area = {
	{0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
	{0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
	{0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
	{0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
	{0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
	{0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
	{0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
	{0, 0, 0, 0, 1, 3, 1, 0, 0, 0, 0},
}

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_NONE)
combat:setArea(createCombatArea(area))
local function createIceGrowth(id, pos, time)
  if(isWalkable(pos)) then
    doCreateItem(id, 1, pos)
    addEvent(removeStones, time, id, pos)
  end
end
function onGetFormulaValues(player, skill, attack, factor)
  	local min = ((player:getLevel() + bender_attack['earth_growth'].min) * bender_attack['earth_growth'].min_mult)
  	local max = ((player:getLevel() + bender_attack['earth_growth'].max) * bender_attack['earth_growth'].max_mult)
	return -min, -max
end

function onTargetCreature(creature, target)
    addEvent(moveCreatureLookDir, 100, target:getId(), creature:getId())  
    local pos = getThingPos(target:getId())
    pos.stackpos = 0
    local ground = getTileThingByPos(pos)
    if isPisoNevado(ground.itemid) == 1 then
		if getTileItemById(pos, 6707).uid == 0 then
      		createIceGrowth(6707, pos, 2*1000)
		end
    else
    	if getTileItemById(pos, 5747).uid == 0 then
      		createStones(pos, 2*1000)
		end
	end
end

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")  
combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

function onCastSpell(player, var)
	local cid = player:getId()
	doSendAnimatedText("Growth", getThingPos(cid), TEXTCOLOR_LIGHTGREEN)
	if player:canMove() == true then
		noMove(cid, 0.8, 2)
	end
	doCombat(cid, combat, var)
return true
end