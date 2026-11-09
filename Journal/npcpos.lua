-- /journal npcpos writes the targeted NPC in the npc_positions.lua shape.
-- The custom file outside the addon is merged into the compass positions.

local M = {}

local function slash(path)
    return tostring(path or ''):gsub('\\', '/'):gsub('/+$', '')
end

local function display_path(path)
    if path:match('^%a:') then
        return path:gsub('/', '\\')
    end
    return path
end

local function config_dir()
    local dirs = require('questdump').candidate_dirs()

    for _, dir in ipairs(dirs) do
        if not dir:find('/addons/', 1, true) or dir:find('/config/addons/', 1, true) then
            return dir
        end
    end

    return dirs[1]
end

local function ensure_dir(dir)
    local norm = slash(dir)
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
end

function M.format_entry(name, zone, x, y, height)
    return string.format(
        '[%q] = { { %d, %.2f, %.2f, %.2f } },',
        tostring(name),
        tonumber(zone) or 0,
        tonumber(x) or 0,
        tonumber(y) or 0,
        tonumber(height) or 0
    )
end

function M.append_capture(name, zone, x, y, height, zone_name)
    local dir = config_dir()

    if dir == nil then
        return nil, '保存先を決められませんでした'
    end

    ensure_dir(dir)
    local log_path = slash(dir) .. '/npcpos.txt'
    local custom_path = slash(dir) .. '/npc_positions_custom.lua'
    local line = M.format_entry(name, zone, x, y, height)
    local log = io.open(log_path, 'a')

    if log == nil and log_path:match('^%a:') then
        log = io.open(log_path:gsub('/', '\\'), 'a')
    end

    if log == nil then
        return nil, 'npcpos.txt を開けませんでした: ' .. display_path(log_path)
    end

    log:write(string.format(
        '-- %s zone %s %s\n%s\n',
        os.date('!%Y-%m-%d %H:%M:%S UTC'),
        tostring(zone),
        tostring(zone_name or ''),
        line
    ))
    log:close()

    local data = {}
    local chunk = loadfile(custom_path)

    if chunk ~= nil then
        local ok, loaded = pcall(chunk)

        if ok and type(loaded) == 'table' then
            data = loaded
        end
    end

    local rows = data[name]

    if type(rows) ~= 'table' then
        rows = {}
        data[name] = rows
    end

    local zone_id = tonumber(zone) or 0
    local replaced = false

    for index, entry in ipairs(rows) do
        if type(entry) == 'table' and entry[1] == zone_id then
            rows[index] = { zone_id, x, y, height }
            replaced = true
            break
        end
    end

    if not replaced then
        rows[#rows + 1] = { zone_id, x, y, height }
    end

    local names = {}

    for key in pairs(data) do
        if type(data[key]) == 'table' then
            names[#names + 1] = key
        end
    end

    table.sort(names)
    local body = { 'return {' }

    for _, key in ipairs(names) do
        local parts = {}

        for _, entry in ipairs(data[key]) do
            if type(entry) == 'table' then
                parts[#parts + 1] = string.format(
                    '{ %d, %.2f, %.2f, %.2f }',
                    tonumber(entry[1]) or 0,
                    tonumber(entry[2]) or 0,
                    tonumber(entry[3]) or 0,
                    tonumber(entry[4]) or 0
                )
            end
        end

        body[#body + 1] = string.format('    [%q] = { %s },', key, table.concat(parts, ', '))
    end

    body[#body + 1] = '}'
    body[#body + 1] = ''
    local custom = io.open(custom_path, 'w')

    if custom == nil and custom_path:match('^%a:') then
        custom = io.open(custom_path:gsub('/', '\\'), 'w')
    end

    if custom ~= nil then
        custom:write(table.concat(body, '\n'))
        custom:close()
    end

    return display_path(log_path), display_path(custom_path)
end

local function player_index(party)
    local ok, index = pcall(function()
        return party:GetMemberTargetIndex(0)
    end)

    if ok then
        return tonumber(index)
    end

    return nil
end

local function target_index(target)
    for _, name in ipairs({ 'GetTargetIndex', 'GetIndex' }) do
        if target[name] ~= nil then
            local ok, index = pcall(function()
                return target[name](target, 0)
            end)

            if (not ok or index == nil) then
                ok, index = pcall(function()
                    return target[name](target)
                end)
            end

            index = ok and tonumber(index) or nil

            if index ~= nil and index > 0 then
                return index
            end
        end
    end

    return nil
end

function M.capture()
    if AshitaCore == nil then
        return nil, 'この環境では NPC の座標を読めません'
    end

    local ok, memory = pcall(function()
        return AshitaCore:GetMemoryManager()
    end)

    if not ok or memory == nil then
        return nil, 'メモリを読めません'
    end

    local entity = memory:GetEntity()
    local party = memory:GetParty()
    local mine = player_index(party)
    local index = nil
    local target_ok, target = pcall(function()
        return memory:GetTarget()
    end)

    if target_ok and target ~= nil then
        index = target_index(target)
    end

    local function named(i)
        local name_ok, name = pcall(function()
            return entity:GetName(i)
        end)

        if name_ok and type(name) == 'string' and name ~= '' and i ~= mine then
            return name
        end

        return nil
    end

    if index == nil or named(index) == nil then
        local me_x, me_y

        if mine ~= nil then
            pcall(function()
                me_x = entity:GetLocalPositionX(mine)
                me_y = entity:GetLocalPositionY(mine)
            end)
        end

        local best, best_d

        for i = 0, 0x8FF do
            local name = named(i)

            if name ~= nil then
                local x_ok, x = pcall(function()
                    return entity:GetLocalPositionX(i)
                end)
                local y_ok, y = pcall(function()
                    return entity:GetLocalPositionY(i)
                end)

                if x_ok and y_ok and x ~= nil and y ~= nil then
                    local dx = me_x and (x - me_x) or 0
                    local dy = me_y and (y - me_y) or 0
                    local d2 = dx * dx + dy * dy

                    if best == nil or d2 < best_d then
                        best = i
                        best_d = d2
                    end
                end
            end
        end

        index = best
    end

    local name = index and named(index) or nil

    if name == nil then
        return nil, '名前のある NPC が見つかりません。対象を選んでからもう一度。'
    end

    local x = entity:GetLocalPositionX(index)
    local y = entity:GetLocalPositionY(index)
    local height = entity:GetLocalPositionZ(index)
    local zone = party:GetMemberZone(0)
    local zone_name = nil
    pcall(function()
        zone_name = AshitaCore:GetResourceManager():GetString('zones.names', zone)
    end)

    local log_path, custom_path = M.append_capture(name, zone, x, y, height, zone_name)

    if log_path == nil then
        return nil, custom_path
    end

    pcall(function()
        require('compass').AddPosition(name, {
            tonumber(zone) or 0, x or 0, y or 0, height or 0,
        })
    end)

    return {
        name = name,
        zone = zone,
        x = x,
        y = y,
        height = height,
        log_path = log_path,
        custom_path = custom_path,
        line = M.format_entry(name, zone, x, y, height),
    }
end

return M
