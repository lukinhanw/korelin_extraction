local area = {
  {0, 1, 0},
  {1, 3, 1},
  {0, 1, 0},
}
local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 3)
combat:setArea(createCombatArea(area))
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 43)

function onGetFormulaValues(player, skill, attack, factor)
    local min = ((player:getLevel() + bender_attack['air_ball'].min) * bender_attack['air_ball'].min_mult)
    local max = ((player:getLevel() + bender_attack['air_ball'].max) * bender_attack['air_ball'].max_mult)
  return -min, -max
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")


function onCastSpell(player, var)
  if not player then return false end
  local cid = player:getId()
  local target = getCreatureTarget(cid)
  if target > 1 then
    doSendAnimatedText("Ball", getThingPos(cid), TEXTCOLOR_AIR)  
    doCombat(cid, combat, var)
  end
  return true
end