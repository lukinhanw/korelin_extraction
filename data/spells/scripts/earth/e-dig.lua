local holes = {468, 481, 483}
function onCastSpell(player, var)
  local cid = player:getId()

  if getCreatureLookPosition(cid).x == CONTAINER_POSITION then
    return true
  end
  local pos = getCreatureLookPosition(cid)
  local tile = Tile(pos)
  if not tile then
    return true
  end

  local ground = tile:getGround()
  if not ground then
    return true
  end
  local groundId = ground:getId()
  if isInArray(holes, groundId) then
    doSendAnimatedText("Dig", player:getPosition(), TEXTCOLOR_LIGHTGREEN)
    doSendMagicEffect(pos, 35)

    ground:transform(groundId + 1)
    ground:decay()

    pos.z = pos.z + 1
    tile:relocateTo(pos)
  else
    player:sendCancelMessage("There is not a hole in front of you.")
    doSendMagicEffect(player:getPosition(), 3)
    return true
  end

  return true
end
