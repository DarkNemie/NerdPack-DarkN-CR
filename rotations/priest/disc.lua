local dynEval = DarkNCR.dynEval
local fetchKey = NeP.Interface.fetchKey

local config = {
	key = 'NePconfPriestDisc',
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Priest Discipline Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{type = 'header', text = 'General Settings:', align = 'center'},
			{type = 'checkbox', text = 'Move Faster', key = 'Feathers', default = true, desc = 'This checkbox enables or disables the automatic use of feathers & others to move faster.'},
			{type = 'spinner', text = 'Power Word: Barrier', key = 'PWB', default = 3,min = 1,max = 5},
			{type = 'spinner', text = 'MassDispell', key = 'MDispell', default = 3,min = 1,max = 5},
			{type = 'dropdown',
				text = 'Pain Suppression', key = 'PainSuppression', 
				list = {
			    	{text = 'Lowest',key = 'Lowest'},
			        {text = 'Tank',key = 'Tank'},
			    	{text = 'Focus',key = 'Focus'}
		    	}, 
		    	default = 'Lowest', 
		    	desc = 'Select Who to use Pain Suppression on.' 
		   },
			{type = 'dropdown',
				text = 'Pain Suppression', key = 'PainSuppressionTG', 
				list = {
			    	{text = 'Allways',key = 'Allways'},
			        {text = 'Boss',key = 'Boss'}
		    	}, 
		    	default = 'Allways', 
		    	desc = 'Select When to use Pain Suppression.' 
		   },
			{type = 'spinner', text = 'Pain Suppression', key = 'PainSuppressionHP', default = 25},
			{type = 'spinner', text = 'Attonement', key = 'Attonement', default = 70},
			{type = 'spinner', text = 'Saving Grace', key = 'SavingGrace', default = 35},
			{type = 'spinner', text = 'Emergency Heals', key = 'FastHeals', default = 35},
		
		-- Tank/Focus
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = 'Tank/Focus Settings:', align = 'center'},
			{type = 'spinner', text = 'Clarity Of Will', key = 'ClarityofWillTank', default = 99},
			{type = 'spinner', text = 'Power Word: Shield', key = 'PowerShieldTank', default = 99},
			{type = 'spinner', text = 'Penance', key = 'PenanceTank', default = 70},
			{type = 'spinner', text = 'Flash Heal', key = 'FlashHealTank', default = 60},
			{type = 'spinner', text = 'Heal', key = 'HealTank', default = 99},
		
		-- Player
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = 'Player Settings:', align = 'center'},
			{type = 'spinner', text = 'Clarity Of Will', key = 'ClarityofWillPlayer', default = 99},
			{type = 'spinner', text = 'Power Word: Shield', key = 'PowerShieldPlayer', default = 99},
			{type = 'spinner', text = 'Penance', key = 'PenancePlayer', default = 60},
			{type = 'spinner', text = 'Flash Heal', key = 'FlashHealPlayer', default = 40},
			{type = 'spinner', text = 'Heal', key = 'HealPlayer', default = 99},
		
		-- Raid
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = 'Raid Settings:', align = 'center'},
			{type = 'spinner', text = 'Clarity Of Will', key = 'ClarityofWillRaid', default = 60},
			{type = 'spinner', text = 'Power Word: Shield', key = 'PowerShieldRaid', default = 60},
			{type = 'spinner', text = 'Penance', key = 'PenanceRaid', default = 60},
			{type = 'spinner', text = 'Flash Heal', key = 'FlashHealRaid', default = 40},
			{type = 'spinner', text = 'Heal', key = 'HealRaid', default = 99},
	}
}

NeP.Interface.buildGUI(config)

local init = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePconfPriestDisc') end)
	NeP.Interface.CreateToggle(
		'autoGround', 
		'Interface\\Icons\\Ability_priest_bindingprayers.png', 
		'Automated Ground Spells', 
		'Enable the use of automated ground spells like MassDispell & Power Word: Barrier.\nOnly Works if using a Advanced Unlocker.')
	NeP.Interface.CreateToggle(
		'focusDps', 
		'Interface\\Icons\\Ability_priest_atonement.png', 
		'Enable Agressive Mode', 
		'Will only heal if lowest is bellow 60%.')
end

