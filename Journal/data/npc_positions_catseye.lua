-- CatsEye NPC positions, in the same shape as data/npc_positions.lua:
--   ["Name"] = { { zone id, x, y, height }, ... }
-- x and y are the two ground coordinates. The height is not used for distance.
-- This table starts empty. /journal npcpos writes captures to
-- config/addons/Journal/npc_positions_custom.lua, which is merged at load.
return {}
