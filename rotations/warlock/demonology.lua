local config = {
	key = 'NePConfWarlockDemo',
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Warlock Demonology Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		{type = 'text', text = 'Keybinds:', align = 'center'},		
			--stuff
		{type = 'spacer'},{type = 'rule'},
		{type = 'text', text = 'DPS:', align = 'center'},
			--stuff
		{type = 'spacer'},{type = 'rule'},
		{type = 'text', text = 'Survival:', align = 'center'},
			--stuff
	}
}

NeP.Interface.buildGUI(config)

local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfWarlockDemo') end)
end

local Shared = {
	
}

local Cooldowns = {
	
}

local Moving = {
	
}

local inCombat = {
	
}

local outCombat = {
	{Shared},
}

NeP.Engine.registerRotation(266, '[|cff'..NeP.Interface.addonColor..'NeP|r] Warlock - Demonology',
	{ -- In-Combat
		{Shared},
		{Moving, "player.moving"},
		{{ -- Conditions
			{Cooldowns, "modifier.cooldowns"},
			{inCombat}
		}, "!player.moving" },
	},outCombat, exeOnLoad)