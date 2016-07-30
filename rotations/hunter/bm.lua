local myCR 		= 'DarkNCR'									-- Change this to something Unique
local myClass 	= 'Hunter'									-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'BeastMastery'							-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
----------	Do not change unless you know what your doing ----------
local mKey 		=  myCR ..mySpec ..myClass					-- Do not change unless you know what your doing
local Sidnum 	= DNCRlib.classSpecNum(myClass ..mySpec)	-- Do not change unless you know what your doing
local config 	= {
	key 	 = mKey,
	profiles = true,
	title 	 = '|T'..DarkNCR.Interface.Logo..':10:10|t' ..myCR.. ' ',
	subtitle = ' ' ..mySpec.. ' '..myClass.. ' Settings',
	color 	 = NeP.Core.classColor('player'),	
	width 	 = 250,
	height 	 = 500,
	config 	 = DNCRClassMenu.Config(Sidnum)
}
NeP.Interface.buildGUI(config)
local E = DarkNCR.dynEval
local F = function(key) return NeP.Interface.fetchKey(mKey, key, 100) end

local exeOnLoad = function()
	DarkNCR.Splash()
	DarkNCR.ClassSetting(mKey)
	NeP.Interface.CreateToggle('md', 'Interface\\Icons\\ability_hunter_misdirection', 'Auto Misdirect', 'Automatially Misdirect when necessary')
	NeP.Interface.CreateToggle('ressPet', 'Interface\\Icons\\Inv_misc_head_tiger_01.png', 'Pet Ress', 'Automatically ress your pet when it dies.')
end

local healthstn = function() 
	return E('player.health <= ' .. F('Healthstone')) 
end

---------- Special function for pet summon ----------
local petnum = function()
	return F('ptsltnum',1)
end 

local petT = {
    [1] = (function() CastSpellByName(GetSpellInfo(883)) end),
    [2] = (function() CastSpellByName(GetSpellInfo(83242)) end),
    [3] = (function() CastSpellByName(GetSpellInfo(83243)) end),
    [4] = (function() CastSpellByName(GetSpellInfo(83244)) end),
    [5] = (function() CastSpellByName(GetSpellInfo(83245)) end),
}

local petcallnum = function() 
	return petT[petnum()]() 
end

local configupdate = {
	{petcallnum},
}
---------- End section for pet summon ----------
--------------- END of do not change area ----------------
--
--	Notes: Rotation needs updated, it is currently useing
--	MM for 7.0.x rotation information and skills.
--
---------- This Starts the Area of your Rotaion ----------
local Survival = {
	-- Put skills or items here that are used to keep you alive!  Example: {'skillid'}, or {'#itemid'},
	{'5384', {'player.aggro >= 100', 'modifier.party', '!player.moving'}}, 		-- Fake death
	{'194291', 'player.health < 50'}, 											-- Exhilaration
	{'186265', 'player.health < 10'}, 											-- Aspect of the turtle
	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
	{'#5512', healthstn}, 														-- Health stone
	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
}

local Cooldowns = {
	--Put items you want used on CD below:     Example: {'skillid'},  
	{'193526'}, 																-- TrueShot
	{'131894'}, 																-- A Murder of Crows
	{'Lifeblood'},
	{'Berserking'},
	{'Blood Fury'},
	{'#trinket1', (function() return F('trink1') end)},
	{'#trinket2', (function() return F('trink2') end)},
}

local Interrupts = {
	-- Place skills that interrupt casts below:		Example: {'skillid'},
	{'!147362'},																-- Counter Shot
	{'!19577'},																	-- Intimidation
	{'!19386'},																	-- Wyvern Sting
	{'!186387'},																-- Bursting Shot
}

local Buffs = {

	--Put buffs that are applied out of combat below:     Example: {'skillid'}, 

}

local Pet = {
	--Put skills in here that apply to your pet needs, while out of combat! 
	{{ 																			-- Pet Dead
		{'55709', '!player.debuff(55711)'}, 									-- Heart of the Phoenix
		{'982'} 																-- Revive Pet
	}, {'pet.dead', 'toggle.ressPet'}},	
	{petcallnum, '!pet.exists'},												-- Summon Pet
	{'/petassist'}
}

