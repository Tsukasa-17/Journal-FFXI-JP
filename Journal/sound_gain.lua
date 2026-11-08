-- Volume-scaled WAV cache for Ashita play_sound (path-only API).
-- Bundled originals are never modified. PCM 16-bit LE only.

local M = {}

local cache_dir = nil
local last_volume = nil
local warned = false

-- Cache naming version: bump when the gain curve changes so stale files from
-- an older curve are never reused.
local CURVE_TAG = 'p2'

local KNOWN_SOUNDS = {
    'new_quest', 'new_mission', 'complete_quest', 'complete_mission', 'nearby_quest',
}

-- Perceptual (audio-taper) curve: slider % -> linear amplitude gain.
-- Linear gain made 50% only -6 dB (barely quieter to the ear); squared gives
-- 50% = -12 dB, 25% = -24 dB, 10% = -40 dB.
function M.gain_for(volume)
    volume = math.floor(tonumber(volume) or 100)
    if volume <= 0 then return 0 end
    if volume >= 100 then return 1 end
    local x = volume / 100
    return x * x
end

local function is_windows()
    return package ~= nil and package.config ~= nil and package.config:sub(1, 1) == '\\'
end

local function native(path)
    if is_windows() then
        return (path:gsub('/', '\\'))
    end
    return path
end

local function warn_once(msg)
    if warned then return end
    warned = true
    local ok, enc = pcall(require, 'encoding')
    if ok and type(enc) == 'table' and enc.chat_print ~= nil then
        pcall(enc.chat_print, msg)
    elseif print ~= nil then
        pcall(print, msg)
    end
end

local function addon_base()
    local base = tostring(addon and addon.path or '')
    if base ~= '' and not base:match('[\\/]$') then
        base = base .. '/'
    end
    return base
end

local function ensure_cache_dir()
    if cache_dir ~= nil then
        return cache_dir
    end
    -- Prefer forward slashes; Windows Ashita/fs APIs accept them and Lua io
    -- paths stay consistent across separators from addon.path.
    local base = addon_base():gsub('\\', '/')
    cache_dir = native(base .. 'cache/alert_sounds/')
    if ashita ~= nil and ashita.fs ~= nil and ashita.fs.create_dir ~= nil then
        pcall(ashita.fs.create_dir, native(base .. 'cache'))
        pcall(ashita.fs.create_dir, cache_dir)
    end
    return cache_dir
end

local function read_file(path)
    local f = io.open(path, 'rb')
    if f == nil then
        return nil
    end
    local data = f:read('*a')
    f:close()
    return data
end

local function write_file(path, data)
    local f = io.open(path, 'wb')
    if f == nil then
        return false
    end
    f:write(data)
    f:close()
    return true
end

-- Parse a minimal PCM WAV (RIFF/WAVE/fmt/data). Returns header fields + data offset.
local function parse_wav(buf)
    if type(buf) ~= 'string' or #buf < 44 then
        return nil
    end
    if buf:sub(1, 4) ~= 'RIFF' or buf:sub(9, 12) ~= 'WAVE' then
        return nil
    end

    local pos = 13
    local fmt = nil
    local data_off, data_size = nil, nil

    while pos + 8 <= #buf do
        local id = buf:sub(pos, pos + 3)
        local size = buf:byte(pos + 4)
            + buf:byte(pos + 5) * 256
            + buf:byte(pos + 6) * 65536
            + buf:byte(pos + 7) * 16777216
        local chunk = pos + 8
        if id == 'fmt ' and size >= 16 then
            local audio_format = buf:byte(chunk) + buf:byte(chunk + 1) * 256
            local channels = buf:byte(chunk + 2) + buf:byte(chunk + 3) * 256
            local rate = buf:byte(chunk + 4)
                + buf:byte(chunk + 5) * 256
                + buf:byte(chunk + 6) * 65536
                + buf:byte(chunk + 7) * 16777216
            local bits = buf:byte(chunk + 14) + buf:byte(chunk + 15) * 256
            fmt = {
                format = audio_format,
                channels = channels,
                rate = rate,
                bits = bits,
            }
        elseif id == 'data' then
            data_off = chunk
            data_size = size
            break
        end
        pos = chunk + size
        if size % 2 == 1 then
            pos = pos + 1
        end
    end

    if fmt == nil or data_off == nil then
        return nil
    end
    if fmt.format ~= 1 or fmt.bits ~= 16 then
        return nil
    end
    if data_off + data_size - 1 > #buf then
        data_size = #buf - data_off + 1
    end
    return fmt, data_off, data_size
