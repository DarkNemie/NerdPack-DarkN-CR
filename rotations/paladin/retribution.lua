local mKey = 'DarkNCR_PalaRet'
local addonColor = DarkNCR.Interface.addonColor
--local Logo = DarkNCR.Interface.Logo
local E = DarkNCR.dynEval
local F = function(key) return NeP.Interface.fetchKey(mKey, key, 100) end

local config = {
	key = mKey,
	profiles = true,
	title = 'DarkNCR Config',
	subtitle = "Paladin Protection Settings",
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		--Combat
	    {type = 'text', text = 'Combat', align = 'center'},
	    -- Execution Sentence (10 ms = 1 sec)
	    	{type = 'text', text = 'Execution Sentence time to tick (10 ms = 1 sec)', align = 'left'},
			{type = 'spinner', text = 'Execution Sentence tick time', key = 'ExecutionSentence', default = 70}, 
		-- [[ Keybinds ]]
		{type = 'text', text = 'Keybinds', align = 'center'},		
			{type = 'text', text = 'Control: Hammer of Justice', align = 'left'},
			{type = 'text', text = 'Shift: Blinding Light/Repentance', align = 'left'},
			{type = 'text', text = 'Alt: Pause Rotation',align = 'left'},
		-- [[ General ]]
		{type = 'spacer'},{type = 'rule'},
		{type = 'text', text = 'General', align = 'center' },
		
			-- Interrupt
			{ type = 'dropdown',text = 'Interrupt at%:', key = 'InterruptAt', list = {
				{text = 20, key = 'InterruptAt20'},
				{text = 40, key = 'InterruptAt40'},
				{text = 60, key = 'InterruptAt60'},
				{text = 80, key = 'InterruptAt80'}
        	}, default = 'InterruptAt40' },
        	
			-- Buff
			{ type = 'dropdown',text = 'Buff:', key = 'Buff', list = {
				{text = 'Self', key = 'Self'},
				{text = 'Manual', key = 'Manual'}
        	}, default = 'Self' },
			-- Self Dispel
        	{ type = "checkbox", text = "Self Dispel", key = "SelfDispel", default = true},

	    -- [[ Survival ]]
		{ type = 'spacer' },{ type = 'rule' },
	    {type = 'text', text = 'Survival', align = 'center'},
			-- Healthstone
			{ type = 'spinner', text = 'Healthstone', key = 'HealthStone', default = 70},
			-- Lay on Hands
			{ type = 'spinner', text = 'Lay on Hands', key = 'LayOnHands', default = 15},
			-- Divine Shield
			{ type = 'spinner', text = 'Divine Shield', key = 'DivineShield', default = 10},
			-- Shield of Vengeance
			{ type = 'spinner', text = 'Shield of Vengeance', key = 'ShieldOfVengeance', default = 60},
			-- Gift of Naaru
			{ type = 'spinner', text = 'Gift of Naaru(draenei only)', key = 'GiftOfNaaru', default = 70},
			
		}
}

NeP.Interface.buildGUI(config)

local exeOnLoad = function()
	DarkNCR.Splash()
	DarkNCR.ClassSetting(mKey)
end

local Survival = {
	-- Healthstone
	{'#5512', (function() return E('player.health <= '..F('HealthStone')) end)},
	-- Lay on Hands
	{"633", (function() return E('player.health <= '..F('LayOnHands')) end)},	
	-- Shield of Vengeance
	{"184662", (function() return E('player.health <= '..F('ShieldOfVengeance')) end)},
	-- Divine Shield
	{'642', (function() return E('player.health <= '..F('DivineShield')) end)},
	-- GiftOfNaaru
	{'59542', (function() return E('player.health <= '..F('GiftOfNaaru')) end)},
	
	-- Cleanse Toxins
	{ '213644', {
		'player.dispellable(213644)',
		(function() return F( 'SelfDispel') end)
	}, 'player' },
	
}

