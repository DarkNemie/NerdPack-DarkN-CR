local dynEval = DarkNCR.dynEval
local PeFetch = NeP.Interface.fetchKey
local addonColor = NeP.Interface.addonColor

local config = {
	key = 'NePConfigShammanResto',
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Shaman-Resto Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {	
		{type = 'header', text = '|cff'..addonColor..'General Settings:', align = 'center'},
			{type = 'dropdown', text = 'Earth Shield on ...', key = 'ESo', 
				list = {
					{text = 'Tank', key = '1'},
					{text = 'Focus', key = '2'},
					{text = 'Manual', key = '3'}
				}, 
				default = '2', 
				desc = 'Select target to cast Earth Shield on.' 
			},	
			{type = 'spinner', text = 'Ancestral Swiftness', key = 'AncestralSwiftness', default = 30},
		
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = '|cff'..addonColor..'Items Settings:', align = 'center'},
			{type = 'spinner', text = 'Healthstone', key = 'Healthstone', default = 50},
			{type = 'spinner', text = 'Trinket 1', key = 'Trinket1', default = 85}, 
			{type = 'spinner', text = 'Trinket 2', key = 'Trinket2',default = 85},
		
		{type = 'spacer'},
		{type = 'rule'},
		{type = 'header', text = '|cff'..addonColor..'Tank/Focus Settings:', align = 'center'},
			{type = 'checkbox', text = 'Riptide', key = 'RiptideTank', default = true,},
			{type = 'spinner', text = 'Healing Surge #Health', key = 'HealingSurgeTank', default = 45},
			{type = 'spinner', text = 'Healing Wave #Health', key = 'HealingWaveTank', default = 75},
		
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = '|cff'..addonColor..'Player Settings:', align = 'center'},
			{type = 'spinner', text = 'Astral Shift', key = 'AstralShift', default = 50},
			{type = 'spinner', text = 'Ancestral Swiftness', key = 'HealingSurgePlayer', default = 35},
			{type = 'spinner', text = 'Riptide', key = 'RiptidePlayer', default = 95},
			{type = 'spinner', text = 'Healing Wave', key = 'HealingWavePlayer', default = 65},
		
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = '|cff'..addonColor..'Raid Settings:', align = 'center'},
			{type = 'spinner', text = 'Healing Wave', key = 'HealingWaveRaid', default = 90},
			{type = 'spinner', text = 'Riptide', key = 'RiptideRaid', default = 95},
			{type = 'spinner', text = 'Unleash Life', key = 'UnleashLifeRaid', default = 25},
			{type = 'spinner', text = 'Healing Surge', key = 'HealingSurgeRaid', default = 35},
	}
}

NeP.Interface.buildGUI(config)

local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfigShammanResto') end)
	NeP.Interface.CreateToggle(
  		'NeP_Totems', 
  		'Interface\\Icons\\Spell_shaman_dropall_01.png‎', 
  		'Use Totems', 
  		'Enable to use totems.\nSpecial Totems require Cooldowns Toggle enabled also.')
	NeP.Interface.CreateToggle(
  		'NeP_Wolf', 
  		'Interface\\Icons\\Spell_nature_spiritwolf.png', 
  		'Use Ghost Wolf', 
  		'Enable to use Ghost Worf while moving\nRequires player to move for 3 seconds or more.')
	NeP.Interface.CreateToggle(
  		'dps', 
  		'Interface\\Icons\\Spell_shaman_stormearthfire.png‎', 
  		'Some DPS', 
  		'Do some damage while healing in party/raid.')
end	

local Cooldowns = {
   	{'114052', {-- Ascendance
		'@coreHealing.needsHealing(65, 3)',
		'!player.totem(108280)' -- Stop if w/ Healing Tide Totem
	}},
	{'108285', {-- Call of the Elements // TALENT (Reset Totem CD's)
		'talent(3,1)', 
		'@coreHealing.needsHealing(80, 3)', 
		'player.spell(5394).cooldown >= 10'
	}, 'player'},
}

