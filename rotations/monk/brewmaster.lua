local myCR 		= 'DNCR'									-- Change this to something Unique
local myClass 	= 'Monk'									-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'Brewmaster'								-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
----------	Do not change unless you know what your doing ----------
local Sidnum 	= DarkNCR.classSpecNum[myClass..mySpec]	-- Do not change unless you know what your doing
local config 	= DarkNCR.menuConfig[Sidnum]

local exeOnLoad = function()
	DarkNCR.Splash()
end


--------------- END of do not change area ----------------
--
--	Notes:
--
---------- This Starts the Area of your Rotaion ----------
local Survival = {
	-- Put skills or items here that are used to keep you alive!  Example: {'skillid'}, or {'#itemid'},

	{'115072', 'player.health <= UI(ExpelHarm)'},			-- Expel Harm
	{'115098', 'player.health <= UI(ChiWave)'},			-- Chi Wave
	{'115203', 'player.health <= UI(FortifyingBrew)'},	-- Fortifying Brew
	{'115308', {'player.buff(215479).duration <= 1', 'player.debuff(124275)','player.health <= UI(IronskinBrew)'}},-- Ironskin Brew
	{'119582', {'player.debuff(124274)','player.health <= UI(PurifyingBrew)'}},-- Purifying Brew
	{'#109223', 'player.health < 40'}, 													-- Healing Tonic
	{'#5512', 'player.health <= UI(Healthstone)'}, 																-- Health stone
	{'#109223', 'player.health < 40'}, 													-- Healing Tonic
}

local Cooldowns = {
	--Put items you want used on CD below:     Example: {'skillid'},  
	-- Nimble Brew if pvp talent taken
--	{'137648', 'player.state.disorient'},
--	{'137648', 'player.state.stun'}, 
--	{'137648', 'player.state.fear'},
--	{'137648', 'player.state.horror'},
	-- Tiger's Lust if cd taken
--	{'116841', 'player.state.root'},
--	{'116841', 'player.state.snare'},

	{'Lifeblood'},
	{'Berserking'},
	{'Blood Fury'},
	{'#trinket1', 'UI(trink1)'},
	{'#trinket2', 'UI(trink2)'},
}

local Interrupts = {
	-- Place skills that interrupt casts below:		Example: {'skillid'},
	{'116705'},																			-- Spear Hand Strike
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

local Taunts = {
	{'115546', 'target.range <= 35'},						-- Provoke
}


local AoE = {
	-- AoE Rotation goes here.
	{'205523'},				--[[Use Blackout Strike first due to blackout combo talent this is priority over keg smash]]
	{'121253'},				-- Cast Keg Smash on cd.
	{'116847'},				-- Use Rushing Jade Wind, if you have taken this talent.
	{'123986'},				--[[If you have taken Chi burst]]
	{'115181'},				--[[Breath of Fire ]]
	
	--[[Use Tiger Palm to fill any spare global cooldowns. 
	This should only be used each time the monk is above 65 energy and keg smash is currently on cd.]]
	{'100780', 'player.energy >= 65'},
}

local ST = {
	-- Single target/Melle Rotation goes here
	{'205523'},											--[[Use Blackout Strike first due to blackout combo talent this is priority over keg smash]]
	{'121253'},											--[[Use Keg Smash on cooldown ]]
	
	--[[Use Tiger Palm to fill any spare global cooldowns. 
	This should only be used each time the monk is above 65 energy and keg smash is currently on cd.]]
	{'100780', 'player.energy >= 65'},
	{'115181'},											--[[Use Breath of Fire on cooldown ]]
	{'116847'},											-- Use Rushing Jade Wind, if you have taken this talent.
	{'117952', 'target.range >= 10'},					-- Crackling Jade Lightning
}

local Keybinds = {

	{'pause', 'keybind(alt)'},														-- Pause
	{'115315', 'keybind(control)', 'mouseover.ground'},								-- Summon Black Ox Statue
	
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
		{ST, {'target.range <= 8', 'target.infront'}},
		{Taunts, 'UI(canTaunt)'}
	}, outCombat, exeOnLoad)