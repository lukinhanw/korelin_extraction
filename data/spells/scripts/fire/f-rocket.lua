local condition = createConditionObject(CONDITION_SPELLGROUPCOOLDOWN)
condition:setParameter(CONDITION_PARAM_SUBID, 1)
condition:setParameter(CONDITION_PARAM_TICKS, 1000)

local function fire_rocket(cid, oldLook, distance)
  if not isCreature(cid) then
    return true
  end
  local poslook = getCreatureLookPosition(cid)
   local dir1 = {
      [0] = {x=poslook.x + 1 , y=poslook.y+1, z=poslook.z},
      [1] = {x=poslook.x-1, y=poslook.y+1, z=poslook.z},
      [2] = {x=poslook.x + 1 , y=poslook.y - 1, z=poslook.z},
      [3] = {x=poslook.x + 1 , y=poslook.y -1, z=poslook.z},
    }
    local dir2 = {
      [0] = {x=poslook.x - 1 , y=poslook.y+1, z=poslook.z},
      [1] = {x=poslook.x-1 , y=poslook.y-1, z=poslook.z},
      [2] = {x=poslook.x - 1 , y=poslook.y - 1, z=poslook.z},
      [3] = {x=poslook.x + 1 , y=poslook.y +1, z=poslook.z},
    }
 
  local player = Player(cid)
  if distance > 0 then
    if isInverseDir(oldLook, getPlayerLookDir(cid)) then
      player:setStorageValue(storage.fire_rocket, 0) 
      player:setStorageValue(storage.fire_rocket_exhausted, os.time() + 4)
      player:removeCondition(CONDITION_SPELLGROUPCOOLDOWN)
      return player:sendCancelMessage("You stopped rocket.")
    end 
    if player:getStorageValue(storage.fire_rocket) == 0 then
      player:setStorageValue(storage.fire_rocket_exhausted, os.time() + 4)
      player:removeCondition(CONDITION_SPELLGROUPCOOLDOWN)
      return player:sendCancelMessage("You stopped rocket.")
    end  

    if isWalkable(poslook, true, true, true) and not isCreature(getThingfromPos(poslook).uid) then
      for n = 0, 255 do
        if isInArray(excluded_border, getThingfromPos({x=poslook.x, y=poslook.y, z=poslook.z, stackpos=n}).itemid) then

          if getCreatureHealth(cid) >= getCreatureMaxHealth(cid) * 0.10 then
            addEvent(doCreatureAddHealth, 100, cid, -10)
            doPlayerSendTextMessage(cid, 19, "Você perdeu 10 pontos de vida.")
            addEvent(doSendAnimatedText, 200, "10",getCreaturePosition(cid), 150)
          end
          return false
        end
      end

      if getCreatureHealth(cid) >= getCreatureMaxHealth(cid) * 0.10 then
        addEvent(doCreatureAddHealth, 100, cid, -10)
        doPlayerSendTextMessage(cid, 19, "Você perdeu 10 pontos de vida.")
        addEvent(doSendAnimatedText, 200, "10",getCreaturePosition(cid), 150)
      end
      doMoveCreature(cid, getPlayerLookDir(cid))

    else
      if getCreatureHealth(cid) >= getCreatureMaxHealth(cid) * 0.10 then
        addEvent(doCreatureAddHealth, 100, cid, -10)
        doPlayerSendTextMessage(cid, 19, "Você perdeu 10 pontos de vida.")
        addEvent(doSendAnimatedText, 200, "10",getCreaturePosition(cid), 150)
      end

      
    end
    player:addCondition(condition)
    addEvent(fire_rocket, 120-(getPlayerLevel(cid)/10), cid, getPlayerLookDir(cid), distance - 1)
  else
    player:removeCondition(CONDITION_EXHAUST_COMBAT)
    player:setStorageValue(storage.fire_rocket_exhausted, os.time() + 4)
    player:setStorageValue(storage.fire_rocket, 0)
  end
  return true
end



function onCastSpell(player, var)
  local cid = player:getId()
  local distance = 30
  local oldPos = getPlayerPosition(cid)
  if player:getStorageValue(storage.ingrainReduce) == 1 then
    return player:sendCancelMessage("You can't use rocket while using ingrain.")
  end
  if(player:getStorageValue(storage.fire_rocket_exhausted) > os.time() and player:getStorageValue(storage.fire_rocket_exhausted) < 100+os.time()) then -- exhausted
    doSendMagicEffect(player:getPosition(), 3)
    player:sendCancelMessage("You are exhausted. Wait " .. player:getStorageValue(storage.fire_rocket_exhausted) - os.time() .. ' second' .. ((player:getStorageValue(storage.fire_rocket_exhausted) - os.time()) == 1 and "" or "s"))
    return false    
  end 
  if player:getStorageValue(storage.fire_rocket) == 0 then 
    doSendAnimatedText("Rocket", player:getPosition(), TEXTCOLOR_ORANGE)
    player:setStorageValue(storage.fire_rocket, 1)
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Use CTRL + SETAS do TECLADO para controlar o rocket, para parar basta virar na direção oposta.")
    fire_rocket(cid, getPlayerLookDir(cid), distance)  
  else
    player:setStorageValue(storage.fire_rocket, 0)
  end

  return true
end
