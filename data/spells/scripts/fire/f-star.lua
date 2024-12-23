local area = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 0, 0, 0, 1, 0},
    {1, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 2, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 1},
    {0, 1, 0, 0, 0, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
}

local hit_area = {
	{0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 2, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
}
local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setArea(createCombatArea(hit_area))

function onTargetCreature(creature, target)
	doSendMagicEffect(target:getPosition(), 16)
end
function onGetFormulaValues(player, skill, attack, factor)

    local min = ((player:getLevel() + bender_attack['fire_star'].min) * bender_attack['fire_star'].min_mult)
    local max = ((player:getLevel() + bender_attack['fire_star'].max) * bender_attack['fire_star'].max_mult)
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")  


function onCastSpell(player, var)
	if not player then return false end
	local position = player:getPosition()
	local cid = player:getId()
	doSendAnimatedText("Star", getThingPos(cid), TEXTCOLOR_ORANGE)
  	local star_area = getPosfromArea(cid, area)
	for _,v in pairs(star_area) do
		doSendDistanceShoot(position, v, 47)
	end
  	doCombat(cid, combat, var)

  return true
end