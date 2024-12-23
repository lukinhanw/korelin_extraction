local area = {
    {0, 1, 0},
    {0, 3, 0},
    {0, 0, 0},
}

local walls = {
  [0] = {3494, 3493, 3491},
  [1] = {3488, 3487, 3485},
  [2] = {3494, 3493, 3491},
  [3] = {3488, 3487, 3485},
}
function onCastSpell(player, var)
  local cid = player:getId()
  if not isCreature(cid) then
    return true
  end
  local pos_dir = getCreatureLookPosition(cid)
  local look_dir = getPlayerLookDir(cid)
  print(walls[look_dir][3])
  for i = 0,10 do
    pos_dir.stackpos = i
    local item = getThingfromPos(pos_dir)
    local x = item.itemid
    if x == walls[look_dir][3] then
      doRemoveItem(item.uid, 1)
    end
  end
  return true
end
