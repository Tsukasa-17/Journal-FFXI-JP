-- Pinned tracker.
--
-- Small standalone window with the missions and quests pinned from the
-- Journal ("Pin to Tracker"). Two layouts:
--   stacked : every pinned item at once, missions first, then quests
--   tabs    : one item at a time, with a tab per item
--
-- The window has no background and everything is set flush right, with a
-- small shadow behind the text so it stays readable over the game.
--
-- The server only reports whether a quest or mission is active or
-- completed, so the current step is advanced by hand (the < and > buttons,
-- or /journal pin next|prev|reset) or by the zone-change check.
-- Each item has a thumbtack: it unpins the item. The item stays on the list
-- for a few seconds, with an empty thumbtack, so it can be pinned again.
-- The mode and the visibility of the tracker are the same setting everywhere:
-- the X on this window, the button on the Journal, and /journal pin.

local imgui = require('imgui')
local icons = require('icons')
local richtext = require('richtext')
local i18n = require('i18n')

local M = {}

local styles = nil

-- Light blue for italics, used only if the italic font could not be loaded.
local italic_tint = { 0.75, 0.84, 1.00, 1.00 }

local restore_window = true

-- Drag-resize, in the same way as the compass. The width is the tracker
-- size (pin_scale). The height is remembered on its own. Text size is not
-- part of either. size_refit is the few frames that fit the content before
-- a height has been saved. A later change of text size or tracker size
-- must not make that height shorter.
local size_placed = false
local size_refit = 0
local applied_scale = nil
local applied_text = nil
local seen_w, seen_h = nil, nil

-- Frames left holding the player's height after a text-size or tracker-size
-- change. 0 means the window is the player's again, including a drag.
local height_lock = nil
local height_lock_frames = 0

local WINDOW_WIDTH = 420
local TAB_NAME_LENGTH = 12
local TEXT_SIZE = 16

-- Text size of the current frame, TEXT_SIZE times the tracker text size.
local current_size = TEXT_SIZE

-- Bold text in the current frame. Without a bold face the text is drawn a
-- second time one pixel to the right.
local current_bold = false
local fake_bold = false

-- Layout of the default ImGui style, used to set buttons flush right.
local WINDOW_PADDING = 8
local FRAME_PADDING_X = 4
local FRAME_PADDING_Y = 3
local ITEM_SPACING_X = 8
local INNER_SPACING_X = 4

local TRANSPARENT = { 0, 0, 0, 0 }
local SHADOW_COLOR = 0xCC000000

-- Opacity of the tracker in the current frame (set from the settings), and
-- the last window reset that was applied.
local current_opacity = 1.0
local last_reset_count = nil

-- The shadow follows the opacity of the text.
local function shadow_color()
    local alpha = math.floor(0xCC * current_opacity + 0.5)

    return alpha * 0x1000000
end

local colors = {
    mission = { 0.55, 0.75, 1.00, 1.00 },
    quest = { 1.00, 0.85, 0.40, 1.00 },
    repeatable = { 0.62, 0.85, 1.00, 1.00 },
    section = { 0.60, 0.60, 0.60, 1.00 },
    step = { 1.00, 1.00, 1.00, 1.00 },
    next = { 0.65, 0.65, 0.65, 1.00 },
    done = { 0.55, 0.85, 0.55, 1.00 },
    ghost = { 0.55, 0.55, 0.55, 1.00 },
    pin_icon = { 0.90, 0.90, 0.90, 1.00 },
    tab_active = { 0.30, 0.30, 0.30, 1.00 },
    bg = { 0.00, 0.00, 0.00, 0.00 },

    -- The < and > step buttons: translucent gray.
    step_button = { 0.55, 0.55, 0.55, 0.35 },
    step_button_hovered = { 0.65, 0.65, 0.65, 0.50 },
    step_button_active = { 0.75, 0.75, 0.75, 0.65 },
}

local section_labels = {
    mission = '-- MISSIONS --',
    quest = '-- QUESTS --',
}

local kinds = { 'mission', 'quest' }

-- Items just unpinned from the tracker. They stay a few seconds, so the
-- thumbtack can pin them again. Each one: kind, id, name, steps, time.
local GHOST_SECONDS = 20
local ghosts = {}

-- What the thumbtacks asked for during this frame. It is done when the frame
-- has been drawn, so the list of pins does not change while it is drawn.
local pending_unpin = nil
local pending_repin = nil

local function step_text(step)
    if type(step) == 'table' then
        if step.text ~= nil then
            return i18n.step(tostring(step.text))
        end

        return ''
    end

    return i18n.step(tostring(step or ''))
end

