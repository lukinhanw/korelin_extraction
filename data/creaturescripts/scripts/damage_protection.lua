-- Definição das constantes de slots
local SLOTS = {
    HEAD = 1,
    NECKLACE = 2,
    BACKPACK = 3,
    ARMOR = 4,
    RIGHT = 5,
    LEFT = 6,
    LEGS = 7,
    FEET = 8,
    RING = 9,
    AMMO = 10
}

local function getProtectionChance(player)
    local totalChance = 0
    for _, slot in pairs({SLOTS.HEAD, SLOTS.NECKLACE, SLOTS.ARMOR, SLOTS.RIGHT, SLOTS.LEFT, SLOTS.LEGS, SLOTS.FEET, SLOTS.RING}) do
        local item = player:getSlotItem(slot)
        if item then
            local protectChance = item:getCustomAttribute("protect")
            if protectChance then
                totalChance = totalChance + protectChance
            end
        end
    end
    return totalChance
end

function onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    -- Só processa se for um player recebendo dano
    if not creature:isPlayer() or primaryDamage >= 0 then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    -- Calcula chance total de proteção
    local protectChance = getProtectionChance(creature)
    if protectChance <= 0 then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    -- Tenta bloquear o dano
    local roll = math.random(1, 100)
    if roll <= protectChance then
        -- Bloqueou o dano
        creature:getPosition():sendMagicEffect(4)
        return 0, primaryType, secondaryDamage, secondaryType
    end

    return primaryDamage, primaryType, secondaryDamage, secondaryType
end 