local dynEval = DarkNCR.dynEval
local PeFetch = NeP.Interface.fetchKey

local config = {
	key = 'NePConfigMageArcane',
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Mage Arcane Settings',
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
			{type = 'spinner',text = 'Healthstone - HP',key = 'Healthstone',width = 50,default = 75,},
	}
}

NeP.Interface.buildGUI(config)

local lib = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfigMageArcane') end)
	NeP.Interface.CreateToggle(
		'alter', 
		'Interface\\ICONS\\spell_mage_altertime', 
		'Alter Time', 
		'Toggle the usage of Alter Time and Arcane Power.')
	NeP.Interface.CreateToggle(
		'def', 
		'Interface\\ICONS\\creatureportrait_creature_iceblock', 
		'Survival', 
		'Ice Block when Shit gets serious')
end

local Survival = {
	{ '45438', {'toggle.def','player.health <= 30'}}, --Ice Block
    { '11958', {'toggle.def','player.health <= 25','player.spell(45438).cooldown'}}, --Cold Snap for Reset 
	{ '#5512', (function() return dynEval('player.health <= ' .. PeFetch('NePConfigMageArcane', 'Healthstone')) end) }, --Healthstone
}

local Cooldowns = {
	{ '12042'},-- Arcane Power
    { '12043'},-- Presence of Mind
    { '108978', {'player.buff(12042)','!player.buff(108978)','toggle.alter' }},-- Alter Time
    { '159916'}, -- AMagic
}

local Moving = {
	{ '108839'}, -- Ice Floes
    { '108843', 'player.spell.exists(108843)' }, -- Blazing Speed
}

local inCombat = {
	-- AoE
    { '1449', 'player.area(10).enemies >= 5'},-- Arcane Explosion
    { '120', 'player.area(10).enemies >= 5'},-- Cone of Cold
	
	-- Rotation
    { '114923', {'player.debuff(36032).count >= 4', 'target.debuff(114923).duration <= 3.6'}},-- Nether Tempest
    { '157980', {'modifier.cooldowns','player.spell.exists(157980)'}},-- Supernova
    { '5143', { 'player.debuff(36032).count >= 4', 'player.buff(79683).count >= 3' }},-- Arcane Missiles with 3x Procc
    { '44425', 'player.debuff(36032).count >= 4' },-- Arcane Barrage 
    { '30451' },--Arcane Blast
}

local outCombat = {
	{ '1459', '!player.buff' }, -- Arcane Brilliance
	{ '30455', 'tank.combat', 'target' }, -- Ice Lance
}

NeP.Engine.registerRotation(62, '[|cff'..NeP.Interface.addonColor..'NeP|r] Mage - Arcane', 
	{ -- In-Combat
		-- keybinds
		{ '113724', 'modifier.alt', 'target.ground' }, -- Ring of Frost
		{ '116011', {'modifier.shift','!player.buff(116014)'}, 'player.ground' }, -- Rune of Power
		{{-- Interrupts
			{ '102051' }, -- Frostjaw
			{ '2139' }, -- Counterspell
		}, 'target.interruptAt(40)' },
		{Survival, 'player.health < 100'},
		{Cooldowns, 'modifier.cooldowns'},
		{Moving, 'player.moving'},
		{inCombat, { 'target.infront', 'target.exists', 'target.range <= 40' }},
	}, outCombat, lib)