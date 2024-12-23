local spell = {}

spell.config = {
  [1] = {
    area = {
    {0  , 3, 0},
    }
  },
  [2] = {
    area = {
    {1, 3, 1},
    },
  },
  [3] = {
    area = {
    {1, 1, 3, 1, 1},
    },
  }
}

spell.combats = {}

for _, config in ipairs(spell.config) do
  local combat = Combat()
  combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
  combat:setParameter(COMBAT_PARAM_EFFECT, 85)
  combat:setArea(createCombatArea(config.area))
  combat:setParameter(COMBAT_PARAM_CREATEITEM, 5619)

  function onGetFormulaValues(player, skill, attack, factor)
    local min = ((player:getLevel() + bender_attack['earth_barrier'].min) * bender_attack['earth_barrier'].min_mult)
    local max = ((player:getLevel() + bender_attack['earth_barrier'].max) * bender_attack['earth_barrier'].max_mult)
    return -min, -max
  end
  
  combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
  table.insert(spell.combats, combat)
end


function onCastSpell(player, var)
  local cid = player:getId()

  local v = getPlayerStorageValue(cid, storage.barrier)
  local time1 = getPlayerStorageValue(cid, storage.barrier_time1)
  local time2 = getPlayerStorageValue(cid, storage.barrier_time2)
  
  if v < 1 then 
    v = 1 
  end
  local dir = getPlayerLookDir(cid)
  local pos = changeposbydir(getThingPos(cid), dir, 4)  
  doCombat(cid, spell.combats[v], positionToVariant(pos))  
  doSendAnimatedText("Barrier", getThingPos(cid), TEXTCOLOR_LIGHTGREEN)
  if v > 1 and os.clock() - time1 - (time2/500) > 1 then v = 1 end
  setPlayerStorageValue(cid, storage.barrier, v%3+1)
  setPlayerStorageValue(cid, storage.barrier_time1, math.floor(os.clock()))
  setPlayerStorageValue(cid, storage.barrier_time2, (os.clock() - math.floor(os.clock())) * 500)
  return true
end
