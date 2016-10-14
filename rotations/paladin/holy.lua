local myCR 		= 'DNCR'									-- Change this to something Unique
local myClass 	= 'Paladin'									-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'Holy'									-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
----------	Do not change unless you know what your doing ----------
local Sidnum 	= DarkNCR.classSpecNum[myClass..mySpec]	-- Do not change unless you know what your doing
local config 	= {
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


local exeOnLoad = function()
	DarkNCR.Splash()
end


--------------- END of do not change area ----------------
--
--	The Fetch and dynaEval functions below have been updated, 
--	if there is errors look there first, new skills have not been updated
--
---------- This Starts the Area of your Rotaion ----------
local _All = {
	-- keybinds
	{'114158', 'keybind(shift)', 'target.ground'}, -- Light´s Hammer
	{'!/focus [target=mouseover]', 'keybind(alt)'}, -- Mouseover Focus
	-- Hand of Freedom
--	{'1044', 'player.state.root'},
	-- Buffs
	{'20217', {-- Blessing of Kings
		'!player.buffs.stats',
		'UI(Buff) == Kings',
	}, nil},
	{'19740', {-- Blessing of Might
		'!player.buffs.mastery',
		'UI(Buff) == Might',
	}, nil}, 
	
	-- Seals
	{'20165', {-- seal of Insigh
		'player.seal != 2', 
		'UI(seal) == Insight',
	}, nil}, 
	{'105361', {-- seal of Command
		'player.seal != 1',
		'UI(seal) == Command',
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
	}, 'toggle(AoE)'}, 
	{'82326', {-- Holy Light
		'lowest.health <= UI(HolyLightIL)',
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
		'tank.health <= UI(LayonHandsTank)',
		'tank.spell(633).range'
	}, 'tank'},
	{'53563', {-- Beacon of light
		'!tank.buff(53563)', -- Beacon of light
		'!tank.buff(156910)', -- Beacon of Faith
		'tank.spell(53563).range' 
	}, 'tank'},
	{'6940', {-- Hand of Sacrifice
		'tank.spell(6940).range',
		'tank.health <= UI(HandofSacrifice)'
	}, 'tank'}, 
	{'19750', {-- Flash of Light
		'tank.health <= UI(FlashofLightTank)', 
		'!player.moving',
		'tank.spell(19750).range'
	}, 'tank'},
	{'114157', {-- Execution Sentence // Talent
		'tank.health <= UI(ExecutionSentenceTank)',
		'tank.spell(114157).range'
	}, 'tank'},
	{'148039', {-- Sacred Shield // Talent
		'player.spell(148039).charges >= 1', 
		'tank.health <= UI(SacredShieldTank)', 
		'!tank.buff(148039)', -- SS
		'tank.range < 40' 
	}, 'tank'},
	{'114163', {-- Eternal Flame // talent
			'player.holypower >= 3', 
		'!tank.buff(114163)',
		'focus.spell(114163).range',
		'lowest.health <= UI(EternalFlameTank)'
	}, 'tank'},
	{'85673', {-- Word of Glory
		'player.holypower >= 3',
		'focus.spell(85673).range',
		'lowest.health <= UI(WordofGloryTank)'
	}, 'tank' },
	{'114165', {-- Holy Prism // Talent
		'tank.health <= UI(HolyPrismTank)', 
		'!player.moving',
		'tank.spell(114165).range' 
	}, 'tank'},
	{'82326', {-- Holy Light
		'tank.health < UI(HolyLightTank)',
		'!player.moving',
		'focus.spell(82326).range' 
	}, 'tank'},
}

local _Focus = {
	{'633', {-- Lay on Hands
		'focus.health <= UI(LayonHandsTank)',
		'focus.spell(633).range'
	}, 'focus'}, 
	{'6940', {-- Hand of Sacrifice
		'focus.spell(6940).range',
		'focus.health <= UI(HandofSacrifice)'
	}, 'focus'},
	{'19750', {-- Flash of Light
		'focus.health <= UI(FlashofLightTank)', 
		'!player.moving',
		'focus.spell(19750).range'
	}, 'focus'},
	{'114157', {-- Execution Sentence // Talent
		'focus.health <= UI(ExecutionSentenceTank)',
		'focus.spell(114157).range'
	}, 'focus'},
	{'148039', {-- Sacred Shield // Talent
		'player.spell(148039).charges >= 1', 
		'focus.health <= UI(SacredShieldTank)', 
		'!focus.buff(148039)', 
		'focus.range < 40' 
	}, 'focus'},
	{'114163', {-- Eternal Flame // talent
		'player.holypower >= 3', 
		'!focus.buff(114163)',
		'focus.spell(114163).range',
		'lowest.health <= UI(EternalFlameTank)'
	}, 'focus'},
	{'85673', {-- Word of Glory
		'player.holypower >= 3',
		'focus.spell(85673).range',
		'lowest.health <= UI(WordofGloryTank) '
	}, 'focus'},
	{'114165', {-- Holy Prism // Talent
		'player.holypower >= 3',
		'focus.health <= UI(HolyPrismTank)', 
		'!player.moving',
		'focus.spell(114165).range' 
	}, 'focus'},
	{'82326', {-- Holy Light
		'focus.health < UI(HolyLightTank)',
		'!player.moving',
		'focus.spell(82326).range' 
	}, 'focus'},
}

local _Player = {
	-- Items
	{'#5512', 'player.health <= UI(Healthstone)'}, 											-- Health stone
	{'#trinket1', 'UI(trink1)'},				-- Trinket 1
	{'#trinket2', 'UI(trink2)'}, 			-- Trinket 2
	{{-- Beacon of Faith
		{'156910', {
			'!player.buff(53563)', -- Beacon of light
			'!player.buff(156910)' -- Beacon of Faith
		}, 'player'},
	}, 'talent(7,1)'},
	{'498', 'player.health <= UI(DivineProtection)', nil}, -- Divine Protection
	{'642', 'player.health <= UI(DivineShield)', nil}, -- Divine Shield
	{'148039', {-- Sacred Shield // Talent
		'player.spell(148039).charges >= 2', 
		'player.health <= UI(SacredShield)', 
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
		'UI(CrusaderStrike' 
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
	{'85673', 'lowest.health <= UI(WordofGloryDP)', 'lowest' }, -- Word of Glory
	{'114163', {-- Eternal Flame
		'!lowest.buff(114163)', 
		'lowest.health <= UI(EternalFlameDP)' 
	}, 'lowest'},
}

local _SelflessHealer = {
	{'20271', 'target.spell(20271).range', 'target'}, -- Judgment
	{{-- If got buff
		{'19750', {-- Flash of light
			'lowest.health <= UI(FlashofLightSH)',  
			'!player.moving' 
		}, 'lowest'}, 
	}, 'player.buff(114250).count = 3'}
}

local _Raid = {
	-- Lay on Hands
	{'633', 'lowest.health <= UI(LayonHands)', 'lowest'}, 
	{'19750', {-- Flash of Light
		'lowest.health <= UI(FlashofLight)', 
		'!player.moving' 
	}, 'lowest'},
	-- Execution Sentence // Talent
	{'114157', 'lowest.health <= UI(ExecutionSentence)', 'lowest'},
	{'148039', {-- Sacred Shield // Talent
		'player.spell(148039).charges >= 2', 
		'lowest.health <= UI(SacredShield)', 
		'!lowest.buff(148039)' 
	}, 'lowest'},
	{'114163', {-- Eternal Flame // talent
		'player.holypower >= 1', 
		'!lowest.buff(114163)', 
		'lowest.health <= UI(EternalFlame)'
	}, 'lowest'},
	{'85673', {-- Word of Glory
		'player.holypower >= 3', 
		'lowest.health <= UI(WordofGlory)' 
	}, 'lowest' },
	{'114165', {-- Holy Prism // Talent
		'lowest.health <= UI(HolyPrism)', 
		'!player.moving' 
	}, 'lowest'},
	{'82326', {-- Holy Light
		'lowest.health < UI(HolyLight)',
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
	}, 'toggle(AoE)'},
	-- Holy Light
	{'82326', {
		'lowest.health < UI(HolyLightOCC)',
		'!player.moving' 
	}, 'lowest'},
}

NeP.CR:Add(Sidnum, '[|cff'..DarkNCR.Interface.addonColor ..myCR..'|r]'  ..mySpec.. ' '..myClass, 
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
		{_Cooldowns, 'toggle(cooldowns)'},
		{_AoE, 'toggle(AoE)'},
		{_Tank},
		{_Focus},
		{_Player},
		{_Raid}
	},{-- Out-Combat
		{_All},
		{outCombat}
	}, lib)