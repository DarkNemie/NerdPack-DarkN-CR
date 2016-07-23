local dynEval = DarkNCR.dynEval
local fetchKey = NeP.Interface.fetchKey

local config = {
	key = 'NePConfDkBlood',
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Deathknight Blood Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{ type = 'rule' },
		{ type = 'header', text = 'General settings:', align = 'center' },

			{ type = 'checkbox', text = 'Run Faster', key = 'RunFaster', default = false, 
				desc = 'This checkbox enables or disables the use of Unholy presence while out of combat to move faster.'
			},

		-- Focus
		{ type = 'rule' },
		{ type = 'header', text = 'Player settings:', align = 'center' },

			{ type = 'spinner', text = 'Icebound Fortitude', key = 'IceboundFortitude', default = 40 },
			{ type = 'spinner', text = 'Vampiric Blood', key = 'VampiricBlood', default = 40 },
			{ type = 'spinner', text = 'Death Pact', key = 'DeathPact', default = 50 },
			{ type = 'spinner', text = 'Rune Tap', key = 'RuneTap', default = 60 },
			{ type = 'spinner', text = 'Death Siphon', key = 'DeathSiphon', default = 60 },

	}
}

NeP.Interface.buildGUI(config)

local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfDkBlood') end)
	NeP.Interface.CreateToggle(
		"DRW", 
		"Interface\\Icons\\INV_Sword_07", 
		"Dancing Rune Weapon",
		"Toggle Off if you dont want to use DRW on CD")

end

local _darkSimSpells = {
	-- Siege of Orgrimmar
	'Froststorm Bolt',
	'Arcane Shock',
	'Rage of the Empress',
	'Chain Lightning',
	-- PvP
	'Hex',
	'Mind Control',
	'Cyclone',
	'Polymorph',
	'Pyroblast',
	'Tranquility',
	'Divine Hymn',
	'Hymn of Hope',
	'Ring of Frost',
	'Entangling Roots'
}

local _DarkSimUnit = function(unit)
	for index,spellName in pairs(_darkSimSpells) do
		if NeP.DSL.Conditions['casting'](unit, spellName) then
			return true 
		end
	end
	return false
end

local Shared = {
	-- buffs
	{ '48263', 'player.seal != 1', nil }, -- Blood
	{ '49222', '!player.buff(49222)' }, -- bone shield
	{ '57330', '!player.buffs.attackpower' }, -- Horn of Winter

	-- Keybinds
	{ '42650', 'modifier.alt' }, -- Army of the Dead
	{ '49576', 'modifier.control' }, -- Death Grip
	{ '43265', 'modifier.shift', 'target.ground' }, -- Death and Decay
	{ '152280', 'modifier.shift', 'target.ground' }, -- Defile
}

local Survival = {
	-- healthstone
	{ '#5512', 'player.health < 70'},

	-- Icebound Fortitude
	{ '48792', (function() return dynEval('player.health <= '..fetchKey('NePConfDkBlood', 'IceboundFortitude')) end) },
	-- Vampiric Blood
	{ '55233', (function() return dynEval('player.health <= '..fetchKey('NePConfDkBlood', 'VampiricBlood')) end) }, 
	-- Death Pact 
	{ '48743', (function() return dynEval('player.health <= '..fetchKey('NePConfDkBlood', 'DeathPact')) end) }, 
	-- rune tap
	{ '48982', (function() return dynEval('player.health <= '..fetchKey('NePConfDkBlood', 'RuneTap')) end) },
	-- Death Siphon
	{ '108196', (function() return dynEval('player.health <= '..fetchKey('NePConfDkBlood', 'DeathSiphon')) end) },
	{ '49039', {  -- Lichborne //fear
		'player.state.fear', 
		'player.runicpower >= 40', 
		'player.spell.exists(49039)' 
	}},
	{ '49039', { -- Lichborne //sleep
		'player.state.sleep', 
		'player.runicpower >= 40', 
		'player.spell.exists(49039)' 
	}},
	{ '49039', { -- Lichborne //charm
		'player.state.charm', 
		'player.runicpower >= 40', 
		'player.spell.exists(49039)' 
	}},
}

