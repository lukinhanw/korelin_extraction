local spell = {}

spell.config = {
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
  combat:setParameter(COMBAT_PARAM_EFFECT, 7)
  combat:setArea(createCombatArea(config.area))
  function onGetFormulaValues(player, skill, attack, factor)
    local min = ((player:getLevel() + bender_attack['fire_wave'].min) * bender_attack['fire_wave'].min_mult)
    local max = ((player:getLevel() + bender_attack['fire_wave'].max) * bender_attack['fire_wave'].max_mult)
    return -min, -max
  end
  combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
  table.insert(spell.combats, combat)
end


local spell2 = {}

spell2.config = {
  [5] = {
    area = {
      {0, 0, 0, 0, 0, 1, 0, 0},
      {0, 0, 0, 0, 0, 0, 1, 0},
      {0, 0, 0, 0, 0, 0, 0, 1},
      {0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0},
      {0, 2, 0, 0, 0, 0, 0, 0},
    },
  },
  [4] = {
    area = {
      {0, 0, 0, 0, 1, 0, 0},
      {0, 0, 0, 0, 0, 1, 0},
      {0, 0, 0, 0, 0, 0, 1},
      {0, 0, 0, 0, 0, 0, 0},
      {0, 2, 0, 0, 0, 0, 0},
    },
  },
  [3] = {
    area = {
      {0, 0, 0, 1, 0, 0, 0},
      {0, 0, 0, 0, 1, 0, 0},
      {0, 0, 0, 0, 0, 1, 0},
      {0, 2, 0, 0, 0, 0, 0},
    },
  },
  [2] = {
    area = {
      {0, 0, 0, 1},
      {0, 2, 0, 0},
    },
  },
  [1] = {
    area = {
      {0, 2, 1},
    },
  },
}


spell2.combats = {}
for _, config in ipairs(spell2.config) do
  local combat = Combat()
  combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
  combat:setParameter(COMBAT_PARAM_EFFECT, 7)
  combat:setArea(createCombatArea(config.area))
  function onGetFormulaValues(player, skill, attack, factor)
    local min = ((player:getLevel() + 3) * 1.7)
    local max = ((player:getLevel() + 5) * 1.9)
    return -min, -max
  end
  combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
  table.insert(spell2.combats, combat)
end

local spell3 = {}

spell3.config = {
  [5] = {
    area = {
      {0, 0, 1, 0, 0, 0, 0, 0},
      {0, 1, 0, 0, 0, 0, 0, 0},
      {1, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 2, 0},
    },
  },
  [4] = {
    area = {
      {0, 0, 1, 0, 0, 0, 0},
      {0, 1, 0, 0, 0, 0, 0},
      {1, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 2, 0},
    },
  },
  [3] = {
    area = {
      {0, 0, 0, 1, 0, 0, 0},
      {0, 0, 1, 0, 0, 0, 0},
      {0, 1, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 2, 0},
    },
  },
  [2] = {
    area = {
      {1, 0, 0, 0, 0},
      {0, 0, 2, 0, 0},
    },
  },
  [1] = {
    area = {
      {1, 2, 0},
    },
  },
}


spell3.combats = {}
for _, config in ipairs(spell3.config) do
  local combat = Combat()
  combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
  combat:setParameter(COMBAT_PARAM_EFFECT, 7)
  combat:setArea(createCombatArea(config.area))
  function onGetFormulaValues(player, skill, attack, factor)
    local min = ((player:getLevel() + 3) * 1.7)
    local max = ((player:getLevel() + 5) * 1.9)
    return -min, -max
  end
  combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
  table.insert(spell3.combats, combat)
end


function onCastSpell(player, var)
  local cid = player:getId()
  doSendAnimatedText("Wave", getThingPos(cid), TEXTCOLOR_ORANGE)
  local whip =  getPlayerStorageValue(cid, storage.fire_whip)

  if player:canMove() == true then
    noMove(cid, 0.6, 2)
  end
  if whip == 3 then
    for n = 1, #spell2.combats do
      addEvent(doCombat, (n * 80), cid, spell2.combats[n], var)
    end
    setPlayerStorageValue(cid, storage.fire_whip, 1)
  elseif whip == 4 then
    for n = 1, #spell3.combats do
      addEvent(doCombat, (n * 80), cid, spell3.combats[n], var)
    end
    setPlayerStorageValue(cid, storage.fire_whip, 1)
  else
    for n = 1, #spell.combats do
      addEvent(doCombat, (n * 80), cid, spell.combats[n], var)
    end

  end
  return true
end