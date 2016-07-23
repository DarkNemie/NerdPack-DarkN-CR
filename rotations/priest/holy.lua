local dynEval = DarkNCR.dynEval
local fetchKey = NeP.Interface.fetchKey

local config = {
	key = 'NePConfPriestHoly',
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Priest Holy Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {

		-- General
		{ type = 'header', text = 'General settings:', align = 'center'},
		{ type = 'spacer' },
			-- Feathers
			{ type = 'checkbox',text = 'Feathers', key = 'Feathers', default = true, desc = 'This checkbox enables or disables the use of automatic feathers to move faster.'},
			 -- Chakra
			{ type = 'dropdown',text = 'Chakra:', key = 'Chakra', 
				list = {
					{text = 'Chastise',key = 'Chastise'},
					{text = 'Sanctuary',key = 'Sanctuary'},
					{text = 'Serenity',key = 'Serenity'}
				}, 
				default = 'Serenity', 
				desc = 'Select What Chakra to use...' 
			},
			-- Buff
			{ type = 'checkbox', text = 'Buff', key = 'Buff', default = true, desc = 'This checkbox enables or disables the use of automatic buffing.'},

		-- Focus/Tank
		{ type = 'spacer' },{ type = 'rule' },
		{ type = 'header', text = 'Focus/Tank settings:', align = 'center' },
			-- Flash Heal
			{ type = 'spinner', text = 'Flash Heal', key = 'FlashHealTank', default = 40},
			-- Holy Word Serenity
			{ type = 'spinner', text = 'Holy Word Serenity', key = 'HolyWordSerenityTank', default = 90},
			-- Power Word: Shield
			{ type = 'spinner', text = 'Power Word: Shield', key = 'ShieldTank', default = 100},
			-- Heal
			{ type = 'spinner', text = 'Heal', key = 'HealTank', default = 95},
			-- Renew
			{ type = 'spinner', text = 'Renew', key = 'RenewTank', default = 100},
			-- Binding Heal
			{ type = 'spinner', text = 'Binding Heal', key = 'BindingHealTank', default = 100},
			-- Prayer of Mending
			{ type = 'spinner', text = 'Prayer of Mending', key = 'PrayerofMendingTank', default = 100},

		-- Raid/Party
		{ type = 'spacer' },{ type = 'rule' },
		{ type = 'header', text = 'Raid/Party settings:', align = 'center' },
			-- Flash Heal
			{ type = 'spinner', text = 'Flash Heal', key = 'FlashHealRaid', default = 20},
			-- Holy Word Serenity
			{ type = 'spinner', text = 'Holy Word Serenity', key = 'HolyWordSerenityRaid', default = 60},
			-- Renew
			{ type = 'spinner', text = 'Renew', key = 'RenewRaid',default = 85},
			-- Power Word: Shield
			{ type = 'spinner', text = 'Power Word: Shield', key = 'ShieldRaid', default = 40},
			-- Binding Heal
			{ type = 'spinner', text = 'Binding Heal', key = 'BindingHealRaid', default = 99},
			-- Heal
			{ type = 'spinner', text = 'Heal', key = 'HealRaid', default = 95},

		-- Player
		{ type = 'spacer' },{ type = 'rule' },
		{ type = 'header', text = 'Player settings:', align = 'center' },
			-- Flash Heal
			{ type = 'spinner', text = 'Flash Heal', key = 'FlashHealPlayer', default = 40},
			-- Holy Word Serenity
			{ type = 'spinner', text = 'Holy Word Serenity', key = 'HolyWordSerenityPlayer', default = 90},
			-- Renew
			{ type = 'spinner', text = 'Renew',key = 'RenewPlayer', default = 85},
			-- Power Word: Shield
			{ type = 'spinner', text = 'Power Word: Shield', key = 'ShieldPlayer', default = 70},
			-- Desperate Prayer
			{ type = 'spinner', text = 'Desperate Prayer',key = 'DesperatePrayer', default = 25},
			-- Heal
			{ type = 'spinner', text = 'Heal', key = 'Heal', default = 95},
			-- Healthstone
			{ type = 'spinner', text = 'Healthstone', key = 'Healthstone', default = 35},
	}
}

