local function water_barrier(cid, time)
    if not isCreature(cid) then return true end
    local player = Player(cid)
    if time > 0 then
        doSendMagicEffect(getCreaturePos(cid), 11)
        addEvent(valid(water_barrier), 1000, cid, time - 1)
    else
        setPlayerStorageValue(cid, storage.waterProtect, 0)
    end
end

local spells_storages = {1124, 1125, 1126, 1127}

function onCastSpell(player, var)
    local cid = player:getId()
    if not isCreature(cid) then return true end

    for i = 1, #spells_storages do
        if player:getStorageValue(spells_storages[i]) == 1 then
            return player:sendCancelMessage("You can't use protect now.")
        end
    end
    if (player:getStorageValue(storage.waterProtect_exhausted) > os.time() and
        player:getStorageValue(storage.waterProtect_exhausted) < 100 + os.time()) then -- exhausted
        doSendMagicEffect(player:getPosition(), 3)
        player:sendCancelMessage("You are exhausted. Wait " ..player:getStorageValue(storage.waterProtect_exhausted) - os.time() .. ' second' ..((player:getStorageValue(storage.waterProtect_exhausted) - os.time()) == 1 and "" or "s"))
        return true
    end
	if not hasWater(cid, 5) then return true end
    water_barrier(cid, 3)
    doSendAnimatedText("Protect", getThingPos(cid), TEXTCOLOR_WATER)
    player:setStorageValue(storage.waterProtect, 1)
    player:setStorageValue(storage.waterProtect_exhausted, os.time() + 16)
    return true
end
