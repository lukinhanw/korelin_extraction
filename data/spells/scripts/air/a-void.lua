local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
-- Remove o efeito visual geral da magia
-- setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_SOUND_WHITE) -- Linha removida

local condition = createConditionObject(CONDITION_EXHAUST_COMBAT)
setConditionParam(condition, CONDITION_PARAM_TICKS, 5000)
addCombatCondition(combat, condition)

local arr = {
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {1, 1, 1, 3, 1, 1, 1},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0}
}

local spells_storages = {1102, 1128, 1129, 1130, 1131}

function onTargetCreature(creature, target)
    -- Aplica o efeito visual apenas se houver uma criatura na área afetada
    doSendMagicEffect(target:getPosition(), 81)
    
    if target:isPlayer() then
        for i = 1, #spells_storages do
            target:setStorageValue(spells_storages[i], os.time() + 5)
        end
        target:addCondition(condition)
        return target:sendTextMessage(18, "You are under pressure for 5 seconds.")
    end
end

local area = createCombatArea(arr)
setCombatArea(combat, area)

combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

function onCastSpell(player, var)
    local cid = player:getId()
    if(player:getStorageValue(storage.air_void_exhausted) > os.time() and player:getStorageValue(storage.air_void_exhausted) < 100+os.time()) then -- exhausted
        player:sendCancelMessage("You are exhausted. Wait " .. player:getStorageValue(storage.air_void_exhausted) - os.time() .. ' second' .. ((player:getStorageValue(storage.air_void_exhausted) - os.time()) == 1 and "" or "s"))
        return false    
    end 

    if player:canMove() == true then
        noMove(cid, 0.2, 2)
    end

	doSendAnimatedText("Void", player:getPosition(), TEXTCOLOR_AIR)
    doCombat(cid, combat, var)
    player:setStorageValue(storage.air_void_exhausted, os.time() + 18)
    -- doSendAnimatedText("Void", getThingPos(cid), TEXTCOLOR_AIR) -- Linha removida se você também deseja remover este efeito textual
    return true
end
