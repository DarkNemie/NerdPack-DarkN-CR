local myClass 	= DNCRlib.myClass
local mySpec	= DNCRlib.mySpec
local myCR 		= 'DarkNCR'							-- Change this to something Unique
local myClass 	= 'DeathKnight'						-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'Blood'							-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
local mKey 		=  myCR ..mySpec ..myClass			-- Do not change unless you know what your doing
local Sidnum 	= DNCRlib.classSpecNum(myClass ..mySpec)
local config 	= {
	key 	 = mKey,
	profiles = true,
	title 	 = '|T'..DarkNCR.Interface.Logo..':10:10|t' ..myCR.. ' ',
	subtitle = ' ' ..mySpec.. ' '..myClass.. ' Settings',
	color 	 = NeP.Core.classColor('player'),	
	width 	 = 250,
	height 	 = 500,
	config 	 = {
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = mySpec, align = 'center'},
			
			-- Survival Settings:
			{ type = 'checkbox', text = 'Vampiric Blood', key = 'vampB', default = true, 
				desc = 'Enable the usage of VP.'
			},
		}
}
----------	Do not change unless you know what your doing ----------
NeP.Interface.buildGUI(config)
local E = DarkNCR.dynEval
local F = function(key) return NeP.Interface.fetchKey(mKey, key, 100) end

local exeOnLoad = function()
	DarkNCR.Splash()
	DarkNCR.ClassSetting(mKey)
end
----------	END of do not change area ----------

---------- This Starts the Area of your Rotaion ----------
local Survival = {

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
	{'pause', 'modifier.alt'},
	
}

local outCombat = {
	{Keybinds},
}

NeP.Engine.registerRotation(Sidnum, '[|cff'..DarkNCR.Interface.addonColor ..myCR..'|r]'  ..mySpec.. ' '..myClass, 
	{-- In-Combat
		{Keybinds},
		{Survival, 'player.health < 100'},
		{Cooldowns, 'modifier.cooldowns'},
		{AoE, 'player.area(8).enemies >= 3'},
		{ST}
	}, outCombat, exeOnLoad)