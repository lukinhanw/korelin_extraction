local spell = {}

spell.config = {
    [4] = {
    	area = {
		{0, 0, 0, 1, 1, 1, 0, 0, 0},
		{0, 0, 1, 0, 0, 0, 1, 0, 0},
		{0, 1, 0, 0, 0, 0, 0, 1, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 2, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 0, 0, 1},
		{0, 1, 0, 0, 0, 0, 0, 1, 0},
		{0, 0, 1, 0, 0, 0, 1, 0, 0},
		{0, 0, 0, 1, 1, 1, 0, 0, 0}
		}
    },
    [3] = {
    	area = {
		{0, 0, 1, 1, 1, 0, 0},
		{0, 1, 0, 0, 0, 1, 0},
		{1, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 2, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 1},
		{0, 1, 0, 0, 0, 1, 0},
		{0, 0, 1, 1, 1, 0, 0}
    	}
    },
    [2] = {
    	area = {
		{0, 1, 1, 1, 0},
		{1, 0, 0, 0, 1},
		{1, 0, 2, 0, 1},
		{1, 0, 0, 0, 1},
		{0, 1, 1, 1, 0}
    	}
    },
    [1] = {
    	area = {  
		{1, 1, 1},
		{1, 2, 1},
		{1, 1, 1}
    	}
    }
}
local condition = Condition(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 7000)
condition:setFormula(-0.6, 0, -0.6, 0)

spell.combats = {}
for _, config in ipairs(spell.config) do
    local combat = Combat()
	combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
	combat:setParameter(COMBAT_PARAM_EFFECT, 3)
	combat:setArea(createCombatArea(config.area))
	combat:addCondition(condition)
	
	function onGetFormulaValues(player, skill, attack, factor)
		local min = ((player:getLevel() + bender_attack['air_twinkle'].min) * bender_attack['air_twinkle'].min_mult)
		local max = ((player:getLevel() + bender_attack['air_twinkle'].max) * bender_attack['air_twinkle'].max_mult)
		return -min, -max
	end

	function onTargetCreature(creature, target)
		moveCreature(creature:getId(), target:getId(), math.random(0,7))
	end
	
	combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")  
	combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
    table.insert(spell.combats, combat)
end


function onCastSpell(player, var)
	local cid = player:getId()
	doSendAnimatedText("Twinkle", player:getPosition(), TEXTCOLOR_AIR)
	if player:canMove() == true then
		noMove(cid, 0.4, 14)
	end
	-- chargeEffect(cid, 40, 1, 12)


	local count = 0
	local function doEffect()
		if count < 4 then
			doSendMagicEffect(player:getPosition(), 117)
			count = count + 1
			addEvent(doEffect, 500)
		end
	end
	doEffect()


	for v = 1, 8 do 
	    for n = 1, #spell.combats do
	   		addEvent(doCombat, 2000 + (v-1) * 400 +(n * 100), cid, spell.combats[n], var)
	    end
	end
	return true 
end
