local myCR 		= 'DNCR'									-- Change this to something Unique
local myClass 	= 'Priest'									-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'Shadow'									-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
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

	{'Shadow Mend', 'player.health < 60', 'player'},
	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
	{'#5512', healthstn}, 														-- Health stone
	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
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
	
	-- Place skills that interrupt casts below:		Example: {'skillid'},
	
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
	-- AoE Rotation goes here.
	
}

local Voidform = {
		--Void Bolt on cooldown.
	{'!Void Eruption'},
	--Shadow Word: Death when available on targets with <= 20% health.
	{'Shadow Word: Death', 'target.health <= 20'},
	--Mind Blast on cooldown.
	{'Mind Blast'},
	--Mind Flay as a filler.
	{'Mind Flay'}
}

local ST = {
	-- Single target Rotation goes here
		--Void Eruption at 100 Insanity to activate Voidform.
	{'Void Eruption', 'player.insanity >= 100'},
	--Shadow Word: Pain maintained at all times.
	{'Shadow Word: Pain', 'target.debuff(Shadow Word: Pain).duration < 5'},
	--Vampiric Touch maintained at all times.
	{'Vampiric Touch', 'target.debuff(Vampiric Touch).duration < 5'},
	--Shadow Word: Death when available on targets with <= 20% health.
	{'Shadow Word: Death', 'target.health <= 20'},
	--Mind Blast on cooldown to build Insanity.
	{'Mind Blast'},
	--Mind Flay as a filler to build Insanity.
	{'Mind Flay'}
}

local Keybinds = {

	{'pause', 'modifier.alt'},													-- Pause
	
}
local dotitall = function()
	CastSpellByName("Vampiric Touch")
	CastSpellByName("Shadow Word: Pain")
	TargetNearestEnemy()
	CastSpellByName("Vampiric Touch")
	CastSpellByName("Shadow Word: Pain")
end
--[[
{
	{'Shadow Word: Pain','!target.debuff(Shadow Word: Pain)','target' },
	{ "/targetenemy", 'target.debuff(Shadow Word: Pain).duration > 5'  },
	{ "/targetenemy [noexists]"},
	
}
]]--

local outCombat = {
	{Keybinds},
	{Buffs},
	{Pet},
	{dotitall, 'toggle.ADots' },
}

NeP.Engine.registerRotation(Sidnum, '[|cff'..DarkNCR.Interface.addonColor ..myCR..'|r]'  ..mySpec.. ' '..myClass, 
	{-- In-Combat
		--{dotitall,'toggle.ADots'},
		{Keybinds},
		{Interrupts, 'target.interruptAt(15)'},
		{Survival, 'player.health < 100'},
		{Cooldowns, 'modifier.cooldowns'},
		{Pet_inCombat},
		{AoE, {'player.area(8).enemies >= 3','toggle.AoE'}},
		{Voidform, 'player.buff(Voidform)'},
		{ST, '!player.buff(Voidform)'}
	}, outCombat, exeOnLoad)