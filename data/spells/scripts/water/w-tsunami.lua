local spell = {}

spell.config = {

  [10] = {
    area = {
      {1, 1, 1, 1, 1, 1, 1, 1, 1},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 2, 0, 0, 0, 0},

    },
  },
  [9] = {
    area = {
      {1, 1, 1, 1, 1, 1, 1, 1, 1},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 2, 0, 0, 0, 0},

    },
  },
  [8] = {
    area = {
      {1, 1, 1, 1, 1, 1, 1, 1, 1},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 2, 0, 0, 0, 0},

    },
  },
  [7] = {
    area = {
      {1, 1, 1, 1, 1, 1, 1, 1, 1},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 2, 0, 0, 0, 0},

    },
  },
  [6] = {
    area = {
      {1, 1, 1, 1, 1, 1, 1, 1, 1},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 2, 0, 0, 0, 0},

    },
  },
  [5] = {
    area = {
      {1, 1, 1, 1, 1, 1, 1},
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 2, 0, 0, 0},
    },
  },
  [4] = {
    area = {
      {1, 1, 1, 1, 1},
      {0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0},
      {0, 0, 2, 0, 0},
    },
  },
  [3] = {
    area = {
      {1, 1, 1, 1, 1},
      {0, 0, 0, 0, 0},
      {0, 0, 2, 0, 0},
    },
  },
  [2] = {
    area = {
      {1, 1, 1},
      {0, 2, 0}
    },
  },

  [1] = {
    area = {
      {1, 3, 1},
    },
  },
}

spell.combats = {}
for _, config in ipairs(spell.config) do
  local combat = Combat()
  combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
  combat:setParameter(COMBAT_PARAM_EFFECT, 54)
  combat:setArea(createCombatArea(config.area))
  function onGetFormulaValues(player, skill, attack, factor)
    local min = ((player:getLevel() + bender_attack['water_tsunami'].min) * bender_attack['water_tsunami'].min_mult)
    local max = ((player:getLevel() + bender_attack['water_tsunami'].max) * bender_attack['water_tsunami'].max_mult)
    return -min, -max
  end
  function onTargetCreature(creature, target)
    moveCreature(creature:getId(), target:getId(), getPlayerLookDir(creature:getId()))
  end

  combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")

  combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
  table.insert(spell.combats, combat)
end



function onCastSpell(player, var)
  local cid = player:getId()
  if not hasWater(cid, 110) then
    doPlayerSendCancel(cid, "Essa dobrar requer uma grande quantidade de agua, vá para pertos de rios ou mares")
    return true
  end
  doSendAnimatedText("Tsunami", getThingPos(cid), TEXTCOLOR_WATER)
  if player:canMove() == true then
    noMove(cid, 1, 2)
  end
  for n = 1, #spell.combats do
    addEvent(doCombat, (n * 100), cid, spell.combats[n], var)
  end
  return true
end