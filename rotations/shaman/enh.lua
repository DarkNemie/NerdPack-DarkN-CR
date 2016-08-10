local myCR 		= 'DNCR'									-- Change this to something Unique
local myClass 	= 'Shaman'									-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'Enhancement'									-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
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

local Cooldowns = {
	--Put items you want used on CD below:     Example: {'skillid'},
	{'Fire Elemental Totem'},
  	{'Earth Elemental Totem'},
  	{'Feral Spirit'},
  	{'Stormlash Totem'},
  	{'Ascendance', '!player.buff(Ascendance)'},  
	{'Lifeblood'},
	{'Berserking'},
	{'Blood Fury'},
	{'#trinket1', (function() return F('trink1') end)},
	{'#trinket2', (function() return F('trink2') end)},
}

local Interrupts = {
	-- Place skills that interrupt casts below:		Example: {'skillid'},
	{'Wind Shear'},
}

local Buffs = {
	--Put buffs that are applied out of combat below:     Example: {'skillid'}, 
  {'Windfury Weapon', '!player.enchant.mainhand' },
  {'Flametongue Weapon', '!player.enchant.offhand' },
  {'Lightning Shield', '!player.buff(Lightning Shield)' },
}

local Pet = {

	--Put skills in here that apply to your pet needs, while out of combat! 

}

local Pet_inCombat = {

	-- Place your pets combat rotation here if it has one! 	Example: {'skillID'},

}

local Healing = {
	  -- Healing
  { 'Healing Surge', { 
    'player.buff(Maelstrom Weapon).count = 5', 
    'player.health < 80',
  }},
  
  {'Healing Stream Totem', 'player.health < 60' },
}

local AoE = {
	-- AoE Rotation goes here.
	  -- AoE
  {'Flame Shock'},
  {'Lava Lash', 'target.debuff(Flame Shock)'},
  
  {'Chain Lightning', 'player.buff(Maelstrom Weapon).count = 5' },
  
  {'Fire Nova', 'target.debuff(Flame Shock)'},
}

local ST = {
	-- Single target Rotation goes here
	{'Unleash Elements' },
  	{'Ancestral Swiftness', 'spell.cooldown(Elemental Blast) <= 1' },
  	{'Elemental Blast' },
  	{'Lightning Bolt', 'player.buff(Maelstrom Weapon).count = 5' },
  	{'Stormstrike' },
  	{'Stormblast' },
  	{'Flame Shock', 'player.buff(Unleash Flame)' },
  	{'Flame Shock', 'target.debuff(Flame Shock).duration <= 3' },
  	{'Lava Lash' },
  	{'Earth Shock' },
}

local mytotems = {
  { 'Searing Totem', { 
    'toggle.totems', 
    '!player.totem(Fire Elemental Totem)', 
    '!player.totem(Searing Totem)', 
    '!toggle.AoE' 
  }},
  
  { 'Magma Totem', { 
    'toggle.totems', 
    '!player.totem(Fire Elemental Totem)', 
    '!player.totem(Magma Totem)', 
  }},


}

local Keybinds = {
	{ 'Totemic Projection', 'modifier.shift', 'ground' },						-- totemic projection
	{ 'pause', 'modifier.alt'},													-- Pause
	
}

local outCombat = {
	{Keybinds},
	{Buffs},
	{Pet},
	{ 'Healing Stream Totem', 'player.health < 100' },
}

NeP.Engine.registerRotation(Sidnum, '[|cff'..DarkNCR.Interface.addonColor ..myCR..'|r]'  ..mySpec.. ' '..myClass, 
	{-- In-Combat
		{Keybinds},
		{Interrupts, 'target.interruptAt(15)'},
		{Survival, 'player.health < 100'},
		{Cooldowns, 'modifier.cooldowns'},
		{mytotems},
		{Pet_inCombat},
		{Healing},
		{AoE, {'player.area(8).enemies >= 3','toggle.AoE'}},
		{ST}
	}, outCombat, exeOnLoad)