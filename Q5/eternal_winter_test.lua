local combat = {}

-- Define the combat areas

local area = {
{
{0,1,0,0,0,0,0,0,0},
{1,0,0,0,2,0,0,0,1},
{0,1,0,0,0,0,0,0,0},
{0,0,1,0,0,0,0,0,0},
{0,0,0,1,0,0,0,0,0},
{0,0,0,0,1,0,0,0,0}
},
{
{0,1,0,1,0,0},
{1,0,0,0,1,0},
{0,0,0,0,0,1},
{0,0,2,0,0,0},
{0,1,0,1,0,1}
},
{
{1},
{1},
{1},
{1},
{2}
},
{
{0,0,1,0,0,0,1,0,0},
{0,0,0,0,0,0,0,0,0},
{1,0,1,0,2,0,1,0,1},
{0,0,0,0,0,0,0,0,0},
{0,0,1,0,1,0,1,0,0}
},
{
{0,0,1,0,0,0,1,0,0},
{0,0,0,0,0,0,0,0,0},
{1,0,1,0,2,0,1,0,1},
{0,0,0,0,0,0,0,0,0},
{0,0,1,0,0,0,1,0,0},
{0,0,0,0,0,0,0,0,0},
{0,0,0,0,1,0,0,0,0}
},
{
{0,0,0,1,0,1,0,0,0},
{0,0,0,1,0,1,1,0,0},
{0,1,1,1,0,1,1,1,0},
{1,1,0,1,2,1,1,1,1},
{0,1,1,1,1,1,1,1,0},
{0,0,0,0,1,0,1,0,0},
{0,0,0,1,1,1,0,0,0}
},
{
{0,0,1,0,0},
{0,0,1,0,0},
{1,0,1,0,1},
{0,0,1,0,0},
{1,0,2,0,1},
{0,0,0,0,0},
{1,0,0,0,1}
}
}

-- Set combats

for i = 1,7 do
	combat[i] = Combat()
	combat[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
	combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
	combat[i]:setArea(createCombatArea(area[i]))
	combat[i]:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")
end

-- Set formula based on magicLevel
function onGetFormulaValues(player, level, magicLevel)
	local min = (level / 5) + (magicLevel * 5.5) + 25
	local max = (level / 5) + (magicLevel * 11) + 50
	return -min, -max
end

--Function to execute combat (as a helper for calling it in a loop)
local function CastSpell(creature, variant, index)
	combat[index]:execute(creature, variant)
end

--Function to start an event (as a helper for calling it in a loop)
local function Event(creature, variant, index)
	addEvent(CastSpell, 350 * index, creature,variant,index)
end

-- When the spell is cast, each combat is executed with a different delay, to have the desired effect
function onCastSpell(creature, variant)
	for i = 2, 7 do
		Event(creature,variant,i)
	end	
	return combat[1]:execute(creature, variant)
end