NeP.Interface.buildGUI(config)

local init = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfPriestHoly') end)
end


local _PoH = function()
	return false
end

local _ClarityOfPurpose = function()
	local minHeal = GetSpellBonusDamage(2) * 1.125
	local total = 0
	for i=1,#NeP.OM.unitFriend do
		local object = NeP.OM.unitFriend[i]
		local healthMissing = max(0, object.maxHealth - object.actualHealth)
		if healthMissing > minHeal 
		and UnitIsFriend('player', object.key) then
			if object.distance <= 10 then
				total = total + 1
			end
		end
	end
	return total > 3
end

local All = {
	--[[ Chakra ]]
  	{ '81208', { -- Serenity
  		'player.stance != 3',
  		(function() return fetchKey('NePConfPriestHoly', 'Chakra') == 'Serenity' end),
  	}},
	{ '81206', { -- Sanctuary
		'player.stance != 2',
		(function() return fetchKey('NePConfPriestHoly', 'Chakra') == 'Sanctuary' end),
	}},
	{ '81209', { -- Serenity
		'player.stance != 1',
		(function() return fetchKey('NePConfPriestHoly', 'Chakra') == 'Chastise' end),
	}},
	
	-- Buffs
	{ '21562', { -- Fortitude
		(function() return fetchKey('NePConfPriestHoly','Buff') end),
		'!player.buffs.stamina'
	}},

  	--[[ keybinds ]]
	{ '32375', 'modifier.rcontrol', 'player.ground' }, --Mass Dispel
	{ '48045', 'modifier.ralt', 'tank' }, -- Mind Sear
	{ '120517', 'modifier.lcontrol', 'player' }, --Halo
	{ '110744', 'modifier.lcontrol', 'player' }, --Divine Star
}

local MoveFast = {
	{ '121536', { 
		'player.movingfor > 2', 
		'!player.buff(121557)', 
		'player.spell(121536).charges >= 1' 
	}, 'player.ground' },
	{ '17', {
		'talent(2, 1)', 
		'player.movingfor > 2', 
		'!player.buff(6788)',
	}, 'player' },
}

local Cooldowns = {
	{ '10060' }, --Power Infusion
	{ '123040', { --Mindbender
		'player.mana < 75', 
		'target.spell(123040).range'
	}, 'target' },
}

