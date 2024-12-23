local spell = {}

spell.config = {
  [1] = {
    area = {
      [1] = {
        {0, 2, 1},
      },
      [2] = {
        {0, 3, 0},
      },

      [3] = {
        {1, 2, 0},
      },
    },
  },
  [2] ={
    area = {
      [1] = {
        {1, 2, 0},
      },
      [2] = {
        {0, 3, 0},
      },

      [3] = {
        {0, 2, 1},
      },
    },
  },
  [3] ={
    area = {
      [1] = {
        {0, 2, 0},
        {0, 0, 0},
        {0, 0, 1}
      },
      [2] = {
        {0, 2, 0},
        {0, 0, 1}
      },

      [3] = {
        {0, 2, 1},
      },

      [4] = {
        {0, 3, 0},
      },
      [5] = {
        {1, 2, 0},

      },
    },
  },
  [4] ={
    area = {
      [1] = {
        {0, 2, 0},
        {0, 0, 0},
        {1, 0, 0}
      },
      [2] = {
        {0, 2, 0},
        {1, 0, 0}
      },

      [3] = {
        {1, 2, 0},
      },

      [4] = {
        {0, 3, 0},
      },
      [5] = {
        {0, 2, 1},

      },
    },
  },
  [5] ={
    area = {
      [1] = {
        {0, 3, 0},
      },
      [2] = {
        {0, 2, 1},
      },

      [3] = {
        {0, 2, 0},
        {0, 0, 1}
      },
      [4] = {
        {0, 2, 0},
        {0, 0, 0},
        {0, 0, 1}
      },
      [5] = {
        {0, 2, 0},
        {0, 0, 0},
        {0, 1, 0}
      },
      [6] = {
        {0, 2, 0},
        {0, 0, 0},
        {1, 0, 0}
      },

      [7] = {
        {0, 2, 0},
        {1, 0, 0},
        {0, 0, 0}
      },

      [8] = {
        {1, 2, 0},
        {0, 0, 0},
        {0, 0, 0}
      },
    },
  },
}

spell.combats = {}
for i, config in ipairs(spell.config) do
  table.insert(spell.combats, {})
  for j, area in ipairs(config.area) do
    local combat = Combat()
    combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
    combat:setParameter(COMBAT_PARAM_EFFECT, 11)
    combat:setArea(createCombatArea(area))
    function onGetFormulaValues(player, skill, attack, factor)
      local min = ((player:getLevel() + bender_attack['water_whip'].min) * bender_attack['water_whip'].min_mult)
      local max = ((player:getLevel() + bender_attack['water_whip'].max) * bender_attack['water_whip'].max_mult)
      return -min, -max
    end
    combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
    table.insert(spell.combats[i], combat)
  end
end


function onCastSpell(player, var)
  if not player then return false end
  local cid = player:getId()

  if not hasWater(cid, 1) then
    return false
  end

  local whip =  getPlayerStorageValue(cid, storage.water_whip)
  local time = getPlayerStorageValue(cid, storage.water_whip_time1)
  local time2 = getPlayerStorageValue(cid, storage.water_whip_time2)

  if whip < 1 then
    whip = 1
  end
  for i = 1, #spell.combats[whip] do
    addEvent(doCombat, (i * 100), cid, spell.combats[whip][i], var)
  end
  if player:canMove() == true then
    noMove(cid, 0.5, 2)
  end
  doSendAnimatedText("Whip", getThingPos(cid), TEXTCOLOR_WATER)
  if whip > 1 and os.clock() - time - (time2/1000) > 1 then whip = 1 end
  setPlayerStorageValue(cid, storage.water_whip, whip%5+1)
  setPlayerStorageValue(cid, storage.water_whip_time1, math.floor(os.clock()))
  setPlayerStorageValue(cid, storage.water_whip_time2, (os.clock() - math.floor(os.clock())) * 2000)
  return true
end