local function utf8_chars(text)
    local chars = {}
    local i = 1
    local n = #text

    while i <= n do
        local b = text:byte(i)
        local len = 1

        if b >= 0xF0 then
            len = 4
        elseif b >= 0xE0 then
            len = 3
        elseif b >= 0xC0 then
            len = 2
        end

        if i + len - 1 > n then
            break
        end

        chars[#chars + 1] = text:sub(i, i + len - 1)
        i = i + len
    end

    return chars
end

-- ASCII stays 1 column, the historical 12-column tab budget. Japanese
-- glyphs are wider, so they take 2 and are never cut mid-character.
local function columns_of(char)
    if char:byte(1) < 0x80 then
        return 1
    end

    return 2
end

local function is_ascii(text)
    return text:match('^[%z\1-\127]*$') ~= nil
end

-- English titles in lower case, for names that differ from the dictionary
-- only in case, in the apostrophe or in a "(Bastok)" suffix. A lower-case
-- title shared by two different translations is left out.
local loose_titles = nil

local function loose_title(name)
    if loose_titles == nil then
        loose_titles = {}

        local ok, words = pcall(require, 'data.translations_ja')

        if ok and type(words) == 'table' then
            for key, value in pairs(words) do
                if type(key) == 'string'
                    and type(value) == 'string'
                    and key:sub(1, 4) ~= 'ctx:' then

                    local lower = key:lower()
                    local prior = loose_titles[lower]

                    if prior == nil then
                        loose_titles[lower] = value
                    elseif prior ~= value then
                        loose_titles[lower] = false
                    end
                end
            end
        end
    end

    local function find(text)
        local value = loose_titles[text:lower()]

        return value ~= false and value or nil
    end

    local plain = name:gsub('\226\128\153', "'")

    return find(plain)
        or find((plain:gsub('%s*%b()%s*$', '')))
end

local function display_name(entry)
    local name = tostring(entry.name or '')
    local shown = tostring(i18n.step(name, {
        kind = entry.kind,
        area = entry.area,
        id = entry.id,
    }))

    if not is_ascii(shown)
        or i18n.get_language == nil
        or i18n.get_language() ~= 'ja' then

        return shown
    end

    -- A pin saved with an area that is not the one of the dictionary.
    for _, other in ipairs({
        tostring(i18n.step(name, { kind = entry.kind, id = entry.id })),
        tostring(i18n.step(name)),
        loose_title(name),
    }) do
        if other ~= nil and not is_ascii(other) then
            return other
        end
    end

    return shown
end

local function short_name(name)
    name = tostring(name or '')

    local chars = utf8_chars(name)
    local total = 0

    for _, char in ipairs(chars) do
        total = total + columns_of(char)
    end

    if total <= TAB_NAME_LENGTH then
        return name
    end

    local budget = TAB_NAME_LENGTH - 3
    local used = 0
    local out = {}

    for _, char in ipairs(chars) do
        local width = columns_of(char)

        if used + width > budget then
            break
        end

        out[#out + 1] = char
        used = used + width
    end

    return table.concat(out) .. '...'
end

-- The tab the selector draws. The ImGui id stays the pin index.
function M.TabSpec(entry, index)
    local full = display_name(entry or {})
    local label = short_name(full)

    return {
        index = index,
        label = label,
        full = full,
        id = label .. '##pin_tab_' .. tostring(index),
    }
end

-- The window size sets only the width of the window, and the text size
-- only the size of the text. Longer lines wrap.
function M.LayoutScale(pin)
    local size_scale = tonumber(pin and pin.scale) or 1.0
    local text_scale = tonumber(pin and pin.text_scale) or 1.0

    if size_scale ~= size_scale or size_scale <= 0 or size_scale == math.huge then
        size_scale = 1.0
    end

    if text_scale ~= text_scale or text_scale <= 0 or text_scale == math.huge then
        text_scale = 1.0
    end

    return {
        scale = text_scale,
        font = TEXT_SIZE * text_scale,
        width = WINDOW_WIDTH * size_scale,
        text_scale = text_scale,
        size_scale = size_scale,
    }
end

-- Height to keep when the text size or the tracker size changes.
-- A height the player already set is returned as it is, whether the text
-- would now be shorter or taller. No saved height yet: the measurement
-- stands (the first fit uses 0, which means "as tall as the text").
function M.HoldHeight(saved_height, measured_height)
    saved_height = tonumber(saved_height)

    if saved_height == nil
        or saved_height ~= saved_height
        or saved_height <= 0
        or saved_height == math.huge then

        return tonumber(measured_height)
    end

    return saved_height
end

-- Lines that fit in max_width. measure(text) returns a width. English
-- breaks on spaces; anything wider than the line breaks one character at
-- a time, so a large tracker font still stays inside the window.
function M.FitLines(text, max_width, measure)
    text = tostring(text or '')
    max_width = tonumber(max_width) or 0

    if text == '' or type(measure) ~= 'function' or max_width <= 0 then
        return { text }
    end

    local whole = measure(text)

    if type(whole) ~= 'number' or whole ~= whole or whole <= max_width then
        return { text }
    end

    local char_end = require('style_ja').char_end
    local lines = {}
    local line = ''
    local i = 1
    local n = #text

    local function emit()
        local trimmed = line:gsub('%s+$', '')

        if trimmed ~= '' then
            lines[#lines + 1] = trimmed
        end

        line = ''
    end

    local function append_chars(chunk)
        local k = 1

        while k <= #chunk do
            local ke = char_end(chunk, k)
            local one = chunk:sub(k, ke)

            if line ~= '' and measure(line .. one) > max_width then
                emit()
            end

            line = line .. one
            k = ke + 1
        end
    end

    while i <= n do
        local e = char_end(text, i)
        local ch = text:sub(i, e)

        if ch:byte() < 128 and ch ~= ' ' and ch ~= '\t' then
            local j = e + 1

            while j <= n do
                local e2 = char_end(text, j)
                local c2 = text:sub(j, e2)

                if c2:byte() >= 128 or c2 == ' ' or c2 == '\t' then
                    break
                end

                e = e2
                j = e + 1
            end

            ch = text:sub(i, e)
        end

        if ch ~= ' ' and ch ~= '\t' then
            if line == '' then
                if measure(ch) > max_width then
                    append_chars(ch)
                else
                    line = ch
                end
            elseif measure(line .. ch) > max_width then
                emit()

                if measure(ch) > max_width then
                    append_chars(ch)
                else
                    line = ch
                end
            else
                line = line .. ch
            end
        elseif line ~= '' and measure(line .. ' ') <= max_width then
            line = line .. ' '
        end

        i = e + 1
    end

    emit()

    if #lines == 0 then
        return { text }
    end

    return lines
end

-- Height of the stacked list. A saved window height caps it so the list
-- and the window do not each grow their own scrollbar. 0 means no cap.
-- Sixteen pixels stay free at the corner for the resize grip.
function M.StackLimit(stack_max, content_avail)
    stack_max = tonumber(stack_max) or 0

    if stack_max ~= stack_max or stack_max < 0 or stack_max == math.huge then
        stack_max = 0
    end

    stack_max = math.floor(stack_max)
    content_avail = tonumber(content_avail)

    if content_avail == nil
        or content_avail ~= content_avail
        or content_avail == math.huge
        or content_avail <= 0 then

        return stack_max
    end

    content_avail = math.max(1, math.floor(content_avail) - 16)

    if stack_max <= 0 or content_avail < stack_max then
        return content_avail
    end

    return stack_max
end

---------------------------------------------------------- flush right

local function text_width(text)
    return (imgui.CalcTextSize(text))
end

local function button_width(label)
    return text_width(label) + FRAME_PADDING_X * 2
end

-- Free width from the cursor to the right edge. A scrollbar (the stacked
-- height limit) is already out of that width.
local function content_width()
    local ok_avail, avail = pcall(imgui.GetContentRegionAvail)
    local ok_x, x = pcall(imgui.GetCursorPosX)

    if ok_avail and ok_x and tonumber(avail) ~= nil and tonumber(x) ~= nil then
        return math.max(1, avail)
    end

    return math.max(1, imgui.GetWindowWidth() - WINDOW_PADDING * 2)
end

-- Moves the cursor so that something this wide ends at the right edge.
local function align_right(width)
    local edge = imgui.GetWindowWidth() - WINDOW_PADDING
    local ok_avail, avail = pcall(imgui.GetContentRegionAvail)
    local ok_x, x = pcall(imgui.GetCursorPosX)

    if ok_avail and ok_x and tonumber(avail) ~= nil and tonumber(x) ~= nil then
        edge = x + avail
    end

    imgui.SetCursorPosX(math.max(WINDOW_PADDING, edge - width))
end

-- One line of text flush right, with a shadow. With icon_color, an infinity
-- sign follows the text (the repeatable quests).
local function draw_right_line(color, text, icon_color, lead)
    local line_height = imgui.GetTextLineHeight()
    local icon_width, icon_height = 0, 0
    local icon_gap = 0
    local lead_width = 0

    if icon_color ~= nil then
        icon_width, icon_height = icons.infinity_size(line_height)
        icon_gap = 8
    end

    if lead ~= nil and lead.width and lead.height and imgui.Dummy and imgui.SameLine then
        lead_width = line_height * lead.width / lead.height
    end

    align_right(
        text_width(text) + icon_gap + icon_width
            + (lead_width > 0 and lead_width + 4 or 0)
    )

    if lead_width > 0 then
        if pcall(imgui.Dummy, { lead_width, line_height }) then
            pcall(function()
                local min_x, min_y = imgui.GetItemRectMin()
                local max_x, max_y = imgui.GetItemRectMax()

                imgui.GetWindowDrawList():AddImage(
                    lead.id,
                    { min_x, min_y },
                    { max_x, max_y },
                    { 0, 0 },
                    { 1, 1 },
                    imgui.GetColorU32({ 1, 1, 1, 1 })
                )
            end)

            imgui.SameLine(0, 4)
        end
    end

    -- The line is reserved with invisible text and then drawn twice, the
    -- first time as the shadow.
    local text_x, text_y = imgui.GetCursorPos()

    imgui.PushStyleColor(ImGuiCol_Text, TRANSPARENT)
    local reserved = pcall(imgui.Text, text)
    imgui.PopStyleColor()

    local drawn = reserved and pcall(function()
        local draw = imgui.GetWindowDrawList()
        local x, y = imgui.GetItemRectMin()

        draw:AddText({ x + 1, y + 1 }, shadow_color(), text)
        draw:AddText({ x, y }, imgui.GetColorU32(color), text)

        if fake_bold then
            draw:AddText({ x + 1, y }, imgui.GetColorU32(color), text)
        end

        if icon_color ~= nil then
            local icon_x = x + text_width(text) + icon_gap
            local icon_y = y + (line_height - icon_height) * 0.5

            icons.draw_infinity(
                draw,
                icon_x + 1,
                icon_y + 1,
                icon_width,
                icon_height,
                shadow_color(),
                1.6
            )

            icons.draw_infinity(
                draw,
                icon_x,
                icon_y,
                icon_width,
                icon_height,
                imgui.GetColorU32(icon_color),
                1.6
            )
        end
    end)

    if not drawn then
        imgui.TextColored(color, text)
    end

    -- Where the text is, in window coordinates, for a button over it.
    return text_x, text_y, text_width(text) + icon_gap + icon_width, line_height
end

-- Flush right, and on more than one line when the font is wider than the
-- window. Icons stay on the first line (the picture) and the last line
-- (the infinity sign). A line that already fits is drawn once, as before.
local function right_text(color, text, icon_color, lead)
    local line_height = imgui.GetTextLineHeight()
    local icon_width = 0
    local icon_gap = 0
    local lead_width = 0

    if icon_color ~= nil then
        icon_width = (icons.infinity_size(line_height))
        icon_gap = 8
    end

    if lead ~= nil and lead.width and lead.height and imgui.Dummy and imgui.SameLine then
        lead_width = line_height * lead.width / lead.height
    end

    local extras = icon_gap + icon_width
        + (lead_width > 0 and lead_width + 4 or 0)
    local room = content_width()
    local lines = { text }

    if text_width(text) + extras > room then
        lines = M.FitLines(text, math.max(8, room - extras), text_width)
    end

    local origin_x, origin_y, right, bottom = nil, nil, nil, nil

    for index, line in ipairs(lines) do
        local x, y, w, h = draw_right_line(
            color,
            line,
            index == #lines and icon_color or nil,
            index == 1 and lead or nil
        )

        if x ~= nil and y ~= nil then
            origin_x = origin_x == nil and x or math.min(origin_x, x)
            origin_y = origin_y or y
            right = math.max(right or 0, x + (w or 0))
            bottom = math.max(bottom or 0, y + (h or line_height))
        end
    end

    if origin_x == nil then
        return nil, nil, 0, line_height
    end

    return origin_x,
        origin_y,
        math.max(0, right - origin_x),
        math.max(line_height, bottom - origin_y)
end

-- An invisible button over a line drawn by right_text. A plain Text item
-- does not take the click (the press starts moving the window instead).
local function line_button(id, x, y, width, height)
    if x == nil or y == nil or imgui.InvisibleButton == nil then
        return false, false
    end

    local after_x, after_y = imgui.GetCursorPos()

    imgui.SetCursorPos({ x, y })

    local clicked = imgui.InvisibleButton(id, { math.max(1, width), math.max(1, height) })
    local hovered = imgui.IsItemHovered()

    imgui.SetCursorPos({ after_x, after_y })

    return clicked, hovered
end

-- The click on an NPC name goes to the controller (set while drawing).
local click_npc = nil

local function text_wrapped(color, text, id, items)
    richtext.draw_wrapped(text, {
        styles = styles,
        items = items,
        color = color,
        italic_color = italic_tint,
        size = current_size,
        bold = current_bold,
        align = 'right',
        shadow = true,
        on_npc = click_npc and function(name)
            click_npc(name, text)
        end or nil,
        id = id,
        npc_tooltip = i18n.t('Click to point the compass at it'),
    })
end

local function group_by_kind(pins, controller)
    local groups = { mission = {}, quest = {} }

    for index, entry in ipairs(pins) do
        local group = groups[entry.kind]
        local listed = controller == nil
            or controller.IsQuestListed == nil
            or controller.IsQuestListed(entry)

        if group ~= nil and listed then
            group[#group + 1] = index
        end
    end

    return groups
end

-- Missions first, then quests, each in the pinned order. Same as the tabs.
function M.TabRow(pins, controller)
    local groups = group_by_kind(pins or {}, controller)
    local row = {}

    for _, kind in ipairs(kinds) do
        local group = groups[kind]

        if #group > 0 then
            if #row > 0 then
                row[#row + 1] = { separator = true }
            end

            for _, index in ipairs(group) do
                local spec = M.TabSpec(pins[index], index)
                spec.kind = pins[index].kind
                row[#row + 1] = spec
            end
        end
    end

    return row
end

-- Draws one pinned item. Only the direction buttons are shown.
-- One of the < and > buttons: small, in translucent gray.
local function step_button(label)
    imgui.PushStyleColor(ImGuiCol_Button, colors.step_button)
    imgui.PushStyleColor(ImGuiCol_ButtonHovered, colors.step_button_hovered)
    imgui.PushStyleColor(ImGuiCol_ButtonActive, colors.step_button_active)

    local clicked = imgui.SmallButton(label)

    imgui.PopStyleColor(3)

    return clicked
end

-- The thumbtack button: as wide as the < and > buttons. filled is a pinned
-- item, an empty thumbtack is an item that was just unpinned.
local function pin_button(id, filled, tooltip)
    local width = button_width('>')
    local height = imgui.GetTextLineHeight()

    imgui.PushStyleColor(ImGuiCol_Button, colors.step_button)
    imgui.PushStyleColor(ImGuiCol_ButtonHovered, colors.step_button_hovered)
    imgui.PushStyleColor(ImGuiCol_ButtonActive, colors.step_button_active)

    local clicked = imgui.Button('##' .. id, { width, height })

    imgui.PopStyleColor(3)

    local min_x, min_y = imgui.GetItemRectMin()
    local max_x, max_y = imgui.GetItemRectMax()
    local size = math.min(max_x - min_x, max_y - min_y) * 0.92

    icons.draw_pin(
        imgui.GetWindowDrawList(),
        min_x + ((max_x - min_x) - size) * 0.5,
        min_y + ((max_y - min_y) - size) * 0.5,
        size,
        imgui.GetColorU32(filled and colors.pin_icon or colors.ghost),
        filled
    )

    if imgui.IsItemHovered() and imgui.SetTooltip then
        imgui.SetTooltip(i18n.t(tooltip))
    end

    return clicked
end

-- An item that was just unpinned: its name, dimmed, and an empty thumbtack.
local function draw_ghost(controller, position)
    local ghost = ghosts[position]

    right_text(
        colors.ghost,
        string.upper(display_name(ghost)),
        ghost.repeatable == true and colors.ghost or nil
    )

    align_right(button_width('>'))

    if pin_button('pin_again_' .. position, false, 'Pin to Tracker') then
        pending_repin = position
    end

    imgui.Spacing()
end

local function draw_ghosts_of(controller, kind)
    for position, ghost in ipairs(ghosts) do
        if ghost.kind == kind then
            draw_ghost(controller, position)
        end
    end
end

local function has_ghosts_of(kind)
    for _, ghost in ipairs(ghosts) do
        if ghost.kind == kind then
            return true
        end
    end

    return false
end

local function draw_pin(controller, index, entry)
    local steps = entry.steps or {}
    local total = #steps
    local step = math.max(1, math.min(entry.step or 1, math.max(total, 1)))

    local lead = nil

    if entry.id ~= nil
        and controller.worldmark ~= nil
        and controller.worldmark.GetIcon ~= nil then

        local kind = nil

        if entry.kind == 'quest' and controller.GetQuestIconKind ~= nil then
            kind = controller.GetQuestIconKind(entry.id)
        elseif entry.kind == 'mission'
            and controller.GetMissionIconKind ~= nil then

            kind = controller.GetMissionIconKind(entry.id, entry.name)
        end

        lead = kind ~= nil and controller.worldmark.GetIcon(kind) or nil
    end

    local name = string.upper(display_name(entry))
    local title_x, title_y, title_w, title_h = right_text(
        colors[entry.kind] or colors.quest,
        name,
        entry.repeatable == true and colors.repeatable or nil,
        lead
    )

    if entry.id ~= nil and controller.OpenPinInJournal ~= nil then
        local clicked, hovered = line_button(
            '##pin_open_' .. index,
            title_x,
            title_y,
            title_w,
            title_h
        )

        if hovered and imgui.SetTooltip then
            imgui.SetTooltip(i18n.t('Opens it in the Journal list'))
        end

        if clicked and not controller.OpenPinInJournal(entry) then
            local chat_print = require('encoding').chat_print
            local found = ''

            if entry.kind == 'mission' and controller.FindPinnedMission ~= nil then
                local area, mission = controller.FindPinnedMission(entry)

                found = mission ~= nil
                    and string.format(' -> %s/%s', tostring(area), tostring(mission.id))
                    or ' -> none'
            end

            if controller.jump_fail then
                found = found .. ' (' .. tostring(controller.jump_fail) .. ')'
            end

            chat_print(string.format(
                i18n.t('[Journal] %s was not found in the Journal list.'),
                name
            ))
            chat_print(string.format(
                '[Journal] kind=%s area=%s id=%s name=%s%s',
                tostring(entry.kind),
                tostring(entry.area),
                tostring(entry.id),
                tostring(entry.name),
                found
            ))
        end
    end

    if total == 0 then
        right_text(colors.next, i18n.t('No steps available.'))
        return
    end

    right_text(colors.next, string.format(i18n.t('Step %d / %d'), step, total))

    text_wrapped(colors.step, step_text(steps[step]), 'p' .. index .. 's', true)

    -- The next step is shown unless the Journal switched it off.
    local show_next =
        controller.GetPinShowNext == nil
        or controller.GetPinShowNext()

    if show_next and steps[step + 1] ~= nil then
        right_text(colors.next, i18n.t('Next:'))
        text_wrapped(colors.next, step_text(steps[step + 1]), 'p' .. index .. 'n', true)
    end

    align_right(
        button_width('<') + ITEM_SPACING_X
            + button_width('>') + ITEM_SPACING_X
            + button_width('>')
    )

    if step_button('<##pin_prev_' .. index) then
        controller.PrevPinStep(index)
    end

    imgui.SameLine()

    if step_button('>##pin_next_' .. index) then
        controller.NextPinStep(index)
    end

    imgui.SameLine()

    if pin_button('pin_toggle_' .. index, true, 'Unpin from Tracker') then
        pending_unpin = index
    end
end

-- Ashita 4.3 takes ImGuiChildFlags as the third argument of BeginChild,
-- Ashita 4.1 the old border boolean.
local CHILD_NO_BORDER = ImGuiChildFlags_None or false

local function begin_child(id, size, flags)
    if flags == nil then
        return imgui.BeginChild(id, size, CHILD_NO_BORDER)
    end

    return imgui.BeginChild(id, size, CHILD_NO_BORDER, flags)
end

-- Height of the stacked items in the last frame, so the child window is
-- only as tall as they need while they fit under the limit.
local stack_height = nil

local function draw_stack_items(controller, pins)
    local groups = group_by_kind(pins, controller)

    for _, kind in ipairs(kinds) do
        local group = groups[kind]

        if #group > 0 or has_ghosts_of(kind) then
            imgui.Separator()
            right_text(colors.section, i18n.t(section_labels[kind]))

            for _, index in ipairs(group) do
                draw_pin(controller, index, pins[index])
                imgui.Spacing()
            end

            draw_ghosts_of(controller, kind)
        end
    end
end

-- max_height 0 lets the tracker grow with every pin. Otherwise the items
-- scroll with the mouse wheel once they are taller than max_height.
local function content_height()
    if imgui.GetContentRegionAvail == nil then
        return nil
    end

    local ok, first, second = pcall(imgui.GetContentRegionAvail)

    if not ok then
        return nil
    end

    if type(first) == 'number' and type(second) == 'number' then
        return second
    end

    if type(first) == 'table' then
        return tonumber(first.y or first[2])
    end

    return nil
end

local function draw_stacked(controller, pins, max_height, window_fixed)
    max_height = tonumber(max_height) or 0

    if window_fixed then
        max_height = M.StackLimit(max_height, content_height())
    end

    if max_height <= 0 or imgui.BeginChild == nil then
        stack_height = nil
        draw_stack_items(controller, pins)
        return
    end

    local height = math.min(stack_height or max_height, max_height)

    imgui.PushStyleColor(ImGuiCol_ChildBg, TRANSPARENT)

    if begin_child('##PinStack', { 0, math.max(1, height) }) then
        draw_stack_items(controller, pins)

        local ok, content = pcall(imgui.GetCursorPosY)

        if ok and tonumber(content) ~= nil then
            stack_height = math.ceil(content) + 2
        end
    end

    imgui.EndChild()
    imgui.PopStyleColor()
end

-- The tab row scrolls sideways when it is wider than the window: the
-- < and > buttons, the mouse wheel over the row, and the active tab
-- brought into view when it changes.
local tab_scroll = { active = nil, step = 0 }

local function draw_tab_buttons(controller, row, active, follow)
    for position, item in ipairs(row) do
        if position > 1 then
            imgui.SameLine()
        end

        if item.separator then
            imgui.TextColored(colors.section, '|')
        else
            local is_active = item.index == active

            if is_active then
                imgui.PushStyleColor(ImGuiCol_Button, colors.tab_active)
            end

            if imgui.SmallButton(item.label .. '##pin_tab_' .. item.index) then
                controller.SetPinActive(item.index)
            end

            if item.full ~= nil
                and item.full ~= item.label
                and imgui.IsItemHovered
                and imgui.IsItemHovered()
                and imgui.SetTooltip then

                imgui.SetTooltip(item.full)
            end

            if is_active then
                imgui.PopStyleColor()

                if follow and imgui.SetScrollHereX then
                    pcall(imgui.SetScrollHereX, 0.5)
                end
            end
        end
    end
end

local function draw_tab_row(controller, row, active)
    local width = 0

    for position, item in ipairs(row) do
        if item.separator then
            width = width + text_width('|')
        else
            width = width + button_width(item.label)
        end

        if position > 1 then
            width = width + ITEM_SPACING_X
        end
    end

    local available = imgui.GetWindowWidth() - WINDOW_PADDING * 2

    if width <= available
        or imgui.BeginChild == nil
        or imgui.SetScrollX == nil
        or imgui.GetScrollX == nil then

        tab_scroll.active = active
        align_right(width)
        draw_tab_buttons(controller, row, active, false)
        return
    end

    local follow = tab_scroll.active ~= active
    tab_scroll.active = active

    local arrow = button_width('<') + ITEM_SPACING_X
    local child_width = math.max(40, available - arrow * 2)
    local height = imgui.GetTextLineHeight() + 2
    local step = math.max(40, child_width * 0.6)
    local move = 0

    imgui.SetCursorPosX(WINDOW_PADDING)

    if step_button('<##pin_tabs_left') then
        move = -step
    end

    imgui.SameLine()
    imgui.PushStyleColor(ImGuiCol_ChildBg, TRANSPARENT)

    if begin_child(
        '##PinTabs',
        { child_width, height },
        ImGuiWindowFlags_NoScrollbar + ImGuiWindowFlags_NoScrollWithMouse
    ) then
        draw_tab_buttons(controller, row, active, follow)

        if move == 0 and imgui.IsWindowHovered and imgui.IsWindowHovered() then
            local ok, wheel = pcall(function()
                return imgui.GetIO().MouseWheel
            end)

            if ok and tonumber(wheel) ~= nil and wheel ~= 0 then
                move = -wheel * step * 0.5
            end
        end

        if tab_scroll.step ~= 0 then
            move = move + tab_scroll.step
            tab_scroll.step = 0
        end

        if move ~= 0 then
            imgui.SetScrollX(math.max(0, imgui.GetScrollX() + move))
        end
    end

    imgui.EndChild()
    imgui.PopStyleColor()

    imgui.SameLine()

    if step_button('>##pin_tabs_right') then
        tab_scroll.step = step
    end
end

local function draw_tabs(controller, pins, active)
    -- The row of tabs, with a bar between missions and quests.
    draw_tab_row(controller, M.TabRow(pins, controller), active)

    local entry = pins[active]

    if entry ~= nil
        and (controller.IsQuestListed == nil or controller.IsQuestListed(entry)) then
        imgui.Separator()
        right_text(colors.section, i18n.t(section_labels[entry.kind] or ''))

        draw_pin(controller, active, entry)
    end

    if #ghosts > 0 then
        imgui.Separator()

        for position = 1, #ghosts do
            draw_ghost(controller, position)
        end
    end
end

-- Does what the thumbtacks asked for in this frame.
local function apply_pending(controller, pins)
    local unpin = pending_unpin
    local repin = pending_repin

    pending_unpin = nil
    pending_repin = nil

    if unpin ~= nil and pins[unpin] ~= nil then
        local entry = pins[unpin]

        ghosts[#ghosts + 1] = {
            kind = entry.kind,
            id = entry.id,
            name = entry.name,
            area = entry.area,
            steps = entry.steps,
            repeatable = entry.repeatable,
            time = os.time(),
        }

        controller.RemovePin(unpin)
    end

    if repin ~= nil and ghosts[repin] ~= nil then
        local ghost = ghosts[repin]

        table.remove(ghosts, repin)

        controller.ToggleItemPin(
            ghost.kind,
            {
                id = ghost.id,
                name = ghost.name,
                area = ghost.area,
                steps = ghost.steps,
            }
        )
    end
end

-- Forgets the items unpinned a while ago, and the ones that are pinned
-- again (from the Journal, for example).
local function prune_ghosts(pins)
    local now = os.time()
    local position = 1

    while position <= #ghosts do
        local ghost = ghosts[position]
        local keep = (now - ghost.time) <= GHOST_SECONDS

        for _, entry in ipairs(pins) do
            if entry.kind == ghost.kind
                and entry.id == ghost.id
                and entry.name == ghost.name then

                keep = false
                break
            end
        end

        if keep then
            position = position + 1
        else
            table.remove(ghosts, position)
        end
    end
end

-- The X at the top right. It hides the tracker through the same visibility
-- setting as the Journal button and /journal pin.
local function draw_close(controller)
    align_right(button_width('X'))

    imgui.PushStyleColor(ImGuiCol_Button, { 0.55, 0.55, 0.55, 0.45 })
    imgui.PushStyleColor(ImGuiCol_ButtonHovered, { 0.85, 0.45, 0.45, 0.75 })
    imgui.PushStyleColor(ImGuiCol_ButtonActive, { 0.75, 0.30, 0.30, 0.90 })
    imgui.PushStyleColor(ImGuiCol_Text, { 1.00, 1.00, 1.00, 1.00 })

    local clicked = imgui.SmallButton('X##pin_close')

    imgui.PopStyleColor(4)

    if imgui.IsItemHovered() and imgui.SetTooltip then
        imgui.SetTooltip(i18n.t('Hide the Tracker'))
    end

    if clicked and controller.SetPinVisible ~= nil then
        controller.SetPinVisible(false)
    end
end

function M.Draw(controller, can_draw)
    if controller == nil
        or controller.GetPinState == nil then
        return
    end

    if can_draw ~= nil and not can_draw() then
        return
    end

    local pin = controller.GetPinState()

    if pin == nil or not pin.visible then
        size_placed = false
        size_refit = 0
        height_lock = nil
        height_lock_frames = 0
        seen_w, seen_h = nil, nil

        return
    end

    local pins = controller.GetPins() or {}

    prune_ghosts(pins)

    if controller.GetStyles ~= nil then
        styles = controller.GetStyles()
    end

    -- Clicking an NPC name points the compass at it.
    click_npc = controller.AddCompassNpcByName

    -- "Reset window positions" in the settings.
    if last_reset_count == nil then
        last_reset_count = pin.reset_count
    elseif pin.reset_count ~= last_reset_count then
        last_reset_count = pin.reset_count
        restore_window = true
    end

    if restore_window then
        if pin.x ~= nil and pin.y ~= nil then
            imgui.SetNextWindowPos({ pin.x, pin.y })
        end

        restore_window = false
    end

    -- Tracker size and the tracker's own text scale. The Journal text
    -- size is not read here. Width follows the tracker size. A height the
    -- player already has is kept; text that no longer fits scrolls.
    local layout = M.LayoutScale(pin)
    local scale = layout.scale

    current_size = layout.font

    local text_changed = applied_text ~= nil
        and math.abs(layout.text_scale - applied_text) > 0.001
    local width_changed = applied_scale ~= nil
        and math.abs(layout.size_scale - applied_scale) > 0.001

    applied_text = layout.text_scale

    -- The settings stepper (and /journal pin size) changed the width.
    -- Apply that width once. A drag updates the same scale, so it does
    -- not come back through here and fight the mouse.
    if width_changed then
        size_placed = false
        seen_w = nil
        applied_scale = layout.size_scale
        size_refit = 0
    end

    if applied_scale == nil then
        applied_scale = layout.size_scale
    end

    -- Text size or tracker size: hold the height the player already set.
    -- Never fit the window to the text, which would pull the top and
    -- bottom in when the new lines are shorter.
    if (text_changed or width_changed) and height_lock_frames == 0 then
        local keep = tonumber(pin.height) or tonumber(seen_h)

        if keep ~= nil and keep == keep and keep > 0 and keep ~= math.huge then
            height_lock = keep
            height_lock_frames = 3
        end
    end

    -- No saved height yet: fit the content for a few frames, then keep it.
    -- Once a height is saved, including one the player dragged, a change
    -- in the pinned list must not fit the window again. Extra rows scroll.
    if pin.height ~= nil or height_lock ~= nil then
        size_refit = 0
    elseif not size_placed and size_refit == 0 then
        size_refit = 3
    end

    local fitting = size_refit > 0 and height_lock == nil

    if height_lock ~= nil and (height_lock_frames > 0 or not size_placed) then
        imgui.SetNextWindowSize({ layout.width, height_lock })
    elseif fitting then
        imgui.SetNextWindowSize({ layout.width, 0 })
    elseif not size_placed and pin.height ~= nil then
        imgui.SetNextWindowSize({ layout.width, pin.height })
    end

    size_placed = true

    if imgui.SetNextWindowSizeConstraints then
        imgui.SetNextWindowSizeConstraints(
            { WINDOW_WIDTH * 0.60, 80 },
            { WINDOW_WIDTH * 2.00, 1200 }
        )
    end

    -- Opacity of the text and the background set in the settings. The
    -- background is transparent by default, and there is no border.
    current_opacity = tonumber(pin.opacity) or 1.0

    local alpha_pushed = false

    if ImGuiStyleVar_Alpha ~= nil then
        imgui.PushStyleVar(ImGuiStyleVar_Alpha, current_opacity)
        alpha_pushed = true
    end

    imgui.PushStyleColor(
        ImGuiCol_WindowBg,
        { 0, 0, 0, tonumber(pin.background) or 0 }
    )
    imgui.PushStyleColor(ImGuiCol_Border, { 0, 0, 0, 0 })

    -- The corner grip stays invisible until the mouse is over it.
    imgui.PushStyleColor(ImGuiCol_ResizeGrip, TRANSPARENT)
    imgui.PushStyleColor(ImGuiCol_ResizeGripHovered, { 0.80, 0.84, 0.95, 0.55 })
    imgui.PushStyleColor(ImGuiCol_ResizeGripActive, { 0.80, 0.84, 0.95, 0.85 })

    local open = { true }
    local flags = ImGuiWindowFlags_NoTitleBar
        + ImGuiWindowFlags_NoSavedSettings
        + ImGuiWindowFlags_NoCollapse

    -- While the window is still fitting its content it must not scroll.
    -- A height the player set stays put, and extra lines scroll.
    if fitting or (pin.height == nil and height_lock == nil) then
        flags = flags + ImGuiWindowFlags_NoScrollbar
    end

    if imgui.Begin(
        'Pinned Tracker###JournalPinned',
        open,
        flags
    ) then
        -- Everything in the window, headers and buttons included, is set
        -- in the text font at the scaled size. Without that font the
        -- window font scale is used instead.
        local fonts = richtext.fonts or {}
        local regular = fonts.regular
        local pushed_font = false

        current_bold = pin.bold == true
        fake_bold = current_bold and fonts.bold == nil

        if current_bold and fonts.bold ~= nil then
            regular = fonts.bold
        end

        if regular ~= nil then
            imgui.PushFont(regular, current_size)
            pushed_font = true
        elseif imgui.SetWindowFontScale ~= nil then
            pcall(imgui.SetWindowFontScale, scale)
        end

        draw_close(controller)

        if #pins == 0 and #ghosts == 0 then
            right_text(
                colors.next,
                i18n.t('Nothing pinned. Use "Pin to Tracker" in the Journal.')
            )
        elseif pin.mode == 'tabs' then
            draw_tabs(controller, pins, pin.active)
        else
            draw_stacked(controller, pins, pin.stack_max, pin.height ~= nil)
        end

        apply_pending(controller, pins)

        if pushed_font then
            imgui.PopFont()
        end

        local x, y = imgui.GetWindowPos()

        if x ~= pin.x or y ~= pin.y then
            controller.SetPinGeometry(x, y)
        end

        local window_width, window_height = imgui.GetWindowSize()

        -- The fit of the first frames, then whatever the player drags.
        -- Width is stored as the tracker size, so the settings stepper
        -- shows the same value. Height is stored on its own. A text-size
        -- or tracker-size change does not store a shorter height.
        if height_lock ~= nil and height_lock_frames > 0 then
            height_lock_frames = height_lock_frames - 1

            if controller.SetPinScale and (
                seen_w == nil or math.abs(window_width - seen_w) > 2
            ) then
                applied_scale = controller.SetPinScale(
                    window_width / WINDOW_WIDTH
                )
            end

            local kept = M.HoldHeight(height_lock, window_height)

            if controller.SetPinHeight and pin.height ~= kept then
                controller.SetPinHeight(kept)
            end

            seen_w = window_width
            seen_h = kept

            if height_lock_frames == 0 then
                height_lock = nil
            end
        elseif size_refit > 0 then
            size_refit = size_refit - 1

            if size_refit == 0 and controller.SetPinHeight then
                controller.SetPinHeight(window_height)
                seen_w, seen_h = window_width, window_height
            end
        elseif controller.SetPinScale and controller.SetPinHeight then
            local width_changed = seen_w == nil
                or math.abs(window_width - seen_w) > 2
            local height_changed = seen_h == nil
                or math.abs(window_height - seen_h) > 2

            if width_changed or height_changed then
                if width_changed then
                    applied_scale = controller.SetPinScale(
                        window_width / WINDOW_WIDTH
                    )
                end

                if height_changed then
                    controller.SetPinHeight(window_height)
                end

                seen_w, seen_h = window_width, window_height
            end
        end
    end

    imgui.End()
    imgui.PopStyleColor(5)

    if alpha_pushed then
        imgui.PopStyleVar(1)
    end
end

return M
