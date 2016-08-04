local myCR 		= 'DarkNCR'									-- Change this to something Unique
local myClass 	= 'Shaman'									-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'Restoration'								-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
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
	NeP.Interface.CreateToggle(
  		'Ghost_Wolf', 
  		'Interface\\Icons\\Spell_nature_spiritwolf.png', 
  		'Use Ghost Wolf', 
  		'Enable to use Ghost Worf while moving\nRequires player to move for 3 seconds or more.')
	NeP.Interface.CreateToggle(
  		'healdps', 
  		'Interface\\Icons\\Spell_shaman_stormearthfire.png‎', 
  		'Some DPS', 
  		'Do some damage while healing in party/raid.')
	NeP.Interface.CreateToggle(
		'mydispel',
		'Interface\\Icons\\Ability_shaman_cleansespirit.png‎',
		'Dispel',
		'Turn on or off auto dispelling!')
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
	{'61295', {-- Riptide
		'!player.buff(53390)', -- Tidal Waves
		'!player.buff(61295)', -- Riptide
		'player.health <= 60',
		'!lowest.health <= 50' -- Dont use it on sealf if someone needs it more!
	}, 'player'},
	{'59547', 'player.health <= 70', 'player'},		 							-- Gift of the Naaru // Draenei Racial
	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
	{'#5512', healthstn}, 														-- Health stone
	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
	{'108271', 'player.health <= 50'},											-- Astral Shift
	--{'98008', 'player.health <= 50', 'mouseover.ground'},  						-- Spirit Link
	{'77130', 'dispellAll(77130)'},      --Disspell
}

local myDispel = {
	{'77130', 'dispellAll(77130)'},     										 --Disspell
}

local Cooldowns = {
	{'5394',	{'!totem(157153)','!totem(108280)','lowest.health < 95'}},  	-- healing stream
	{'157153',	{'!totem(5394)','!totem(108280)','lowest.health < 95'}},  		-- Cloud Burst
	{'108280',	{'!totem(157153)','!totem(5394)','lowest.health < 95'}},		-- Healing Tide
	{'Lifeblood'},
	{'Berserking'},
	{'Blood Fury'},
	{'#133585','player.mana < 97' ,'target'},				---(function() return F('trink1') end)  --- I need to fix this
	--{'#trinket2', (function() return F('trink2') end)},
}

local Interrupts = {
	{'57994'}, -- Wind shear
	
}

local Buffs = {
	{{-- Ghost Wolf
		{'/cancelaura Ghost Wolf',{
			'player.buff(79206)', 
			'player.buff(2645)'
		}},
		{'2645', {-- Ghost Wolf
			'player.movingfor >= 1', 
			'!player.buff(79206)',
			'!player.buff(2645)'
		}},
	}, 'toggle.Ghost_Wolf'},
}

local Oshit = {
	{'5394'},  													-- healing stream
	{'157153'},  												-- Cloud Burst
	{'108280'},													-- Healing Tide
	{'79206'},													-- Spiritwalkers Grace
	--{'#86125'},													-- Kafa Press for some reason no tracking cooldowns
	{'61295', 'tank.buff(61295).duration < 3', 'tank'}, 		-- Riptide
	{'8004',  'tank.health < 60', 'tank'},						-- Healing Surge is an emergency heal to save players facing death. Consumes Tidal Waves.
	
}

local AoEH = {
	{'73920',{'!player.buff(73920)','player.area(25).friendly >= 2','lowest.health < 99'},'mouseover.ground'},				-- Healing Rain
	{'1064', {'player.buff(73920)','player.area(25).friendly >= 2','lowest.health < 95'}, 'lowest'},						-- Chain Heal used to heal moderate to high damage. Provides Tidal Waves.
}

local STH = {

}

local Lowest = {
	{'61295', {'!player.buff(53390)','lowest.health < 100','lowest.buff(61295).duration < 3'}, 'lowest'},						--Riptide placed on as many targets as possible. Provides Tidal Waves.
	{'1064',  {'!player.buff(53390)','!lowest.health <= 61','lowest.health < 95'}, 'lowest'},					-- Chain Heal used to heal moderate to high damage. Provides Tidal Waves.
	{'61295', 'lowest.buff(61295).duration < 3', 'lowest'},									--Riptide placed on as many targets as possible. Provides Tidal Waves.
	{'8004',  {'player.buff(53390)','lowest.health < 60'}, 'lowest'},						--Healing Surge is an emergency heal to save players facing death. Consumes Tidal Waves.
	{'77472', {'player.buff(53390)','lowest.health < 100'}, 'lowest'},						--Healing Wave used to heal moderate to high damage. Consumes Tidal Waves.
}

local DPS = {

	{'188838', '!target.debuff(188838)', 'target'}, 										-- flame shock
	{'51505', {'target.debuff(188838)','player.buff(77762)'},'target'}, 					-- lava burst
	{'51505', {'target.debuff(188838)'},'target'},						 					-- lava burst
	{'403'}, 																				-- lighting bolt
	{'421','target.area(9).enemies > 2', 'target'}, 										-- Chain Lighting
}

local Keybinds = {
	{'98008', 'modifier.lcontrol', 'mouseover.ground' },						-- Spirit Link
	{'192058','modifier.lshift', 'mouseover.ground'},							-- AoeStun
	{'/focus [target=mouseover]', 'modifier.lalt'}, 							-- Mouseover Focus
	--{'pause', 'modifier.alt'},													-- Pause
	
}

local occRess = {
	{' res spellID', 'friendly.dead','friendly'}
}

local outCombat = {
	{Keybinds},
	{Buffs},
	{Survival, 'player.health < 100'},
	{'1064', 'lowest.health < 98', 'lowest'},
}

NeP.Engine.registerRotation(Sidnum, '[|cff'..DarkNCR.Interface.addonColor ..myCR..'|r]'  ..mySpec.. ' '..myClass, 
	{-- In-Combat
		{myDispel, 'toggle.mydispel'},
		{Keybinds},
		{Interrupts, 'target.interruptAt(15)'},
		{Survival},
		{Cooldowns,'modifier.cooldowns'},
		{Oshit, {'tank.health < 30','toggle.Raidme'},'tank'},
		{AoEH,{{'lowest.health > 60','player.mana > 50'},'toggle.AoE'}},
		{Lowest, {'lowest.health < 100','player.area(40).friendly > 2'}},
		{STH},
		{DPS,'toggle.healdps'},
	}, outCombat, exeOnLoad)