local spell = {}

spell.config = {
  [3] = {
      area = {
        {0, 1, 0},
        {0, 0, 0},
        {0, 0, 0},
        {0, 0, 0},
        {0, 2, 0},
      },
  },
  [2] = {
      area = {
        {0, 1, 0},
        {0, 1, 0},
        {0, 0, 0},
        {0, 2, 0},
      },
  },
  [1] = {
      area = {
        {0, 1, 0},
        {0, 3, 0},
    },
  },
}


spell.combats = {}
for _, config in ipairs(spell.config) do
  local combat = Combat()
  combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
  combat:setParameter(COMBAT_PARAM_EFFECT, 21)
  combat:setArea(createCombatArea(config.area))
  
  function onTargetCreature(creature, target)
    local condition = Condition(CONDITION_POISON)
    condition:setParameter(CONDITION_PARAM_DELAYED, true)
    condition:addDamage(4, 5000, (creature:getLevel()/2))
    
    target:addCondition(condition)
 
  end 
  
  function onGetFormulaValues(player, skill, attack, factor)
    local min = ((player:getLevel() + bender_attack['water_fang'].min) * bender_attack['water_fang'].min_mult)
    local max = ((player:getLevel() + bender_attack['water_fang'].max) * bender_attack['water_fang'].max_mult)
    return -min, -max
  end
  
  combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")
  combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
  table.insert(spell.combats, combat)
end


function onCastSpell(player, var)
	if not player then return false end
	local cid = player:getId()
  if not hasWater(cid, 2) then return true end
	doSendAnimatedText("Fang", getThingPos(cid), TEXTCOLOR_WATER)	
  if player:canMove() == true then
    noMove(cid, 0.5, 2)
  end
  for n = 1, #spell.combats do
    addEvent(doCombat, (n * 130), cid, spell.combats[n], var)
  end

  return true
end