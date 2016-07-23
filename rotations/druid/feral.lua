local dynEval = DarkNCR.dynEval
local fetchKey = NeP.Interface.fetchKey

local config = {
	key = "NePConfDruidFeral",
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick.." Config",
	subtitle = "Druid Feral Settings",
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{ type = 'rule' },
		{ type = 'header', text = "General settings:", align = "center"},
			-- Buff
			{ type = "checkbox", text = "Buffs", key = "Buffs", default = true, desc =
			 "This checkbox enables or disables the use of automatic buffing."},
			-- Prowl
			{ type = "checkbox", text = "Prowl", key = "Prowl", default = false, desc =
			 "This checkbox enables or disables the use of automatic Prowl when out of combat."},

		-- Player
		{ type = 'rule' },
		{ type = 'header', text = "Player settings:", align = "center"},
			-- Tiger's Fury
			{ type = "spinner", text = "Tigers Fury", key = "TigersFury", default = 35},
			-- Renewal
			{ type = "spinner", text = "Renewal", key = "Renewal", default = 30},
			-- Cenarion Ward
			{ type = "spinner", text = "Cenarion Ward", key = "CenarionWard", default = 75},
			-- Survival Instincts
			{ type = "spinner", text = "Survival Instincts", key = "SurvivalInstincts", default = 75},
			-- Healing Touch
			{ type = "spinner", text = "Healing Touch", key = "HealingTouch", default = 70, Desc=
			"When player as buff (Predatory Swiftness)."},		

	}
}

NeP.Interface.buildGUI(config)

local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfDruidFeral') end)
end

