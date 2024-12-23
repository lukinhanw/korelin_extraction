local spell = {}

spell.config = {
	[13] = {

	  	area = {
			{1, 1, 1},
		    {1, 2, 1},
		    {1, 1, 1},
		},
	},
	[12] = {

	  	area = {
			{1, 1, 1},
		    {1, 2, 1},
		    {1, 1, 1},
		},
	},

	[11] = {

	  	area = {
			{1, 1, 1},
		    {1, 2, 1},
		    {1, 1, 1},
		},
	},

	[10] = {
	  	area = {
			{0, 0, 0},
		    {0, 2, 0},
		    {0, 0, 1},
		},
	},

	[9] = {
	  	area = {
			{0, 0, 0},
		    {0, 2, 0},
		    {0, 1, 0},
		},
	},
	[8] = {
	  	area = {
			{0, 2, 1},
			{0, 0, 0},
		},
	},

	[7] = {
	  	area = {
			{0, 2, 0},
			{0, 0, 1},
		},
	},

	[6] = {
	  	area = {
			{0, 2, 0},
			{0, 1, 0},
		},
	},


	[5] = {
	  	area = {
			{0, 2, 0},
			{1, 0, 0},
		},
	},
	[4] = {
	  	area = {
		    {1, 2, 0},
	    	{0, 0, 0},
		    
	    },
	},
	[3] = {
	  	area = {
	  	   	{1, 0, 0},
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
	   		{0, 0, 1},
	   		{0, 2, 0},
		},
	},
}
local condition = Condition(CONDITION_ENERGY)
condition:setParameter(CONDITION_PARAM_DELAYED, true)
condition:addDamage(7, 1000, -5)
spell.combats = {}
for _, config in ipairs(spell.config) do
    local combat = Combat()
	combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
	combat:setParameter(COMBAT_PARAM_EFFECT, 3)
	combat:setArea(createCombatArea(config.area))
	function onGetFormulaValues(player, skill, attack, factor)
		local min = ((player:getLevel() + bender_attack['air_wheel'].min) * bender_attack['air_wheel'].min_mult) / 2
		local max = ((player:getLevel() + bender_attack['air_wheel'].max) * bender_attack['air_wheel'].max_mult) / 2
		return -min, -max
	end
	combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
    table.insert(spell.combats, combat)
end

local hit_energy_area = {
	{1, 1, 1},
	{1, 2, 1},
	{1, 1, 1},
}		


local hit_energy = Combat()
hit_energy:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
hit_energy:setParameter(COMBAT_PARAM_EFFECT, 4)
hit_energy:setArea(createCombatArea(hit_energy_area))
hit_energy:addCondition(condition)


function onCastSpell(player, var)
	local cid = player:getId()
	doSendAnimatedText("Wheel", getThingPos(cid), TEXTCOLOR_AIR)	
	if player:canMove() == true then
		noMove(cid, 0.5, 2)
    end
    for n = 1, #spell.combats do
    	if n == 8 then
    		for i = 1, 2 do
    			addEvent(doCombat, 200+(i * 500), cid, hit_energy,var)
    		end
    	end
    	addEvent(doCombat, (n * 80), cid, spell.combats[n], var)
    end
  return true
end