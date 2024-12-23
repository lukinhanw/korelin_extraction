function onCastSpell(player, var)


  local minDmg = ((player:getLevel() + bender_attack['earth_punch'].min) * bender_attack['earth_punch'].min_mult) / 2.4
  local maxDmg = ((player:getLevel() + bender_attack['earth_punch'].max) * bender_attack['earth_punch'].max_mult) / 2.4
  local cid = player:getId() 
  local target = getCreatureTarget(cid)
  if target > 1 then
 
    if getDistanceBetween(getThingPos(cid), getThingPos(target)) > 1 then
 		  return doPlayerSendCancel(cid, "You are so far.")
 	  end 
    doSendAnimatedText("Punch", player:getPosition(), TEXTCOLOR_LIGHTGREEN)
    for i = 1, 3 do
      addEvent(function()
      	if not isCreature(target) or not isCreature(cid) then return true end
      	doTargetCombatHealth(cid, target, 1, -minDmg, -maxDmg, 96)
      end, i*250)
    end
  else
    return doPlayerSendCancel(cid, 'You need select a target.')
  end
  return true
end
