-- Isolated Journal alert volume boundary; no loud fallback on scaling failure.
local M = {}
local missing_sound = {}
local sound_gain = require('sound_gain')
local chat_print = require('encoding').chat_print
local tx = require('i18n').t
function M.play(entry, controller, addon)
    if ashita == nil or ashita.misc == nil
        or ashita.misc.play_sound == nil then

        return
    end

    local file = (entry.done and 'complete_' or 'new_')
        .. (entry.kind == 'mission' and 'mission' or 'quest')
        .. '.wav'

    if entry.near then
        file = 'nearby_quest.wav'
    end

    local base = tostring(addon and addon.path or '')

    if base ~= '' and not base:match('[\\/]$') then
        base = base .. '/'
    end

    local src = base .. 'assets/sounds/' .. file

    if ashita.fs ~= nil and ashita.fs.exists ~= nil
        and not ashita.fs.exists(src) then

        -- nearby_quest.wav is optional and is not in the upstream package
        -- or this one. The alert stays silent, without a chat warning.
        if file ~= 'nearby_quest.wav' and not missing_sound[file] then
            missing_sound[file] = true

            chat_print(string.format(
                tx('[Journal] Alert sound not found: assets/sounds/%s'),
                file
            ))
        end

        return
    end

    local volume = 100

    if controller ~= nil and controller.GetAlertSoundVolume ~= nil then
        volume = controller.GetAlertSoundVolume() or 100
    end

    local path = sound_gain.resolve(src, volume)

    -- Volume 0 mutes (resolve returns nil). Sound toggle is checked by caller.
    if path == nil then
        return
    end

    pcall(ashita.misc.play_sound, path)
end

-- The text sizes are baked into the font, so any size is pushed with it.
return M
