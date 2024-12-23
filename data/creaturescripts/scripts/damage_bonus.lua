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

local function getDamageBonus(player)
    local totalDamage = 0
    for _, slot in pairs({SLOTS.HEAD, SLOTS.NECKLACE, SLOTS.ARMOR, SLOTS.RIGHT, SLOTS.LEFT, SLOTS.LEGS, SLOTS.FEET, SLOTS.RING}) do
        local item = player:getSlotItem(slot)
        if item then
            local damageBonus = item:getCustomAttribute("power")
            if damageBonus then
                totalDamage = totalDamage + damageBonus
            end
        end
    end
    return totalDamage
end

function onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if not attacker or not attacker:isPlayer() then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    local damagePercent = getDamageBonus(attacker)
    if damagePercent <= 0 then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    -- Calcula o novo dano com o bônus
    local newDamage = math.floor(primaryDamage * (1 + damagePercent / 100))
    return newDamage, primaryType, secondaryDamage, secondaryType
end 