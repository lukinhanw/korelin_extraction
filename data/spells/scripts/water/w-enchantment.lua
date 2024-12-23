function onCastSpell(player, var)
    local potionId = 7618 -- ID da Small Health Potion
    local newPotionId = 7591 -- ID da Strong Health Potion
    local soulCost = 1 -- Custo em Soul Points

    if player:getSoul() < soulCost then
        player:sendCancelMessage("You need 1 Soul point to perform this bender.")
        return false
    end

    local potion = player:getItemById(potionId, true)
    if potion then
        if potion.type > 1 then -- Se a quantidade do item for maior que 1
            potion:remove(1) -- Remove apenas uma unidade
        else
            potion:remove() -- Remove o item se este for o último ou o único
        end

        player:addItem(newPotionId, 1) -- Adiciona 1 Strong Health Potion ao inventário do jogador
        player:addSoul(-soulCost)
		doSendAnimatedText("Enchantment", getThingPos(player), TEXTCOLOR_WATER)
		doSendMagicEffect(player:getPosition(), 26)
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You enchanted a healing potion.")
        return true
    else
        player:sendCancelMessage("You need a Health Potion to perform this enchantment.")
        return false
    end
end