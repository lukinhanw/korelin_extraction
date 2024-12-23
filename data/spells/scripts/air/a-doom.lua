local area = {
  {0, 1, 0},
  {1, 3, 1},
  {0, 1, 0},
}
local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 3)
combat:setArea(createCombatArea(area))

function onGetFormulaValues(player, skill, attack, factor)
  local min = ((player:getLevel() + bender_attack['air_doom'].min) * bender_attack['air_doom'].min_mult)
  local max = ((player:getLevel() + bender_attack['air_doom'].max) * bender_attack['air_doom'].max_mult)
  return -min, -max 
end
function onTargetCreature(creature, target)
  moveCreature(creature:getId(), target:getId(), getPushDir(creature:getId(), target:getId()))
end  

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")  
combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local function doDoom(cid, time)
  if not isCreature(cid) then return true end
  local playerPos = getThingPos(cid)
  if time > 0 then
    for i = 1, 4 do
      local toPos = {x=playerPos.x - (math.random(-4,4)), y=playerPos.y- (math.random(-4,4)), z=playerPos.z}
      if isSightClear(getThingPos(cid), toPos, false) == true  then
        doSendDistanceShoot(getThingPos(cid), toPos, 43)
        addEvent(doCombat, 120*i, cid, combat, positionToVariant(toPos))
      end
    end
    addEvent(doDoom, 120, cid, time-1)
  end
end

function onCastSpell(player, var)
	if not player then return false end
	local cid = player:getId()
  local playerPos = player:getPosition()
  
  doSendAnimatedText("Doom", getThingPos(cid), TEXTCOLOR_AIR)  
    
  local count = 0
	local function doEffect()
		if count < 4 then
			doSendMagicEffect(player:getPosition(), 117)
			count = count + 1
			addEvent(doEffect, 500)
		end
	end
	doEffect()
  
  addEvent(doDoom, 2000, cid, 24)
  if player:canMove() == true then
    noMove(cid, 1, 3)
  end
  return true
end