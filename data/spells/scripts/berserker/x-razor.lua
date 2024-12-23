
local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 32)
combat:setParameter(COMBAT_PARAM_EFFECT, 18)

function onGetFormulaValues(player, skill, attack, factor)
  local min = (player:getLevel() / 5) + (skill * attack * 0.3) + 7
  local max = (player:getLevel() / 5) + (skill * attack * 0.4) + 11  
  return -min, -max
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local function razorCharge(cid, target, i, n, equals, var)
  if not isCreature(cid) or not isCreature(target) or n <= 0 then return false end
  if i == equals then
    doCombat(cid, combat, var)
    return true
  end

  local pos = getThingPos(cid)

  local area = {
    {x=pos.x+1, y=pos.y+1, z=pos.z},
    {x=pos.x+1, y=pos.y, z=pos.z},
    {x=pos.x+1, y=pos.y-1, z=pos.z},
    {x=pos.x, y=pos.y-1, z=pos.z},
    {x=pos.x-1, y=pos.y-1, z=pos.z},
    {x=pos.x-1, y=pos.y, z=pos.z},
    {x=pos.x-1, y=pos.y+1, z=pos.z},
    {x=pos.x, y=pos.y+1, z=pos.z},
    {x=pos.x+1, y=pos.y+1, z=pos.z},
    {x=pos.x+1, y=pos.y, z=pos.z},
    {x=pos.x+1, y=pos.y-1, z=pos.z},
    {x=pos.x, y=pos.y-1, z=pos.z},

  }
  local area2 ={
    {x=pos.x-1, y=pos.y-1, z=pos.z},
    {x=pos.x-1, y=pos.y, z=pos.z},
    {x=pos.x-1, y=pos.y+1, z=pos.z},
    {x=pos.x, y=pos.y+1, z=pos.z},
    {x=pos.x+1, y=pos.y+1, z=pos.z},
    {x=pos.x+1, y=pos.y, z=pos.z},
    {x=pos.x+1, y=pos.y-1, z=pos.z},
    {x=pos.x, y=pos.y-1, z=pos.z},
    {x=pos.x-1, y=pos.y-1, z=pos.z},
    {x=pos.x-1, y=pos.y, z=pos.z},
    {x=pos.x-1, y=pos.y+1, z=pos.z},
    {x=pos.x, y=pos.y+1, z=pos.z},

  }
  doSendMagicEffect(area[(i%#area)], 40)
  doSendMagicEffect(area2[(i%#area2)],40)

  addEvent(razorCharge, 150, cid, target, i+1, n-1, equals, var)
end

function onCastSpell(player, var)
  local cid = player:getId()

  local target = getCreatureTarget(cid)
 
  if target > 1 then
    if player:canMove() == true then
      noMove(cid, 0.5, 1)
    end
    doSendAnimatedText("Razor", getThingPos(cid), 93)
    razorCharge(cid, target, 1, 18, 18, var)
  end
  return true
end