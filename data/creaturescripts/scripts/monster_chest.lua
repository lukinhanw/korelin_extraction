local AttributesConfig = dofile('data/libs/systems/attributes_config.lua')

-- Adiciona a constante RATE_LOOT
local RATE_LOOT = configManager.getNumber(configKeys.RATE_LOOT) or 1

local config = {
    closedChestId = 5947,  -- ID do baú fechado
    openedChestId = 1996,  -- ID do baú aberto
    unlockTime = 3,        -- Tempo em desbloqueio
    effect = 178,          -- Efeito durante desbloqueio
    successEffect = 174,   -- Efeito ao abrir
    rarities = {
        {
            name = "common",
            chance = 70,  -- 70%
            attributes = AttributesConfig.attributeCount.common
        },
        {
            name = "rare",
            chance = 20,   -- 20%
            attributes = AttributesConfig.attributeCount.rare
        },
        {
            name = "epic",
            chance = 8,   -- 8%
            attributes = AttributesConfig.attributeCount.epic
        },
        {
            name = "legendary",
            chance = 2,    -- 2%
            attributes = AttributesConfig.attributeCount.legendary
        }
    }
}

-- Tabela global para controle de desbloqueio
local unlockingChests = {}

local function getItemRarity()
    local roll = math.random(100)
    local currentChance = 0
    
    for _, rarity in ipairs(config.rarities) do
        currentChance = currentChance + rarity.chance
        if roll <= currentChance then
            return rarity
        end
    end
    return config.rarities[1]
end

local function addAttributes(item, rarity)
    if rarity.attributes.max == 0 then return {} end
    
    local numAttributes = math.random(rarity.attributes.min, rarity.attributes.max)
    local attributes = {}
    
    local availableAttributes = AttributesConfig.getAvailableAttributes()
    
    for i = 1, numAttributes do
        if #availableAttributes == 0 then break end
        
        local index = math.random(#availableAttributes)
        local attr = table.remove(availableAttributes, index)
        local baseValue = math.random(attr.min, attr.max)
        local finalValue = AttributesConfig.calculateValue(attr.name, baseValue, rarity.name)
        
        table.insert(attributes, {
            name = attr.name,
            value = finalValue
        })
    end
    
    return attributes
end

function onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    if not creature:isMonster() then
        return true
    end

    local position = corpse:getPosition()
    local lootTable = {}
    
    local monsterType = MonsterType(creature:getName())
    if monsterType then
        for _, loot in ipairs(monsterType:getLoot()) do
            local adjustedChance = math.min(loot.chance * RATE_LOOT, 100000)
            if math.random(100000) <= adjustedChance then
                local count = loot.maxCount > 1 and math.random(1, loot.maxCount) or 1
                
                local rarity = getItemRarity()
                local attributes = {}
                
                local itemType = ItemType(loot.itemId)
                if itemType then
                    if (itemType:getWeaponType() ~= WEAPON_NONE or itemType:getArmor() > 0) and rarity.name ~= "common" then
                        local itemName = itemType:getName()
                        table.insert(attributes, {
                            name = "name",
                            value = rarity.name .. " " .. itemName
                        })
                        
                        local itemAttributes = addAttributes(itemType, rarity)
                        for _, attr in ipairs(itemAttributes) do
                            table.insert(attributes, attr)
                        end
                    end
                end
                
                table.insert(lootTable, {
                    id = loot.itemId,
                    count = count,
                    attributes = attributes,
                    rarity = rarity.name
                })
            end
        end
    end

    corpse:remove()

    -- Efeito quando o monstro morre
    local effectPosition = Position(position.x, position.y + 2, position.z)
    effectPosition:sendMagicEffect(166)

    -- Cria o baú fechado após 2 segundos (tempo do efeito)
    addEvent(function(pos, items)
        -- Serializa o loot e salva no baú fechado
        local lootString = ""
        for _, item in ipairs(items) do
            local attrString = ""
            if #item.attributes > 0 then
                for _, attr in ipairs(item.attributes) do
                    attrString = attrString .. attr.name .. "=" .. attr.value .. "|"
                end
            end
            lootString = lootString .. item.id .. "," .. item.count .. "," .. attrString .. ";"
        end

        -- Cria o baú fechado com o loot serializado
        local chest = Game.createItem(config.closedChestId, 1, pos)
        if chest then
            chest:setCustomAttribute("monsterLoot", lootString)
            chest:setActionId(8999)
        end
    end, 2000, position, lootTable)

    return true
end