end

local function scale_pcm16(buf, data_off, data_size, gain)
    local out = { buf:sub(1, data_off - 1) }
    local parts = {}
    local i = data_off
    local last = data_off + data_size - 1
    -- Process in blocks to limit table growth
    local block = {}
    local bn = 0
    while i + 1 <= last do
        local lo, hi = buf:byte(i, i + 1)
        local sample = lo + hi * 256
        if sample >= 32768 then
            sample = sample - 65536
        end
        sample = math.floor(sample * gain + (sample >= 0 and 0.5 or -0.5))
        if sample > 32767 then
            sample = 32767
        elseif sample < -32768 then
            sample = -32768
        end
        if sample < 0 then
            sample = sample + 65536
        end
        bn = bn + 1
        block[bn] = string.char(sample % 256, math.floor(sample / 256) % 256)
        if bn >= 4096 then
            parts[#parts + 1] = table.concat(block)
            block = {}
            bn = 0
        end
        i = i + 2
    end
    if bn > 0 then
        parts[#parts + 1] = table.concat(block)
    end
    -- odd trailing byte
    if i <= last then
        parts[#parts + 1] = buf:sub(i, last)
    end
    out[2] = table.concat(parts)
    if data_off + data_size <= #buf then
        out[3] = buf:sub(data_off + data_size)
    end
    return table.concat(out)
end

local function cache_path_for(src_path, volume)
    local base = src_path:match('([^/\\]+)$') or 'sound.wav'
    local stem = base:gsub('%.[Ww][Aa][Vv]$', '')
    return ensure_cache_dir() .. stem .. '_' .. CURVE_TAG .. '_v' .. tostring(volume) .. '.wav'
end

-- Remove cached files for one volume (plus legacy linear-curve names).
-- Explicit names: ashita.fs.get_dir proved unreliable (old files survived).
function M.clear_cache(volume)
    local dir = ensure_cache_dir()
    for _, stem in ipairs(KNOWN_SOUNDS) do
        if volume ~= nil then
            pcall(os.remove, dir .. stem .. '_' .. CURVE_TAG .. '_v' .. tostring(volume) .. '.wav')
        end
        for v = 1, 99 do
            pcall(os.remove, dir .. stem .. '_v' .. tostring(v) .. '.wav')
        end
    end
end

-- volume: integer 0..100. Returns path to play, or nil to skip (mute / failure).
function M.resolve(src_path, volume)
    volume = math.floor(tonumber(volume) or 100)
    if volume < 0 then volume = 0 end
    if volume > 100 then volume = 100 end

    if volume ~= last_volume then
        -- Drop previous volume's files lazily by clearing whole cache when volume changes.
        if last_volume ~= nil and last_volume ~= volume and last_volume ~= 100 then
            M.clear_cache(last_volume)
        end
        last_volume = volume
    end

    if volume <= 0 then
        return nil
    end
    if volume >= 100 then
        return src_path
    end

    local dest = cache_path_for(src_path, volume)
    if ashita ~= nil and ashita.fs ~= nil and ashita.fs.exists ~= nil then
        if ashita.fs.exists(dest) then
            return dest
        end
    else
        local f = io.open(dest, 'rb')
        if f ~= nil then
            f:close()
            return dest
        end
    end

    -- Fail closed: below 100% never play the full-volume original.
    local buf = read_file(src_path)
    local fmt, data_off, data_size = nil, nil, nil
    if buf ~= nil then
        fmt, data_off, data_size = parse_wav(buf)
    end
    if fmt == nil then
        warn_once('[Journal] 通知音の音量調整に失敗したため、通知音をミュートしました（WAV読込不可）。')
        return nil
    end
    local scaled = scale_pcm16(buf, data_off, data_size, M.gain_for(volume))
    if write_file(dest, scaled) then
        return dest
    end
    warn_once('[Journal] 通知音の音量調整に失敗したため、通知音をミュートしました（cacheフォルダに書き込めません）。')
    return nil
end

-- Pure helper for tests (no ashita).
function M._scale_buffer_for_test(buf, volume)
    volume = math.floor(tonumber(volume) or 100)
    if volume <= 0 then
        return nil
    end
    if volume >= 100 then
        return buf
    end
    local fmt, data_off, data_size = parse_wav(buf)
    if fmt == nil then
        return nil, 'unsupported'
    end
    return scale_pcm16(buf, data_off, data_size, M.gain_for(volume)), fmt
end

function M._parse_wav_for_test(buf)
    return parse_wav(buf)
end

return M
