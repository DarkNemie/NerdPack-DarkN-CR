local myCR 		= 'DarkNCR'									-- Change this to something Unique
local myClass 	= 'Paladin'									-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'Holy'									-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
----------	Do not change unless you know what your doing ----------
local mKey 		=  myCR ..mySpec ..myClass					-- Do not change unless you know what your doing
local Sidnum 	= DarkNCR.classSpecNum[myClass..mySpec]	-- Do not change unless you know what your doing
local config 	= {
	key 	 = mKey,
	profiles = true,
	title 	 = '|T'..DarkNCR.Interface.Logo..':10:10|t' ..myCR.. ' ',
	subtitle = ' ' ..mySpec.. ' '..myClass.. ' Settings',
	color 	 = NeP.Core.classColor('player'),	
	width 	 = 250,
	height 	 = 500,
	config 	 = {
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 50},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Class Specific Settings', align = 'center'},
			

		}
}

NeP.Interface.buildGUI(config)
local E = DarkNCR.dynEval
local F = function(key) return NeP.Interface.fetchKey(mKey, key, 100) end

local exeOnLoad = function()
	DarkNCR.Splash()
	DarkNCR.ClassSetting(mKey)
end

local healthstn = function() 
	return E('player.health <= ' .. F('Healthstone')) 
end
--------------- END of do not change area ----------------
--
--	The Fetch and dynaEval functions below have been updated, 
--	if there is errors look there first, new skills have not been updated
--
---------- This Starts the Area of your Rotaion ----------
local _All = {
	-- keybinds
	{'114158', 'modifier.shift', 'target.ground'}, -- Light´s Hammer
	{'!/focus [target=mouseover]', 'modifier.alt'}, -- Mouseover Focus
	-- Hand of Freedom
	{'1044', 'player.state.root'},
	-- Buffs
	{'20217', {-- Blessing of Kings
		'!player.buffs.stats',
		(function() return F('Buff') == 'Kings' end),
	}, nil},
	{'19740', {-- Blessing of Might
		'!player.buffs.mastery',
		(function() return F('Buff') == 'Might' end),
	}, nil}, 
	
	-- Seals
	{'20165', {-- seal of Insigh
		'player.seal != 2', 
		(function() return F('seal') == 'Insight' end),
	}, nil}, 
	{'105361', {-- seal of Command
		'player.seal != 1',
		(function() return F('seal') == 'Command' end),
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
		(function() return E('lowest.health <= '..F('HolyLightIL')) end),
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
		(function() return E('tank.health <= '..F('LayonHandsTank')) end),
		'tank.spell(633).range'
	}, 'tank'},
	{'53563', {-- Beacon of light
		'!tank.buff(53563)', -- Beacon of light
		'!tank.buff(156910)', -- Beacon of Faith
		'tank.spell(53563).range' 
	}, 'tank'},
	{'6940', {-- Hand of Sacrifice
		'tank.spell(6940).range',
		(function() return E('tank.health <= '..F('HandofSacrifice')) end)
	}, 'tank'}, 
	{'19750', {-- Flash of Light
		(function() return E('tank.health <= '..F('FlashofLightTank')) end), 
		'!player.moving',
		'tank.spell(19750).range'
	}, 'tank'},
	{'114157', {-- Execution Sentence // Talent
		(function() return E('tank.health <= '..F('ExecutionSentenceTank')) end),
		'tank.spell(114157).range'
	}, 'tank'},
	{'148039', {-- Sacred Shield // Talent
		'player.spell(148039).charges >= 1', 
		(function() return E('tank.health <= '..F('SacredShieldTank')) end), 
		'!tank.buff(148039)', -- SS
		'tank.range < 40' 
	}, 'tank'},
	{'114163', {-- Eternal Flame // talent
			'player.holypower >= 3', 
		'!tank.buff(114163)',
		'focus.spell(114163).range',
		(function() return E('lowest.health <= '..F('EternalFlameTank')) end)
	}, 'tank'},
	{'85673', {-- Word of Glory
		'player.holypower >= 3',
		'focus.spell(85673).range',
		(function() return E('lowest.health <= '..F('WordofGloryTank')) end)
	}, 'tank' },
	{'114165', {-- Holy Prism // Talent
		(function() return E('tank.health <= '..F('HolyPrismTank')) end), 
		'!player.moving',
		'tank.spell(114165).range' 
	}, 'tank'},
	{'82326', {-- Holy Light
		(function() return E('tank.health < '..F('HolyLightTank')) end),
		'!player.moving',
		'focus.spell(82326).range' 
	}, 'tank'},
}

