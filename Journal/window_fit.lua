-- Clamp / fit ImGui windows to the available display without fighting the user.

local M = {}

local last_w, last_h = nil, nil

local function read_size(size)
    if type(size) == 'table' then
        local x = size[1] or size.x or size.X
        local y = size[2] or size.y or size.Y
        if type(x) == 'number' and type(y) == 'number' and x > 0 and y > 0 then
            return x, y
        end
    end
    return nil
end

function M.get_display_size(imgui)
    if imgui == nil then
        return nil
    end

    if imgui.GetIO ~= nil then
        local ok, io = pcall(imgui.GetIO)
        if ok and io ~= nil then
            local ok_size, size = pcall(function()
                return io.DisplaySize
            end)
            if ok_size then
                local w, h = read_size(size)
                if w ~= nil then
                    return w, h
                end
            end
        end
    end

    if imgui.GetMainViewport ~= nil then
        local ok, viewport = pcall(imgui.GetMainViewport)
        if ok and viewport ~= nil then
            local ok_size, size = pcall(function()
                return viewport.Size
            end)
            if ok_size then
                local w, h = read_size(size)
                if w ~= nil then
                    return w, h
                end
            end
            local ok_work, work = pcall(function()
                return viewport.WorkSize
            end)
            if ok_work then
                local w, h = read_size(work)
                if w ~= nil then
                    return w, h
                end
            end
        end
    end

    return nil
end

function M.display_changed(imgui)
    local w, h = M.get_display_size(imgui)
    if w == nil then
        return false, nil, nil
    end
    local changed = last_w ~= w or last_h ~= h
    last_w, last_h = w, h
    return changed, w, h
end

-- Preferred default size that fits inside the display.
function M.default_size(display_w, display_h, margin)
    margin = margin or 40
    local max_w = math.max(320, display_w - margin * 2)
    local max_h = math.max(240, display_h - margin * 2)
    local w = math.min(1100, max_w)
    local h = math.min(720, max_h)
    return w, h
end

-- Fit: use up to fit_ratio of the display (default 0.92).
function M.fit_size(display_w, display_h, margin, fit_ratio)
    margin = margin or 24
    fit_ratio = fit_ratio or 0.92
    local max_w = math.max(320, display_w - margin * 2)
    local max_h = math.max(240, display_h - margin * 2)
    return math.floor(max_w * fit_ratio + 0.5), math.floor(max_h * fit_ratio + 0.5)
end

-- Clamp position+size so the window stays usable on screen.
-- min_w/min_h are soft floors (still reduced if display is smaller).
function M.clamp_geometry(x, y, w, h, display_w, display_h, margin, min_w, min_h)
    margin = margin or 16
    min_w = min_w or 400
    min_h = min_h or 300

    local max_w = math.max(200, display_w - margin * 2)
    local max_h = math.max(160, display_h - margin * 2)
    min_w = math.min(min_w, max_w)
    min_h = math.min(min_h, max_h)

    w = tonumber(w) or max_w
    h = tonumber(h) or max_h
    if w > max_w then w = max_w end
    if h > max_h then h = max_h end
    if w < min_w then w = min_w end
    if h < min_h then h = min_h end

    if x == nil then x = margin end
    if y == nil then y = margin end
    x = tonumber(x) or margin
    y = tonumber(y) or margin

    -- Keep title bar reachable: at least margin of the window on-screen.
    local min_visible = 48
    if x + w < min_visible then
        x = min_visible - w
    end
    if y + min_visible > display_h then
        y = display_h - min_visible
    end
    if x > display_w - min_visible then
        x = display_w - min_visible
    end
    if y < 0 then
        y = margin
    end
    if x < 0 then
        x = margin
    end
    if x + w > display_w - margin then
        x = math.max(margin, display_w - margin - w)
    end
    if y + h > display_h - margin then
        y = math.max(margin, display_h - margin - h)
    end

    return math.floor(x + 0.5), math.floor(y + 0.5), math.floor(w + 0.5), math.floor(h + 0.5)
end

-- Settings window size: a saved manual size wins over the font-scaled
-- default. Missing or invalid values use the default. Both are clamped
-- to the display when one is known. Returns width, height, using_saved.
function M.resolve_saved_size(saved_w, saved_h, default_w, default_h, display_w, display_h, margin, min_w, min_h)
    local function positive(value)
        value = tonumber(value)
        if value == nil or value ~= value or value <= 0
            or value == math.huge or value == -math.huge then
            return nil
        end
        return value
    end

    saved_w = positive(saved_w)
    saved_h = positive(saved_h)
    local using_saved = saved_w ~= nil and saved_h ~= nil
    local w = using_saved and saved_w or (positive(default_w) or 480)
    local h = using_saved and saved_h or (positive(default_h) or 640)

    display_w = positive(display_w)
    display_h = positive(display_h)
    if display_w ~= nil and display_h ~= nil then
        local _, _, cw, ch = M.clamp_geometry(
            margin or 16,
            margin or 16,
            w,
            h,
            display_w,
            display_h,
            margin or 16,
            min_w or 240,
            min_h or 180
        )
        return cw, ch, using_saved
    end

    return math.floor(w + 0.5), math.floor(h + 0.5), using_saved
