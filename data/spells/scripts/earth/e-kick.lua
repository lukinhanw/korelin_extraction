function onCastSpell(player, var)
  local minDmg = ((player:getLevel() + bender_attack['earth_kick'].min) * bender_attack['earth_kick'].min_mult)
  local maxDmg = ((player:getLevel() + bender_attack['earth_kick'].max) * bender_attack['earth_kick'].max_mult)
  if not player then return false end
  local cid = player:getId()

  local dmg = -5
  local target = getCreatureTarget(cid)
  if target > 1 then 
    if getDistanceBetween(getThingPos(cid), getThingPos(target)) > 6 then
      return doPlayerSendCancel(cid, "You are so far.")
    end 
    local pos = getThingPos(target)
    createStones(getThingPos(target), 2*1000)
    if player:canMove() == true then
      noMove(cid, 0.1, 2)
    end
    doSendAnimatedText("Kick", getThingPos(cid), TEXTCOLOR_LIGHTGREEN)
    doTargetCombatHealth(cid, target, COMBAT_PHYSICALDAMAGE, -minDmg, -maxDmg, CONST_ME_STUN)
  	moveCreature(cid, target, getPushDir(cid, target))
    return true
  else
    return doPlayerSendCancel(cid, 'You need select a target.')
  end
end