local _MassDispell = function()
    if IsUsableSpell('32375') then
		if select(2, GetSpellCooldown('62618')) == 0 then
			local total = 0        
			for i=1,#NeP.OM.unitFriend do
				local Obj = NeP.OM.unitFriend[i]
				if Obj.distance <= 40 then
					for j = 1, 40 do
						local debuffName, _,_,_, dispelType, duration, expires,_,_,_,_,_,_, _,_,_ = UnitDebuff(Obj.key, j)
						if dispelType and dispelType == 'Magic' or dispelType == 'Disease' then
							total = total + 1
						end
					end
				end
				if total >= fetchKey('NePconfPriestDisc', 'MDispell')  then
					NeP.Engine.CastGround('32375', Obj.key)
					return true
				end
			end
		end
	end
	return false
end

local _PWBarrier = function()
	if IsUsableSpell('62618') then
		if select(2, GetSpellCooldown('62618')) == 0 then
			local minHeal = GetSpellBonusDamage(2) * 1.125
			local total = 0
			for i=1,#NeP.OM.unitFriend do
				local Obj = NeP.OM.unitFriend[i]
				if Obj.distance <= 40 then
					if max(0, Obj.maxHealth - Obj.actualHealth) > minHeal then
						total = total + 1
					end
				end
				if total >= fetchKey('NePconfPriestDisc', 'PWB')  then
					NeP.Engine.CastGround('62618', Obj.key)
					return true
				end
			end
		end
	end
	return false
end

local _holyNova = function()
	local minHeal = GetSpellBonusDamage(2) * 1.125
	local total = 0
		for i=1,#NeP.OM.unitFriend do
			local Obj = NeP.OM.unitFriend[i]
			if Obj.distance <= 12 then
				if max(0, Obj.maxHealth - Obj.actualHealth) > minHeal then
					total = total + 1
				end
			end
		end
	return total > 3
end

local _PoH = function()
	return false
end

local Keybinds = {
	{'32375', 'modifier.lshift', 'ground'}, -- MassDispell
	{'62618', 'modifier.lcontrol', 'ground'}, -- Power Word: Barrier
}

local Attonement = {
	-- Holy Fire
	{'14914', nil, 'target'},
	-- Penance
	{'47540', nil, 'target'},
	-- Smite
	{'585', nil, 'target'},
}

local HealFast = {
	{'Gift of the Naaru', nil, 'lowest'},
	-- Penance
	{'!47540', nil, 'lowest'},
	-- Power Word: Shield
	{'!17', {
		'!lowest.debuff(6788).any', 
		'!lowest.buff(17).any',
	}, 'lowest'},
	-- Flash Heal
	{'!2061', nil, 'lowest'},
}

local AoE = {
	{'121135', '@coreHealing.needsHealing(95, 3)', 'lowest'}, -- Cascade
	{'33076', {--Prayer of Mending // FIXME needs TWeaking
		'tank.health <= 80',
		'@coreHealing.needsHealing(90, 3)',
		'!player.moving', 
		'tank.spell(33076).range' 
	}, 'tank'},
 	{'596', (function() return _PoH() end)},-- Prayer of Healing
   	{'132157', (function() return _holyNova() end), nil}, -- Holy Nova
}

local Shared = {
	-- Fortitude
	{'21562', '!player.buffs.stamina'},
	
	{{-- LoOk aT It GOoZ!!!
		{'121536', {
			'player.movingfor > 2', 
			'!player.buff(121557)', 
			'player.spell(121536).charges >= 1' 
		}, 'player.ground'},
		{'17', {
			'talent(2, 1)', 
			'player.movingfor > 2', 
			'!player.buff(17)',
		}, 'player'},
	}, (function() return fetchKey('NePconfPriestDisc', 'Feathers') end)},
}

local SpiritShell = {
	-- Prayer of Healing
   	{'596', (function() return _PoH() end)},
   	-- Flash Heal
	{'!2061', 'lowest.health <= 40', 'lowest'},
	-- Heal
	{'2060', 'lowest.health >= 40', 'lowest'},
}

local ClarityOfWill = {
	-- tank
	{'152118', {
		(function() return dynEval('tank.health <= '..fetchKey('NePconfPriestDisc', 'ClarityofWillTank')) end),
		'!tank.buff(152118).any'	
	}, 'tank'},
	-- focus
	{'152118', {
		(function() return dynEval('focus.health <= '..fetchKey('NePconfPriestDisc', 'ClarityofWillTank')) end),
		'!focus.buff(152118).any'	
	}, 'focus'},
	-- player
	{'152118', {
		(function() return dynEval('player.health <= '..fetchKey('NePconfPriestDisc', 'ClarityofWillPlayer')) end),
		'!player.buff(152118).any'	
	}, 'player'},
	-- raid
	{'152118', {
		(function() return dynEval('lowest.health <= '..fetchKey('NePconfPriestDisc', 'ClarityofWillRaid')) end),
		'!lowest.buff(152118).any'		
	}, 'lowest'},
}

