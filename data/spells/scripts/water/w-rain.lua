local area = {
  {0, 0, 0},
  {0, 3, 0},
  {0, 0, 0},
}
local condition = Condition(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 12000)
condition:setFormula(-0.6, 0, -0.6, 0)

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 79)
combat:setArea(createCombatArea(area))
combat:addCondition(condition)
function onTargetCreature(creature, target)
  doSendMagicEffect(target:getPosition(), 14)
  doSendAnimatedText("Slow!", target:getPosition(), 212)
end
local function doRain(cid, time)
  if not isCreature(cid) then return false end
  local playerPos = getThingPos(cid)
  if time > 0 then

    for i = 1, 3 do
      local topPos = {x=playerPos.x - (math.random(18,18)), y=playerPos.y- (math.random(18,18)), z=playerPos.z}
      local toPos = {x= playerPos.x + (math.random(-2,2)), y=playerPos.y- (math.random(-2,2)), z=playerPos.z}

      if isSightClear(getThingPos(cid), toPos, false) == true  then
    	  doSendDistanceShoot(topPos, toPos, 37)
   		  doCombat(cid, combat, positionToVariant(toPos))
  	  end
    end
  end
  addEvent(doRain, 250, cid, time-1)
end
combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")
function onCastSpell(player, var)
  if not player then return false end
  local cid = player:getId()
  if not hasWater(cid, 3) then return false end
  doSendAnimatedText("Rain", getThingPos(cid), TEXTCOLOR_WATER)
  doRain(cid, 15)
  return true
end