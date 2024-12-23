function onCastSpell(player, var)
  local cid = player:getId()
  player:sendCancelMessage("Use e-sense name to be able to track opponent ")
  return true
end
