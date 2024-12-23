local spell = {}

spell.config = {
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
	combat:setParameter(COMBAT_PARAM_EFFECT, 3)
	combat:setArea(createCombatArea(config.area))
	function onGetFormulaValues(player, skill, attack, factor)
		local min = ((player:getLevel() + bender_attack['air_burst'].min) * bender_attack['air_burst'].min_mult) / 2
		local max = ((player:getLevel() + bender_attack['air_burst'].max) * bender_attack['air_burst'].max_mult) / 2
		return -min, -max
	end

	function onTargetCreature(creature, target)
		moveCreature(creature:getId(), target:getId(), getPushDir(creature:getId(), target:getId()))
	end
	
	function onTargetTile(creature, position)
		local thing = getTileItemByType(position, 6)
		if thing.uid > 0 then
			if isInArray({1487,1488}, thing.itemid) then
			
				doTransformItem(thing.uid, thing.itemid+1, 1)
			elseif thing.itemid == 1489 then
				doRemoveItem(thing.uid, 1)
			end
		end
	end
	combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")
	combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")  
	combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
    table.insert(spell.combats, combat)
end


function onCastSpell(player, var)
	local cid = player:getId()
	doSendAnimatedText("Burst", player:getPosition(), TEXTCOLOR_AIR)
	if player:canMove() == true then
		noMove(cid, 0.2, 2)
	end
    for n = 1, #spell.combats do
   		addEvent(doCombat, (n * 100), cid, spell.combats[n], var)
    end
	return true 
end
