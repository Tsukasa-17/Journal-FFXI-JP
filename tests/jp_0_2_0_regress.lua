-- jpver 0.2.0 regression mocks. No game, packets, or host UI.
local fails = 0
local function check(name, ok)
    if ok then
        io.write('PASS ', name, '\n')
    else
        fails = fails + 1
        io.write('FAIL ', name, '\n')
    end
end

package.path = '/workspace/Journal/?.lua;/workspace/Journal/?/init.lua;' .. package.path
T = function(t) return t or {} end

local wf = require('window_fit')
local i18n = require('i18n')
i18n.set_language('ja')

local rov_ctx = { kind = 'mission', area = 'rov', id = 130 }
check('rov 130 title', i18n.step('Eddies of Despair', rov_ctx) == '害毒の渦')
check('rov 232 title', i18n.step('Eddies of Despair', {
    kind = 'mission', area = 'rov', id = 232,
}) == '迷宮の渦')
check('no global eddies map', i18n.step('Eddies of Despair') == 'Eddies of Despair')
check('id 130 alone', i18n.step('Eddies of Despair', 130) == '害毒の渦')
check('id 232 alone', i18n.step('Eddies of Despair', 232) == '迷宮の渦')
check('wrong area stays english', i18n.step('Eddies of Despair', {
    kind = 'mission', area = 'bastok', id = 130,
}) == 'Eddies of Despair')
check('wrong kind stays english', i18n.step('Eddies of Despair', {
    kind = 'quest', area = 'rov', id = 130,
}) == 'Eddies of Despair')
check('resonance still global', i18n.step('Resonance', {
    kind = 'mission', area = 'rov', id = 110,
}) == '鳴くはクリスタル')

local forms130 = i18n.search_forms('Eddies of Despair', rov_ctx)
local forms232 = i18n.search_forms('Eddies of Despair', {
    kind = 'mission', area = 'rov', id = 232,
})
local forms_plain = i18n.search_forms('Eddies of Despair')
local function has(list, text)
    for _, item in ipairs(list) do
        if item == text then return true end
    end
    return false
end
check('search 130', has(forms130, '害毒の渦') and not has(forms130, '迷宮の渦'))
check('search 232', has(forms232, '迷宮の渦') and not has(forms232, '害毒の渦'))
check('search without id', not has(forms_plain, '害毒の渦') and not has(forms_plain, '迷宮の渦'))

local missions = require('data.missions')
local step130 = missions.MISSIONS.rov[130].steps[1]
local step232 = missions.MISSIONS.rov[232].steps[4]
check('rov 130 step cleaned', step130 == 'After defeating Ophiotaurus, examine Undulating Confluence (G-8) again.')
check('rov 130 step ja', i18n.step(step130) == 'Ophiotaurusを倒したら、Undulating Confluence(G-8)を再度調べる。')
check('rov 232 last step ja', i18n.step(step232) == 'Eschan Portal #15(H-12)の光る「???」を調べる。')
check('english source kept', missions.MISSIONS.rov[130].name == 'Eddies of Despair')
check('ids kept', missions.MISSIONS.rov[130] ~= nil and missions.MISSIONS.rov[232] ~= nil)

local words = require('data.translations_ja')
check('clean conflict kept',
    words['Examine Transcendental Radiance.'] == 'Transcendental Radiance を調べる。'
    and words['Examine Transcendental Radiance.'] ~= words['Examine Transcendental Radiance..'])

