local AttributesConfig = dofile('data/libs/systems/attributes_config.lua')

local function deserializeLoot(str)
    local lootTable = {}
    for itemData in str:gmatch("([^;]+)") do
        local parts = {}
        for part in itemData:gmatch("([^,]+)") do
            table.insert(parts, part)
        end

        if #parts >= 2 then
            local attributes = {}
            if parts[3] then
                for attrData in parts[3]:gmatch("([^|]+)") do
                    local name, value = attrData:match("(.+)=(.+)")
                    if name and value then
                        if name == "name" then
                            attributes[name] = value
                        else
                            attributes[name] = tonumber(value)
                        end
                    end
                end
            end

            table.insert(lootTable, {
                id = tonumber(parts[1]),
                count = tonumber(parts[2]),
                attributes = attributes
            })
        end
    end
    return lootTable
end

local function cancelOpening(item)
    if not item then
        return
    end
    item:removeCustomAttribute("opening")
    item:removeCustomAttribute("playerOpening")
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Verifica se o baú já foi aberto
    if item:getCustomAttribute("opened") then
        return false
    end

    -- Verifica se o baú já está sendo aberto
    if item:getCustomAttribute("opening") then
        local openingPlayerId = item:getCustomAttribute("playerOpening")
        if openingPlayerId == player:getId() then
            player:sendCancelMessage("You are already checking this loot.")
        else
            player:sendCancelMessage("This loot is already being checked by another player.")
        end
        return false
    end

    -- Marca o baú como sendo aberto
    item:setCustomAttribute("opening", 1)
    item:setCustomAttribute("playerOpening", player:getId())

    -- Posição inicial do player
    local initialPos = player:getPosition()

    -- Mensagem inicial
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Searching for loot...")

    -- Contagem regressiva com efeitos
    for i = 1, 3 do
        addEvent(function()
            local currentPlayer = Player(player:getId())
            if not currentPlayer then
                cancelOpening(item)
                return
            end

            -- Efeito de loading bar
            local loadingPosition = Position(fromPosition.x, fromPosition.y, fromPosition.z)
            loadingPosition:sendMagicEffect(178)

            -- Verifica se o player se moveu
            if currentPlayer:getPosition() ~= initialPos then
                currentPlayer:sendCancelMessage("You moved and interrupted the loot check.")
                cancelOpening(item)
                return
            end

            currentPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Searching for loot... " .. (4 - i) .. "s")
        end, i * 1000)
    end

    -- Após 3 segundos, adiciona os itens e marca o baú como aberto
    addEvent(function()
        local currentPlayer = Player(player:getId())
        if not currentPlayer then
            cancelOpening(item)
            return
        end

        -- Verifica se o player se moveu
        if currentPlayer:getPosition() ~= initialPos then
            currentPlayer:sendCancelMessage("You moved and interrupted the loot check.")
            cancelOpening(item)
            return
        end

        -- Cria o baú aberto
        local openedChest = Game.createItem(1996, 1, fromPosition)
        if not openedChest then
            cancelOpening(item)
            return
        end

        -- Pega o loot salvo e adiciona no baú
        local lootData = item:getCustomAttribute("monsterLoot")
        if lootData then
            local lootTable = deserializeLoot(lootData)
            for _, lootItem in ipairs(lootTable) do
                local newItem = Game.createItem(lootItem.id, lootItem.count)
                if newItem then
                    -- Adiciona os atributos ao item
                    for name, value in pairs(lootItem.attributes) do
                        if name == "name" then
                            newItem:setAttribute(name, value)
                        else
                            newItem:setCustomAttribute(name, value)
                        end
                    end
                    -- Adiciona o item ao baú aberto
                    openedChest:addItemEx(newItem)
                end
            end
        end

        -- Remove o baú fechado
        item:remove()

        -- Remove o baú após 1 minuto
        addEvent(function()
            local tile = Tile(fromPosition)
            if tile then
                local chest = tile:getItemById(1996)
                if chest then
                    chest:remove()
                end
            end
        end, 60 * 1000)

        -- Marca o baú como não mais sendo aberto
        cancelOpening(item)

        -- Efeito de baú aberto
        fromPosition:sendMagicEffect(174)

        -- Mensagem de sucesso
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Loot check successful!")
    end, 3100)

    return false
end
