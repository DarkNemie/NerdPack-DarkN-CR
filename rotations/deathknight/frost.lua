local myCR 		= 'DNCR'							-- Change this to something Unique
local myClass 	= 'DeathKnight'						-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'Frost'							-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
----------	Do not change unless you know what your doing ----------
local mKey 		=  myCR ..mySpec ..myClass			-- Do not change unless you know what your doing
local Sidnum 	= DarkNCR.classSpecNum[myClass..mySpec]
local config 	= DarkNCR.menuConfig[Sidnum]

local exeOnLoad = function()
	DarkNCR.Splash()
	
end
----------	END of do not change area ----------

---------- This Starts the Area of your Rotaion ----------
local Survival = {
	
	{'55233',UI(vampB)'}, -- Vampiric Blood
	{'Lifeblood'},
	{'Berserking'},
	{'Blood Fury'},
	{'#trinket1', 'UI(trink1)'},
	{'#trinket2', 'UI(trink2)'},
}

local Cooldowns = {

}

local AoE = {

}

local ST = {
	--Blood Boil to maintain Blood Plague.
	{'Blood Boil', '!target.debuff(Blood Plague)'},
	
	--Death and Decay whenever available. Watch for Crimson Scourge procs.
	
	--Marrowrend to maintain 5 undefined.
	{'Marrowrend'},
	
	--Blood Boil with 2 charges.
	{'Blood Boil', 'player.spell(Blood Boil).charges >= 2'},
	
	--Death Strike to dump Runic Power.
	{'Death Strike', 'player.energy >= 75'},
	
	--Heart Strike as a filler to build Runic Power.
	{'Heart Strike'}
}

local Keybinds = {
	-- Pause
	{'pause', 'keybind(alt)'},
	
}

local outCombat = {
	{Keybinds},
}

NeP.CR:Add(Sidnum, '[|cff'..DarkNCR.Interface.addonColor ..myCR..'|r]'  ..mySpec.. ' '..myClass, 
	{-- In-Combat
		{Keybinds},
		{Survival, 'player.health < 100'},
		{Cooldowns, 'toggle(cooldowns)'},
		{AoE, 'player.area(8).enemies >= 3'},
		{ST}
	}, outCombat, exeOnLoad)