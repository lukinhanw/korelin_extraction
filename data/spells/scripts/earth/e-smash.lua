
local condition = createConditionObject(CONDITION_DRUNK)
setConditionParam(condition, CONDITION_PARAM_TICKS, 20000)

local function smashCharge(cid, target, i, n, equals, var)
  if not isCreature(target) then return true end
  local player = Player(cid)
  local stones = {
  [1] = {effect = CONST_ANI_SMALLSTONE, minDmg = math.floor((player:getLevel() + bender_attack['earth_smash1'].min) * bender_attack['earth_smash1'].min_mult), maxDmg = math.floor((player:getLevel() + bender_attack['earth_rock1'].max) * bender_attack['earth_rock1'].max_mult)},
  [2] = {effect = CONST_ANI_LARGEROCK, minDmg = math.floor((player:getLevel() + bender_attack['earth_smash2'].min) * bender_attack['earth_smash2'].min_mult), maxDmg = math.floor((player:getLevel() + bender_attack['earth_rock2'].max) * bender_attack['earth_rock2'].max_mult)},
  [3] = {effect = CONST_ANI_WHIRLWINDCLUB, minDmg = math.floor((player:getLevel() + bender_attack['earth_smash1'].min) * bender_attack['earth_smash3'].min_mult), maxDmg = math.floor((player:getLevel() + bender_attack['earth_rock3'].max) * bender_attack['earth_rock3'].max_mult)},
  [4] = {effect = CONST_ANI_SMALLSTONE, minDmg = math.floor((player:getLevel() + bender_attack['earth_smash1'].min) * bender_attack['earth_smash1'].min_mult), maxDmg = math.floor((player:getLevel() + bender_attack['earth_rock1'].max) * bender_attack['earth_rock1'].max_mult)},
  [5] = {effect = CONST_ANI_LARGEROCK, minDmg = math.floor((player:getLevel() + bender_attack['earth_smash2'].min) * bender_attack['earth_smash2'].min_mult), maxDmg = math.floor((player:getLevel() + bender_attack['earth_rock2'].max) * bender_attack['earth_rock2'].max_mult)},
  [6] = {effect = CONST_ANI_WHIRLWINDCLUB, minDmg = math.floor((player:getLevel() + bender_attack['earth_smash3'].min) * bender_attack['earth_smash3'].min_mult), maxDmg = math.floor((player:getLevel() + bender_attack['earth_rock3'].max) * bender_attack['earth_rock3'].max_mult)},
  }


  if not isCreature(cid) or not isCreature(target) or n <= 0 then return false end
  local playerPos = getThingPos(cid)
  local topPos = {x=playerPos.x -(math.random(16,16)), y=playerPos.y- (math.random(16,16)), z=playerPos.z}
  if i == equals then
    for v = 1, 8 do
    	local i = math.random(1, 6)
    	local random = stones[i]
      	

    	if v == 8 then
    		addEvent(function()
	      		if isCreature(target) then

	    			doSendDistanceShoot(getThingPos(cid), topPos, random.effect)
	    			doSendDistanceShoot(topPos, getThingPos(target), random.effect)
	    			addEvent(doSendAnimatedText, 1200, "Confused!!",getThingPos(target), TEXTCOLOR_YELLOW)
	          		addEvent(doTargetCombatHealth, 200+(100 * v), cid, target, 1, -random.minDmg, -random.maxDmg, 32)
					print()
					if target > 0 then
						doAddCondition(target, condition)
					end
	        	end
      		end, 150 * v)
    	else
	      	addEvent(function()
	      		if isCreature(target) then
	    			doSendDistanceShoot(getThingPos(cid), topPos, random.effect)
	    			doSendDistanceShoot(topPos, getThingPos(target), random.effect)
	          		addEvent(doTargetCombatHealth, 200+(100 * v), cid, target, 1, -random.minDmg, -random.maxDmg, 35)
	        	end
	      	end, 150 * v)
	    end
    end
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
  doSendMagicEffect(area[(i%#area)], 40)
  doSendMagicEffect(area2[(i%#area2)],40)

  addEvent(smashCharge, 150, cid, target, i+1, n-1, equals, var)
end

function onCastSpell(player, var)
  if not player then return false end

  local cid = player:getId()

  local target = getCreatureTarget(cid)
  if target > 1 then
    if player:canMove() == true then
      noMove(cid, 1, 2)
    end
    doSendAnimatedText("Rock Smash", getThingPos(cid), TEXTCOLOR_LIGHTGREEN)
    smashCharge(cid, target, 1, 8, 8, var)
  end
  return true
end