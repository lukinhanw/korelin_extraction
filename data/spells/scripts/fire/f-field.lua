local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITBYFIRE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_FIRE)


function onGetFormulaValues(player, skill, attack, factor)
  local min = ((player:getLevel() + bender_attack['fire_spin'].min) * bender_attack['fire_spin'].min_mult)
  local max = ((player:getLevel() + bender_attack['fire_spin'].max) * bender_attack['fire_spin'].max_mult)
  return -min, -max
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local function doBurn(cid, target, pos)
  if not isCreature(cid) then return true end
  local player = Player(cid)  
  if pos ~= getThingPos(target) then
    return true
  end
    doAreaCombatHealth(cid, 1, pos, 0, -getPlayerLevel(target), -getPlayerLevel(target), CONST_ME_HITBYFIRE)
    addEvent(doBurn, 250, cid, target, pos)
end

function onCastSpell(creature, variant, isHotkey)
	local cid = creature:getId()
	local playername = creature:getName()
  local pos = getPositionByDirection(getThingPos(cid), getPlayerLookDir(cid), 1)
 	local target = getTopCreature(pos).uid
  doSendAnimatedText("Field", getThingPos(cid), TEXTCOLOR_ORANGE)
   	if haveTile(getCreatureLookPosition(cid)) then 
      if(isWalkable(getCreatureLookPosition(cid))) then
		    local fire_field = doCreateItem(ITEM_FIREFIELD_PVP_FULL, 1, getCreatureLookPosition(cid))
        if not fire_field then return false end
        doDecayItem(fire_field)
        doItemSetAttribute(fire_field, "name","a fire field. They belongs to "..playername) 
      end 
     end
	doCombat(cid, combat, variant)

  if target and isPlayer(target) then -- combo fire thrower
    if creature:getStorageValue(storage.fire_thrower_time) == 1 +  os.time() then
      doBurn(cid, target, getThingPos(target))
    end
  end
  return true
end