local RaidCombat = {

	-- PW:S
	{ '129250', {'target.range <= 30', 'target.enemie'}, 'target' },

  	{{ -- CD's
		{ '10060' }, --Power Infusion
		{ '123040', { --Mindbender
			'player.mana < 75', 
			'target.spell(123040).range',
		}, 'target' },
	}, 'modifier.cooldowns' },
	
	-- Proc's
	{ '596', { -- Prayer of healing // Divine Insigt
		'player.buff(123267)',
		(function() return _PoH() end)
	}, 'lowest' },
	{ '2061', { -- Flash heal // Surge of light
		'lowest.health < 100',
		'player.buff(114255)',
	}, 'lowest' },

	{{-- Player dead (Spirit)
		{ '88684', 'lowest.health <= 80', 'lowest' }, -- Holy Word Serenity
		{ '2061', 'lowest.health < 100', 'lowest' }, -- Flash Heal
		{ '34861', '@coreHealing.needsHealing(95, 3)', 'lowest'}, -- Circle of Healing
		{ '121135', '@coreHealing.needsHealing(95, 3)' }, -- Cascade
		{ '596', (function() return _PoH() end), 'lowest' }, -- Prayer of Healing
	}, 'player.buff(27827)' },

	{{-- AOE
   		{ '34861', '@coreHealing.needsHealing(90, 3)', 'lowest'}, -- Circle of Healing
		{ '121135', { -- cascade
			'@coreHealing.needsHealing(95, 3)', 
			'!player.moving'
		}, 'lowest'},
		-- Divine Hymn
			{ '64843', { -- Divine Hymn
				'@coreHealing.needsHealing(50, 3)', 
				'modifier.party' 
			}},
			{ '64843', { -- Divine Hymn
				'@coreHealing.needsHealing(60, 5)', 
				'modifier.raid', 
				'!modifier.members > 10' 
			}},
			{ '64843', {  -- Divine Hymn
				'@coreHealing.needsHealing(60, 8)', 
				'modifier.raid', 
				'modifier.members > 10' 
			}},
		{ '596', (function() return _PoH() end) },-- Prayer of Healing
   		{ '155245', (function() return _ClarityOfPurpose() end), 'lowest' },-- Clarity Of Purpose
	}, 'modifier.multitarget' },

	{{-- Heal Fast Bitch!!
		-- Desperate Prayer
		{ '!19236',  --Desperate Prayer
			(function() return dynEval('player.health <= ' .. fetchKey('NePConfPriestHoly', 'DesperatePrayer')) end),
			'player' },

		-- Holy Word Serenity
		{ '!88684', { -- Holy Word Serenity
			(function() return dynEval('focus.health <= ' .. fetchKey('NePConfPriestHoly', 'HolyWordSerenityTank')) end),
			'focus.spell(88684).range'
			}, 'focus' },
		{ '!88684', { -- Holy Word Serenity
			(function() return dynEval('tank.health <= ' .. fetchKey('NePConfPriestHoly', 'HolyWordSerenityTank')) end),
			'tank.spell(88684).range'
			}, 'tank' },
		{ '!88684', -- Holy Word Serenity
			(function() return dynEval('player.health <= ' .. fetchKey('NePConfPriestHoly', 'HolyWordSerenityPlayer')) end), 
			'player' }, 
		{ '!88684', -- Holy Word Serenity
			(function() return dynEval('lowest.health <= ' .. fetchKey('NePConfPriestHoly', 'HolyWordSerenityRaid')) end),
			'lowest' }, 

		-- Flash Heal
		{ '!2061', { --Flash Heal
			(function() return dynEval('focus.health <= ' .. fetchKey('NePConfPriestHoly', 'FlashHealTank')) end),
			'focus.spell(2061).range',
			'!player.moving'
		}, 'focus' },
		{ '!2061', { --Flash Heal
			(function() return dynEval('tank.health <= ' .. fetchKey('NePConfPriestHoly', 'FlashHealTank')) end),
			'tank.spell(2061).range',
			'!player.moving'
		}, 'tank' },
		{ '!2061', { --Flash Heal
			(function() return dynEval('player.health <= ' .. fetchKey('NePConfPriestHoly', 'FlashHealPlayer')) end),
			'!player.moving'
		}, 'player' },
		{ '!2061', { --Flash Heal
			(function() return dynEval('lowest.health <= ' .. fetchKey('NePConfPriestHoly', 'FlashHealRaid')) end),
			'!player.moving'
		}, 'lowest' },
	}, '!player.casting.percent >= 50' },

	-- Shields
	{ '17', {  --Power Word: Shield
		(function() return dynEval('focus.health <= ' .. fetchKey('NePConfPriestHoly', 'ShieldTank')) end),
		'!focus.debuff(6788).any', 
		'focus.spell(17).range'
	}, 'focus' },
	{ '17', {  --Power Word: Shield
		(function() return dynEval('tank.health <= ' .. fetchKey('NePConfPriestHoly', 'ShieldTank')) end),
		'!tank.debuff(6788).any',
		'tank.spell(17).range'
	}, 'tank' },
	{ '17', { --Power Word: Shield
		(function() return dynEval('player.health <= ' .. fetchKey('NePConfPriestHoly', 'ShieldPlayer')) end),
		'!player.debuff(6788).any', 
		'!player.buff(17).any'
	}, 'player' }, 
	{ '17', { --Power Word: Shield
		(function() return dynEval('lowest.health <= ' .. fetchKey('NePConfPriestHoly', 'ShieldRaid')) end),
	 	'!lowest.debuff(6788).any', 
		'!lowest.buff(17).any',
	}, 'lowest' },

	-- Renew
	{ '139', { -- Renew
		(function() return dynEval('focus.health <= ' .. fetchKey('NePConfPriestHoly', 'RenewTank')) end),
		'!focus.buff(139)', 
		'focus.spell(139).range'
	}, 'focus' },
	{ '139', { -- Renew
		(function() return dynEval('tank.health <= ' .. fetchKey('NePConfPriestHoly', 'RenewTank')) end),
		'!tank.buff(139)', 
		'tank.spell(139).range'
	}, 'tank' },
	{ '139', { -- Renew
		(function() return dynEval('player.health <= ' .. fetchKey('NePConfPriestHoly', 'RenewPlayer')) end), 
		'!player.buff(139)'
	}, 'player' },
	{ '139', { -- Renew
		(function() return dynEval('lowest.health <= ' .. fetchKey('NePConfPriestHoly', 'RenewRaid')) end),
		'!lowest.buff(139)',
	}, 'lowest' },

	-- Prayer of Mending
	{ '33076', { --Prayer of Mending
		(function() return dynEval('focus.health <= ' .. fetchKey('NePConfPriestHoly', 'PrayerofMendingTank')) end),
		'focus.spell(33076).range',
		'!player.moving'
	}, 'focus' },
	{ '33076', { --Prayer of Mending
		(function() return dynEval('tank.health <= ' .. fetchKey('NePConfPriestHoly', 'PrayerofMendingTank')) end),
		'tank.spell(33076).range',
		'!player.moving'
	}, 'tank' },

	-- binding heal
	{ '32546', {
		(function() return dynEval('focus.health <= ' .. fetchKey('NePConfPriestHoly', 'BindingHealTank')) end),
		'player.health < 60',
		'focus.spell(32546).range',
		'!player.moving'
	}, 'focus' },
	{ '32546', {
		(function() return dynEval('tank.health <= ' .. fetchKey('NePConfPriestHoly', 'BindingHealTank')) end),
		'player.health <= 60', 
		'tank.spell(32546).range',
		'!player.moving'
	}, 'tank' },
	{ '32546', {
		(function() return dynEval('lowest.health <= ' .. fetchKey('NePConfPriestHoly', 'BindingHealRaid')) end),
		'player.health < 60',
		'!player.moving'
	}, 'lowest' },

	-- Heal
	{ '2060', { -- Heal
		(function() return dynEval('focus.health <= ' .. fetchKey('NePConfPriestHoly', 'HealTank')) end), 
		'focus.spell(2060).range',
		'!player.moving'
	}, 'focus' },
	{ '2060', { -- Heal
		(function() return dynEval('tank.health <= ' .. fetchKey('NePConfPriestHoly', 'HealTank')) end), 
		'tank.spell(2060).range',
		'!player.moving'
	}, 'tank' },
	{ '2060', { -- Heal	
		(function() return dynEval('player.health <= ' .. fetchKey('NePConfPriestHoly', 'Heal')) end),
		'!player.moving'
	}, 'player' },
	{ '2060', { -- Heal	
		(function() return dynEval('lowest.health <= ' .. fetchKey('NePConfPriestHoly', 'HealRaid')) end),
		'!player.moving'
	}, 'lowest' },
}

