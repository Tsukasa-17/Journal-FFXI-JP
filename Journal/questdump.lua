-- Optional quest-log diagnostic. Off until /journal questdump on.
-- Records 0x056 bitfields (every log type, including ones Journal does not
-- use, and the mission packets that share this packet) and 0x055 key items.
-- It does not change quest status.

local M = {}

local enabled = false
local installed = false
local latest = {}
local snaps = {}
local CHAT_MAX = 20

local function read_u16(data, offset)
    local b1, b2 = data:byte(offset + 1, offset + 2)
    if b1 == nil or b2 == nil then
        return nil
    end
    return b1 + b2 * 0x100
end

local function read_u32(data, offset)
    local b1, b2, b3, b4 = data:byte(offset + 1, offset + 4)
    if b1 == nil or b2 == nil or b3 == nil or b4 == nil then
        return nil
    end
    return b1 + b2 * 0x100 + b3 * 0x10000 + b4 * 0x1000000
end

local function copy_logs(src)
    local out = {}
    for key, value in pairs(src) do
        out[key] = value
    end
    return out
end

local function bit_on(byte, bit)
    local mask = 2 ^ bit
    return byte % (mask * 2) >= mask
end

-- Bit 0 is the low bit of the first byte, matching tracker_id.
local function each_diff(before, after, emit)
    local n = math.max(before and #before or 0, after and #after or 0)
    for index = 0, n - 1 do
        local old = before and before:byte(index + 1) or 0
        local new = after and after:byte(index + 1) or 0
        if old ~= new then
            for bit = 0, 7 do
                local was = bit_on(old, bit)
                local now = bit_on(new, bit)
                if was ~= now then
                    emit(index * 8 + bit, now)
                end
            end
        end
    end
end

function M.is_enabled()
    return enabled
end

function M.set_enabled(on)
    enabled = on == true
    return enabled
end

function M.reset()
    enabled = false
    latest = {}
    snaps = {}
end

function M.ingest(id, data)
    if not enabled or type(data) ~= 'string' then
        return false
    end

    if id == 0x056 then
        if #data < 0x28 then
            return false
        end
        local packet_type = read_u32(data, 0x24)
        if packet_type == nil then
            return false
        end
        latest[string.format('056:%08X', packet_type)] = data:sub(0x05, 0x04 + 32)
        return true
    end

    if id == 0x055 then
        -- GP_SERV_COMMAND_SCENARIOITEM: obtained bits at 0x04, seen bits
        -- at 0x44, table index at 0x84.
        if #data < 0x86 then
            return false
        end
        local table_index = read_u16(data, 0x84)
        if table_index == nil then
            return false
        end
        local key = string.format('%04X', table_index)
        latest['055:get:' .. key] = data:sub(0x05, 0x04 + 64)
        latest['055:look:' .. key] = data:sub(0x45, 0x44 + 64)
        return true
    end

    return false
end

function M.on_packet(e)
    if not enabled or type(e) ~= 'table' then
        return
    end
    if e.id ~= 0x056 and e.id ~= 0x055 then
        return
    end
    M.ingest(e.id, e.data)
end

function M.install()
    if installed then
        return
    end
    if ashita == nil or ashita.events == nil or ashita.events.register == nil then
        return
    end
    installed = true
    ashita.events.register('packet_in', 'journal_questdump_packet_in', function(e)
        if not enabled then
            return
        end
        pcall(M.on_packet, e)
    end)
end

function M.snapshot(name)
    snaps[#snaps + 1] = {
        name = name,
        logs = copy_logs(latest),
    }
    local count = 0
    for _ in pairs(latest) do
        count = count + 1
    end
    return count
end

function M.snap_count()
    return #snaps
end

local function find_snap(name, fallback_index)
    if name ~= nil and name ~= '' then
        for index = #snaps, 1, -1 do
            if snaps[index].name == name then
                return snaps[index]
            end
        end
        return nil
    end
    return snaps[fallback_index]
end

local function line_for(key, bit, on)
    local before_word = on and 'オフ' or 'オン'
    local after_word = on and 'オン' or 'オフ'
    local log_type = key:match('^056:(%x+)$')
    if log_type ~= nil then
        return string.format(
            '0x056 種別 0x%s ビット %d: %s → %s',
            log_type, bit, before_word, after_word
        )
    end
    local which, table_hex = key:match('^055:([^:]+):(%x+)$')
    if which == 'get' or which == 'look' then
        local label = which == 'look' and '確認ビット' or '入手ビット'
        return string.format(
            '0x055 テーブル %d %s %d: %s → %s',
            tonumber(table_hex, 16) or 0,
            label,
            bit,
            before_word,
            after_word
        )
    end
    return string.format('%s ビット %d: %s → %s', key, bit, before_word, after_word)
end

function M.changes(name_a, name_b)
    local left = find_snap(name_a, #snaps - 1)
    local right = find_snap(name_b, #snaps)
    if name_a ~= nil and name_a ~= '' and find_snap(name_a, 0) == nil then
        return nil, 'スナップショット「' .. tostring(name_a) .. '」がありません。'
    end
    if name_b ~= nil and name_b ~= '' and find_snap(name_b, 0) == nil then
        return nil, 'スナップショット「' .. tostring(name_b) .. '」がありません。'
    end
    if left == nil or right == nil or left == right then
        return nil, '比べるにはスナップショットが2つ必要です。受注前と後で snap してください。'
    end

    local keys = {}
    local seen = {}
    for key in pairs(left.logs) do
        seen[key] = true
        keys[#keys + 1] = key
    end
    for key in pairs(right.logs) do
        if not seen[key] then
            keys[#keys + 1] = key
        end
    end
    table.sort(keys)

    local lines = {}
    for _, key in ipairs(keys) do
        each_diff(left.logs[key], right.logs[key], function(bit, on)
            lines[#lines + 1] = line_for(key, bit, on)
        end)
    end

    return {
        left = left.name,
        right = right.name,
        lines = lines,
    }
end

function M.config_dir()
    if addon == nil or addon.path == nil then
        return nil
    end
    local path = tostring(addon.path):gsub('\\', '/')
    path = path:gsub('/+$', '')
    local root = path:gsub('/addons/[^/]+$', '')
    if root == '' or root == path then
        return nil
    end
    return root .. '/config/addons/' .. tostring(addon.name or 'Journal')
end

function M.write_report(dir, text)
    if type(dir) ~= 'string' or dir == '' or type(text) ~= 'string' then
        return nil
    end
    if ashita ~= nil and ashita.fs ~= nil and ashita.fs.create_dir ~= nil then
        local parent = dir:gsub('\\', '/'):gsub('/+$', ''):gsub('/[^/]+$', '')
        local grand = parent:gsub('/[^/]+$', '')
        pcall(ashita.fs.create_dir, grand)
        pcall(ashita.fs.create_dir, parent)
        pcall(ashita.fs.create_dir, dir)
    end
    local path = dir:gsub('\\', '/'):gsub('/+$', '') .. '/questdump.txt'
    local file = io.open(path, 'a')
    if file == nil then
        file = io.open(path, 'w')
    end
    if file == nil then
        return nil
    end
    file:write(text)
    if text:sub(-1) ~= '\n' then
        file:write('\n')
    end
    file:close()
    return path
end

local function say(text, lines)
    lines[#lines + 1] = text
    local ok, enc = pcall(require, 'encoding')
    if ok and type(enc) == 'table' and enc.chat_print ~= nil then
        pcall(enc.chat_print, text)
    end
end

local function usage(lines)
    say('[Journal] クエストログの調査です。普段はオフで、表示には影響しません。', lines)
    say('/journal questdump on で記録を開始します。', lines)
    say('エリアを移動してから /journal questdump snap before', lines)
    say('受注したあと /journal questdump snap after', lines)
    say('終わったあと /journal questdump snap done', lines)
    say('/journal questdump diff before after で変わったビットを出します。', lines)
    say('結果はチャットと、Ashita の config/addons/Journal/questdump.txt に残ります。', lines)
    say('/journal questdump off で記録を止めます。', lines)
end

local function publish(result, lines)
    say(string.format(
        '[Journal] %s → %s の差は %d 件です。',
        result.left, result.right, #result.lines
    ), lines)
    if #result.lines == 0 then
        say('[Journal] クエストログにもキーアイテムにも変化はありません。', lines)
    end
    local shown = math.min(#result.lines, CHAT_MAX)
    for index = 1, shown do
        say('[Journal] ' .. result.lines[index], lines)
    end
    if #result.lines > CHAT_MAX then
        say(string.format(
            '[Journal] ほか %d 件はファイルに書きました。',
            #result.lines - CHAT_MAX
        ), lines)
    end

    local body = {}
    body[#body + 1] = os.date('!%Y-%m-%d %H:%M:%S UTC')
    body[#body + 1] = result.left .. ' → ' .. result.right
    body[#body + 1] = 'ビット番号は 0 始まりです。0x056 はパケットの 0x04 からで、tracker_id と同じ数え方です。'
    body[#body + 1] = '0x055 はキーアイテムです。入手ビットは持っているもの、確認ビットは中身を見たものです。'
    body[#body + 1] = '数値が入っているパケットは、複数のビットが同時に変わることがあります。'
    if #result.lines == 0 then
        body[#body + 1] = '変化はありません。'
    end
    for _, line in ipairs(result.lines) do
        body[#body + 1] = line
    end
    body[#body + 1] = ''

    local path = M.write_report(M.config_dir(), table.concat(body, '\n'))
    if path ~= nil then
        say('[Journal] 保存しました: ' .. path, lines)
    else
        say('[Journal] ファイルには保存できませんでした。チャットの内容を控えてください。', lines)
    end
end

function M.handle(args)
    local lines = {}
    local sub = args and args[3] and tostring(args[3]):lower() or 'help'
    local first = args and args[4]
    local second = args and args[5]

    if sub == 'on' then
        M.set_enabled(true)
        say('[Journal] 記録を開始しました。エリアを移動してから、受注前に snap してください。', lines)
        return lines
    end

    if sub == 'off' then
        M.set_enabled(false)
        say('[Journal] 記録を止めました。取ったスナップショットは残っています。', lines)
        return lines
    end

    if sub == 'snap' or sub == 'snapshot' then
        if not enabled then
            say('[Journal] 記録はオフです。先に /journal questdump on してください。', lines)
            return lines
        end
        local name = first and tostring(first) or ('snap' .. (#snaps + 1))
        name = name:gsub('[%c\\/]', ''):sub(1, 40)
        if name == '' then
            name = 'snap' .. (#snaps + 1)
        end
        local count = M.snapshot(name)
        say(string.format(
            '[Journal] スナップショット「%s」を取りました（%d 種類）。',
            name, count
        ), lines)
        if count == 0 then
            say('[Journal] まだパケットが届いていません。エリアを移動してから、もう一度 snap してください。', lines)
        end
        return lines
    end

    if sub == 'diff' then
        local result, err = M.changes(first, second)
        if result == nil then
            say('[Journal] ' .. err, lines)
            return lines
        end
        publish(result, lines)
        return lines
    end

    usage(lines)
    return lines
end

return M
