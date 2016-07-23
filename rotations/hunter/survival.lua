local dynEval = DarkNCR.dynEval
local PeFetch = NeP.Interface.fetchKey

local n = GetSpellInfo('5118')

local config = {
	key = 'DarkNConfigHunterSurv',
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Hunter Survival Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			
		
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Survival', align = 'center'},
			
		-- Survival Settings:
		{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
		
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Survival', align = 'center'},
			
		-- Survival Settings:
		{type = 'spinner', text = 'Pet Slot to use: 1 - 5', key = 'ptsltnum', default = 1, min = 1, max = 5},
	
	}
}

NeP.Interface.buildGUI(config)

local lib = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('DarkNConfigHunterSurv') end)
	NeP.Interface.CreateToggle('md', 'Interface\\Icons\\ability_hunter_misdirection', 'Auto Misdirect', 'Automatially Misdirect when necessary')
	NeP.Interface.CreateToggle('ressPet', 'Interface\\Icons\\Inv_misc_head_tiger_01.png', 'Pet Ress', 'Automatically ress your pet when it dies.')
end

local trinkset1 = function()
	return PeFetch('DarkNConfigHunterSurv', 'trink1')
end

local trinkset2 = function()
	return PeFetch('DarkNConfigHunterSurv', 'trink2')
end

local healthstn = function() 
	return dynEval('player.health <= ' .. PeFetch('DarkNConfigHunterSurv', 'Healthstone')) 
end

local petnum = function()
	return PeFetch('DarkNConfigHunterSurv', 'ptsltnum')
end

--[[
local ptsltcall = function()
	if petslotnum = 1 then
		CastSpellByName(GetSpellInfo(883))
	end 
	if petslotnum = 2 then
		CastSpellByName(GetSpellInfo(83242))
	end 	
	if petslotnum = 3 then
		CastSpellByName(GetSpellInfo(83243))
	end
	if petslotnum = 4 then
		CastSpellByName(GetSpellInfo(83244))
	end 
	if petslotnum = 5 then
		CastSpellByName(GetSpellInfo(83245))
	end 	
end	
]]--
local petT = {
    [1] = (function() CastSpellByName(GetSpellInfo(883)) end),
    [2] = (function() CastSpellByName(GetSpellInfo(83242)) end),
    [3] = (function() CastSpellByName(GetSpellInfo(83243)) end),
    [4] = (function() CastSpellByName(GetSpellInfo(83244)) end),
    [5] = (function() CastSpellByName(GetSpellInfo(83245)) end),
}




local Keybinds = {
	{ '109248' , 'modifier.lcontrol', 'target.ground' }, 						-- Binding Shot
}

local Buffs = {
}

local Pet = {
--{petT[(function() return Fetch('DarkNConfigHunterSurv', 'petslot')](), '!pet.exists'},
	{petT[..petnum](), '!pet.exists'},
--	{ptsltcall, '!pet.exists'},												-- Summon Pet
	
  	{{ 																			-- Pet Dead
		{'55709', '!player.debuff(55711)'}, 									-- Heart of the Phoenix
		{'982'} 																-- Revive Pet
	}, {'pet.dead', 'toggle.ressPet'}},	
}

local Pet_inCombat = {
	{'53271', 'player.state.stun'}, 											-- Master's Call
	{'53271', 'player.state.root'}, 											-- Master's Call
	{'53271', { 'player.state.snare', '!player.debuff(Dazed)' }},				-- Master's Call
	{'53271', 'player.state.disorient'}, 				 						-- Master's Call
	{'136', { 'pet.health <= 75', '!pet.buff(136)' }},							-- Mend Pet
}

local Cooldowns = {
	{'193526'}, 																-- TrueShot
	{'131894'}, 																-- A Murder of Crows
	{'Lifeblood'},
	{'Berserking'},
	{'Blood Fury'},
	{'#trinket1', trinkset1},
	{'#trinket2', trinkset2},
}

local Survival = {
	{'5384', {'player.aggro >= 100', 'modifier.party', '!player.moving'}}, 		-- Fake death
	{'194291', 'player.health < 50'}, 											-- Exhilaration
	{'186265', 'player.health < 10'}, 											-- Aspect of the turtle
	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
	{'#5512', healthstn}, 														-- Health stone
	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
}

local Interrupts = {
	{'!147362'},																-- Counter Shot
	{'!19577'},																	-- Intimidation
	{'!19386'},																	-- Wyvern Sting
	{'!186387'},																-- Bursting Shot
	
}
	
local inCombat = {
	-- Misdirect to focus target or pet when threat is above a certain threat
{{
	{ "34477", { "focus.exists", "!player.buff(35079)", "target.threat > 60" }, "focus" },
	{ "34477", { "pet.exists", "!pet.dead", "!player.buff(35079)", "!focus.exists", "target.threat > 85", "!talent(7,3)" }, "pet" },
}, "toggle.md", },

	{'120360', 'toggle.AoE'}, 													-- Barrage // TALENT	
	{'214579', {'player.buff(223138)', 'toggle.AoE'}, 'target'},				-- SideWinder
	{'185358' , {'player.buff(193534).duration < 3','talent (1,2)'}, 'target'},	-- Arcane Shot /W Steady Focus
	{'19434', 'player.buff(194594)', 'target'},  								-- Aimed shot /w lnl
	{'185901', 'target.debuff(185365)'}, 										-- Marked Shot
	{'19434', {'player.focus > 50', 'target.debuff(187131)'}, 'target'},  		-- Aimed shot /w Vulnerable
	{'214579', {'player.focus < 50','toggle.AoE'}, 'target'},					-- sidewinder focus pool
	{'198670', 'player.focus > 30'},											-- Piercing Shot
	{'194599'}, 																-- Black Arrow	
	{'206817'},																	-- Sentinel
	{'185358', '!talent(7,1)'},													-- Arcane Shot
	{'2643', {'player.focus > 60', 'player.area(40).enemies >= 3','toggle.AoE'}, 'target'}, 	-- Multi-Shot
	{'163485', '!player.moving', 'target'}, 									-- Focusing Shot // TALENT
	{'19434', {'player.focus > 60', '!talent(7,1)'}, 'target'}, 				-- Aimed Shot
	{'19434', 'player.focus > 90', 'target'} 									-- Aimed Shot
}

local outCombat = {
	{Keybinds},
	{Buffs},
	{Pet}
}

NeP.Engine.registerRotation(255, '[|cff'..NeP.Interface.addonColor..'DarkNemie|r] Hunter - MM',
	{ 																			-- In-Combat
		{'pause', 'player.buff(5384)'},											-- Pause for Feign Death
		{Keybinds},
		{Buffs},
		{Interrupts, 'target.interruptAt(5)'},
		{{ 																		-- General Conditions
			{Survival, 'player.health < 100'},
			{Cooldowns, 'modifier.cooldowns'},
			{inCombat, {'target.infront', 'target.range <= 45'}},
		}, '!player.channeling'}
	}, outCombat, lib)