local Cooldowns = {
	--Crusade
	{'224668'},
	--Avenging Wrath
	{'31884'}
}
local MegaAoE = {
			-- Divine storm 
	{'53385',   {
 		'player.holypower > 2',
		'target.infront' ,
 		'target.range <= 8'
				},
	'target'},
		-- Zeal 
	{'217020',   {
		'talent(2, 2)',
    	'player.holypower <= 4',
 		'target.infront' ,
 		'target.range <= 5',
						},
	'target'}	,
}
local AoE = {
	-- Zeal if expires
	{'217020',   {
		'talent(2, 2)',
    	'player.holypower <= 4',
    	'player.buff(217020).duration < 3',
 		'target.infront' ,
 		'target.range <= 5',
						},
	'target'}	,
	-- Judgment 4+ Holy Power 
	{'20271',   {
		'player.holypower >= 4',
		'target.infront',
 		'target.range <= 30',
						},
	'target'},
		-- Judgment  DP procs
	{'20271',   {
		'player.buff(223819)', 
 		'target.infront',
 		'target.range <= 30',
						},
	'target'},
	-- Justicar's Vengeance  with Divine Purpose proc and Judgment up
	{'215661',   {
 		'player.buff(223819)', 
		'target.debuff(197277).duration > 0',
		'target.infront' ,
 		'target.range <= 5',
				},
	'target'},
	-- Divine storm with 5 HP
	{'53385',   {
 		'player.holypower = 5',
		'target.debuff(197277).duration > 0',
		'target.infront' ,
 		'target.range <= 5',
				},
	'target'},
	
	-- Divine storm with 4 HP AND Fires of Justice
	{'53385',   {
 		'player.holypower >= 4',
 		'player.buff(209785)',
		'target.debuff(197277).duration > 0',
		'target.infront' ,
 		'target.range <= 5',
				},
	'target'},
	
	-- Crusader Strike to build Holy Power. (2 charges)
	{'35395',   {
		'talent(2, 1)',
    	'player.spell(35395).charges = 2',
 		'player.holypower <= 4',
 		'target.infront' ,
 		'target.range <= 5',
						},
	'target'}	,
		
	-- Zeal to build Holy Power. (2 charges)
	{'217020',   {
		'talent(2, 2)',
    	'player.spell(217020).charges = 2',
 		'player.holypower <= 4',
 		'target.infront' ,
 		'target.range <= 5',
						},
	'target'}	,
	--Blade of wrath to build Holy Power.
	{'202270',   {
	'talent(4, 2)',
 		'player.holypower <= 3',
 		'target.infront' ,
 		'target.range <= 12',
					},
	'target'},

		-- Divine storm with 3 HP
	{'53385',   {
 		'player.holypower = 3',
		'target.debuff(197277).duration > 0',
		'target.infront' ,
 		'target.range <= 5',
				},
	'target'},
		-- Divine storm procced Fires of justice
	{'53385',   {
		'player.buff(209785)', 
 		'player.holypower >= 2',
		'target.debuff(197277).duration > 0',
		'target.infront' ,
 		'target.range <= 5'
				},
	'target'},
	-- Crusader Strike to build Holy Power. (1 charge)
	{'35395',   {
		'talent(2, 1)',
    	'player.spell(35395).charges = 1',
 		'player.holypower <= 4',
 		'target.infront' ,
 		'target.range <= 5',
						},
	'target'},
		-- Zeal to build Holy Power. (1 charge)
	{'217020',   {
		'talent(2, 2)',
    	'player.spell(217020).charges = 1',
 		'player.holypower <= 4',
 		'target.infront' ,
 		'target.range <= 5',
						},
	'target'},
		-- Judgment
	{'20271',   {
 		'target.infront' ,
 		'target.range <= 30',
						},
	'target'},
			-- Divine storm procced Fires of justice
	{'53385',   {
 		'player.holypower > 2',
		'target.infront' ,
 		'target.range <= 5'
				},
	'target'},
	-- Blinging light
	{'115750',   {
 		'target.infront' ,
 		'target.range <= 5',
						},
	'target'},

}

local Keybinds = {
	-- Pause
	{'pause', 'modifier.alt'},
	--Blinding light
	{'115750', 'modifier.shift'},
	--Repentance
	{'20066', 'modifier.shift'},
	--Hammer of justice
	{'853', 'modifier.control'},
}

local outCombat = {
	{Keybinds},
	-- Greater Blessing of Wisdom
	{'203539',	{
	  (function() return F('Buff')=='Self' end),
	 '!player.buff(203539).any'
	 			},
	  'player'},
	-- Greater Blessing of Might
	{'203528',	{
	  (function() return F('Buff')=='Self' end),
	 '!player.buff(203528).any'
	 			},
	  'player'},
	-- Greater Blessing of Kings
	{'203538',	{
	  (function() return F('Buff')=='Self' end),
	 '!player.buff(203538).any'
	 			},
	  'player'},

	
}

