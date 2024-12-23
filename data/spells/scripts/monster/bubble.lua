
local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)
combat:setParameter(COMBAT_PARAM_EFFECT, 26)



function onCastSpell(creature, var)

  local cid = creature:getId()

  if creature:canMove() == true then
    noMove(cid, 1, 2)
  end
  doSendAnimatedText("Bubble", getThingPos(cid), TEXTCOLOR_WATER)
  for v = 1, 12 do
    addEvent(valid(doCombat), 110*v, cid, combat, var)
  end
  
  return true
end