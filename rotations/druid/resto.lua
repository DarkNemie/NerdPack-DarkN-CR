local dynEval = DarkNCR.dynEval
local fetchKey = NeP.Interface.fetchKey

local config = {
	key = "NePConfDruidResto",
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick.." Config",
	subtitle = "Druid Restoration Settings",
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{ type = 'rule' },
		{ type = 'header', text = "General settings:", align = "center"},

		-- Focus
		{ type = 'rule' },
		{ type = 'header', text = 'Focus settings:', align = "center"},
			{ type = "spinner", text = "Life Bloom", key = "LifeBloomTank", default = 100},
			{ type = "spinner", text = "Swiftmend", key = "SwiftmendTank", default = 80},
			{ type = "spinner", text = "Rejuvenation", key = "RejuvenationTank", default = 95},
			{ type = "spinner", text = "Wild Mushroom", key = "WildMushroomTank", default = 100},
			{ type = "spinner", text = "Healing Touch", key = "HealingTouchTank", default = 96},

	}
}

NeP.Interface.buildGUI(config)

local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfDruidResto') end)
end	

local Shared = {
	--	keybinds
	{ "740" , "modifier.shift" }, -- Tranq
	{ "!/focus [target=mouseover]", "modifier.alt" }, -- Mouseover Focus
	{ "20484", "modifier.control", "mouseover" }, -- Rebirth

	-- Mark of the Wild
	{ "1126", '!player.buffs.stats'},
}

