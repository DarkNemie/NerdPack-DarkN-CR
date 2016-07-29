local dynEval = DarkNCR.dynEval
local fetchKey = NeP.Interface.fetchKey

local config = {
	key = "NePConfPalaProt",
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick.." Config",
	subtitle = "Paladin Protection Settings",
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
    
	}
}

NeP.Interface.buildGUI(config)

local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfPalaProt') end)
end

local Survival = {
	{'Lay on Hands', 'player.health < 15'},
}

local Cooldowns = {
	{'Ardent Defender', 'player.health < 30'}
}

local AoE = {
	
}

local InCombat = {
	{'Avenger\'s Shield'},
	{'Consecration', 'target.range < 8'},
	{'Light of the Protector', 'player.buff(Consecration)'},
	{'Shield of the Righteous', 'spell.charges(Shield of the Righteous) > 2'},
	{'Shield of the Righteous', {
		'player.buff(Consecration)',
		'!player.buff(Shield of the Righteous)'
	}},
	{'Hammer of the Righteous', 'player.buff(Consecration)'},
	{'Hammer of the Righteous', 'spell.charges(Hammer of the Righteous) > 1'},
	{'Judgment'}
}

local outCombat = {

}

NeP.Engine.registerRotation(66, '[|cff'..NeP.Interface.addonColor..'NeP|r] Paladin - Protection', 
	{ -- In-Combat
		{Survival, "player.health < 100"},
		{Cooldowns, "modifier.cooldowns"},
		--{AoE, 'player.area(40).enemies >= 3'},
		{InCombat}
	}, outCombat, exeOnLoad)