end

-- First size after open is the restored/default size and is not saved.
-- A later change is a manual resize and should be persisted.
function M.note_settings_resize(seen_w, seen_h, width, height)
    width = tonumber(width)
    height = tonumber(height)
    if width == nil or height == nil then
        return seen_w, seen_h, false
    end
    if seen_w == nil or seen_h == nil then
        return width, height, false
    end
    if math.abs(width - seen_w) > 1 or math.abs(height - seen_h) > 1 then
        return width, height, true
    end
    return seen_w, seen_h, false
end

-- Inner split of the Journal book. The details pane is a fraction of the
-- window width and the list takes the rest, minus a fixed gap. 0.32 is the
-- historical fraction: until the player drags, the panes stay that size.
M.JOURNAL_DETAILS_RATIO = 0.32
M.JOURNAL_PANE_GAP = 10

-- Floors the default split already clears at the journal's smallest window
-- (360). A saved fraction that no longer fits is clamped to these floors.
-- If the window cannot hold both floors, they shrink together.
local JOURNAL_MIN_LIST = 180
local JOURNAL_MIN_DETAILS = 96

local function finite_number(value)
    value = tonumber(value)
    if value == nil or value ~= value or value == math.huge or value == -math.huge then
        return nil
    end
    return value
end

-- A saved fraction in (0, 1). Anything else means "use the default".
function M.normalize_journal_ratio(value)
    value = finite_number(value)
    if value == nil or value <= 0 or value >= 1 then
        return nil
    end
    return value
end

local function clamp_journal_panes(content_width, details)
    local gap = M.JOURNAL_PANE_GAP
    local available = content_width - gap

    if available < 2 then
        local list = math.max(0, content_width - gap)
        if list < 1 and content_width > 0 then
            return content_width, 0
        end
        return list, math.max(0, available - list)
    end

    local min_list = JOURNAL_MIN_LIST
    local min_details = JOURNAL_MIN_DETAILS

    if min_list + min_details > available then
        local scale = available / (min_list + min_details)
        min_list = math.max(1, math.floor(min_list * scale))
        min_details = available - min_list
        if min_details < 1 then
            min_details = 1
            min_list = available - 1
        end
    end

    if details < min_details then
        details = min_details
    elseif details > available - min_list then
        details = available - min_list
    end

    return available - details, details
end

-- list width, details width. ratio nil (or invalid) is the 0.32 default.
function M.journal_panes(content_width, ratio)
    content_width = finite_number(content_width)
    if content_width == nil or content_width <= 0 then
        return 0, 0
    end
    content_width = math.floor(content_width)

    local desired
    local normalized = M.normalize_journal_ratio(ratio)
    if normalized == nil then
        desired = math.floor(content_width * M.JOURNAL_DETAILS_RATIO)
    else
        -- The extra millionth keeps a ratio built from (pixels + 0.5) / width
        -- on the same pixel after it is stored and read back.
        desired = math.floor(content_width * normalized + 1e-6)
    end

    return clamp_journal_panes(content_width, desired)
end

-- Fraction that journal_panes will turn back into this details width,
-- after the same clamp. Nil when the width is not usable.
function M.journal_ratio_for_details(content_width, details)
    content_width = finite_number(content_width)
    details = finite_number(details)
    if content_width == nil or content_width < 1 or details == nil then
        return nil
    end
    content_width = math.floor(content_width)

    local _, clamped = clamp_journal_panes(content_width, details)
    local ratio = (clamped + 0.5) / content_width
    ratio = math.floor(ratio * 1000000 + 0.5) / 1000000
    if ratio <= 0 then
        ratio = 0.000001
    elseif ratio >= 1 then
        ratio = 0.999999
    end
    return ratio
end

-- True when saved size clearly exceeds the display (needs auto-fit).
function M.needs_auto_fit(w, h, display_w, display_h, margin)
    margin = margin or 16
    w = tonumber(w) or 0
    h = tonumber(h) or 0
    if display_w == nil or display_h == nil then
        return false
    end
    return w > display_w - margin or h > display_h - margin or w <= 0 or h <= 0
end

return M
