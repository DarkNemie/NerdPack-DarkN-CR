local dynEval = DarkNCR.dynEval
local PeFetch = NeP.Interface.fetchKey
local addonColor = '|cff'..NeP.Interface.addonColor

local InsanityHack = GetSpellInfo(15407)

local config = {
	key = 'NePConfPriestShadow',
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Priest Shadow Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		-- Keybinds
		{type = 'header', text = addonColor..'Keybinds:', align = 'center'},
			-- Control
			{type = 'text', text = addonColor..'Control: ', align = 'left', size = 11, offset = -11},
			{type = 'text', text = 'Mind Sear', align = 'right', size = 11, offset = 0 },
			-- Shift
			{type = 'text', text = addonColor..'Shift:', align = 'left', size = 11, offset = -11},
			{type = 'text', text = 'Cascade', align = 'right', size = 11, offset = 0 },
			-- Alt
			{type = 'text', text = addonColor..'Alt:',align = 'left', size = 11, offset = -11},
			{type = 'text', text = 'Pause Rotation', align = 'right', size = 11, offset = 0 },
		
		-- [[ General Settings ]]
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = addonColor..'General', align = 'center'},
			{ type = 'checkbox', text = 'Move faster', key = 'canMoveF', default = true },
		
		-- [[ Survival settings ]]
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = addonColor..'Survival', align = 'center'},
			{ type = "spinner", text = "Flash Heal", key = "FlashHeal", default = 35},
	}
}

NeP.Interface.buildGUI(config)

local lib = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfPriestShadow') end)
end

local keybinds = {
	-- Pause
	{'pause', 'modifier.alt'},
	-- Cascade
	{'127632', 'modifier.shift'},
	-- Mind Sear
	{'48045', 'modifier.control'},
}

local Buffs = {
	-- Power Word: Fortitude
	{'21562', '!player.buffs.stamina'},
	-- Shadowform
	{'15473', 'player.stance != 1'},
	--{'1706', 'player.falling'} -- Levitate
	-- Angelic Feather
	{'121536', {
		'player.movingfor > 3',
		'!player.buff(121557)',
		(function() return PeFetch('NePConfPriestShadow', 'canMoveF') end)
	}, 'player.ground'}
}

local Cooldowns = {
	-- Mindbender
	{'123040'},
	 --Shadowfiend
	{'34433'},
	-- Vampiric Embrace
	{'15286', '@coreHealing.needsHealing(65, 3)'}
}

local Survival = {
	-- PW:Shield
	{'17', '!player.buff(17)', 'player'},
	 -- Flash Heal
	{'2061', (function() return dynEval('player.health < '..PeFetch('NePConfPriestShadow', 'FlashHeal')) end), 'player'},
}

local AoE = {
	-- Cascade
	{'127632'},
	-- Mind Sear
	{'48045', 'target.area(8).enemies >= 3'},
}

local Moving = {
	-- Shadow Word: Death
	{'32379', '@DarkNCR.instaKill(20)'},
	-- Shadow Word: Pain.
	{'589', '@DarkNCR.aDot(2)'},
}

local inCombat = {
	-- Void Entropy
	{'155361', {'player.shadoworbs >= 3', '!target.debuff(155361)'}},

	-- Cast Devouring Plague with 3 or more Shadow Orbs.
	{'2944', {'player.shadoworbs >= 3', '!target.debuff(2944)'}},

	-- Cast Mind Blast if you have fewer than 5 Shadow Orbs.
	{'!8092', 'player.shadoworbs < 5', 'target'},

	-- Cast Shadow Word: Death if you have fewer than 5 Shadow Orbs.
	{'!32379', {'player.shadoworbs < 5', '@DarkNCR.instaKill(20)'}},

	-- Cast Insanity on the target when you have the Insanity buff (if you are using the Insanity talent).
	{'/cast '..InsanityHack, 'player.buff(132573).duration > 0.4'},

	-- Cast Mind Spike if you have a Surge of Darkness proc (if you are using this talent).
	{'73510', 'player.buff(Surge of Darkness)'},

	-- Apply and maintain Shadow Word: Pain.
	{'589', '@DarkNCR.aDot(2)'},

	-- Apply and maintain Vampiric Touch.
	{'34914', '@DarkNCR.aDot(3)'},

	{AoE, 'player.area(40).enemies >= 3'},

	-- Cast Mind Flay as your filler spell.
	{'15407'}

} 

local outCombat = {
	{Buffs},
	{keybinds}
}

NeP.Engine.registerRotation(258, '[|cff'..NeP.Interface.addonColor..'NeP|r] Priest - Shadow', 
	{-- In-Combat
		{keybinds},
		{Buffs},
		{Moving, 'player.moving'},
		{Survival, 'player.health < 100'},
		{Cooldowns, 'modifier.cooldowns'},
		{inCombat},
	}, outCombat, lib)