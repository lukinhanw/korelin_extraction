local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HEALING)
combat:setParameter(COMBAT_PARAM_EFFECT, 73)
combat:setParameter(COMBAT_PARAM_TARGETCASTERORTOPMOST, 1)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)

function onTargetCreature(creature, target)
    doRemoveCondition(target:getId(), CONDITION_POISON)
    doRemoveCondition(target:getId(), CONDITION_FIRE)
    doRemoveCondition(target:getId(), CONDITION_ENERGY)
    doRemoveCondition(target:getId(), CONDITION_DRUNK)
    return true
end

function onGetFormulaValues(player, skill, attack, factor)
  min = 1
  max = 1
  return min, max
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature") 

function onCastSpell(player, var)
    local cid = player:getId()
    if not hasWater(cid, 1) then return true end
    doCombat(cid, combat, var)
    doSendMagicEffect("Purify", getThingPos(cid), TEXTCOLOR_WATER)
    return true
end