local area = {
{1, 1, 1},
{0, 3, 0},
{0, 0, 0},
}

local condition = createConditionObject(CONDITION_DRUNK)
setConditionParam(condition, CONDITION_PARAM_TICKS, 20000)

function onCastSpell(player, var)
	local minDmg = ((player:getLevel() + bender_attack['earth_crush'].min) * bender_attack['earth_crush'].min_mult)
	local maxDmg = ((player:getLevel() + bender_attack['earth_crush'].max) * bender_attack['earth_crush'].max_mult)
	local cid = player:getId()
	if not isCreature(cid) then return false end
	local crush_area = getPosfromArea(cid, area)
  	doSendAnimatedText("Crush", getThingPos(cid), TEXTCOLOR_LIGHTGREEN)
  	if player:canMove() == true then
		noMove(cid, 0.5, 2)
	end
	if math.random(1, 100) >= 20 then
		for _,v in pairs(crush_area) do
			doAreaCombatHealth(cid, 1, v, 0, -minDmg, -maxDmg, 35)
		end
	else
		for _,v in pairs(crush_area) do	
			local target = getTopCreature(v).uid
			
			if target > 0 then
				doAddCondition(target, condition)
			end
			doAreaCombatHealth(cid, 1, v, 0, -minDmg, -maxDmg, 93)
		end
	end
	return true
end