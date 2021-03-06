-- Class ID 7 - The Naturalist
local myCR 		= 'DNCR'									-- Change this to something Unique
local myClass 	= 'Shaman'									-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= '1to10'									-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
----------	Do not change unless you know what your doing ----------
local mKey 		=  myCR  ..myClass	..mySpec				-- Do not change unless you know what your doing
local Sidnum 	= 7	                -- This is the class ID for Shaman
local config = {
        	-- General
			{type = 'rule'},
			{type = 'header', text = 'General:', align = 'center'},
				--Trinket usage settings:
				{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = false},
				{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = false},
				{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
				
			--Spec Specific settings
			{type = 'spacer'},{ type = 'rule'},
			{type = 'header', text = 'Spec Specific Settings', align = 'center'},
}
local exeOnLoad = function()
	DarkNCR.Splash()
end



------------------------------------------------------------
local Survival = {
  { "Healing Surge", "player.health <= 75" },
  	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
	{'#5512', 'player.health <= UI(Healthstone)'}, 														-- Health stone
	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
	{ 'Healing Surge', 'player.health < 70' },
}

local Cooldowns = {
	--Put items you want used on CD below:     Example: {'skillid'},  
 	{'Lifeblood'},
	{'Berserking'},
	{'Blood Fury'},
	{'#trinket1', 'UI(trink1)'},
	{'#trinket2', 'UI(trink2)'},
}

local Buffs = {
  { "Lightning Shield", "!player.buff(Lightning Shield)" },
}

local AoE = {

}

local ST = {
  { "Primal Strike" },
  { "Earth Shock" },
  { "Lightning Bolt" },
}

local Keybinds = {

}

local outCombat = {
    {Keybinds},
	{Buffs},
}


NeP.CR:Add(Sidnum, '[|cff'..DarkNCR.Interface.addonColor ..myCR..'|r]'  ..mySpec.. ' '..myClass, 
	{-- In-Combat
		{Keybinds},
		{Interrupts, 'target.interruptAt(15)'},
		{Survival, 'player.health < 100'},
		{Cooldowns, 'toggle(cooldowns)'},
		{AoE, {'player.area(8).enemies >= 3','toggle(AoE)'}},
		{ST}
	}, outCombat, exeOnLoad)