-- Journal localization (English / Spanish / Japanese).
--
-- Dictionaries:
--   data/translations_es.lua / data/translations_ja.lua  objective step texts
--   data/ui_es.lua / data/ui_ja.lua                      Journal UI / chat texts
--
-- Missing entries fall back to the English source string.
-- ImGui labels that end in ##id keep the id suffix (see M.t).

local M = {}

-- Japanese-only addon default; controller enforces JA on every config load.
-- Internal EN/ES dictionaries/APIs remain for canonical compatibility and tests.
local language = 'ja'
local dictionaries = {
    es = { steps = nil, ui = nil, steps_failed = false, ui_failed = false },
    ja = { steps = nil, ui = nil, steps_failed = false, ui_failed = false },
}

local function normalize_language(code)
    code = tostring(code or ''):lower()
    if code == 'es' or code == 'spanish' or code == 'espanol' or code == 'español' then
        return 'es'
    end
    if code == 'ja' or code == 'jp' or code == 'japanese' or code == '日本語' then
        return 'ja'
    end
    if code == 'en' or code == 'english' then
        return 'en'
    end
    return nil
end

-- clean.step removes stray periods when actor fragments are joined
-- ("(G-8). again" -> "(G-8) again"). Dictionaries were keyed on the raw
-- source, so the cleaned runtime text missed. Alias only when the cleaned
-- key is not already a different entry.
local function alias_cleaned_keys(words)
    local clean = require('data.clean')
    local alias = {}

    for key, value in pairs(words) do
        if type(key) == 'string'
            and type(value) == 'string'
            and key:sub(1, 4) ~= 'ctx:' then

            local cleaned = clean.step(key)

            if type(cleaned) == 'string' and cleaned ~= key and words[cleaned] == nil then
                local prior = alias[cleaned]

                if prior == nil then
                    alias[cleaned] = value
                elseif prior ~= value then
                    alias[cleaned] = false
                end
            end
        end
    end

    for key, value in pairs(alias) do
        if value ~= false then
            words[key] = value
        end
    end
end

-- Contextual names for English titles that are shared by more than one
-- record. Key form: ctx:<kind>:<area>:<id>:<english name>
-- A global English key is intentionally not used.
local function index_context(words)
    local exact = {}
    local by_id = {}

    for key, value in pairs(words) do
        if type(key) == 'string' and type(value) == 'string' then
            local kind, area, id, name = key:match('^ctx:([^:]+):([^:]+):([^:]+):(.*)$')

            if kind ~= nil and name ~= nil and name ~= '' then
                exact[kind .. '\0' .. area .. '\0' .. id .. '\0' .. name] = value

                local idkey = kind .. '\0' .. id .. '\0' .. name
                local prev = by_id[idkey]

                if prev == nil then
                    by_id[idkey] = { value = value, count = 1 }
                elseif prev.value ~= value then
                    prev.count = prev.count + 1
                end
            end
        end
    end

    return { exact = exact, by_id = by_id }
end

local function context_parts(context)
    if type(context) == 'table' then
        local kind = context.kind
        if kind ~= nil then
            kind = tostring(kind):lower()
        end

        local area = context.area
        if area == nil then
            area = context.category
        end
        if area ~= nil then
            area = tostring(area)
        end

        local id = context.id
        if id ~= nil then
            id = tostring(id)
        end

        return kind, area, id, true
    end

    if context ~= nil then
        return nil, nil, tostring(context), false
    end

    return nil, nil, nil, false
end

local function lookup_context(index, text, context, field)
    if index == nil or type(text) ~= 'string' or text == '' then
        return nil
    end
    if field ~= nil and field ~= 'name' then
        return nil
    end

    local kind, area, id, explicit = context_parts(context)
    if id == nil then
        return nil
    end

    -- An explicit category that does not match must not borrow another area.
    if explicit and area ~= nil then
        if kind == nil then
            return nil
        end
        return index.exact[kind .. '\0' .. area .. '\0' .. id .. '\0' .. text]
    end

    if kind ~= nil then
        local row = index.by_id[kind .. '\0' .. id .. '\0' .. text]
        if row ~= nil and row.count == 1 then
            return row.value
        end
        return nil
    end

    local found = nil
    for _, candidate in ipairs({ 'mission', 'quest' }) do
        local row = index.by_id[candidate .. '\0' .. id .. '\0' .. text]
        if row ~= nil and row.count == 1 then
            if found ~= nil and found ~= row.value then
                return nil
            end
            found = row.value
        end
    end

    return found
