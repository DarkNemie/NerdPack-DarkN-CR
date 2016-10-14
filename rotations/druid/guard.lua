local myCR 		= 'DNCR'									-- Change this to something Unique
local myClass 	= 'Druid'									-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'Guardian'								-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
----------	Do not change unless you know what your doing ----------
local mKey 		=  myCR ..mySpec ..myClass					-- Do not change unless you know what your doing
local Sidnum 	= DarkNCR.classSpecNum[myClass..mySpec]		-- Do not change unless you know what your doing
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
	{'22842', {'player.spell(22842).charges = 2', 'player.health < 100'} },		-- Frenzied Regeneration
	{'22842', 'player.health < 70' },											-- Frenzied Regeneration
	{'61336', {'player.spell(61336).charges = 2', 'player.health < 80'} },		-- Survival Instincts
	{'61336', 'player.health < 35' },											-- Survival Instincts
	{'22812', 'player.health < 85' },											-- Barkskin
	{'192081', 'player.rage >= 95', 'player' },									-- IronFur
		
}

local Cooldowns = {
	--Put items you want used on CD below:     Example: {'skillid'},  
	
	{'Lifeblood'},
	{'Berserking'},
	{'Blood Fury'},
	{'#trinket1', (function() return F('trink1') end)},
	{'#trinket2', (function() return F('trink2') end)},
}

local Interrupts = {
	{'106839'},																	-- Skull Bash
	
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
	{ '6807', 'player.rage > 70', 'target' },-- Maul
	{ '8921', 'player.buff(Galactic Guardian)' },	-- Moonfire
	{ '106832' },-- Thrash
	{ '33917' },-- Mangle
	{ '8921', '!target.debuff(164812)', 'target'},	-- Moonfire
	{ '8921', 'target.debuff(164812).duration <= 4.2', 'target' },	-- Moonfire
	{ '213771 ' },--- Swipe	
}

local ST = {
	{ '6807', 'player.rage > 70', 'target' }, -- Maul
	{ '8921', '!target.debuff(164812)', 'target'},	-- Moonfire
	{ '33917' },	-- Mangle
	{ '106832' }, -- Thrash
	{ '8921', 'player.buff(Galactic Guardian)', 'target' },	-- Moonfire
	{ '8921', 'target.debuff(164812).duration <= 4.2', 'target' }, -- Moonfire
	{ '213771' }, -- Swipe	
	
}

local Keybinds = {
	{'pause', 'keybind(alt)'},
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
		{ST}
	}, outCombat, exeOnLoad)