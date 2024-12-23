
local function wrathCharge(cid, target, i, n, equals)
  if not isCreature(target) or not isCreature(cid) or n <= 0 then return false end
  if i == equals then
    create_wratharound(cid, getThingPos(target))
    if isMonster(target) then
      noMove(target, 4, 4)
    end
    return true
  end

  local pos = getThingPos(target)

  local area = {
    {x=pos.x+1, y=pos.y+1, z=pos.z},
    {x=pos.x+1, y=pos.y, z=pos.z},
    {x=pos.x+1, y=pos.y-1, z=pos.z},
    {x=pos.x, y=pos.y-1, z=pos.z},
    {x=pos.x-1, y=pos.y-1, z=pos.z},
    {x=pos.x-1, y=pos.y, z=pos.z},
    {x=pos.x-1, y=pos.y+1, z=pos.z},
    {x=pos.x, y=pos.y+1, z=pos.z},
    {x=pos.x+1, y=pos.y+1, z=pos.z},
    {x=pos.x+1, y=pos.y, z=pos.z},
    {x=pos.x+1, y=pos.y-1, z=pos.z},
    {x=pos.x, y=pos.y-1, z=pos.z},

  }
  local area2 ={
    {x=pos.x-1, y=pos.y-1, z=pos.z},
    {x=pos.x-1, y=pos.y, z=pos.z},
    {x=pos.x-1, y=pos.y+1, z=pos.z},
    {x=pos.x, y=pos.y+1, z=pos.z},
    {x=pos.x+1, y=pos.y+1, z=pos.z},
    {x=pos.x+1, y=pos.y, z=pos.z},
    {x=pos.x+1, y=pos.y-1, z=pos.z},
    {x=pos.x, y=pos.y-1, z=pos.z},
    {x=pos.x-1, y=pos.y-1, z=pos.z},
    {x=pos.x-1, y=pos.y, z=pos.z},
    {x=pos.x-1, y=pos.y+1, z=pos.z},
    {x=pos.x, y=pos.y+1, z=pos.z},

  }
  doSendMagicEffect(area[(i%#area)], 109)
  doSendMagicEffect(area2[(i%#area2)], 109)
  addEvent(wrathCharge, 150, cid, target, i+1, n-1, equals)
end

function onCastSpell(creature, variant, isHotkey)
  local cid = creature:getId()
  local target = getCreatureTarget(cid)
  if target > 1 then
    if creature:canMove() == true then
      noMove(cid, 0.5, 2)
    end
    doSendAnimatedText("Wrath", getThingPos(cid), TEXTCOLOR_ORANGE)
    wrathCharge(cid, target, 1, 12, 12)
  end
  return true
end
