local area = {
  {0, 1, 0},
  {1, 3, 1},
  {0, 1, 0},
}
local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 7)
combat:setArea(createCombatArea(area))
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 52)

function onGetFormulaValues(player, skill, attack, factor)
    local min = ((player:getLevel() + bender_attack['fire_blast'].min) * bender_attack['fire_blast'].min_mult)
    local max = ((player:getLevel() + bender_attack['fire_blast'].max) * bender_attack['fire_blast'].max_mult)
  return -min, -max
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")


function onCastSpell(player, var)
	if not player then return false end
	local cid = player:getId()
  local target = getCreatureTarget(cid)
  if target > 1 then
    doSendAnimatedText("Blast", getThingPos(cid), TEXTCOLOR_ORANGE)  
    doCombat(cid, combat, var)
  end
  return true
end