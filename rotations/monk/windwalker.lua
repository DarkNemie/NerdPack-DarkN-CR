local config = {
	key = 'NePConfigMonkWw',
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Monk WindWalker Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		-- General
		{type = 'header',text = 'General', align = 'center'},
			{type = 'checkbox', text = 'SEF', key = 'SEF', default = true},

		-- Survival
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = 'Survival', align = 'center'},
			{type = 'spinner', text = 'Healthstone', key = 'Healthstone', default = 75},		
	}
}

NeP.Interface.buildGUI(config)

local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfigMonkWw') end)
end

local SEF_Debuff = GetSpellInfo('138130') -- SEF Debuff
local SEF_Spell = GetSpellInfo('137639') -- SEF Debuff

local _SEF = function()
	for i=1,#NeP.OM.unitEnemie do
		local object = NeP.OM.unitEnemie[i]
		if NeP.DSL.Conditions['deathin'](object.key) >= 10 then
			if UnitGUID('target') ~= UnitGUID(object.key) then
				if UnitAffectingCombat(object.key) or object.is == 'dummy' then
					local _,_,_,_,_,_,debuff = UnitDebuff(object.key, GetSpellInfo(137639), nil, 'PLAYER')
					if not debuff and DarkNCR.dynEval('!player.buff('..SEF_Debuff..').count = 2') then
						if NeP.Engine.Infront('player', object.key) then
							NeP.Engine.ForceTarget = object.key
							return true 
						end
					end
				end
			end
		end
	end
	return false
end

local _All = {
	-- Keybinds
	{ 'pause', 'modifier.shift' },
	{ '119381', 'modifier.control' }, -- Leg Sweep
	{ '122470', 'modifier.alt' }, -- Touch of Karma
	
	-- Buffs
	{ '115921', '!player.buffs.stats'},-- Legacy of the Emperor
	
	-- FREEDOOM!
	{ '137562', 'player.state.disorient' }, -- Nimble Brew = 137562
	{ '116841', 'player.state.disorient' }, -- Tiger's Lust = 116841
	{ '137562', 'player.state.fear' }, -- Nimble Brew = 137562
	{ '116841', 'player.state.stun' }, -- Tiger's Lust = 116841
	{ '137562', 'player.state.stun' }, -- Nimble Brew = 137562
	{ '137562', 'player.state.root' }, -- Nimble Brew = 137562
	{ '116841', 'player.state.root' }, -- Tiger's Lust = 116841
	{ '137562', 'player.state.horror' }, -- Nimble Brew = 137562
	{ '137562', 'player.state.snare' }, -- Nimble Brew = 137562
	{ '116841', 'player.state.snare' }, -- Tiger's Lust = 116841
}

local _Cooldowns = {
	{ '115288', 'player.energy <= 30'},-- Energizing Brew
	{ '123904'}, -- Invoke Xuen, the White Tiger
	{ 'Chi Brew', 'player.chi <= 2' },
	{ 'Serenity', 'player.chi <= 3' }
}

local _Survival = {
	{ '115072', { 'player.health <= 80', 'player.chi < 4' }}, -- Expel Harm
	{ '115203', { -- Forifying Brew at < 30% health and when DM & DH buff is not up
		'player.health < 30',
		'!player.buff(122783)', -- Diffuse Magic
		'!player.buff(122278)'}}, -- Dampen Harm
	{ '#5512', 'player.health < 40' }, -- Healthstone
}

local _Interrupts = {
	{ '116705' }, -- Spear Hand Strike
	{ '107079', '!target.debuff(116705)' }, -- Quaking Palm when SHS is on CD
	{ '116844', '!target.debuff(116705)' }, -- Ring of Peace when SHS is on CD
	{ '119381', 'target.range <= 5' }, -- Leg Sweep when SHS is on CD
	{ '119392', 'target.range <= 30' }, -- Charging Ox Wave when SHS is on CD
	{ '115078', { -- Paralysis when SHS, and Quaking Palm are all on CD
		'!target.debuff(116705)', -- Spear Hand Strike
		'player.spell(107079).cooldown > 0', -- Quaking Palm
	}},
}

local _SEF = {
	{ SEF_Spell, {'player.area(40).enemies >= 3', (function() return _SEF() end)} },
	{ '/cancelaura '..SEF_Spell, 'target.debuff('..SEF_Debuff..')', 'target'}, -- Storm, Earth, and Fire
}

local _Ranged = {
	{ '116841', 'player.moving'},-- Tiger's Lust
	{ '124081', '!target.debuff(124081)'}, -- Zen Sphere
	{ '115098' }, -- Chi Wave
	{ '123986' }, -- Chi Burst
	{ '117952', '!player.moving'}, -- Crackling Jade Lightning
	{ '115072', 'player.chi < 4'}, -- Expel Harm
}

local _Melle = {
	-- Tigereye Brew
	{ '116740', {
		'player.buff(125195).count >= 10', 
		'!player.buff(116740)'
	}},

	-- Rotation
	{{ -- infront
		{ '115080', 'player.buff(121125)', 'target' }, -- Touch of Death, Death Note
		{ '100787', 'player.buff(125359).duration < 5', 'target' }, -- Tiger Palm if not w/t Tiger Power
		{ '107428', 'target.debuff(130320).duration < 3', 'target' }, -- Rising Sun Kick
		{ '113656', '!player.moving', 'target' }, -- Fists of Fury
		{ '100784', 'player.buff(116768)', 'target' },-- Blackout Kick w/tCombo Breaker: Blackout Kick
		{ '100787', 'player.buff(118864)', 'target' }, -- Tiger Palm w/t Combo Breaker: Tiger Palm
		{ '115098', 'player.energy <= 65' }, -- Chi Wave
		{ '100784', 'player.chi >= 3', 'target' }, -- Blackout Kick /DUMP CHI
		{ '115698', nil, 'target' }, -- Jab
	}, 'target.infront' },
}

local _AoE = {
	{ '115080', 'player.buff(121125)', 'target' }, -- Touch of Death, Death Note
	{ '100787', 'player.buff(125359).duration < 5', 'target' }, -- Tiger Palm if not w/t Tiger Power
	{ '107428', 'target.debuff(130320).duration < 3', 'target' }, -- Rising Sun Kick
	{ '113656', '!player.moving', 'target' }, -- Fists of Fury
	{ '101546' }, -- Spinning Crane Kick
}

NeP.Engine.registerRotation(269, '[|cff'..NeP.Interface.addonColor..'NeP|r] Monk - Windwalker',
	{ -- In-Combat
		{_All},
		{_Survival, 'player.health < 100'},
		{_Interrupts, 'target.interruptAt(40)'},
		{_Cooldowns, 'modifier.cooldowns'},
		{_SEF, (function() return NeP.Interface.fetchKey('NePConfigMonkWw', 'SEF') end)},
		{{ -- Conditions
			{_AoE, 'player.area(8).enemies >= 3'},
			{_Melle, 'target.inMelee'},
			{_Ranged, { '!target.inMelee', 'target.inRanged' }}
		}, {'target.range <= 40', 'target.exists'} }
	}, _All, exeOnLoad)
