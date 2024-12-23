local condition = Condition(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 10000)
condition:setFormula(-0.8, 0, -0.8, 0)

local function petrifyCharge(cid, target, minDmg, maxDmg, i, n, equals)
  if not isCreature(cid) or not isCreature(target) or n <= 0 then return false end
  if i == equals then
    createStones(getThingPos(target), 2*1000)
    doTargetCombatHealth(cid, target, COMBAT_PHYSICALDAMAGE, minDmg, maxDmg, 35)
    doAddCondition(target, condition)
    return true
  end

  local pos = getThingPos(target)
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
  doSendMagicEffect(area[(i%#area)], 101)
  addEvent(petrifyCharge, 150, cid, target, minDmg, maxDmg, i+1, n-1, equals)
end

function onCastSpell(player, var)
  if not player then return false end
  local minDmg = ((player:getLevel() + bender_attack['earth_petrify'].min) * bender_attack['earth_petrify'].min_mult)
  local maxDmg = ((player:getLevel() + bender_attack['earth_petrify'].max) * bender_attack['earth_petrify'].max_mult)

  local cid = player:getId()

  local target = getCreatureTarget(cid)
  if target > 1 then
    if player:canMove() == true then
      noMove(cid, 1, 2)
    end
    doSendAnimatedText("Petrify", getThingPos(cid), TEXTCOLOR_LIGHTGREEN)
    petrifyCharge(cid, target, -minDmg, -maxDmg, 1, 12, 12)
  end
  return true
end
