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
condition:setFormula(-0.6, 0, -0.6, 0)

for _, config in ipairs(spell.config) do
    local combat = Combat()
	combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
	combat:setParameter(COMBAT_PARAM_EFFECT, 3)
	combat:setArea(createCombatArea(config.area))
	combat:addCondition(condition)

    table.insert(spell.combats, combat)
end


function onCastSpell(creature, var)
	local cid = creature:getId()
	doSendAnimatedText("Icywind", getThingPos(cid), TEXTCOLOR_AIR)	
	if creature:canMove() == true then
		noMove(cid, 0.5, 2)
    end
    for n = 1, #spell.combats do
   		addEvent(doCombat, (n * 80), cid, spell.combats[n], var)
    end
  return true
end