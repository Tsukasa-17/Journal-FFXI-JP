-- Minimal Shift-JIS <-> UTF-8 helpers for Ashita resource strings.
-- Uses Win32 MultiByteToWideChar / WideCharToMultiByte (CP932 / CP65001).

local ffi = require('ffi')

local M = {}

-- Idempotent cdef: LuaJIT errors on duplicate declarations; swallow that.
if not _G.__journal_encoding_ffi_defined then
    local ok = pcall(function()
        ffi.cdef[[
            int MultiByteToWideChar(unsigned int CodePage, unsigned long dwFlags, const char* lpMultiByteStr, int cbMultiByte, wchar_t* lpWideCharStr, int cchWideChar);
            int WideCharToMultiByte(unsigned int CodePage, unsigned long dwFlags, const wchar_t* lpWideCharStr, int cchWideChar, char* lpMultiByteStr, int cbMultiByte, const char* lpDefaultChar, int* lpUsedDefaultChar);
        ]]
    end)
    _G.__journal_encoding_ffi_defined = true
    M._cdef_ok = ok and true or true -- presence of APIs verified at call time
else
    M._cdef_ok = true
end

local CP_UTF8 = 65001
local CP_SJIS = 932
local cache = {}

local function convert(input, from_cp, to_cp, use_cache)
    input = tostring(input or '')
    if input == '' then
        return input
    end

    local key = from_cp .. '>' .. to_cp .. '|' .. input
    if use_cache and cache[key] ~= nil then
        return cache[key]
    end

    local ok, result = pcall(function()
        local src_len = #input
        local cbuf = ffi.new('char[?]', src_len + 1)
        ffi.copy(cbuf, input)

        local wlen = ffi.C.MultiByteToWideChar(from_cp, 0, cbuf, -1, nil, 0)
        if wlen <= 0 then
            return input
        end

        local wbuf = ffi.new('wchar_t[?]', wlen)
        ffi.C.MultiByteToWideChar(from_cp, 0, cbuf, -1, wbuf, wlen)

        local clen = ffi.C.WideCharToMultiByte(to_cp, 0, wbuf, -1, nil, 0, nil, nil)
        if clen <= 0 then
            return input
        end

        local out = ffi.new('char[?]', clen)
        ffi.C.WideCharToMultiByte(to_cp, 0, wbuf, -1, out, clen, nil, nil)
        return ffi.string(out)
    end)

    if not ok or type(result) ~= 'string' then
        return input
    end

    if use_cache then
        cache[key] = result
    end

    return result
end

function M.shiftjis_to_utf8(input, use_cache)
    return convert(input, CP_SJIS, CP_UTF8, use_cache ~= false)
end

function M.utf8_to_shiftjis(input, use_cache)
    return convert(input, CP_UTF8, CP_SJIS, use_cache ~= false)
end

function M.clear_cache()
    cache = {}
end


-- Ashita chat/print expects CP932 (Shift-JIS). ImGui/Meiryo UI stays UTF-8.
-- Convert only at the chat boundary; ASCII and EN/ES (no CJK) pass through.

local function is_ascii(s)
    for i = 1, #s do
        if s:byte(i) >= 128 then
            return false
        end
    end
    return true
end

-- True when the string contains UTF-8 CJK / kana / fullwidth (not Latin-1 accents).
local function has_cjk_utf8(s)
    local i = 1
    local n = #s
    while i <= n do
        local c = s:byte(i)
        if c < 128 then
            i = i + 1
        elseif c >= 224 and c <= 239 and i + 2 <= n then
            local c2, c3 = s:byte(i + 1), s:byte(i + 2)
            if c2 and c3 and c2 >= 128 and c2 <= 191 and c3 >= 128 and c3 <= 191 then
                local cp = (c - 224) * 4096 + (c2 - 128) * 64 + (c3 - 128)
                if (cp >= 0x3000 and cp <= 0x30FF)
                    or (cp >= 0x31F0 and cp <= 0x31FF)
                    or (cp >= 0x3400 and cp <= 0x4DBF)
                    or (cp >= 0x4E00 and cp <= 0x9FFF)
                    or (cp >= 0xF900 and cp <= 0xFAFF)
                    or (cp >= 0xFF00 and cp <= 0xFFEF) then
                    return true
                end
            end
            i = i + 3
        elseif c >= 240 and i + 3 <= n then
            i = i + 4
        elseif c >= 192 and i + 1 <= n then
            i = i + 2
        else
            i = i + 1
        end
    end
    return false
end

local function ascii_diagnostic(s)
    -- Prefer an explicit readable ASCII line over mojibake.
    local out = {}
    local i = 1
    local n = #s
    while i <= n do
        local c = s:byte(i)
        if c < 128 then
            out[#out + 1] = string.char(c)
            i = i + 1
        elseif c >= 224 and i + 2 <= n then
            out[#out + 1] = '?'
            i = i + 3
        elseif c >= 192 and i + 1 <= n then
            out[#out + 1] = '?'
            i = i + 2
        else
            out[#out + 1] = '?'
            i = i + 1
        end
    end
    local text = table.concat(out)
    if text:find('%?') then
        return text .. ' [JP chat: CP932 convert failed]'
    end
    return text
end

-- Preserve Ashita auto-translate / color control bytes (0x1E..0x1F runs) by
-- converting only UTF-8 text segments between them.
local function convert_preserving_controls(s)
    local parts = {}
    local i = 1
    local n = #s
    local buf = {}
    local function flush()
        if #buf == 0 then
            return
        end
        local chunk = table.concat(buf)
        buf = {}
        if is_ascii(chunk) or not has_cjk_utf8(chunk) then
            parts[#parts + 1] = chunk
            return
        end
        local converted = M.utf8_to_shiftjis(chunk, true)
        if type(converted) ~= 'string' or converted == '' then
            parts[#parts + 1] = ascii_diagnostic(chunk)
            return
        end
        -- Failure path in convert() returns the original UTF-8 input.
        if converted == chunk then
            parts[#parts + 1] = ascii_diagnostic(chunk)
            return
        end
        parts[#parts + 1] = converted
    end
    while i <= n do
        local c = s:byte(i)
        if c == 0x1E or c == 0x1F then
            flush()
            parts[#parts + 1] = string.char(c)
            i = i + 1
            if i <= n then
                parts[#parts + 1] = string.char(s:byte(i))
                i = i + 1
            end
        else
            buf[#buf + 1] = string.char(c)
            i = i + 1
        end
    end
    flush()
    return table.concat(parts)
end

function M.to_chat(text)
    text = tostring(text or '')
    if text == '' or is_ascii(text) then
        return text
    end
    if not has_cjk_utf8(text) then
        -- EN/ES (including Latin accents): keep current UTF-8 behavior.
        return text
    end
    return convert_preserving_controls(text)
end

function M.chat_print(...)
    local n = select('#', ...)
    if n == 0 then
        print()
        return
    end
    local parts = {}
    for i = 1, n do
        parts[i] = M.to_chat(tostring(select(i, ...)))
    end
    -- Match Lua print: join with tabs.
    print(table.concat(parts, '\t'))
end


return M
