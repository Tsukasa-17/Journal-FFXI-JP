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
