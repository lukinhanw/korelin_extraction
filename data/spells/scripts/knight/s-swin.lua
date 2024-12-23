local spell = {}

spell.config = {
    [1] = {
        area = {
            [1] = {
                {0, 2, 1},
            },
            [2] = {
              {0, 3, 0},
            },
        
            [3] = {
              {1, 2, 0},
            },
        },
    },
    [2] ={
        area = {
            [1] = {
              {1, 2, 0},
            },
            [2] = {
              {0, 3, 0},
            },
        
            [3] = {
              {0, 2, 1},
            },
        },
    },
}

spell.combats = {}
for i, config in ipairs(spell.config) do
    table.insert(spell.combats, {})
    for j, area in ipairs(config.area) do
        local combat = Combat()
        combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
        combat:setParameter(COMBAT_PARAM_EFFECT, 4)
        combat:setArea(createCombatArea(area))

        function onGetFormulaValues(player, skill, attack, factor)

          local min = (player:getLevel() / 5) + (skill * attack * 0.01) + 5
          local max = (player:getLevel() / 5) + (skill * attack * 0.04) + 8
          return -min, -max
        end
        combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
        table.insert(spell.combats[i], combat)
    end
end


function onCastSpell(player, var)
  if not player then return false end
  local cid = player:getId()
  local swin =  getPlayerStorageValue(cid, storage.sword_swin)
  local time = getPlayerStorageValue(cid, storage.sword_swin_time1)
  local time2 = getPlayerStorageValue(cid, storage.sword_swin_time2)
  
  if swin < 1 then 
    swin = 1 
  end

  for i = 1, 3 do
    addEvent(doCombat, (i * 200), cid, spell.combats[swin][i], var)
  end
  if player:canMove() == true then
    noMove(cid, 0.5, 2)
  end
  doSendAnimatedText("Swin", getThingPos(cid), TEXTCOLOR_RED)
  if swin > 1 and os.clock() - time - (time2/1000) > 1 then swin = 1 end
  setPlayerStorageValue(cid, storage.sword_swin, swin%2+1)
  setPlayerStorageValue(cid, storage.sword_swin_time1, math.floor(os.clock()))
  setPlayerStorageValue(cid, storage.sword_swin_time2, (os.clock() - math.floor(os.clock())) * 900)
    return true
end