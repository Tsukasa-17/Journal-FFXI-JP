-- Optional quest-log diagnostic. Off until /journal questdump on.
-- Records 0x056 bitfields (every log type, including ones Journal does not
-- use), 0x055 key items, and 0x05C event numbers. It does not change quest
-- status. Snapshots copy the bytes; later packets do not rewrite them.

local M = {}

local enabled = false
local watch = false
local installed = false
local latest = {}
local snaps = {}
local counts_on = {}
local counts_snap = {}
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

local function read_i32(data, offset)
    local value = read_u32(data, offset)
    if value == nil then
        return nil
    end
    if value >= 0x80000000 then
        return value - 0x100000000
    end
    return value
end

local function slash(path)
    return tostring(path or ''):gsub('\\', '/'):gsub('/+$', '')
end

local function copy_logs(src)
    local out = {}
    for key, value in pairs(src) do
        -- A new string, so a later packet cannot change this snapshot.
        out[key] = value:sub(1, -1)
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

local function chat(text)
    local ok, enc = pcall(require, 'encoding')
    if ok and type(enc) == 'table' and enc.chat_print ~= nil then
        pcall(enc.chat_print, text)
    end
end

function M.is_enabled()
    return enabled
end

function M.is_watching()
    return watch
end

function M.set_enabled(on)
    on = on == true
    if on and not enabled then
        latest = {}
        counts_on = {}
        counts_snap = {}
    end
    enabled = on
    if not enabled then
        watch = false
    end
    return enabled
end

function M.reset()
    enabled = false
    watch = false
    latest = {}
    snaps = {}
    counts_on = {}
    counts_snap = {}
end

local function note_packet(id)
    counts_on[id] = (counts_on[id] or 0) + 1
    counts_snap[id] = (counts_snap[id] or 0) + 1
end

local function store(key, bytes)
    local previous = latest[key]
    latest[key] = bytes
    return previous
end

