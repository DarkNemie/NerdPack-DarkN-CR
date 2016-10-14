local myCR 		= 'DNCR'									-- Change this to something Unique
local myClass 	= 'Druid'									-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'Balance'									-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
----------	Do not change unless you know what your doing ----------
local mKey 		=  myCR ..mySpec ..myClass					-- Do not change unless you know what your doing
local Sidnum 	= DarkNCR.classSpecNum[myClass..mySpec]	-- Do not change unless you know what your doing
local config 	= DarkNCR.menuConfig[Sidnum]

local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface.buildGUI(config)
	DarkNCR.ClassSetting(mKey)
end

local healthstn = function() 
	return E('player.health <= ' .. F('Healthstone')) 
end
--------------- END of do not change area ----------------
--
--	Notes:
--
---------- This Starts the Area of your Rotaion ----------
local Survival = {
	-- Put skills or items here that are used to keep you alive!  Example: {'skillid'}, or {'#itemid'},

	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
	{'#5512', healthstn}, 														-- Health stone
	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
}

local Misc = {
	{ 'Moonkin Form', '!player.buff(Moonkin Form)' },--Activate Moonkin Form
	{ 'Solar Beam', 'target.interruptAt(50)' },-- Solar Beam
	{ 'Barkskin', 'player.health <= 50', 'player' },--Barkskin
	{ 'Healing Touch', 'player.health <= 70' },	
}

local Cooldowns = {
	--Put items you want used on CD below:     Example: {'skillid'},  
	{ 'Celestial Alignment', 'toggle(cooldowns)' },	--Celestial Alignment
	{'Lifeblood'},
	{'Berserking'},
	{'Blood Fury'},
	{'#trinket1', (function() return F('trink1') end)},
	{'#trinket2', (function() return F('trink2') end)},
}

local Interrupts = {
	
	-- Place skills that interrupt casts below:		Example: {'skillid'},
	
}

local Buffs = {

	--Put buffs that are applied out of combat below:     Example: {'skillid'}, 

}

local Pet = {

	--Put skills in here that apply to your pet needs, while out of combat! 

}

local Pet_inCombat = {

	-- Place your pets combat rotation here if it has one! 	Example: {'skillID'},

}

local AoE = {
	-- AoE Rotation goes here.
	
	{ 'Starsurge', { 'player.lunarpower >= 40', 'player.buff(164547).count < 3'} },--Cap Lunar Empowerment multi target
	{ 'Starfall',  'player.lunarpower >= 60'  },
	{ 'Sunfire',  'target.debuff(Stellar Empowerment)' },--DPS multi target when target debuffed
	{ 'Lunar Strike',  'player.buff(164547)' },--Lunar Strike multi target with Lunar Empowerment buff
	{ 'Solar Wrath',  'player.buff(164545).count = 3' },--Solar Strike multi target at 3 Solar Empowerment stacks
	
}

local ST = {
	-- Single target Rotation goes here
	{ 'Starsurge', { 'player.lunarpower >= 40', 'player.buff(164545).count < 3'} },--Cap Solar Empowerment single target
	{ 'Moonfire',  'target.debuff(Stellar Empowerment)'  },--DPS single target when target debuffed
	{ 'Solar Wrath',  'player.buff(164545)'  },--Solar Wrath single target with Solar Empowerment buff
	{ 'Lunar Strike',  'player.buff(164547).count = 3' },--Lunar Strike single target at 3 Lunar Empowerment stacks
	{ 'Moonfire', 'target.debuff(Moonfire).duration < 6.6' },--Debuff target
	{ 'Sunfire', 'target.debuff(Sunfire).duration < 5.4' },--Debuff target
	{ 'Solar Wrath'  },--Solar Wrath single target filler
}

local Keybinds = {
	{ 'Typhoon', 'keybind(alt)' },
	{ 'Entangling Roots', 'keybind(shift)' },
	{'pause', 'keybind(alt)'},													-- Pause
	
}

local outCombat = {
	{Keybinds},
	{Buffs},
	{Pet}
}

NeP.CR:Add(Sidnum, '[|cff'..DarkNCR.Interface.addonColor ..myCR..'|r]'  ..mySpec.. ' '..myClass, 
	{-- In-Combat
		{Keybinds},
		{Misc},
		{Interrupts, 'target.interruptAt(15)'},
		{Survival, 'player.health < 100'},
		{Cooldowns, 'toggle(cooldowns)'},
		{Pet_inCombat},
		{AoE, {'player.area(8).enemies >= 3','toggle(AoE)'}},
		{ST, 'player.area(8).enemies < 3'}
	}, outCombat, exeOnLoad)