local myCR 		= 'DNCR'									-- Change this to something Unique
local myClass 	= 'DemonHunter'								-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'Havoc'									-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
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
NeP.Interface.buildGUI(config)
local E = DarkNCR.dynEval
local F = function(key) return NeP.Interface.fetchKey(mKey, key, 100) end

local exeOnLoad = function()
	DarkNCR.Splash()
	DarkNCR.ClassSetting(mKey)
end

local healthstn = function() 
	return E('player.health <= ' .. F('Healthstone')) 
end
--------------- END of do not change area ----------------

---------- This Starts the Area of your Rotaion ----------
local Survival = {
	-- Put skills or items here that are used to keep you alive!  Example: {'skillid'}, or {'#itemid'},
	-- Defence
  	{ 'Netherwalk', { 'talent(4,1)',  'modifier.rcontrol' } },--104 Talent(4,1)
  	{ 'Blur', { 'modifier.rcontrol' } },--104
  	{ 'Chaos Nova', 'modifier.ralt' },

	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
	{'#5512', healthstn}, 														-- Health stone
	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
}

local Cooldowns = {
	--Put items you want used on CD below:     Example: {'skillid'},  
	{ 'Metamorphosis', 'modifier.cooldowns' },
  	{ 'Darkness', 'modifier.cooldowns' },
	{'Lifeblood'},
	{'Berserking'},
	{'Blood Fury'},
	{'#trinket1', (function() return F('trink1') end)},
	{'#trinket2', (function() return F('trink2') end)},
}

local Interrupts = {
	-- Place skills that interrupt casts below:		Example: {'skillid'},
	{ 'Consume Magic', 'modifier.interrupts' },
}

local Buffs = {
	--Put buffs that are applied out of combat below:     Example: {'skillid'}, 

}

local Pet = {
	--Put skills in here that apply to your pet needs while out of combat! 


}

local Pet_inCombat = {
	-- Place your pets combat rotation here if it has one! 	Example: {'skillID'},

}

local AoE = {

}

local ST = {
	--{ 'Anguish' },--Artifact
  	--{ 'Felblade', 'talent(3,1)' },--102 Talent(3,1)
  	--{ 'Fel Eruption', 'talent(5,2)' },--106 Talent(5,2)
  	--{ 'Nemesis', 'talent(5,3)' },--106 Talent(5,3)
  	--{ 'Chaos Blades', 'talent(7,1)' },--110 Talent(7,1)
  	--{ 'Fel Barrage', 'talent(7,2)' },--110 Talent(7,2)
  
  	{ 'Vengeful Retreat', { 'talent(2, 1)', 'player.fury <= 85' } },--Prepared Talent(2,1)
  	{ 'Fel Rush', { 'talent(1, 1)', 'player.fury <= 70' } },--1st time Fel Mastery Talent(1,1)
  	{ 'Fel Rush' },--2nd time

  	{ 'Eye Beam', 'modifier.multitarget' },
  	{ 'Annihilation', { 'player.buff(Metamorphosis)' } },--Metamorphosis Buff
  	{ 'Chaos Strike', { 'talent(1, 2)', 'modifier.multitarget' } },--Chaos Cleave Talent(1,2)
  	{ 'Blade Dance', 'modifier.multitarget' },
  
  	{ 'Chaos Strike', { 'player.fury >= 70' } },
  	{ "Demon's Bite", { '!talent(2, 2)', 'player.fury <= 80' } },--Not Demon Blades Talent(2,2)
  	{ 'Throw Glaive' },

}

local Keybinds = {
	{'pause', 'modifier.alt'},													-- Pause
	
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