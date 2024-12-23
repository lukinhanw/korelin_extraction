local spell = {}

spell.config = {
  [9] = {
    area = {
      {0, 2, 1},
      {0, 0, 0},
      {0, 0, 0},
    }
  },
  [8] = {
    area = {
      {0, 2, 0},
      {0, 0, 1},
      {0, 0, 0},
    }
  },

  [7] = {
    area = {
      {0, 2, 0},
      {0, 0, 0},
      {0, 0, 1},
    },
  },
  [6] = {
    area ={
      {0, 2, 0},
      {0, 0, 0},
      {0, 1, 0},
    },
  },
 
  [5] = {
    area = {
      {0, 2, 0},
      {0, 0, 0},
      {1, 0, 0},
    },
  },
  [4] = {
    area = {
      {0, 2, 0},
      {1, 0, 0},
    },
  },
  [3] = {
    area = {
      {1, 2, 0},
    },
  },
  [2] = {
    area = {
      {0, 3, 0},
    },
  },
  [1] = {
    area = {
      {0, 2, 1},
    },
  },
}

spell.combats = {}
for _, config in ipairs(spell.config) do
  local combat = Combat()
  combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
  combat:setParameter(COMBAT_PARAM_EFFECT, 4)
  combat:setArea(createCombatArea(config.area))
  function onGetFormulaValues(player, skill, attack, factor)
    local min = (player:getLevel() / 5) + (skill * attack * 0.03) + 7
    local max = (player:getLevel() / 5) + (skill * attack * 0.05) + 11
    return -min, -max
  end

  combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
  table.insert(spell.combats, combat)
end


function onCastSpell(player, var)
  if not player then return false end
  local cid = player:getId()
    
  for i = 1, #spell.combats do
    addEvent(doCombat, (i * 50), cid, spell.combats[i], var)
  end
  if player:canMove() == true then
    noMove(cid, 0.05, 9)
  end
  doSendAnimatedText("Spin", getThingPos(cid), TEXTCOLOR_RED)
  return true
end