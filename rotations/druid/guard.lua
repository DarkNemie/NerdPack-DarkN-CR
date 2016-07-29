local dynEval 	= DarkNCR.dynEval
local PeFetch	= NeP.Interface.fetchKey
local addonColor = '|cff'..NeP.Interface.addonColor

local config = {
	key = "NePConfDruidGuard",
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick.." Config",
	subtitle = "Druid Guardian Settings",
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- Keybinds
		{type = 'header', text = addonColor..'Keybinds:', align = 'center'},
			-- Control
			{type = 'text', text = addonColor..'Control: ', align = 'left', size = 11, offset = -11},
			{type = 'text', text = '...', align = 'right', size = 11, offset = 0},
			-- Shift
			{type = 'text', text = addonColor..'Shift:', align = 'left', size = 11, offset = -11},
			{type = 'text', text = '...', align = 'right', size = 11, offset = 0},
			-- Alt
			{type = 'text', text = addonColor..'Alt:',align = 'left', size = 11, offset = -11},
			{type = 'text', text = 'Pause Rotation', align = 'right', size = 11, offset = 0},

		-- General
		{type = 'rule'},
		{type = 'header', text = "General:", align = "center"},
			{type = "checkbox", text = "Bear Form", key = "BearV2", default = false, 
				desc = "Use bear form auto while in combat"
			},

		-- Player
		{type = 'rule'},
		{type = 'header', text = "Survival:", align = "center"},
			{type = "spinner", text = "Healthstone", key = "Healthstone", default = 50},
	}
}

NeP.Interface.buildGUI(config)

local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfDruidGuard') end)
end

local keybinds = {
	-- Pause
	{'pause', 'modifier.alt'},
}

local Shared = {
	{"Mark of the Wild", '!player.buffs.stats'},
}

local Interrupts = {
	-- Skull Bash
	{"Skull Bash"},
	-- Mighty Bash
	{"Mighty Bash"},
}

local Survival = {
	-- Healthstone
	{"#5512", (function() return dynEval("player.health <= "..PeFetch('NePConfDruidGuard', 'Healthstone')) end)},
}

local Cooldowns = {
	--[[Frenzied Regeneration converts up to 60 Rage into health. 
	The ability has a 1.5 second cooldown (but this is affected by your Haste).]]
	{'Frenzied Regeneration'},
	
	--[[Savage Defense increases your dodge chance by 45% for 6 seconds and reduces your Physical damage taken by 25% for the same duration. 
	This ability works on a charge system. 
	You can have a maximum of 2 charges, and it has a 12-second recharge time.]]
	{'Savage Defense'},

	--[[Survival Instincts reduces all damage taken by 50% for 6 seconds. 
	It works a charge system. 
	It has a maximum of 2 charges, and it has a 2-minute recharge time.]]
	{'Survival Instincts'},

	--[[Barkskin is a simple 20% damage reduction, lasting 12 seconds, with a 1-minute cooldown.]]
	{'Barkskin'},
}

local inCombat = {
	{'MoonFire', '!target.debuff(MoonFire)'},
	{'Wrath'}
}

local BearForm = {
	-- Trash (AOE)
	{'Thrash', 'player.area(8).enemies >= 3'},
	
	-- Growl (Taunt)
	{'Growl', 'modifer.taunt'},
	
	-- Use Mangle on cooldown (its cooldown has a chance to be reset by Lacerate, so you need to watch out for this).
	{'Mangle'},
	
	-- Use Lacerate until it has 3 stacks on the target.
	{'Lacerate', '!target.debuff(Lacerate).count > 3'}, -- Lacerate
	
	-- Use Pulverize (consuming the Lacerate stacks).
	{'Pulverize'},
	
	-- Keep up the Thrash bleed (lasts 16 seconds).
	{'Thrash', '!target.debuff(Thrash)'},
	
	--Use Maul only when you are under the effect of a Tooth and Claw proc;
	{'Maul', 'player.buff(Tooth and Claw)'},
	 	
	 --Use Maul only when you are at or very close to maximum Rage;
	 {'Maul', 'player.rage >= 80'},
		
	--Use Maul only when you do not need to use your active mitigation.
		-- FIXME: TODO
	
	-- Re-stack Lacerate to 3 before the 12-second buff from Pulverize expires.
	{'Lacerate'},
}

local CatForm = {
	{'Shred', '!player.combopoints >= 5'},
	{'Ferocious Bite'}
}

local outCombat = {
	{keybinds},
	{Shared},
	{'#trinket1'}
}

NeP.Engine.registerRotation(104, '[|cff'..NeP.Interface.addonColor..'NeP|r] Druid - Guardian', 
	{-- Incombat
		--{keybinds},
		{Shared},
		{Survival, 'player.health < 100'},
		{Interrupts, "target.interruptAt(40)"},
		{Cooldowns, 'modifier.cooldowns'},
		-- Auto Bear Form
		{"5487", {
	  		"player.form != 1", 	-- Stop if bear
	  		"!player.buff(5215)", 	-- Not in Stealth
	  		(function() return PeFetch('NePConfDruidGuard', 'BearV2') end),
	  	}},
		{inCombat, '!player.form > 0'},
		{BearForm, 'player.form == 1'},
		{CatForm, 'player.form == 2'},
	}, outCombat, exeOnLoad)