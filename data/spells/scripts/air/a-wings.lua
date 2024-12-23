local spell1 = {}
local spell2 = {}

spell1.config = {
  [1] = {
    area = {
      {1, 0, 0, 0, 0, 0, 0, 0, 1},
      {1, 0, 0, 0, 0, 0, 0, 0, 1},
      {1, 0, 0, 0, 2, 0, 0, 0, 1},
      {1, 0, 0, 0, 0, 0, 0, 0, 1},
      {1, 0, 0, 0, 0, 0, 0, 0, 1},
      {1, 0, 0, 0, 0, 0, 0, 0, 1},
      {1, 0, 0, 0, 0, 0, 0, 0, 1}
    },
  },
  [2] = {
    area = {
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 1, 0, 0, 0, 0, 0, 1, 0},
      {0, 1, 0, 0, 2, 0, 0, 1, 0},
      {0, 1, 0, 0, 0, 0, 0, 1, 0},
      {0, 1, 0, 0, 0, 0, 0, 1, 0},
      {0, 1, 0, 0, 0, 0, 0, 1, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0}
    },
  },
  [3] = {
    area = {
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 1, 0, 2, 0, 1, 0, 0},
      {0, 0, 1, 0, 0, 0, 1, 0, 0},
      {0, 0, 1, 0, 0, 0, 1, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0}

    },
  },
  [4] = {
    area = {
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 1, 2, 1, 0, 0, 0},
      {0, 0, 0, 1, 0, 1, 0, 0, 0},
      {0, 0, 0, 1, 0, 1, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0}

    },
  },
}

spell2.config ={
  [1] = {
    area = {

      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 2, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 1, 1, 1, 0, 0, 0}
    },
  },
  [2] = {
    area = {
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 2, 0, 0, 0, 0},
      {0, 0, 0, 1, 1, 1, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0}
    },
  },
  [3] = {
    area = {

      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 1, 3, 1, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0}
    },
  },
  [4] = {
    area = {
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 1, 1, 1, 1, 1, 0, 0},
      {0, 0, 0, 0, 2, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0}
    },
  },
  [5] = {
    area = {

      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 1, 1, 1, 1, 1, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 2, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0}
    },
  },

  [6] = {
    area = {
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 1, 1, 1, 1, 1, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 2, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0}
    },
  },

  [7] = {
    area = {
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 1, 1, 1, 1, 1, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 2, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0}
    },
  },

  [8] = {
    area = {
      {0, 0, 1, 1, 1, 1, 1, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 2, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0}
    },
  },
}

spell1.combats = {}
spell2.combats = {}
for _, config in ipairs(spell1.config) do
  local combat = Combat()
  combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
  combat:setParameter(COMBAT_PARAM_EFFECT, 3)
  combat:setArea(createCombatArea(config.area))
  function onGetFormulaValues(player, skill, attack, factor)
    local min = ((player:getLevel() + bender_attack['air_wings'].min) * bender_attack['air_wings'].min_mult) / 2
    local max = ((player:getLevel() + bender_attack['air_ball'].max) * bender_attack['air_wings'].max_mult) / 2
    return -min, -max
  end

  function onTargetCreature(creature, target)
    moveCreature(creature:getId(), target:getId(), getPushDir(target:getId(), creature:getId()))
  end

  combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")
  combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
  table.insert(spell1.combats, combat)
end


for _, config in ipairs(spell2.config) do
  local combat2 = Combat()
  combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
  combat2:setParameter(COMBAT_PARAM_EFFECT, 3)
  combat2:setArea(createCombatArea(config.area))
  function onGetFormulaValues(player, skill, attack, factor)
    local min = ((player:getLevel() + bender_attack['air_wings'].min) * bender_attack['air_wings'].min_mult) / 2
    local max = ((player:getLevel() + bender_attack['air_ball'].max) * bender_attack['air_wings'].max_mult) / 2
    return -min, -max
  end

  function onTargetCreature(creature, target)
    moveCreature(creature:getId(), target:getId(), getPlayerLookDir(creature:getId()))
  end

  combat2:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")
  combat2:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
  table.insert(spell2.combats, combat2)
end


function onCastSpell(player, var)
  if not player then return false end
  local cid = player:getId()
  for n = 1, #spell1.combats do
    addEvent(doCombat, (n * 80), cid, spell1.combats[n], var)

  end
  for i = 1, #spell2.combats do
    addEvent(doCombat, 400 + (i * 80), cid, spell2.combats[i], var)
  end
  if player:canMove() == true then
    noMove(cid, 0.6, 3)
  end
  doSendAnimatedText("Wings", getThingPos(cid), TEXTCOLOR_AIR)
  return true
end