-- What the player carries, to mark the items that a step asks for.
--
-- richtext.lua asks this module (richtext.items_api, set by journal.lua) if
-- the player has an item by its name: Tick() is called while the steps are
-- drawn and does the work in small pieces, Version() changes when the
-- inventory (or the index of names) changes so the marked texts are made
-- again, and Status(name, quantity) answers 'ok' (enough), 'partial' (some)
-- or nil (not an item, or not known yet).
--
-- The names come from the game resources: the items are read once, a slice
-- of ids at each call, and indexed by name (lowercase, no apostrophes). The
-- counts are read from all the containers of the character (bag, safe,
-- storage, locker, satchel, sack, case and the wardrobes), every
-- SCAN_INTERVAL seconds. The key items are the same way: their names are
-- read from the resources ('keyitems.names') and the ones that a text names
-- are asked to the player (HasKeyItem) at each scan. Everything is protected: if the binding of Ashita
-- does not answer as expected the module just says nothing.

local M = {}

-- Container ids of Ashita: 0 bag, 1 mog safe, 2 storage, 3 temporary (left
-- out), 4 locker, 5 satchel, 6 sack, 7 case, 8 wardrobe, 9 safe 2, 10 to 12
-- wardrobes 2 to 4.
local CONTAINERS = { 0, 1, 2, 4, 5, 6, 7, 8, 9, 10, 11, 12 }
local SCAN_INTERVAL = 1.5
local INDEX_SLICE = 1500
local INDEX_MAX = 32000
local KEY_MAX = 4500
local GIL_ID = 65535

local counts = {}
local version = 1
local last_scan = -1000

local index = { names = {}, next_id = 1, done = false }
local key_index = { names = {}, next_id = 0, done = false }

-- Key items that a text has asked for: id -> true when the player has it.
local watched = {}

local function normalize(name)
    name = tostring(name or ''):lower()
    name = name:gsub('%z+$', '')
    name = name:gsub("'", ''):gsub('`', ''):gsub('\226\128\153', '')
    name = name:gsub('%s+', ' '):gsub('^ ', ''):gsub(' $', '')

    return name
end

M.normalize = normalize

-- English step names are in the Ashita index. Japanese step text uses the
-- official names from data.style_aliases_ja. Missing module: names stay as
-- the resources gave them.
local alias_table = nil

local function aliases()
    if alias_table ~= nil then
        return alias_table
    end

    local ok, result = pcall(require, 'data.style_aliases_ja')

    if ok and type(result) == 'table' then
        alias_table = result
    else
        alias_table = false
    end

    return alias_table
end

-- Copy each English id list onto its Japanese name. A Japanese key that
-- Ashita already filled (Name[2]) is left alone.
local function apply_aliases(names)
    local map = aliases()

    if map == false then
        return
    end

    for english, japanese in pairs(map) do
        if type(english) == 'string' and type(japanese) == 'string' then
            local from = names[normalize(english)]
            local key = normalize(japanese)

            if from ~= nil and key ~= '' and names[key] == nil then
                names[key] = from
            end
        end
    end
end

-- The displayed name may arrive after the index was finished.
local function alias_target(names, key)
    local map = aliases()

    if map == false then
        return nil
    end

    for english, japanese in pairs(map) do
        if type(japanese) == 'string' and normalize(japanese) == key then
            local found = type(english) == 'string'
                and names[normalize(english)]
                or nil

            if found ~= nil then
                return found
            end
        end
    end

    return nil
end