local Totems = {
	{{-- Party

		-- Water
		{{-- Dont break other Water Totems
			{{-- Cooldowns
				{'108280', {-- Healing Tide Totem
					'!player.buff(114052)', -- if wt/ Ascendance
					'@coreHealing.needsHealing(50, 3)'
				}},
			}, 'modifier.cooldowns'},
			{'5394', '@coreHealing.needsHealing(85, 3)'}, -- Healing Stream Totem
			{'157153', '@coreHealing.needsHealing(85, 3)'},-- Cloudburst Totem // TALENT
		},{
			'!player.totem(5394)', -- Stop if w/ Healing Stream Totem
			'!player.totem(157153)', -- Stop if w/ Cloudburst Totem
			'!player.totem(108280)' -- Stop if w/ Healing Tide Totem
		}},
		
		-- Air
		{{-- Dont Break other Air Totems!
			{{-- Cooldowns
				{'98008', 'player.buff(114052)'}, -- Spirit Link Totem if w/ Ascendance
			}, 'modifier.cooldowns'},
			{'108273', 'player.state.root'}, -- Windwalk Totem
			{'108273', 'player.state.snare'}, -- Windwalk Totem
		},{
			'!player.totem(98008)', -- Stop if w/ Spirit Link Totem
			'!player.totem(108273)' -- Stop if w/ Windwalk Totem
		}},

	},{
		'!modifier.raid',
		'modifier.party'
	}},
	
	{{-- Raid
		-- Water
		{{-- Dont break other Water Totems
			{{-- Cooldowns
				{'108280', {-- Healing Tide Totem
					'!player.buff(114052)', -- if wt/ Ascendance
					'@coreHealing.needsHealing(50, 6)'
				}},
			}, 'modifier.cooldowns'},
			{'5394', '@coreHealing.needsHealing(85, 6)'}, -- Healing Stream Totem
			{'157153', '@coreHealing.needsHealing(85, 6)'}, -- Cloudburst Totem // TALENT
		},{
			'!player.totem(5394)', -- Stop if w/ Healing Stream Totem
			'!player.totem(157153)', -- Stop if w/ Cloudburst Totem
			'!player.totem(108280)' -- Stop if w/ Healing Tide Totem
		}},
		
		-- Air
		{{-- Dont Break other Air Totems!
			{{-- Cooldowns
				{'98008', 'player.buff(114052)'}, -- Spirit Link Totem if w/ Ascendance
			}, 'modifier.cooldowns'},
			{'108273', 'player.state.root'}, -- Windwalk Totem
			{'108273', 'player.state.snare'}, -- Windwalk Totem
		},{
			'!player.totem(98008)', -- Stop if w/ Spirit Link Totem
			'!player.totem(108273)' -- Stop if w/ Windwalk Totem
		}},

	}, 'modifier.raid'},
	
	-- Earth
	{'108270', {-- Stone Bulwark Totem
		'player.health <= 45',
		'talent(1,2)' 
	}},
}

local General = {

  	-- Keybinds
	{'73920', {-- Healing Rain if not Ascendance // FIX ME: Automate this...
		'modifier.shift', 
		'!player.buff(114052)'
	}, 'mouseover.ground'},
  	{'/focus [target=mouseover]', 'modifier.lalt'}, -- Mouseover Focus

	-- Buffs
    {'52127', {-- Water Shield
		'!player.buff(52127)', 
		'!player.buff(974)'
	}},
	{{-- Ghost Wolf
		{'/cancelaura Ghost Wolf',{
			'!player.moving', 
			'player.buff(2645)'
		}},
		{'/cancelaura Ghost Wolf',{
			'player.buff(79206)', 
			'player.buff(2645)'
		}},
		{'2645', {-- Ghost Wolf
			'player.movingfor >= 1', 
			'!player.buff(79206)',
			'!player.buff(2645)'
		}},
	}, 'toggle.NeP_Wolf'},
}

local HealFast = {
	{'!73685',{	-- Unleash Life	
		'!player.buff(73685)',
		(function() return dynEval('lowest.health <= '..PeFetch('NePConfigShammanResto', 'UnleashLifeRaid')) end)
	}, 'lowest'},
	{'!16188', (function() return dynEval('lowest.health <= 30'..PeFetch('NePConfigShammanResto', 'AncestralSwiftness')) end), 'lowest'}, -- Ancestral Swiftness
	{'!8004',nil, 'lowest'}, -- Healing Surge
}

local AoE = {
	{{-- Party
		{'1064', '@coreHealing.needsHealing(90, 3)', 'lowest'},  -- Chain Heal
	},{
		'!modifier.raid',
		'modifier.party'
	}},
	{{-- Raid
		{'1064', '@coreHealing.needsHealing(90, 5)', 'lowest'},  -- Chain Heal
	}, 'modifier.raid'},
}

local Tank = {
	-- Tank
	{'974', {-- Earth Shield
		(function() return PeFetch('NePConfigShammanResto', 'ESo') == '1' end),
		'!tank.buff(974)'
	}, 'tank'},
	{'61295', {-- Riptide
	    (function() return PeFetch('NePConfigShammanResto', 'ESo') == '1' end),
		(function() return PeFetch('NePConfigShammanResto', 'RiptideTank') end)
	    'tank.buff(61295).duration <= 3' -- Riptide
	}, 'tank'},
	{'8004', (function() return dynEval('tank.health <= '..PeFetch('NePConfigShammanResto', 'HealingSurgeTank')) end), 'tank'}, -- Healing Surge
	{'77472', (function() return dynEval('tank.health <= '..PeFetch('NePConfigShammanResto', 'HealingWaveTank')) end), 'tank'}, -- Healing Wave
}

