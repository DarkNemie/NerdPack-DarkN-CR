local dynEval = DarkNCR.dynEval
local PeFetch = NeP.Interface.fetchKey

local config = {
	key = "NePConfigWarrArms",
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick.." Config",
	subtitle = "Warrior Arms Settings",
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{type = 'rule'},
		{type = 'header',text = "General settings:", align = "center"},
			-- NOTHING IN HERE YET...

		{type = "spacer"},
		{type = 'rule'},
		{type = "header", text = "Survival Settings", align = "center"},
			{type = "spinner", text = "Healthstone", key = "Healthstone", width = 50, default = 75},

			-- Survival
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = 'Survival', align = 'center'},
			{type = 'spinner', text = 'Rallying Cry', key = 'RallyingCry', default = 15,},
			{type = 'spinner',text = 'Die by the Sword', key = 'DBTS', default = 25,},
			{type = 'spinner',text = 'Impending Victory', key = 'IVT', default = 100,},
			{type = 'spinner',text = 'Enraged Regeneration', key = 'ERG', default = 60,},

	}
}

NeP.Interface.buildGUI(config)

local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfigWarrArms') end)
end

local Shared = {
	
}

local Keybinds = {
	{'Heroic Leap', 'modifier.shift', 'target.ground'}
}

local Cooldowns = {
	{'Recklessness'},
	{'Blood Fury'},
	{'Bloodbath'}
}

local Interrupts = {
	-- Pummel
	{"6552"},
}

local Survival = {
	-- Healthstone
  	{"#5512", (function() return dynEval("player.health <= "..PeFetch('NePConfigWarrArms', 'Healthstone')) end)}, 
  	-- Rallying Cry
	{'97462', (function() return dynEval('player.health <= '..PeFetch('NePConfigWarrArms', 'RallyingCry')) end)},
	-- Die by the Sword
  	{'118038', (function() return dynEval('player.health <= '..PeFetch('NePConfigWarrArms', 'DBTS')) end)}, 
  	-- Impending Victory
  	{'103840', (function() return dynEval('player.health <= '..PeFetch('NePConfigWarrArms', 'IVT')) end)}, 
  	 -- Enraged Regeneration
	{'55694', (function() return dynEval('player.health <= '..PeFetch('NePConfigWarrArms', 'ERG')) end)},
}

local AoE = {
	{'Bladestorm'},
	{'Dragon Roar'},
	{'Thunder Clap', 'player.glyph(Glyph of Resonating Power)'},
	{'Whirlwind'},
}

local inCombat = {
	{'Sweeping Strikes', 'player.area(8).enemies > 1'},
	{'Rend', 'target.debuff(Rend).duration < 5'},
	{'Rend', '@DarkNCR.areaRend(3, 5)'},
	{'Ravager'},
	{'Colossus Smash', '!target.debuff(Colossus Smash)'},
	{'Mortal Strike', 'target.health > 20'},
	{'Colossus Smash'},
	{'Bladestorm', {'target.debuff(Colossus Smash)', 'modifier.cooldowns'} },
	{'Storm Bolt', '!target.debuff(Colossus Smash)'},
	{'Dragon Roar'},
	{'Execute', 'player.buff(Sudden Death)'},
	{'Execute'},
	{'Execute', '@DarkNCR.aoeExecute()'},
	{'Thunder Clap', 'player.glyph(Glyph of Resonating Power)'},
	{'Whirlwind', 'player.rage > 40'},
	{'Whirlwind', 'target.debuff(Colossus Smash)'}
}

local outCombat = {
	{Shared},
	{Keybinds}
}

NeP.Engine.registerRotation(71, '[|cff'..NeP.Interface.addonColor..'NeP|r] Warrior - Arms', 
	{-- In-Combat CR
		{Shared},
		{Keybinds},
		{Interrupts, "target.interruptAt(70)"},
		{Survival, 'player.health < 100'},
  		{Cooldowns, "modifier.cooldowns"},
  		{AoE, {'player.area(40).enemies >= 3', 'modifier.aoe'} },
		{inCombat, 'target.range <= 7'}
		-- {"57755", "player.range > 10", "target"} -- Heroic Throw
	}, outCombat, exeOnLoad)