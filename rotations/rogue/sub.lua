local dynEval = DarkNCR.dynEval
local PeFetch = NeP.Interface.fetchKey

local config = {
	key = 'NePConfigRogueSub',
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Rogue Subtlety Settings',
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
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfigRogueSub') end)
	NeP.Interface.CreateToggle(
		'MfD', 
		'Interface\\Icons\\Ability_hunter_assassinate.png', 
		'Marked for Death', 
		'Use Marked for Death \nBest used for targets that will die under a minute.')
end

local Cooldowns = {
	{'Shadow Reflection'},
	{'Preparation', 'player.spell(Vanish).cooldown <= 0'},
	{'Shadow Dance', 'player.energy > 75'},
	{'Vanish', 'player.spell(Premeditation).cooldown <= 0'},
}

local AoE = {
	{'Slice and Dice', { -- Slice and Dice // Refresh
		'player.buff(Slice and Dice).duration <= 3',
		'player.combopoints >= 3'
	}},
	{'Crimson Tempest', 'player.combopoints >= 5'}, -- Crimson Tempest // DUMP CP
	{'Hemorrhage', 'target.debuff(Hemorrhage).duration <= 7'}, -- Hemorrhage to apply dot
	{'Ambush'},
	{'Fan of Knives'},
}

local ST = {
	-- Slice and Dice // Refresh
	{'Slice and Dice', {
		'player.buff(Slice and Dice).duration <= 3',
		'player.combopoints <= 2'
	}},
	-- Rupture to apply dot
	{'Rupture', {
		'player.combopoints >= 5',
		'target.debuff(Rupture).duration <= 7'
	}},
	-- Eviscerate // Dump CP
	{'Eviscerate', {
		'player.combopoints >= 5',
	}},
	-- Hemorrhage to apply dot
	{'Hemorrhage', {
		'target.debuff(Hemorrhage).duration <= 7',
	}},
	{'Ambush'},
	{'Backstab', 'player.behind'},
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
		(function() return NeP.Interface.fetchKey('NePConfigRogueSub', 'LetalPosion') == 'Deadly' end)
	}},
	{'8679', { -- Deadly Poison / Letal
		'!lastcast(8679)',
		'!player.buff(8679)',
		(function() return NeP.Interface.fetchKey('NePConfigRogueSub', 'LetalPosion') == 'Wound' end)
	}},
	
	-- Non-Letal Poisons
	{'3408', { -- Crippling Poison / Non-Letal
		'!lastcast(3408)',
		'!player.buff(3408)',
		(function() return NeP.Interface.fetchKey('NePConfigRogueSub', 'NoLetalPosion') == 'Crippling' end)
	}},
	{'108211', { -- Leeching Poison / Non-Letal
		'!lastcast(108211)',
		'!player.buff(108211)',
		(function() return NeP.Interface.fetchKey('NePConfigRogueSub', 'NoLetalPosion') == 'Leeching' end)
	}}
}

NeP.Engine.registerRotation(261, '[|cff'..NeP.Interface.addonColor..'NeP|r] Rogue - Subtlety', 
	{-- In-Combat
		{{ -- Dont Break Sealth && Melee Range
			{{-- Interrupts
				{ 'Kick' },
			}, 'target.interruptAt(40)' },
			{'Recuperate',{
				'player.combopoints <= 3',
				'player.health < 35',
				'player.buff(Recuperate).duration <= 5'
			}},
			{'Marked for Death', {
				'player.combopoints = 0',
				'toggle.MfD'
			}},
			{'Premeditation', 'player.buff(Vanish)'},
			{'Premeditation', 'player.buff(Shadow Dance)'},
			{'Tricks of the Trade', 'player.aggro > 60', 'tank'},
			{'Evasion', 'player.health < 30'},
			{Cooldowns, 'modifier.cooldowns' },
			{AoE, 'player.area(10).enemies >= 3' },
			{ST, '!modifier.multitarget' },
		}, {'!player.buff(Vanish)', 'target.range < 7'} },
	}, outCombat, exeOnLoad)