local Focus = {					
    {'974', {-- Earth Shield
    	(function() return PeFetch('NePConfigShammanResto', 'ESo') == '2' end),
    	'!focus.buff(974)'
   }, 'focus'},
	{'61295', {-- Riptide
	    (function() return PeFetch('NePConfigShammanResto', 'ESo') == '2' end),
		(function() return PeFetch('NePConfigShammanResto', 'RiptideTank') end),
	    'focus.buff(61295).duration <= 3' -- Riptide
	}, 'focus'},
	{'8004', (function() return dynEval('focus.health <= '..PeFetch('NePConfigShammanResto', 'HealingSurgeTank')) end), 'focus'}, -- Healing Surge
	{'77472', (function() return dynEval('focus.health <= '..PeFetch('NePConfigShammanResto', 'HealingWaveTank')) end), 'focus'}, -- Healing Wave
}

local RaidHealing = {
	{'8004', (function() return dynEval('lowest.health <= '..PeFetch('NePConfigShammanResto', 'HealingSurgeRaid')) end), 'lowest'}, -- Healing Surge
	{'77472', {-- Healing Wave
		'lowest.health <= 60',
		'lowest.buff(61295)' -- Riptide
	}, 'lowest'},
	{'61295', {-- Riptide
		'!player.buff(53390)', -- Tidal Waves
		'!lowest.buff(61295)', -- Riptide
		(function() return dynEval('lowest.health <= '..PeFetch('NePConfigShammanResto', 'RiptideRaid')) end)
	}, 'lowest'},
	{'77472', (function() return dynEval('lowest.health <= '..PeFetch('NePConfigShammanResto', 'HealingWaveRaid')) end), 'lowest'}, -- Healing Wave
}

local Player = {
	-- Survival
	{'108271', (function() return dynEval('player.health <= '..PeFetch('NePConfigShammanResto', 'AstralShift')) end), nil}, -- Astral Shift
	{'Stoneform', 'player.health <= 65'}, -- Stoneform // Dwarf Racial
	{'59547', 'player.health <= 70', 'player'}, -- Gift of the Naaru // Draenei Racial
	{'8004', (function() return dynEval('player.health <= '..PeFetch('NePConfigShammanResto', 'HealingSurgePlayer')) end), 'player'}, -- Healing Surge
	{'61295', {-- Riptide
		'!player.buff(53390)', -- Tidal Waves
		'!player.buff(61295)', -- Riptide
		(function() return dynEval('player.health <= '..PeFetch('NePConfigShammanResto', 'RiptidePlayer')) end),
		'!lowest.health <= 50' -- Dont use it on sealf if someone needs it more!
	}, 'player'},
	{'77472', (function() return dynEval('player.health <= '..PeFetch('NePConfigShammanResto', 'HealingWavePlayer')) end), 'player'}, -- Healing Wave
	
	-- Items
	{'#5512', (function() return dynEval('player.health <= '..PeFetch('NePConfigShammanResto', 'Healthstone')) end), nil}, -- Healthstone
	{'#trinket1', (function() return dynEval('player.mana <= '..PeFetch('NePConfigShammanResto', 'Trinket1')) end), nil}, -- Trinket 1
	{'#trinket2', (function() return dynEval('player.mana <= '..PeFetch('NePConfigShammanResto', 'Trinket2')) end), nil}, -- Trinket 2
}

local DPS= {
	{'2894', {-- Fire Elemental Totem
		'!talent(6, 2)', 
		'modifier.cooldowns' 
	}}, 
	{'3599', {-- Searing Totem // Fire Elemental Totem
		'!player.totem(3599)', 
		'!player.totem(2894)' 
	}},
	{'117014', 'talent(6, 3)'},
	{'8050', '!target.debuff(8050)'},
	{'51505'},
	{'421', 'player.area(10).enemies >= 3'},
	{'403'}, -- Lightning Bolt	
}

local outCombat = {
	{General},
	{Player}
}

NeP.Engine.registerRotation(264, '[|cff'..NeP.Interface.addonColor..'NeP|r] Shamman - Restoration', 
	{-- In-Combat
		{General},
		{{-- Party/Raid
			-- Dispel
			{'77130', 'player.dispellAll(77130)'},
			{{-- Interrupt
				{'57994'}, -- Wind Shear
			}, 'target.interruptAt(40)'},
			{{-- General Conditions
				{Cooldowns, 'modifier.cooldowns'},
				{Totems, 'toggle.NeP_Totems'},
				{HealFast, {'lowest.health < 40', '!player.casting.percent >= 40'}},
				{AoE, {'modifier.multitarget', '!lowest.health < 60'}},
				{Tank, {'tank.range <= 40', 'tank.health < 100'}},
				{Focus, {'focus.range <= 40', 'focus.health < 100'}},
				{Player, 'player.health < 100'},
				{RaidHealing, 'lowest.health < 100'},
				{DPS, {
					'toggle.dps',
					'target.range < 40'
				}},
			}, '!player.moving'},
		}, 'modifier.party'},
		{{-- Solo
			{Player},
			{DPS, 'toggle.dps'}
		}, '!modifier.party'},
	}, outCombat, exeOnLoad)
