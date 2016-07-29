local dynEval = DarkNCR.dynEval
local PeFetch = NeP.Interface.fetchKey

local config = {
	key = 'NePConfigMageFrost',
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Mage Frost Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{ type = 'rule' },
		{ type = 'header',text = 'General settings:', align = 'center' },
			--Empty
		{ type = 'spacer' },{ type = 'rule' },
		{ type = 'header', text = 'Survival Settings', align = 'center' },
			
			-- Survival Settings:
			{type = 'spinner',text = 'Healthstone - HP',key = 'Healthstone',width = 50, default = 75,},
	}
}

NeP.Interface.buildGUI(config)

local lib = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfigMageFrost') end)
  	NeP.Interface.CreateToggle(
  		'cleave', 
  		'Interface\\Icons\\spell_frost_frostbolt', 
  		'Disable Cleaves', 
  		'Disable casting of Cone of Cold and Ice Nova for Procs.')
end


local Survival = {
	{ '#5512', (function() return dynEval('player.health <= ' .. PeFetch('NePConfigMageFrost', 'Healthstone')) end) }, --Healthstone
	{ '1953', 'player.state.root' }, -- Blink
	{ '475', { -- Remove Curse
		'!lastcast(475)', 
		'player.dispellable(475)' 
	}, 'player' }, 
}

local Cooldowns = {
	{ 'Rune of Power', { '!player.buff(Rune of Power)', '!player.moving' }, 'player.ground' }, 
	{ '12472' },--Icy Veins
	{ 'Mirror Image' },
}

local inCombat = {

	-- Moving
	{ 'Ice Floes', 'player.moving' },

	-- Procs
	{ '44614', 'player.buff(Brain Freeze)', 'target' },-- Frostfire Bolt
	{ '30455', 'player.buff(Fingers of Frost)', 'target' },-- Ice Lance

	-- Frost Bomb
	{ 'Frost Bomb', { 
		'target.debuff(Frost Bomb).duration <= 3', 
		'talent(5, 1)' 
	}},

	{{ -- AoE
		{ '84714' },--Frozen Orb
		{ 'Ice Nova', 'talent(5, 3)'},
		{ '120' },--Cone of Cold
		{ '10', nil, 'target.ground' },--Blizzard
	}, 'player.area(40).enemies >= 3' },
	

	-- Main Rotation
	{ '84714', '!toggle.cleave' }, -- Frozen Orb
	{ 'Ice Nova', { '!toggle.cleave', 'talent(5, 3)' } },
	{ '120', { '!toggle.cleave' } },--Cone of Cold
	{ '116' },--Frostbolt
	
}

local outCombat = {
	-- Buffs
	{ 'Arcane Brilliance', '!player.buff(Arcane Brilliance)' },
	{ 'Summon Water Elemental', '!pet.exists'}
}

NeP.Engine.registerRotation(64, '[|cff'..NeP.Interface.addonColor..'NeP|r] Mage - Frost',
	{ -- In-Combat
		-- Rotation Utilities
		{ 'pause', 'modifier.lalt' },
		{ 'Rune of Power', 'modifier.lcontrol', 'player.ground' },
		{ '2139', 'target.interruptAt(40)' },--Counterspell
		{Survival, 'player.health < 100'},
		{Cooldowns, 'modifier.cooldowns'},
		{inCombat, { 'target.infront', 'target.exists', 'target.range <= 40' }},
	}, outCombat, lib)