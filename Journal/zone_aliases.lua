-- Stable EN/JA aliases, independent of client resource language.
local M = {}
local zone_index
local zones_data = require('data.zones')
local encoding = require('encoding')
local zonematch = require('zonematch')
function M.get()
    if zone_index ~= nil then
        return zone_index
    end

    -- Prefer static official EN/JA names so auto-step and styling do not
    -- depend on the client language of Ashita resource strings.
    local names = {}

    if type(zones_data) == 'table' then
        for id, entry in pairs(zones_data) do
            local numeric_id = tonumber(id)
            if numeric_id ~= nil and type(entry) == 'table' then
                local list = {}
                if type(entry.en) == 'string' and entry.en ~= '' then
                    list[#list + 1] = entry.en
                end
                if type(entry.ja) == 'string' and entry.ja ~= '' then
                    list[#list + 1] = entry.ja
                end
                if #list > 0 then
                    names[numeric_id] = list
                end
            end
        end
    end

    local index = zonematch.build_index(names)

    -- Optional fallback: merge game resource names (UTF-8 converted) when
    -- the static table is empty. Failures are ignored.
    if #index == 0 then
        local ok, resources = pcall(function()
            return AshitaCore:GetResourceManager()
        end)

        if ok and resources ~= nil then
            local fallback = {}
            for id = 1, 511 do
                local got, name = pcall(function()
                    return resources:GetString('zones.names', id)
                end)

                if got and type(name) == 'string' and name ~= '' then
                    local utf8 = encoding.shiftjis_to_utf8(name, true)
                    if type(utf8) == 'string' and utf8 ~= '' then
                        fallback[id] = utf8
                    else
                        fallback[id] = name
                    end
                end
            end
            index = zonematch.build_index(fallback)
        end
    end

    if #index > 0 then
        zone_index = index
    end

    return index
end

function M.name(id, language)
    local entry = zones_data[tonumber(id)]
    if type(entry) == 'table' then
        return (language == 'ja' and entry.ja) or entry.en
    end
end
return M
