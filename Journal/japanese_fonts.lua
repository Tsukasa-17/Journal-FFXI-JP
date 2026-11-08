-- Journal Japanese compatibility: isolated system-font loader.
local M = {}
function M.load(imgui, addon, richtext, selection)
    local glyph_ranges = require('glyph_ranges')
    local choice = require('font_choice')
    local requested = choice.normalize(selection or choice.get())
    local custom_failed = false
    local tx = require('i18n').t
    local chat_print = require('encoding').chat_print
    local journal_font, text_font, text_bold_font, text_italic_font
        -- Prefer Windows Meiryo (TTC) for Japanese glyphs. Do not ship Meiryo;
        -- fall back to the bundled Latin fonts when it is missing.
        -- Glyph ranges MUST be passed for CJK; a no-range load only has Latin.
        local function windows_font_path(file_name)
            local windir = os.getenv('WINDIR') or os.getenv('SystemRoot') or 'C:\\Windows'
            return windir .. '\\Fonts\\' .. file_name
        end

        local function file_exists(path)
            return choice.exists(path)
        end

        -- Persistent ranges (module-level via glyph_ranges.lua). Prefer our
        -- built buffer; optionally try ImGui's GetGlyphRangesJapanese pointer.
        local function resolve_glyph_ranges()
            local built = nil
            if glyph_ranges ~= nil and glyph_ranges.get ~= nil then
                local ok, value = pcall(glyph_ranges.get)
                if ok and value ~= nil then
                    built = value
                end
            end

            local ok_atlas, atlas_ranges = pcall(function()
                local io = imgui.GetIO()
                if io == nil or io.Fonts == nil then
                    return nil
                end
                if io.Fonts.GetGlyphRangesJapanese ~= nil then
                    return io.Fonts:GetGlyphRangesJapanese()
                end
                return nil
            end)

            if built ~= nil then return built, 'built' end

            if ok_atlas and atlas_ranges ~= nil then
                return atlas_ranges, 'atlas'
            end

            return built, 'built'
        end

        local ranges, ranges_source = resolve_glyph_ranges()

        local function add_font_file(path, size_pixels, with_ranges)
            if not file_exists(path) or not choice.valid_font_file(path) then
                return nil, 'missing-file'
            end

            if with_ranges and ranges ~= nil then
                -- Ashita IGuiManager: AddFontFromFileTTF(path, size, font_cfg, glyph_ranges)
                local ok, font = pcall(function()
                    return imgui.AddFontFromFileTTF(path, size_pixels, nil, ranges)
                end)
                if ok and font ~= nil and font ~= false then
                    return font, 'with-ranges'
                end
            end

            -- Last resort (Latin-only atlas). Avoid for Meiryo when possible.
            local ok2, font2 = pcall(function()
                return imgui.AddFontFromFileTTF(path, size_pixels)
            end)
            if ok2 and font2 ~= nil and font2 ~= false then
                return font2, 'no-ranges'
            end

            return nil, 'load-failed'
        end

        local meiryo_regular = windows_font_path('meiryo.ttc')
        local meiryo_bold = windows_font_path('meiryob.ttc')
        local used_meiryo = false
        local meiryo_mode = nil

        if requested ~= 'meiryo' then
            local selected = select(1, add_font_file(choice.path(addon, requested), 30, true))
            if selected ~= nil then
                local bold, italic
                if requested == 'assets/fonts/FiraSans-Regular.ttf' then
                    bold = select(1, add_font_file(addon.path .. 'assets/fonts/FiraSans-Bold.ttf', 30, true))
                    italic = select(1, add_font_file(addon.path .. 'assets/fonts/FiraSans-Italic.ttf', 30, true))
                end
                -- Other faces retain richtext fake-bold/italic-tint roles.
                richtext.set_fonts({regular=selected,bold=bold,italic=italic})
                choice.loaded(requested, requested, 'custom-warning')
                chat_print(tx('[Journal] Selected fonts may lack Japanese glyphs. Choose Windows Meiryo if text is missing.'))
                return selected, selected, bold, italic
            end
            custom_failed = true
            chat_print(tx('[Journal] The requested font could not be loaded; a fallback font is active.'))
        end

        journal_font, meiryo_mode = add_font_file(meiryo_regular, 30, true)
        if journal_font == nil then
            journal_font = select(1, add_font_file(
                addon.path .. 'assets/fonts/CarroisGothicSC-Regular.ttf',
                30,
                false
            ))
        else
            used_meiryo = true
        end

        text_font = select(1, add_font_file(meiryo_regular, 30, true))
        text_bold_font = select(1, add_font_file(meiryo_bold, 30, true))
        text_italic_font = text_font

        if text_font == nil then
            text_font = select(1, add_font_file(
                addon.path .. 'assets/fonts/FiraSans-Regular.ttf',
                30,
                false
            ))
        else
            used_meiryo = true
        end

        if text_bold_font == nil then
            text_bold_font = select(1, add_font_file(
                addon.path .. 'assets/fonts/FiraSans-Bold.ttf',
                30,
                false
            )) or text_font
        end

        if text_italic_font == nil then
            text_italic_font = select(1, add_font_file(
                addon.path .. 'assets/fonts/FiraSans-Italic.ttf',
                30,
                false
            )) or text_font
        end

        richtext.set_fonts({
            regular = text_font,
            bold = text_bold_font,
            italic = text_italic_font,
        })

        if used_meiryo then
            chat_print(tx('[Journal] Meiryo font loaded.'))
            if meiryo_mode == 'no-ranges' or ranges == nil then
                chat_print(tx('[Journal] Warning: Meiryo loaded without CJK glyph ranges; Japanese text may not render.'))
            end
        else
            chat_print(tx('[Journal] Meiryo not found; using bundled fonts (Japanese glyphs may be missing).'))
        end

    choice.loaded(requested, used_meiryo and 'meiryo' or ((journal_font or text_font) and 'bundled-fallback' or 'host-default'),
        custom_failed and 'load-failed' or (used_meiryo and 'default' or 'meiryo-missing'))
    return journal_font, text_font, text_bold_font, text_italic_font
end
return M
