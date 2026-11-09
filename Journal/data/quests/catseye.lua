local M = {}

-- CatsEyeXI custom quests. The server does not put this quest in the
-- client's quest log, so it stays untracked: no tracker_area or tracker_id.

M[#M + 1] = {
    id = 'catseye_horutoto_hakken',
    name = 'Horutoto Hakken',
    area = 'catseye',
    zone = '内ホルトト遺跡',
    loc = '内ホルトト遺跡 (H-8) 魔封門のすぐ先',
    npc = 'Gan-Ban',
    req = 'Lv.30+、名声: ウィンダス 1（ACE / CW / WEW）',
    prereq = 'なし',
    reward = '大地の鉢巻（モクシャ+3、VIT+2）、大地の衣（残心+2%、DEX+2）、大地の手甲（格闘スキル+1、片手刀スキル+1、両手刀スキル+1）、大地の下ばき（カウンター+2、AGI+2）、大地の脚絆（モクシャ+3、STR+2）。ソイル装備一式は、からくり士も装備できます。',
    items = '鉢巻: 亜麻糸x2、衣: 亜麻糸x1と草糸x2、手甲: ラワン材x2、下ばき: 毛糸x1、脚絆: 木綿糸x2',
    trackable = false,
}

return M
