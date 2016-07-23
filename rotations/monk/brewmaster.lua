local dynEval = DarkNCR.dynEval
local PeFetch = NeP.Interface.fetchKey
local addonColor = '|cff'..NeP.Interface.addonColor

local config = {
	key = 'NePConfigMonkBM',
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Monk Brewmaster Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		-- Keybinds
		{type = 'header', text = addonColor..'Keybinds:', align = 'center'},
			-- Control
			{type = 'text', text = addonColor..'Control: ', align = 'left', size = 11, offset = -11},
			{type = 'text', text = 'Summon Balck Ox Statue', align = 'right', size = 11, offset = 0 },
			-- Shift
			{type = 'text', text = addonColor..'Shift:', align = 'left', size = 11, offset = -11},
			{type = 'text', text = 'Dizzying Haze', align = 'right', size = 11, offset = 0 },
			-- Alt
			{type = 'text', text = addonColor..'Alt:',align = 'left', size = 11, offset = -11},
			{type = 'text', text = 'Pause Rotation', align = 'right', size = 11, offset = 0 },

		-- General
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = addonColor..'General', align = 'center' },
			{ type = "checkbox", text = "Automated Taunts", key = "canTaunt", default = true },

		-- Survival
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = addonColor..'Survival', align = 'center'},
			{type = 'spinner', text = 'Healthstone', key = 'Healthstone', default = 45},
			{type = 'spinner', text = 'Expel Harm', key = 'ExpelHarm', default = 100},
			{type = 'spinner', text = 'Chi Wave', key = 'ChiWave', default = 100},
			{type = 'spinner', text = 'Guard', key = 'Guard', default = 100},
			{type = 'spinner', text = 'Fortifying Brew', key = 'FortifyingBrew', default = 30},
	}
}

NeP.Interface.buildGUI(config)

local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfigMonkBM') end)
end

local All = {
-- Keybinds
	-- Pause
	{'pause', 'modifier.alt'},
	-- Dizzying Haze
	{'115180', 'modifier.shift', 'mouseover.ground'},
	-- Summon Balck Ox Statue
	{'115315', 'modifier.control', 'mouseover.ground'},

-- Buffs
	-- Legacy of the White Tiger
	{'116781', '!player.buffs.stats'},
}

local FREEDOOM = {
	-- Nimble Brew
	{'137562', 'player.state.disorient'},
	{'137562', 'player.state.stun'}, 
	{'137562', 'player.state.root'},
	{'137562', 'player.state.fear'},
	{'137562', 'player.state.horror'},
	{'137562', 'player.state.snare'},
	
	-- Tiger's Lust
	{'116841', 'player.state.disorient'},
	{'116841', 'player.state.stun'},
	{'116841', 'player.state.root'},
	{'116841', 'player.state.snare'},
}

local Cooldowns = {

}

local Survival = {
	-- Expel Harm
	{'115072', (function() return dynEval('player.health <= '..PeFetch('NePConfigMonkBM', 'ExpelHarm')) end)},
	-- Guard
	{'115295', (function() return dynEval('player.health <= '..PeFetch('NePConfigMonkBM', 'Guard')) end)},
	-- Chi Wave
	{'115098', (function() return dynEval('player.health <= '..PeFetch('NePConfigMonkBM', 'ChiWave')) end)},
	--Healthstone
	{'#5512', (function() return dynEval('player.health <= '..PeFetch('NePConfigMonkBM', 'Healthstone')) end)},
	-- Fortifying Brew
	{'115203', (function() return dynEval('player.health <= '..PeFetch('NePConfigMonkBM', 'FortifyingBrew')) end)},
}

local Interrupts = {
	-- Spear Hand Strike
	{'116705'},
}

local Ranged = {
	-- Crackling Jade Lightning
	{'117952'},
}

local Taunts = {
	-- Provoke
	{'115546', 'target.range <= 35'},
}

local Melle = {
	--[[Use Blackout Kick, to maintain high uptime on Shuffle, the self-buff that it applies.]]
	{'100784', '!player.buff(Shuffle)'},

	--[[Use Keg Smash on cooldown (it generates 2 Chi, so only use when you have 2 or less).]]
	{'121253', 'player.chi <= 2'},

	--[[Use Jab. This is your default Chi builder, and your primary source of dumping Energy. 
	It should only be used when you have around 80 Energy, to prevent capping it.]]
	{'108557', 'player.energy >= 80'},

	--[[Use Tiger Palm to fill any spare global cooldowns. 
	The ability has no resource cost, and it has the benefit of applying a damage-increasing (rather, armor-ignoring) 
	self-buff called Tiger Power. Make sure to maintain 100% uptime on this buff.]]
	{'100787'},
}

local AoE = {
	-- Cast Keg Smash.
	{'121253'},
	
	-- Use Rushing Jade Wind, if you have taken this talent.
	{'Rushing Jade Wind'},

	-- If you have not taken Rushing Jade Wind, use Spinning Crane Kick as a filler.]]
	{'101546'},

	--[[If you have taken Chi Explosion as your tier 7 talent, then use this with 2 Chi in order to build Shuffle, 
	and once you have enough duration on Shuffle (or you do not need it), use Chi Explosion with 4 Chi.]]

	--[[Breath of Fire should only be used against adds that you wish to prevent from casting spells, 
	but it should not otherwise be part of your rotation.]]
}

NeP.Engine.registerRotation(268, '[|cff'..NeP.Interface.addonColor..'NeP|r] Monk - Brewmaster',
	{-- In-Combat
		{All},
		{Survival, 'player.health < 100'},
		{Interrupts, 'target.interruptAt(40)'},
		{FREEDOOM},
		{Taunts, 'modifier.taunt'},
		{Cooldowns, 'modifier.cooldowns'},
		-- Touch of Death, Death Note
		{ '115080', {'player.buff(121125)', 'target.ttd > 5'}, 'target' },
		-- Elusive Brew
		{'115308', 'player.buff(115308).count >= 10'},
		{{-- Conditions
			{AoE, {
				'player.area(8).enemies >= 3', 
				(function() return PeFetch('NePConfigMonkBM', 'canTaunt') end)
			}},
			{Melle, {'target.inMelee', 'target.infront'}},
			--{Ranged, '!target.inMelee'}
		}, {'target.range <= 40', 'target.exists'}}
	}, All, exeOnLoad)
