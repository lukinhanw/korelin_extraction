local area = {
{0, 0, 0},
{1, 3, 1},
{0, 0, 0},
}

local condition = createConditionObject(CONDITION_DRUNK)
setConditionParam(condition, CONDITION_PARAM_TICKS, 20000)

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 32)
combat:setArea(createCombatArea(area))
combat:addCondition(condition)

function onGetFormulaValues(player, skill, attack, factor)
    local min = (player:getLevel() / 5) + (skill * attack * 0.13) + 10
    local max = (player:getLevel() / 5) + (skill * attack * 0.09) + 15
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

function onCastSpell(player, var)

	local cid = player:getId()
  	doSendAnimatedText("Impact", getThingPos(cid), 93)
  	if player:canMove() == true then
		noMove(cid, 0.5, 2)
	end
	doCombat(cid, combat, var)
	return true
end