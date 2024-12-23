local spell ={}

spell.config = {
  [1] = {
    area = {
      {0, 3, 0},

    },
  },
  [2] = {
    area = {
      {0, 1, 0},
      {0, 2, 0},

    },
  },

  [3] = {
    area = {
      {0, 1, 0},
      {0, 0, 0},
      {0, 2, 0},
    },
  },
  [4] = {
    area = {
      {0, 1 ,0},
      {0, 0, 0},
      {0, 0, 0},
      {0, 2, 0},
    },
  },
  [5] = {
    area = {
      {0, 1, 0},
      {0, 0 ,0},
      {0, 0, 0},
      {0, 0, 0},
      {0, 2, 0},
    },
  },
  [6] = {
    area = {
      {0, 1, 0},
      {0, 0 ,0},
      {0, 0 ,0},
      {0, 0, 0},
      {0, 0, 0},
      {0, 2, 0},
    },
  },

}

spell.combats = {}
local condition = Condition(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 8500)
condition:setFormula(-0.9, 0, -0.9, 0)

for _, config in ipairs(spell.config) do
  local combat = Combat()
  combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
  combat:setParameter(COMBAT_PARAM_EFFECT, 44)
  combat:setArea(createCombatArea(config.area))
  combat:addCondition(condition) 
  
  function onGetFormulaValues(player, skill, attack, factor)
    local min = ((player:getLevel() + bender_attack['water_icebeam'].min) * bender_attack['water_icebeam'].min_mult)
    local max = ((player:getLevel() + bender_attack['water_icebeam'].max) * bender_attack['water_icebeam'].max_mult)
    return -min, -max
  end

  combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
  table.insert(spell.combats, combat)
end

function onCastSpell(player, var)
  if not player then return false end
  local cid = player:getId()
  if not hasWater(cid, 3) then return true end
  doSendAnimatedText("Icebeam", getThingPos(cid), TEXTCOLOR_WATER)
  if player:canMove() == true then
    noMove(cid, 0.5, 2)
  end
  for n = 1, #spell.combats do
    addEvent(doCombat, (n * 110), cid, spell.combats[n], var)
  end
  return true
end