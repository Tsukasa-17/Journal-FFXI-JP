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
        slot.steps = result
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

    return (context ~= nil and words['quest:' .. tostring(context) .. ':' .. tostring(field or 'name')]) or words[text] or text
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
            local translated = (context ~= nil and words['quest:' .. tostring(context) .. ':' .. tostring(field or 'name')]) or words[text]
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