local inCombat = {

	-- Dispell
	{ "88423", 'player.dispellAll(88423)' },

	{{-- Cooldowns
		{ "29166", "player.mana < 80", "player" }, -- Inervate
		{ "132158" }, -- Nature's Swiftness
		{{ -- Party
			{ "106731", "@coreHealing.needsHealing(85, 3)" },-- Incarnation
			{ "740", "@coreHealing.needsHealing(50, 3)" }, -- Tranq
		}, "modifier.party" },
		{{ -- Raid
			{ "106731", "@coreHealing.needsHealing(85, 6)" },-- Incarnation
			{ "740", "@coreHealing.needsHealing(50, 7)" }, -- Tranq
		}, "modifier.raid" },
	}, "modifier.cooldowns"},
	
	-- Items
		{ "#5512", "player.health < 60" }, --Healthstone
	
	--  Ironbark
		{"Ironbark",{
			"focus.health <= 40",
			"focus.friend",
			"focus.range <= 40"
		},"focus"},
		{"Ironbark",{
			"tank.health <= 40",
			"tank.range <= 40"
		},"tank"},

	-- Genesis
		{ "145518", { -- Genesis
			"!player.spell(18562).cooldown = 0", 
			"lowest.health < 40", 
			"lowest.buff(774)" 
		}, "lowest" }, 

	{{-- FREE Regrowth
		{ "8936", {  
			"lowest.health < 50", 
			"!lowest.buff(8936)", 
			"!player.moving" 
		}, "lowest" },
	}, "player.buff(8936)" },

	{{-- AOE
		{ "48438", { -- Wildgrowth
			"@coreHealing.needsHealing(85, 3)", 
			"!lastcast(48438)"
		}, "lowest" }, 
	}, "modifier.multitarget" },

	{{-- Soul of the Forest
		{ "Regrowth", {
			"!player.moving",
			"focus.range <= 40", 
			"focus.health <=85"
		}, "focus"},
		{ "Regrowth", {
			"!player.moving",
			"tank.range <= 40", 
			"tank.health <=85"
		}, "tank" },
		{ "Regrowth", {
			"!player.moving",
			"lowest.range <= 40", 
			"lowest.health <=85"
		}, "lowest" },
	}, "player.buff(114108)" },

	{{-- Incarnation: Tree of Life
		{ "33763", { -- Lifebloom
			"!lowest.buff(33763)", 
			"lowest.health < 30" 
		}, "lowest" },
		{ "8936", { -- Regrowth
			"player.buff(16870)", 
			"!lowest.buff", 
			"lowest.health < 80" 
		}, "lowest" }, 
	}, "player.buff(33891)" },

	{{-- Clearcasting
		{ "8936", { -- Regrowth
			"!lowest.buff(8936)", 
			"lowest.health < 80", 
			"!player.moving", 
		}, "lowest" }, 
		{ "5185", { -- Healing Touch
			"lowest.health < 80", 
			"!player.moving",
		}, "lowest" },
	}, "player.buff(16870)" },

	{{-- Force of Nature
		{ "102693", {
			"!lastcast(102693)",
			"player.spell(102693).charges >= 1", 
			"tank.range <= 40",
			"@coreHealing.needsHealing(70, 5)"
		}, "tank" },
		{ "102693", {
			"!lastcast",
			"player.spell(102693).charges >= 1", 
			"lowest.range <= 40",
			"@coreHealing.needsHealing(70, 5)"
		}, "lowest" }, 
		{ "102693", {
			"!lastcast",
			"player.spell(102693).charges >= 2", 
			"tank.range <= 40", 
			"tank.health <= 70"
		}, "tank" },  
		{ "102693", {
			"!lastcast",
			"player.spell(102693).charges >= 2", 
			"lowest.range <= 40", 
			"lowest.health <= 70"
		}, "lowest" },
		{ "102693", {
			"!lastcast",
			"player.spell(102693).charges = 3", 
			"tank.range <= 40", 
			"tank.health <= 92"
		}, "tank" }, 
		{ "102693", {
			"!lastcast",
			"player.spell(102693).charges = 3", 
			"lowest.range <= 40", 
			"lowest.health <= 92"
		}, "lowest" },  
	},"talent(4,3)"},

	-- Life Bloom
		{ "33763", { -- Life Bloom
			(function() return dynEval(
				"focus.health <= "..fetchKey('NePConfDruidResto', 'LifeBloomTank')
			) end),
			"!focus.buff(33763)", 
			"focus.spell(33763).range" 
		}, "focus" }, 
		{ "33763", { -- Life Bloom
			(function() return dynEval(
				"tank.health <= "..fetchKey('NePConfDruidResto', 'LifeBloomTank'
			)) end),
			"!tank.buff(33763)", 
			"tank.spell(33763).range" 
		}, "tank" }, 

	{{-- Wild Mushroom
		{ "145205", "!player.totem(145205)", "focus" }, -- Wild Mushroom
    	{ "145205", "!player.totem(145205)", "tank" }, -- Wild Mushroom
	}, "!glyph(146654)" },

	{{-- Wild Mushroom // Glyph of the Sprouting Mushroom
		{ "145205", "!player.totem(145205)", "focus.ground" }, -- Wild Mushroom
		{ "145205", "!player.totem(145205)", "tank.ground" }, -- Wild Mushroom
	}, "glyph(146654)" },
	
	-- Swiftmend
		{ "18562", {  -- Swiftmend
			(function() return dynEval(
				"focus.health <= "..fetchKey('NePConfDruidResto', 'SwiftmendTank')
			) end),
			"focus.buff(774)" 
		}, "focus" },
		{ "18562", { -- Swiftmend
			(function() return dynEval(
				"tank.health <= "..fetchKey('NePConfDruidResto', 'SwiftmendTank')
			) end),
			"tank.buff(774)" 
		}, "tank" },
		{ "18562", { "lowest.health < 30", "lowest.buff(774)" }, "focus" }, -- Swiftmend

	-- Rejuvenation
		{ "774", {
			(function() return dynEval(
				"focus.health <= "..fetchKey('NePConfDruidResto', 'RejuvenationTank')
			) end),
			"!focus.buff", 
			"focus.spell(774).range" 
			}, "focus" },
		{ "774", {
			(function() return dynEval(
				"tank.health <= "..fetchKey('NePConfDruidResto', 'RejuvenationTank')
			) end),
			"!tank.buff", 
			"tank.spell(774).range" 
			}, "tank" },
		{ "774", {
			"!lowest.buff", 
			"lowest.health < 65" 
		}, "lowest" },

	{{-- Germination // Talent
		{ "774", {
			(function() return dynEval(
				"focus.health <= "..fetchKey('NePConfDruidResto', 'RejuvenationTank')
			) end),
			"!focus.buff(155777)", 
			"focus.spell(774).range" 
		}, "focus" },
		{ "774", {
			(function() return dynEval(
				"tank.health <= "..fetchKey('NePConfDruidResto', 'RejuvenationTank')
			) end),
			"!tank.buff(155777)", 
			"tank.spell(774).range" 
		}, "tank" },
		{ "774", { 
			"!lowest.buff(155777)", 
			"lowest.health < 65" 
		}, "lowest" },
	}, "talent(7,2)" },
	
	{{-- Regrowth EMERGENCY
		{ "!8936", {  -- Regrowth
			"lowest.health < 20", 
			"!player.moving" 
		}, "lowest" },
	}, "!player.casting.percent >= 50" },

	-- Regrowth	
		{ "8936", {  -- Regrowth
			"lowest.health < 50", 
			"!lowest.buff(8936)", 
			"!player.moving" 
		}, "lowest" },

	-- Healing Touch
	 	{ "5185", {  -- Healing Touch
	 		(function() return dynEval(
				"focus.health <= "..fetchKey('NePConfDruidResto', 'HealingTouchTank')
			) end), 
		 	"!player.moving" 
		}, "focus" },
		{ "5185", { -- Healing Touch
			(function() return dynEval(
				"tank.health <= "..fetchKey('NePConfDruidResto', 'HealingTouchTank')
			) end),
			"!player.moving" 
		}, "tank" },
		{ "5185", { "lowest.health < 96", "!player.moving" }, "lowest" }, -- Healing Touch

}

local outCombat = {

	{Shared},

	-- Life Bloom
		{ "33763", { -- Life Bloom
			"tank.health < 100",
			"!tank.buff(33763)", 
			"tank.spell(33763).range" 
		}, "tank" }, 

}

NeP.Engine.registerRotation(105, '[|cff'..NeP.Interface.addonColor..'NeP|r] Druid - Restoration', inCombat, outCombat, exeOnLoad)