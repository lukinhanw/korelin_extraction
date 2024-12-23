local function updateHealthBonus(player, item, isEquip)
    local healthBonus = item:getCustomAttribute("health")
    if not healthBonus then
        return
    end

    -- Usa o ID do item ao invés do UID
    local itemId = item:getId()
    local storageKey = Storage.Equipment.HealthBonus + itemId
    local equipStatusKey = Storage.Equipment.HealthBonus + itemId + 10000 -- Storage para status do equip
    
    if isEquip then
        -- Verifica se já está equipado
        if player:getStorageValue(equipStatusKey) > 0 then
            return
        end
        
        -- Aplica o bônus
        player:setMaxHealth(player:getMaxHealth() + healthBonus)
        player:setStorageValue(storageKey, healthBonus)
        player:setStorageValue(equipStatusKey, 1) -- Marca como equipado
    else
        -- Remove o bônus
        local storedBonus = player:getStorageValue(storageKey)
        if storedBonus > 0 then
            player:setMaxHealth(player:getMaxHealth() - storedBonus)
            player:setStorageValue(storageKey, -1)
            player:setStorageValue(equipStatusKey, -1) -- Marca como não equipado
        end
    end
end

local function updateSpeedBonus(player, item, isEquip)
    local speedBonus = item:getCustomAttribute("speed")
    if not speedBonus then
        return
    end
    
    -- Aplica ou remove o bônus
    if isEquip then
        player:changeSpeed(speedBonus)
    else
        player:changeSpeed(-speedBonus)
    end
end

function onEquip(player, item, slot, isCheck)
    if not isCheck then
        updateHealthBonus(player, item, true)
        updateSpeedBonus(player, item, true)
    end
    return true
end

function onDeEquip(player, item, slot, isCheck)
    if not isCheck then
        updateHealthBonus(player, item, false)
        updateSpeedBonus(player, item, false)
    end
    return true
end 