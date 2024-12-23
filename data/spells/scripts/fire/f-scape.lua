local ArrayRopeSpot = {384, 418}

function onCastSpell(cid, var)
	local pos = getPlayerPosition(cid)
	pos.stackpos = 0
	local grounditem = getThingfromPos(pos)

	if(isInArray(ArrayRopeSpot, grounditem.itemid) == true) then
		local newpos = pos
		newpos.y = newpos.y + 1
		newpos.z = newpos.z - 1
		doSendAnimatedText("Scape",newpos, TEXTCOLOR_ORANGE)
		doTeleportThing(cid, newpos)
		doSendMagicEffect(pos, 7)
		doSendMagicEffect(newpos, 7)
		
		return LUA_NO_ERROR
	else
		doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
		doSendMagicEffect(pos, CONST_ME_POFF)
		return LUA_ERROR
	end	
	return true
end