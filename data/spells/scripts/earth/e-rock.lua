function onCastSpell(player, var)
  local stones = {
  [1] = {effect = CONST_ANI_SMALLSTONE, minDmg = math.floor((player:getLevel() + bender_attack['earth_rock1'].min) * bender_attack['earth_rock1'].min_mult), maxDmg = math.floor((player:getLevel() + bender_attack['earth_rock1'].max) * bender_attack['earth_rock1'].max_mult)},
  [2] = {effect = CONST_ANI_LARGEROCK, minDmg = math.floor((player:getLevel() + bender_attack['earth_rock2'].min) * bender_attack['earth_rock2'].min_mult), maxDmg = math.floor((player:getLevel() + bender_attack['earth_rock2'].max) * bender_attack['earth_rock2'].max_mult)},
  [3] = {effect = CONST_ANI_WHIRLWINDCLUB, minDmg = math.floor((player:getLevel() + bender_attack['earth_rock3'].min) * bender_attack['earth_rock3'].min_mult), maxDmg = math.floor((player:getLevel() + bender_attack['earth_rock3'].max) * bender_attack['earth_rock3'].max_mult)},
  [4] = {effect = CONST_ANI_SMALLSTONE, minDmg = math.floor((player:getLevel() + bender_attack['earth_rock1'].min) * bender_attack['earth_rock1'].min_mult), maxDmg = math.floor((player:getLevel() + bender_attack['earth_rock1'].max) * bender_attack['earth_rock1'].max_mult)},
  [5] = {effect = CONST_ANI_LARGEROCK, minDmg = math.floor((player:getLevel() + bender_attack['earth_rock2'].min) * bender_attack['earth_rock2'].min_mult), maxDmg = math.floor((player:getLevel() + bender_attack['earth_rock2'].max) * bender_attack['earth_rock2'].max_mult)},
  [6] = {effect = CONST_ANI_WHIRLWINDCLUB, minDmg = math.floor((player:getLevel() + bender_attack['earth_rock3'].min) * bender_attack['earth_rock3'].min_mult), maxDmg = math.floor((player:getLevel() + bender_attack['earth_rock3'].max) * bender_attack['earth_rock3'].max_mult)},
 
  }
  local cid = player:getId()
  local target = getCreatureTarget(cid)
  if target > 1 then
    if isSightClear(getThingPos(cid), getThingPos(target), 0) == 0 then
      return 1
    end
    if player:canMove() == true then
      noMove(cid, 0.2, 2)
    end
    local i = math.random(1, 6)
    local random = stones[i]
 	  if getDistanceBetween(getThingPos(cid), getThingPos(target)) > 4 then
      return doPlayerSendCancel(cid, "You are so far.")
  	end 
  	doSendAnimatedText("RockThrow", getThingPos(cid), TEXTCOLOR_LIGHTGREEN)
    doSendDistanceShoot(getThingPos(cid), getThingPos(target), random.effect)
    doTargetCombatHealth(cid, target, 1, -random.minDmg, -random.maxDmg, 3)
  else
    return doPlayerSendCancel(cid, 'You need select a target.')
  end
  return true
end
