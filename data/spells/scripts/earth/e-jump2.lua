local function doJumpOut(cid)
	local player = Player(cid)
	local pos = getThingPos(cid)
	local newPos = {x=pos.x, y=pos.y, z=pos.z+1}
	if player:getStorageValue(120300) == 0 then
		return true
	end
	if isWalkable(newPos, true, true, true) then
		doTeleportThing(cid, newPos)
		doSendMagicEffect(newPos, 35)
		player:setStorageValue(120300, 0)
	elseif not haveTile(newPos) then
		createTile(newPos, 1*1000)
		doTeleportThing(cid, newPos)
		doSendMagicEffect(pos, 35)
		doJumpOut(cid)	
	else
		addEvent(doJumpOut, 500, cid)
	end
end

local jumpHeigth = 2


function onCastSpell(player, var)
	local cid = player:getId()

	local pos = player:getPosition()
    local newPos = {x=pos.x,y=pos.y,z=pos.z-1}
    if haveTile(newPos) then
		return true
	end
	if player:getStorageValue(120300) == 1 then
		return true
	end
	doSendAnimatedText("Jump",getCreaturePosition(cid), TEXTCOLOR_LIGHTGREEN)
    doSendMagicEffect(pos, 35)
    addEvent(createTile, 200, newPos, 1000)
	addEvent(createStones,200,pos, 1*3000)
	addEvent(doTeleportThing, 200, cid, newPos)
	player:setStorageValue(120300, 1)
	addEvent(doJumpOut, 2000, cid)
  return true
end
