local function hasTile(pos)
  pos.stackpos = 0
  return getTileThingByPos(pos).itemid >= 1
end

local function checkPos(pos)
  if hasTile(pos) and not getTileInfo(pos).house and isWalkable(pos, true, true, true) then
    return true
  end
end

local jumpHeigth = 2


function onCastSpell(player, var)
  local cid = player:getId()
  if player:getStorageValue(storage.ingrainReduce) == 1 then
  	return doPlayerSendCancel(cid, "You can't use jump while use ingrain.")
  end
  cpos = getThingPos(cid)
  pos = changeposbydir(getThingPos(cid), getPlayerLookDir(cid), 1)
  if pos.z > 7 then
    start = 8
    fim = 15
  else
    start = 0
    fim = 7
  end
  local tilePos1 = {x=cpos.x,y=cpos.y, z=cpos.z-1}

  for z=start,fim do
    local mpos = {x=pos.x,y=pos.y,z=z}
    local tilePos = {x=cpos.x,y=cpos.y, z=cpos.z-1}
    if mpos.z < pos.z then
	    if hasTile({x=cpos.x,y=cpos.y,z=mpos.z}) or hasTile({x=cpos.x,y=cpos.y,z=cpos.z-1})  then
	      if isWalkable(pos, false, false, true) then

	        if isWalkable(changeposbydir(cpos, getPlayerLookDir(cid), 1), true, true, true) then
	          createStones(cpos, 1*2000)
	          doTeleportThing(cid, pos)
   		      doSendAnimatedText("Jump",getCreaturePosition(cid), TEXTCOLOR_LIGHTGREEN)
	          doSendMagicEffect(pos, CONST_ME_MAGIC_GREEN)
	        else
	          return doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTENOUGHROOM)
	        end
	       
	      else
	        return doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTENOUGHROOM)
	      end
	      return true
	    end
	end
    if checkPos(mpos)  then
      if queryTileAddThing(cid, mpos) and isWalkable(mpos, true, true, true ) and hasTile(mpos) then
        if z >= pos.z  then
          if getTopCreature({x=pos.x, y=pos.y, z=pos.z+1, stackpos=i}).uid > 0 then
            return doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTENOUGHROOM)
          end
          if mpos.z > pos.z and not isWalkable(mpos) then
          	if hasTile(pos) then
          		return doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTENOUGHROOM)
          	end
          end
		  if mpos.z == pos.z then -- checa a movimentação pra frente sem mudar de andar
	       	for x = 0, 255 do
            	if string.match(string.lower(getItemName(getThingfromPos({x=pos.x, y=pos.y, z=pos.z, stackpos=x}).itemid)), ".*archway.*") or string.match(string.lower(getItemName(getThingfromPos({x=pos.x, y=pos.y, z=pos.z, stackpos=x}).itemid)), ".*ramp.*") or string.match(string.lower(getItemName(getThingfromPos({x=pos.x, y=pos.y, z=pos.z, stackpos=x}).itemid)), "stairs") or string.match(string.lower(getItemName(getThingfromPos({x=pos.x, y=pos.y, z=pos.z, stackpos=x}).itemid)), "hole") or string.match(string.lower(getItemName(getThingfromPos({x=pos.x, y=pos.y, z=pos.z, stackpos=x}).itemid)), "trapdoor") then
              		return doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTENOUGHROOM)
            	end
          	end
      	  end

          if mpos.z > pos.z then -- checa se a posição de baixo tem algum item quando esta previso para teleportar a baixo dela
          	if hasTile(pos) then
          		return doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTENOUGHROOM)
          	end
	       	for x = 0, 255 do
            	if string.match(string.lower(getItemName(getThingfromPos({x=mpos.x, y=mpos.y, z=mpos.z, stackpos=x}).itemid)), ".*ramp.*") or string.match(string.lower(getItemName(getThingfromPos({x=mpos.x, y=mpos.y, z=mpos.z, stackpos=x}).itemid)), "stairs") or string.match(string.lower(getItemName(getThingfromPos({x=mpos.x, y=mpos.y, z=mpos.z, stackpos=x}).itemid)), "hole")  or string.match(string.lower(getItemName(getThingfromPos({x=mpos.x, y=mpos.y, z=mpos.z, stackpos=x}).itemid)), "trapdoor")then
              		return doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTENOUGHROOM)
            	end
          	end
            for x = 0, 255 do
              if getThingfromPos({x=mpos.x, y=mpos.y, z=mpos.z-1, stackpos=x}).itemid ~= 0 and hasTile({x=mpos.x, y=mpos.y, z=mpos.z-1}) then
                return doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTENOUGHROOM)
              end
            end

            if getThingfromPos({x=mpos.x, y=mpos.y, z=mpos.z-1}).itemid == 919 then
              return doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTENOUGHROOM)
            end

          end
          doTeleportThing(cid, mpos)
          doSendAnimatedText("Jump",getCreaturePosition(cid), TEXTCOLOR_LIGHTGREEN)
          doSendMagicEffect(mpos, CONST_ME_MAGIC_GREEN)
          createStones(cpos, 1*2000)
          return true
        else
          if mpos.z < pos.z-jumpHeigth then
            return doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTENOUGHROOM)
          end

          if getTopCreature({x=pos.x, y=pos.y, z=pos.z-1, stackpos=i}).uid > 0 then
            return doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTENOUGHROOM)
          end

          if mpos.z < pos.z then -- checa a se tem um objeto do tipo escada, ou rampa na proxima
            for x = 0, 255 do
              if string.match(string.lower(getItemName(getThingfromPos({x=mpos.x, y=mpos.y, z=mpos.z, stackpos=x}).itemid)), ".*ramp.*") or string.match(string.lower(getItemName(getThingfromPos({x=mpos.x, y=mpos.y, z=mpos.z, stackpos=x}).itemid)), ".*archway.*") or string.match(string.lower(getItemName(getThingfromPos({x=mpos.x, y=mpos.y, z=mpos.z, stackpos=x}).itemid)), "stairs") or string.match(string.lower(getItemName(getThingfromPos({x=mpos.x, y=mpos.y, z=mpos.z, stackpos=x}).itemid)), "hole") or string.match(string.lower(getItemName(getThingfromPos({x=mpos.x, y=mpos.y, z=mpos.z, stackpos=x}).itemid)), "trapdoor")then
                return doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTENOUGHROOM)
              end
            end
          end 
          doTeleportThing(cid, mpos)
          doSendAnimatedText("Jump", getCreaturePosition(cid), TEXTCOLOR_LIGHTGREEN)
          doSendMagicEffect(mpos, CONST_ME_MAGIC_GREEN)
          createStones(cpos, 1*2000)
          return true
        end
      else
        return doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTENOUGHROOM)
      end
      return true
    end
  end
  doPlayerSendCancel(cid, "you can't jump here.")
  return true
end