local function watch_bits(header, previous, fresh)
    if not watch then
        return
    end
    local changes = {}
    each_diff(previous, fresh, function(bit, on)
        changes[#changes + 1] = string.format(
            'ビット %d %s',
            bit,
            on and 'オン' or 'オフ'
        )
    end)
    if #changes == 0 then
        chat('[Journal] ' .. header .. ' 受信（変化なし）')
        return
    end
    if #changes <= 8 then
        chat('[Journal] ' .. header .. ' 受信: ' .. table.concat(changes, '、'))
        return
    end
    chat(string.format('[Journal] %s 受信（%d ビット変化）', header, #changes))
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
        local key = string.format('056:%08X', packet_type)
        local fresh = data:sub(0x05, 0x04 + 32)
        local previous = store(key, fresh)
        watch_bits(string.format('0x056 種別 0x%08X', packet_type), previous, fresh)
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
        local suffix = string.format('%04X', table_index)
        local got = data:sub(0x05, 0x04 + 64)
        local seen = data:sub(0x45, 0x44 + 64)
        local previous_got = store('055:get:' .. suffix, got)
        local previous_seen = store('055:look:' .. suffix, seen)
        watch_bits(
            string.format('0x055 テーブル %d 入手', table_index),
            previous_got,
            got
        )
        watch_bits(
            string.format('0x055 テーブル %d 確認', table_index),
            previous_seen,
            seen
        )
        return true
    end

    if id == 0x05C then
        -- GP_SERV_COMMAND_PENDINGNUM: eight event numbers at 0x04.
        if #data < 0x24 then
            return false
        end
        local fresh = data:sub(0x05, 0x04 + 32)
        local previous = store('05C', fresh)
        if watch then
            local parts = {}
            for index = 0, 7 do
                local now = read_i32(fresh, index * 4)
                local was = previous and read_i32(previous, index * 4) or 0
                if previous == nil or was ~= now then
                    parts[#parts + 1] = string.format('%d=%s', index, tostring(now))
                end
            end
            if #parts == 0 then
                chat('[Journal] 0x05C 受信（変化なし）')
            else
                chat('[Journal] 0x05C 受信: ' .. table.concat(parts, ' '))
            end
        end
        return true
    end

    return false
end

function M.on_packet(e)
    if not enabled or type(e) ~= 'table' or type(e.id) ~= 'number' then
        return
    end
    note_packet(e.id)
    if e.id == 0x056 or e.id == 0x055 or e.id == 0x05C then
        M.ingest(e.id, e.data)
    end
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

function M.activity_lines(had_snap)
    local function n(map, id)
        return map[id] or 0
    end
    local lines = {
        string.format(
            '[Journal] 0x056 は開始から %d、前回の snap から %d。0x055 は開始から %d、前回から %d。0x05C は開始から %d、前回から %d。',
            n(counts_on, 0x056), n(counts_snap, 0x056),
            n(counts_on, 0x055), n(counts_snap, 0x055),
            n(counts_on, 0x05C), n(counts_snap, 0x05C)
        ),
    }
    if had_snap and n(counts_snap, 0x056) == 0 then
        lines[#lines + 1] = '[Journal] 前回の snap のあと、クエストログ（0x056）は届いていません。'
    end
    local ids = {}
    for id in pairs(counts_snap) do
        ids[#ids + 1] = id
    end
    table.sort(ids)
    if #ids == 0 then
        lines[#lines + 1] = '[Journal] 前回の snap のあと、パケットは届いていません。'
        return lines
    end
    local parts = {}
    local limit = math.min(#ids, 16)
    for index = 1, limit do
        local id = ids[index]
        parts[#parts + 1] = string.format('0x%03X x%d', id, counts_snap[id])
    end
    local extra = ''
    if #ids > limit then
        extra = string.format(' ほか %d 種', #ids - limit)
    end
    lines[#lines + 1] = '[Journal] 前回から届いたパケット: ' .. table.concat(parts, ' ') .. extra
    return lines
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

local function number_lines(left_bytes, right_bytes)
    local lines = {}
    for index = 0, 7 do
        local was = left_bytes and read_i32(left_bytes, index * 4) or 0
        local now = right_bytes and read_i32(right_bytes, index * 4) or 0
        if was ~= now then
            lines[#lines + 1] = string.format(
                '0x05C 数値 %d: %s → %s',
                index, tostring(was), tostring(now)
            )
        end
    end
    return lines
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
        if key == '05C' then
            local extra = number_lines(left.logs[key], right.logs[key])
            for _, line in ipairs(extra) do
                lines[#lines + 1] = line
            end
        else
            each_diff(left.logs[key], right.logs[key], function(bit, on)
                lines[#lines + 1] = line_for(key, bit, on)
            end)
        end
    end

    return {
        left = left.name,
        right = right.name,
        lines = lines,
    }
end

function M.candidate_dirs()
    local dirs = {}
    local seen = {}
    local function add(dir)
        dir = slash(dir)
        if dir ~= '' and not seen[dir] then
            seen[dir] = true
            dirs[#dirs + 1] = dir
        end
    end
    local name = addon and addon.name or 'Journal'
    if AshitaCore ~= nil and AshitaCore.GetInstallPath ~= nil then
        local ok, install = pcall(function()
            return AshitaCore:GetInstallPath()
        end)
        if ok and type(install) == 'string' and install ~= '' then
            add(slash(install) .. '/config/addons/' .. name)
        end
    end
    if addon ~= nil and addon.path ~= nil then
        local path = slash(addon.path)
        -- .../Vanacore/addons/vanacore/Journal -> .../Vanacore
        local root = path:match('^(.*)/addons/')
        if root ~= nil and root ~= '' then
            add(root .. '/config/addons/' .. name)
        end
        add(path)
    end
    return dirs
end

function M.config_dir()
    local dirs = M.candidate_dirs()
    return dirs[1]
end

local function ensure_dir(dir)
    local norm = slash(dir)
    if norm == '' then
        return false, 'パスが空です'
    end
    local built = ''
    local index = 1
    if norm:match('^%a:') then
        built = norm:sub(1, 2)
        index = 3
    end
    while index <= #norm do
        local found = norm:find('/', index, true)
        local part
        if found == nil then
            part = norm:sub(index)
            index = #norm + 1
        else
            part = norm:sub(index, found - 1)
            index = found + 1
        end
        if part ~= '' then
            if built == '' then
                built = '/' .. part
            else
                built = built .. '/' .. part
            end
            if ashita ~= nil and ashita.fs ~= nil and ashita.fs.create_dir ~= nil then
                pcall(ashita.fs.create_dir, built)
                pcall(ashita.fs.create_dir, built:gsub('/', '\\'))
            end
        end
    end
    return true
end

local function display_path(path)
    if path:match('^%a:') then
        return path:gsub('/', '\\')
    end
    return path
end

function M.write_report(text, dirs)
    if type(text) ~= 'string' then
        return nil, '書く内容がありません'
    end
    if type(dirs) ~= 'table' then
        dirs = M.candidate_dirs()
    end
    if #dirs == 0 then
        return nil, '保存先を決められませんでした（addon.path がありません）'
    end
    local errors = {}
    for _, dir in ipairs(dirs) do
        ensure_dir(dir)
        local path = slash(dir) .. '/questdump.txt'
        local file, err = io.open(path, 'a')
        if file == nil and path:match('^%a:') then
            file, err = io.open(path:gsub('/', '\\'), 'a')
        end
        if file ~= nil then
            local ok, write_err = pcall(function()
                file:write(text)
                if text:sub(-1) ~= '\n' then
                    file:write('\n')
                end
                file:close()
            end)
            if ok then
                local note = nil
                if #errors > 0 then
                    note = table.concat(errors, ' / ')
                end
                return display_path(path), nil, note
            end
            errors[#errors + 1] = display_path(path) .. '（' .. tostring(write_err) .. '）'
        else
            errors[#errors + 1] = display_path(path) .. '（' .. tostring(err or '開けません') .. '）'
        end
    end
    return nil, table.concat(errors, ' / ')
end

local function say(text, lines)
    lines[#lines + 1] = text
    chat(text)
end

local function usage(lines)
    say('[Journal] クエストログの調査です。普段はオフで、表示には影響しません。', lines)
    say('/journal questdump on で記録を開始します。届いたパケットはその場で覚えます。', lines)
    say('エリアを移動してから /journal questdump snap before', lines)
    say('受注したあと /journal questdump snap after', lines)
    say('終わったあと /journal questdump snap done', lines)
    say('/journal questdump diff before after で変わったビットを出します。', lines)
    say('/journal questdump watch で、0x056・0x055・0x05C が届くたびにチャットへ出します。', lines)
    say('保存先は config/addons/Journal/questdump.txt です。だめなときはアドオンフォルダです。', lines)
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
    body[#body + 1] = '0x05C はイベント用の数値 8 個です。'
    if #result.lines == 0 then
        body[#body + 1] = '変化はありません。'
    end
    for _, line in ipairs(result.lines) do
        body[#body + 1] = line
    end
    body[#body + 1] = ''

    local path, err, note = M.write_report(table.concat(body, '\n'))
    if path ~= nil then
        say('[Journal] 保存しました: ' .. path, lines)
        if note ~= nil then
            say('[Journal] 先に試した場所は失敗しました: ' .. note, lines)
        end
    else
        say('[Journal] ファイルには保存できませんでした: ' .. tostring(err), lines)
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

    if sub == 'watch' then
        if not enabled then
            M.set_enabled(true)
        end
        watch = not watch
        if watch then
            say('[Journal] 届いた 0x056・0x055・0x05C をその場で出します。ゾーン移動では多く出ます。', lines)
        else
            say('[Journal] その場の表示を止めました。記録は続きます。', lines)
        end
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
        local had_snap = #snaps > 0
        local activity = M.activity_lines(had_snap)
        local count = M.snapshot(name)
        counts_snap = {}
        say(string.format(
            '[Journal] スナップショット「%s」を取りました（%d 種類）。',
            name, count
        ), lines)
        for _, line in ipairs(activity) do
            say(line, lines)
        end
        if count == 0 then
            say('[Journal] まだ 0x056 / 0x055 / 0x05C を受け取っていません。', lines)
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