local SoloCombat = {

	-- Proc's
	{ '596', { -- Prayer of healing // Divine Insigt
		'@coreHealing.needsHealing(95, 3)',
		'player.buff(123267)',
		'!player.moving',
		'modifier.party', 
		'!modifier.raid'
	}, 'lowest' },
	{ '2061', { -- Flash heal // Surge of light
		'lowest.health < 100',
		'player.buff(114255)',
		'!player.moving'
	}, 'lowest' },

	-- Heal Fast Bitch!!
		-- Desperate Prayer
			{ '19236',  --Desperate Prayer
				(function() return dynEval('player.health <= ' .. fetchKey('NePConfPriestHoly', 'DesperatePrayer')) end),
			'player' },

		-- Holy Word Serenity
			{ '88684', -- Holy Word Serenity
				(function() return dynEval('player.health <= ' .. fetchKey('NePConfPriestHoly', 'HolyWordSerenityPlayer')) end), 
			'player' },

		-- Flash Heal
			{ '2061', { --Flash Heal
				(function() return dynEval('player.health <= ' .. fetchKey('NePConfPriestHoly', 'FlashHealPlayer')) end),
				'!player.moving'
			}, 'player' },

	-- Shields
	{ '17', { --Power Word: Shield
		(function() return dynEval('player.health <= ' .. fetchKey('NePConfPriestHoly', 'ShieldPlayer')) end),
		'!player.debuff(6788).any', 
		'!player.buff(17).any'
	}, 'player' },

	-- Renew
	{ '139', { -- Renew
		(function() return dynEval('player.health <= ' .. fetchKey('NePConfPriestHoly', 'RenewPlayer')) end), 
		'!player.buff(139)'
	}, 'player' },
	
	{ '32379', (function() return NeP.Core.AutoDots('32379', 0, 20) end) }, -- SW:D
	{ '589', (function() return NeP.Core.AutoDots('589') end) }, -- SW:P 
	
	-- DPS
		
		-- AoE
		{ '48045', (function() return NeP.Core.SAoE(3, 10) end), 'target' }, -- mind sear
			
		-- Single
		{ '129250', {'target.range <= 30', 'target.enemie'}, 'target' }, -- PW:S
		{ '589', '!target.debuff(589)', 'target' }, -- SW:P
		{ '585', {  --Smite
			'!player.moving', 
			'target.spell(585).range' 
		}, 'target' },
}

