local dynEval = DarkNCR.dynEval
local PeFetch = NeP.Interface.fetchKey

local config = {
  key = 'NePConfPalaHoly',
  profiles = true,
  title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
  subtitle = 'Paladin Holy Settings',
  color = NeP.Core.classColor('player'),
  width = 250,
  height = 500,
  config = {
    -- General
    {type = 'rule'},
    {type = 'header', text = 'General settings:', align = 'center'},
		{type = 'checkbox', text = 'Run Faster', key = 'RunFaster', default = false},
		{type = 'checkbox', text = 'Crusader Strike', key = 'CrusaderStrike', default = true ,},
		{type = 'dropdown',
		  	text = 'Buff:', key = 'Buff', 
		  	list = {
			    {text = 'Kings',key = 'Kings'},
			    {text = 'Might',key = 'Might'}
		   }, 
			default = 'Kings', 
			desc = 'Select What buff to use The moust...' 
	   },
		{type = 'dropdown', text = 'Seal:', key = 'seal', 
		  	list = {
			    {text = 'Insight',key = 'Insight'},
			    {text = 'Command',key = 'Command'}
			}, 
			default = 'Insight', 
			desc = 'Select What Seal to use...' 
	   },
		{type = 'spinner', text = 'Holy Light', key = 'HolyLightOCC', default = 100, desc = 'Holy Light when outside of combat.'},

    -- Items
    {type = 'rule'},
    {type = 'header', text = 'Items settings:', align = 'center'},
		{type = 'spinner', text = 'Healthstone', key = 'Healthstone', default = 50},
		{type = 'spinner', text = 'Trinket 1', key = 'Trinket1', default = 85}, 
		{type = 'spinner', text = 'Trinket 2', key = 'Trinket2',default = 85},

    -- Survival
    {type = 'rule'},
    {type = 'header', text = 'Survival settings:', align = 'center'},
		{type = 'spinner', text = 'Divine Protection', key = 'DivineProtection', default = 90},
		{type = 'spinner', text = 'Divine Shield', key = 'DivineShield', default = 20},
		{type = 'rule'},
		{type = 'header', text = 'Proc\'s settings:', align = 'center'},
		{type = 'text', text = 'Divine Purpose: ', align = 'center'},
		{type = 'spinner', text = 'Word of Glory', key = 'WordofGloryDP', default = 80},
		{type = 'spinner', text = 'Eternal Flame', key = 'EternalFlameDP', default = 85},
		{type = 'text', text = 'Selfless Healer: ', align = 'center'},
		{type = 'spinner', text = 'Flash of light', key = 'FlashofLightSH', default = 85},
		{type = 'text', text = 'Infusion of Light: ', align = 'center'},
		{type = 'spinner', text = 'Holy Light', key = 'HolyLightIL', default = 100},

    -- Tank/Focus
    {type = 'rule'},
    {type = 'header', text = 'Tank/Focus settings:', align = 'center'},
		{type = 'spinner', text = 'Hand of Sacrifice', key = 'HandofSacrifice', default = 40},
		{type = 'spinner', text = 'Lay on Hands', key = 'LayonHandsTank', default = 15},
		{type = 'spinner', text = 'Flash of Light', key = 'FlashofLightTank', default = 40},
		{type = 'spinner', text = 'Execution Sentence', key = 'ExecutionSentenceTank', default = 80},
		{type = 'spinner', text = 'Eternal Flame', key = 'EternalFlameTank', default = 75, desc = 'With 3 Holy Power.'},
		{type = 'spinner', text = 'Word of Glory', key = 'WordofGloryTank', default = 80, desc = 'With 3 Holy Power.'},
		{type = 'spinner', text = 'Holy Shock', key = 'HolyShockTank', default = 100},
		{type = 'spinner', text = 'Holy Prism', key = 'HolyPrismTank', default = 85},
		{type = 'spinner', text = 'Sacred Shield', key = 'SacredShieldTank', default = 100, desc = 'With 1 charge or more.'},
		{type = 'spinner', text = 'Holy Light', key = 'HolyLightTank', default = 100},

    -- Raid/party
    {type = 'rule'},
    {type = 'header', text = 'Raid/Party settings:', align = 'center'},
      	{type = 'spinner', text = 'Lay on Hands', key = 'LayonHands', default = 15},
      	{type = 'spinner', text = 'Flash of Light', key = 'FlashofLight', default = 35},
      	{type = 'spinner', text = 'Execution Sentence', key = 'ExecutionSentence', default = 10},
      	{type = 'spinner', text = 'Eternal Flame', key = 'EternalFlame', default = 93, desc = 'With 1 Holy Power.'},
      	{type = 'spinner', text = 'Word of Glory', key = 'WordofGlory', default = 80, desc = 'With 3 Holy Power.'},
      	{type = 'spinner', text = 'Holy Shock', key = 'HolyShock', default = 100},
     	{type = 'spinner', text = 'Holy Prism', key = 'HolyPrism', default = 85},
      	{type = 'spinner', text = 'Sacred Shield', key = 'SacredShield', default = 80, desc = 'With 2 charge or more.'},
      	{type = 'spinner',text = 'Holy Light', key = 'HolyLight', default = 100},
	}
}

