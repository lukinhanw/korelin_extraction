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


local ammo = {
    [1] = {effect = CONST_ANI_ARROW, attack = 12},
    [2] = {effect = CONST_ANI_BOLT, attack = 25},
    [3] = {effect = CONST_ANI_POWERBOLT, attack = 40},
  }

function onTargetCreature(creature, target)
	doSendMagicEffect(target:getPosition(), 1)
end

  function onGetFormulaValues(player, skill, attack, factor)
    local cid = player:getId()
    local ids = {2544, 2543, 2547}
    local ammoType = {[2544] = 1,[2543] = 2, [2547] = 3}
    local distSkill = player:getEffectiveSkillLevel(SKILL_DISTANCE)
    local getAmmo = getPlayerSlotItem(cid, CONST_SLOT_AMMO)
    if(isInArray(ids, getAmmo.itemid)) then
        local min = (player:getLevel() / 5) + ((distSkill + ammo[ammoType[getAmmo.itemid]].attack) * 0.83) + 9
        local max = (player:getLevel() / 5) + ((distSkill + ammo[ammoType[getAmmo.itemid]].attack) * 1.08) + 10
        doChangeTypeItem(getAmmo.uid, getAmmo.type-1)
        return -min, -max
    else
        player:sendCancelMessage("You don't have ammunition.")
    end
  end
combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")  


function onCastSpell(player, var)
	if not player then return false end
	local position = player:getPosition()
	local cid = player:getId()
    local ids = {2544, 2543, 2547}
    local ammoType = {[2544] = 1,[2543] = 2, [2547] = 3}
    local getAmmo = getPlayerSlotItem(cid, CONST_SLOT_AMMO)
    if(isInArray(ids, getAmmo.itemid)) then
    	doSendAnimatedText("Vulcan", getThingPos(cid), TEXTCOLOR_LIGHTGREY)
      	local vulcan_area = getPosfromArea(cid, area)
    	
        for _,v in pairs(vulcan_area) do
    		doSendDistanceShoot(position, v, ammo[ammoType[getAmmo.itemid]].effect)
    	end

      	doCombat(cid, combat, var)
    else
        player:sendCancelMessage("You don't have ammunition.")
    end
  return true
end