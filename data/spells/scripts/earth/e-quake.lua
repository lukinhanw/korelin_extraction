local spell = {}

spell.config = {
   [5] = {
   		area = {
		{0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
		{0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
		{0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0},
		{0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
		{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 2, 0, 0, 0, 0, 1},
		{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
		{0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0},
		{0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0},
		{0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0},
		{0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0}
		}
	},
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


spell.combats = {}
for _, config in ipairs(spell.config) do
    local combat = Combat()
	combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
	combat:setParameter(COMBAT_PARAM_EFFECT, 102)
	combat:setArea(createCombatArea(config.area))
	function onGetFormulaValues(player, skill, attack, factor)
 		local minDmg = ((player:getLevel() + bender_attack['earth_quake'].min) * bender_attack['earth_quake'].min_mult)
 		local maxDmg = ((player:getLevel() + bender_attack['earth_quake'].max) * bender_attack['earth_quake'].max_mult)
		return -minDmg, -maxDmg
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
	doSendAnimatedText("Quake", player:getPosition(), TEXTCOLOR_LIGHTGREEN)
	if player:canMove() == true then
		noMove(cid, 0.4, 2)
	end
    for n = 1, #spell.combats do
   		addEvent(doCombat, (n * 250), cid, spell.combats[n], var)
    end
	return true 
end
