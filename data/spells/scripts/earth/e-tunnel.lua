function onCastSpell(player, var)
  local cid = player:getId()
  local target = getCreatureTarget(cid)
  local oldPosPlayer = player:getPosition()
  local route = fireRoute(player:getPosition(), getThingPos(target))
  doSendAnimatedText("Tunnel", oldPosPlayer, TEXTCOLOR_LIGHTGREEN)
  local function doTunnel(cid, target, pos)
    local topTarget = getTopCreature(pos).uid
    if topTarget then
      if target == topTarget then
        doTeleportThing(cid, getThingPos(target))
        doTeleportThing(topTarget, oldPosPlayer)
      end
    end

    doSendMagicEffect(pos, 35)
  end

  for _, v in pairs(route) do
    if _ < 8 then
      addEvent(doTunnel, 200*_, cid, target, v)
    else
      return true
    end
  end
  return true
end
