local spell = {}

spell.config = {
  [10] = {
      multMin = 8.0,
      multMax = 7.5,
      area = {
        {1, 1, 1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1, 1, 1},
        {0, 1, 1, 1, 1, 1, 1, 1, 0},
        {0, 1, 1, 1, 1, 1, 1, 1, 0},
        {0, 0, 1, 1, 1, 1, 1, 0, 0},
        {0, 0, 1, 1, 1, 1, 1, 0, 0},
        {0, 0, 0, 1, 3, 1, 0, 0, 0}
    },
  },

  [9] = {

      multMin = 7.0,
      multMax = 6.5,
      area = {
        {1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1},
        {0, 1, 1, 1, 1, 1, 0},
        {0, 1, 1, 1, 1, 1, 0},
        {0, 0, 1, 1, 1, 0, 0},
        {0, 0, 1, 1, 1, 0, 0},
        {0, 0, 0, 3, 0, 0, 0}
      },
  },

  [8] = {

      multMin = 6.0,
      multMax = 5.5,
      area = {
        {1, 1, 1, 1, 1, 1, 1},
        {0, 1, 1, 1, 1, 1, 0},
        {0, 1, 1, 1, 1, 1, 0},
        {0, 0, 1, 1, 1, 0, 0},
        {0, 0, 1, 1, 1, 0, 0},
        {0, 0, 1, 1, 1, 0, 0},
        {0, 0, 0, 3, 0, 0, 0}
     },
  },

  [7] = {

      multMin = 3.2,
      multMax = 2.9,
      area = {
        {1, 1, 1, 1, 1},
        {1, 1, 1, 1, 1},
        {0, 1, 1, 1, 0},
        {0, 1, 1, 1, 0},
        {0, 0, 3, 0, 0}
     },
  },

  [6] = {

      multMin = 3.2,
      multMax = 2.9,
      area = {
        {1, 1, 1, 1, 1},
        {0, 1, 1, 1, 0},
        {0, 1, 1, 1, 0},
        {0, 1, 1, 1, 0},
        {0, 0, 3, 0, 0}
      },
  },

  [5] = {

      multMin = 1.9,
      multMax = 1.5,
      area = {
        {1, 1, 1},
        {1, 1, 1},
        {1, 1, 1},
        {0, 3, 0}
      },
  },

  [4] = {

      multMin = 1.7,
      multMax = 1.3,
      area = {
        {1, 1, 1},
        {1, 1, 1},
        {0, 3, 0}
      },
  },
  [3] = {

      multMin = 1.2,
      multMax = 0.9,
      area = {
        {1, 1, 1},
        {1, 3, 1}
      },
  },
  [2] = {

      multMin = 1.0,
      multMax = 0.8,
      area = {
        {1, 3, 1}
      },
  },
  [1] = {

      multMin = 1.0,
      multMax = 0.7,
    area = {
    {0, 3, 0}
    },
  },
}

spell.combats = {}
charge_timing = {20, 40, 80, 160, 280, 320, 360, 600, 640, 680}
for _, config in ipairs(spell.config) do
  local combat = Combat()
  combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
  combat:setParameter(COMBAT_PARAM_EFFECT, 7)
  combat:setArea(createCombatArea(config.area))

  function onGetFormulaValues(player, skill, attack, factor)

    local min = ((player:getLevel() + bender_attack['fire_charge'].min) * config.multMin)
    local max = ((player:getLevel() + bender_attack['fire_charge'].max) * config.multMax)
    return -min, -max
  end
  
  combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
  table.insert(spell.combats, combat)
end

function onCastSpell(player, var)
	if not player then return false end
	local position = player:getPosition()
	local cid = player:getId()
	doSendAnimatedText("Charge", getThingPos(cid), TEXTCOLOR_ORANGE)
    local time = getPlayerStorageValue(cid, storage.charge_time)
    
    local a = math.floor(os.time() - time)
    local b = 1
    
    while a > charge_timing[b] and b < 10 do
        b=b+1
    end
    if player:canMove() == true then
      noMove(cid, 0.5, 2)
    end
    doCombat(cid, spell.combats[b], var)
    setPlayerStorageValue(cid, storage.charge_time, os.time())

  return true
end