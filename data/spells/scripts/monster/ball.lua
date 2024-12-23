local area = {
  {0, 1, 0},
  {1, 3, 1},
  {0, 1, 0},
}
local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 3)
combat:setArea(createCombatArea(area))
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 13)


function onCastSpell(creature, var)
	local cid = creature:getId()
  local target = getCreatureTarget(cid)
  if target > 1 then
    doSendAnimatedText("Ball", getThingPos(cid), TEXTCOLOR_AIR)  
    doCombat(cid, combat, var)
  end
  return true
end