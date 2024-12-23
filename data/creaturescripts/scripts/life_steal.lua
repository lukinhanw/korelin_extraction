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

local function getLifeStealBonus(player)
    local totalLifeSteal = 0
    for _, slot in pairs({SLOTS.HEAD, SLOTS.NECKLACE, SLOTS.ARMOR, SLOTS.RIGHT, SLOTS.LEFT, SLOTS.LEGS, SLOTS.FEET, SLOTS.RING}) do
        local item = player:getSlotItem(slot)
        if item then
            local lifeStealBonus = item:getCustomAttribute("lifesteal")
            if lifeStealBonus then
                totalLifeSteal = totalLifeSteal + lifeStealBonus
            end
        end
    end
    return totalLifeSteal
end

function onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
    -- Só processa se houver um atacante e ele for player
    if not attacker or not attacker:isPlayer() then
        return primaryDamage, primaryType, secondaryDamage, secondaryType
    end

    -- Calcula o Life Steal
    local lifeStealPercent = getLifeStealBonus(attacker)

    if lifeStealPercent > 0 then
        local healAmount = 0
        
        if creature:isMonster() then
            -- PvE: Dano positivo
            if primaryDamage <= 0 then
                return primaryDamage, primaryType, secondaryDamage, secondaryType
            end
            healAmount = math.floor(primaryDamage * (lifeStealPercent / 100))
        else
            -- PvP: Dano negativo
            if primaryDamage >= 0 then
                return primaryDamage, primaryType, secondaryDamage, secondaryType
            end
            healAmount = math.floor(math.abs(primaryDamage) * (lifeStealPercent / 100))
        end
        
        if healAmount > 0 then
            attacker:addHealth(healAmount)
            attacker:getPosition():sendMagicEffect(15)
        end
    end
    
    return primaryDamage, primaryType, secondaryDamage, secondaryType
end 