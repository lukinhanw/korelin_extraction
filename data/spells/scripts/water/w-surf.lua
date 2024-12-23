local condition = createConditionObject(CONDITION_SPELLGROUPCOOLDOWN)
condition:setParameter(CONDITION_PARAM_SUBID, 1)
condition:setParameter(CONDITION_PARAM_TICKS, 1000)

local area = {
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 1, 0, 0, 0},
	{0, 0, 1, 2, 1, 0, 0},
	{0, 0, 1, 1, 1, 0, 0},
	{0, 0, 1, 1, 1, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 0},

}

local spell = {}

spell.config = {
  [5] = {
    area = {
      {0, 0, 0, 0, 0}, 
      {0, 0, 0, 0, 0},      
      {0, 0, 2, 0, 0},
    },
  },

  [4] = {
    area = {
	  {0, 0, 1, 0, 0},
      {0, 0, 2, 0, 0},
    },
  },

  [3] = {
    area = {
	  {0, 0, 0, 0, 0},
	  {0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0},      
      {0, 0, 2, 0, 0},
    },
  },
  [2] = {
    area = {

      {1, 2, 1},
      {0, 1, 0},

    },
  },
  [1] = {
    area = {
      {0, 2, 0},
      {0, 0, 0},
      {0, 1, 0}    
    
    },
  },
}
spell.combats = {}
for _, config in ipairs(spell.config) do
  local combat = Combat()
  combat:setParameter(COMBAT_PARAM_EFFECT, 109)
  combat:setArea(createCombatArea(config.area))
  table.insert(spell.combats, combat)
end


local function water_surf(cid, oldLook, distance)
  if not isCreature(cid) then
    return true
  end
  local player = Player(cid)
  local poslook = getCreatureLookPosition(cid)
  if distance > 0 then
    if isInverseDir(oldLook, getPlayerLookDir(cid)) then
      player:setStorageValue(storage.water_surf, 0) 
      player:setStorageValue(storage.water_surf_exhausted, os.time() + 3)
      player:removeCondition(CONDITION_SPELLGROUPCOOLDOWN)
      return player:sendCancelMessage("You stopped surf.")
    end   
    if player:getStorageValue(storage.water_surf) == 0 then
      player:setStorageValue(storage.water_surf_exhausted, os.time() + 3)
      player:removeCondition(CONDITION_SPELLGROUPCOOLDOWN)
      return player:sendCancelMessage("You stopped surf.")
    end  
    if isWalkable(poslook, true, true, true) and not isCreature(getThingfromPos(poslook).uid) then
      for n = 0, 255 do
        if isInArray(excluded_border, getThingfromPos({x=poslook.x, y=poslook.y, z=poslook.z, stackpos=n}).itemid) then

          if getCreatureHealth(cid) >= getCreatureMaxHealth(cid) * 0.10 then
            addEvent(doCreatureAddHealth, 100, cid, -12)
            doPlayerSendTextMessage(cid, 19, "Voc� perdeu 12 pontos de vida.")
          end
          return false
        end
      end
    	for n = 1, #spell.combats do
    		addEvent(doCombat, (n * 50), cid, spell.combats[n], positionToVariant(getThingPos(cid)))
    	end

      doMoveCreature(cid, getPlayerLookDir(cid))
      doSendMagicEffect(changeposbydir(getThingPos(cid), getPlayerLookDir(cid), -1), 26)
    else
      if getCreatureHealth(cid) >= getCreatureMaxHealth(cid) * 0.10 then
        addEvent(doCreatureAddHealth, 100, cid, -12)
        doPlayerSendTextMessage(cid, 19, "Voc� perdeu 12 pontos de vida.")
      end
    end
    player:addCondition(condition)
    if not nearWater(cid) then
      addEvent(water_surf, 170 - (getPlayerLevel(cid)/10),cid, getPlayerLookDir(cid), distance-1)
    else
      addEvent(water_surf, 100 - (player:getLevel()/10), cid , getPlayerLookDir(cid), distance-1)
    end
  else
    player:removeCondition(CONDITION_EXHAUST_COMBAT)
    player:setStorageValue(storage.water_surf_exhausted, os.time() + 2)
    player:setStorageValue(storage.water_surf, 0)
  end
  return true
end

  	

function onCastSpell(player, var)
  local cid = player:getId()
  local distance = 25
  local distance_water = 40
  local oldPos = getPlayerPosition(cid)
  
  if player:getStorageValue(storage.ingrainReduce) == 1 then
    return player:sendCancelMessage("You can't use surf while using ingrain.")
  end
  
  if(player:getStorageValue(storage.water_surf_exhausted) > os.time() and player:getStorageValue(storage.water_surf_exhausted) < 100+os.time()) then -- exhausted
    doSendMagicEffect(player:getPosition(), 3)
    player:sendCancelMessage("You are exhausted. Wait " .. player:getStorageValue(storage.water_surf_exhausted) - os.time() .. ' second' .. ((player:getStorageValue(storage.water_surf_exhausted) - os.time()) == 1 and "" or "s"))
    return false    
  end 
  
  if not nearWater(cid) then
    distance = distance
  else
    distance = distance_water
  end
  if player:getStorageValue(storage.water_surf) == 0 then 
    if hasWater(cid, 5) then
      doSendAnimatedText("Surf",getCreaturePosition(cid), TEXTCOLOR_WATER)
      player:setStorageValue(storage.water_surf, 1)
      player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Use CTRL + SETAS do TECLADO para controlar o surf, para parar basta virar na dire��o oposta.")
      water_surf(cid, getPlayerLookDir(cid), distance)  
    end
  else
    player:setStorageValue(storage.water_surf, 0)
  end
  return true
end
