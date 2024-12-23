local spell = {}

local dir = {[0] = {6418, 6419}, [1] = {6416, 6417}, [2] = {6418, 6419}, [3] = {6416, 6417}}


spell.config = {
  [3] = {
    area = {
      {0, 1, 0},
      {0, 1, 0},
      {0, 0, 0},
      {0, 0, 0},
      {0, 0, 0},
      {0, 2, 0},
    },
  },
  [2] = {
    area = {
      {0, 1, 0},
      {0, 1, 0},
      {0, 0, 0},
      {0, 2, 0},
    },
  },
  [1] = {
    area = {
      {0, 1, 0},
      {0, 3, 0},
    },
  },
}
local function createSpikes(id, pos, time)
  local npos = {x=pos.x, y=pos.y, z=pos.z}
  if(isWalkable(npos)) then
    doCreateItem(id, 1, npos)
    doCreateItem(id-1, 1, npos)
    addEvent(removeStones, time, id, npos)
    addEvent(removeStones, time, id-1, npos)
  end
end
local function createIceSpikes(id, pos, time)
  if(isWalkable(pos)) then
    doCreateItem(id, 1, pos)
    addEvent(removeStones, time, id, pos)
  end
end
spell.combats = {}
for _, config in ipairs(spell.config) do
  local combat = Combat()
  combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
  combat:setParameter(COMBAT_PARAM_EFFECT, 3)
  combat:setArea(createCombatArea(config.area))


  function onGetFormulaValues(player, skill, attack, factor)

    local minDmg = ((player:getLevel() + bender_attack['earth_spikes'].min) * bender_attack['earth_spikes'].min_mult)
    local maxDmg = ((player:getLevel() + bender_attack['earth_spikes'].max) * bender_attack['earth_spikes'].max_mult)
    return -minDmg, -maxDmg
  end
  function onTargetTile(creature, position)
    local cid = creature:getId()
    local ground = getTileThingByPos(position)
    if isPisoNevado(ground.itemid) == 1 then
      createIceSpikes(6966, position, 2000)
    else
      createSpikes(dir[getPlayerLookDir(cid)][2], position, 2000)
    end
  end
  combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

  combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
  table.insert(spell.combats, combat)
end

function onCastSpell(player, var)
  local cid = player:getId()
  doSendAnimatedText("Spikes", getThingPos(cid), TEXTCOLOR_LIGHTGREEN)
  for n = 1, #spell.combats do
    addEvent(doCombat, (n * 180), cid, spell.combats[n], var)
  end
  if player:canMove() == true then
    noMove(cid, 1, 2)
  end
  return true
end