NeP.Interface.buildGUI(config)

local lib = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfPalaHoly') end)
end

local _All = {
	-- keybinds
	{'114158', 'modifier.shift', 'target.ground'}, -- Light´s Hammer
	{'!/focus [target=mouseover]', 'modifier.alt'}, -- Mouseover Focus
	-- Hand of Freedom
	{'1044', 'player.state.root'},
	-- Buffs
	{'20217', {-- Blessing of Kings
		'!player.buffs.stats',
		(function() return PeFetch('NePConfPalaHoly', 'Buff') == 'Kings' end),
	}, nil},
	{'19740', {-- Blessing of Might
		'!player.buffs.mastery',
		(function() return PeFetch('NePConfPalaHoly', 'Buff') == 'Might' end),
	}, nil}, 
	
	-- Seals
	{'20165', {-- seal of Insigh
		'player.seal != 2', 
		(function() return PeFetch('NePConfPalaHoly', 'seal') == 'Insight' end),
	}, nil}, 
	{'105361', {-- seal of Command
		'player.seal != 1',
		(function() return PeFetch('NePConfPalaHoly', 'seal') == 'Command' end),
	}, nil},
}

local _AoE = {
	-- Light of Dawn
	{'85222', {-- Party
		'@coreHealing.needsHealing(90, 3)', 
		'player.holypower >= 3',
		'modifier.party' 
	}},
	{'85222', {-- Raid
		'@coreHealing.needsHealing(90, 5)', 
		'player.holypower >= 3', 
		'modifier.raid', 
	}},
	-- Holy Radiance 
	{'82327', {-- Holy Radiance - Party
		'@coreHealing.needsHealing(80, 3)', 
		'!player.moving', 
		'modifier.party' 
	}, 'lowest'}, 
	{'82327', {-- Holy Radiance - Raid
		'@coreHealing.needsHealing(90, 5)', 
		'!player.moving', 
		'modifier.raid', 
	}, 'lowest'},  
}

local _InfusionOfLight = {
	{{-- AoE
		{'82327', {-- Holy Radiance - Party
			'@coreHealing.needsHealing(80, 3)', 
			'!player.moving'
		}, 'lowest'}, 
	}, 'modifier.multitarget'}, 
	{'82326', {-- Holy Light
		(function() return dynEval('lowest.health <= '..PeFetch('NePConfPalaHoly', 'HolyLightIL')) end),
		'!player.moving' 
	}, 'lowest'},
}

local _Fast = {
	{'!633', 'lowest.health <= 15', 'lowest'}, -- Lay on Hands
	{'!19750', {-- Flash of Light
		'lowest.health <= 30', 
		'!player.moving' 
	}, 'lowest'},
}