local function index_slice()
    local ok, manager = pcall(function()
        return AshitaCore:GetResourceManager()
    end)

    if not ok or manager == nil then
        return
    end

    local last = math.min(index.next_id + INDEX_SLICE - 1, INDEX_MAX)

    for id = index.next_id, last do
        local got, item = pcall(function()
            return manager:GetItemById(id)
        end)

        if got and item ~= nil then
            -- Ashita item names: [2] Japanese, [3] English. [1] is kept
            -- too, so a step can name the item in either language.
            for slot = 1, 3 do
                local named, name = pcall(function()
                    return item.Name[slot]
                end)

                if named and type(name) == 'string' and name ~= '' then
                    local key = normalize(name)
                    local list = index.names[key]

                    if list == nil then
                        index.names[key] = { id }
                    else
                        local seen = false

                        for _, have in ipairs(list) do
                            if have == id then
                                seen = true
                                break
                            end
                        end

                        if not seen then
                            list[#list + 1] = id
                        end
                    end
                end
            end
        end
    end

    index.next_id = last + 1

    if index.next_id > INDEX_MAX then
        index.done = true
        apply_aliases(index.names)
        version = version + 1
    end
end

local function key_slice()
    local ok, manager = pcall(function()
        return AshitaCore:GetResourceManager()
    end)

    if not ok or manager == nil then
        return
    end

    local last = math.min(key_index.next_id + INDEX_SLICE - 1, KEY_MAX)

    for id = key_index.next_id, last do
        local got, name = pcall(function()
            return manager:GetString('keyitems.names', id)
        end)

        local function remember_key(value)
            if type(value) ~= 'string' or value == '' then
                return
            end

            local key = normalize(value)

            -- The first id of a name is kept.
            if key_index.names[key] == nil then
                key_index.names[key] = id
            end
        end

        if got then
            remember_key(name)
        end

        -- Language slots, when the resource manager has them.
        for _, lang in ipairs({ 2, 3 }) do
            local named, localized = pcall(function()
                return manager:GetString('keyitems.names', id, lang)
            end)

            if named then
                remember_key(localized)
            end
        end
    end

    key_index.next_id = last + 1

    if key_index.next_id > KEY_MAX then
        key_index.done = true
        apply_aliases(key_index.names)
        version = version + 1
    end
end

local function has_key_item(id)
    local ok, owned = pcall(function()
        return AshitaCore:GetMemoryManager():GetPlayer():HasKeyItem(id)
    end)

    return ok and owned == true
end

local function scan()
    -- The key items that were asked for.
    for id, owned in pairs(watched) do
        local now_owned = has_key_item(id)

        if now_owned ~= owned then
            watched[id] = now_owned
            version = version + 1
        end
    end

    local ok, inventory = pcall(function()
        return AshitaCore:GetMemoryManager():GetInventory()
    end)

    if not ok or inventory == nil then
        return
    end

    local found = {}
    local total = 0

    for _, container in ipairs(CONTAINERS) do
        local got, max = pcall(function()
            return inventory:GetContainerCountMax(container)
        end)

        if got and type(max) == 'number' then
            for slot = 0, max do
                local read, item = pcall(function()
                    return inventory:GetContainerItem(container, slot)
                end)

                if read and item ~= nil then
                    local id = tonumber(item.Id) or 0
                    local count = tonumber(item.Count) or 0

                    if id > 0 and id ~= GIL_ID and count > 0 then
                        found[id] = (found[id] or 0) + count
                        total = total + 1
                    end
                end
            end
        end
    end

    -- An empty answer (zoning, or not logged in yet) keeps what was known.
    if total == 0 then
        return
    end

    local changed = false

    for id, count in pairs(found) do
        if counts[id] ~= count then
            changed = true
            break
        end
    end

    if not changed then
        for id in pairs(counts) do
            if found[id] == nil then
                changed = true
                break
            end
        end
    end

    if changed then
        counts = found
        version = version + 1
    end
end

-- Called while the steps are drawn.
function M.Tick()
    if not index.done then
        index_slice()
    elseif not key_index.done then
        key_slice()
    end

    local now = os.clock()

    if now - last_scan >= SCAN_INTERVAL then
        last_scan = now
        scan()
    end
end

function M.Version()
    return version
end

-- 'ok' when the player has quantity or more, 'partial' (and how many) when
-- he has fewer, nil when the name is neither an item nor a key item of the
-- game (a door, a monster...) or the names are not read yet.
function M.Status(name, quantity)
    if not index.done then
        return nil
    end

    local key = normalize(name)
    local ids = index.names[key]

    if ids == nil then
        ids = alias_target(index.names, key)
    end

    if ids == nil then
        -- Not an item: maybe a key item (there is only one of each).
        local key_id = key_index.done and key_index.names[key] or nil

        if key_id == nil and key_index.done then
            key_id = alias_target(key_index.names, key)
        end

        if key_id == nil then
            return nil
        end

        local owned = watched[key_id]

        if owned == nil then
            owned = has_key_item(key_id)
            watched[key_id] = owned
        end

        if owned then
            return 'ok', 1
        end

        return 'partial', 0
    end

    local have = 0

    for _, id in ipairs(ids) do
        have = have + (counts[id] or 0)
    end

    if have >= (quantity or 1) then
        return 'ok', have
    end

    return 'partial', have
end

-- For the tests.
function M.Reset()
    counts = {}
    version = 1
    last_scan = -1000
    index = { names = {}, next_id = 1, done = false }
    key_index = { names = {}, next_id = 0, done = false }
    watched = {}
end

-- Inject a finished name index and counts. aliases are copied the same way
-- as when the resource scan finishes, unless apply_aliases is false.
function M.SetTestIndex(spec)
    spec = spec or {}

    M.Reset()
    index.names = spec.names or {}
    index.done = true
    counts = spec.counts or {}

    if spec.keys ~= nil then
        key_index.names = spec.keys
        key_index.done = true
    end

    if spec.apply_aliases ~= false then
        apply_aliases(index.names)

        if key_index.done then
            apply_aliases(key_index.names)
        end
    end
end

return M
