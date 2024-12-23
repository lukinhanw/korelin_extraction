local condition = createConditionObject(CONDITION_EXHAUST_COMBAT)
setConditionParam(condition, CONDITION_PARAM_TICKS, 9999999)

local function earth_subway(cid, oldPos, oldLook)
  print(oldPos.x)
  print(oldPos.y)
  print(oldPos.z)
  if not isCreature(cid) then return true end
  local player = Player(cid)
  local newPos = {x=oldPos.x,y=oldPos.y, z=oldPos.z-1}
  local pos = getThingPos(cid)
  local return_pos = {x=pos.x, y=pos.y, z=pos.z-1}
    if isInverseDir(oldLook, getPlayerLookDir(cid)) then
      player:setStorageValue(storage.earth_track, 0) 
          doTeleportThing(cid, return_pos)
      player:setStorageValue(storage.earth_track_exhausted, os.time() + 4)
      player:removeCondition(CONDITION_EXHAUST_COMBAT)
      return player:sendCancelMessage("You stopped track.")
    end 
    if player:getStorageValue(storage.earth_track) == 0 then
          doTeleportThing(cid, return_pos )
      player:setStorageValue(storage.earth_track_exhausted, os.time() + 4)
      player:removeCondition(CONDITION_EXHAUST_COMBAT)
      return player:sendCancelMessage("You stopped track.")
    end    
  if not isCreature(cid) then
    return true
  end
  if not isWalkable(getCreatureLookPosition(cid), true, true, true) and not isCreature(getThingfromPos(getCreatureLookPosition(cid)).uid) then
  	if not haveTile(getCreatureLookPosition(cid)) then
  		print(1)
  		createTile(pos, 1*1000)
  		createTile(getCreatureLookPosition(cid), 1*1000)
  	end
  	
  		createTile(getCreatureLookPosition(cid), 1*1000)
  	doSendMagicEffect(getCreatureLookPosition(cid), 2)
    doSendMagicEffect(getThingPos(cid), 35)
    doMoveCreature(cid, getPlayerLookDir(cid))
    doSendMagicEffect(changeposbydir({x=getThingPos(cid).x,y=getThingPos(cid).y, z=getThingPos(cid).z-1}, getPlayerLookDir(cid), 0), 35)
  else
   	doTeleportThing(cid, oldPos)
    return true
  end   
  addEvent(earth_subway, 170-(getPlayerLevel(cid)/10), cid, oldPos, getPlayerLookDir(cid))
  return true
end



function onCastSpell(player, var)
  local cid = player:getId()
  if not isCreature(cid) then
    return true
  end
  
  local oldPos = player:getPosition()
  local newPos = {x=oldPos.x,y=oldPos.y, z=oldPos.z+1}
  if player:getStorageValue(storage.earth_track) == 0 then
    if not isWalkable(newPos, true, true, true) then
      doTeleportThing(cid, newPos, true)
    	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Use CTRL + SETAS do TECLADO para controlar o subway, para parar basta virar na direção oposta.")
      player:setStorageValue(storage.earth_track, 1)
    	earth_subway(cid, oldPos, getPlayerLookDir(cid))

    else
      doPlayerSendTextMessage(cid, 19, "Você não pode descer aqui.")
    end
  else
    player:setStorageValue(storage.earth_track, 0)
  end
  return true
end