local _Tank = {
	{'633', {-- Lay on Hands
		(function() return dynEval('tank.health <= '..PeFetch('NePConfPalaHoly', 'LayonHandsTank')) end),
		'tank.spell(633).range'
	}, 'tank'},
	{'53563', {-- Beacon of light
		'!tank.buff(53563)', -- Beacon of light
		'!tank.buff(156910)', -- Beacon of Faith
		'tank.spell(53563).range' 
	}, 'tank'},
	{'6940', {-- Hand of Sacrifice
		'tank.spell(6940).range',
		(function() return dynEval('tank.health <= '..PeFetch('NePConfPalaHoly', 'HandofSacrifice')) end)
	}, 'tank'}, 
	{'19750', {-- Flash of Light
		(function() return dynEval('tank.health <= '..PeFetch('NePConfPalaHoly', 'FlashofLightTank')) end), 
		'!player.moving',
		'tank.spell(19750).range'
	}, 'tank'},
	{'114157', {-- Execution Sentence // Talent
		(function() return dynEval('tank.health <= '..PeFetch('NePConfPalaHoly', 'ExecutionSentenceTank')) end),
		'tank.spell(114157).range'
	}, 'tank'},
	{'148039', {-- Sacred Shield // Talent
		'player.spell(148039).charges >= 1', 
		(function() return dynEval('tank.health <= '..PeFetch('NePConfPalaHoly', 'SacredShieldTank')) end), 
		'!tank.buff(148039)', -- SS
		'tank.range < 40' 
	}, 'tank'},
	{'114163', {-- Eternal Flame // talent
			'player.holypower >= 3', 
		'!tank.buff(114163)',
		'focus.spell(114163).range',
		(function() return dynEval('lowest.health <= '..PeFetch('NePConfPalaHoly', 'EternalFlameTank')) end)
	}, 'tank'},
	{'85673', {-- Word of Glory
		'player.holypower >= 3',
		'focus.spell(85673).range',
		(function() return dynEval('lowest.health <= '..PeFetch('NePConfPalaHoly', 'WordofGloryTank')) end)
	}, 'tank' },
	{'114165', {-- Holy Prism // Talent
		(function() return dynEval('tank.health <= '..PeFetch('NePConfPalaHoly', 'HolyPrismTank')) end), 
		'!player.moving',
		'tank.spell(114165).range' 
	}, 'tank'},
	{'82326', {-- Holy Light
		(function() return dynEval('tank.health < '..PeFetch('NePConfPalaHoly', 'HolyLightTank')) end),
		'!player.moving',
		'focus.spell(82326).range' 
	}, 'tank'},
}

local _Focus = {
	{'633', {-- Lay on Hands
		(function() return dynEval('focus.health <= '..PeFetch('NePConfPalaHoly', 'LayonHandsTank')) end),
		'focus.spell(633).range'
	}, 'focus'}, 
	{'6940', {-- Hand of Sacrifice
		'focus.spell(6940).range',
		(function() return dynEval('focus.health <= '..PeFetch('NePConfPalaHoly', 'HandofSacrifice')) end)
	}, 'focus'},
	{'19750', {-- Flash of Light
		(function() return dynEval('focus.health <= '..PeFetch('NePConfPalaHoly', 'FlashofLightTank')) end), 
		'!player.moving',
		'focus.spell(19750).range'
	}, 'focus'},
	{'114157', {-- Execution Sentence // Talent
		(function() return dynEval('focus.health <= '..PeFetch('NePConfPalaHoly', 'ExecutionSentenceTank')) end),
		'focus.spell(114157).range'
	}, 'focus'},
	{'148039', {-- Sacred Shield // Talent
		'player.spell(148039).charges >= 1', 
		(function() return dynEval('focus.health <= '..PeFetch('NePConfPalaHoly', 'SacredShieldTank')) end), 
		'!focus.buff(148039)', 
		'focus.range < 40' 
	}, 'focus'},
	{'114163', {-- Eternal Flame // talent
		'player.holypower >= 3', 
		'!focus.buff(114163)',
		'focus.spell(114163).range',
		(function() return dynEval('lowest.health <= '..PeFetch('NePConfPalaHoly', 'EternalFlameTank')) end)
	}, 'focus'},
	{'85673', {-- Word of Glory
		'player.holypower >= 3',
		'focus.spell(85673).range',
		(function() return dynEval('lowest.health <= '..PeFetch('NePConfPalaHoly', 'WordofGloryTank')) end) 
	}, 'focus'},
	{'114165', {-- Holy Prism // Talent
		'player.holypower >= 3',
		(function() return dynEval('focus.health <= '..PeFetch('NePConfPalaHoly', 'HolyPrismTank')) end), 
		'!player.moving',
		'focus.spell(114165).range' 
	}, 'focus'},
	{'82326', {-- Holy Light
		(function() return dynEval('focus.health < '..PeFetch('NePConfPalaHoly', 'HolyLightTank')) end),
		'!player.moving',
		'focus.spell(82326).range' 
	}, 'focus'},
}

