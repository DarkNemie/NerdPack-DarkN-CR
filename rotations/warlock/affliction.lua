local config = {
	key = 'NePConfWarlockAff',
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Warlock Affliction Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		{type = 'text', text = 'Keybinds', align = 'center'},		
			--stuff
		{type = 'spacer'},{type = 'rule'},
		{type = 'text', text = 'DPS', align = 'center'},
			--stuff
		{type = 'spacer'},{type = 'rule'},
		{type = 'text', text = 'Survival', align = 'center'},
			--stuff
	}
}

NeP.Interface.buildGUI(config)

local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfWarlockAff') end)
end

local Shared = {
	-- Buff
	{'Dark Intent', '!player.buff(Dark Intent)'},
}

local Cooldowns = {
	
}

local Moving = {
	
}

local AoE = {
	{{-- Against 4 or more enemies, 
		-- you should start replacing Drain Soul with Seed of Corruption as your filler spell. 
			-- FIXME: TO BE DONE
		-- Use Soulburn Icon Soulburn+Seed of Corruption to apply Corruption and prioritise maintaining Agony over Unstable Affliction. 
			-- FIXME: TO BE DONE
		-- If you need burst AoE damage, you should simply spam Seed of Corruption, as DoTs will not have enough time to tick.
			-- FIXME: TO BE DONE
		-- If Cataclysm is your Tier 7 talent, then you need to use it on cooldown.
		{'Cataclysm', nil, 'target.ground'},
	}, 'player.area(40).enemies >= 4' },

	{{-- Against 2 and 3 enemies, 
		-- use your normal rotation on one of them and keep your DoTs up on the others.
		{'Agony', '@DarkNCR.aDot(2)'},
		{'Corruption', '@DarkNCR.aDot(2)'},
		{'Unstable Affliction', '@DarkNCR.aDot(2)'},
	}, 'player.area(40).enemies >= 2' },
}

local inCombat = {
	-- Apply Agony and refresh it when it has less than 7.2 seconds remaining.
	{'Agony', 'target.debuff(Agony).duration <= 7.2', 'target'},
	-- Apply Corruption and refresh it when it has less than 5.4 seconds remaining.
	{'Corruption', 'target.debuff(Corruption).duration <= 5.4', 'target'},
	-- Apply Unstable Affliction and refresh it when it has less than 4.2 seconds remaining.
	{'Unstable Affliction', 'target.debuff(Unstable Affliction).duration <= 4.2', 'target'},
	
	{{ -- Cast Haunt Icon Haunt when: one of the following is true
		-- you have a trinket proc;
			-- FIXME: TO BE DONE
		-- Dark Soul: Misery Icon Dark Soul: Misery is up;
		{'Haunt', 'player.buff(Dark Soul: Misery)', 'target'},
		-- the boss is approaching death;
		{'Haunt', {
			'target.boss',
			'target.ttd < 15'
		}, 'target'},
		-- you have at least 3 Soul Shards (so that you have Soul Shards left when Dark Soul is up).
		{'Haunt', 'player.soulshards >= 3', 'target'},
	},{
		{'!target.debuff(Haunt)'},
		{'player.soulshards >= 4'},
	}},
	
	-- Cast Drain Soul as a filler.
	{'Drain Soul'},
}

local outCombat = {
	{Shared},
}

NeP.Engine.registerRotation(265, '[|cff'..NeP.Interface.addonColor..'NeP|r] Warlock - Affliction',
	{ -- In-Combat
		{Shared},
		{Moving, "player.moving"},
		{{ -- Conditions
			{Cooldowns, "modifier.cooldowns"},
			{'Life Tap', {'player.mana < 20', '!player.health < 30'}},
			{AoE},
			{inCombat}
		}, "!player.moving" },
	},outCombat, exeOnLoad)