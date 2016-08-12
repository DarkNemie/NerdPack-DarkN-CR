local myCR 		= 'DNCR'									-- Change this to something Unique
local myClass 	= 'DemonHunter'								-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'Vengeance'								-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
----------	Do not change unless you know what your doing ----------
local mKey 		=  myCR ..mySpec ..myClass					-- Do not change unless you know what your doing
local Sidnum 	= DarkNCR.classSpecNum[myClass..mySpec]	-- Do not change unless you know what your doing
local config 	= {
	key 	 = mKey,
	profiles = true,
	title 	 = '|T'..DarkNCR.Interface.Logo..':10:10|t' ..myCR.. ' ',
	subtitle = ' ' ..mySpec.. ' '..myClass.. ' Settings',
	color 	 = NeP.Core.classColor('player'),	
	width 	 = 250,
	height 	 = 500,
	config 	 = DarkNCR.menuConfig[Sidnum]
}

local E = DarkNCR.dynEval
local F = function(key) return NeP.Interface.fetchKey(mKey, key, 100) end

local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface.buildGUI(config)
	DarkNCR.ClassSetting(mKey)
end

local healthstn = function() 
	return E('player.health <= ' .. F('Healthstone')) 
end
--------------- END of do not change area ----------------

---------- This Starts the Area of your Rotaion ----------
local Survival = {
	-- Put skills or items here that are used to keep you alive!  Example: {'skillid'}, or {'#itemid'},
  	{ 'Demon Spikes', { '!player.buff(Demon Spikes)', 'player.health <= 85' } },
  	{ 'Empower Wards', 'player.health <= 75' },
  	{ 'Fiery Brand', 'player.health <= 65' },
	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
	{'#5512', healthstn}, 														-- Health stone
	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
}

local Cooldowns = {
	--Put items you want used on CD below:     Example: {'skillid'},  
	{ 'Metamorphosis' },
  	{ 'Darkness' },
	{'Lifeblood'},
	{'Berserking'},
	{'Blood Fury'},
	--{'#trinket1', (function() return F('trink1') end)},
	--{'#trinket2', (function() return F('trink2') end)},
}

local Interrupts = {
	-- Place skills that interrupt casts below:		Example: {'skillid'},
	{ 'Consume Magic'},
}

local Buffs = {
	--Put buffs that are applied out of combat below:     Example: {'skillid'}, 

}

local Pet = {

	--Put skills in here that apply to your pet needs while out of combat! 
	--[[
	Here is an example from Hunter CR.
	{'/cast Call Pet 1', '!pet.exists'},										-- Summon Pet
  	{{ 																			-- Pet Dead
		{'55709', '!player.debuff(55711)'}, 									-- Heart of the Phoenix
		{'982'} 																-- Revive Pet
	}, {'pet.dead', 'toggle.ressPet'}},	
	]]--

}

local Pet_inCombat = {

	-- Place your pets combat rotation here if it has one! 	Example: {'skillID'},

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
  {'Throw Glaive', 'target.range >= 6', 'target.range <= 30','target'},
  { 'Soul Cleave', 'player.pain >= 50' },
  { 'Immolation Aura' },
  { 'Sigil of Flame' },
  { 'Fiery Brand',  'talent(2,3)' },
  { 'Shear' },
}

local Keybinds = {
	{'pause', 'modifier.alt'},													-- Pause
	{ 'Infernal Strike',  'modifier.lshift', 'mouseover.ground'  },

}

local Taunt = {
--	{ 'Throw Glaive', 'modifier.lshift' },--Taunt
	--{ 'Torment', 'modifier.lcontrol' },--Taunt
}

local outCombat = {
	{Keybinds},
	{Buffs},
	{Pet}
}

NeP.Engine.registerRotation(Sidnum, '[|cff'..DarkNCR.Interface.addonColor ..myCR..'|r]'  ..mySpec.. ' '..myClass, 
	{-- In-Combat
		{Keybinds},
		{Interrupts, 'target.interruptAt(15)'},
		{Survival, 'player.health < 100'},
		{Cooldowns, 'modifier.cooldowns'},
		{Pet_inCombat},
		{AoE, {'player.area(8).enemies >= 3','toggle.AoE'}},
		{ST}
	}, outCombat, exeOnLoad)