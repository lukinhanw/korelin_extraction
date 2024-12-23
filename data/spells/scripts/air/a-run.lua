local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, 73)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local condition = Condition(CONDITION_HASTE)
condition:setParameter(CONDITION_PARAM_TICKS, 22000)
condition:setFormula(0.5, -56, 0.5, -56)
combat:addCondition(condition)

function onCastSpell(creature, variant)
	doSendAnimatedText("Run", creature:getPosition(), TEXTCOLOR_AIR)
	return combat:execute(creature, variant)
end
