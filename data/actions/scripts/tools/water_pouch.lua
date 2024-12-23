
function onUse(player, item, fromPosition, target, toPosition, isHotkey)

	if isPisoBordaDagua(target.itemid) == 1 or isPisoAgua(target.itemid) == 1 then
		item:transform(item:getId() + 1)
		item:setActionId(200)
		doPlayerSendTextMessage(player:getId(), MESSAGE_INFO_DESCR, "Its is full.")
	
		item:setAttribute("description", "It is full.")
		doSendMagicEffect(player:getPosition(), 26)
	else
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "Sorry, its not possible.")
	end
	return false
end
