local dynEval = DarkNCR.dynEval
local PeFetch = NeP.Interface.fetchKey
local addonColor = '|cff'..NeP.Interface.addonColor

local config = {
	key = 'NePconfigMonkMm',
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Monk Mistweaver Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		-- Keybinds
		{type = 'header', text = addonColor..'Keybinds:', align = 'center'},
			-- Control
			{type = 'text', text = addonColor..'Control: ', align = 'left', size = 11, offset = -11},
			{type = 'text', text = 'Summon Jade Serpent Statue', align = 'right', size = 11, offset = 0},
			-- Shift
			{type = 'text', text = addonColor..'Shift:', align = 'left', size = 11, offset = -11},
			{type = 'text', text = '...', align = 'right', size = 11, offset = 0},
			-- Alt
			{type = 'text', text = addonColor..'Alt:',align = 'left', size = 11, offset = -11},
			{type = 'text', text = 'Pause Rotation', align = 'right', size = 11, offset = 0},
		
		-- General
		{type = 'spacer'},{type = 'rule'},
		{type = 'header',text = addonColor..'Tank/Focus:', align = 'center'},

		-- General
		{type = 'spacer'},{type = 'rule'},
		{type = 'header',text = addonColor..'Raid:', align = 'center'},

		-- Survival		
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = addonColor..'Survival:', align = 'center'},	
			
	}
}

NeP.Interface.buildGUI(config)

local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePconfigMonkMm') end)
	NeP.Interface.CreateToggle(
		'trans', 
		'Interface\\Icons\\Inv_boots_plate_dungeonplate_c_05.png', 
		'Enable Casting Transcendence Outside of Combat', 
		'Enable/Disable Casting Transcendence Outside of Combat.')
end

local function Trans()
	-- Transcendence: Transfer
	local usable, nomana = IsUsableSpell('119996');
	local tFound = false;
	for i=1,40 do 
		local B=UnitBuff('player', i); 
		if B=='Transcendence' then tFound = true; break end 
	end
	if not usable or not tFound then return true end
	return false
end

local All = {
	-- Legacy of the Emperor
  	{'115921', '!player.buffs.stats'},
	
	-- Pause
	{'pause', 'modifier.alt'},
	-- Summon Jade Serpent Statue
  	{'115313' , 'modifier.shift', 'tank.ground'},

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

	-- Transcendence: Transfer
	{'119996', 'player.health < 35'},
	-- Transcendence
	{'Transcendence', {
		(function() return Trans() end),
		'toggle.trans'
	}},
}

local inCombatSerpente = {
	
}

local inCombatCrane = {
	
}

local outCombat = {
	{All},
}

NeP.Engine.registerRotation(270, '[|cff'..NeP.Interface.addonColor..'NeP|r] Monk - Mistweaver', 
	{-- In-Combat Change CR dyn
		{All},
		{inCombatSerpente, 'player.stance = 1'}, -- Serpent Stance
		{inCombatCrane, 'player.stance = 2'}, -- Crane Stance
	},outCombat, exeOnLoad)