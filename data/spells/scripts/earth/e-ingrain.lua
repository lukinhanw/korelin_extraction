local function ingrain_heal(cid, time)
  if not isCreature(cid) then return true end
  local player = Player(cid)
  if time > 0 then
    player:setNoMove(true)
    doSendMagicEffect(getCreaturePos(cid), 88)
    doCreatureAddHealth(cid, getPlayerLevel(cid) * 0.4)
    addEvent(valid(ingrain_heal), 1000, cid, time - 1)
  else
    player:setNoMove(false)
  	setPlayerStorageValue(cid, storage.ingrainReduce, 0)
  end
end
local spells_storages = {1124, 1125, 1126, 1127}
function onCastSpell(player, var)
  local cid = player:getId()
  if not isCreature(cid) then
    return true
  end
  for i = 1, #spells_storages do
    if player:getStorageValue(spells_storages[i]) == 1 then
      return player:sendCancelMessage("You can't use ingrain now.")
    end
  end
  if(player:getStorageValue(storage.ingrain_exhausted) > os.time() and player:getStorageValue(storage.ingrain_exhausted) < 100+os.time()) then -- exhausted
    doSendMagicEffect(player:getPosition(), 3)
    player:sendCancelMessage("You are exhausted. Wait " .. player:getStorageValue(storage.ingrain_exhausted) - os.time() .. ' second' .. ((player:getStorageValue(storage.ingrain_exhausted) - os.time()) == 1 and "" or "s"))
    return false    
  end 
  doSendAnimatedText("Ingrain", getThingPos(cid), TEXTCOLOR_LIGHTGREEN)
  player:setNoMove(true)
  createIngrainTree(getThingPos(cid), 11)
  ingrain_heal(cid, 12)
  player:setStorageValue(storage.ingrainReduce, 1)
  player:setStorageValue(storage.ingrain_exhausted, os.time() + 15)
  return true
end
