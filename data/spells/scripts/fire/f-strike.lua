local spell = {}

spell.config = {
    [1] = {
        area = {
		      {1, 1, 1},
		      {1, 2, 1},
		      {1, 1, 1}
        },
    },
}

spell.combats = {}
for _, config in ipairs(spell.config) do
  local combat = Combat()
  combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
  combat:setArea(createCombatArea(config.area))
  function onTargetCreature(creature, target)
		doSendMagicEffect(target:getPosition(), 16)
	end

  function onGetFormulaValues(player, skill, attack, factor)
    local min = ((player:getLevel() + bender_attack['fire_strike'].min) * bender_attack['fire_strike'].min_mult)
    local max = ((player:getLevel() + bender_attack['fire_strike'].max) * bender_attack['fire_strike'].max_mult)
    return -min, -max
  end
  combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")  
  combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
  table.insert(spell.combats, combat)
end

local function doStrike(cid, var, time)
  if not isPlayer(cid) then return true end
	if time > 0 then
		doCombat(cid, spell.combats[1], positionToVariant(getThingPos(cid)))
		doSendMagicEffect(getThingPos(cid), 114)
	end
	addEvent(doStrike, 1000, cid, positionToVariant(getThingPos(cid)), time-1)
end

function onCastSpell(player, var)
  if not player then return false end
  local cid = player:getId()
  if(player:getStorageValue(storage.fire_strike_exhausted) > os.time() and player:getStorageValue(storage.fire_strike_exhausted) < 100+os.time()) then -- exhausted
    doSendMagicEffect(player:getPosition(), 3)
    player:sendCancelMessage("You are exhausted. Wait " .. player:getStorageValue(storage.fire_strike_exhausted) - os.time() .. ' second' .. ((player:getStorageValue(storage.fire_strike_exhausted) - os.time()) == 1 and "" or "s"))
    return false    
  end 

  doSendAnimatedText("Strike", player:getPosition(), TEXTCOLOR_ORANGE)
  doStrike(cid, positionToVariant(getThingPos(cid)), 7)
  player:setStorageValue(storage.fire_strike_exhausted, os.time() + 16)
  return true
end