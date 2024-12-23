local spell = {}

spell.config = {
  [9] = {
    area = {
      {0, 0, 0, 1, 0, 0, 0},
      {0, 0, 0, 1, 0, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 3, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 0, 1, 0, 0, 0},
      {0, 0, 0, 1, 0, 0, 0}
    },
  },  


  [8] = {
    area = {
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0},
      {0, 1, 1, 1, 1, 0, 0},
      {0, 0, 1, 3, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 0, 0, 0, 1, 0},
      {0, 0, 0, 0, 0, 0, 0}
    },
  },  

  [7] = {
    area = {
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {1, 1, 1, 3, 1, 1, 1},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0}
    },
  },  
  [6] = { 
    area = {
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 1, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 3, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 1, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0}
    },
  },

  [5] = {
    area = {
      {0, 0, 0, 1, 0, 0, 0},
      {0, 0, 0, 1, 0, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 3, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 0, 1, 0, 0, 0},
      {0, 0, 0, 1, 0, 0, 0}
    },
  },
  [4] = {
    area = {
      {0, 0, 0, 0, 0, 0, 0},
      {0, 1, 0, 0, 0, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 3, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 0, 0, 0, 1, 0},
      {0, 0, 0, 0, 0, 0, 0}
    },
  },
  [3] = {
    area = {
      {0, 0, 0, 0, 0, 0, 0},
      {0, 1, 0, 0, 0, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 3, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 0, 0, 0, 1, 0},
      {0, 0, 0, 0, 0, 0, 0}
   },
  },
  [2] = {
    area = {
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 1, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 3, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 1, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0}
    },
  },
  [1] = {
    area = {
      {0, 0, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 1, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 0, 1, 3, 1, 0, 0},
      {0, 0, 1, 1, 1, 0, 0},
      {0, 1, 0, 0, 0, 0, 0},
      {0, 0, 0, 0, 0, 0, 0}
    },
  },
}
spell.combats = {}
for _, config in ipairs(spell.config) do
  local combat = Combat()
  combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
  combat:setParameter(COMBAT_PARAM_EFFECT, 4)
  combat:setArea(createCombatArea(config.area))
  table.insert(spell.combats, combat)
end


local combat2 = Combat()
combat2:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat2:setParameter(COMBAT_PARAM_EFFECT, 4)

function onGetFormulaValues(player, skill, attack, factor)
  local min = (player:getLevel() / 5) + (skill * attack * 0.01) + 1
  local max = (player:getLevel() / 5) + (skill * attack * 0.03) + 6
  return -min, -max
end

combat2:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")



local function doSlash(cid, target, i, n, equals, var)
  if not isCreature(cid) or not isCreature(target) or n <= 0 then return false end  
  local pos = getThingPos(target)
  if i == equals then
    for n = 1, #spell.combats do
      addEvent(doCombat, n * 220, cid, combat2, var)
      addEvent(doCombat, (n * 220), cid, spell.combats[n], var)
    end
    return true
  end
  local area = {
    {x=pos.x+1, y=pos.y+1, z=pos.z},
    {x=pos.x+1, y=pos.y, z=pos.z},
    {x=pos.x+1, y=pos.y-1, z=pos.z},
    {x=pos.x, y=pos.y-1, z=pos.z},
    {x=pos.x-1, y=pos.y-1, z=pos.z},
    {x=pos.x-1, y=pos.y, z=pos.z},
    {x=pos.x-1, y=pos.y+1, z=pos.z},
    {x=pos.x, y=pos.y+1, z=pos.z},
    {x=pos.x+1, y=pos.y+1, z=pos.z},
    {x=pos.x+1, y=pos.y, z=pos.z},
    {x=pos.x+1, y=pos.y-1, z=pos.z},
    {x=pos.x, y=pos.y-1, z=pos.z},

  }
  local area2 ={
    {x=pos.x-1, y=pos.y-1, z=pos.z},
    {x=pos.x-1, y=pos.y, z=pos.z},
    {x=pos.x-1, y=pos.y+1, z=pos.z},
    {x=pos.x, y=pos.y+1, z=pos.z},
    {x=pos.x+1, y=pos.y+1, z=pos.z},
    {x=pos.x+1, y=pos.y, z=pos.z},
    {x=pos.x+1, y=pos.y-1, z=pos.z},
    {x=pos.x, y=pos.y-1, z=pos.z},
    {x=pos.x-1, y=pos.y-1, z=pos.z},
    {x=pos.x-1, y=pos.y, z=pos.z},
    {x=pos.x-1, y=pos.y+1, z=pos.z},
    {x=pos.x, y=pos.y+1, z=pos.z},

  }
  doSendMagicEffect(area[(i%#area)], 40)
  doSendMagicEffect(area2[(i%#area2)],40)
  addEvent(doSlash, 150, cid, target, i+1, n-1, equals, var)
end

function onCastSpell(player, var)
  local cid = player:getId()
  doSendAnimatedText("Slash", getThingPos(cid), TEXTCOLOR_RED)
  if player:canMove() == true then
    noMove(cid, 0.6, 2)
  end
  doSlash(cid, getCreatureTarget(cid), 1, 12, 12, var)
  return true
end