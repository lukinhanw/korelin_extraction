local area = {{0, 1, 0}, {1, 3, 1}, {0, 1, 0}}
local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 7)
combat:setArea(createCombatArea(area))

function onGetFormulaValues(player, skill, attack, factor)
    local min = ((player:getLevel() + bender_attack['fire_meteor'].min) *
                    bender_attack['fire_meteor'].min_mult)
    local max = ((player:getLevel() + bender_attack['fire_meteor'].max) *
                    bender_attack['fire_meteor'].max_mult)
    return -min, -max
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local function doMeteor(cid, time)
    if not isCreature(cid) then return true end
    local playerPos = getThingPos(cid)
    if time > 0 then
        local topPos = {
            x = playerPos.x - (math.random(16, 16)),
            y = playerPos.y - (math.random(16, 16)),
            z = playerPos.z
        }
        local toPos = {
            x = playerPos.x - (math.random(-1, 1)),
            y = playerPos.y - (math.random(-1, 1)),
            z = playerPos.z
        }

        doSendDistanceShoot(topPos, toPos, 4)
        addEvent(doCombat, 350, cid, combat, positionToVariant(toPos))
        addEvent(doMeteor, 350, cid, time - 1)
    end
end

function onCastSpell(player, var)
    if not player then return false end
    local cid = player:getId()
    local playerPos = player:getPosition()

    doSendAnimatedText("Meteor", getThingPos(cid), TEXTCOLOR_ORANGE)

	doSendMagicEffect(getThingPos(cid), 111)
    for i = 1, 7 do
        addEvent(doSendMagicEffect, i * 300, getThingPos(cid), 111)
    end

    addEvent(doMeteor, 2000, cid, 12)
    if player:canMove() == true then noMove(cid, 1, 3) end
    return true
end
