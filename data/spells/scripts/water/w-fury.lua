local area = {
  {0, 0, 0},
  {0, 3, 0},
  {0, 0, 0},
}
local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 2)
combat:setArea(createCombatArea(area))

function onGetFormulaValues(player, skill, attack, factor)
  local min = ((player:getLevel() + bender_attack['water_fury'].min) * bender_attack['water_fury'].min_mult)
  local max = ((player:getLevel() + bender_attack['water_fury'].max) * bender_attack['water_fury'].max_mult)
  return -min, -max
end
  
combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local function doFury(cid, target, time)
  if not target then return true end
  local playerPos = getThingPos(cid)
  
  local lookPos = {
    [0] = {x=playerPos.x - (math.random(-4, 4)), y=playerPos.y + (math.random(1, 4)), z=playerPos.z},

    [1] = {x=playerPos.x - (math.random(1, 4)), y=playerPos.y- (math.random(-4, 4)), z=playerPos.z},

    [2] = {x=playerPos.x - (math.random(-4, 4)), y=playerPos.y - math.random(1, 4), z=playerPos.z},

    [3] = {x=playerPos.x + (math.random(1, 4)), y=playerPos.y - math.random(-4, 4), z=playerPos.z},
  }
  if time > 0 then
      doSendDistanceShoot(lookPos[getPlayerLookDir(cid)], getThingPos(target),  37)       
      doSendDistanceShoot(lookPos[getPlayerLookDir(cid)], getThingPos(target),  37)
      doSendDistanceShoot(lookPos[getPlayerLookDir(cid)], getThingPos(target),  37)      
      doSendDistanceShoot(lookPos[getPlayerLookDir(cid)], getThingPos(target),  37)      
      doSendMagicEffect(lookPos[getPlayerLookDir(cid)], 54)
      doSendMagicEffect(lookPos[getPlayerLookDir(cid)], 54)
      doSendMagicEffect(lookPos[getPlayerLookDir(cid)], 54)
      doSendMagicEffect(lookPos[getPlayerLookDir(cid)], 54)
      doCombat(cid, combat, positionToVariant(target))
      addEvent(function()
        if isCreature(target) or isCreature(cid) then
            doFury(cid, target, time-1)
        end
      end, 100)
  end
end

function onCastSpell(player, var)
	if not player then return false end
	local cid = player:getId()
  local playerPos = player:getPosition()
  local time = 10
  if not nearWater(cid) then
    time = 4
  else
    time = time
  end
  if hasWater(cid, 9) then
    if not nearWater(cid) then
      doSendAnimatedText("Spheres", getThingPos(cid), TEXTCOLOR_WATER)  
    else
      doSendAnimatedText("Fury", getThingPos(cid), TEXTCOLOR_MAYABLUE)  
    end
    doFury(cid, getCreatureTarget(cid), time)
    if player:canMove() == true then
      noMove(cid, 0.5, 2)
    end  
  end
  return true
end