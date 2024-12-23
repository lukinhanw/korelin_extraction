local area_dash = {
	{1, 3, 1},
}

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 4)
combat:setArea(createCombatArea(area_dash))

function onGetFormulaValues(player, skill, attack, factor)
    local min = (player:getLevel() / 5) + (skill * attack * 0.12) + 20
    local max = (player:getLevel() / 5) + (skill * attack * 0.18) + 25
  return -min, -max
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")


local combat2 = Combat()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, 4)
combat2:setArea(createCombatArea(area_dash))

  function onGetFormulaValues2(player, skill, attack, factor)
    local min = (player:getLevel() / 5) + (skill * attack * 0.10) + 15
    local max = (player:getLevel() / 5) + (skill * attack * 0.15) + 20
    return -min, -max
  end


combat2:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues2")

local function doDash(cid, distance)
	if distance > 0 then
		if isWalkable(changeposbydir(getThingPos(cid), getPlayerLookDir(cid), 1), true, true, true) then
			doMoveCreature(cid, getPlayerLookDir(cid))
		else
			doCombat(cid, combat2, positionToVariant(changeposbydir(getThingPos(cid), getPlayerLookDir(cid), 1)))
			return true
		end
		doDash(cid, distance -1)
	else
		doCombat(cid, combat, positionToVariant(changeposbydir(getThingPos(cid), getPlayerLookDir(cid), 1)))
	end
	return true
end

function onCastSpell(player, var)
	local cid = player:getId()
  	doSendAnimatedText("Dash", getThingPos(cid), TEXTCOLOR_RED)
  	
  	if player:canMove() == true then
		noMove(cid, 0.5, 2)
	end
	doDash(cid, 4)	
	return true
end