local CatForm = {

	-- rake // prowl with glyph
	{ "1822", {
		"player.buff(5215)", -- prowl
		"player.glyph(127540)" -- Savage Roar
	}, "target" },

  	--	keybinds
  		{{ -- Shift
  			{ "106839", { -- Skull Bash
  				"target.exists",
  				"target.range <= 13"
  			}, "target" },
		  	{ "Mighty Bash", {
  				"target.exists",
  				"target.range <= 13"
  			}, "target" },
		  	{ "77764", "modifier.party" }, -- Stampending Roar
		  	{ "1850" } -- Dash
	  	}, "modifier.shift" },
	  	{{-- Control
	  		{ "Mass Entanglement" },
	  		{ "Ursol's Vortex", "target.exists", "mouseover.ground" }, -- Ursol's Vortex
	  		{ "339" }, -- Entangling Roots
	  	}, "modifier.control" },
	  	{ "Typhoon", { 
	  		"modifier.alt", 
	  		"target.exists"
	  	}, "target" },

  	-- Survival
	{ "Renewal", (function() return dynEval("player.health <= "..fetchKey('NePConfDruidFeral', 'Renewal')) end) }, -- Renewal
	{ "Cenarion Ward", (function() return dynEval("player.health <= "..fetchKey('NePConfDruidFeral', 'CenarionWard')) end) }, -- Cenarion Ward
	{ "61336",(function() return dynEval("player.health <= "..fetchKey('NePConfDruidFeral', 'SurvivalInstincts')) end) }, -- Survival Instincts
	  	
	{{ -- Interrupts
		{ "106839" },	-- Skull Bash
		{ "5211" }, 	-- Mighty Bash
	}, "target.interruptAt(40)" },

	-- Predatory Swiftness (Passive Proc)
	{ "5185", {  -- Healing Touch Player
		(function() return dynEval("player.health <= "..fetchKey('NePConfDruidFeral', 'HealingTouch')) end),
		"player.buff(Predatory Swiftness)",
		"!talent(7,2)"
	}, "player" },
	{ "5185", {  -- Healing Touch Lowest
		"lowest.health < 70",
		"!talent(7,2)",
		"player.buff(Predatory Swiftness)" 
	}, "lowest" },
	{ "5185", {  -- Healing Touch Lowest (BooldTalons TALENT)
		"talent(7,2)",
		"player.combopoints = 5",
		"player.buff(Predatory Swiftness)"
	}, "lowest" },
	{ "5185", { -- Healing Touch EXPIRE
		"player.buff(Predatory Swiftness)", 
		"player.buff(Predatory Swiftness).duration <= 3"
	}, "lowest" },

  	{{--Cooldowns
		{ "106737", {  --Force of Nature
			"player.spell(106737).charges > 2", 
			"!lastcast(106737)", 
			"player.spell(106737).exists" 
		}},
		{ "106951" }, -- Beserk
		{ "124974" }, -- Nature's Vigil
		{ "102543" }, -- incarnation
	}, "modifier.cooldowns" },
  	
	-- Tiger's Fury
	{ "5217", (function() return dynEval("player.energy <= "..fetchKey('NePConfDruidFeral', 'TigersFury')) end) },

	-- Proc's
	{ "106830", "player.buff(Omen of Clarity)", "target" }, -- Free Thrash

	-- Finish
	{ "52610", { -- Savage Roar
		"player.buff(52610).duration <= 4", -- Savage Roar
		"player.buff(174544).duration <= 4", -- Savage Roar GLYPH
		"player.combopoints <= 2" 
	}, "target"},
	{{ -- 5 CP
		{ "1079", { -- Rip // bellow 25% if target does not have debuff
			"target.health < 25", 
			"!target.debuff(1079)" -- stop if target as rip debuff
		}, "target"},
		{ "1079", { -- Rip // more then 25% to refresh
			"target.health > 25", 
			"target.debuff(1079).duration <= 7"
		}, "target"},
		{ "22568", { -- Ferocious Bite to refresh Rip when target at <= 25% health.
			"target.health < 25", 
			"target.debuff(1079).duration < 5" -- RIP
		}, "target"},
		{ "22568", { -- Ferocious Bite // Max Combo and Rip or Savage Roar do not need refreshed
			"target.debuff(1079).duration > 7", -- RIP
			"player.buff(52610).duration > 4" -- Savage Roar
		}, "target"},
		{ "22568", { -- Ferocious Bite // Max Combo and Rip or Savage Roar GLYPH do not need refreshed
			"target.debuff(1079).duration > 7", -- RIP
			"player.buff(174544).duration > 4" -- Savage Roar GLYPH
		}, "target"},
	}, "player.combopoints = 5" },

	{{-- AoE
		{ "106830", "target.debuff(106830).duration < 5", "target" }, -- Tharsh
		{ "106785" }, -- Swipe
	}, 'player.area(40).enemies >= 3' },

	-- Single Rotation
	{ "1822", "target.debuff(155722).duration <= 4", "target" }, -- rake
	{ "155625", { -- MoonFire // Lunar Inspiration (TALENT)
		"target.debuff(155625).duration <= 4",
		"talent(7, 1)"
	}, "target" },
	{ "5221" }, -- Shred
}

local All = {
	-- Buff
	{ "1126", {  -- Mark of the Wild
		'!player.aura(stats)',
		"!player.buff(5215)",-- Not in Stealth
		"player.form = 0", -- Player not in form
		(function() return fetchKey('NePConfDruidFeral','Buffs') end),
	}},
	
	{ "Ursol's Vortex", {
		"modifier.shift", 
		"target.exists"
	}, "mouseover.ground" }, -- Ursol's Vortex
	{ "Disorienting Roar", "modifier.shift" },
	{ "Mighty Bash", {
		"modifier.control", 
		"target.exists"
	}, "target" },
	{ "Typhoon", {
		"modifier.alt", 
		"target.exists"
	}, "target" },
	{ "Mass Entanglement", "modifier.shift" },
}

local inCombat = {
	{All},
	{ CatForm, "player.form = 2" },
}

local outCombat = {
	{All},

	-- Stealth (CAT)
	{"5215", { 
		"player.form = 2", -- If cat
		"!player.buff(5215)", -- Not in Stealth
		"player.form = 2",
		(function() return fetchKey('NePConfDruidFeral','Prowl') end),
	}},
}

NeP.Engine.registerRotation(103, '[|cff'..NeP.Interface.addonColor..'NeP|r] Druid - Feral', inCombat, outCombat, exeOnLoad)