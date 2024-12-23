function onCastSpell(player, var)
    local ammo = {
        [1] = {
            effect = CONST_ANI_ARROW,
            minDmg = math.floor((player:getLevel() + bender_attack['air_bow1'].min) * bender_attack['air_bow1'].min_mult),
            maxDmg = math.floor((player:getLevel() + bender_attack['air_bow1'].max) * bender_attack['air_bow1'].max_mult)
        },
        [2] = {
            effect = CONST_ANI_BOLT,
            minDmg = math.floor((player:getLevel() + bender_attack['air_bow2'].min) * bender_attack['air_bow2'].min_mult),
            maxDmg = math.floor((player:getLevel() + bender_attack['air_bow2'].max) * bender_attack['air_bow2'].max_mult)
        },
        [3] = {
            effect = CONST_ANI_POWERBOLT,
            minDmg = math.floor((player:getLevel() + bender_attack['air_bow3'].min) * bender_attack['air_bow3'].min_mult),
            maxDmg = math.floor((player:getLevel() + bender_attack['air_bow3'].max) * bender_attack['air_bow3'].max_mult)
        }
    }
    local ids = {2544, 2543, 2547}
    local ammoType = {
        [2544] = 1,
        [2543] = 2,
        [2547] = 3
    }

    local cid = player:getId()

    local getAmmo = getPlayerSlotItem(cid, CONST_SLOT_AMMO)
    local target = getCreatureTarget(cid)

    if target > 1 then
        if (isInArray(ids, getAmmo.itemid)) then
            if isSightClear(getThingPos(cid), getThingPos(target), 0) == 0 then
                return 1
            end
            doSendAnimatedText("Bow", getThingPos(cid), TEXTCOLOR_AIR)
            doSendDistanceShoot(getThingPos(cid), getThingPos(target), ammo[ammoType[getAmmo.itemid]].effect)
            doTargetCombatHealth(cid, target, 1, -ammo[ammoType[getAmmo.itemid]].minDmg,
                -ammo[ammoType[getAmmo.itemid]].maxDmg, 3)
            doChangeTypeItem(getAmmo.uid, getAmmo.type - 1)
        else
			doPlayerSendCancel(cid, "You need a ammunition to use this spell.")
			doSendMagicEffect(getThingPos(cid), 3)
			return false
        end
    end
    return true
end