local SavingGrace = {
	{'!152116', (function() return dynEval('tank.health <= '..fetchKey('NePconfPriestDisc', 'SavingGrace')) end), 'tank'},
	{'!152116', (function() return dynEval('focus.health <= '..fetchKey('NePconfPriestDisc', 'SavingGrace')) end), 'focus'},
	{'!152116', (function() return dynEval('player.health <= '..fetchKey('NePconfPriestDisc', 'SavingGrace')) end), 'player'},
	{'!152116', (function() return dynEval('lowest.health <= '..fetchKey('NePconfPriestDisc', 'SavingGrace')) end), 'lowest'},
}

local Cooldowns = {
	-- Power Infusion
	{'10060', 'player.mana < 80'},
	-- Spirit Shell // Party
	{'109964', {
		'@coreHealing.needsHealing(60, 3)',
		'modifier.party'
	}},
	-- Spirit Shell // Raid
	{'109964', {
		'@coreHealing.needsHealing(60, 5)',
		'modifier.raid'
	}},
}

local PainSuppression = {	
		{{-- ALL
		{'33206', {
			(function() return fetchKey('NePconfPriestDisc', 'PainSuppression') == 'Focus' end),
			(function() return dynEval('focus.health <= '..fetchKey('NePconfPriestDisc', 'PainSuppressionHP')) end)
		}, 'focus'},
		{'33206', {
			(function() return fetchKey('NePconfPriestDisc', 'PainSuppression') == 'Tank' end),
			(function() return dynEval('tank.health <= '..fetchKey('NePconfPriestDisc', 'PainSuppressionHP')) end)
		}, 'tank'},
		{'33206', {
			(function() return fetchKey('NePconfPriestDisc', 'PainSuppression') == 'Lowest' end),
			(function() return dynEval('lowest.health <= '..fetchKey('NePconfPriestDisc', 'PainSuppressionHP')) end)
		}, 'lowest'},
	}, (function() return fetchKey('NePconfPriestDisc', 'PainSuppressionTG') == 'Allways' end)},

	{{-- Boss
		{'33206', {
			(function() return fetchKey('NePconfPriestDisc', 'PainSuppression') == 'Focus' end),
			(function() return dynEval('focus.health <= '..fetchKey('NePconfPriestDisc', 'PainSuppressionHP')) end),
		}, 'focus'},
		{'33206', {
			(function() return fetchKey('NePconfPriestDisc', 'PainSuppression') == 'Tank' end),
			(function() return dynEval('tank.health <= '..fetchKey('NePconfPriestDisc', 'PainSuppressionHP')) end),
		}, 'tank'},
		{'33206', {
			(function() return fetchKey('NePconfPriestDisc', 'PainSuppression') == 'Lowest' end),
			(function() return dynEval('lowest.health <= '..fetchKey('NePconfPriestDisc', 'PainSuppressionHP')) end),
		}, 'lowest'},
	}, {'target.boss', (function() return fetchKey('NePconfPriestDisc', 'PainSuppressionTG') == 'Boss' end)}}
}

local Solo = {
	{'32379', (function() return NeP.Core.AutoDots('32379', 0, 20) end)}, -- SW:D
	{'589', (function() return NeP.Core.AutoDots('589') end)}, -- SW:P 

  	-- CD's
	{'10060', 'modifier.cooldowns'}, -- Power Infusion 
	{'585', nil, 'target'}, -- Smite
}

local Moving = {
	-- Power Word: Shield
	{'17', {
		'lowest.health <= 30',
		'!lowest.debuff(6788).any', 
		'!lowest.buff(17).any',
	}, 'lowest'},
	-- Penance
	{'47540', 'lowest.health <= 30', 'lowest'},
}