package.preload['imgui'] = function() return {} end
local pinned = require('pinned')
local pins = {
    { kind = 'quest', id = 4, name = 'Chocobo on the Loose!', area = 'jeuno' },
    { kind = 'mission', id = 17, name = "The Pirates' Cove", area = 'bastok' },
    { kind = 'quest', id = 13, name = 'Lure of the Wildcat (Bastok)', area = 'bastok' },
    { kind = 'quest', id = 81, name = 'Out of the Depths', area = 'bastok' },
}
local row = pinned.TabRow(pins)
local tabs = {}
for _, item in ipairs(row) do
    if not item.separator then
        tabs[#tabs + 1] = item
    end
end
check('tab order mission then quests',
    tabs[1].index == 2 and tabs[2].index == 1 and tabs[3].index == 3 and tabs[4].index == 4)
check('tab pirate ja', tabs[1].label == '海賊たちの唄' and tabs[1].id == '海賊たちの唄##pin_tab_2')
check('tab lure ja', tabs[3].label == '山猫の誘惑')
check('tab lure names differ',
    pinned.TabSpec({ kind = 'quest', id = 23, name = "Lure of the Wildcat (San d'Oria)", area = 'sandoria' }).label
        ~= pinned.TabSpec({ kind = 'quest', id = 83, name = 'Lure of the Wildcat (Windurst)', area = 'windurst' }).label)
check('tab not english prefix',
    not tabs[1].label:find('THE PIRAT') and not tabs[3].label:find('LURE OF'))
local depth = pinned.TabSpec(pins[4], 4)
check('tab utf8 ellipsis', depth.label:sub(-3) == '...' and depth.full == '暗き地の底より' and depth.id:find('##pin_tab_4$', 1, false) ~= nil)
local base = pinned.LayoutScale({ scale = 1, text_scale = 1 })
local big = pinned.LayoutScale({ scale = 1, text_scale = 1.4 })
local half = pinned.LayoutScale({ scale = 2, text_scale = 0.5 })
check('tracker scale default', base.font == 16 and base.width == 420)
check('tracker scale 140', math.abs(big.font - 22.4) < 0.001 and math.abs(big.width - 588) < 0.001)
check('tracker scale keeps wrap ratio', math.abs((big.font / big.width) - (base.font / base.width)) < 0.0001)
check('tracker size and text multiply', half.font == 16 and half.width == 420)

local dw, dh, saved = wf.resolve_saved_size(nil, nil, 480, 640, 1920, 1080, 16, 240, 180)
check('settings default', dw == 480 and dh == 640 and saved == false)
local sw, sh, used = wf.resolve_saved_size(700, 800, 672, 896, 1920, 1080, 16, 240, 180)
check('settings saved ignores font default', sw == 700 and sh == 800 and used == true)
local small_w, small_h = wf.resolve_saved_size(nil, nil, 240, 320, 1920, 1080, 16, 240, 180)
check('settings default follows scale', small_w == 240 and small_h == 320)
local bad_w, bad_h, bad_used = wf.resolve_saved_size('no', -1, 480, 640, 1920, 1080, 16, 240, 180)
check('settings invalid uses default', bad_w == 480 and bad_h == 640 and bad_used == false)
local zero_w, zero_h, zero_used = wf.resolve_saved_size(0, 100, 480, 640, 1920, 1080, 16, 240, 180)
check('settings zero invalid', zero_w == 480 and zero_h == 640 and zero_used == false)
local cw, ch, cused = wf.resolve_saved_size(5000, 5000, 480, 640, 800, 600, 16, 240, 180)
check('settings screen clamp', cused == true and cw <= 800 - 16 and ch <= 600 - 16 and cw >= 240 and ch >= 180)
local seen_w, seen_h, save = wf.note_settings_resize(nil, nil, 480, 640)
check('open does not save default', save == false and seen_w == 480)
seen_w, seen_h, save = wf.note_settings_resize(seen_w, seen_h, 480, 640)
check('steady size does not save', save == false)
seen_w, seen_h, save = wf.note_settings_resize(seen_w, seen_h, 730, 810)
check('resize requests save', save == true and seen_w == 730 and seen_h == 810)
local again_w, again_h, again_used = wf.resolve_saved_size(730, 810, 480, 640, 1920, 1080, 16, 240, 180)
check('reopen uses resized', again_w == 730 and again_h == 810 and again_used == true)

local config = {
    journal_text_scale = 0.79,
    pin_scale = 1.5,
    pin_text_scale = nil,
    announce_prox_compass = true,
    journal_width = 1000,
    journal_height = 700,
    journal_x = 30,
    journal_y = 40,
}
local handler
package.preload['settings'] = function()
    return {
        load = function() return config end,
        register = function(_, _, fn) handler = fn end,
        save = function() return true end,
    }
end
ashita = { events = { register = function() end } }
local logic = require('logic')
logic.Initialize()
check('pin text default', math.abs(logic.GetPinTextScale() - 1) < 0.0001)
check('journal scale kept', math.abs(logic.GetTextScale() - 0.79) < 0.0001)
check('pin scale kept', math.abs(logic.GetPinScale() - 1.5) < 0.0001)
check('prox compass default on', logic.GetProxCompass() == true)
logic.SetPinTextScale(1.4)
check('pin text 140', math.abs(logic.GetPinTextScale() - 1.4) < 0.0001)
check('journal scale independent', math.abs(logic.GetTextScale() - 0.79) < 0.0001)
check('pin scale independent', math.abs(logic.GetPinScale() - 1.5) < 0.0001)
check('prox compass untouched', logic.GetProxCompass() == true)
check('pin text low bound', math.abs(logic.SetPinTextScale(0.2) - 0.5) < 0.0001)
check('pin text high bound', math.abs(logic.SetPinTextScale(2) - 1.4) < 0.0001)
check('pin text 79 kept', math.abs(logic.SetPinTextScale(0.79) - 0.79) < 0.0001)
check('pin text step', math.abs(logic.AdjustPinTextScale(1) - 0.84) < 0.0001)

check('settings size missing', logic.GetSettingsWindowSize() == nil)
logic.SetSettingsWindowSize(730, 810)
local gw, gh = logic.GetSettingsWindowSize()
check('settings size set', gw == 730 and gh == 810)
logic.FitJournalToScreen(1920, 1080)
gw, gh = logic.GetSettingsWindowSize()
local journal = logic.GetJournalWindowState()
check('screen fit does not stomp settings size', gw == 730 and gh == 810)
check('screen fit still moves journal', journal.width ~= 1000 or journal.height ~= 700)
logic.SetTextScale(1.2)
gw, gh = logic.GetSettingsWindowSize()
check('font scale does not stomp settings size', gw == 730 and gh == 810)
check('invalid settings size rejected', logic.SetSettingsWindowSize(0, 10) == false)
check('huge settings size rejected', logic.SetSettingsWindowSize(20000, 10) == false)
gw, gh = logic.GetSettingsWindowSize()
check('rejected size not stored', gw == 730 and gh == 810)

logic.Unload()
check('saved pin text', math.abs(config.pin_text_scale - logic.GetPinTextScale()) < 0.0001)
check('saved settings size', config.settings_width == 730 and config.settings_height == 810)
check('saved journal scale', math.abs(config.journal_text_scale - 1.2) < 0.0001)
check('saved prox compass', config.announce_prox_compass == true)

local other = {
    journal_text_scale = 1.1,
    pin_scale = 0.8,
    pin_text_scale = 0.55,
    settings_width = 640,
    settings_height = 900,
    announce_prox_compass = false,
    journal_width = 900,
    journal_height = 600,
}
handler(other)
check('char settings size', logic.GetSettingsWindowSize() == 640)
local _, chh = logic.GetSettingsWindowSize()
check('char settings height', chh == 900)
check('char pin text', math.abs(logic.GetPinTextScale() - 0.55) < 0.0001)
check('char journal text', math.abs(logic.GetTextScale() - 1.1) < 0.0001)
check('char prox off', logic.GetProxCompass() == false)

local broken = {
    journal_text_scale = 0.9,
    pin_scale = 1.2,
    pin_text_scale = 1,
    settings_width = 'no',
    settings_height = -5,
    announce_prox_compass = true,
    journal_x = 12,
    journal_y = 18,
}
handler(broken)
check('invalid loaded size clears', logic.GetSettingsWindowSize() == nil)
check('invalid load keeps journal scale', math.abs(logic.GetTextScale() - 0.9) < 0.0001)
check('invalid load keeps position fields', logic.GetJournalWindowState().x == 12)

local credit = require('jp_credit')
check('jp credit 0.2.0', credit.version == '0.2.0' and credit.display('0.3.0'):find('0.3.0', 1, true) ~= nil)
local journal_src = io.open('/workspace/Journal/journal.lua'):read('*a')
check('addon version 0.3.0', journal_src:find("addon.version = '0.3.0'", 1, true) ~= nil)
check('addon author kxteel', journal_src:find("addon.author  = 'Kxteel'", 1, true) ~= nil)
local logic_src = io.open('/workspace/Journal/logic.lua'):read('*a')
check('no new compass setting', logic_src:find('prox_compass_open', 1, true) == nil)
check('compass auto open remains', logic_src:find('M.SetCompassOpen(true)', 1, true) ~= nil)
local readme = io.open('/workspace/Journal/README.md'):read('*a')
check('readme test candidate', readme:find('試験候補', 1, true) ~= nil)
check('readme keeps 0.1.0 release', readme:find('jp-v0.1.0', 1, true) ~= nil)
check('readme no 0.2.0 release url', readme:find('releases/download/jp-v0.2.0', 1, true) == nil)
check('readme names settings keys', readme:find('settings_width', 1, true) ~= nil and readme:find('pin_text_scale', 1, true) ~= nil)

local function count_keys(path)
    local n = 0
    for line in io.lines(path) do
        if line:find('^%s*%[', 1) then n = n + 1 end
    end
    return n
end
check('translation keys 7692', count_keys('/workspace/Journal/data/translations_ja.lua') == 7692)
check('ui keys 361', count_keys('/workspace/Journal/data/ui_ja.lua') == 361)

if fails > 0 then
    io.write('FAILED ', fails, '\n')
    os.exit(1)
end
io.write('ALL PASS\n')
