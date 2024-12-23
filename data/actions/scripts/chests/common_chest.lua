local AttributesConfig = dofile('data/libs/systems/attributes_config.lua')

-- Configuração do baú comum
local CHEST_CONFIG = {
    id = 7621,  -- ID do baú trancado
    openedId = 7622, -- ID do baú aberto
    name = "Common chest",
    unlockTime = 3, -- Tempo em segundos para destravar
    effect = 178, -- Efeito durante o desbloqueio
    successEffect = 174, -- Efeito de sucesso ao abrir
    minItems = 1,  -- Mínimo de itens por baú
    maxItems = 7,  -- Máximo de itens por baú
    items = {
        {2160, 10, 20, 1000},   -- crystal coin
        {2400, 1, 1, 800},      -- magic sword
        {2431, 1, 1, 800},      -- stonecutter axe
        {2494, 1, 1, 700},      -- demon armor
        {2495, 1, 1, 700},      -- demon legs
        {2393, 1, 1, 600},      -- giant sword
        {2514, 1, 1, 600},      -- mastermind shield
        {2472, 1, 1, 500},      -- magic plate armor
        {2470, 1, 1, 500},      -- golden legs
    },
    rarityChances = {
        common = 90,    
        rare = 8,      
        epic = 2,      
        legendary = 0   
    }
}

-- Tabela global para controle de desbloqueio
local unlockingChests = {}

local function getItemRarity()
    local roll = math.random(100)
    local currentChance = 0
    
    for rarity, chance in pairs(CHEST_CONFIG.rarityChances) do
        currentChance = currentChance + chance
        if roll <= currentChance then
            return rarity
        end
    end
    return "common"
end

local function addAttributes(item, rarity)
    if rarity == "common" then return {} end
    
    local attributes = {}
    local numAttributes = math.random(
        AttributesConfig.attributeCount[rarity].min,
        AttributesConfig.attributeCount[rarity].max
    )
    
    local availableAttributes = AttributesConfig.getAvailableAttributes()
    
    for i = 1, numAttributes do
        if #availableAttributes == 0 then break end
        
        local index = math.random(#availableAttributes)
        local attr = table.remove(availableAttributes, index)
        local baseValue = math.random(attr.min, attr.max)
        local finalValue = AttributesConfig.calculateValue(attr.name, baseValue, rarity)
        
        table.insert(attributes, attr.name .. "=" .. finalValue)
    end
    
    return attributes
end

local function createChestReward(position, player)
    local newContainer = Game.createItem(CHEST_CONFIG.openedId, 1)
    if newContainer then
        -- Determina quantos itens serão adicionados
        local numItems = math.random(CHEST_CONFIG.minItems, CHEST_CONFIG.maxItems)
        
        for i = 1, numItems do
            -- Adiciona um item aleatório
            local selectedItem = CHEST_CONFIG.items[math.random(#CHEST_CONFIG.items)]
            local count = math.random(selectedItem[2], selectedItem[3])
            local reward = Game.createItem(selectedItem[1], count)
            
            if reward then
                local rarity = getItemRarity()
                if rarity ~= "common" then
                    local itemType = ItemType(selectedItem[1])
                    if itemType then
                        reward:setAttribute("name", rarity .. " " .. itemType:getName())
                        local attributes = addAttributes(reward, rarity)
                        for _, attrStr in ipairs(attributes) do
                            local name, value = attrStr:match("(.+)=(.+)")
                            if name and value then
                                reward:setCustomAttribute(name, tonumber(value))
                            end
                        end
                    end
                end
                newContainer:addItemEx(reward)
            end
        end
        
        -- Coloca o baú na posição
        newContainer:moveTo(position)
        
        -- Efeito e mensagem final
        position:sendMagicEffect(CHEST_CONFIG.successEffect)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, CHEST_CONFIG.name .. " unlocked!")
    end
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local playerId = player:getId()
    local itemUid = item:getUniqueId()
    
    -- Verifica se o baú já está sendo desbloqueado
    if unlockingChests[itemUid] then
        local chestData = unlockingChests[itemUid]
        if chestData.playerId == playerId then
            player:sendTextMessage(MESSAGE_STATUS_SMALL, "You are already searching this chest.")
        else
            local otherPlayer = Player(chestData.playerId)
            if otherPlayer then
                player:sendTextMessage(MESSAGE_STATUS_SMALL, "This chest is being searched by " .. otherPlayer:getName() .. ".")
            else
                -- Se o outro player não existe mais, limpa o registro
                unlockingChests[itemUid] = nil
                -- E permite este player tentar abrir
                return onUse(player, item, fromPosition, target, toPosition, isHotkey)
            end
        end
        return true
    end
    
    -- Verifica se o player já está abrindo outro baú
    for uid, data in pairs(unlockingChests) do
        if data.playerId == playerId then
            player:sendTextMessage(MESSAGE_STATUS_SMALL, "You are already searching another chest.")
            return true
        end
    end
    
    -- Marca o baú como sendo desbloqueado
    unlockingChests[itemUid] = {
        playerId = playerId,
        position = player:getPosition(),
        timeLeft = CHEST_CONFIG.unlockTime
    }
    
    -- Mensagem inicial
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Searching for loot... 3s")
    
    -- Função local para o processo de desbloqueio
    local function processUnlock()
        local currentPlayer = Player(playerId)
        local chestData = unlockingChests[itemUid]
        
        if not currentPlayer or not chestData then
            unlockingChests[itemUid] = nil
            return
        end
        
        -- Verifica se o player se moveu
        if currentPlayer:getPosition() ~= chestData.position then
            currentPlayer:sendTextMessage(MESSAGE_STATUS_SMALL, "You moved and interrupted the loot check.")
            unlockingChests[itemUid] = nil
            return
        end
        
        -- Atualiza o tempo restante
        chestData.timeLeft = chestData.timeLeft - 1
        
        -- Mostra o progresso
        if chestData.timeLeft > 0 then
            currentPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Searching for loot... " .. (chestData.timeLeft) .. "s")
            fromPosition:sendMagicEffect(CHEST_CONFIG.effect)
            addEvent(processUnlock, 1000)
        else
            -- Remove o baú antigo
            item:remove()
            -- Cria o novo baú com a recompensa
            createChestReward(fromPosition, currentPlayer)
            -- Limpa o registro
            unlockingChests[itemUid] = nil
        end
    end
    
    -- Inicia o processo
    addEvent(processUnlock, 1000)
    return true
end 