local spell ={}

spell.config = {
  [1] = {
    area = {
      {0, 0, 1, 1},
      {0, 1, 1, 1},
      {1, 1, 1, 1},
      {0, 0, 0, 2}

    },
  },
  [2] = {
    area = {

      {0, 1, 0, 0},
      {0, 1, 1, 0},
      {0, 1, 1, 1},
      {2, 1, 1, 1}
    },
  },

  [3] = {
    area = {
      {2, 0, 0, 0},
      {1, 1, 1, 1},
      {1, 1, 1, 0},
      {1, 1, 0, 0}
    },
  },
  [4] = {
    area = {
      {1, 1, 1, 2},
      {1, 1, 1, 0},
      {0, 1, 1, 0},
      {0, 0, 1, 0}
    },
  },
}

spell.combats = {}

for _, config in ipairs(spell.config) do
  local combat = Combat()
  combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
  combat:setParameter(COMBAT_PARAM_EFFECT, 26)
  combat:setArea(createCombatArea(config.area))
  function onGetFormulaValues(player, skill, attack, factor)
  local min = ((player:getLevel() + bender_attack['water_clock'].min) * bender_attack['water_clock'].min_mult)
  local max = ((player:getLevel() + bender_attack['water_clock'].max) * bender_attack['water_clock'].max_mult)
    return -min, -max
  end

  combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
  table.insert(spell.combats, combat)
end


function onCastSpell(player, var)
  if not player then return false end
  local cid = player:getId()
  if not hasWater(cid, 4) then return true end
  doSendAnimatedText("Clock", getThingPos(cid), TEXTCOLOR_WATER)
  if player:canMove() == true then
    noMove(cid, 0.5, 3)
  end
  for v = 1, 2 do
    for n = 1, #spell.combats do
      addEvent(doCombat, (v*300) + (n * 110), cid, spell.combats[n], var)
    end
  end
  return true
end