local area = {
  {0, 0, 0},
  {0, 3, 0},
  {0, 0, 0},
}

local area_storm = {

	{0, 0, 1, 1, 1, 0, 0},
	{0, 1, 1, 1, 1, 1, 0},
	{1, 1, 1, 1, 1, 1, 1},
	{1, 1, 1, 3, 1, 1, 1},
	{1, 1, 1, 1, 1, 1, 1},
	{0, 1, 1, 1, 1, 1, 0},
	{0, 0, 1, 1, 1, 0, 0}
}
local condition = Condition(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 7000)
condition:setFormula(-0.9, 0, -0.9, 0)

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 26)
combat:setArea(createCombatArea(area_storm))

function onGetFormulaValues(player, skill, attack, factor)
  local min = ((player:getLevel() + bender_attack['water_storm'].min) * bender_attack['water_storm'].min_mult)
  local max = ((player:getLevel() + bender_attack['water_storm'].max) * bender_attack['water_storm'].max_mult)
  return -min, -max
end
function onTargetCreature(creature, target)
  moveCreature(creature:getId(), target:getId(), math.random(0,7))
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local combat2 = Combat()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, 79)
combat2:setArea(createCombatArea(area))
combat2:addCondition(condition)



function onCastSpell(player, var)
  if not player then return false end
  local cid = player:getId()
  local playerPos = player:getPosition()
  if not hasWater(cid, 4) then return true end
  doSendAnimatedText("Storm", getThingPos(cid), TEXTCOLOR_WATER)
  doSendMagicEffect(getThingPos(cid), 107)
  -- chargeEffect(cid, 40, 1, 12)
  for i = 1,5 do
    local topPos = {x=playerPos.x - (math.random(7,7)), y=playerPos.y- (math.random(7,7)), z=playerPos.z}
    local toPos = {x=playerPos.x - (math.random(-2,2)), y=playerPos.y- (math.random(-2,2)), z=playerPos.z}
    addEvent(doSendDistanceShoot,  2100 + (i * 400), topPos, toPos, 37)
    addEvent(doCombat, 2000 + (i*400), cid, combat, var)
    addEvent(doCombat, 2000 + (i *400), cid, combat2, positionToVariant(toPos))
  end
  if player:canMove() == true then
    noMove(cid, 1, 5)
  end

  return true
end