local PartyRaid = {
	-- Surge of Light
	{'2061', 'player.buff(114255)', 'lowest'},

	{SavingGrace, {-- Saving Grace // Talent
		'talent(7,3)',
		'!player.debuff(155274) >= 3',
	}},

	{PainSuppression},

	{{-- Auto Ground ON
		-- MassDispell
		{'32375', (function() return _MassDispell() end)},
		-- Power Word: Barrier
		{'62618', (function() return _PWBarrier() end)},
	}, 'toggle.autoGround'},
	
	{Cooldowns, 'modifier.cooldowns'},

	-- Borrowed Time
	{'17', {
		'!lowest.debuff(6788).any',
		'player.buff(59889).duration <= 2'
	}, 'lowest'},  

	{ClarityOfWill, 'talent(7,1)'}, -- Clarity of Will // Talent

	{SpiritShell, 'player.buff(109964)'}, -- SpiritShell // Talent


	{HealFast, {
		(function() return dynEval('lowest.health <= '..fetchKey('NePconfPriestDisc', 'FastHeals')) end),
		'!player.casting.percent >= 65', 
	}},

	{Attonement, {
		'toggle.focusDps',
		'lowest.health >= 60',
		'target.range <= 30',
		'target.enemy'
	}},

	{Attonement, {
		(function() return dynEval('lowest.health >= '..fetchKey('NePconfPriestDisc', 'Attonement')) end), 
		'!player.buff(81661).count = 5', 
		'player.mana > 20', 
		'target.range <= 30',
		'target.enemy'
	}},

	{AoE, 'modifier.multitarget'},

	-- Player
	{'19236', 'player.health <= 20', 'player'}, --Desperate Prayer
	{'#5512', 'player.health <= 35'}, -- HealthStone
	{'586', 'target.threat >= 80'}, -- Fade
	{'123040', 'player.mana < 85', 'target'}, -- Mindbender
	{'34433', 'player.mana < 85', 'target'}, -- Shadowfiend

	-- Penance
	{'47540', (function() return dynEval('tank.health <= '..fetchKey('NePconfPriestDisc', 'PenanceTank')) end), 'tank'},
	{'47540', (function() return dynEval('focus.health <='..fetchKey('NePconfPriestDisc', 'PenanceTank')) end), 'focus'},
	{'47540', (function() return dynEval('player.health <= '..fetchKey('NePconfPriestDisc', 'PenancePlayer')) end), 'player'},
	{'47540', (function() return dynEval('lowest.health <= '..fetchKey('NePconfPriestDisc', 'PenanceRaid')) end), 'lowest'},
	
	-- Power Word: Shield
	{'17', '@coreHealing.lowestDebuff(6788, 95)'},
	
	-- Flash Heal
	{'2061', (function() return dynEval('tank.health <= '..fetchKey('NePconfPriestDisc', 'FlashHealTank')) end), 'tank'},
	{'2061', (function() return dynEval('focus.health <= '..fetchKey('NePconfPriestDisc', 'FlashHealTank')) end), 'focus'},
	{'2061', (function() return dynEval('player.health <= '..fetchKey('NePconfPriestDisc', 'FlashHealPlayer')) end), 'player'},
	{'2061', (function() return dynEval('lowest.health <= '..fetchKey('NePconfPriestDisc', 'FlashHealRaid')) end), 'lowest'}, 
	
	-- Heal
	{'2060', (function() return dynEval('tank.health <= '..fetchKey('NePconfPriestDisc', 'HealTank')) end), 'tank'},
	{'2060', (function() return dynEval('focus.health <= '..fetchKey('NePconfPriestDisc', 'HealTank')) end), 'focus'},
	{'2060', (function() return dynEval('player.health <= '..fetchKey('NePconfPriestDisc', 'HealPlayer')) end), 'player'},
	{'2060', (function() return dynEval('lowest.health <= '..fetchKey('NePconfPriestDisc', 'HealRaid')) end), 'lowest'},
}

local inCombat = {
	{Shared},
	{Keybinds},
	-- Purify
	{'527', 'player.dispellAll(527)'},
	-- Archangel
	{'81700', 'player.buff(81661).count = 5'}, 
	-- Power Word: Solace
	{'129250', 'target.range <= 30', 'target'},
	{Moving, 'player.moving'},
	{PartyRaid, 'modifier.party'},
	{Solo, '!modifier.party'}
}

local outCombat = {
	{Keybinds},
	{Shared}
}

NeP.Engine.registerRotation(256, '[|cff'..NeP.Interface.addonColor..'NeP|r] Priest - Discipline', inCombat, outCombat, init)