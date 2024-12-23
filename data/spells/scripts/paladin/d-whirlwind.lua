  local ammo = {
    [1] = {effect = CONST_ANI_ARROW, attack = 12},
    [2] = {effect = CONST_ANI_BOLT, attack = 25},
    [3] = {effect = CONST_ANI_POWERBOLT, attack = 40},
  }
  local combat = Combat()
  combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
  combat:setParameter(COMBAT_PARAM_EFFECT, 1)

  function onGetFormulaValues(player, skill, attack, factor)
    local cid = player:getId()
    local ids = {2544, 2543, 2547}
    local ammoType = {[2544] = 1,[2543] = 2, [2547] = 3}
    local distSkill = player:getEffectiveSkillLevel(SKILL_DISTANCE)
    local getAmmo = getPlayerSlotItem(cid, CONST_SLOT_AMMO)
    if(isInArray(ids, getAmmo.itemid)) then
      local min = (player:getLevel() / 5) + ((distSkill + ammo[ammoType[getAmmo.itemid]].attack) * 1.1) + 9
      local max = (player:getLevel() / 5) + ((distSkill + ammo[ammoType[getAmmo.itemid]].attack) * 1.2) + 10
      doChangeTypeItem(getAmmo.uid, getAmmo.type-1)
      return -min, -max
    else
      player:sendCancelMessage("You don't have ammunition.")
    end 
  end
  combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")


function onCastSpell(player, var)
  local ids = {2544, 2543, 2547}
  local ammoType = {[2544] = 1,[2543] = 2, [2547] = 3}

  local cid = player:getId()

  local getAmmo = getPlayerSlotItem(cid, CONST_SLOT_AMMO)
  local target = getCreatureTarget(cid)

  if target > 1 then
    if(isInArray(ids, getAmmo.itemid)) then
      if isSightClear(getThingPos(cid), getThingPos(target), 0) == 0 then
        return 1
      end
      doSendAnimatedText("Whirlwind", getThingPos(cid), TEXTCOLOR_LIGHTGREY)
      doSendDistanceShoot(getThingPos(cid), getThingPos(target), ammo[ammoType[getAmmo.itemid]].effect)
      doChangeTypeItem(getAmmo.uid, getAmmo.type-1)
      doCombat(cid, combat, var)
    else
      player:sendCancelMessage("You don't have ammunition.")    
    end
  end
  return true
end