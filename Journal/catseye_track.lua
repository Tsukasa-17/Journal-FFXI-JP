-- Progress for CatsEye quests, which never appear in the 0x056 quest log.
-- A chat line "Quest Accepted: Name" marks the quest active. A completion
-- line listed on the quest marks it completed, and only while it is active.
-- The table is kept by the caller (the per-character settings).

local M = {}

local state = {}
local quests = {}
local by_name = {}

local function norm(name)
    return tostring(name or ''):lower():gsub('^%s+', ''):gsub('%s+$', '')
end

local function plain(text)
    text = tostring(text or ''):gsub('[%z\1-\31]', '')
    text = text:gsub('^%s+', ''):gsub('%s+$', '')
    text = text:gsub('^[^%w\128-\255]+', '')
    return text
end

function M.set_quests(list)
    quests = {}
    by_name = {}

    for _, quest in ipairs(list or {}) do
        if type(quest) == 'table' and type(quest.name) == 'string' then
            quests[#quests + 1] = quest
            by_name[norm(quest.name)] = quest
        end
    end
end

function M.reset()
    state = {}
end

function M.import(saved)
    state = {}

    if type(saved) ~= 'table' then
        return
    end

    for key, row in pairs(saved) do
        if type(key) == 'string' and type(row) == 'table'
            and (row.status == 'active' or row.status == 'completed'
                or row.status == 'not_started') then

            state[norm(key)] = {
                name = type(row.name) == 'string' and row.name or key,
                status = row.status,
            }
        end
    end
end

function M.export()
    local saved = {}

    for key, row in pairs(state) do
        saved[key] = { name = row.name, status = row.status }
    end

    return saved
end

function M.status_for(quest)
    if type(quest) ~= 'table' then
        return 'not_started'
    end

    local row = state[norm(quest.name)]

    if row == nil then
        return 'not_started'
    end

    return row.status or 'not_started'
end

function M.set_status(quest, status)
    if type(quest) ~= 'table' or type(quest.name) ~= 'string' then
        return false
    end

    if status ~= 'active' and status ~= 'completed' and status ~= 'not_started' then
        return false
    end

    local key = norm(quest.name)

    if status == 'not_started' then
        state[key] = nil
        return true
    end

    state[key] = { name = quest.name, status = status }
    return true
end

local function accept_name(text)
    local name = text:match('^[Qq]uest%s+[Aa]ccepted:%s*(.+)$')

    if name == nil then
        name = text:match('Quest Accepted:%s*(.+)')
    end

    if name == nil then
        return nil
    end

    name = name:gsub('%s+$', ''):gsub('[%.!]+$', '')
    name = name:match('^(.-)%s*$')

    if name == nil or name == '' then
        return nil
    end

    return name
end

local function trigger_hit(message, trigger)
    if type(trigger) ~= 'string' or trigger == '' then
        return false
    end

    if message:find(trigger, 1, true) then
        return true
    end

    return message:lower():find(trigger:lower(), 1, true) ~= nil
end

function M.on_text(message, zone)
    local text = plain(message)

    if text == '' then
        return nil
    end

    local accepted = accept_name(text)

    if accepted ~= nil then
        local key = norm(accepted)
        local quest = by_name[key]
        state[key] = {
            name = quest and quest.name or accepted,
            status = 'active',
        }

        return {
            action = 'active',
            name = state[key].name,
            known = quest ~= nil,
            quest = quest,
        }
    end

    local zone_id = tonumber(zone)

    for _, quest in ipairs(quests) do
        local row = state[norm(quest.name)]

        if row ~= nil and row.status == 'active' and type(quest.complete_on) == 'table' then
            local allow = quest.complete_zone == nil
                or zone_id == nil
                or zone_id == quest.complete_zone

            if allow then
                for _, trigger in ipairs(quest.complete_on) do
                    if trigger_hit(text, trigger) then
                        row.status = 'completed'

                        return {
                            action = 'completed',
                            name = quest.name,
                            known = true,
                            quest = quest,
                        }
                    end
                end
            end
        end
    end

    return nil
end

-- Nearby compass and the alert. Completed stays hidden, unless it is
-- repeatable and the player is not hiding completed quests.
function M.shows_nearby(status, repeatable, hide_complete)
    if status == 'active' or status == 'not_started' then
        return true
    end

    if status == 'completed' then
        return repeatable == true and hide_complete ~= true
    end

    return false
end

function M.unknown_rows()
    local rows = {}

    for key, row in pairs(state) do
        if by_name[key] == nil and row.status ~= 'not_started' then
            rows[#rows + 1] = {
                id = 'catseye_note_' .. key:gsub('%W', '_'),
                name = row.name,
                area = 'catseye',
                category = 'catseye',
                zone = 'CatsEye',
                npc = '',
                req = '',
                prereq = '',
                reward = '',
                steps = {
                    'チャットで記録したクエストです。手順はまだ入っていません。',
                },
                chat_track = true,
                trackable = false,
                status = row.status,
            }
        end
    end

    table.sort(rows, function(a, b)
        return tostring(a.name) < tostring(b.name)
    end)

    return rows
end

return M
