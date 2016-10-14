local myCR 		= 'DNCR'									-- Change this to something Unique
local myClass 	= 'DemonHunter'								-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'Vengeance'								-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
----------	Do not change unless you know what your doing ----------
local Sidnum 	= DarkNCR.classSpecNum[myClass..mySpec]	-- Do not change unless you know what your doing
local config 	= DarkNCR.menuConfig[Sidnum]

local exeOnLoad = function()
	DarkNCR.Splash()
end


--------------- END of do not change area ----------------
----------------------------------------------------------
--Test--   these are called via /run DarkNCR.IStrike() macro ingame
DarkNCR.IStrike = function()
	NeP.Engine.forcePause = true,
	--NeP.Engine.clear_Cast_Queue()
	NeP.Engine.Cast_Queue('189110', 'mouseover.ground') 	-- mouseover Infernal Strike
	--C_Timer.After(0.8 , function() NeP.Engine.clear_Cast_Queue() end )
	NeP.Engine.forcePause = false
end
DarkNCR.SFlame = function()
	NeP.Engine.forcePause = true,
	--NeP.Engine.clear_Cast_Queue()
	NeP.Engine.Cast_Queue('204596', 'mouseover.ground') 	-- Sigil Flame
	--C_Timer.After(0.8 , function() NeP.Engine.clear_Cast_Queue() end )
	NeP.Engine.forcePause = false
end
DarkNCR.SMisery = function()
	NeP.Engine.forcePause = true,
	--NeP.Engine.clear_Cast_Queue()
	NeP.Engine.Cast_Queue('207684', 'mouseover.ground') 	-- Sigil Misery
	--C_Timer.After(0.8 , function() NeP.Engine.clear_Cast_Queue() end )
	NeP.Engine.forcePause = false
end
DarkNCR.SSilent = function()
	NeP.Engine.forcePause = true,
	--NeP.Engine.clear_Cast_Queue()
	NeP.Engine.Cast_Queue('202137', 'mouseover.ground') 	-- Sigil Silent
	--C_Timer.After(0.8 , function() NeP.Engine.clear_Cast_Queue() end )
	NeP.Engine.forcePause = false
end
-- End Test section , IT IS RECOMENDED NOT TO USE THIS!!
----------------------------------------------------------
-- Test Function for Soul Cleave max up time -------------
--[[  refrence
	RegisterConditon('pain', function(target, spell)
	return UnitPower(target, SPELL_POWER_PAIN)
end)

-- Returns the number of fury you have left till max (e.g. you have a max of 100 fury and 80 fury now, so it will return 20)
RegisterConditon('furydiff', function(target, spell)
    local max = UnitPowerMax(target, SPELL_POWER_FURY)
    local curr = UnitPower(target, SPELL_POWER_FURY)
    return (max - curr)
end)
]]--

DarkNCR.mySC = function ()
	local maxP = UnitPowerMax('player', SPELL_POWER_PAIN)
	local currP = UnitPower('player', SPELL_POWER_PAIN)
	local diffP = (maxP - currP)
	local maxH = UnitHealthMax('player')
	local currH = UnitHealth('player')
	local diffH = (maxH - currH)
	if diffP < 40 then
		return true
	elseif diffH > 78847 then 
		return true
	end	
end

local mySC = DarkNCR.mySC
-- End Test Function for Soul Cleave max up time ---------
---------- This Starts the Area of your Rotaion ----------
local Survival = {
  	{'Demon Spikes',  {'!player.buff(Demon Spikes)', '!target.debuff(Fiery Brand)', 'player.health <= 98' } },
  	{'Empower Wards', {'!player.buff(Demon Spikes)', '!target.debuff(Fiery Brand)', 'player.health <= 98' } },
	{'Fiery Brand',   {'!player.buff(Demon Spikes)', '!player.buff(Empower Wards)' ,'player.health <= 98' } },	
	{'#109223', 'player.health < 65'}, 											-- Healing Tonic
	{'#5512', 'player.health <= UI(Healthstone)'}, 														-- Health stone
	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
}

local Cooldowns = {
	{'Metamorphosis'}, --- unidirectional
	{'Lifeblood'},
	{'Berserking'},
	{'Blood Fury'},
    {'#trinket1', 'UI(trink1)'},
    {'#trinket2', 'UI(trink2)'},
}

local Interrupts = {
	{ 'Consume Magic'},   --melee
}

local Buffs = {
}

local Pet = {
}

local Pet_inCombat = {
}

local AoE = {
}

local ST = {
  --{ 'Soul Carver' },--Artifact
  --{ 'Felblade', 'talent(3,1)' },--102 Talent(3,1)
  --{ 'Fracture', 'talent(4,2)' },--104 Talent(4,2)
  --{ 'Fel Eruption', 'talent(5,2)' },--106 Talent(5,2)
  --{ 'Fel Devastation', 'talent(6,1)' },--108 Talent(6,1)
  --{ 'Spirit Bomb', 'talent(6,3)' },--108 Talent(6,3)
  --{ 'Nether Bond', 'talent(7,2)' },--110 Talent(7,2)
  --{ 'Soul Barrier', 'talent(7,3)' },--110 Talent(7,3)
  {'Throw Glaive', {'target.range >= 5', 'target.range <= 30'},'target'},  -- melle
  { 'Soul Cleave', {mySC,'target.range <= 6'}, 'target' },  --melee
  { 'Immolation Aura' }, ---- unidirectional
  { 'Sigil of Flame', '!toggle(Raidme)' , 'mouseover.ground' },  --- mouseover target
  { 'Fiery Brand',  'talent(2,3)' },     --unidirectional
  { 'Shear','target.range <= 6', 'target'}, -- melee
}

local Keybinds = {
	{'pause', 'keybind(alt)'},													-- Pause
	{ 'Infernal Strike',  'keybind(lshift)', 'mouseover.ground'  },

}

local Taunt = {
}

local outCombat = {
	{Keybinds},
	{Buffs},
	{Pet}
}



NeP.CR:Add(Sidnum, '[|cff'..DarkNCR.Interface.addonColor ..myCR..'|r]'  ..mySpec.. ' '..myClass, 
	{-- In-Combat
		{Keybinds},
		{Interrupts, 'target.interruptAt(15)'},
		{Survival, 'player.health < 100'},
		{Cooldowns, 'toggle(cooldowns)'},
		{Pet_inCombat},
		{AoE, {'player.area(8).enemies >= 3','toggle(AoE)'}},
		{ST,'target.infront'},
		{girlsgonewild}
	}, outCombat, exeOnLoad)