local Cooldowns = {
	{ '49028', '!toggle.DRW', 'target' }, -- Dancing Rune Weapon
	{ '47568', { -- Empower Rune Weapon
		'player.runes(death).count < 1', 
		'player.runes(frost).count < 1', 
		'player.runes(unholy).count < 1', 
		'player.runicpower < 30' }}, 
	{ '115989', 'target.debuff(55095)' }, -- Unholy Blight
	{ '115989', 'target.debuff(55078)' }, -- Unholy Blight
	{ '#gloves'},
}

local Interrupts = {
	-- Mind freeze
	{ '47528' },
	-- Strangulate
	{ '47476' },
	-- Asphyxiate
	{ '108194' },
}

local AoE = {
	-- Blood Boil
	{ '50842',	'target.range <= 10' },
	-- Death and Decay
	{ '43265', 'target.range < 7', 'target.ground' },
	-- Defile
	{ '152280', 'target.range < 7', 'target.ground' },
}

local inCombat = {

	-- Dark Simulacrum
	{ '77606', (function() return _DarkSimUnit('target') end), 'target' },
	{ '77606', (function() return _DarkSimUnit('focus') end), 'focus' },

	-- Plague Leech
	{ '123693', {
		'target.debuff(55095)',-- Target With Frost Fever
		'target.debuff(55078)',-- Target With Blood Plague
		'player.runes(unholy).count = 0',-- With 0 Unholy Runes
		'player.runes(frost).count = 0',-- With 0 Frost Runes
		'player.runes(death).count = 0',-- With 0 Death Runes
		'!lastcast(123693)'
	}}, 

	-- Diseases
	{ '77575', 'target.debuff(55095).duration < 2' }, -- Outbreak
	{ '77575', 'target.debuff(55078).duration < 2' }, -- Outbreak
	{ '45462', 'target.debuff(55078).duration < 2', 'target' }, -- Plague Strike
	{ '45477', 'target.debuff(55095).duration < 2', 'target' }, -- Icy Touch
	{ '48721', { -- Blood Boil // blood
		'player.runes(blood).count > 1',
		'target.debuff(55095).duration < 3', 
		'target.debuff(55078).duration <3' 
	}},
	{ '48721', {  -- Blood Boil // death
		'player.runes(death).count > 1',
		'target.debuff(55095).duration < 3', 
		'target.debuff(55078).duration <3' 
	}},

	-- AoE
	{AoE, 'player.area(40).enemies >= 3' },

	-- Rotation
	{ '50842', { -- Blood Boil
		'player.buff(Crimson Scourge)',
		'target.range <= 10' 
	}}, 
	{ '47541', 'player.runicpower >= 90', 'target' }, -- Death Coil // Full runic
	{ '49998', 'player.buff(77513).duration <= 1', 'target' }, -- Death Strike
	{ '114866', 'target.health <= 35', 'target' }, -- Soul Reaper
	{ '50842',	{ -- Blood Boil
		'target.range <= 10', 
		'!target.health <= 35' 
	}}, 
	{ '50842',	{ -- Blood Boil //35 % health if SR
		'player.runes(blood).count = 1', 
		'target.range <= 10', 
		'target.health <= 35' 
	}}, 
	{ '47541', 'player.runicpower >= 30', 'target' }, -- Death Coil

	{{ -- Blood Tap
	    { '45529', 'player.runes(unholy).count = 0' }, --Blood Tap
	    { '45529', 'player.runes(frost).count = 0' }, -- Blood Tap
	    { '45529', 'player.runes(blood).count = 0' }, -- Blood Tap
	} , {
	    'player.buff(Blood Charge).count >= 5',
	    'player.runes(death).count = 0',
	    '!lastcast(45529)'
	}},
}

local outCombat = {
	{Shared}
}

NeP.Engine.registerRotation(250, '[|cff'..NeP.Interface.addonColor..'NeP|r] Deathknight - Blood', {
		{Shared},
		{Survival, 'player.health < 100' },
		{Cooldowns, 'modifier.cooldowns' },
		{Interrupts, 'target.interruptAt(40)' },
		{inCombat}
	}, outCombat, exeOnLoad)