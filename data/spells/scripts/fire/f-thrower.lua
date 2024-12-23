local spell = {}

spell.config = {
  [6] = {
    area = {
      {1, 1, 1},
      {0, 0, 0},
      {0, 0, 0},
      {0, 0, 0},
      {0, 0, 0},
      {0, 2, 0},
    },
  },
  [5] = {
    area = {
      {1, 1, 1},
      {0, 0, 0},
      {0, 0, 0},
      {0, 0, 0},
      {0, 2, 0},
    },
  },
  [4] = {
    area = {
      {1, 1, 1},
      {0, 0, 0},
      {0, 0, 0},
      {0, 2, 0},
    },
  },

  [3] = {
    area = {
      {1, 1, 1},
      {0, 0, 0},
      {0, 2, 0},
    },
  },
  [2] = {
    area = {
      {0, 1, 0},
      {0, 2, 0},
    },
  },
  [1] = {
    area = {
      {0, 3, 0},
    },
  },
}

spell.combats = {}
for _, config in ipairs(spell.config) do
  local combat = Combat()
  combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
  combat:setParameter(COMBAT_PARAM_EFFECT, 6)
  combat:setArea(createCombatArea(config.area))
  function onGetFormulaValues(player, skill, attack, factor)
    local min = ((player:getLevel() + bender_attack['fire_thrower'].min) * bender_attack['fire_thrower'].min_mult) / 3
    local max = ((player:getLevel() + bender_attack['fire_thrower'].max) * bender_attack['fire_thrower'].max_mult) / 3
    return -min, -max
  end
  combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
  table.insert(spell.combats, combat)
end


function onCastSpell(player, var)
  local combo = player:getStorageValue(storage.fire_thrower_combo)

  if not player then return false end
  local cid = player:getId()
  doSendAnimatedText("Thrower", getThingPos(cid), TEXTCOLOR_ORANGE)
  if player:canMove() == true then
    noMove(cid, 0.5, 3)
  end
  for m = 1,3 do
    for n = 1, #spell.combats do
      addEvent(doCombat, (m-1)*200 + (n * 120), cid, spell.combats[n], var)
    end
  end
  if combo < 2 then
  	player:setStorageValue(storage.fire_thrower_combo, combo + 1)
  else
  	player:setStorageValue(storage.fire_thrower_time, os.time() + 2)
  	player:setStorageValue(storage.fire_thrower_combo, 0)
  end
  return true
end