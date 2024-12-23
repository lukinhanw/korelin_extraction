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
condition:setParameter(CONDITION_PARAM_TICKS, 4000)
condition:setFormula(-1.1, 0, -1.1, 0)

for _, config in ipairs(spell.config) do
  local combat = Combat()
  combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
  combat:setParameter(COMBAT_PARAM_EFFECT, 2)
  combat:setArea(createCombatArea(config.area))
  combat:addCondition(condition) 
  
  table.insert(spell.combats, combat)
end



local spell2 ={}

spell2.config = {
  [1] = {
    area = {
      {0, 2, 1},

    },
  },
  [2] = {
    area = {
      {0, 0, 0, 0, 1},
      {0, 0, 2, 0, 0},

    },
  },

  [3] = {
    area = {
      {0, 0, 0, 0, 0, 0, 1},
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 2, 0, 0, 0},
    },
  },
  [4] = {
    area = {
      {0, 0, 0, 0, 0, 0, 0, 0, 1},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 2, 0, 0, 0, 0},
    },
  },
  [5] = {
    area = {
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
      {0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0},
    },
  },

}

spell2.combats = {}

for _, config in ipairs(spell2.config) do
  local combat = Combat()
  combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
  combat:setParameter(COMBAT_PARAM_EFFECT, 2)
  combat:setArea(createCombatArea(config.area))
  combat:addCondition(condition) 
  
  table.insert(spell2.combats, combat)
end


local spell3 ={}

spell3.config = {
  [1] = {
    area = {
      {1, 2, 0},

    },
  },
  [2] = {
    area = {
      {1, 0, 0, 0, 0},
      {0, 0, 2, 0, 0},

    },
  },

  [3] = {
    area = {
      {1, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 2, 0, 0, 0},
    },
  },
  [4] = {
    area = {
      {1, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 2, 0, 0, 0, 0},
    },
  },
  [5] = {
    area = {
      {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0},
    },
  },

}

spell3.combats = {}

for _, config in ipairs(spell3.config) do
  local combat = Combat()
  combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
  combat:setParameter(COMBAT_PARAM_EFFECT, 2)
  combat:setArea(createCombatArea(config.area))
  combat:addCondition(condition) 
  
  table.insert(spell3.combats, combat)
end

function onCastSpell(creature, var)
  local cid = creature:getId()
  local target = getCreatureTarget(cid)
  doSendAnimatedText("Icebeam", getThingPos(cid), TEXTCOLOR_WATER)
  if target > 1 then
    if getThingPos(cid).y > getThingPos(target).y then   
      if creature:getDirection() == 3 then
        for n = 1, #spell2.combats do
          addEvent(doCombat, (n * 110), cid, spell2.combats[n], var)  
        end
      elseif creature:getDirection() == 1 then
        for n = 1, #spell3.combats do
          addEvent(doCombat, (n * 110), cid, spell3.combats[n], var)  
        end
      else
        for n = 1, #spell.combats do
          addEvent(doCombat, (n * 110), cid, spell.combats[n], var)  
        end
      end
    else
      for n = 1, #spell.combats do
        addEvent(doCombat, (n * 110), cid, spell.combats[n], var)  
      end
    end
  else 
    for n = 1, #spell.combats do
      addEvent(doCombat, (n * 110), cid, spell.combats[n], var)  
    end

  end

  return true
end