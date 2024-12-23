local spell = {}

spell.config = {
  [4] = {
    area = {
      {0, 0, 0, 1, 1, 1, 0, 0, 0},
      {0, 0, 1, 0, 0, 0, 1, 0, 0},
      {0, 1, 0, 0, 0, 0, 0, 1, 0},
      {1, 0, 0, 0, 0, 0, 0, 0, 1},
      {1, 0, 0, 0, 2, 0, 0, 0, 1},
      {1, 0, 0, 0, 0, 0, 0, 0, 1},
      {0, 1, 0, 0, 0, 0, 0, 1, 0},
      {0, 0, 1, 0, 0, 0, 1, 0, 0},
      {0, 0, 0, 1, 1, 1, 0, 0, 0}
    },
  },
  [3] = {
    area = {
      {0, 0, 1, 1, 1, 0, 0},
      {0, 1, 0, 0, 0, 1, 0},
      {1, 0, 0, 0, 0, 0, 1},
      {1, 0, 0, 2, 0, 0, 1},
      {1, 0, 0, 0, 0, 0, 1},
      {0, 1, 0, 0, 0, 1, 0},
      {0, 0, 1, 1, 1, 0, 0}
    },
  },
  [2] = {
    area = {
      {0, 1, 1, 1, 0},
      {1, 0, 0, 0, 1},
      {1, 0, 2, 0, 1},
      {1, 0, 0, 0, 1},
      {0, 1, 1, 1, 0}
    },
  },
  [1] = {
    area = {
      {1, 1, 1},
      {1, 2, 1},
      {1, 1, 1}
    },
  },
}

spell.combats = {}

for _, config in ipairs(spell.config) do
  local combat = Combat()
  combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
  combat:setParameter(COMBAT_PARAM_EFFECT, 110)
  combat:setArea(createCombatArea(config.area))

  function onGetFormulaValues(player, skill, attack, factor)
    local min = ((player:getLevel() + bender_attack['water_spin'].min) * bender_attack['water_spin'].min_mult)
    local max = ((player:getLevel() + bender_attack['water_spin'].max) * bender_attack['water_spin'].max_mult)
    return -min, -max
  end
  function onTargetCreature(creature, target)
    moveCreature(creature:getId(), target:getId(), getPushDir(creature:getId(), target:getId()))
  end
  combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")
  combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
  table.insert(spell.combats, combat)
end


function onCastSpell(player, var)
  if not player then return false end
  local cid = player:getId()
  if not hasWater(cid, 3) then return true end
  local spin =  getPlayerStorageValue(cid, storage.water_spin)
  local time = getPlayerStorageValue(cid, storage.water_spin_time1)
  doSendAnimatedText("Spin", getThingPos(cid), TEXTCOLOR_WATER)
  if player:canMove() == true then
    noMove(cid, 0.8, 3)
  end
  if spin < 1 then
    spin = 1
  end
  if spin > 1 and time <= os.time() then spin = 1 setPlayerStorageValue(cid, storage.water_spin, 1) end
  doCombat(cid, spell.combats[spin], var)
  setPlayerStorageValue(cid, storage.water_spin, spin%4+1)
  setPlayerStorageValue(cid, storage.water_spin_time1, os.time() + 2)
  return true
end