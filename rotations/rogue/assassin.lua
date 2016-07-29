local dynEval = DarkNCR.dynEval
local PeFetch = NeP.Interface.fetchKey

local config = {
	key = 'NePConfigRogueAss',
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Rogue Assassination Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{ type = 'header', text = 'General:', align = 'center' },
			-- ...Empty...
			{ type = 'text', text = 'Nothing here yet... :C', align = 'center' },
		-- Poisons
		{ type = "spacer" },{ type = 'rule' },
		{ type = 'header', text = 'Poisons:', align = 'center' },
			-- Letal Poison
			{ type = 'dropdown', text = 'Letal Posion', key = 'LetalPosion',
		      	list = {
			        {text = 'Wound Posion', key = 'Wound'},
			        {text = 'Deadly Posion', key = 'Deadly'},
			    },
		    	default = 'Deadly',
		    	desc = 'Select what Letal Posion to use.'
		    },
		    -- Non-Letal Poison
			{ type = 'dropdown',text = 'Non-Letal Posion',key = 'NoLetalPosion',
		      	list = {
			        {text = 'Crippling Poison', key = 'Crippling'},
			        {text = 'Leeching Posion', key = 'Leeching'},
			    },
		    	default = 'Crippling',
		    	desc = 'Select what Non-Letal Posion to use.'
		    },
		-- Survival
		{ type = 'spacer' },{ type = 'rule' },
		{ type = 'header', text = 'Survival:', align = 'center'},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', width = 50, default = 75},
	}
}

NeP.Interface.buildGUI(config)

local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfigRogueAss') end)
	NeP.Interface.CreateToggle(
		'MfD', 
		'Interface\\Icons\\Ability_hunter_assassinate.png', 
		'Marked for Death', 
		'Use Marked for Death \nBest used for targets that will die under a minute.')
end

local Cooldowns = {
	{ '1856', 'player.energy >= 60' }, -- Vanish
	{ 'Shadow Reflection' }, -- Shadow Reflection // TALENT (FIXME: ID)
	{ '14185', 'player.spell(1856).cooldown >= 10' }, -- Preparation
	{ '79140', '!player.moving' }, -- Vendetta
}

local Survival = {
	{ '73651', { -- Recuperate
		'player.combopoints <= 3',
		'player.health < 35',
		'player.buff(73651).duration <= 5'
	}},
	{ '5277', 'player.health < 30' }, -- Evasion
	{ '57934', 'player.aggro > 60', 'tank'}, -- Tricks of the Trade
	{ '57934', 'player.aggro > 60', 'focus'}, -- Tricks of the Trade
	{ '#5512', (function() return dynEval('player.health <= ' .. PeFetch('NePConfigRogueAss', 'Healthstone')) end) }, --Healthstone
}

local inCombat = {
	{'137619', { -- Marked for Death
		'player.combopoints = 0',
		'toggle.MfD'
	}},
	{'1943', { -- Rupture
		'player.combopoints >= 5',
		'@DarkNCR.aDot(7)'
	}, 'target' },
	{ '32645', 'player.combopoints >= 5', 'target' }, -- Envenom
	{ '111240', 'target.health <= 35', 'target' }, -- Dispatch
	{ '111240', 'player.buff(121153)', 'target' }, -- Dispatch w/ Proc Blindside
	-- AoE
		{ '51723', 'player.area(10).enemies >= 3'}, -- Fan of Knives
	{ '1329', 'target.health >= 35', 'target' }, -- Mutilate
}

local outCombat = {
	{'8676', { -- Ambush after vanish
		'target.alive',
		'lastcast(1856)' -- Vanish
	}, 'target' },

	-- Letal Poisons
	{'2823', { -- Deadly Poison / Letal
		'!lastcast(2823)',
		'!player.buff(2823)',
		(function() return NeP.Interface.fetchKey('NePConfigRogueAss', 'LetalPosion') == 'Deadly' end)
	}},
	{'8679', { -- Deadly Poison / Letal
		'!lastcast(8679)',
		'!player.buff(8679)',
		(function() return NeP.Interface.fetchKey('NePConfigRogueAss', 'LetalPosion') == 'Wound' end)
	}},
	
	-- Non-Letal Poisons
	{'3408', { -- Crippling Poison / Non-Letal
		'!lastcast(3408)',
		'!player.buff(3408)',
		(function() return NeP.Interface.fetchKey('NePConfigRogueAss', 'NoLetalPosion') == 'Crippling' end)
	}},
	{'108211', { -- Leeching Poison / Non-Letal
		'!lastcast(108211)',
		'!player.buff(108211)',
		(function() return NeP.Interface.fetchKey('NePConfigRogueAss', 'NoLetalPosion') == 'Leeching' end)
	}}
}

NeP.Engine.registerRotation(259, '[|cff'..NeP.Interface.addonColor..'NeP|r] Rogue - Assassination', 
	{-- In-Combat
		{{ -- Dont Break Sealth && Melee Range
			{{-- Interrupts
				{ '1766' }, -- Kick
			}, 'target.interruptAt(40)' },
			{Survival},
			{Cooldowns, 'modifier.cooldowns' },
			{inCombat},
		}, { '!player.buff(1856)', 'target.range < 7' } },
	}, outCombat, exeOnLoad)