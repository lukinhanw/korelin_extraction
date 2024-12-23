local condition = createConditionObject(CONDITION_EXHAUST_COMBAT)
setConditionParam(condition, CONDITION_PARAM_TICKS, 1000)

local function earth_track(cid, oldLook, distance)
    if not isCreature(cid) then
        return true
    end
    local player = Player(cid)
    if distance > 0 then
        if not isCreature(cid) then
            return true
        end
        if isInverseDir(oldLook, getPlayerLookDir(cid)) then
            player:setStorageValue(storage.earth_track, 0)
            player:setStorageValue(storage.earth_track_exhausted, os.time() + 4)
            player:removeCondition(CONDITION_EXHAUST_COMBAT)
            return player:sendCancelMessage("You stopped track.")
        end
        if player:getStorageValue(storage.earth_track) == 0 then
            player:setStorageValue(storage.earth_track_exhausted, os.time() + 4)
            player:removeCondition(CONDITION_EXHAUST_COMBAT)
            return player:sendCancelMessage("You stopped track.")
        end
        local poslook = getCreatureLookPosition(cid)
        if isWalkable(poslook, true, true, true) and not isCreature(getThingfromPos(poslook).uid) then
            for n = 0, 255 do
                if isInArray(excluded_border, getThingfromPos({
                    x = poslook.x,
                    y = poslook.y,
                    z = poslook.z,
                    stackpos = n
                }).itemid) then

                    if getCreatureHealth(cid) >= getCreatureMaxHealth(cid) * 0.10 then
                        addEvent(doCreatureAddHealth, 100, cid, -12)
                        doPlayerSendTextMessage(cid, 19, "Voc� perdeu 12 pontos de vida.")
                    end
                    return false
                end
            end
            doMoveCreature(cid, getPlayerLookDir(cid))
        else
            addEvent(doCreatureAddHealth, 100, cid, -12)
            doPlayerSendTextMessage(cid, 19, "Voc� perdeu 12 pontos de vida.")
        end
        player:addCondition(condition)
        addEvent(earth_track, 170 - (getPlayerLevel(cid) / 10), cid, getPlayerLookDir(cid), distance - 1)
    else
        player:removeCondition(CONDITION_EXHAUST_COMBAT)
        player:setStorageValue(storage.earth_track, 0)
        player:setStorageValue(storage.earth_track_exhausted, os.time() + 4)
    end
    return true
end

function onCastSpell(player, var)
    local cid = player:getId()
    if not isCreature(cid) then
        return true
    end
    if player:getStorageValue(storage.ingrainReduce) == 1 then
        return player:sendCancelMessage("You can't use track while using ingrain.")
    end

    if (player:getStorageValue(storage.earth_track_exhausted) > os.time() and
        player:getStorageValue(storage.earth_track_exhausted) < 100 + os.time()) then -- exhausted
        doSendMagicEffect(player:getPosition(), 3)
        player:sendCancelMessage("You are exhausted for " .. player:getStorageValue(storage.earth_track_exhausted) -
                                     os.time() .. ' second' ..
                                     ((player:getStorageValue(storage.earth_track_exhausted) - os.time()) == 1 and "" or
                                         "s"))
        return false
    end
    if player:getStorageValue(storage.earth_track) == 0 then
        local distance = 70
        local oldPos = getPlayerPosition(cid)

        doSendAnimatedText("Track", getCreaturePosition(cid), TEXTCOLOR_LIGHTGREEN)
        chargeEffect(cid, 35, 1, 8)
        player:setStorageValue(storage.earth_track, 1)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE,
            "Use CTRL + SETAS do TECLADO para controlar o track, para parar basta virar na dire��o oposta.")
        addEvent(earth_track, 1200, cid, getPlayerLookDir(cid), distance)
    else
        player:setStorageValue(storage.earth_track, 0)
    end
    return true
end
