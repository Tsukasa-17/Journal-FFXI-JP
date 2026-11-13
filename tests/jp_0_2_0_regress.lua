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
local big = pinned.LayoutScale({ scale = 1, text_scale = 2 })
local wide = pinned.LayoutScale({ scale = 2, text_scale = 1 })
local half = pinned.LayoutScale({ scale = 2, text_scale = 0.5 })
check('tracker scale default', base.font == 16 and base.width == 420)
check('tracker text 200 keeps width', big.font == 32 and big.width == 420)
check('tracker window size keeps text', wide.font == 16 and wide.width == 840)
check('tracker size and text independent', half.font == 8 and half.width == 840)
local huge = pinned.LayoutScale({ scale = 1.5, text_scale = 4 })
check('tracker text 400 keeps width', huge.font == 64 and huge.width == 630 and huge.text_scale == 4)
local function columns(text)
    local width = 0
    local index = 1
    while index <= #text do
        local last = require('style_ja').char_end(text, index)
        width = width + (text:byte(index) < 128 and 1 or 2)
        index = last + 1
    end
    return width
end
local cjk = pinned.FitLines('あいうえお', 4, columns)
check('wrap cjk pairs', cjk[1] == 'あい' and cjk[2] == 'うえ' and cjk[3] == 'お' and #cjk == 3)
local wrapped = pinned.FitLines('one two three', 7, columns)
check('wrap english words', wrapped[1] == 'one two' and wrapped[2] == 'three')
local fits = pinned.FitLines('short', 40, columns)
check('wrap keeps short line', #fits == 1 and fits[1] == 'short')
local hard = pinned.FitLines('Hello', 3, columns)
check('wrap long word', hard[1] == 'Hel' and hard[2] == 'lo')
check('stack limit off', pinned.StackLimit(0, nil) == 0)
check('stack limit kept', pinned.StackLimit(480, nil) == 480)
check('stack limit fits window', pinned.StackLimit(480, 200) == 184)
check('stack limit window only', pinned.StackLimit(0, 400) == 384)
check('stack limit smaller cap', pinned.StackLimit(200, 500) == 200)
check('tab english not upper',
    pinned.TabSpec({ kind = 'quest', id = 'x', name = 'No Such Quest' }, 9).label == 'No Such Q...')
check('tab loose case',
    pinned.TabSpec({ kind = 'mission', id = 'x', name = "the pirates' cove" }, 1).full == '海賊たちの唄')
check('tab loose suffix',
    pinned.TabSpec({ kind = 'mission', id = 'x', name = "The Pirates' Cove (Bastok)" }, 1).full == '海賊たちの唄')

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
    journal_quest_category = 8,
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
check('pin hidden on load', logic.GetPinState().visible == false)
local quest_tabs = logic.GetQuestCategories()
check('catseye tab last', quest_tabs[#quest_tabs] == 'catseye' and quest_tabs[#quest_tabs - 1] == 'crystal_war' and quest_tabs[1] == 'all')
check('catseye label', logic.GetQuestCategoryNames().catseye == 'CatsEye')
check('saved category stays crystal war', logic.GetQuestSelection().category_index == 9 and quest_tabs[9] == 'crystal_war')
check('pin text migrated from size', math.abs(logic.GetPinTextScale() - 1.5) < 0.0001)
check('pin layout marked', config.pin_layout_v2 == true)
check('pin bold default off', logic.GetPinBold() == false)
check('pin stack default off', logic.GetPinStackMax() == 0)
check('pin stack low', logic.SetPinStackMax(50) == 200)
check('pin stack high', logic.SetPinStackMax(5000) == 960)
check('pin stack step down', logic.AdjustPinStackMax(-1) == 920)
logic.SetPinStackMax(200)
check('pin stack off from min', logic.AdjustPinStackMax(-1) == 0)
check('pin stack on from off', logic.AdjustPinStackMax(1) == 200)
check('pin stack invalid', logic.SetPinStackMax('no') == 0)
logic.SetPinStackMax(480)
check('pin bold on', logic.SetPinBold(true) == true and logic.GetPinState().bold == true)
check('pin state stack', logic.GetPinState().stack_max == 480)
check('journal scale kept', math.abs(logic.GetTextScale() - 0.79) < 0.0001)
check('pin scale kept', math.abs(logic.GetPinScale() - 1.5) < 0.0001)
check('pin height starts unset', logic.GetPinHeight() == nil and logic.GetPinState().height == nil)
check('pin height low', logic.SetPinHeight(10) == 80)
check('pin height high', logic.SetPinHeight(5000) == 1200)
check('pin height kept', logic.SetPinHeight(360) == 360 and logic.GetPinState().height == 360)
check('pin height leaves scale', math.abs(logic.GetPinScale() - 1.5) < 0.0001)
check('pin height leaves text', math.abs(logic.GetPinTextScale() - 1.5) < 0.0001)
check('pin height clear', logic.SetPinHeight(nil) == nil and logic.GetPinHeight() == nil)
check('prox compass default on', logic.GetProxCompass() == true)
logic.SetPinTextScale(1.4)
check('pin text 140', math.abs(logic.GetPinTextScale() - 1.4) < 0.0001)
check('journal scale independent', math.abs(logic.GetTextScale() - 0.79) < 0.0001)
check('pin scale independent', math.abs(logic.GetPinScale() - 1.5) < 0.0001)
check('prox compass untouched', logic.GetProxCompass() == true)
check('pin text low bound', math.abs(logic.SetPinTextScale(0.2) - 0.5) < 0.0001)
check('pin text 300 kept', math.abs(logic.SetPinTextScale(3) - 3) < 0.0001)
check('pin text 400 kept', math.abs(logic.SetPinTextScale(4) - 4) < 0.0001)
check('pin text high bound', math.abs(logic.SetPinTextScale(5) - 4) < 0.0001)
check('pin text max field', logic.PIN_TEXT_MAX == 4 and logic.PIN_TEXT_MIN == 0.5)
check('pin text 79 kept', math.abs(logic.SetPinTextScale(0.79) - 0.79) < 0.0001)
check('pin text step', math.abs(logic.AdjustPinTextScale(1) - 0.84) < 0.0001)
local book_before = logic.GetJournalWindowState()
local pin_window = logic.GetPinScale()
local book_scale = logic.GetTextScale()
local stepped = logic.GetPinTextScale()
logic.SetPinTextScale(4)
local book_after = logic.GetJournalWindowState()
check('tracker text leaves book size',
    book_after.width == book_before.width and book_after.height == book_before.height)
check('tracker text leaves pin window', math.abs(logic.GetPinScale() - pin_window) < 0.0001)
check('tracker text leaves book scale', math.abs(logic.GetTextScale() - book_scale) < 0.0001)
logic.SetPinTextScale(stepped)
check('tracker text restored', math.abs(logic.GetPinTextScale() - stepped) < 0.0001)

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

logic.SetPinVisible(true)
check('pin show', logic.GetPinState().visible == true)
logic.TogglePinVisible()
check('pin hide toggle', logic.GetPinState().visible == false)
logic.SetPinVisible(true)
logic.Unload()
check('saved pin text', math.abs(config.pin_text_scale - logic.GetPinTextScale()) < 0.0001)
check('saved pin open', config.pin_open == true)
check('saved settings size', config.settings_width == 730 and config.settings_height == 810)
check('saved journal scale', math.abs(config.journal_text_scale - 1.2) < 0.0001)
check('saved prox compass', config.announce_prox_compass == true)
check('saved pin bold', config.pin_bold == true)
check('saved pin stack', config.pin_stack_max == 480)

local other = {
    journal_text_scale = 1.1,
    pin_scale = 0.8,
    pin_text_scale = 0.55,
    pin_layout_v2 = true,
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
check('char pin bold off', logic.GetPinBold() == false and logic.GetPinStackMax() == 0)
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

handler({
    pin_layout_v2 = true,
    pin_text_scale = 2,
    pin_scale = 0.9,
    journal_text_scale = 0.8,
    journal_width = 1100,
    journal_height = 720,
})
check('saved 200 still loads', math.abs(logic.GetPinTextScale() - 2) < 0.0001)
handler({
    pin_layout_v2 = true,
    pin_text_scale = 3.5,
    pin_scale = 0.9,
    journal_text_scale = 0.8,
    journal_width = 1100,
    journal_height = 720,
})
check('saved 350 loads', math.abs(logic.GetPinTextScale() - 3.5) < 0.0001)
check('350 leaves pin window', math.abs(logic.GetPinScale() - 0.9) < 0.0001)
check('350 leaves journal text', math.abs(logic.GetTextScale() - 0.8) < 0.0001)
local book350 = logic.GetJournalWindowState()
check('350 leaves book size', book350.width == 1100 and book350.height == 720)
handler({
    pin_layout_v2 = true,
    pin_text_scale = 9,
    pin_scale = 1,
    journal_text_scale = 1,
    journal_width = 1000,
    journal_height = 700,
})
check('loaded text clamped', math.abs(logic.GetPinTextScale() - 4) < 0.0001)

local credit = require('jp_credit')
check('jp credit 0.3.4', credit.version == '0.3.4' and credit.display('0.3.7'):find('0.3.7', 1, true) ~= nil)
check('jp credit keeps tsukasa', credit.display('0.3.7'):find('[jpver 0.3.4 by Tsukasa]', 1, true) ~= nil)
check('jp contributor hando', credit.contributor_line:find('協力者: hando', 1, true) ~= nil)
local mini_src = io.open('/workspace/Journal/mini_icon.lua'):read('*a')
check('book has no tooltip', mini_src:find('BeginTooltip', 1, true) == nil and mini_src:find('SetTooltip', 1, true) == nil)
check('book still clicks', mini_src:find("InvisibleButton('##JournalMiniImage'", 1, true) ~= nil)
local pin_src = io.open('/workspace/Journal/pinned.lua'):read('*a')
check('tracker corner resizes', pin_src:find('SetNextWindowSizeConstraints', 1, true) ~= nil)
check('tracker width stays scale', pin_src:find('window_width / WINDOW_WIDTH', 1, true) ~= nil)
check('tracker keeps dragged height', pin_src:find('if pin.height ~= nil then', 1, true) ~= nil)
check('tracker close hides',
    pin_src:find("X##pin_close", 1, true) ~= nil
    and pin_src:find('SetPinVisible(false)', 1, true) ~= nil)
check('tracker text refits height', pin_src:find('text_refit', 1, true) ~= nil)
check('tracker wraps wide lines', pin_src:find('function M.FitLines', 1, true) ~= nil)
local ui_ja = require('data.ui_ja')
check('tracker on ja', ui_ja['Tracker ON'] == 'トラッカー ON')
check('tracker off ja', ui_ja['Tracker OFF'] == 'トラッカー OFF')
check('tracker hide ja', ui_ja['Hide the Tracker'] == 'トラッカーを隠す')
local ui_src = io.open('/workspace/Journal/ui.lua'):read('*a')
check('book tracker toggle',
    ui_src:find('##JournalTrackerToggle', 1, true) ~= nil
    and ui_src:find('SetPinVisible(not tracker_on)', 1, true) ~= nil)
check('compass content does not resize', ui_src:find('clipped_signature', 1, true) == nil and ui_src:find('GetScrollMaxY', 1, true) == nil)
check('compass text does not resize', ui_src:find('last_scale', 1, true) == nil)
check('compass wraps like tracker', ui_src:find('Compass lines wrap to the window', 1, true) ~= nil)
local rich_src = io.open('/workspace/Journal/richtext.lua'):read('*a')
check('wrap leaves room for close', rich_src:find('opts.reserve', 1, true) ~= nil)
check('compass bold setting', ui_src:find("tx('Bold text')", 1, true) ~= nil)
check('compass stack setting', ui_src:find("tx('Stacked height limit')", 1, true) ~= nil)
local compass = logic.compass
local compass_snap = compass.Serialize()
compass.Load({ w = 400, h = 280, text_scale = 1.2 })
local cw, ch = compass.GetSize()
check('compass keeps saved size', cw == 400 and ch == 280)
check('compass bold defaults off', compass.GetBold() == false)
check('compass stack defaults off', compass.GetStackMax() == 0)
check('compass scale from width', math.abs(compass.GetWindowScale() - 1.54) < 0.001)
local epoch = compass.GetWindowScaleEpoch()
compass.SetTextScale(0.8)
cw, ch = compass.GetSize()
check('compass text keeps size', cw == 400 and ch == 280 and math.abs(compass.GetTextScale() - 0.8) < 0.001)
compass.SetBold(true)
cw, ch = compass.GetSize()
check('compass bold keeps size', compass.GetBold() == true and cw == 400 and ch == 280)
check('compass stack low', compass.SetStackMax(50) == 200)
check('compass stack high', compass.SetStackMax(5000) == 960)
check('compass stack off', compass.SetStackMax(0) == 0)
check('compass stack on', compass.AdjustStackMax(1) == 200)
check('compass stack down off', compass.AdjustStackMax(-1) == 0)
cw, ch = compass.GetSize()
check('compass stack keeps size', cw == 400 and ch == 280)
check('compass scale sets width', math.abs(compass.SetWindowScale(1.5) - 1.5) < 0.001)
cw, ch = compass.GetSize()
check('compass scale keeps height', cw == 390 and ch == 280)
check('compass scale epoch', compass.GetWindowScaleEpoch() == epoch + 1)
compass.SetSize(410, 280)
check('compass drag does not restamp', compass.GetWindowScaleEpoch() == epoch + 1)
check('compass drag updates scale', math.abs(compass.GetWindowScale() - 1.58) < 0.001)
compass.Load(compass_snap)
local journal_src = io.open('/workspace/Journal/journal.lua'):read('*a')
check('addon version 0.3.7', journal_src:find("addon.version = '0.3.7'", 1, true) ~= nil)
check('text scale does not resize windows', ui_src:find('scalex', 1, true) == nil)
check('addon author kxteel', journal_src:find("addon.author  = 'Kxteel'", 1, true) ~= nil)
check('journal splitter handle', ui_src:find("##JournalPaneSplit", 1, true) ~= nil)
check('splitter cursor is optional', ui_src:find('ImGuiMouseCursor_ResizeEW', 1, true) ~= nil)
check('split drag can hold the window', ui_src:find('split_drag_lock', 1, true) ~= nil)
check('split drag blocks mouse', ui_src:find('journal_ui_split_mouse', 1, true) ~= nil)
local logic_src = io.open('/workspace/Journal/logic.lua'):read('*a')
check('split ratio key', logic_src:find('journal_details_ratio', 1, true) ~= nil)
check('no new compass setting', logic_src:find('prox_compass_open', 1, true) == nil)
check('compass auto open remains', logic_src:find('M.SetCompassOpen(true)', 1, true) ~= nil)
local readme = io.open('/workspace/Journal/README.md'):read('*a')
check('readme image', readme:find('assets/journal_icon.png', 1, true) ~= nil)
check('readme no download', readme:find('releases/download', 1, true) == nil)
check('readme no full branding', readme:find('完全版', 1, true) == nil)
check('readme install kept', readme:find('古い Journal フォルダだけ', 1, true) ~= nil)

local function count_keys(path)
    local n = 0
    for line in io.lines(path) do
        if line:find('^%s*%[', 1) then n = n + 1 end
    end
    return n
end
check('translation keys kept and extended', count_keys('/workspace/Journal/data/translations_ja.lua') == 7765)
check('ui keys', count_keys('/workspace/Journal/data/ui_ja.lua') > 0)
check('tracker opens journal list', type(logic.OpenPinInJournal) == 'function')
check('prox range', logic.prox_range.radius == 30 and logic.prox_range.keep == 35)
local worldmark = require('worldmark')
check('arrow file map', worldmark.IconFile('available') == 'available.png' and worldmark.IconFile('missing') == nil)
check('icon fallback', worldmark.GetIcon('available') == nil)
check('sheet opener', type(logic.OpenQuestSheet) == 'function')
check('repeatable state', logic.GetNpcMarkState('nobody') == 'normal' or logic.GetNpcMarkState('nobody') == 'hidden')

local quest_data = require('data.quests')
local counts = quest_data.GetCategoryCounts()
check('old categories remain',
    counts.sandoria > 0 and counts.bastok > 0 and counts.windurst > 0
    and counts.jeuno > 0 and counts.outlands > 0 and counts.other > 0
    and counts.whitegate > 0 and counts.crystal_war > 0)
check('catseye quest count', counts.catseye == 102)
local hakken
for _, quest in ipairs(quest_data.QUESTS.catseye) do
    if quest.id == 'catseye_horutoto_hakken' then
        hakken = quest
    end
end
check('hakken english title', hakken.name == 'Horutoto Hakken' and i18n.step('Horutoto Hakken') == 'Horutoto Hakken')
check('hakken untracked', hakken.trackable == false and hakken.tracker_id == nil and hakken.chat_track == true)
check('hakken japanese step', hakken.steps[1] == '東サルタバルタ (J-7) から内ホルトト遺跡に入る。')
check('hakken ten steps', #hakken.steps == 10)
local positions = require('data.npc_positions')
check('no invented npc position', positions['Gan-Ban'] == nil and positions['Renovio'] == nil)
local tracker = require('tracker')
local listed = tracker.GetQuestArea('catseye')
local listed_hakken
for _, quest in ipairs(listed) do
    if quest.name == 'Horutoto Hakken' then
        listed_hakken = quest
    end
end
check('hakken in list', #listed == 102 and listed_hakken ~= nil and listed_hakken.status == 'not_started')
check('sandoria list remains', #tracker.GetQuestArea('sandoria') > 10)
local order = tracker.GetQuestCategories()
check('category order', order[8] == 'crystal_war' and order[9] == 'catseye' and #order == 9)
check('zone heading ja', logic.JapaneseZone("Southern San d'Oria") == '南サンドリア')
check('zone heading ruins', logic.JapaneseZone('Inner Horutoto Ruins') == '内ホルトト遺跡')
check('zone heading kept', logic.JapaneseZone('内ホルトト遺跡') == '内ホルトト遺跡')
check('zone heading fallback', logic.JapaneseZone('Not A Real Zone XYZ') == 'Not A Real Zone XYZ')
check('zone heading other', logic.JapaneseZone('Other') == 'その他')
check('catseye shown by default', logic.GetShowCatseye() == true)
local shown_tabs = logic.GetQuestCategories()
local catseye_tab
for index, category in ipairs(shown_tabs) do
    if category == 'catseye' then
        catseye_tab = index
    end
end
check('catseye tab present', catseye_tab ~= nil)
logic.SetQuestSelection(catseye_tab, 1)
local groups = logic.GetQuestListGroups()
check('catseye grouped by zone', #groups >= 3)
local group_names = {}
for _, group in ipairs(groups) do
    group_names[logic.JapaneseZone(group.zone)] = true
end
check('catseye zone headings',
    group_names['内ホルトト遺跡'] and group_names['南サンドリア'] and group_names['ウィンダス森の区'])
check('open cats eye from tracker', logic.OpenPinInJournal({
    kind = 'quest', id = 'catseye_give_me_a_ring', name = 'Give Me a Ring', area = 'catseye',
}) == true)
logic.SetShowCatseye(false)
check('hidden cats eye not listed', logic.IsQuestListed({
    kind = 'quest', id = 'catseye_give_me_a_ring', area = 'catseye',
}) == false)
check('hidden cats eye does not open', logic.OpenPinInJournal({
    kind = 'quest', id = 'catseye_give_me_a_ring', name = 'Give Me a Ring', area = 'catseye',
}) == false)
local hidden_tabs = logic.GetQuestCategories()
local hidden = false
for _, category in ipairs(hidden_tabs) do
    if category == 'catseye' then
        hidden = true
    end
end
check('catseye tab hidden', hidden == false)
check('left catseye tab', logic.GetQuestSelection().category_index == 1)
logic.SetShowCatseye(true)
local track = require('catseye_track')
track.set_quests(quest_data.QUESTS.catseye)
track.reset()
local give = { name = 'Give Me a Ring', chat_track = true, complete_zone = 241, complete_on = { 'ウィンダスリングを手にいれた' } }
check('accept sets active', track.on_text('◇ Quest Accepted: Give Me a Ring', 241).action == 'active' and track.status_for(give) == 'active')
check('complete needs active zone', track.on_text('ウィンダスリングを手にいれた！', 230) == nil and track.status_for(give) == 'active')
check('complete on reward', track.on_text('ウィンダスリングを手にいれた！', 241).action == 'completed' and track.status_for(give) == 'completed')
track.reset()
check('reward before accept ignored', track.on_text('サンドリアリングを手にいれた！', 230) == nil)
check('unknown name kept', track.on_text('Quest Accepted: Totally New Quest', nil).known == false)
check('unknown row', track.unknown_rows()[1].name == 'Totally New Quest')
local soil = { name = 'Horutoto Hakken', complete_zone = 248, complete_on = hakken.complete_on }
track.on_text('Quest Accepted: Horutoto Hakken', 192)
check('any soil piece completes', track.on_text('大地の脚絆を手にいれた！', 248).action == 'completed')
check('npcpos line', require('npcpos').format_entry('Aeolia', 230, 1.5, -2, 0.25) == '["Aeolia"] = { { 230, 1.50, -2.00, 0.25 } },')
check('aeolia has no fixed position', positions['Aeolia'] == nil and positions['Moyeyo'] == nil)
local near = require('catseye_track')
check('nearby not started', near.shows_nearby('not_started', false, true) == true)
check('nearby active', near.shows_nearby('active', false, true) == true)
check('nearby completed hidden', near.shows_nearby('completed', false, false) == false)
check('nearby repeatable hidden', near.shows_nearby('completed', true, true) == false)
check('nearby repeatable shown', near.shows_nearby('completed', true, false) == true)

local function blank_packet(length)
    return string.rep('\0', length)
end
local function set_byte(packet, offset, value)
    return packet:sub(1, offset) .. string.char(value) .. packet:sub(offset + 2)
end
local function packet_056(packet_type, bits)
    local packet = blank_packet(0x28)
    local b1 = packet_type % 256
    local b2 = math.floor(packet_type / 256) % 256
    packet = set_byte(packet, 0x24, b1)
    packet = set_byte(packet, 0x25, b2)
    for _, bit in ipairs(bits) do
        local offset = 0x04 + math.floor(bit / 8)
        local mask = 2 ^ (bit % 8)
        local current = packet:byte(offset + 1)
        packet = set_byte(packet, offset, current + mask)
    end
    return packet
end
local function packet_055(table_index, get_bits, look_bits)
    local packet = blank_packet(0x88)
    packet = set_byte(packet, 0x84, table_index)
    for _, bit in ipairs(get_bits) do
        local offset = 0x04 + math.floor(bit / 8)
        packet = set_byte(packet, offset, packet:byte(offset + 1) + (2 ^ (bit % 8)))
    end
    for _, bit in ipairs(look_bits) do
        local offset = 0x44 + math.floor(bit / 8)
        packet = set_byte(packet, offset, packet:byte(offset + 1) + (2 ^ (bit % 8)))
    end
    return packet
end

local dump = require('questdump')
dump.reset()
check('dump starts off', dump.is_enabled() == false)
check('dump ignores while off', dump.ingest(0x056, packet_056(0x0070, { 4 })) == false)
dump.set_enabled(true)
check('dump stores unknown log', dump.ingest(0x056, packet_056(0x01AB, { 3 })) == true)
dump.snapshot('before')
check('dump stores unknown log change', dump.ingest(0x056, packet_056(0x01AB, { 3, 7 })) == true)
check('dump stores known log', dump.ingest(0x056, packet_056(0x0070, { 12 })) == true)
check('dump stores key item', dump.ingest(0x055, packet_055(3, { 5 }, { 9 })) == true)
dump.snapshot('after')
local result = dump.changes('before', 'after')
local joined = table.concat(result.lines, '\n')
check('dump shows log bit', joined:find('0x056 種別 0x000001AB ビット 7: オフ → オン', 1, true) ~= nil)
check('dump shows quest bit', joined:find('0x056 種別 0x00000070 ビット 12: オフ → オン', 1, true) ~= nil)
check('dump shows key item', joined:find('0x055 テーブル 3 入手ビット 5: オフ → オン', 1, true) ~= nil)
check('dump shows seen key item', joined:find('0x055 テーブル 3 確認ビット 9: オフ → オン', 1, true) ~= nil)
check('dump needs two snaps', dump.changes('missing', 'after') == nil)
local saved_addon = addon
addon = { path = '/tmp/ashita-root/addons/Journal/', name = 'Journal' }
check('dump config outside addon', dump.config_dir() == '/tmp/ashita-root/config/addons/Journal')
addon = {
    path = 'C:/Games/CatsEyeXI/catseyexi-client/Vanacore/addons/vanacore/Journal/',
    name = 'Journal',
}
local vanacore_dirs = dump.candidate_dirs()
local saw_config, saw_addon = false, false
for _, dir in ipairs(vanacore_dirs) do
    if dir == 'C:/Games/CatsEyeXI/catseyexi-client/Vanacore/config/addons/Journal' then
        saw_config = true
    end
    if dir == 'C:/Games/CatsEyeXI/catseyexi-client/Vanacore/addons/vanacore/Journal' then
        saw_addon = true
    end
end
check('vanacore config dir', saw_config)
check('vanacore addon fallback', saw_addon)
local report_dir = '/tmp/journal-questdump-test'
os.execute('mkdir -p ' .. report_dir)
os.remove(report_dir .. '/questdump.txt')
local written = dump.write_report('テスト\n', { report_dir })
check('dump writes report', written == report_dir .. '/questdump.txt')
local report = io.open(written, 'r')
local report_text = report:read('*a')
report:close()
check('dump report text', report_text:find('テスト', 1, true) ~= nil)
os.remove(written)
local bad_path, bad_err = dump.write_report('x', { '/etc/passwd/journal-questdump' })
check('dump reports save error', bad_path == nil and type(bad_err) == 'string' and bad_err:find('questdump.txt', 1, true) ~= nil)
addon = saved_addon

local function packet_05c(nums)
    local packet = blank_packet(0x24)
    for index, value in ipairs(nums) do
        local n = value
        if n < 0 then
            n = n + 4294967296
        end
        local offset = 0x04 + (index - 1) * 4
        for _ = 0, 3 do
            packet = set_byte(packet, offset, n % 256)
            n = math.floor(n / 256)
            offset = offset + 1
        end
    end
    return packet
end

dump.reset()
dump.set_enabled(true)
dump.on_packet({ id = 0x056, data = packet_056(0x0070, { 1 }) })
dump.on_packet({ id = 0x017, data = 'hello' })
local first_lines = dump.handle({ '/journal', 'questdump', 'snap', 'one' })
local first_text = table.concat(first_lines, '\n')
check('dump counts since on', first_text:find('0x056 は開始から 1、前回の snap から 1', 1, true) ~= nil)
check('dump lists other packets', first_text:find('0x017 x1', 1, true) ~= nil)
dump.on_packet({ id = 0x056, data = packet_056(0x0070, { 1, 2 }) })
local second_lines = dump.handle({ '/journal', 'questdump', 'snap', 'two' })
local second_text = table.concat(second_lines, '\n')
check('dump counts since snap', second_text:find('0x056 は開始から 2、前回の snap から 1', 1, true) ~= nil)
check('dump says log arrived', second_text:find('クエストログ（0x056）は届いていません', 1, true) == nil)
local kept = dump.changes('one', 'two')
check('dump snap keeps earlier bits', table.concat(kept.lines, '\n'):find('0x056 種別 0x00000070 ビット 2: オフ → オン', 1, true) ~= nil)
dump.on_packet({ id = 0x05C, data = packet_05c({ 0, 0, 0, 0, 0, 0, 0, 0 }) })
dump.snapshot('c1')
dump.on_packet({ id = 0x05C, data = packet_05c({ 0, 0, 4, 0, 0, 0, 0, 0 }) })
dump.snapshot('c2')
local event = dump.changes('c1', 'c2')
check('dump event number', table.concat(event.lines, '\n'):find('0x05C 数値 2: 0 → 4', 1, true) ~= nil)
dump.reset()
check('dump off again', dump.is_enabled() == false)

local rich = require('richtext')
local item_styles = {
    { kind = 'item', index = { { name = 'honey' }, { name = 'mythril sword' } } },
}
local function marked(text, have)
    return rich.annotate(text, item_styles, function(name, quantity)
        local owned = have[name] or 0
        if owned >= quantity then
            return 'ok', owned
        end
        return 'partial', owned
    end)
end
check('ja count is not one of five', marked('Honey5個を用意。', { Honey = 1 }):find('(1/5)', 1, true) ~= nil)
local ja_styles = require('style_ja').extend({ { index = {}, kind = 'item' } }, 'ja')
local function marked_ja(text, have)
    return rich.annotate(text, ja_styles, function(name, quantity)
        local owned = have[name] or 0
        if owned >= quantity then
            return 'ok', owned
        end
        return 'partial', owned
    end)
end
check('jp flint name parses four', marked_ja('Aquillinaに火打石4個を渡して100ギル。', { ['火打石'] = 4 }):find('VV', 1, true) ~= nil)
check('jp flint short is not enough', marked_ja('火打石4個を用意。', { ['火打石'] = 1 }):find('(1/4)', 1, true) ~= nil)
check('jp flint none stays unmarked', marked_ja('火打石4個を用意。', { ['火打石'] = 0 }) == '火打石4個を用意。')
local inventory = require('inventory')
inventory.SetTestIndex({
    names = { ['flint stone'] = { 880 } },
    counts = { [880] = 4 },
})
local flint_state, flint_have = inventory.Status('火打石', 4)
check('status flint ja enough', flint_state == 'ok' and flint_have == 4)
local flint_en_state = inventory.Status('Flint Stone', 4)
check('status flint english enough', flint_en_state == 'ok')
inventory.SetTestIndex({
    names = { ['flint stone'] = { 880 } },
    counts = { [880] = 1 },
})
local flint_short, flint_short_have = inventory.Status('火打石', 4)
check('status flint ja one of four', flint_short == 'partial' and flint_short_have == 1)
inventory.SetTestIndex({
    names = { ['flint stone'] = { 880 } },
    counts = { [880] = 0 },
})
local flint_none, flint_none_have = inventory.Status('火打石', 4)
check('status flint ja none', flint_none == 'partial' and flint_none_have == 0)
inventory.SetTestIndex({
    names = { ['flint stone'] = { 880 } },
    counts = { [880] = 4 },
    apply_aliases = false,
})
check('status flint ja fallback', inventory.Status('火打石', 4) == 'ok')
inventory.SetTestIndex({
    names = {
        ['flint stone'] = { 880 },
        ['火打石'] = { 881 },
    },
    counts = { [880] = 4, [881] = 1 },
})
local kept_state, kept_have = inventory.Status('火打石', 4)
check('status flint keeps resource japanese', kept_state == 'partial' and kept_have == 1)
check('status unknown japanese item', inventory.Status('見たことのない品', 1) == nil)
check('normalize drops trailing nul', inventory.normalize('Flint Stone\0') == 'flint stone')
check('jp hides one of three', marked_ja('トカゲの皮3枚を用意。', { ['トカゲの皮'] = 1 }):find('(1/3)', 1, true) ~= nil)
check('jp hides three is enough', marked_ja('トカゲの皮3枚を用意。', { ['トカゲの皮'] = 3 }):find('VV', 1, true) ~= nil)
check('jp hides none stays unmarked', marked_ja('トカゲの皮3枚を用意。', { ['トカゲの皮'] = 0 }) == 'トカゲの皮3枚を用意。')
check('sheet count after particle', rich.quantity_after('大羊の毛皮を3枚用意する。', #'大羊の毛皮') == 3)
check('tube count', rich.quantity_after('空の試験管5本', #'空の試験管') == 5)
check('feather count after particle', rich.quantity_after('ヒポグリフの尾羽根を2本渡す。', #'ヒポグリフの尾羽根') == 2)
check('toad count', rich.quantity_after('ヒキガエル3匹と茗荷1個', #'ヒキガエル') == 3)
check('letter count', rich.quantity_after('手紙4通', #'手紙') == 4)
check('map ordinal is not a count', rich.quantity_after('2枚目のマップ', 0) == nil)
local skin_styles = {
    { kind = 'item', index = { { name = 'lizard skin' } } },
}
check('english skin sheets one of three', rich.annotate(
    'Lizard Skin3枚を用意。',
    skin_styles,
    function(_, quantity)
        if 1 >= quantity then return 'ok', 1 end
        return 'partial', 1
    end
):find('(1/3)', 1, true) ~= nil)
check('flash step uses flint', words['Obtain Flint Stone x4. It drops from worm type enemies such as Tunnel Worm, Carrion Worm and Stone Eater, and can also be found at the Auction House (Materials, Goldsmithing).']:find('火打石4個', 1, true) ~= nil)
check('shady step uses zinc', words['Obtain Zinc Ore x4. It can be bought from Teerth in Bastok Markets for 200 gil, from Celestina in Mhaura for 200 gil, or at the Auction House, or you can mine it from a Mineral Vein.']:find('亜鉛鉱4個', 1, true) ~= nil)
check('ja count check when enough', marked('Honey5個を用意。', { Honey = 5 }):find('VV', 1, true) ~= nil)
check('ja trade is not a reward skip', marked('RaimbroyにHoney5個を渡し400ギルを受け取る。', { Honey = 5 }):find('VV', 1, true) ~= nil)
check('reward receive stays unmarked', marked('receive the Mythril Sword.', { ['Mythril Sword'] = 1 }) == 'receive the Mythril Sword.')
check('ja receive stays unmarked', marked('Mythril Swordを受け取る。', { ['Mythril Sword'] = 1 }) == 'Mythril Swordを受け取る。')

check('fame 2 is not bastok for every quest', words['Fame 2'] == '名声2')
check('bastok fame stays on that quest', words['quest:bsz_pb_guest_of_hauteur:req'] == 'バストゥーク名声3')
check('sandoria fame level follows data', words['quest:sdz_ss_timely_visit:req'] == 'サンドリア名声4')
check('norg fame is named', words['Fame 2 (Norg)'] == 'ノーグ名声2')
check('porika step is translated', words['Return to Tosuka-Porika (G-8).'] == 'Tosuka-Porika(G-8)のもとへ戻る。')
check('notes menu is japanese', require('data.ui_ja')['General notes'] == 'メモ')
check('yes button remains', require('data.ui_ja')['Yes'] == 'はい')
check('no thanks remains', require('data.ui_ja')['No thanks'] == 'いいえ')

local split = require('window_fit')
check('split constant is 0.32', split.JOURNAL_DETAILS_RATIO == 0.32 and split.JOURNAL_PANE_GAP == 10)
local locked, lock_x, lock_y = split.split_drag_lock(true, 40, 80, 200, 300)
check('drag locks the book', locked == true and lock_x == 40 and lock_y == 80)
locked, lock_x, lock_y = split.split_drag_lock(false, 40, 80, 200, 300)
check('idle book stays free', locked == false and lock_x == 200 and lock_y == 300)
locked, lock_x, lock_y = split.split_drag_lock(true, nil, nil, 12, 18)
check('drag without a start stays free', locked == false and lock_x == 12 and lock_y == 18)
locked, lock_x, lock_y = split.split_drag_lock(true, 'no', 10, 4, 6)
check('bad anchor does not lock', locked == false and lock_x == 4 and lock_y == 6)
for _, width in ipairs({ 360, 400, 720, 1000, 1100, 1600 }) do
    local list_w, details_w = split.journal_panes(width, nil)
    local expect_d = math.floor(width * 0.32)
    local expect_l = width - expect_d - 10
    check(
        'split default ' .. width,
        list_w == expect_l and details_w == expect_d
    )
end
local half_l, half_d = split.journal_panes(1100, 0.5)
check('split half applied', half_d == 550 and half_l == 1100 - 550 - 10)
local wide_l, wide_d = split.journal_panes(360, 0.95)
check('split clamps wide details', wide_l == 180 and wide_d == 170 and wide_l + wide_d + 10 == 360)
local narrow_l, narrow_d = split.journal_panes(1100, 0.05)
check('split clamps narrow details', narrow_d == 96 and narrow_l == 1100 - 10 - 96)
local bad_l, bad_d = split.journal_panes(1100, 'no')
check('split bad ratio is default', bad_d == math.floor(1100 * 0.32) and bad_l == 1100 - bad_d - 10)
check('split zero ratio is default', select(2, split.journal_panes(1100, 0)) == math.floor(1100 * 0.32))
check('split normalize rejects', split.normalize_journal_ratio(nil) == nil and split.normalize_journal_ratio(1) == nil and split.normalize_journal_ratio(-0.2) == nil)
local overflow = 0
for width = 200, 1800, 37 do
    for _, ratio in ipairs({ nil, 0.05, 0.32, 0.5, 0.8, 0.95 }) do
        local list_w, details_w = split.journal_panes(width, ratio)
        if list_w < 1 or details_w < 1 or list_w + details_w + 10 ~= width then
            overflow = overflow + 1
        end
    end
end
check('split stays inside the window', overflow == 0)
local trip = 0
for width = 360, 1400, 53 do
    local min_details = 96
    local max_details = width - 10 - 180
    if max_details >= min_details then
        for details = min_details, max_details, 41 do
            local ratio = split.journal_ratio_for_details(width, details)
            local _, got = split.journal_panes(width, ratio)
            if got ~= details then
                trip = trip + 1
            end
        end
    end
end
check('split ratio round trip', trip == 0)

handler({
    journal_text_scale = 1,
    journal_width = 1000,
    journal_height = 700,
})
check('split unset by default', logic.GetJournalDetailsRatio() == nil)
local logic_l, logic_d = logic.JournalPaneWidths(1100)
check(
    'logic default split',
    logic_d == math.floor(1100 * 0.32) and logic_l == 1100 - logic_d - 10
)
local before = logic.GetJournalWindowState()
check('set split ratio', logic.SetJournalDetailsRatio(0.5) == true)
check('repeat split ratio', logic.SetJournalDetailsRatio(0.5) == false)
local after = logic.GetJournalWindowState()
check(
    'split leaves the outer window',
    before.width == after.width and before.height == after.height
)
logic.SetTextScale(1.15)
check('text scale leaves split', math.abs(logic.GetJournalDetailsRatio() - 0.5) < 1e-8)
check('split leaves text scale path', math.abs(logic.GetTextScale() - 1.15) < 0.0001)
logic_l, logic_d = logic.JournalPaneWidths(1000)
check('logic applies saved ratio', logic_d == 500 and logic_l == 1000 - 500 - 10)
logic_l, logic_d = logic.JournalPaneWidths(360)
check(
    'logic clamps saved ratio',
    logic_l == 180 and logic_d == 170 and logic_l + logic_d + 10 == 360
)
check('reject bad split', logic.SetJournalDetailsRatio('no') == false)
check('bad split keeps ratio', math.abs(logic.GetJournalDetailsRatio() - 0.5) < 1e-8)
local saved_split = {
    journal_details_ratio = 0.4,
    journal_text_scale = 1.05,
    journal_width = 900,
    journal_height = 600,
    announce_prox_compass = true,
}
handler(saved_split)
check('loaded split ratio', math.abs(logic.GetJournalDetailsRatio() - 0.4) < 1e-8)
logic_l, logic_d = logic.JournalPaneWidths(900)
check(
    'loaded split applied',
    logic_d == math.floor(900 * 0.4) and logic_l == 900 - logic_d - 10
)
logic.Unload()
check('split key saved', math.abs(saved_split.journal_details_ratio - 0.4) < 1e-8)
check('split save leaves text scale', math.abs(saved_split.journal_text_scale - 1.05) < 0.0001)
check('split save leaves compass', saved_split.announce_prox_compass == true)
handler({ journal_details_ratio = 0.8, journal_text_scale = 1, journal_width = 1000 })
logic_l, logic_d = logic.JournalPaneWidths(360)
check('loaded wide split clamps', logic_l == 180 and logic_d == 170)
handler({ journal_details_ratio = 'wide', journal_text_scale = 0.9, journal_width = 1000 })
check('invalid split clears', logic.GetJournalDetailsRatio() == nil)
logic_d = select(2, logic.JournalPaneWidths(1100))
check('invalid split uses 0.32', logic_d == math.floor(1100 * 0.32))
check('invalid split leaves text scale', math.abs(logic.GetTextScale() - 0.9) < 0.0001)
local fresh_split = { journal_text_scale = 1, journal_width = 800, journal_height = 500 }
handler(fresh_split)
logic.Unload()
check('unset split is not stored', fresh_split.journal_details_ratio == nil)
check('unset split leaves width', fresh_split.journal_width == 800)

if fails > 0 then
    io.write('FAILED ', fails, '\n')
    os.exit(1)
end
io.write('ALL PASS\n')
