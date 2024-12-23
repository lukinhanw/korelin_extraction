local cooldownAttackGroup = Condition(CONDITION_SPELLGROUPCOOLDOWN)
cooldownAttackGroup:setParameter(CONDITION_PARAM_SUBID, 1)
cooldownAttackGroup:setParameter(CONDITION_PARAM_TICKS, 1000)

local function air_boost(cid, oldLook, distance)
    if not isCreature(cid) then return true end
    local player = Player(cid)
    if distance > 0 then
        if isInverseDir(oldLook, getPlayerLookDir(cid)) then
            player:setStorageValue(storage.air_boost, 0)
            player:setStorageValue(storage.air_boost_exhausted, os.time() + 2)
            player:removeCondition(CONDITION_SPELLGROUPCOOLDOWN)
            return player:sendCancelMessage("You stopped boost.")
        end
        if player:getStorageValue(storage.air_boost) == 0 then
            player:setStorageValue(storage.air_boost_exhausted, os.time() + 2)
            player:removeCondition(CONDITION_SPELLGROUPCOOLDOWN)
            return player:sendCancelMessage("You stopped boost.")
        end
        local poslook = getCreatureLookPosition(cid)
        if isWalkable(poslook, true, true, true) and
            not isCreature(getThingfromPos(poslook).uid) then
            for n = 0, 255 do
                if isInArray(excluded_border, getThingfromPos({
                        x = poslook.x,
                        y = poslook.y,
                        z = poslook.z,
                        stackpos = n
                    }).itemid) then
                    if getCreatureHealth(cid) >= getCreatureMaxHealth(cid) * 0.10 then
                        addEvent(doCreatureAddHealth, 100, cid, -12)
                        doPlayerSendTextMessage(cid, 19, "Voce perdeu 12 pontos de vida.")
                    end
                    return false
                end
            end

            doMoveCreature(cid, getPlayerLookDir(cid))
        else
            if getCreatureHealth(cid) >= getCreatureMaxHealth(cid) * 0.10 then
                addEvent(doCreatureAddHealth, 100, cid, -12)
                doPlayerSendTextMessage(cid, 19, "Voce perdeu 12 pontos de vida.")
            end
        end
        player:addCondition(cooldownAttackGroup)
        addEvent(air_boost, 150, cid, getPlayerLookDir(cid), distance - 1)
    else
        player:removeCondition(CONDITION_EXHAUST_COMBAT)
        player:setStorageValue(storage.air_boost_exhausted, os.time() + 2)
        player:setStorageValue(storage.air_boost, 0)
    end
    return true
end

function onCastSpell(player, var)
    local cid = player:getId()
    local distance = 60
    local oldPos = getPlayerPosition(cid)
    if player:getStorageValue(storage.ingrainReduce) == 1 then
        return player:sendCancelMessage("You can't use boost while using ingrain.")
    end
    if (player:getStorageValue(storage.air_boost_exhausted) > os.time() and
        player:getStorageValue(storage.air_boost_exhausted) < 100 + os.time()) then -- exhausted
        doSendMagicEffect(player:getPosition(), 3)
        player:sendCancelMessage("You are exhausted. Wait " ..player:getStorageValue(storage.air_boost_exhausted) - os.time() .. ' second' ..((player:getStorageValue(storage.air_boost_exhausted) - os.time()) == 1 and "" or "s"))
        return false
    end
    if player:getStorageValue(storage.air_boost) == 0 then
        doSendAnimatedText("Boost", getCreaturePosition(cid), TEXTCOLOR_AIR)
        player:setStorageValue(storage.air_boost, 1)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Use CTRL + SETAS do TECLADO para controlar o boost, para parar basta usar virar na direção oposta.")
        air_boost(cid, getPlayerLookDir(cid), distance)
    else
        player:setStorageValue(storage.air_boost, 0)
    end
    return true
end
