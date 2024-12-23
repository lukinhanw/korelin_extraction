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
  combat:setParameter(COMBAT_PARAM_EFFECT, 12)
  combat:setArea(createCombatArea(config.area))
  
  function onTargetCreature(creature, target)
  	if not target then return false end
    local thunderDmg = ((creature:getLevel()/2) * 2)
    if target:isPlayer() then
      thunderDmg = ((creature:getLevel() + 5) * 2.8) * 2.3
    end
    addEvent(function()
    	if isCreature(target:getId()) then
    		doTargetCombatHealth(creature:getId(), target:getId(), COMBAT_PHYSICALDAMAGE, -thunderDmg, -thunderDmg, CONST_ME_NONE)
  		end
  	end, 1000)
  end 
  
  function onGetFormulaValues(player, skill, attack, factor)
    local min = ((player:getLevel() + bender_attack['fire_thunder'].min) * bender_attack['fire_thunder'].min_mult)
    local max = ((player:getLevel() + bender_attack['fire_thunder'].max) * bender_attack['fire_thunder'].max_mult)
    return -min, -max
  end
  
  combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")
  combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
  table.insert(spell.combats, combat)
end


function onCastSpell(player, var)
	if not player then return false end
	local cid = player:getId()
	doSendAnimatedText("Thunder", getThingPos(cid), TEXTCOLOR_RED)	
  if player:canMove() == true then
    noMove(cid, 0.5, 2)
  end
  for n = 1, #spell.combats do
    addEvent(doCombat, (n * 180), cid, spell.combats[n], var)
  end

  return true
end