local _Player = {
	-- Items
	{'#5512', (function() return dynEval('player.health <= '..PeFetch('NePConfPalaHoly', 'Healthstone')) end), nil}, -- Healthstone
	{'#trinket1', (function() return dynEval('player.mana <= '..PeFetch('NePConfPalaHoly', 'Trinket1')) end), nil}, -- Trinket 1
	{'#trinket2', (function() return dynEval('player.mana <= '..PeFetch('NePConfPalaHoly', 'Trinket2')) end), nil}, -- Trinket 2
	{{-- Beacon of Faith
		{'156910', {
			'!player.buff(53563)', -- Beacon of light
			'!player.buff(156910)' -- Beacon of Faith
		}, 'player'},
	}, 'talent(7,1)'},
	{'498', (function() return dynEval('player.health <= '..PeFetch('NePConfPalaHoly', 'DivineProtection')) end), nil}, -- Divine Protection
	{'642', (function() return dynEval('player.health <= '..PeFetch('NePConfPalaHoly', 'DivineShield')) end), nil}, -- Divine Shield
	{'148039', {-- Sacred Shield // Talent
		'player.spell(148039).charges >= 2', 
		(function() return dynEval('player.health <= '..PeFetch('NePConfPalaHoly', 'SacredShield')) end), 
		'!player.buff(148039)' 
	}, 'player'},
}

local _Cooldowns = {
	{'#gloves'}, -- gloves
	{'31821', '@coreHealing.needsHealing(40, 5)', nil}, -- Devotion Aura	
	{'31884', '@coreHealing.needsHealing(95, 4)', nil}, -- Avenging Wrath
	{'86669', '@coreHealing.needsHealing(85, 4)', nil}, -- Guardian of Ancient Kings
	{'31842', '@coreHealing.needsHealing(90, 4)', nil}, -- Divine Favor
	{'105809', 'talent(5, 1)', nil}, -- Holy Avenger
}

local inCombat = {
	{{-- Interrupts
		{'96231', 'target.range <= 6', 'target'},-- Rebuke
	}, 'target.interruptAt(40)'},
	{'35395', {-- Crusader Strike
		'target.range < 5',
		'target.infront',
		(function() return PeFetch('NePConfPalaHoly', 'CrusaderStrike') end) 
	}, 'target'},
}

local _BeaconOfInsight = {
	{'157007', nil, 'lowest'},
	{'19750', {-- flash of light
		'lowest.health <= 40', 
		'!player.moving' 
	}, 'lowest'},
	{'82326', {-- Holy Light
		'lowest.health < 80',
		'!player.moving' 
	}, 'lowest'},
}

local _DivinePurpose = {
	{'85222', {-- Light of Dawn
		'@coreHealing.needsHealing(90, 3)', 
		'player.holypower >= 1',
		'modifier.party' 
	}},
	{'85673', (function() return dynEval('lowest.health <= '..PeFetch('NePConfPalaHoly', 'WordofGloryDP')) end), 'lowest' }, -- Word of Glory
	{'114163', {-- Eternal Flame
		'!lowest.buff(114163)', 
		(function() return dynEval('lowest.health <= '..PeFetch('NePConfPalaHoly', 'EternalFlameDP')) end) 
	}, 'lowest'},
}

local _SelflessHealer = {
	{'20271', 'target.spell(20271).range', 'target'}, -- Judgment
	{{-- If got buff
		{'19750', {-- Flash of light
			(function() return dynEval('lowest.health <= '..PeFetch('NePConfPalaHoly', 'FlashofLightSH')) end),  
			'!player.moving' 
		}, 'lowest'}, 
	}, 'player.buff(114250).count = 3'}
}

