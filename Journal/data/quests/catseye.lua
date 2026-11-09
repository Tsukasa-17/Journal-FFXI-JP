local M = {}

-- CatsEyeXI quests are not in the client quest log. chat_track records
-- "Quest Accepted" and the complete_on lines. Titles and NPC names stay
-- English. Rewards use the resolved Japanese item names.

local function quest(row)
    row.area = 'catseye'
    row.chat_track = true
    row.trackable = false
    row.prereq = row.prereq or 'なし'
    M[#M + 1] = row
end

quest({
    id = 'catseye_featherweight',
    name = 'Featherweight',
    zone = 'オズトロヤ城',
    loc = 'オズトロヤ城 (I-9)',
    npc = 'Yagudo Outlaw',
    req = '区分: Content Quests、名声: ウィンダス 1、Lv.50+、（CW）',
    prereq = 'なし',
    reward = '参照: Yagudo Arena Rewards',
    items = '七結節のキープス (One time); 十三結節のキープス (One time); 獣人銀貨 x4 (Every time)',
    wiki = 'Content Quests',
    repeatable = true,
})

quest({
    id = 'catseye_rock_cooking',
    name = 'Rock Cooking',
    zone = 'ムバルポロス旧市街',
    loc = 'ムバルポロス旧市街 (E-5)',
    npc = 'Dusty Footprint',
    req = '区分: Content Quests、Lv.65+、（CW）',
    prereq = 'なし',
    reward = 'オブシディアン、銀鉱、ガーネット、ペリドット、スフェーン、ターコイズ',
    items = '獣人貨 x12 (One time payment); 火成岩',
    wiki = 'Content Quests',
    repeatable = true,
    complete_on = {
        'オブシディアンを手にいれた',
        'Obtained: Obsidian',
        '銀鉱を手にいれた',
        'Obtained: Silver Ore',
        'ガーネットを手にいれた',
        'Obtained: Garnet',
        'ペリドットを手にいれた',
        'Obtained: Peridot',
        'スフェーンを手にいれた',
        'Obtained: Sphene',
        'ターコイズを手にいれた',
        'Obtained: Turquoise',
    },
})

quest({
    id = 'catseye_thread_bare',
    name = 'Thread Bare',
    zone = '大工房',
    loc = '大工房 (I-9)',
    npc = 'Mathias',
    req = '区分: Content Quests、名声: バストゥーク 1、Lv.45+、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = '草刈鎌',
    items = 'None',
    wiki = 'Content Quests',
    complete_on = {
        '草刈鎌を手にいれた',
        'Obtained: Sickle',
    },
})

quest({
    id = 'catseye_clink_to_the_past',
    name = 'Clink to the Past',
    zone = 'ナシュモ',
    loc = 'ナシュモ (H-7)',
    npc = 'Dadaroon',
    req = '区分: Content Quests、名声: アトルガン 1、Lv.60+、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = '発掘できる能力',
    items = 'アーモンド x12; アトルガン黄金貨 x5',
    wiki = 'Content Quests',
})

quest({
    id = 'catseye_broken_bones',
    name = 'Broken Bones',
    zone = 'マウラ',
    loc = 'マウラ (G-9)',
    npc = 'Felyna',
    req = '区分: Content Quests、名声: ?、Lv.60+、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = 'ローズハープ',
    items = 'None',
    wiki = 'Content Quests',
    complete_on = {
        'ローズハープを手にいれた',
        'Obtained: Rose Harp',
    },
})

quest({
    id = 'catseye_here_be_dragons',
    name = 'Here Be Dragons',
    zone = 'セルビナ',
    loc = 'セルビナ (I-9)',
    npc = 'Khartes',
    req = '区分: Content Quests、名声: ?、（CW）',
    prereq = 'なし',
    reward = '採掘できる能力。',
    items = 'None',
    wiki = 'Content Quests',
})

quest({
    id = 'catseye_goblin_s_gambit',
    name = 'Goblin\'s Gambit',
    zone = 'ムバルポロス旧市街',
    loc = 'ムバルポロス旧市街 (G-8)',
    npc = 'Bagatrix',
    req = '区分: Content Quests、Lv.65+、（CW）',
    prereq = 'なし',
    reward = '黒魔道士、赤魔道士、白魔道士、魔導剣士、アーデルハイト、エリヴィラ、ヨアヒム、コルモル、ミリ・アリアポー、ウカ・トトゥリン、ヴァレンラール',
    items = '獣人金貨 x4',
    wiki = 'Content Quests',
    repeatable = true,
    complete_on = {
        '黒魔道士を手にいれた',
        'Obtained: Black Mage',
        '赤魔道士を手にいれた',
        'Obtained: Red Mage',
        '白魔道士を手にいれた',
        'Obtained: White Mage',
        '魔導剣士を手にいれた',
        'Obtained: Rune Fencer',
        'アーデルハイトを手にいれた',
        'Obtained: Adelheid',
        'エリヴィラを手にいれた',
        'Obtained: Elivira',
        'ヨアヒムを手にいれた',
        'Obtained: Joachim',
        'コルモルを手にいれた',
        'Obtained: Koru-moru',
        'ミリ・アリアポーを手にいれた',
        'Obtained: Mihli Aliapoh',
        'ウカ・トトゥリンを手にいれた',
        'Obtained: Uka Totlihn',
        'ヴァレンラールを手にいれた',
        'Obtained: Valaineral',
    },
})

quest({
    id = 'catseye_finding_nemosyne',
    name = 'Finding Nemosyne',
    zone = 'ジュノ下層',
    loc = 'ジュノ下層 (H-9)',
    npc = 'Letheb',
    req = '区分: System Quests、名声: ジュノ 1、Lv.15+、（CW）',
    prereq = 'なし',
    reward = '聖水',
    items = 'None',
    wiki = 'System Quests',
    complete_on = {
        '聖水を手にいれた',
        'Obtained: Holy Water',
    },
})

quest({
    id = 'catseye_digging_up_dirt',
    name = 'Digging Up Dirt',
    zone = 'ジュノ下層',
    loc = 'ジュノ下層 (I-7)',
    npc = 'Sebastian',
    req = '区分: System Quests、名声: ジュノ 1、Lv.30+、（CW / WEW）',
    prereq = 'なし',
    reward = 'DomenicのBCNMテレポ利用権',
    items = 'None',
    wiki = 'System Quests',
})

quest({
    id = 'catseye_up_up_and_away',
    name = 'Up, Up and Away',
    zone = 'デルクフの塔下層',
    loc = 'デルクフの塔下層 (E-10)',
    npc = 'Disarmed Knight',
    req = '区分: System Quests、名声: ジュノ 1、Lv.30+、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = 'イカロスウィング',
    items = 'None',
    wiki = 'System Quests',
    complete_on = {
        'イカロスウィングを手にいれた',
        'Obtained: Icarus Wing',
    },
})

quest({
    id = 'catseye_boxed_up',
    name = 'Boxed Up',
    zone = '北サンドリア',
    loc = '北サンドリア (E-3)',
    npc = 'Rusty Hammer',
    req = '区分: System Quests、名声: サンドリア 1、Lv.40+、（CW）',
    prereq = 'なし',
    reward = '3000ギル',
    items = 'フェニックスの尾 x1; マホガニー原木 x1; ローズウッド原木 x1; エボニー原木 x1',
    wiki = 'System Quests',
    complete_on = {
        '3000ギルを手にいれた',
        'Obtained: 3000 gil',
        'You obtain 3000 gil',
    },
})

quest({
    id = 'catseye_gobbie_travels',
    name = 'Gobbie Travels',
    zone = 'ジュノ下層',
    loc = 'ジュノ下層 (H-9)',
    npc = 'Portalix',
    req = '区分: System Quests、名声: ジュノ 1、Lv.10+、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = 'ゴブリンパイ',
    items = '星彩の欠片; 月光の欠片; 日光の欠片',
    wiki = 'System Quests',
    complete_on = {
        'ゴブリンパイを手にいれた',
        'Obtained: Goblin Pie',
    },
})

quest({
    id = 'catseye_out_of_stock',
    name = 'Out of Stock',
    zone = 'バストゥーク港',
    loc = 'バストゥーク港 (K-13)',
    npc = 'Shady Dealer',
    req = '区分: System Quests、名声: バストゥーク 1、Lv.10+、（ACE / WEW）',
    prereq = 'なし',
    reward = 'Access to the Curio Vendor Moogle \'s wares, if you don\'t have the Rhapsody yet.',
    items = 'None',
    wiki = 'System Quests',
})

quest({
    id = 'catseye_near_death_experience',
    name = 'Near Death Experience',
    zone = 'ルフェーゼ野',
    loc = 'ルフェーゼ野 (E-8)',
    npc = 'Andrus',
    req = '区分: System Quests、名声: Tavnazia 1、Lv.60+、（ACE / WEW）',
    prereq = 'なし',
    reward = '5000ギル',
    items = 'Complete Promathia Mission 1-3',
    wiki = 'System Quests',
    complete_on = {
        '5000ギルを手にいれた',
        'Obtained: 5000 gil',
        'You obtain 5000 gil',
    },
})

quest({
    id = 'catseye_blast_to_the_past',
    name = 'Blast to the Past',
    zone = 'バタリア丘陵',
    loc = 'バタリア丘陵 (S)',
    npc = 'Ash',
    req = '区分: System Quests、名声: ジュノ 1、Lv.60+、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = '5000ギル',
    items = 'None',
    wiki = 'System Quests',
    complete_on = {
        '5000ギルを手にいれた',
        'Obtained: 5000 gil',
        'You obtain 5000 gil',
    },
})

quest({
    id = 'catseye_a_crystal_prelude_san_d_oria',
    name = 'A Crystal Prelude (San d\'Oria)',
    zone = '龍王ランペールの墓',
    loc = '龍王ランペールの墓 (J-6)',
    npc = 'Robineaux',
    req = '区分: San d\'Oria、名声: サンドリア 1、（CW）',
    prereq = 'なし',
    reward = 'JSE Onion Weapon',
    items = 'None',
    wiki = 'San d\'Oria',
    complete_on = {
        'Obtained: JSE Onion Weapon',
        'You obtain JSE Onion Weapon',
    },
})

quest({
    id = 'catseye_ring_around_the_roses',
    name = 'Ring Around the Roses',
    zone = '南サンドリア',
    loc = '南サンドリア (M-8)',
    npc = 'Aeolia',
    req = '名声: サンドリア 1（CW）',
    prereq = 'なし',
    reward = 'サンドリアリング',
    items = '',
    wiki = 'San d\'Oria',
    complete_zone = 230,
    complete_on = {
        'サンドリアリングを手にいれた',
        'Obtained: San d\'Oria Ring',
        'You obtain a San d\'Oria Ring',
    },
})

quest({
    id = 'catseye_hungry_customer',
    name = 'Hungry Customer',
    zone = '南サンドリア',
    loc = '南サンドリア (K-6) 宿屋「ライオン Springs」',
    npc = 'Couquillard',
    req = '名声: サンドリア 1（CW）',
    prereq = 'なし',
    reward = '500ギル',
    items = '野兎の肉x3',
    wiki = 'San d\'Oria',
    repeatable = true,
    complete_zone = 230,
    complete_on = {
        '500ギルを手にいれた',
        'Obtained: 500 gil',
        'You obtain 500 gil',
    },
})

quest({
    id = 'catseye_in_sheep_s_clothing',
    name = 'In Sheep\'s Clothing',
    zone = '北サンドリア',
    loc = '北サンドリア (C-9)',
    npc = 'Chilly Wolf',
    req = '区分: San d\'Oria、名声: サンドリア 1、Lv.5+、（CW）',
    prereq = 'なし',
    reward = '250ギル',
    items = '大羊の毛皮 x3',
    wiki = 'San d\'Oria',
    repeatable = true,
    complete_on = {
        '250ギルを手にいれた',
        'Obtained: 250 gil',
        'You obtain 250 gil',
    },
})

quest({
    id = 'catseye_hatchet_job',
    name = 'Hatchet Job',
    zone = '東ロンフォール',
    loc = '東ロンフォール (I-7)',
    npc = 'Aesculian',
    req = '区分: San d\'Oria、名声: サンドリア 1、Lv.5+、（CW）',
    prereq = 'なし',
    reward = 'まさかり、フィールドチュニカ',
    items = '野兎のグリル x1',
    wiki = 'San d\'Oria',
    complete_on = {
        'まさかりを手にいれた',
        'Obtained: Hatchet',
        'フィールドチュニカを手にいれた',
        'Obtained: Field Tunica',
    },
})

quest({
    id = 'catseye_fleeing_daylight',
    name = 'Fleeing Daylight',
    zone = '北サンドリア',
    loc = '北サンドリア (F-8)',
    npc = 'Tenebraux',
    req = '区分: San d\'Oria、名声: サンドリア 1、（CW）',
    prereq = 'なし',
    reward = 'ディアガ',
    items = '鳥の血 x6',
    wiki = 'San d\'Oria',
    complete_on = {
        'ディアガを手にいれた',
        'Obtained: Diaga',
    },
})

quest({
    id = 'catseye_on_guard',
    name = 'On Guard',
    zone = '西ロンフォール',
    loc = '西ロンフォール (H-5)',
    npc = 'Somnelius',
    req = '区分: San d\'Oria、名声: サンドリア 1、Lv.5+、（CW）',
    prereq = 'なし',
    reward = '拳法着',
    items = 'ネムリタケ x2',
    wiki = 'San d\'Oria',
    complete_on = {
        '拳法着を手にいれた',
        'Obtained: Kenpogi',
    },
})

quest({
    id = 'catseye_on_watch',
    name = 'On Watch',
    zone = '西ロンフォール',
    loc = '西ロンフォール (H-5)',
    npc = 'Somnelius',
    req = '区分: San d\'Oria、名声: サンドリア 1、Lv.10+、（CW）',
    prereq = 'On Guard',
    reward = 'ブラスサイフォス',
    items = 'たたかえ',
    wiki = 'San d\'Oria',
    complete_on = {
        'ブラスサイフォスを手にいれた',
        'Obtained: Brass Xiphos',
    },
})

quest({
    id = 'catseye_counting_lost_sheep',
    name = 'Counting Lost Sheep',
    zone = '南サンドリア',
    loc = '南サンドリア (E-7)',
    npc = 'Frerehn',
    req = '区分: San d\'Oria、名声: サンドリア 1、Lv.?、（CW）',
    prereq = 'なし',
    reward = 'クロスボウ、600ギル',
    items = 'たたかえ',
    wiki = 'San d\'Oria',
    complete_on = {
        'クロスボウを手にいれた',
        'Obtained: Crossbow',
        '600ギルを手にいれた',
        'Obtained: 600 gil',
        'You obtain 600 gil',
    },
})

quest({
    id = 'catseye_staying_afloat',
    name = 'Staying Afloat',
    zone = '北サンドリア',
    loc = '北サンドリア (F-6)',
    npc = 'Archimedes',
    req = '区分: San d\'Oria、名声: サンドリア 1、Lv.10+、（CW）',
    prereq = 'なし',
    reward = '800ギル',
    items = 'どんぐり x12',
    wiki = 'San d\'Oria',
    repeatable = true,
    complete_on = {
        '800ギルを手にいれた',
        'Obtained: 800 gil',
        'You obtain 800 gil',
    },
})

quest({
    id = 'catseye_rambling_around',
    name = 'Rambling Around',
    zone = '南サンドリア',
    loc = '南サンドリア (K-8)',
    npc = 'Glenda',
    req = '区分: San d\'Oria、名声: サンドリア 1、Lv.10+、（CW）',
    prereq = 'なし',
    reward = '1500ギル',
    items = 'たたかえ',
    wiki = 'San d\'Oria',
    complete_on = {
        '1500ギルを手にいれた',
        'Obtained: 1500 gil',
        'You obtain 1500 gil',
    },
})

quest({
    id = 'catseye_rambling_around_ii',
    name = 'Rambling Around II',
    zone = '南サンドリア',
    loc = '南サンドリア (K-8)',
    npc = 'Glenda',
    req = '区分: San d\'Oria、名声: サンドリア 1、Lv.12+、（CW）',
    prereq = 'Rambling Around',
    reward = '1800ギル',
    items = 'ラノリン x2',
    wiki = 'San d\'Oria',
    repeatable = true,
    complete_on = {
        '1800ギルを手にいれた',
        'Obtained: 1800 gil',
        'You obtain 1800 gil',
    },
})

quest({
    id = 'catseye_saving_my_hide',
    name = 'Saving My Hide',
    zone = '南サンドリア',
    loc = '南サンドリア (D-8)',
    npc = 'Alutanie',
    req = '区分: San d\'Oria、名声: サンドリア 1、Lv.20+、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = 'リザードベルト',
    items = 'たたかえ',
    wiki = 'San d\'Oria',
    repeatable = true,
    complete_on = {
        'リザードベルトを手にいれた',
        'Obtained: Lizard Belt',
    },
})

quest({
    id = 'catseye_a_matter_of_trust_san_d_oria',
    name = 'A Matter of Trust (San d\'Oria)',
    zone = 'サンドリア港',
    loc = 'サンドリア港 (G-8)',
    npc = 'Keenajaques',
    req = '区分: San d\'Oria、名声: サンドリア 1、Lv.10、（CW）',
    prereq = 'なし',
    reward = 'グローブ',
    items = 'たたかえ',
    wiki = 'San d\'Oria',
    repeatable = true,
    complete_on = {
        'グローブを手にいれた',
        'Obtained: Gloves',
    },
})

quest({
    id = 'catseye_a_matter_of_trust_ii_san_d_oria',
    name = 'A Matter of Trust II (San d\'Oria)',
    zone = 'サンドリア港',
    loc = 'サンドリア港 (G-8)',
    npc = 'Keenajaques',
    req = '区分: San d\'Oria、名声: サンドリア 1、Lv.25+、（CW）',
    prereq = 'A Matter of Trust (San d\'Oria)',
    reward = 'コットンゲートル、ダッシューズ',
    items = 'None',
    wiki = 'San d\'Oria',
    repeatable = true,
    complete_on = {
        'コットンゲートルを手にいれた',
        'Obtained: Cotton Gaiters',
        'ダッシューズを手にいれた',
        'Obtained: Sprinter\'s Shoes',
    },
})

quest({
    id = 'catseye_a_matter_of_trust_iii_san_d_oria',
    name = 'A Matter of Trust III (San d\'Oria)',
    zone = 'サンドリア港',
    loc = 'サンドリア港 (G-8)',
    npc = 'Keenajaques',
    req = '区分: San d\'Oria、名声: サンドリア 1、Lv.40+、（CW）',
    prereq = 'A Matter of Trust II (San d\'Oria)',
    reward = 'サンドリアのフェイス使用許可証、ラムマント',
    items = 'None',
    wiki = 'San d\'Oria',
    complete_on = {
        'サンドリアのフェイス使用許可証を手にいれた',
        'Obtained: San d\'Oria Trust permit',
        'ラムマントを手にいれた',
        'Obtained: Ram Mantle',
    },
})

quest({
    id = 'catseye_chasing_the_light',
    name = 'Chasing the Light',
    zone = '北サンドリア',
    loc = '北サンドリア (M-6)',
    npc = 'Megasolus',
    req = '区分: San d\'Oria、名声: サンドリア 1、Lv.75、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = 'Enlight (Scroll)',
    items = '獣人金貨; Defeat Dynamis Lord .',
    wiki = 'San d\'Oria',
    complete_on = {
        'Obtained: Enlight (Scroll)',
        'You obtain Enlight (Scroll)',
    },
})

quest({
    id = 'catseye_a_crystal_prelude_bastok',
    name = 'A Crystal Prelude (Bastok)',
    zone = 'ダングルフの涸れ谷',
    loc = 'ダングルフの涸れ谷 (G-8)',
    npc = 'Iron Wolf',
    req = '区分: Bastok、名声: バストゥーク 1、（CW）',
    prereq = 'なし',
    reward = 'JSE Onion Weapon',
    items = 'None',
    wiki = 'Bastok',
    complete_on = {
        'Obtained: JSE Onion Weapon',
        'You obtain JSE Onion Weapon',
    },
})

quest({
    id = 'catseye_running_rings_around',
    name = 'Running Rings Around',
    zone = 'バストゥーク商業区',
    loc = 'バストゥーク商業区 (K-9)',
    npc = 'Verona',
    req = '区分: Bastok、名声: バストゥーク 1、（CW）',
    prereq = 'なし',
    reward = 'バストゥークリング',
    items = '',
    wiki = 'Bastok',
    complete_on = {
        'バストゥークリングを手にいれた',
        'Obtained: Bastokan Ring',
    },
})

quest({
    id = 'catseye_bug_report',
    name = 'Bug Report',
    zone = 'バストゥーク港',
    loc = 'バストゥーク港 (K-6)',
    npc = 'Bardus',
    req = '区分: Bastok、名声: バストゥーク 1、（CW）',
    prereq = 'なし',
    reward = '300ギル',
    items = '虫の翅 x4',
    wiki = 'Bastok',
    repeatable = true,
    complete_on = {
        '300ギルを手にいれた',
        'Obtained: 300 gil',
        'You obtain 300 gil',
    },
})

quest({
    id = 'catseye_birdsearch',
    name = 'Birdsearch',
    zone = 'バストゥーク商業区',
    loc = 'バストゥーク商業区 (H-9)',
    npc = 'Neavias',
    req = '区分: Bastok、名声: バストゥーク 1、Lv.5+、（CW）',
    prereq = 'なし',
    reward = '400ギル',
    items = '鳥の羽根 x4',
    wiki = 'Bastok',
    repeatable = true,
    complete_on = {
        '400ギルを手にいれた',
        'Obtained: 400 gil',
        'You obtain 400 gil',
    },
})

quest({
    id = 'catseye_mining_my_business',
    name = 'Mining My Business',
    zone = 'ツェールン鉱山',
    loc = 'ツェールン鉱山 (J-9)',
    npc = 'Iron Digger',
    req = '区分: Bastok、名声: バストゥーク 1、Lv.5+、（CW）',
    prereq = 'なし',
    reward = 'つるはし、フィールドチュニカ',
    items = 'スィートリザード x1',
    wiki = 'Bastok',
    complete_on = {
        'つるはしを手にいれた',
        'Obtained: Pickaxe',
        'フィールドチュニカを手にいれた',
        'Obtained: Field Tunica',
    },
})

quest({
    id = 'catseye_earthen_echoes',
    name = 'Earthen Echoes',
    zone = 'バストゥーク鉱山区',
    loc = 'バストゥーク鉱山区 (I-7)',
    npc = 'Rumbling Valley',
    req = '区分: Bastok、名声: バストゥーク 1、Lv.15+、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = 'ストンスキン',
    items = '火打石 x60',
    wiki = 'Bastok',
    complete_on = {
        'ストンスキンを手にいれた',
        'Obtained: Stoneskin',
    },
})

quest({
    id = 'catseye_buzz_off',
    name = 'Buzz Off',
    zone = 'バストゥーク鉱山区',
    loc = 'バストゥーク鉱山区 (K-6)',
    npc = 'Sinister Moon',
    req = '区分: Bastok、名声: バストゥーク 1、Lv.5+、（CW）',
    prereq = 'なし',
    reward = 'レザーベスト',
    items = '蜂の一刺し',
    wiki = 'Bastok',
    complete_on = {
        'レザーベストを手にいれた',
        'Obtained: Leather Vest',
    },
})

quest({
    id = 'catseye_buzz_kill',
    name = 'Buzz Kill',
    zone = 'バストゥーク鉱山区',
    loc = 'バストゥーク鉱山区 (K-6)',
    npc = 'Sinister Moon',
    req = '区分: Bastok、名声: バストゥーク 1、Lv.10+、（CW）',
    prereq = 'Buzz Off',
    reward = 'ブラススピア',
    items = 'たたかえ',
    wiki = 'Bastok',
    complete_on = {
        'ブラススピアを手にいれた',
        'Obtained: Brass Spear',
    },
})

quest({
    id = 'catseye_a_little_courage',
    name = 'A Little Courage',
    zone = 'バストゥーク鉱山区',
    loc = 'バストゥーク鉱山区 (I-7)',
    npc = 'Zorvah',
    req = '区分: Bastok、名声: バストゥーク 1、Lv.?、（CW）',
    prereq = 'なし',
    reward = 'アッシュポール、600ギル',
    items = 'たたかえ',
    wiki = 'Bastok',
    complete_on = {
        'アッシュポールを手にいれた',
        'Obtained: Ash Pole',
        '600ギルを手にいれた',
        'Obtained: 600 gil',
        'You obtain 600 gil',
    },
})

quest({
    id = 'catseye_chasing_tails',
    name = 'Chasing Tails',
    zone = 'バストゥーク鉱山区',
    loc = 'バストゥーク鉱山区 (K-7)',
    npc = 'Shining Stone',
    req = '区分: Bastok、名声: バストゥーク 1、Lv.7+、（CW）',
    prereq = 'なし',
    reward = '600ギル',
    items = 'トカゲの尻尾 x12',
    wiki = 'Bastok',
    repeatable = true,
    complete_on = {
        '600ギルを手にいれた',
        'Obtained: 600 gil',
        'You obtain 600 gil',
    },
})

quest({
    id = 'catseye_that_s_all_folks',
    name = 'That\'s All Folks',
    zone = 'バストゥーク港',
    loc = 'バストゥーク港 (E-6)',
    npc = 'Conchata-Potata',
    req = '区分: Bastok、名声: バストゥーク 1、Lv.10+、（CW）',
    prereq = 'なし',
    reward = '1500ギル',
    items = '',
    wiki = 'Bastok',
    complete_on = {
        '1500ギルを手にいれた',
        'Obtained: 1500 gil',
        'You obtain 1500 gil',
    },
})

quest({
    id = 'catseye_in_a_bucket',
    name = 'In a Bucket',
    zone = 'バストゥーク港',
    loc = 'バストゥーク港 (E-6)',
    npc = 'Conchata-Potata',
    req = '区分: Bastok、名声: バストゥーク 1、Lv.12+、（CW）',
    prereq = 'That\'s All Folks',
    reward = '1800ギル',
    items = '陸ガニの甲殻 x3',
    wiki = 'Bastok',
    repeatable = true,
    complete_on = {
        '1800ギルを手にいれた',
        'Obtained: 1800 gil',
        'You obtain 1800 gil',
    },
})

quest({
    id = 'catseye_wanting_ore',
    name = 'Wanting Ore',
    zone = '大工房',
    loc = '大工房 (F-9)',
    npc = 'Ferredec',
    req = '区分: Bastok、名声: バストゥーク 1、Lv.20+、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = 'プレートベルト',
    items = 'None',
    wiki = 'Bastok',
    complete_on = {
        'プレートベルトを手にいれた',
        'Obtained: Plate Belt',
    },
})

quest({
    id = 'catseye_a_matter_of_trust_bastok',
    name = 'A Matter of Trust (Bastok)',
    zone = 'バストゥーク商業区',
    loc = 'バストゥーク商業区 (H-5)',
    npc = 'Reisle',
    req = '区分: Bastok、名声: バストゥーク 1、Lv.10、（CW）',
    prereq = 'なし',
    reward = 'ブラスミトン',
    items = 'None',
    wiki = 'Bastok',
    complete_on = {
        'ブラスミトンを手にいれた',
        'Obtained: Brass Mittens',
    },
})

quest({
    id = 'catseye_a_matter_of_trust_ii_bastok',
    name = 'A Matter of Trust II (Bastok)',
    zone = 'バストゥーク商業区',
    loc = 'バストゥーク商業区 (H-5)',
    npc = 'Reisle',
    req = '区分: Bastok、名声: バストゥーク 1、Lv.25+、（CW）',
    prereq = 'A Matter of Trust (Bastok)',
    reward = 'グリーヴ、ダッシューズ',
    items = 'None',
    wiki = 'Bastok',
    complete_on = {
        'グリーヴを手にいれた',
        'Obtained: Greaves',
        'ダッシューズを手にいれた',
        'Obtained: Sprinter\'s Shoes',
    },
})

quest({
    id = 'catseye_a_matter_of_trust_iii_bastok',
    name = 'A Matter of Trust III (Bastok)',
    zone = 'バストゥーク商業区',
    loc = 'バストゥーク商業区 (H-5)',
    npc = 'Reisle',
    req = '区分: Bastok、名声: バストゥーク 1、Lv.40+、（CW）',
    prereq = 'A Matter of Trust II (Bastok)',
    reward = 'バストゥークのフェイス使用許可証、アースマント',
    items = 'None',
    wiki = 'Bastok',
    complete_on = {
        'バストゥークのフェイス使用許可証を手にいれた',
        'Obtained: Bastok Trust permit',
        'アースマントを手にいれた',
        'Obtained: Earth Mantle',
    },
})

quest({
    id = 'catseye_a_crystal_prelude_windurst',
    name = 'A Crystal Prelude (Windurst)',
    zone = 'トライマライ水路',
    loc = 'トライマライ水路 (H-8)',
    npc = 'Erudu-Faludu',
    req = '区分: Windurst、名声: ウィンダス 1、（CW）',
    prereq = 'なし',
    reward = 'JSE Onion Weapon',
    items = 'None',
    wiki = 'Windurst',
    complete_on = {
        'Obtained: JSE Onion Weapon',
        'You obtain JSE Onion Weapon',
    },
})

quest({
    id = 'catseye_give_me_a_ring',
    name = 'Give Me a Ring',
    zone = 'ウィンダス森の区',
    loc = 'ウィンダス森の区 (K-11)',
    npc = 'Moyeyo',
    req = '名声: ウィンダス 1（CW）',
    prereq = 'なし',
    reward = 'ウィンダスリング',
    items = '',
    wiki = 'Windurst',
    complete_zone = 241,
    complete_on = {
        'ウィンダスリングを手にいれた',
        'Obtained: Windurst Ring',
        'You obtain a Windurst Ring',
    },
})

quest({
    id = 'catseye_only_the_dose',
    name = 'Only the Dose',
    zone = 'ウィンダス森の区',
    loc = 'ウィンダス森の区 (J-8)',
    npc = 'Perah Celehsi',
    req = '区分: Windurst、名声: ウィンダス 1、（CW）',
    prereq = 'なし',
    reward = '300ギル',
    items = '蜂の一刺し',
    wiki = 'Windurst',
    repeatable = true,
    complete_on = {
        '300ギルを手にいれた',
        'Obtained: 300 gil',
        'You obtain 300 gil',
    },
})

quest({
    id = 'catseye_reaping_rewards',
    name = 'Reaping Rewards',
    zone = '西サルタバルタ',
    loc = '西サルタバルタ (G-9)',
    npc = 'Fha Mhakyaa',
    req = '区分: Windurst、名声: ウィンダス 1、Lv.5+、（CW）',
    prereq = 'なし',
    reward = '草刈鎌、フィールドチュニカ',
    items = 'ハニーエッグ',
    wiki = 'Windurst',
    complete_on = {
        '草刈鎌を手にいれた',
        'Obtained: Sickle',
        'フィールドチュニカを手にいれた',
        'Obtained: Field Tunica',
    },
})

quest({
    id = 'catseye_rustling_feathers',
    name = 'Rustling Feathers',
    zone = 'ウィンダス港',
    loc = 'ウィンダス港 (B-4)',
    npc = 'Puluki-Culuki',
    req = '区分: Windurst、名声: ウィンダス 1、Lv.5+、（CW）',
    prereq = 'なし',
    reward = '150ギル',
    items = 'ヤグードの羽根 x4',
    wiki = 'Windurst',
    repeatable = true,
    complete_on = {
        '150ギルを手にいれた',
        'Obtained: 150 gil',
        'You obtain 150 gil',
    },
})

quest({
    id = 'catseye_down_to_earth',
    name = 'Down to Earth',
    zone = 'ウィンダス水の区',
    loc = 'ウィンダス水の区 (F-7)',
    npc = 'Hermin-Harmon',
    req = '区分: Windurst、名声: ウィンダス 1、Lv.10+、（CW）',
    prereq = 'なし',
    reward = '銅鉱、亜鉛鉱、金鉱、白金鉱',
    items = '隕石',
    wiki = 'Windurst',
    repeatable = true,
    complete_on = {
        '銅鉱を手にいれた',
        'Obtained: Copper Ore',
        '亜鉛鉱を手にいれた',
        'Obtained: Zinc Ore',
        '金鉱を手にいれた',
        'Obtained: Gold Ore',
        '白金鉱を手にいれた',
        'Obtained: Platinum Ore',
    },
})

quest({
    id = 'catseye_say_peas',
    name = 'Say Peas',
    zone = 'ウィンダス水の区',
    loc = 'ウィンダス水の区 (E-9 (North)',
    npc = 'Perara',
    req = '区分: Windurst、名声: ウィンダス 1、Lv.5+、（CW）',
    prereq = 'なし',
    reward = '200ギル、ローブ',
    items = 'ララブのしっぽ x5',
    wiki = 'Windurst',
    complete_on = {
        '200ギルを手にいれた',
        'Obtained: 200 gil',
        'You obtain 200 gil',
        'ローブを手にいれた',
        'Obtained: Robe',
    },
})

quest({
    id = 'catseye_get_cracking',
    name = 'Get Cracking',
    zone = 'ウィンダス水の区',
    loc = 'ウィンダス水の区 (E-9 (North)',
    npc = 'Perara',
    req = '区分: Windurst、名声: ウィンダス 1、Lv.10+、（CW）',
    prereq = 'Say Peas',
    reward = '200ギル、ホリースタッフ',
    items = 'None',
    wiki = 'Windurst',
    complete_on = {
        '200ギルを手にいれた',
        'Obtained: 200 gil',
        'You obtain 200 gil',
        'ホリースタッフを手にいれた',
        'Obtained: Holly Staff',
    },
})

quest({
    id = 'catseye_slowing_down',
    name = 'Slowing Down',
    zone = 'ウィンダス森の区',
    loc = 'ウィンダス森の区 (I-6)',
    npc = 'Temimi',
    req = '区分: Windurst、名声: ウィンダス 1、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = 'スロウ',
    items = 'スカルローカスト x4',
    wiki = 'Windurst',
    complete_on = {
        'スロウを手にいれた',
        'Obtained: Slow',
    },
})

quest({
    id = 'catseye_fowl_tales',
    name = 'Fowl Tales',
    zone = 'ウィンダス石の区',
    loc = 'ウィンダス石の区 (E-7)',
    npc = 'Hoi-Boi',
    req = '区分: Windurst、名声: ウィンダス 1、Lv.?、（CW）',
    prereq = 'なし',
    reward = 'サパラ、600ギル',
    items = 'たたかえ',
    wiki = 'Windurst',
    complete_on = {
        'サパラを手にいれた',
        'Obtained: Sapara',
        '600ギルを手にいれた',
        'Obtained: 600 gil',
        'You obtain 600 gil',
    },
})

quest({
    id = 'catseye_neck_and_neck',
    name = 'Neck and Neck',
    zone = 'ウィンダス森の区',
    loc = 'ウィンダス森の区 (G-8)',
    npc = 'Erbelie',
    req = '区分: Windurst、名声: ウィンダス 1、Lv.10+、（CW）',
    prereq = 'なし',
    reward = '1500ギル',
    items = 'None',
    wiki = 'Windurst',
    complete_on = {
        '1500ギルを手にいれた',
        'Obtained: 1500 gil',
        'You obtain 1500 gil',
    },
})

quest({
    id = 'catseye_neck_and_neck_ii',
    name = 'Neck and Neck II',
    zone = 'ウィンダス森の区',
    loc = 'ウィンダス森の区 (G-8)',
    npc = 'Erbelie',
    req = '区分: Windurst、名声: ウィンダス 1、Lv.12+、（CW）',
    prereq = 'Neck and Neck',
    reward = '800ギル',
    items = 'パパカ草 x2',
    wiki = 'Windurst',
    repeatable = true,
    complete_on = {
        '800ギルを手にいれた',
        'Obtained: 800 gil',
        'You obtain 800 gil',
    },
})

quest({
    id = 'catseye_feather_forecast',
    name = 'Feather Forecast',
    zone = 'ウィンダス森の区',
    loc = 'ウィンダス森の区 (G-12)',
    npc = 'Pennana',
    req = '区分: Windurst、名声: ウィンダス 1、Lv.20+、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = '銀の帯',
    items = 'たたかえ',
    wiki = 'Windurst',
    repeatable = true,
    complete_on = {
        '銀の帯を手にいれた',
        'Obtained: Silver Obi',
    },
})

quest({
    id = 'catseye_a_matter_of_trust_windurst',
    name = 'A Matter of Trust (Windurst)',
    zone = 'ウィンダス石の区',
    loc = 'ウィンダス石の区 (K-6)',
    npc = 'Sharara',
    req = '区分: Windurst、名声: ウィンダス 1、Lv.10、（CW）',
    prereq = 'なし',
    reward = 'リネンカフス',
    items = 'たたかえ',
    wiki = 'Windurst',
    repeatable = true,
    complete_on = {
        'リネンカフスを手にいれた',
        'Obtained: Linen Cuffs',
    },
})

quest({
    id = 'catseye_a_matter_of_trust_ii_windurst',
    name = 'A Matter of Trust II (Windurst)',
    zone = 'ウィンダス石の区',
    loc = 'ウィンダス石の区 (K-6)',
    npc = 'Sharara',
    req = '区分: Windurst、名声: ウィンダス 1、Lv.25+、（CW）',
    prereq = 'A Matter of Trust (Windurst)',
    reward = 'サンダル、ダッシューズ',
    items = 'None',
    wiki = 'Windurst',
    repeatable = true,
    complete_on = {
        'サンダルを手にいれた',
        'Obtained: Sandals',
        'ダッシューズを手にいれた',
        'Obtained: Sprinter\'s Shoes',
    },
})

quest({
    id = 'catseye_a_matter_of_trust_iii_windurst',
    name = 'A Matter of Trust III (Windurst)',
    zone = 'ウィンダス石の区',
    loc = 'ウィンダス石の区 (K-6)',
    npc = 'Sharara',
    req = '区分: Windurst、名声: ウィンダス 1、Lv.40+、（CW）',
    prereq = 'A Matter of Trust II (Windurst)',
    reward = 'ウィンダスのフェイス使用許可証、ツンドラマント',
    items = 'None',
    wiki = 'Windurst',
    complete_on = {
        'ウィンダスのフェイス使用許可証を手にいれた',
        'Obtained: Windurst Trust permit',
        'ツンドラマントを手にいれた',
        'Obtained: Tundra Mantle',
    },
})

quest({
    id = 'catseye_leg_day',
    name = 'Leg Day',
    zone = 'ジュノ港',
    loc = 'ジュノ港 (G-8)',
    npc = 'Pedro',
    req = '区分: Jeuno、名声: ジュノ 1、Lv.15+、（CW）',
    prereq = 'なし',
    reward = '800ギル',
    items = 'None',
    wiki = 'Jeuno',
    complete_on = {
        '800ギルを手にいれた',
        'Obtained: 800 gil',
        'You obtain 800 gil',
    },
})

quest({
    id = 'catseye_leg_day_ii',
    name = 'Leg Day II',
    zone = 'ジュノ港',
    loc = 'ジュノ港 (G-8)',
    npc = 'Pedro',
    req = '区分: Jeuno、名声: ジュノ 1、Lv.20+、（CW）',
    prereq = 'Leg Day',
    reward = '1600ギル',
    items = 'None',
    wiki = 'Jeuno',
    complete_on = {
        '1600ギルを手にいれた',
        'Obtained: 1600 gil',
        'You obtain 1600 gil',
    },
})

quest({
    id = 'catseye_leg_day_iii',
    name = 'Leg Day III',
    zone = 'ジュノ港',
    loc = 'ジュノ港 (G-8)',
    npc = 'Pedro',
    req = '区分: Jeuno、名声: ジュノ 1、Lv.25+、（CW）',
    prereq = 'Leg Day II',
    reward = '2400ギル',
    items = 'None',
    wiki = 'Jeuno',
    complete_on = {
        '2400ギルを手にいれた',
        'Obtained: 2400 gil',
        'You obtain 2400 gil',
    },
})

quest({
    id = 'catseye_leg_work',
    name = 'Leg Work',
    zone = 'ジュノ港',
    loc = 'ジュノ港 (G-8)',
    npc = 'Pedro',
    req = '区分: Jeuno、名声: ジュノ 1、Lv.35+、（CW）',
    prereq = 'Leg Day III',
    reward = '2400ギル、シルバーホーズ',
    items = 'None',
    wiki = 'Jeuno',
    repeatable = true,
    complete_on = {
        '2400ギルを手にいれた',
        'Obtained: 2400 gil',
        'You obtain 2400 gil',
        'シルバーホーズを手にいれた',
        'Obtained: Silver Hose',
    },
})

quest({
    id = 'catseye_leg_work_ii',
    name = 'Leg Work II',
    zone = 'ジュノ港',
    loc = 'ジュノ港 (G-8)',
    npc = 'Pedro',
    req = '区分: Jeuno、名声: ジュノ 1、Lv.35+、（CW）',
    prereq = 'Leg Work',
    reward = '2400ギル、ビロードスロップス',
    items = 'None',
    wiki = 'Jeuno',
    repeatable = true,
    complete_on = {
        '2400ギルを手にいれた',
        'Obtained: 2400 gil',
        'You obtain 2400 gil',
        'ビロードスロップスを手にいれた',
        'Obtained: Velvet Slops',
    },
})

quest({
    id = 'catseye_decrypting_antiquity',
    name = 'Decrypting Antiquity',
    zone = 'ジュノ上層',
    loc = 'ジュノ上層 (F-7)',
    npc = 'Lectilas',
    req = '区分: Jeuno、名声: ジュノ 1、Lv.45+、（CW）',
    prereq = 'なし',
    reward = '3000ギル',
    items = 'None',
    wiki = 'Jeuno',
    complete_on = {
        '3000ギルを手にいれた',
        'Obtained: 3000 gil',
        'You obtain 3000 gil',
    },
})

quest({
    id = 'catseye_decrypting_antiquity_ii',
    name = 'Decrypting Antiquity II',
    zone = 'ジュノ上層',
    loc = 'ジュノ上層 (F-7)',
    npc = 'Lectilas',
    req = '区分: Jeuno、名声: ジュノ 1、Lv.50+、（CW）',
    prereq = 'Decrypting Antiquity',
    reward = 'Freeze (Scroll)、Tornado (Scroll)、Quake (Scroll)、Burst (Scroll)、Flood (Scroll)、Flare (Scroll)、Haste (Scroll)、Protectra IV (Scroll)、Refresh (Scroll)、Dispel (Scroll)、Phalanx (Scroll)、Erase (Scroll)、Raise II (Scroll)、Utsusemi: Ni (Scroll)、ランペール戦記、Maiden\'s Virelai (Scroll)、Mage\'s Ballad II (Scroll)、Water IV (Scroll)、Blizzaga III (Scroll)',
    items = 'LB1 In Defiant Challenge completed; 古代魔法のパピルス x1',
    wiki = 'Jeuno',
    repeatable = true,
    complete_on = {
        'Obtained: Freeze (Scroll)',
        'You obtain Freeze (Scroll)',
        'Obtained: Tornado (Scroll)',
        'You obtain Tornado (Scroll)',
        'Obtained: Quake (Scroll)',
        'You obtain Quake (Scroll)',
        'Obtained: Burst (Scroll)',
        'You obtain Burst (Scroll)',
        'Obtained: Flood (Scroll)',
        'You obtain Flood (Scroll)',
        'Obtained: Flare (Scroll)',
        'You obtain Flare (Scroll)',
        'Obtained: Haste (Scroll)',
        'You obtain Haste (Scroll)',
        'Obtained: Protectra IV (Scroll)',
        'You obtain Protectra IV (Scroll)',
        'Obtained: Refresh (Scroll)',
        'You obtain Refresh (Scroll)',
        'Obtained: Dispel (Scroll)',
        'You obtain Dispel (Scroll)',
        'Obtained: Phalanx (Scroll)',
        'You obtain Phalanx (Scroll)',
        'Obtained: Erase (Scroll)',
        'You obtain Erase (Scroll)',
        'Obtained: Raise II (Scroll)',
        'You obtain Raise II (Scroll)',
        'Obtained: Utsusemi: Ni (Scroll)',
        'You obtain Utsusemi: Ni (Scroll)',
        'ランペール戦記を手にいれた',
        'Obtained: Dragon Chronicles',
        'Obtained: Maiden\'s Virelai (Scroll)',
        'You obtain Maiden\'s Virelai (Scroll)',
        'Obtained: Mage\'s Ballad II (Scroll)',
        'You obtain Mage\'s Ballad II (Scroll)',
        'Obtained: Water IV (Scroll)',
        'You obtain Water IV (Scroll)',
        'Obtained: Blizzaga III (Scroll)',
        'You obtain Blizzaga III (Scroll)',
    },
})

quest({
    id = 'catseye_harboring_fugitives',
    name = 'Harboring Fugitives',
    zone = 'ジュノ下層',
    loc = 'ジュノ下層 (J-7)',
    npc = 'Agent M97',
    req = '区分: Jeuno、名声: ジュノ 1、Lv.50+、（CW）',
    prereq = 'なし',
    reward = 'Artifact armor quest materials of associated job',
    items = 'None',
    wiki = 'Jeuno',
    repeatable = true,
})

quest({
    id = 'catseye_empty_handed',
    name = 'Empty Handed',
    zone = 'ル・ルデの庭',
    loc = 'ル・ルデの庭 (H-7)',
    npc = 'Faded Footprint',
    req = '区分: Jeuno、名声: ジュノ 1、Lv.25+、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = '1500ギル、シェードティアラ、シェードハーネス、シェードミトン、シェードタイツ、シェードレギンス',
    items = 'None',
    wiki = 'Jeuno',
    complete_on = {
        '1500ギルを手にいれた',
        'Obtained: 1500 gil',
        'You obtain 1500 gil',
        'シェードティアラを手にいれた',
        'Obtained: Shade Tiara',
        'シェードハーネスを手にいれた',
        'Obtained: Shade Harness',
        'シェードミトンを手にいれた',
        'Obtained: Shade Mittens',
        'シェードタイツを手にいれた',
        'Obtained: Shade Tights',
        'シェードレギンスを手にいれた',
        'Obtained: Shade Leggings',
    },
})

quest({
    id = 'catseye_imperial_vault',
    name = 'Imperial Vault',
    zone = 'アルザビ',
    loc = 'アルザビ (F-6 by West Gate)',
    npc = 'Vault Keeper',
    req = '区分: Aht Urghan、名声: アトルガン ?、（CW）',
    prereq = 'なし',
    reward = '300 Vault Points',
    items = 'Jade Idol Jade Idol; Carved Runestone Carved Runestone; Coral Relic Coral Relic A delicate coral ornament from a sunken Lamian temple.; Imperial Urn Imperial Urn',
    wiki = 'Aht Urghan',
})

quest({
    id = 'catseye_insult_to_gingery',
    name = 'Insult to Gingery',
    zone = 'アトルガン白門',
    loc = 'アトルガン白門 (I-10)',
    npc = 'Gordo-Bordo',
    req = '区分: Aht Urghan、名声: アトルガン 1、Lv.40+、（CW）',
    prereq = 'なし',
    reward = '600ギル、シパーヒターバン',
    items = '茗荷 x4',
    wiki = 'Aht Urghan',
    repeatable = true,
    complete_on = {
        '600ギルを手にいれた',
        'Obtained: 600 gil',
        'You obtain 600 gil',
        'シパーヒターバンを手にいれた',
        'Obtained: Sipahi Turban',
    },
})

quest({
    id = 'catseye_pecking_battles',
    name = 'Pecking Battles',
    zone = 'バフラウ段丘',
    loc = 'バフラウ段丘 (I-10)',
    npc = 'Vermali',
    req = '区分: Aht Urghan、名声: アトルガン 1、Lv.50+、（CW）',
    prereq = 'なし',
    reward = '1800ギル、ウィヴルマスク',
    items = 'None',
    wiki = 'Aht Urghan',
    repeatable = true,
    complete_on = {
        '1800ギルを手にいれた',
        'Obtained: 1800 gil',
        'You obtain 1800 gil',
        'ウィヴルマスクを手にいれた',
        'Obtained: Wivre Mask',
    },
})

quest({
    id = 'catseye_the_purse_strings',
    name = 'The Purse Strings',
    zone = 'アトルガン白門',
    loc = 'アトルガン白門 (I-6)',
    npc = 'Carlo',
    req = '区分: Aht Urghan、名声: アトルガン 1、Lv.10+、（CW）',
    prereq = 'なし',
    reward = 'Valoredge Frame materials and weapon.、 Sharpshot Frame materials and weapon.、 Stormwaker Frame materials and accessory.',
    items = 'None',
    wiki = 'Aht Urghan',
    repeatable = true,
})

quest({
    id = 'catseye_x_marks_the_spot',
    name = 'X Marks the Spot',
    zone = 'ナシュモ',
    loc = 'ナシュモ (G-7)',
    npc = 'Captain Farrell',
    req = '区分: Aht Urghan、名声: バストゥーク 1、Lv.COR 75、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = 'キャスターズロール',
    items = 'None',
    wiki = 'Aht Urghan',
    complete_on = {
        'キャスターズロールを手にいれた',
        'Obtained: Caster\'s Roll',
    },
})

quest({
    id = 'catseye_x_marks_the_spot_ii',
    name = 'X Marks the Spot II',
    zone = 'ナシュモ',
    loc = 'ナシュモ (G-7)',
    npc = 'Captain Farrell',
    req = '区分: Aht Urghan、名声: バストゥーク 1、Lv.COR 75、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = 'ボルターズロール',
    items = 'Complete: X Marks the spot I',
    wiki = 'Aht Urghan',
    complete_on = {
        'ボルターズロールを手にいれた',
        'Obtained: Bolter\'s Roll',
    },
})

quest({
    id = 'catseye_the_way_of_wadi',
    name = 'The Way of Wadi',
    zone = 'ダングルフの涸れ谷',
    loc = 'ダングルフの涸れ谷 (I-12)',
    npc = 'Passing Sunrise [Galka Footprint]',
    req = '区分: Other Areas、名声: / Selbina 1、（CW）',
    prereq = 'なし',
    reward = 'デーゲン、オニオンソード',
    items = 'None',
    wiki = 'Other Areas',
    complete_on = {
        'デーゲンを手にいれた',
        'Obtained: Degen',
        'オニオンソードを手にいれた',
        'Obtained: Onion Sword',
    },
})

quest({
    id = 'catseye_soup_of_the_day',
    name = 'Soup of the Day',
    zone = 'セルビナ',
    loc = 'セルビナ (J-9)',
    npc = 'Cokhe Lokhe',
    req = '区分: Other Areas、名声: / Selbina 1、Lv.5+、（CW）',
    prereq = 'なし',
    reward = '500ギル',
    items = '陸ガニのふんどし',
    wiki = 'Other Areas',
    repeatable = true,
    complete_on = {
        '500ギルを手にいれた',
        'Obtained: 500 gil',
        'You obtain 500 gil',
    },
})

quest({
    id = 'catseye_head_first',
    name = 'Head First',
    zone = 'コンシュタット高地',
    loc = 'コンシュタット高地 (L-8)',
    npc = 'Hume Footprint',
    req = '区分: Other Areas、名声: バストゥーク 1、Lv.10+、（CW）',
    prereq = 'なし',
    reward = 'リザードマント',
    items = '呪われたサレコウベ',
    wiki = 'Other Areas',
    repeatable = true,
    complete_on = {
        'リザードマントを手にいれた',
        'Obtained: Lizard Mantle',
    },
})

quest({
    id = 'catseye_likely_tails',
    name = 'Likely Tails',
    zone = 'タロンギ大峡谷',
    loc = 'タロンギ大峡谷 (J-8)',
    npc = 'Mithra Tracks',
    req = '区分: Other Areas、名声: ウィンダス 1、Lv.10+、（CW）',
    prereq = 'なし',
    reward = 'コットンケープ',
    items = '野兎の尻尾',
    wiki = 'Other Areas',
    repeatable = true,
    complete_on = {
        'コットンケープを手にいれた',
        'Obtained: Cotton Cape',
    },
})

quest({
    id = 'catseye_helping_hands',
    name = 'Helping Hands',
    zone = 'セルビナ',
    loc = 'セルビナ (J-9)',
    npc = 'Manusiel',
    req = '区分: Other Areas、名声: / Selbina 1、Lv.15+、（CW）',
    prereq = 'なし',
    reward = 'リザードグローブ',
    items = 'ガガンボの腹虫',
    wiki = 'Other Areas',
    repeatable = true,
    complete_on = {
        'リザードグローブを手にいれた',
        'Obtained: Lizard Gloves',
    },
})

quest({
    id = 'catseye_rolling_with_punches',
    name = 'Rolling With Punches',
    zone = 'マウラ',
    loc = 'マウラ (I-9)',
    npc = 'Raving Fist',
    req = '区分: Other Areas、名声: ウィンダス 1、Lv.20+、（CW）',
    prereq = 'なし',
    reward = '木綿の手甲',
    items = 'ダルメルの唾液',
    wiki = 'Other Areas',
    repeatable = true,
    complete_on = {
        '木綿の手甲を手にいれた',
        'Obtained: Cotton Tekko',
    },
})

quest({
    id = 'catseye_running_on_the_range',
    name = 'Running on the Range',
    zone = '東ロンフォール',
    loc = '東ロンフォール (K-4)',
    npc = 'Nefari',
    req = '区分: Other Areas、名声: サンドリア 1、Lv.30+、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = 'ガリシュクラウン、ガリシュチュニック、ガリシュミトン、ガリシュズボン、ガリシュパンプス',
    items = 'None',
    wiki = 'Other Areas',
    complete_on = {
        'ガリシュクラウンを手にいれた',
        'Obtained: Garish Crown',
        'ガリシュチュニックを手にいれた',
        'Obtained: Garish Tunic',
        'ガリシュミトンを手にいれた',
        'Obtained: Garish Mitts',
        'ガリシュズボンを手にいれた',
        'Obtained: Garish Slacks',
        'ガリシュパンプスを手にいれた',
        'Obtained: Garish Pumps',
    },
})

quest({
    id = 'catseye_searching_the_citadel',
    name = 'Searching the Citadel',
    zone = 'ガルレージュ要塞',
    loc = 'ガルレージュ要塞 (G-8)',
    npc = 'Cramp',
    req = '区分: Other Areas、名声: ウィンダス 1、Lv.30+、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = 'シアークラウン、シアークラウン+1、シアーチュニック、シアーチュニック+1、シアーミトン、シアーミトン+1、シアーズボン、シアーズボン+1、シアーパンプス、シアーパンプス+1',
    items = 'None',
    wiki = 'Other Areas',
    complete_on = {
        'シアークラウンを手にいれた',
        'Obtained: Seer\'s Crown',
        'シアークラウン+1を手にいれた',
        'Obtained: Seer\'s Crown +1',
        'シアーチュニックを手にいれた',
        'Obtained: Seer\'s Tunic',
        'シアーチュニック+1を手にいれた',
        'Obtained: Seer\'s Tunic +1',
        'シアーミトンを手にいれた',
        'Obtained: Seer\'s Mitts',
        'シアーミトン+1を手にいれた',
        'Obtained: Seer\'s Mitts +1',
        'シアーズボンを手にいれた',
        'Obtained: Seer\'s Slacks',
        'シアーズボン+1を手にいれた',
        'Obtained: Seer\'s Slacks +1',
        'シアーパンプスを手にいれた',
        'Obtained: Seer\'s Pumps',
        'シアーパンプス+1を手にいれた',
        'Obtained: Seer\'s Pumps +1',
    },
})

quest({
    id = 'catseye_navigating_the_nest',
    name = 'Navigating the Nest',
    zone = 'クロウラーの巣',
    loc = 'クロウラーの巣 (J-9)',
    npc = 'Bella',
    req = '区分: Other Areas、名声: バストゥーク 1、Lv.30+、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = 'ノクトベレー、ノクトダブレット、ノクトグローブ、ノクトブレー、ノクトゲートル',
    items = 'None',
    wiki = 'Other Areas',
    complete_on = {
        'ノクトベレーを手にいれた',
        'Obtained: Noct Beret',
        'ノクトダブレットを手にいれた',
        'Obtained: Noct Doublet',
        'ノクトグローブを手にいれた',
        'Obtained: Noct Gloves',
        'ノクトブレーを手にいれた',
        'Obtained: Noct Brais',
        'ノクトゲートルを手にいれた',
        'Obtained: Noct Gaiters',
    },
})

quest({
    id = 'catseye_negotiating_the_necropolis',
    name = 'Negotiating the Necropolis',
    zone = 'エルディーム古墳',
    loc = 'エルディーム古墳 (J-8)',
    npc = 'Aletta',
    req = '区分: Other Areas、名声: サンドリア 1、Lv.30+、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = 'アイゼンシャレル、アイゼンブルスト、アイゼンヘンツェ、アイゼンディヒリン、アイゼンシュー',
    items = 'None',
    wiki = 'Other Areas',
    complete_on = {
        'アイゼンシャレルを手にいれた',
        'Obtained: Eisenschaller',
        'アイゼンブルストを手にいれた',
        'Obtained: Eisenbrust',
        'アイゼンヘンツェを手にいれた',
        'Obtained: Eisenhentzes',
        'アイゼンディヒリンを手にいれた',
        'Obtained: Eisendiechlings',
        'アイゼンシューを手にいれた',
        'Obtained: Eisenschuhs',
    },
})

quest({
    id = 'catseye_horutoto_hakken',
    name = 'Horutoto Hakken',
    zone = '内ホルトト遺跡',
    loc = '内ホルトト遺跡 (H-8) 魔封門のすぐ先',
    npc = 'Gan-Ban',
    req = 'Lv.30+、名声: ウィンダス 1（ACE / CW / WEW）',
    prereq = 'なし',
    reward = '大地の鉢巻（モクシャ+3、VIT+2）、大地の衣（残心+2%、DEX+2）、大地の手甲（格闘スキル+1、片手刀スキル+1、両手刀スキル+1）、大地の下ばき（カウンター+2、AGI+2）、大地の脚絆（モクシャ+3、STR+2）。ソイル装備一式は、からくり士も装備できます。',
    items = '鉢巻: 亜麻糸x2、衣: 亜麻糸x1と草糸x2、手甲: ラワン材x2、下ばき: 毛糸x1、脚絆: 木綿糸x2',
    wiki = 'Other Areas',
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
    id = 'catseye_all_thine_heart',
    name = 'All Thine Heart',
    zone = '北サンドリア',
    loc = '北サンドリア (M-7)',
    npc = 'Door: Chantry',
    req = '区分: Other Areas、名声: サンドリア 1、Lv.40+、（CW）',
    prereq = 'なし',
    reward = 'イカロスウィング、ホーリーブレスト',
    items = 'None',
    wiki = 'Other Areas',
    repeatable = true,
    complete_on = {
        'イカロスウィングを手にいれた',
        'Obtained: Icarus Wing',
        'ホーリーブレストを手にいれた',
        'Obtained: Holy Breastplate',
    },
})

quest({
    id = 'catseye_runic_insurrection',
    name = 'Runic Insurrection',
    zone = 'バストゥーク商業区',
    loc = 'バストゥーク商業区 (F-10)',
    npc = 'Octavien',
    req = '区分: Jobs、名声: バストゥーク 1、Lv.75、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = 'Foil (Scroll)、ソビロクレイモア',
    items = '',
    wiki = 'Jobs',
    complete_on = {
        'Obtained: Foil (Scroll)',
        'You obtain Foil (Scroll)',
        'ソビロクレイモアを手にいれた',
        'Obtained: Sowilo Claymore',
    },
})

quest({
    id = 'catseye_forged_in_frost_and_flame',
    name = 'Forged in Frost and Flame',
    zone = 'バストゥーク商業区',
    loc = 'バストゥーク商業区 (F-10)',
    npc = 'Octavien',
    req = '区分: Jobs、名声: バストゥーク 1、Lv.RUN 40、（ACE / CW / WEW）',
    prereq = 'Runic Insurrection',
    reward = '',
    items = '',
    wiki = 'Jobs',
})

quest({
    id = 'catseye_the_way_of_the_blade',
    name = 'The Way of the Blade',
    zone = 'ジュノ下層',
    loc = 'ジュノ下層 (H-10)',
    npc = 'Vaulrien',
    req = '区分: Jobs、名声: バストゥーク 1、Lv.RUN 50、（ACE / CW / WEW）',
    prereq = 'Forged in Frost and Flame',
    reward = '',
    items = 'Runic Ingot x4; ダークインゴット x3; クァールの毛皮 x2; 金糸; 賢者の石',
    wiki = 'Jobs',
})

quest({
    id = 'catseye_the_unnamed_way',
    name = 'The Unnamed Way',
    zone = 'ウィンダス水の区',
    loc = 'ウィンダス水の区 (South)',
    npc = 'Master Lao',
    req = '区分: Jobs、名声: ウィンダス 1、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = 'マータレベル、インデポイズン',
    items = 'Any Level 75 job.; 海亀の甲羅',
    wiki = 'Jobs',
    complete_on = {
        'マータレベルを手にいれた',
        'Obtained: Matre Bell',
        'インデポイズンを手にいれた',
        'Obtained: Indi-Poison',
    },
})

quest({
    id = 'catseye_the_earth_holds_its_breath',
    name = 'The Earth Holds Its Breath',
    zone = 'ウィンダス水の区',
    loc = 'ウィンダス水の区 (South)',
    npc = 'Master Lao',
    req = '区分: Jobs、名声: ウィンダス 1、Lv.GEO 40、（ACE / CW / WEW）',
    prereq = 'The Unnamed Way',
    reward = '',
    items = '',
    wiki = 'Jobs',
})

quest({
    id = 'catseye_echoes_of_the_earth',
    name = 'Echoes of the Earth',
    zone = 'ジュノ下層',
    loc = 'ジュノ下層 (H-9)',
    npc = 'Nahele',
    req = '区分: Jobs、名声: ウィンダス 1、Lv.GEO 50、（ACE / CW / WEW）',
    prereq = 'The Earth Holds its Breath',
    reward = '',
    items = 'Geoweave Thread x6; 絹布 x2; ビロード; 金糸; サーメットチップス; カーネリアン',
    wiki = 'Jobs',
})

quest({
    id = 'catseye_daddy_issues',
    name = 'Daddy Issues',
    zone = 'ジュノ上層',
    loc = 'ジュノ上層 (G-7)',
    npc = 'Brittany',
    req = '区分: Limit Breaks、名声: ジュノ 1、Lv.DNC 66+、（ACE / CW / WEW）',
    prereq = 'The Road to Divadom',
    reward = 'レベル上限が75に引き上げられます',
    items = 'Dancer Main Job lvl66+',
    wiki = 'Limit Breaks',
})

quest({
    id = 'catseye_immortal_kombat',
    name = 'Immortal Kombat!',
    zone = 'アトルガン白門',
    loc = 'アトルガン白門 (J-10)',
    npc = 'Nandiyah',
    req = '区分: Limit Breaks、名声: 1、Lv.BLU 66+、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = 'レベル上限が75に引き上げられます',
    items = 'Blue Mage Main Job Lv.66+',
    wiki = 'Limit Breaks',
})

quest({
    id = 'catseye_master_of_puppets',
    name = 'Master of Puppets',
    zone = 'バストゥーク商業区',
    loc = 'バストゥーク商業区 (F-9)',
    npc = 'Kirk',
    req = '区分: Limit Breaks、名声: 1、Lv.PUP 66+、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = 'レベル上限が75に引き上げられます',
    items = 'Puppetmaster Main Job Lv.66+',
    wiki = 'Limit Breaks',
})

quest({
    id = 'catseye_missing_rum',
    name = 'Missing Rum',
    zone = 'アトルガン白門',
    loc = 'アトルガン白門 (J-12)',
    npc = 'Jacquotte',
    req = '区分: Limit Breaks、名声: 1、Lv.COR 66+、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = 'レベル上限が75に引き上げられます',
    items = 'Corsair Main Job Lv.66+',
    wiki = 'Limit Breaks',
})

quest({
    id = 'catseye_revenge_of_the_nerds',
    name = 'Revenge of the Nerds',
    zone = 'エルディーム古墳',
    loc = 'エルディーム古墳 (S)',
    npc = 'Lewis',
    req = '区分: Limit Breaks、名声: 1、Lv.SCH 66+、（ACE / CW / WEW）',
    prereq = 'なし',
    reward = 'レベル上限が75に引き上げられます',
    items = 'Scholar Main Job Lv.66+',
    wiki = 'Limit Breaks',
})

return M