local _Focus = {
	{'633', {-- Lay on Hands
		(function() return E('focus.health <= '..F('LayonHandsTank')) end),
		'focus.spell(633).range'
	}, 'focus'}, 
	{'6940', {-- Hand of Sacrifice
		'focus.spell(6940).range',
		(function() return E('focus.health <= '..F('HandofSacrifice')) end)
	}, 'focus'},
	{'19750', {-- Flash of Light
		(function() return E('focus.health <= '..F('FlashofLightTank')) end), 
		'!player.moving',
		'focus.spell(19750).range'
	}, 'focus'},
	{'114157', {-- Execution Sentence // Talent
		(function() return E('focus.health <= '..F('ExecutionSentenceTank')) end),
		'focus.spell(114157).range'
	}, 'focus'},
	{'148039', {-- Sacred Shield // Talent
		'player.spell(148039).charges >= 1', 
		(function() return E('focus.health <= '..F('SacredShieldTank')) end), 
		'!focus.buff(148039)', 
		'focus.range < 40' 
	}, 'focus'},
	{'114163', {-- Eternal Flame // talent
		'player.holypower >= 3', 
		'!focus.buff(114163)',
		'focus.spell(114163).range',
		(function() return E('lowest.health <= '..F('EternalFlameTank')) end)
	}, 'focus'},
	{'85673', {-- Word of Glory
		'player.holypower >= 3',
		'focus.spell(85673).range',
		(function() return E('lowest.health <= '..F('WordofGloryTank')) end) 
	}, 'focus'},
	{'114165', {-- Holy Prism // Talent
		'player.holypower >= 3',
		(function() return E('focus.health <= '..F('HolyPrismTank')) end), 
		'!player.moving',
		'focus.spell(114165).range' 
	}, 'focus'},
	{'82326', {-- Holy Light
		(function() return E('focus.health < '..F('HolyLightTank')) end),
		'!player.moving',
		'focus.spell(82326).range' 
	}, 'focus'},
}

local _Player = {
	-- Items
	{'#5512', healthstn}, 											-- Health stone
	{'#trinket1', (function() return F('trink1') end)},				-- Trinket 1
	{'#trinket2', (function() return F('trink2') end)}, 			-- Trinket 2
	{{-- Beacon of Faith
		{'156910', {
			'!player.buff(53563)', -- Beacon of light
			'!player.buff(156910)' -- Beacon of Faith
		}, 'player'},
	}, 'talent(7,1)'},
	{'498', (function() return E('player.health <= '..F('DivineProtection')) end), nil}, -- Divine Protection
	{'642', (function() return E('player.health <= '..F('DivineShield')) end), nil}, -- Divine Shield
	{'148039', {-- Sacred Shield // Talent
		'player.spell(148039).charges >= 2', 
		(function() return E('player.health <= '..F('SacredShield')) end), 
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
		(function() return F('CrusaderStrike') end) 
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
	{'85673', (function() return E('lowest.health <= '..F('WordofGloryDP')) end), 'lowest' }, -- Word of Glory
	{'114163', {-- Eternal Flame
		'!lowest.buff(114163)', 
		(function() return E('lowest.health <= '..F('EternalFlameDP')) end) 
	}, 'lowest'},
}

local _SelflessHealer = {
	{'20271', 'target.spell(20271).range', 'target'}, -- Judgment
	{{-- If got buff
		{'19750', {-- Flash of light
			(function() return E('lowest.health <= '..F('FlashofLightSH')) end),  
			'!player.moving' 
		}, 'lowest'}, 
	}, 'player.buff(114250).count = 3'}
}

local _Raid = {
	-- Lay on Hands
	{'633', (function() return E('lowest.health <= '..F('LayonHands')) end), 'lowest'}, 
	{'19750', {-- Flash of Light
		(function() return E('lowest.health <= '..F('FlashofLight')) end), 
		'!player.moving' 
	}, 'lowest'},
	-- Execution Sentence // Talent
	{'114157', (function() return E('lowest.health <= '..F('ExecutionSentence')) end), 'lowest'},
	{'148039', {-- Sacred Shield // Talent
		'player.spell(148039).charges >= 2', 
		(function() return E('lowest.health <= '..F('SacredShield')) end), 
		'!lowest.buff(148039)' 
	}, 'lowest'},
	{'114163', {-- Eternal Flame // talent
		'player.holypower >= 1', 
		'!lowest.buff(114163)', 
		(function() return E('lowest.health <= '..F('EternalFlame')) end)
	}, 'lowest'},
	{'85673', {-- Word of Glory
		'player.holypower >= 3', 
		(function() return E('lowest.health <= '..F('WordofGlory')) end)
	}, 'lowest' },
	{'114165', {-- Holy Prism // Talent
		(function() return E('lowest.health <= '..F('HolyPrism')) end), 
		'!player.moving' 
	}, 'lowest'},
	{'82326', {-- Holy Light
		(function() return E('lowest.health < '..F('HolyLight')) end),
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
		(function() return E('lowest.health < '..F('HolyLightOCC')) end),
		'!player.moving' 
	}, 'lowest'},
}

NeP.Engine.registerRotation(Sidnum, '[|cff'..DarkNCR.Interface.addonColor ..myCR..'|r]'  ..mySpec.. ' '..myClass, 
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