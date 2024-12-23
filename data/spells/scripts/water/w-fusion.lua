function onCastSpell(player, var)
	local cid = player:getId()
	local pos = getCreaturePosition(cid)
	pos.stackpos = 0
	local ground = getTileThingByPos(pos)
	local myitem = getPlayerSlotItem(cid, 10)
	if isPisoNevado(ground.itemid) == 1 then
		doSendAnimatedText("Fusion", getThingPos(cid), TEXTCOLOR_WATER)
		if myitem.itemid == 4864 or myitem.itemid == 4863 then
			if myitem.itemid == 4864 and (myitem.actionid == 0 or myitem.actionid == 100 or myitem.actionid == 200) then
				doPlayerSendCancel(cid, "The water pouch is full.")
			return true
			end
		if myitem.itemid == 4863 then doTransformItem(myitem.uid, 4864) end
			local x = math.min(200, myitem.actionid+5)
			doSetItemActionId(myitem.uid, x)
			doItemSetAttribute(myitem.uid, "description", "Remaining: "..(x-100).. "%")
			doPlayerSendTextMessage(cid, 22, (x-100).. "%")
			doSendMagicEffect(pos, 26)
		else
			doPlayerSendCancel(cid, "You don't have water pouch")
		end
	else
		doPlayerSendCancel(cid, "This fold can only be used in snow.")
	end
return true
end