local combat = createCombatObject()

local arr = {
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
{1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1},
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
}


local area = createCombatArea(arr)
setCombatArea(combat, area)

function onTargetTile(player, pos)
	local cid = player:getId()
	pos.stackpos = 0
	local ground = getTileThingByPos(pos)
	if ground.itemid >= 4608 and ground.itemid <= 4625 or ground.itemid == 493 then
		if ground.itemid ~= 493 then
			if math.random(1, (100 + getPlayerSkill(cid, 6) / 10)) <= getPlayerSkill(cid, 6) then
				doPlayerAddItem(cid, 2667, 1)
				doSendMagicEffect(pos,2)
			end
		end
	end
end

setCombatCallback(combat, CALLBACK_PARAM_TARGETTILE, "onTargetTile")
function onCastSpell(player, var)
 	local cid = player:getId()
	local pos = changeposbydir(getThingPos(cid), getPlayerLookDir(cid), 3)
  	pos.stackpos = 0
  	local ground = getTileThingByPos(pos)

  	if ground.itemid >= 4608 and ground.itemid <= 4625 or ground.itemid == 493 then
		doCombat(cid, combat, var)
		doSendAnimatedText("Fish", getThingPos(cid), TEXTCOLOR_WATER)
	else
		doPlayerSendCancel(cid, "Essa dobrar requer uma grande quantidade de agua, vá para pertos de rios ou mares")
	end
return true
end