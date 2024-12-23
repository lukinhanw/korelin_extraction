function onCastSpell(player, var)
	if not player then return false end
	

  local minDmg = ((player:getLevel() + bender_attack['fire_jolt'].min) * bender_attack['fire_jolt'].min_mult)
  local maxDmg = ((player:getLevel() + bender_attack['fire_jolt'].max) * bender_attack['fire_jolt'].max_mult)
	
  local cid = player:getId()
  
  local target = getCreatureTarget(cid)
  if target > 1 then
    if getDistanceBetween(getThingPos(cid), getThingPos(target)) > 4 then
      return doPlayerSendCancel(cid, "You are so far.")
    end 
    if player:canMove() == true then
      noMove(cid, 0.1, 2)
    end    
    doSendAnimatedText("Jolt", getThingPos(cid), TEXTCOLOR_RED)  
    doSendDistanceShoot(getThingPos(cid),getThingPos(target), 33)
    doTargetCombatHealth(cid, target, COMBAT_PHYSICALDAMAGE, -minDmg, -maxDmg, 38)
    moveCreature(cid, target, getPushDir(cid, target))    
  else
    return doPlayerSendCancel(cid, 'You need select a target.')
  end
  return true
end