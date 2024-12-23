local area = {
  [1] = {
    {0, 1, 0},
    {0, 3, 0},
    {0, 0, 0},
  },
  [2] = {
    {1, 1, 1},
    {0, 3, 0},
    {0, 0, 0},
  },
  [3] = {
    {1, 1, 1, 1, 1},
    {0, 0, 3, 0, 0},
    {0, 0, 0, 0, 0},
  },
}

function onCastSpell(player, var)
  local min = ((player:getLevel() + bender_attack['earth_barrier'].min) * bender_attack['earth_barrier'].min_mult)
  local max = ((player:getLevel() + bender_attack['earth_barrier'].max) * bender_attack['earth_barrier'].max_mult)
  local cid = player:getId()
  if not isCreature(cid) then
    return true
  end

  local v = getPlayerStorageValue(cid, storage.barrier)
  local time1 = getPlayerStorageValue(cid, storage.barrier_time1)
  local time2 = getPlayerStorageValue(cid, storage.barrier_time2)
  
  if v < 1 then 
    v = 1 
  end
  
  local barrier_area = getPosfromArea(cid, area[v])
  
  for _,i in pairs(barrier_area) do
    doAreaCombatHealth(cid, 1, i, 0, -minDmg, -maxDmg, CONST_ME_NONE)
    if isWalkable(i, true, true, true) then
      createBarriers(i, 8*1000)
      doSendMagicEffect(i, 3)
    else
      doSendMagicEffect(i, 3)
    end
  end
  doSendAnimatedText("Barrier", getThingPos(cid), TEXTCOLOR_LIGHTGREEN)
  if v > 1 and os.clock() - time1 - (time2/1000) > 1 then v = 1 end
  setPlayerStorageValue(cid, storage.barrier, v%3+1)
  setPlayerStorageValue(cid, storage.barrier_time1, math.floor(os.clock()))
  setPlayerStorageValue(cid, storage.barrier_time2, (os.clock() - math.floor(os.clock())) * 1000)
  return true
end