end

local function legacy_context(words, context, field)
    local id
    if type(context) == 'table' then
        if field == nil or field == 'name' then
            return nil
        end
        id = context.id
    else
        id = context
    end

    if id == nil then
        return nil
    end

    return words['quest:' .. tostring(id) .. ':' .. tostring(field or 'name')]
end

local function get_steps_dictionary(code)
    local slot = dictionaries[code]
    if slot == nil then
        return nil
    end
    if slot.steps ~= nil or slot.steps_failed then
        return slot.steps
    end

    local module_name = (code == 'ja') and 'data.translations_ja' or 'data.translations_es'
    local ok, result = pcall(require, module_name)
    if ok and type(result) == 'table' then
        alias_cleaned_keys(result)
        slot.steps = result
        slot.ctx = index_context(result)
    else
        slot.steps_failed = true
    end
    return slot.steps
end

local function get_ui_dictionary(code)
    local slot = dictionaries[code]
    if slot == nil then
        return nil
    end
    if slot.ui ~= nil or slot.ui_failed then
        return slot.ui
    end

    local module_name = (code == 'ja') and 'data.ui_ja' or 'data.ui_es'
    local ok, result = pcall(require, module_name)
    if ok and type(result) == 'table' then
        slot.ui = result
    else
        slot.ui_failed = true
    end
    return slot.ui
end

function M.get_language()
    return language
end

function M.set_language(code)
    local normalized = normalize_language(code)
    language = normalized or 'en'
end

function M.is_supported(code)
    return normalize_language(code) ~= nil
end

-- Returns the text of a step in the current language.
function M.step(text, context, field)
    if language == 'en' or type(text) ~= 'string' then
        return text
    end

    local words = get_steps_dictionary(language)
    if words == nil then
        return text
    end

    local slot = dictionaries[language]
    return lookup_context(slot and slot.ctx, text, context, field)
        or legacy_context(words, context, field)
        or words[text]
        or text
end

-- Returns a Journal UI string in the current language.
-- A text that ends in ##id (an ImGui id) keeps its id.
function M.t(text)
    if language == 'en' or type(text) ~= 'string' then
        return text
    end

    local words = get_ui_dictionary(language)
    if words == nil then
        return text
    end

    local at = text:find('##', 1, true)
    if at == nil then
        return words[text] or text
    end

    local base = text:sub(1, at - 1)
    if base == '' then
        return text
    end

    return (words[base] or base) .. text:sub(at)
end

function M.available(code)
    code = normalize_language(code) or language
    if code == 'en' then
        return true
    end
    return get_ui_dictionary(code) ~= nil
end


-- Forms of a step / title for search: English source plus any loaded
-- translations (so Japanese titles match even when UI language is en/es).
function M.search_forms(text, context, field)
    if type(text) ~= 'string' or text == '' then
        return { tostring(text or '') }
    end

    local forms = { text }
    local seen = { [text] = true }

    for _, code in ipairs({ 'es', 'ja' }) do
        local words = get_steps_dictionary(code)
        if words ~= nil then
            local slot = dictionaries[code]
            local translated = lookup_context(slot and slot.ctx, text, context, field)
                or legacy_context(words, context, field)
                or words[text]
            if type(translated) == 'string'
                and translated ~= ''
                and not seen[translated] then
                seen[translated] = true
                forms[#forms + 1] = translated
            end
        end
    end

    return forms
end

function M.language_label(code)
    code = normalize_language(code) or language
    if code == 'es' then
        return 'Espanol'
    end
    if code == 'ja' then
        return '日本語'
    end
    return 'English'
end

return M
