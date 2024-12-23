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

local function getReflectBonus(player)
    local totalReflect = 0
    for _, slot in pairs({SLOTS.HEAD, SLOTS.NECKLACE, SLOTS.ARMOR, SLOTS.RIGHT, SLOTS.LEFT, SLOTS.LEGS, SLOTS.FEET, SLOTS.RING}) do
        local item = player:getSlotItem(slot)
        if item then
            local reflectBonus = item:getCustomAttribute("reflect")
            if reflectBonus then
                totalReflect = totalReflect + reflectBonus
            end
        end
    end
    return totalReflect
end

function onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    if not creature:isPlayer() then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    -- Verifica se o dano já é um reflect
    if origin and origin == "reflect" then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    if attacker and primaryDamage > 0 then
        local reflectPercent = getReflectBonus(creature)
        if reflectPercent > 0 then
            local reflectDamage = math.floor(primaryDamage * (reflectPercent / 100))
            -- Se o attacker for player reflectDamage é *2
            if attacker:isPlayer() then
                reflectDamage = reflectDamage * 2
            end
            if reflectDamage > 0 then
                -- Adiciona origin "reflect" para identificar dano refletido
                doTargetCombatHealth(creature, attacker, COMBAT_PHYSICALDAMAGE, -reflectDamage, -reflectDamage, CONST_ME_NONE, "reflect")
            end
        end
    end
    
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end 