local Pet_inCombat = {
	-- Place your pets combat rotation here if it has one! 	Example: {'skillID'},
	{'136', { 'pet.health <= 75', '!pet.buff(136)' }},							-- Mend Pet
}

local AoE = {
	-- AoE Rotation goes here.     ---------- NOTE: MM hunters do not really have an AoE Spec
}

local ST = {
	-- Single target Rotation goes here
	-- DPS Timmer
	{ "/stopcasting\n/stopattack\n/cleartarget\n/stopattack\n/cleartarget\n/petpassive", { "player.time >= 300", "toggle.dpstest" }},
	--- my auto target
	{ "/targetenemy [noexists]", { "toggle.myat", "!target.exists" } },
	{ "/targetenemy [dead]", { "toggle.myat", "target.exists", "target.dead" } },
	{ "/targetenemy [noexists][dead]", { 'toggle.myat',(function() return myRcheck() end) } },	
	-- Misdirect to focus target or pet when threat is above a certain threat
{{
	{ "34477", { "focus.exists", "!player.buff(35079)", "target.threat > 60" }, "focus" },
	{ "34477", { "pet.exists", "!pet.dead", "!player.buff(35079)", "!focus.exists", "target.threat > 85", "!talent(7,3)" }, "pet" },
}, "toggle.md", },

----		Rotation		----
	{'120360', 	'toggle.AoE','target'},											-- Barrage // TALENT	
	{'214579', 	{'player.buff(223138)', 'toggle.AoE'}, 'target'},				-- SideWinder
	{'214579', 	{'target.debuff(187131).duration < 2', 'toggle.AoE'}, 'target'},-- SideWinder
	{'185358',	{'player.buff(193534).duration < 3','talent (1,2)'}, 'target'},	-- Arcane Shot /W Steady Focus
	{'19434', 	'player.buff(194594)', 'target'},  								-- Aimed shot /w lnl
	{'185901', 	'target.debuff(187131)'},										-- Marked Shot
	{'19434', 	'target.debuff(187131)', 'target'},  							-- Aimed shot /w Vulnerable
	{'214579', 	{'player.focus < 60','toggle.AoE'}, 'target'},					-- sidewinder focus pool
	{'198670', 	'player.focus > 30'},											-- Piercing Shot
	{'194599'}, 																-- Black Arrow	
	{'206817'},																	-- Sentinel
	{'185358', 	'!talent(7,1)'},												-- Arcane Shot
	{'2643', 	{'player.focus > 60', 'player.area(40).enemies >= 3','toggle.AoE'}, 'target'}, 	-- Multi-Shot
	{'163485', 	'!player.moving', 'target'}, 									-- Focusing Shot // TALENT
	{'19434', 	{'player.focus > 60', '!talent(7,1)'}, 'target'}, 				-- Aimed Shot
	{'19434', 	{'player.focus > 60', 'talent(2,3)'}, 'target'}, 				-- Aimed Shot
	{'19434', 	'player.focus > 90', 'target'} 									-- Aimed Shot
}

local Keybinds = {
	{'pause', 'modifier.lshift'},												-- Pause
	{ '109248' , 'modifier.lcontrol', 'player.ground' }, 						-- Binding Shot
}

local outCombat = {
	{Keybinds},
	{Buffs},
	{Pet}
}

NeP.Engine.registerRotation(Sidnum, '[|cff'..DarkNCR.Interface.addonColor ..myCR..'|r]'  ..mySpec.. ' '..myClass, 
	{-- In-Combat
		{'pause', 'player.buff(5384)'},											-- Pause for Feign Death
		{Keybinds},
		{Interrupts, 'target.interruptAt(15)'},
		{Survival, 'player.health < 100'},
		{Cooldowns, 'modifier.cooldowns'},
		{Pet_inCombat},
		{AoE, {'player.area(8).enemies >= 3','toggle.AoE'}},
		{ST}
	}, outCombat, exeOnLoad)