local Interrupt = {
	--Rebuke
	{'96231',	{
	'target.interruptAt(20)',
	(function() return F('InterruptAt')=='InterruptAt20' end)
	 			},
	 'target'},
	--Rebuke
	{'96231',	{
	'target.interruptAt(40)',
	(function() return F('InterruptAt')=='InterruptAt40' end)
	 			},
	 'target'},
	--Rebuke
	{'96231',	{
	'target.interruptAt(60)',
	(function() return F('InterruptAt')=='InterruptAt60' end)
	 			},
	 'target'},
	--Rebuke
	{'96231',	{
	'target.interruptAt(80)',
	(function() return F('InterruptAt')=='InterruptAt80' end)
	 			},
	 'target'}
}
local ST = {

	-- Judgment 4+ Holy Power 
	{'20271',   {
		'player.holypower >= 4',
		'target.infront',
 		'target.range <= 30',
 		'!target.debuff(197277)'
						},
	'target'},
		-- Judgment  DP procs
	{'20271',   {
		'player.buff(223819)', 
 		'target.infront',
 		'target.range <= 30',
 		'!target.debuff(197277)'
						},
	'target'},
	-- Justicar's Vengeance  with Divine Purpose proc and Judgment up
	{'215661',   {
 		'player.buff(223819)', 
		'target.debuff(197277).duration > 0',
		'target.infront' ,
 		'target.range <= 5',
				},
	'target'},
	-- Templar's Verdict with 5 HP
	{'85256',   {
 		'player.holypower = 5',
		'target.debuff(197277).duration > 0',
		'target.infront' ,
 		'target.range <= 5',
				},
	'target'},
	
	-- Templar's Verdict with 4 HP AND Fires of Justice
	{'85256',   {
 		'player.holypower >= 4',
 		'player.buff(209785)',
		'target.debuff(197277).duration > 0',
		'target.infront' ,
 		'target.range <= 5',
				},
	'target'},
	
	-- Crusader Strike to build Holy Power. (2 charges)
	{'35395',   {
		'talent(2, 1)',
    	'player.spell(35395).charges = 2',
 		'player.holypower <= 4',
 		'target.infront' ,
 		'target.range <= 5',
						},
	'target'}	,
		-- Zeal to build Holy Power. (2 charges)
	{'217020',   {
		'talent(2, 2)',
    	'player.spell(217020).charges = 2',
 		'player.holypower <= 4',
 		'target.infront' ,
 		'target.range <= 5',
						},
	'target'}	,
	--Blade of wrath to build Holy Power.
	{'202270',   {
	'talent(4, 2)',
 		'player.holypower <= 3',
 		'target.infront' ,
 		'target.range <= 12',
					},
	'target'},

		-- Templar's Verdict with 3 HP
	{'85256',   {
 		'player.holypower = 3',
		'target.debuff(197277).duration > 0',
		'target.infront' ,
 		'target.range <= 5',
				},
	'target'},
		-- Templar's Verdict procced Fires of justice
	{'53385',   {
		'player.buff(209785)', 
 		'player.holypower >= 2',
		'target.debuff(197277).duration > 0',
		'target.infront' ,
 		'target.range <= 5'
				},
	'target'},
	-- Crusader Strike to build Holy Power. (1 charge)
	{'35395',   {
		'talent(2, 1)',
    	'player.spell(35395).charges = 1',
 		'player.holypower <= 4',
 		'target.infront' ,
 		'target.range <= 5',
						},
	'target'},
		-- Zeal to build Holy Power. (1 charge)
	{'217020',   {
		'talent(2, 2)',
    	'player.spell(217020).charges = 1',
 		'player.holypower <= 4',
 		'target.infront' ,
 		'target.range <= 5',
						},
	'target'},
		-- Judgment
	{'20271',   {
 		'target.infront' ,
 		'target.range <= 30',
						},
	'target'},
	-- Blinging light
	{'115750',   {
 		'target.infront' ,
 		'target.range <= 5',
						},
	'target'},

}

NeP.Engine.registerRotation(70, '[|cff'..addonColor..'DarkNCR|r] Paladin - Retribution', 
	{-- In-Combat
		{Keybinds},
		{Survival, 'player.health < 100'},
		{Cooldowns, 'modifier.cooldowns'},
		{Interrupt},
		{MegaAoE, 'player.area(8).enemies >= 5'},
		{AoE, 'player.area(8).enemies >= 3'},
		{ST}
	}, outCombat, exeOnLoad)
--[[
local myCR 		= 'DNCR'									-- Change this to something Unique
local myClass 	= 'Paladin'									-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'Retribution'								-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
----------	Do not change unless you know what your doing ----------PaladinRetribution
local mKey 		=  myCR ..mySpec ..myClass					-- Do not change unless you know what your doing
local Sidnum 	= DarkNCR.classSpecNum[myClass..mySpec]		-- Do not change unless you know what your doing
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
]]
	--Put skills in here that apply to your pet needs while out of combat! 
	--[[
	Here is an example from Hunter CR.
	{'/cast Call Pet 1', '!pet.exists'},										-- Summon Pet
  	{{ 																			-- Pet Dead
		{'55709', '!player.debuff(55711)'}, 									-- Heart of the Phoenix
		{'982'} 																-- Revive Pet
	}, {'pet.dead', 'toggle.ressPet'}},	
	]]--
--[[
}

local Pet_inCombat = {

	-- Place your pets combat rotation here if it has one! 	Example: {'skillID'},

}

local AoE = {

}

local ST = {

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
		{Keybinds},
		{Interrupts, 'target.interruptAt(15)'},
		{Survival, 'player.health < 100'},
		{Cooldowns, 'toggle.cooldowns'},
		{Pet_inCombat},
		{AoE, {'player.area(8).enemies >= 3','toggle.AoE'}},
		{ST}
	}, outCombat, exeOnLoad)
	]]