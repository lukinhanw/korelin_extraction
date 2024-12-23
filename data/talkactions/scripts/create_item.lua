local config = {
	rarities = {
		["comum"] = {
			statsBonus = {min = 0, max = 0}
		},
		["rare"] = {
			statsBonus = {min = 0, max = 0}
		},
		["epic"] = {
			statsBonus = {min = 1, max = 2}
		},
		["legendary"] = {
			statsBonus = {min = 2, max = 3}
		}
	}
}

function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end

	-- Separa os parâmetros
	local params = param:split(",")
	if #params < 1 then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE, "Uso: !createitem itemid/nome, [quantidade], [raridade], [atributo1 valor1, atributo2 valor2, ...]")
		return false
	end

	-- Pega o ID do item ou o nome do item
	local itemId
	local quantity = tonumber(params[2]) or 1  -- Define a quantidade como 1 se não for fornecida
	local rarity = params[3] and params[3]:trim():lower() or nil

	-- Verifica se o primeiro parâmetro é um número (ID do item)
	if tonumber(params[1]:trim()) then
		itemId = tonumber(params[1]:trim())
	else
		-- Tenta obter o ID do item pelo nome
		local itemName = params[1]:trim()
		itemId = ItemType(itemName):getId()  -- Usando ItemType para obter o ID
	end

	if not itemId then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE, "ID do item inválido.")
		return false
	end

	if rarity and not config.rarities[rarity] then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE, "Raridade inválida. Use: comum, rare, epic ou legendary")
		return false
	end

	-- Cria o item
	local item = Game.createItem(itemId, quantity)
	if not item then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE, "Item não pode ser criado.")
		return false
	end

	-- Define o nome com a raridade se fornecida
	local itemType = ItemType(itemId)
	local baseName = itemType:getName()
	local newName = rarity and rarity .. " " .. baseName or baseName
	item:setAttribute("name", newName)

	-- Aplica o bônus de stats base se for epic ou legendary
	if rarity then
		local statsBonus = math.random(config.rarities[rarity].statsBonus.min, config.rarities[rarity].statsBonus.max)
		
		local baseArmor = itemType:getArmor()
		if baseArmor and baseArmor > 0 then
			item:setAttribute("armor", baseArmor + statsBonus)
		end

		local baseAttack = itemType:getAttack()
		if baseAttack and baseAttack > 0 then
			item:setAttribute("attack", baseAttack + statsBonus)
		end

		local baseDefense = itemType:getDefense()
		if baseDefense and baseDefense > 0 then
			item:setAttribute("defense", baseDefense + statsBonus)
		end
	end

	-- Tenta adicionar o item ao inventário do jogador
	if player:addItemEx(item) ~= RETURNVALUE_NOERROR then
		-- Se não puder adicionar, coloca o item no chão na posição do jogador
		local playerPos = player:getPosition()
		item:moveTo(playerPos)  -- Usando moveTo para colocar o item no chão
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE, "Item criado no chão, pois não pode ser colocado na mochila.")
	else
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE, "Item criado com sucesso!")
	end

	-- Processa os atributos extras
	if #params > 3 then  -- Verifica se há atributos extras
		for i = 4, #params do
			local attrParam = params[i]:trim():split(" ")
			if #attrParam >= 2 then
				local attrName = attrParam[1]:lower()
				local attrValue = tonumber(attrParam[2])

				if attrValue then
					item:setCustomAttribute(attrName, attrValue)
				end
			end
		end
	end

	return false
end
