local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 37)
combat:setParameter(COMBAT_PARAM_EFFECT, 26)

function onGetFormulaValues(player, skill, attack, factor)
    local min = ((player:getLevel() + bender_attack['water_bubble'].min) *
                    bender_attack['water_bubble'].min_mult)
    local max = ((player:getLevel() + bender_attack['water_bubble'].max) *
                    bender_attack['water_bubble'].max_mult)
    return -min, -max
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local function bubbleCharge(cid, target, i, n, equals, var)
    if not isCreature(cid) or not isCreature(target) or n <= 0 then
        return false
    end
    if i == equals then
        for v = 1, 12 do
            addEvent(function()
                if isCreature(target) then
                    doCombat(cid, combat, var)
                end
            end, 150 * v)
        end
        return true
    end

    local pos = getThingPos(target)

    local area = {
        {x = pos.x + 1, y = pos.y + 1, z = pos.z},
        {x = pos.x + 1, y = pos.y, z = pos.z},
        {x = pos.x + 1, y = pos.y - 1, z = pos.z},
        {x = pos.x, y = pos.y - 1, z = pos.z},
        {x = pos.x - 1, y = pos.y - 1, z = pos.z},
        {x = pos.x - 1, y = pos.y, z = pos.z},
        {x = pos.x - 1, y = pos.y + 1, z = pos.z},
        {x = pos.x, y = pos.y + 1, z = pos.z},
        {x = pos.x + 1, y = pos.y + 1, z = pos.z},
        {x = pos.x + 1, y = pos.y, z = pos.z},
        {x = pos.x + 1, y = pos.y - 1, z = pos.z},
        {x = pos.x, y = pos.y - 1, z = pos.z}

    }
    local area2 = {
        {x = pos.x - 1, y = pos.y - 1, z = pos.z},
        {x = pos.x - 1, y = pos.y, z = pos.z},
        {x = pos.x - 1, y = pos.y + 1, z = pos.z},
        {x = pos.x, y = pos.y + 1, z = pos.z},
        {x = pos.x + 1, y = pos.y + 1, z = pos.z},
        {x = pos.x + 1, y = pos.y, z = pos.z},
        {x = pos.x + 1, y = pos.y - 1, z = pos.z},
        {x = pos.x, y = pos.y - 1, z = pos.z},
        {x = pos.x - 1, y = pos.y - 1, z = pos.z},
        {x = pos.x - 1, y = pos.y, z = pos.z},
        {x = pos.x - 1, y = pos.y + 1, z = pos.z},
        {x = pos.x, y = pos.y + 1, z = pos.z}

    }
    -- doSendMagicEffect(area[(i % #area)], 40)
    -- doSendMagicEffect(area2[(i % #area2)], 40)

    addEvent(bubbleCharge, 150, cid, target, i + 1, n - 1, equals, var)
end

function onCastSpell(player, var)
    if not player then return false end

    local cid = player:getId()

    if not hasWater(cid, 3) then return true end
    local target = getCreatureTarget(cid)
    if target > 1 then
        if player:canMove() == true then noMove(cid, 1, 2) end
        doSendAnimatedText("Bubble", getThingPos(cid), TEXTCOLOR_WATER)
		doSendMagicEffect(getThingPos(cid), 107)
        bubbleCharge(cid, target, 1, 12, 12, var)
    end
    return true
end
