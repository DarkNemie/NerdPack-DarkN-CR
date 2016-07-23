local dynEval = DarkNCR.dynEval
local fetchKey = NeP.Interface.fetchKey

local config = {
	key = 'NePConfigRogueCombat',
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Rogue Combat Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{type = 'header', text = 'General:', align = 'center'},
			-- ...Empty...
			{type = 'text', text = 'Nothing here yet... :C', align = 'center'},
		-- Poisons
		{type = "spacer"},{type = 'rule'},
		{type = 'header', text = 'Poisons:', align = 'center'},
			-- Letal Poison
			{type = 'dropdown', text = 'Letal Posion', key = 'LetalPosion',
		      	list = {
			        {text = 'Wound Posion', key = 'Wound'},
			        {text = 'Deadly Posion', key = 'Deadly'},
			   },
		    	default = 'Deadly',
		    	desc = 'Select what Letal Posion to use.'
		   },
		    -- Non-Letal Poison
			{type = 'dropdown',text = 'Non-Letal Posion',key = 'NoLetalPosion',
		      	list = {
			        {text = 'Crippling Poison', key = 'Crippling'},
			        {text = 'Leeching Posion', key = 'Leeching'},
			   },
		    	default = 'Crippling',
		    	desc = 'Select what Non-Letal Posion to use.'
		   },
		-- Survival
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = 'Survival:', align = 'center'},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', width = 50, default = 75},
	}
}

NeP.Interface.buildGUI(config)

local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfigRogueCombat') end)
end

local Cooldowns = {
	-- Vanish
	{'1856'},
	-- Preparation
	{'Preparation', 'player.spell(Vanish).cooldown >= 10'},
	-- Adrenaline Rush
	{'Adrenaline Rush', 'player.energy < 20'},
	-- Killing Spree
	{'Killing Spree', {
		'player.energy < 20',
		'player.spell(Adrenaline Rush).cooldown >= 10'
	}},
}

local Survival = {
	-- Healthstone
	{'#5512', (function() return dynEval('player.health <= '..fetchKey('NePConfigRogueCombat', 'Healthstone')) end)},
	-- Recuperate
	{'73651',{
		'player.combopoints <= 3',
		'player.health < 100',
		'player.buff(73651).duration <= 5'
	}},
	-- Tricks of the Trade
	{'57934', 'player.agro > 60', 'tank'},
}

local AoE = {
	-- Blade Flurry
	{'13877', '!player.buff(13877)'},
	-- Crimson Tempest
	{'Crimson Tempest', {'player.combopoints >= 5', '@DarkNCR.aDot(2)'}},
}

local ST = {
	-- Remove Blade Flurry
	{'13877', {'player.buff(13877)', '!player.area(7).enemies >= 2'}},
	-- Slice and Dice // Dont let it go off!
	{'5171', 'player.buff(Slice and Dice).duration < 4'},

	{{-- Finishing Moves
		-- Slice and Dice. Refresh it when it has less than 10 seconds remaining.
		{'5171', 'player.buff(5171).duration < 10'},
		-- Eviscerate with 5 Combo Points.
		{'2098', nil, 'target'},
	}, 'player.combopoints >= 5'},

	-- Revealing Strike only to keep its debuff up; you can refresh it when it has 6 seconds or less remaining.
	{'84617', 'target.debuff(84617).duration <= 6', 'target'},
	-- Sinister Strike.
	{'1752'}
}

local outCombat = {

	-- Ambush after vanish
	{'8676', {
		'target.alive',
		'lastcast(1856)' -- Vanish
	}, 'target'},

	-- Deadly Poison / Letal
	{'2823', {
		'!lastcast(2823)',
		'!player.buff(2823)',
		(function() return fetchKey('NePConfigRogueCombat', 'LetalPosion') == 'Deadly' end)
	}},
	-- Deadly Poison / Letal
	{'8679', {
		'!lastcast(8679)',
		'!player.buff(8679)',
		(function() return fetchKey('NePConfigRogueCombat', 'LetalPosion') == 'Wound' end)
	}},
	
	-- Crippling Poison / Non-Letal
	{'3408', {
		'!lastcast(3408)',
		'!player.buff(3408)',
		(function() return fetchKey('NePConfigRogueCombat', 'NoLetalPosion') == 'Crippling' end)
	}},
	-- Leeching Poison / Non-Letal
	{'108211', {
		'!lastcast(108211)',
		'!player.buff(108211)',
		(function() return fetchKey('NePConfigRogueCombat', 'NoLetalPosion') == 'Leeching' end)
	}},
}

NeP.Engine.registerRotation(260, '[|cff'..NeP.Interface.addonColor..'NeP|r] Rogue - Combat', 
	{-- In-Combat
		{{-- Dont Break Sealth && Melee Range
			-- Kick
			{'1766', 'target.interruptAt(40)'},
			-- Marked for Death
			{'Marked for Death', {
				'player.combopoints = 0',
				'target.tdd < 60'
			}},
			-- Evasion
			{'5277', 'player.health < 30'},
			{Cooldowns, 'modifier.cooldowns'},
			{AoE, 'player.area(7).enemies >= 2'},
			{ST},
		}, {'!player.buff(Vanish)', 'target.range < 7'}},
	}, outCombat, exeOnLoad)