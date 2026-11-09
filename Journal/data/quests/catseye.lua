local M = {}

-- CatsEyeXI quests are not in the client quest log. chat_track records
-- "Quest Accepted" and the complete_on lines. One reward piece completes
-- Horutoto Hakken: the player receives one of the five, not all of them.

local function quest(row)
    row.area = 'catseye'
    row.chat_track = true
    row.trackable = false
    row.prereq = row.prereq or 'なし'
    M[#M + 1] = row
end

quest({
    id = 'catseye_horutoto_hakken',
    name = 'Horutoto Hakken',
    zone = 'Inner Horutoto Ruins',
    loc = '内ホルトト遺跡 (H-8) 魔封門のすぐ先',
    npc = 'Gan-Ban',
    req = 'Lv.30+、名声: ウィンダス 1（ACE / CW / WEW）',
    reward = '大地の鉢巻（モクシャ+3、VIT+2）、大地の衣（残心+2%、DEX+2）、大地の手甲（格闘スキル+1、片手刀スキル+1、両手刀スキル+1）、大地の下ばき（カウンター+2、AGI+2）、大地の脚絆（モクシャ+3、STR+2）。ソイル装備一式は、からくり士も装備できます。',
    items = '鉢巻: 亜麻糸x2、衣: 亜麻糸x1と草糸x2、手甲: ラワン材x2、下ばき: 毛糸x1、脚絆: 木綿糸x2',
    complete_zone = 248,
    complete_on = {
        '大地の鉢巻を手にいれた',
        '大地の衣を手にいれた',
        '大地の手甲を手にいれた',
        '大地の下ばきを手にいれた',
        '大地の脚絆を手にいれた',
    },
})

quest({
    id = 'catseye_ring_around_the_roses',
    name = 'Ring Around the Roses',
    zone = "Southern San d'Oria",
    loc = "南サンドリア (M-8)",
    npc = 'Aeolia',
    req = '名声: サンドリア 1（CW）',
    reward = 'サンドリアリング',
    items = '',
    complete_zone = 230,
    complete_on = {
        'サンドリアリングを手にいれた',
        "Obtained: San d'Oria Ring",
        "You obtain a San d'Oria Ring",
    },
})

quest({
    id = 'catseye_give_me_a_ring',
    name = 'Give Me a Ring',
    zone = 'Windurst Woods',
    loc = 'ウィンダス森の区 (K-11)',
    npc = 'Moyeyo',
    req = '名声: ウィンダス 1（CW）',
    reward = 'ウィンダスリング',
    items = '',
    complete_zone = 241,
    complete_on = {
        'ウィンダスリングを手にいれた',
        'Obtained: Windurst Ring',
        'You obtain a Windurst Ring',
    },
})

quest({
    id = 'catseye_hungry_customer',
    name = 'Hungry Customer',
    zone = "Southern San d'Oria",
    loc = '南サンドリア (K-6) 宿屋「ライオン Springs」',
    npc = 'Couquillard',
    req = '名声: サンドリア 1（CW）',
    reward = '500ギル',
    items = '野兎の肉x3',
    repeatable = true,
    complete_zone = 230,
    complete_on = {
        '500ギルを手にいれた',
        'Obtained: 500 gil',
        'You obtain 500 gil',
    },
})

return M
