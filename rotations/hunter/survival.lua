local myCR 		= 'DarkNCR'									-- Change this to something Unique
local myClass 	= 'Hunter'									-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'Survival'								-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
----------	Do not change unless you know what your doing ----------
local mKey 		=  myCR ..mySpec ..myClass					-- Do not change unless you know what your doing
local Sidnum 	= DNCRlib.classSpecNum(myClass ..mySpec)	-- Do not change unless you know what your doing
local config 	= {
	key 	 = mKey,
	profiles = true,
	title 	 = '|T'..DarkNCR.Interface.Logo..':10:10|t' ..myCR.. ' ',
	subtitle = ' ' ..mySpec.. ' '..myClass.. ' Settings',
	color 	 = NeP.Core.classColor('player'),	
	width 	 = 250,
	height 	 = 500,
	config 	 = DNCRClassMenu.Config(Sidnum)
}
NeP.Interface.buildGUI(config)
local E = DarkNCR.dynEval
local F = function(key) return NeP.Interface.fetchKey(mKey, key, 100) end

local exeOnLoad = function()
	DarkNCR.Splash()
	DarkNCR.ClassSetting(mKey)
	NeP.Interface.CreateToggle('md', 'Interface\\Icons\\ability_hunter_misdirection', 'Auto Misdirect', 'Automatially Misdirect when necessary')
	NeP.Interface.CreateToggle('ressPet', 'Interface\\Icons\\Inv_misc_head_tiger_01.png', 'Pet Ress', 'Automatically ress your pet when it dies.')
end

local healthstn = function() 
	return E('player.health <= ' .. F('Healthstone')) 
end

---------- Special function for pet summon ----------
local petnum = function()
	return F('ptsltnum',1)
end 

local petT = {
    [1] = (function() CastSpellByName(GetSpellInfo(883)) end),
    [2] = (function() CastSpellByName(GetSpellInfo(83242)) end),
    [3] = (function() CastSpellByName(GetSpellInfo(83243)) end),
    [4] = (function() CastSpellByName(GetSpellInfo(83244)) end),
    [5] = (function() CastSpellByName(GetSpellInfo(83245)) end),
}

local petcallnum = function() 
	return petT[petnum()]() 
end

local configupdate = {
	{petcallnum},
}
---------- End section for pet summon ----------
--------------- END of do not change area ----------------
--
--	Notes:
--
---------- This Starts the Area of your Rotaion ----------
local Survival = {
	-- Put skills or items here that are used to keep you alive!  Example: {'skillid'}, or {'#itemid'},
	{'5384', {'player.aggro >= 100', 'modifier.party', '!player.moving'}}, 		-- Fake death
	{'194291', 'player.health < 50'}, 											-- Exhilaration
	{'186265', 'player.health < 10'}, 											-- Aspect of the turtle
	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
	{'#5512', healthstn}, 														-- Health stone
	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
}

local Cooldowns = {
	--Put items you want used on CD below:     Example: {'skillid'},  
	{'193526'}, 																-- TrueShot
	{'131894'}, 																-- A Murder of Crows
	{'Lifeblood'},
	{'Berserking'},
	{'Blood Fury'},
	{'#trinket1', (function() return F('trink1') end)},
	{'#trinket2', (function() return F('trink2') end)},
}

local Interrupts = {
	-- Place skills that interrupt casts below:		Example: {'skillid'},
	{'!147362'},																-- Counter Shot
	{'!19577'},																	-- Intimidation
	{'!19386'},																	-- Wyvern Sting
	{'!186387'},																-- Bursting Shot
}

local Buffs = {

	--Put buffs that are applied out of combat below:     Example: {'skillid'}, 

}

local Pet = {
	--Put skills in here that apply to your pet needs, while out of combat! 
	{petcallnum, '!pet.exists'},												-- Summon Pet
}

local Pet_inCombat = {

	-- Place your pets combat rotation here if it has one! 	Example: {'skillID'},

}

local AoE = {
	-- AoE Rotation goes here.
	
}

local ST = {
	-- Single target Rotation goes here
	
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
		{'pause', 'player.buff(5384)'},											-- Pause for Feign Death
		{Keybinds},
		{Interrupts, 'target.interruptAt(15)'},
		{Survival, 'player.health < 100'},
		{Cooldowns, 'modifier.cooldowns'},
		{Pet_inCombat},
		{AoE, {'player.area(8).enemies >= 3','toggle.AoE'}},
		{ST}
	}, outCombat, exeOnLoad)