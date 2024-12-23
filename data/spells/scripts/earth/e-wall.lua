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
  local minDmg = ((player:getLevel() + bender_attack['earth_wall'].min) * bender_attack['earth_wall'].min_mult)
  local maxDmg = ((player:getLevel() + bender_attack['earth_wall'].max) * bender_attack['earth_wall'].max_mult)

  local cid = player:getId()
  if not isCreature(cid) then
    return true
  end
  local dmg = -10
  local wall_area = getPosfromArea(cid, area)
  local dir = getPlayerLookDir(cid)
  for _,i in pairs(wall_area) do
    doAreaCombatHealth(cid, 1, i, 0, -minDmg, -maxDmg, 4)
    if isWalkable(i, false, true, true) then
      for v = 1, 3 do
        addEvent(createWalls, 250*v, walls[dir][v], i, 4*1000)
        -- addEvent(doSendMagicEffect, 250*v, i, 85)
      end
    else
      doSendMagicEffect(i, 3)
    end
  end
  if player:canMove() == true then
    noMove(cid, 1, 2)
  end
  doSendAnimatedText("Wall", getThingPos(cid), TEXTCOLOR_LIGHTGREEN)
  return true
end
