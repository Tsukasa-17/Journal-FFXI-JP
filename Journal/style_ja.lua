-- Japanese styling only. No canonical text/ID mutation, hooks or resource scans.
-- Ashita v4 Lua arrays are 1-based: Name[3] EN, Name[2] JA.
local M = {}
local zm = require('zonematch')
local cached, cached_base, retry_at, resource_done

function M.char_end(s, i)
    local b = s:byte(i) or 0
    local n = b < 128 and 1 or (b < 224 and 2 or (b < 240 and 3 or 4))
    return math.min(#s, i + n - 1)
end

local function valid_utf8(s)
    local i = 1
    while i <= #s do
        local b = s:byte(i)
        if b < 128 then i = i + 1
        else
            local n = b >= 194 and b <= 223 and 2 or (b >= 224 and b <= 239 and 3 or (b >= 240 and b <= 244 and 4 or 0))
            if n == 0 or i + n - 1 > #s then return false end
            for j = i + 1, i + n - 1 do
                local v = s:byte(j)
                if v < 128 or v > 191 then return false end
            end
            local b2 = s:byte(i + 1)
            if (b == 224 and b2 < 160) or (b == 237 and b2 >= 160)
                or (b == 240 and b2 < 144) or (b == 244 and b2 >= 144) then return false end
            i = i + n
        end
    end
    return true
end
M.valid_utf8 = valid_utf8

local function japanese_name(s)
    if type(s) ~= 'string' or s == '' then return nil end
    if not valid_utf8(s) then
        local ok, value = pcall(function() return require('encoding').shiftjis_to_utf8(s, true) end)
        if not ok or type(value) ~= 'string' then return nil end
        s = value
    end
    -- Reject English fallbacks, failed conversion and control bytes.
    if valid_utf8(s) and s:find('[\227-\233]') and not s:find('[%z\1-\31]') then return s end
end
M.resource_name = japanese_name

-- Conservative script boundaries: a name may adjoin Japanese particles, not
-- another kanji/katakana/ASCII identifier. Prefer a missed mark to a false one.
local function adjoining(s, i, after)
    if i < 1 or i > #s then return false end
    local e = M.char_end(s, i)
    local c = s:sub(i, e)
    local a,b,d = c:byte(1,3)
    if a < 128 then return c:match('[%a_]') ~= nil or (not after and c:match('%d') ~= nil) end
    if c == '×' then return false end
    if #c == 3 then
        local cp = (a-224)*4096+(b-128)*64+d-128
        if cp >= 0x3041 and cp <= 0x3096 then return false end -- hiragana particles
        if (cp >= 0x3000 and cp <= 0x303F) or cp == 0xFF08 or cp == 0xFF09
            or cp == 0xFF1A or cp == 0xFF0C or cp == 0xFF0E
            or (after and cp >= 0xFF10 and cp <= 0xFF19) then return false end
    end
    return true
end
function M.boundary(s, first, last)
    local previous = first - 1
    while previous > 0 and s:byte(previous) >= 128 and s:byte(previous) < 192 do previous = previous - 1 end
    return not adjoining(s, previous) and not adjoining(s, last + 1, true)
end

local function append(index, seen, name, id)
    name = japanese_name(name)
    if not name or #name < 6 then return end
    local normalized = zm.normalize(name)
    if seen[normalized] then return end
    seen[normalized] = true
    index[#index+1] = {id=id, name=normalized, length=#normalized, japanese=true}
end

local function names_with_resources(resources)
    local zones, items, seen_z, seen_i = {}, {}, {}, {}
    for id, value in pairs(require('data.zones')) do
        append(zones, seen_z, value.ja, id)
        if resources then
            local ok, name = pcall(function() return resources:GetString('zones.names', id, 1) end)
            if ok then append(zones, seen_z, name, id) end
        end
    end
    for english, fallback in pairs(require('data.style_aliases_ja')) do
        -- Key items and private-server names may not be IItem resources.
        local id, localized
        if resources then
            local ok, result = pcall(function()
                local item = resources:GetItemByName(english, 2)
                if not item or not tonumber(item.ItemId) then return nil end
                local by_id = resources:GetItemById(item.ItemId)
                if not by_id or zm.normalize(tostring(by_id.Name[3] or '')) ~= zm.normalize(english) then return nil end
                return {id=item.ItemId, name=by_id.Name[2]}
            end)
            if ok and result then id, localized = result.id, result.name end
        end
        append(items, seen_i, localized, id or english)
        append(items, seen_i, fallback, id or english)
    end
    return zones, items
end

function M.extend(base, language)
    if language ~= 'ja' then return base end
    local now = os.clock()
    if cached and cached_base == base and (resource_done or now < retry_at) then return cached end
    local ok, resources = pcall(function() return AshitaCore:GetResourceManager() end)
    if not ok then resources = nil end
    local zones, items = names_with_resources(resources)
    cached = {}
    for n, style in ipairs(base) do
        local index = style.index
        if style.kind == 'bold' or style.kind == 'item' then
            index = {}
            for _, entry in ipairs(style.index or {}) do index[#index+1]=entry end
            for _, entry in ipairs(style.kind == 'bold' and zones or items) do index[#index+1]=entry end
        end
        cached[n] = {index=index, kind=style.kind}
    end
    cached_base, retry_at, resource_done = base, now + 5, resources ~= nil
    return cached
end
return M