local outCombat = {
	{ All },

	{{-- AOE
   		{ '34861', '@coreHealing.needsHealing(90, 3)', 'lowest'}, -- Circle of Healing
		{ '121135', { -- cascade
			'@coreHealing.needsHealing(95, 3)', 
			'!player.moving'
		}, 'lowest'},
		-- Divine Hymn
			{ '64843', { -- Divine Hymn
				'@coreHealing.needsHealing(50, 3)', 
				'modifier.party' 
			}},
			{ '64843', { -- Divine Hymn
				'@coreHealing.needsHealing(60, 5)', 
				'modifier.raid', 
				'!modifier.members > 10' 
			}},
			{ '64843', {  -- Divine Hymn
				'@coreHealing.needsHealing(60, 8)', 
				'modifier.raid', 
				'modifier.members > 10' 
			}},
		{ '596', (function() return _PoH() end) },-- Prayer of Healing
   		{ '155245', (function() return _ClarityOfPurpose() end), 'lowest' },-- Clarity Of Purpose
	}, 'modifier.multitarget' },
	   	
	-- Heals
	{ '139', {  -- Renew
		(function() return dynEval('lowest.health <= ' .. fetchKey('NePConfPriestHoly', 'RenewRaid')) end),
		'!lowest.buff(139)'
	}, 'lowest' },	
			
	{ '2061', {  --Flash Heal
		'!player.moving', 
		(function() return dynEval('lowest.health <= ' .. fetchKey('NePConfPriestHoly', 'FlashHealRaid')) end),
	}, 'lowest' },
			
	{ '2060', { -- Heal
		(function() return dynEval('lowest.health <= ' .. fetchKey('NePConfPriestHoly', 'HealRaid')) end),
		'!player.moving'
	}, 'lowest' },
}


local inCombat = {
	{ '586', 'target.threat >= 80' }, -- Fade
	{ '#5512', (function() return dynEval('player.health <= ' .. fetchKey('NePConfPriestHoly', 'Healthstone')) end) }, -- HEALTHSTONE 
	{ All },
	-- Dispell
	{ '527', 'player.dispellAll(527)' },
	{ MoveFast, -- We only want to run these on unlockers that can cast on unit.ground
		(function()
			if FireHack or oexecute then
				return fetchKey('NePConfPriestHoly', 'Feathers') 
			end
		end)  
	},
	{ Cooldowns, 'modifier.cooldowns' },
	{ RaidCombat, 'modifier.party' },
	{ SoloCombat, '!modifier.party' },
}

NeP.Engine.registerRotation(257, '[|cff'..NeP.Interface.addonColor..'NeP|r] Priest - Holy', inCombat, outCombat, init)