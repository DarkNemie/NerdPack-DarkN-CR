local dynEval = DarkNCR.dynEval
local PeFetch = NeP.Interface.fetchKey

local config = {
	key = 'NePConfigWarrFury',
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Warrior Fury Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{type = 'header',text = 'General', align = 'center'},
			{type = 'dropdown',text = 'Shout', key = 'Shout', 
				list = {
			    	{text = 'Battle Shout', key = 'Battle Shout'},
			        {text = 'Commanding Shout', key = 'Commanding Shout'},
		    	}, 
		    	default = 'Battle Shout', 
		    	desc = 'Select what buff to use.' 
		   },
		
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
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfigWarrFury') end)
end

local Racials = {
	-- Dwarves
	{'20594', 'player.health <= 65'},
	-- Humans
	{'59752', 'player.state.charm'},
	{'59752', 'player.state.fear'},
	{'59752', 'player.state.incapacitate'},
	{'59752', 'player.state.sleep'},
	{'59752', 'player.state.stun'},
	-- Draenei
	{'28880', 'player.health <= 70', 'player'},
	-- Gnomes
	{'20589', 'player.state.root'},
	{'20589', 'player.state.snare'},
	-- Forsaken
	{'7744', 'player.state.fear'},
	{'7744', 'player.state.charm'},
	{'7744', 'player.state.sleep'},
}

local All = {
	{'6673', {-- Battle Shout
		'!player.buffs.attackpower',
		(function() return PeFetch('NePConfigWarrFury', 'Shout') == 'Battle Shout' end),
		}},
	{'469', {-- Commanding Shout
		'!player.buffs.stamina',
		(function() return PeFetch('NePConfigWarrFury', 'Shout') == 'Commanding Shout' end),
	}},
	{Racials},
	{'Charge', {
		'modifier.alt',
		'target.spell(35).range'
	}},
	{'Heroic Leap', {
		'modifier.control',
		'target.ground'
	}},
}

local Cooldowns = {
	{'12292'}, -- Bloodbath // Talent
  	{'107574'}, -- Avatar // Talent
  	{'107570'}, -- Storm Bolt // Talent
  	{'118000'}, -- Dragon Roar // Talent
  	{'176289'}, -- Siegebreaker // Talent
  	{'1719'}, -- Recklessness Use as often as possible. Stack with other DPS cooldowns.
  	{'46924'}, -- Bladestorm // Talent
  	{'18499'}, -- Berserker Rage Use as needed to maintain Enrage.
  	{'#gloves'},
}

local Survival = {
	-- Rallying Cry
	{'97462', (function() return dynEval('player.health <= '..PeFetch('NePConfigWarrFury', 'RallyingCry')) end)},
	-- Die by the Sword
  	{'118038', (function() return dynEval('player.health <= '..PeFetch('NePConfigWarrFury', 'DBTS')) end)}, 
  	-- Impending Victory
  	{'103840', (function() return dynEval('player.health <= '..PeFetch('NePConfigWarrFury', 'IVT')) end)}, 
  	 -- Enraged Regeneration
	{'55694', (function() return dynEval('player.health <= '..PeFetch('NePConfigWarrFury', 'ERG')) end)},
}

local Interrupts = {
	-- Pummel
	{'6552'},
	 -- Spell Reflection
	{'23920'},
}

local AoE = {
	
}

local inCombat = {
	{'Berserker Rage', {
		'!player.buff(Enrage)',
		'player.spell(Bloodthirst).cooldown > 5'
	}},
	{'Execute', 'player.buff(Sudden Death)'},
	{'Execute', 'player.rage > 80'},
	{'Wild Strike', 'player.rage > 90'},
	{'Wild Strike', 'player.buff(Bloodsurge)'},
	{'Raging Blow', 'player.spell(Raging Blow).stacks >= 2'},
	
	--Use Bloodthirst When you are not Enraged, if you have chosen the Unquenchable Thirst talent.

	{'Bloodthirst'},
	{'Bloodthirst', '!player.buff(Enrage)'},
	{'152277', nil, 'target.ground'}, -- Ravager // Talent
	{'Storm Bolt'},
	{'Dragon Roar'},
	{'Raging Blow'},
	{'Wild Strike', '!player.buff(Enrage)'},

	--Use Bloodthirst if you have chosen the Unquenchable Thirst talent.
}

local outCombat = {
	{All}
}

NeP.Engine.registerRotation(72, '[|cff'..NeP.Interface.addonColor..'NeP|r] Warrior - Fury', 
	{-- Incombat
		{All},
		{Interrupts, 'target.interruptAt(40)'},
		{Survival, 'player.health < 100'},
		{Cooldowns, 'modifier.cooldowns'},
		{inCombat}
	}, outCombat, exeOnLoad)