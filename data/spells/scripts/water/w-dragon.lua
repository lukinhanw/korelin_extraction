
local arr = {
  {1, 1, 1, 1, 3, 1, 1, 1, 1},
  {0, 1, 1, 1, 1, 1, 1, 1, 0},
  {0, 0, 1, 1, 1, 1, 1, 0, 0},
  {0, 0, 0, 0, 1, 0, 0, 0, 0}
}
local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setArea(createCombatArea(arr))

function dragHit(cid, pos, var)
  local target = variantToNumber(var)
  local player = Player(cid)
  local minDmg = ((player:getLevel() + bender_attack['water_dragon'].min) * bender_attack['water_dragon'].min_mult)
  local maxDmg = ((player:getLevel() + bender_attack['water_dragon'].max) * bender_attack['water_dragon'].max_mult)
  if isCreature(target) then
    doSendDistanceShoot(pos, getThingPos(target), 37)
    doTargetCombatHealth(cid, target, 1, -minDmg, -maxDmg, CONST_ME_NONE)
  end
end

function onTargetCreature(creature, target)
  local cid = creature:getId()
  local mpos = changeposbydir(getThingPos(cid), getPlayerLookDir(cid), 1)
  local gpos = changeposbydir(getThingPos(cid), getPlayerLookDir(cid), 3)
  local b = distBetween2(getThingPos(target:getId()), mpos)
  local x = b == 0 and 12 or 5

  for a=1,x do
    addEvent(dragHit, a*2000/x, cid, gpos, numberToVariant(target:getId()))
  end
  return true
end
combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

function onCastSpell(player, var)
  local cid = player:getId()
  if not hasWater(cid,110) then
    doPlayerSendCancel(cid, "Essa dobrar requer uma grande quantidade de agua, vá para pertos de rios ou mares")
    return true
  end
  local pos = changeposbydir(getThingPos(cid), getPlayerLookDir(cid), 3)
  pos.stackpos = 0
  local ground = getTileThingByPos(pos)
  if ground.itemid >= 4608 and ground.itemid <= 4625 or ground.itemid == 493 then
    doSendMagicEffect(pos, 34)
    doCombat(cid, combat, var)
    doSendAnimatedText("Dragon", getThingPos(cid), TEXTCOLOR_WATER)
    return true
  end
  return true
end
