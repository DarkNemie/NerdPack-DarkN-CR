local dynEval = DarkNCR.dynEval
local PeFetch = NeP.Interface.fetchKey

local config = {
	key = 'NePConfPalaRet',
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Paladin Retribution Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
	}
}

NeP.Interface.buildGUI(config)

local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfPalaRet') end)
end

local Buffs = {
	-- Greater Blessing of Wisdom
	{'203539', '!player.buff(203539).any', 'player'},
	-- Greater Blessing of Might
	{'203528', '!player.buff(203528).any', 'player'},
	-- Greater Blessing of Kings
	{'203538', '!player.buff(203538).any', 'player'}
}

local Survival = {
	{'Flash of Light', 'player.health <= 40'}
}

local Cooldowns = {
	{'Crusade'}
}

local AoE = {
	{'Divine Storm'}
}

local ST = {
	{'Templar\'s Verdict'},
	{'Blade of Wrath', 'player.holypower <= 3'},
	{'Judgment'}
}

local Keybinds = {
	-- Pause
	{'pause', 'modifier.alt'},
}

local outCombat = {
	{Keybinds},
	{Buffs},
	{Seals},
}

NeP.Engine.registerRotation(70, '[|cff'..NeP.Interface.addonColor..'NeP|r] Paladin - Retribution', 
	{-- In-Combat
		{Buffs},
		{Keybinds},
		{All},
		{Survival, 'player.health < 100'},
		{Cooldowns, 'modifier.cooldowns'},
		{AoE, 'player.area(8).enemies >= 3'},
		{ST}
	}, outCombat, exeOnLoad)