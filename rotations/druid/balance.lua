local dynEval = DarkNCR.dynEval
local fetchKey = NeP.Interface.fetchKey

local config = {
	key = 'NePConfDruidBalance',
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Druid Balance Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General settings:', align = 'center'},
			-- Buff
			{type = 'checkbox', text = 'Buffs', key = 'Buffs', default = true, desc =
			 'This checkbox enables or disables the use of automatic buffing.'},

	}
}

NeP.Interface.buildGUI(config)

local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfDruidBalance') end)
end

local All = {
	-- Buff
	{'#128475', '!player.buff(175457)'},
	{'1126', { -- Mark of the Wild
		'!player.aura(stats)',
		'!player.buff(5215)',-- Not in Stealth
		'player.form = 0', -- Player not in form
		(function() return fetchKey('NePConfDruidBalance', 'Buffs', true) end),
	}},
	--Shared Stuff
	{'20484', {-- Rebirth
		'modifier.lshift',
		'!mouseover.alive'
	}, 'mouseover'},
}

local MoomkinForm = {
			
	{{-- Interrupts
		{'78675'}, -- Solar Beam
	}, 'target.interruptsAt(40)'},
	
	{{-- Cooldowns
		{'#trinket1'},
		{'#trinket2'},
		--{'#57723', 'player.hashero'}, --  Int Pot on lust
		{'112071'}, -- Celestial Alignment
		{'102560'} -- Incarnation
	}, 'modifier.cooldowns'},

	--Defensive
	{'Barkskin', 'player.health <= 50', 'player'},
	{'#5512', 'player.health < 40'}, -- Healthstone when less than 40% health
	{'108238', 'player.health < 60', 'player'}, -- Instant renewal when less than 40% health

	-- AoE
	{'48505', {'player.area(40).enemies >= 8', '!player.buff(184989)'}}, -- Starfall
	
	-- Proc's
	{'78674', 'player.buff(Shooting Stars)', 'target'}, -- Starsurge with Shooting Stars Proc
	{'164815', 'player.buff(Solar Peak)', 'target'}, -- SunFire on proc
	{'164812', 'player.buff(Lunar Peak)', 'target'}, -- MoonFire on proc
	
	-- Rotation
	{'78674', {-- StarSurge with more then 2 charges
		'player.spell(78674).charges >= 2',
		'!spell.castwithin < 2'
	}},
	{'78674', {-- StarSurge with Celestial Alignment buff
		'player.buff(112071)',
		'!spell.castwithin < 2'
	}},
	{'164812', '@DarkNCR.aDot(2)'}, -- Moonfire
	{'164815', '@DarkNCR.aDot(2)'}, --SunFire
	{'2912', 'player.buff(164574).count >= 1'}, -- Starfire with Lunar Empowerment
	{'5176', 'player.buff(164545).count >= 1'}, -- Wrath with Solar Empowerment
	{'2912', {-- StarFire
		'player.eclipseRaw <= 20',
		'player.lunar'
	}},
	{'5176', {-- Wrath
		'player.eclipseRaw >= -20',
		'player.solar'
	}},
	{'2912', {-- StarFire
		'player.eclipseRaw <= 0',
		'player.solar'
	}},
	{'5176', {--Wrath
		'player.eclipseRaw >= 0',
		'player.lunar'
	}},
	{'2912'}, -- StarFire Filler
}

local inCombat = {
	{All},
	{MoomkinForm, 'player.buff(24858)'}
}

local outCombat = {
	{All},
}

NeP.Engine.registerRotation(102, '[|cff'..NeP.Interface.addonColor..'NeP|r] Druid - Balance', inCombat,outCombat, exeOnLoad)