local _Raid = {
	-- Lay on Hands
	{'633', (function() return dynEval('lowest.health <= '..PeFetch('NePConfPalaHoly', 'LayonHands')) end), 'lowest'}, 
	{'19750', {-- Flash of Light
		(function() return dynEval('lowest.health <= '..PeFetch('NePConfPalaHoly', 'FlashofLight')) end), 
		'!player.moving' 
	}, 'lowest'},
	-- Execution Sentence // Talent
	{'114157', (function() return dynEval('lowest.health <= '..PeFetch('NePConfPalaHoly', 'ExecutionSentence')) end), 'lowest'},
	{'148039', {-- Sacred Shield // Talent
		'player.spell(148039).charges >= 2', 
		(function() return dynEval('lowest.health <= '..PeFetch('NePConfPalaHoly', 'SacredShield')) end), 
		'!lowest.buff(148039)' 
	}, 'lowest'},
	{'114163', {-- Eternal Flame // talent
		'player.holypower >= 1', 
		'!lowest.buff(114163)', 
		(function() return dynEval('lowest.health <= '..PeFetch('NePConfPalaHoly', 'EternalFlame')) end)
	}, 'lowest'},
	{'85673', {-- Word of Glory
		'player.holypower >= 3', 
		(function() return dynEval('lowest.health <= '..PeFetch('NePConfPalaHoly', 'WordofGlory')) end)
	}, 'lowest' },
	{'114165', {-- Holy Prism // Talent
		(function() return dynEval('lowest.health <= '..PeFetch('NePConfPalaHoly', 'HolyPrism')) end), 
		'!player.moving' 
	}, 'lowest'},
	{'82326', {-- Holy Light
		(function() return dynEval('lowest.health < '..PeFetch('NePConfPalaHoly', 'HolyLight')) end),
		'!player.moving' 
	}, 'lowest'},
}

local outCombat = {
	-- Start
	{'20473', 'lowest.health < 100', 'lowest'}, -- Holy Shock
	{{-- AoE
		-- Light of Dawn
		{'85222', {-- Party
			'@coreHealing.needsHealing(90, 3)', 
			'player.holypower >= 3',
			'modifier.party' 
		}},
		{'85222', {-- Raid
			'@coreHealing.needsHealing(90, 5)', 
			'player.holypower >= 3', 
			'modifier.raid', 
			'!modifier.raid' 
		}}, 
		-- Holy Radiance 
		{'82327', {-- Holy Radiance - Party
			'@coreHealing.needsHealing(80, 3)', 
			'!player.moving', 
			'modifier.party' 
		}, 'lowest'}, 
		{'82327', {-- Holy Radiance - Raid
			'@coreHealing.needsHealing(90, 5)',  
			'!player.moving', 
			'modifier.raid', 
		}, 'lowest'},
	}, 'modifier.multitarget'},
	-- Holy Light
	{'82326', {
		(function() return dynEval('lowest.health < '..PeFetch('NePConfPalaHoly', 'HolyLightOCC')) end),
		'!player.moving' 
	}, 'lowest'},
}

NeP.Engine.registerRotation(65, '[|cff'..NeP.Interface.addonColor..'NeP|r] Paladin - Holy', 
	{-- In-Combat
		{_All},
		-- Dispell
		{'4987', 'player.dispellAll(4987)'},
		-- Holy Shock
		{'20473', 'lowest.health < 100', 'lowest'}, 
		{_Fast},
		{inCombat},
		{_BeaconOfInsight, 'talent(7,2)'},
		{_InfusionOfLight, 'player.buff(54149)'},
		{_DivinePurpose, 'player.buff(86172)'},
		{_SelflessHealer, 'talent(3, 1)'},
		{_Cooldowns, 'modifier.cooldowns'},
		{_AoE, 'modifier.multitarget'},
		{_Tank},
		{_Focus},
		{_Player},
		{_Raid}
	},{-- Out-Combat
		{_All},
		{outCombat}
	}, lib)