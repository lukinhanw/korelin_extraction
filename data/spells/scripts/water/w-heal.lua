local function doHeal(cid, target)
	local player = Player(cid)
 	local pos = getPositionByDirection(getThingPos(cid), getPlayerLookDir(cid), 1)
 	local min = player:getLevel() * 1.0
  local max = player:getLevel() * 1.5
  local target = getTopCreature(pos).uid
  doSendMagicEffect(pos, 87)
  if target > 1 then
  	doCreatureAddHealth(target, math.random(min,max))
  end
end

function onCastSpell(player, var)
  local cid = player:getId()
  if not hasWater(cid, 1) then return true end
  doHeal(cid)

  doSendAnimatedText("Heal", getThingPos(cid), TEXTCOLOR_WATER)
  return true
end