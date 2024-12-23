local spell ={}

spell.config = {
	[1] = {
		area = {
		{1, 0, 0},
		{1, 0, 2},
		{1, 0, 0},
		}
	},
	[2] = {
    	area = {
		{1, 0},
		{1, 0},
		{1, 2},
		}
	},
	[3] = {
		area = {
		{1},
		{1},
		{3},
		}
	},
	[4] = {
		area = {
		{0, 0, 1},
		{0, 0, 1},
		{0, 2, 1},
		}
	},
	[5] = {
		area = {
		{0, 0, 1},
		{2, 0, 1},
		{0, 0, 1},
		}
	},


	[6] = {
		area = {
		{0, 0, 1},
		{2, 0, 1},
		{0, 0, 1},
		}
	},
	[7] = {
		area = {
		{0, 0, 1},
		{0, 0, 1},
		{0, 2, 1},
		}
	},

	[8] = {
		area = {
		{1},
		{1},
		{3},
		}
	},

	[9] = {
    	area = {
		{1, 0},
		{1, 0},
		{1, 2},
		}
	},

	[10] = {
		area = {
		{1, 0, 0},
		{1, 0, 2},
		{1, 0, 0},
		}
	},

}

spell.combats = {}
local targets = {}

for _, config in ipairs(spell.config) do
  local combat = Combat()
  combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
  combat:setParameter(COMBAT_PARAM_EFFECT, 3)
  combat:setArea(createCombatArea(config.area))
  function onGetFormulaValues(player, skill, attack, factor)
    local min = ((player:getLevel() + 3) * 0.4) / 2
    local max = ((player:getLevel() + 5) * 0.6) / 2
    return -min, -max
  end
  
  function onTargetCreature(creature, target)
  	if not target then return false end
    if not isInArray(targets[creature:getId()], target:getId()) then
      table.insert(targets[creature:getId()], target:getId())
    end
  end

  combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")  
  combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
  table.insert(spell.combats, combat)
end

local function moveTargets(cid, dir)
    if not isCreature(cid) or not targets[cid] then return false end
    for i = 1, #targets[cid] do
        if isCreature(targets[cid][i]) then
            moveCreature(targets[cid][i], dir)
        end
    end
end

local function cleanTargets(cid)
    targets[cid] = nil
end

local fanPush = {
	[0] = {
		[1] = 7, [2] = 1, [3] = 1, [4]= 5, [6] = 6, [7] = 3, [8] = 3, [9] = 4,
	}, 

	[1] = { 
		[1] = 5, [2] = 2, [3] = 2, [4] = 4, [6] = 7, [7] = 0, [8] = 0, [9] = 6,
	},
	
	[2] = { 
		[1] = 4, [2] = 3, [3] = 3, [4] = 6, [6]= 5, [7] = 1, [8] = 1, [9] = 7,
	}, 
	[3] = { 
		[1] = 6, [2] = 0, [3] = 0, [4] = 7, [6] = 4, [7] = 2, [8] = 2, [9] = 5
	}
}

function onCastSpell(player, var)
	if not player then return false end
	local cid = player:getId()
	targets[cid] = {}
	doSendAnimatedText("Gust", getThingPos(cid), TEXTCOLOR_AIR)  
	noMove(cid, 0.5, 2)
  	for n = 1, #spell.combats do
    	addEvent(doCombat, (n * 150), cid, spell.combats[n], var)
    	addEvent(moveTargets, n*150, cid, fanPush[getPlayerLookDir(cid)][n])
 	end
  addEvent(cleanTargets, #spell.combats*150+10, cid)
  return true
end