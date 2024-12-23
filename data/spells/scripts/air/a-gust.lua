local spell = {}

spell.config = {
    [6] = {
        area = {{0, 1, 1, 1, 1, 1, 1, 1, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0},
                {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 2, 0, 0, 0, 0}}
    },

    [5] = {
        area = {{0, 1, 1, 1, 1, 1, 1, 1, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0},
                {0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 2, 0, 0, 0, 0}}
    },
    [4] = {
        area = {{1, 1, 1, 1, 1}, {0, 0, 0, 0, 0}, {0, 0, 0, 0, 0}, {0, 0, 2, 0, 0}}
    },
    [3] = {
        area = {{1, 1, 1, 1, 1}, {0, 0, 0, 0, 0}, {0, 0, 2, 0, 0}}
    },
    [2] = {
        area = {{1, 1, 1}, {0, 2, 0}}
    },
    [1] = {
        area = {{1, 3, 1}}
    }
}

spell.combats = {}
local targets = {}

for _, config in ipairs(spell.config) do
    local combat = Combat()
    combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
    combat:setParameter(COMBAT_PARAM_EFFECT, 3)
    combat:setArea(createCombatArea(config.area))
    function onGetFormulaValues(player, skill, attack, factor)
        local min = ((player:getLevel() + bender_attack['air_gust'].min) * bender_attack['air_gust'].min_mult) / 2
        local max = ((player:getLevel() + bender_attack['air_gust'].max) * bender_attack['air_gust'].max_mult) / 2
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
    if not isCreature(cid) or not targets[cid] or isNpc(cid) then
        return false
    end
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
    if not player then
        return false
    end
    local cid = player:getId()
    targets[cid] = {}
    -- doSendAnimatedText("Gust", getThingPos(cid), TEXTCOLOR_AIR)
    if player:canMove() == true then
        noMove(cid, 0.4, 3)
      end
    for n = 1, #spell.combats do
        addEvent(doCombat, (n * 100), cid, spell.combats[n], var)
        addEvent(moveTargets, n * 100 + 5, cid)
    end
    addEvent(cleanTargets, #spell.combats * 100 + 30, cid)
    return true
end
