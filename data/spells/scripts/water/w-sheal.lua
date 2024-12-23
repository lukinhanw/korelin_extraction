function doHeal(cid)
    local player = Player(cid)
    local min = player:getLevel() * 1.0
    local max = player:getLevel() * 1.3
    doSendMagicEffect(getThingPos(cid), 88)
    return player:addHealth(math.random(min, max))
end

function onCastSpell(player, var)
    local cid = player:getId()
    if not hasWater(cid, 1) then return true end
    doHeal(cid)
    doSendAnimatedText("Heal", getThingPos(cid), TEXTCOLOR_WATER)
    return true
end
