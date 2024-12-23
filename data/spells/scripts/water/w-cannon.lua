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
local targets = {}

for _, config in ipairs(spell.config) do
  local combat = Combat()
  combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
  combat:setParameter(COMBAT_PARAM_EFFECT, 11)
  combat:setArea(createCombatArea(config.area))
  function onGetFormulaValues(player, skill, attack, factor)
    local min = ((player:getLevel() + bender_attack['water_cannon'].min) * bender_attack['water_cannon'].min_mult) /2
    local max = ((player:getLevel() + bender_attack['water_cannon'].max) * bender_attack['water_cannon'].max_mult) /2
    return -min, -max
  end

  function onTargetCreature(creature, target)
    if not isInArray(targets[creature:getId()], target:getId()) then
      table.insert(targets[creature:getId()], target:getId())
    end
  end

  combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")
  combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
  table.insert(spell.combats, combat)
end

local function moveTargets(cid)
  if not isCreature(cid) or not targets[cid] or isNpc(cid) then return false end
  for i = 1, #targets[cid] do
    if isCreature(targets[cid][i]) then
      moveCreature(cid, targets[cid][i], getPlayerLookDir(cid))
    end
  end
end

local function cleanTargets(cid)
  targets[cid] = {}
end

function onCastSpell(player, var)
  if not player then return false end
  local cid = player:getId()
  if not hasWater(cid, 3) then return true end
  targets[cid] = {}
  doSendAnimatedText("Cannon", getThingPos(cid), TEXTCOLOR_WATER)
  
  if player:canMove() == true then
    noMove(cid, 0.5, 2)
  end
  
  for n = 1, #spell.combats do
    addEvent(doCombat, (n * 110), cid, spell.combats[n], var)
    addEvent(moveTargets, n*110+5, cid)
  end
  addEvent(cleanTargets, #spell.combats*110+5, cid)
  return true
end