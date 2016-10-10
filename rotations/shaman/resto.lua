local myCR 		= 'DNCR'									-- Change this to something Unique
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

local E = DarkNCR.dynEval
local F = function(key) return NeP.Interface.fetchKey(mKey, key, 100) end
	

local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface.buildGUI(config)
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

----------------------------------------------------------
--Test--   these are called via /run DarkNCR.HR() macros ingame
DarkNCR.HR = function()
	NeP.Engine.CastGround(73920, mouseover) 	-- mouseover healing Rain
end
DarkNCR.SL = function()
	NeP.Engine.CastGround(98008, mouseover) 	-- Spirit Link
end
DarkNCR.ES = function() 
	NeP.Engine.CastGround(198838, mouseover) 	-- Earthen Sheild
end
DarkNCR.LST = function()
	NeP.Engine.CastGround('Lightning Surge Totem', mouseover) 	-- Lighting surge
end
-- End Test section , IT IS RECOMENDED NOT TO USE THIS!!
----------------------------------------------------------

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
		'!lowest.health <= 50' -- Dont use it on self if someone needs it more!
	}, 'player'},
	{'59547', 'player.health <= 70', 'player'},		 							-- Gift of the Naaru // Draenei Racial
	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
	{'#5512', healthstn}, 														-- Health stone
	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
	{'108271', 'player.health <= 50'},											-- Astral Shift
}

local myDispel = {
	{'77130', 'dispellAll(77130)'},     										 --Disspell
}

local Cooldowns = {
	{'5394',	{'!totem(157153)','AoEHeal(100, 3)'}},  			-- healing stream
	{'157153',	{'!player.buff(157504)','AoEHeal(100, 3)'}},  		-- Cloud Burst
	{'108280', 'player.buff(98007)'},								-- Healing Tide / W Spirit Link
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
	{'61295', 'lowest.buff(61295).duration < 3', 'lowest'}, 								-- Riptide
	{'8004',  'lowest.health < 60', 'lowest'},												-- Healing Surge is an emergency heal to save players facing death. Consumes Tidal Waves.
	
}

local AoEH = {
	{'1064', {'player.buff(73920)','AoEHeal(90, 3)'}, 'lowest'},							-- Chain Heal used to heal moderate to high damage. Provides Tidal Waves.
}

local STH = {

}

local Lowest = {
	{'61295', 'lowest.buff(61295).duration < 3', 'lowest'},									--Riptide placed on as many targets as possible. Provides Tidal Waves.
	{'8004',  {'player.buff(53390)','lowest.health < 35'}, 'lowest'},						--Healing Surge is an emergency heal to save players facing death. Consumes Tidal Waves.
	{'77472', {'player.buff(53390)','lowest.health < 80'}, 'lowest'},						--Healing Wave used to heal moderate to high damage. Consumes Tidal Waves.
	{'1064', { 'toggle.AoE',{'AoEHeal(99, 3)' ,'or','lowest.health < 99'} }, 'lowest'},		--Chain Heal
}

local DPS = {
	{'188838', '!target.debuff(188838)', 'target'}, 										-- flame shock
	{'51505', {'target.debuff(188838)','player.buff(77762)'},'target'}, 					-- lava burst
	{'51505', {'target.debuff(188838)'},'target'},						 					-- lava burst
	{'421','target.area(9).enemies > 3', 'target'}, 										-- Chain Lighting
	{'403'}, 																				-- lighting bolt
	
}

local Tank = {
	{'61295', 'tank.buff(61295).duration < 3', 'tank'},										--Riptide
	{'8004', 'tank.health < 60', 'tank'},													--Healing Surge
	{'77472', 'tank.health < 75', 'tank'},													--Healing Wave
	{{ --Chain Heal used to heal moderate to high damage. Provides Tidal Waves.
		{'1064', 'tank.health < 100',  'tank'}
	}, {'toggle.AoE', 'AoEHeal(99, 2)'}}
}


local Keybinds = {
	
	
}

local occRess = {
	{'212048', 'friend.dead'},
}

local outCombat = {
	{occRess},
	{Keybinds},
	{Buffs},
	{Survival, 'player.health < 100'},
	{'1064', 'AoEHeal(90, 3)', 'lowest'},
}

NeP.Engine.registerRotation(Sidnum, '[|cff'..DarkNCR.Interface.addonColor ..myCR..'|r]'  ..mySpec.. ' '..myClass, 
	{-- In-Combat
		{'pause', 'keybind(lshift)'},-- Pause
		{myDispel, 'toggle.mydispel'},
		{Keybinds},
		{Interrupts, 'target.interruptAt(15)'},
		{Survival},
		{Cooldowns,'toggle(cooldowns)'},
		{Tank, {'tank.exists', 'tank.health < 100'}},
		--{Oshit,'lowest.health < 30','lowest'},
		--{AoEH,'player.mana > 10','toggle.AoE'},
		{Lowest, 'lowest.health < 100','lowest'},
		--{STH},
		{DPS,{'toggle.healdps','target.range < 30', 'target.infront'}},
	}, outCombat, exeOnLoad)