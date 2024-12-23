local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local condition = Condition(CONDITION_LIGHT)
condition:setParameter(CONDITION_PARAM_LIGHT_LEVEL, 8)
condition:setParameter(CONDITION_PARAM_LIGHT_COLOR, 215)
condition:setParameter(CONDITION_PARAM_TICKS, (60 * 33 + 10) * 1000)
combat:addCondition(condition)

function onCastSpell(creature, variant)
	local cid = creature:getId()
	doSendAnimatedText("Light", getThingPos(cid), TEXTCOLOR_ORANGE)
	return combat:execute(creature, variant)
end
