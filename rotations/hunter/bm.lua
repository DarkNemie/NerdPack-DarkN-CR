local dynEval = DarkNCR.dynEval
local PeFetch = NeP.Interface.fetchKey

local config = {
	key = 'NePConfigHunterBM',
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Hunter Beast Mastery Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--To be added
		
		-- Survival
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Survival', align = 'center'},
			{type = 'spinner', text = 'Healthstone', key = 'Healthstone', default = 75},
	}
}

NeP.Interface.buildGUI(config)

local lib = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfigHunterBM') end)
	NeP.Interface.CreateToggle(
		'ressPet',
		'Interface\\Icons\\Inv_misc_head_tiger_01.png',
		'Pet Ress',
		'Automatically ress your pet when it dies.')
end

local Keybinds = {
	{{ -- Has trap Launcher
		-- Explosive Trap
		{'82939', 'modifier.alt', 'target.ground'},
		-- Freezing Trap
		{'60192', 'modifier.shift', 'target.ground'},
		-- Ice Trap
		{'82941', 'modifier.shift', 'target.ground'}
	}, 'player.buff(77769)' },
}

local Shared = {
	-- Trap Launcher
	{'77769', '!player.buff(77769)'}, 
}

local Pet = {
	{'/cast Call Pet 1', '!pet.exists'},
  	{{ -- Pet Dead
		{'55709', '!player.debuff(55711)'}, -- Heart of the Phoenix
		{'982'} -- Revive Pet
	}, {'pet.dead', 'toggle.ressPet'}},
}

local Interrupts = {
	-- Counter Shot
	{'!147362'},
	-- Intimidation
	{'!19577'},
	-- Wyrven Sting
	{'!19386'},
}

local Cooldowns = {
	-- Bestial Wrath
	{'19574', {'pet.exists'}},
	{'121818', 'player.hashero'},
	{'121818', 'pet.buff(19615).count >= 4'}, -- wt Frenzy
	{'131894'}, -- A Murder of Crows
	{'26297'},
	{'20572'},
	{'#trinket1'},
	{'#trinket2'},
}

local Survival = {
	-- Fake death
	{'5384', {
		'player.aggro >= 100', 
		'modifier.party', 
		'!player.moving'
	}},
	-- Healthstone
	{'#5512', (function() return dynEval('player.health <= '..PeFetch('NePConfigHunterBM', 'Healthstone')) end)},
}

local AoE = {
	--Cast Multi-Shot, as often as needed to keep up the Beast Cleave buff on your pet.
	{'2643'},
	--Use Barrage.
	{'120360'},
	--Use Explosive Trap.
	{'82939', 'player.buff(77769)' , 'target.ground'}
}

local inCombat = {
	--Keep Steady Focus up, if you have taken this talent.
	{'77767', {
		'player.buff(177668).duration < 3',
		'talent(4,1)',
		'lastcast(77767)'
	}, 'target'},
	-- AoE
	{AoE, 'player.area(40).enemies >= 3'},
	--Cast Kill Command.
	{'34026', 'pet.exists'},
	--Cast Kill Shot,Only available when the target is below 20% health.
	{'53351', '@DarkNCR.instaKill(35)'},
	--Use Barrage, if you have taken this talent.
	{'120360'},
	-- Focus Fire with 5 Frenzy stacks.
	{'82692', 'pet.buff(19615).count >= 5'},
	--Cast Arcane Shot to dump any excess Focus.
	{'3044', 'player.focus >= 80'},
	--Cast Cobra Shot to generate Focus.
	{'77767'},
	-- Steady Shot for low lvl's
	{'56641'},
}

local Pet_InCombat = {
	-- Master's Call
	{'53271', 'player.state.stun'}, 
	{'53271', 'player.state.root'},
	{'53271', 'player.state.disorient'},
	{'53271', {'player.state.snare', '!player.debuff(Dazed)'}},
	-- Mend Pet
	{'136', { 
		'pet.health < 100', 
		'!pet.buff(136)',
		'pet.range < 45' 
	}}, 
	-- Missdirect // PET 
	{'34477', { 
		'!player.buff(35079)', 
		'!focus.exists', 
		'target.threat > 85' 
	}, 'pet'},
	-- Missdirect // Focus
	{'34477', { 
		'focus.exists', 
		'!player.buff(35079)', 
		'target.threat > 60' 
	}, 'focus'},
}

local outCombat = {
	{Keybinds},
	{Shared},
	{Pet}
}

NeP.Engine.registerRotation(253, '[|cff'..NeP.Interface.addonColor..'NeP|r] Hunter - Beast Mastery',
	{ -- In-Combat
		-- Pause for Feign Death
		{'pause', 'player.buff(5384)'},
		{Keybinds},
		{Shared},
		{Interrupts, 'target.interruptAt(40)'},
		{{ -- General Conditions
			{Survival, 'player.health < 100'},
			{Pet},
			{Cooldowns, 'modifier.cooldowns'},
			{Pet_InCombat, {'player.alive', 'pet.exists'} },
			{inCombat, {'target.infront', 'target.exists', 'target.range <= 40'}},
		}, '!player.channeling'}
	}, outCombat, lib)
