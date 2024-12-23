local spell = {}

spell.config = {
	[5] = {
	  	area = {
		    {1, 1, 1, 1, 1},
		    {1, 1, 1, 1, 1},
		    {0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0},
		    {0, 0, 0, 0, 0},
		    {0, 0, 2, 0, 0},
		},
	},
	[4] = {
	  	area = {
		    {1, 1, 1},
		    {0, 0, 0},
		    {0, 0, 0},
		    {0, 2, 0},
	    },
	},
	[3] = {
	  	area = {
		    {1, 1, 1},
		    {0, 0, 0},
		    {0, 2, 0},
	  	},
	},
	[2] = {
	  	area = {
		    {0, 1, 0},
		    {0, 2, 0},
	  	},
	},
	[1] = {
	  	area = {
	   		{0, 3, 0},
		},
	},
}

spell.combats = {}
local condition = Condition(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 7000)
condition:setFormula(-0.5, 0, -0.5, 0)

for _, config in ipairs(spell.config) do
    local combat = Combat()
	combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
	combat:setParameter(COMBAT_PARAM_EFFECT, 3)
	combat:setArea(createCombatArea(config.area))
	combat:addCondition(condition)

	function onGetFormulaValues(player, skill, attack, factor)
    	local min = ((player:getLevel() + bender_attack['air_icywind'].min) * bender_attack['air_icywind'].min_mult)
    	local max = ((player:getLevel() + bender_attack['air_icywind'].max) * bender_attack['air_icywind'].max_mult)
		return -min, -max
	end

	combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
    table.insert(spell.combats, combat)
end


function onCastSpell(player, var)
	local cid = player:getId()
	doSendAnimatedText("Icywind", getThingPos(cid), TEXTCOLOR_AIR)	
	if player:canMove() == true then
		noMove(cid, 0.5, 2)
    end
    for n = 1, #spell.combats do
   		addEvent(doCombat, (n * 80), cid, spell.combats[n], var)
    end
  return true
end