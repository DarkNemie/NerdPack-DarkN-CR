local config = {
	key = "NePConfDkUnholy",
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick.." Config",
	subtitle = "Deathknight Unholy Settings",
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{ type = 'rule' },
		{ type = 'header', text = "General settings:", align = "center"},

			-- HornOCC
			{ type = "checkbox", text = "Buff out of combat", key = "HornOCC", default = false, desc =
			 "This checkbox enables or disables the use of buffing while out of combat."},

			{ type = "dropdown",text = "Presence", key = "Presence", list = {
		    	{
		          text = "Unholy",
		          key = "Unholy"
		        },{
		          text = "Blood",
		          key = "Blood"
		    	},{
		    	  text = "Frost",
		          key = "Frost"
		    	}}, default = "Unholy", desc = "Select What Presence to use." },

		-- Focus
		{ type = 'rule' },
		{ type = 'header', text = 'Survival settings:', align = "center"},

			-- Icebound Fortitude
			{ type = "spinner", text = "Icebound Fortitude", key = "IceboundFortitude", default = 40},

			-- Death Pact
			{ type = "spinner", text = "Death Pact", key = "DeathPact", default = 50},

			-- Death Siphon
			{ type = "spinner", text = "Death Siphon", key = "DeathSiphon", default = 60},

			-- Death Strike With Dark Succor
			{ type = "spinner", text = "Death Strike with Dark Succor", key = "DeathStrikeDS", default = 80},

		-- Cooldowns
		{ type = 'rule' },
		{ type = 'header', text = "Cooldowns settings:", align = "center"},

			-- Empower Rune Weapon
			{ type = "dropdown",text = "Empower Rune Weapon", key = "ERP", list = {
		    	{
		          text = "Allways",
		          key = "Allways"
		        },{
		          text = "Boss Only",
		          key = "Boss"
		    	}}, default = "Allways" },

		    -- Summon Gargoyle
			{ type = "dropdown",text = "Summon Gargoyle", key = "SG", list = {
		    	{
		          text = "Allways",
		          key = "Allways"
		        },{
		          text = "Boss Only",
		          key = "Boss"
		    	}}, default = "Allways" },

		    -- Unholy Blight
			{ type = "dropdown",text = "Unholy Blight", key = "UB", list = {
		    	{
		          text = "Allways",
		          key = "Allways"
		        },{
		          text = "Boss Only",
		          key = "Boss"
		    	}}, default = "Allways" },

		    -- Blood Fury
			{ type = "dropdown",text = "Blood Fury", key = "BF", list = {
		    	{
		          text = "Allways",
		          key = "Allways"
		        },{
		          text = "Boss Only",
		          key = "Boss"
		    	}}, default = "Allways" },

		    -- Cooldowns
		{ type = 'rule' },
		{ type = 'header', text = "Cooldowns settings:", align = "center"},

			-- Death and Decay
			{ type = "dropdown",text = "Death and Decay", key = "DnD", list = {
		    	{
		          text = "Allways",
		          key = "Allways"
		        },{
		          text = "AoE only",
		          key = "AoE"
		    	}}, default = "Allways" },

		    -- Defile
			{ type = "dropdown",text = "Defile", key = "Defile", list = {
		    	{
		          text = "Allways",
		          key = "Allways"
		        },{
		          text = "AoE only",
		          key = "AoE"
		    	}}, default = "Allways" },


	}
}

NeP.Interface.buildGUI(config)

local function exeOnLoad()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfDkUnholy') end)
end

local _darkSimSpells = {
	-- Siege of Orgrimmar
	'Froststorm Bolt',
	'Arcane Shock',
	'Rage of the Empress',
	'Chain Lightning',
	-- PvP
	'Hex',
	'Mind Control',
	'Cyclone',
	'Polymorph',
	'Pyroblast',
	'Tranquility',
	'Divine Hymn',
	'Hymn of Hope',
	'Ring of Frost',
	'Entangling Roots'
}

local _DarkSimUnit = function(unit)
	for index,spellName in pairs(_darkSimSpells) do
		if NeP.DSL.Conditions['casting'](unit, spellName) then
			return true 
		end
	end
	return false
end

local function exeOnLoad()
	DarkNCR.Splash()
end

local _All = {
	-- Keybinds 
	{ "42650", "modifier.control" }, -- Army of the Dead
	{ "51052", "modifier.alt" }, -- AMZ
	{ "152280", "modifier.shift", "target.ground" }, -- Defile
	{ "43265", "modifier.shift", "target.ground" }, -- Death and Decay

	-- Buffs
	{ "48263", { -- Blood
		"player.seal != 1", 
		(function() return NeP.Interface.fetchKey("NePConfDkUnholy", "Presence") == 'Blood' end),
	}, nil }, 
	{ "48266", { -- Frost
		"player.seal != 2", 
		(function() return NeP.Interface.fetchKey("NePConfDkUnholy", "Presence") == 'Frost' end),
	}, nil },
	{ "48265", { -- Unholy
		"player.seal != 3", 
		(function() return NeP.Interface.fetchKey("NePConfDkUnholy", "Presence") == 'Unholy' end),
	}, nil },
	{ "57330", "!player.buffs.attackpower" }, -- Horn of Winter

	-- Pet
	{ "46584", "!pet.exists" }, -- Raise Dead
	{ "63560" }, -- Dark Transformation
}

local _Survival = {
	-- Def cooldowns & Heals // Add a toggle/tick
	{ "#5512", "player.health < 85" },--Healthstone
	{ "48792", (function() return DarkNCR.dynEval("player.health <= " .. NeP.Interface.fetchKey('NePConfDkUnholy', 'IceboundFortitude')) end) }, -- Icebound Fortitude
	{ "48743", (function() return DarkNCR.dynEval("player.health <= " .. NeP.Interface.fetchKey('NePConfDkUnholy', 'DeathPact')) end) }, -- Death Pact
	{ "108196", (function() return DarkNCR.dynEval("player.health <= " .. NeP.Interface.fetchKey('NePConfDkUnholy', 'DeathSiphon')) end) },-- Death Siphon
	{ "49039", { -- Lichborne //fear 
		"player.state.fear", 
		"player.runicpower >= 40", 
		"player.spell.exists(49039)" 
	}},
	{ "49039", { -- Lichborne //sleep 
		"player.state.sleep", 
		"player.runicpower >= 40", 
		"player.spell.exists(49039)" 
	}}, 
	{ "49039", { -- Lichborne //charm 
		"player.state.charm", 
		"player.runicpower >= 40", 
		"player.spell.exists(49039)" 
	}},
	{ "49998", { -- Death Strike With Dark Succor
		"player.buff(10156)", 
		(function() return DarkNCR.dynEval("player.health <= " .. NeP.Interface.fetchKey('NePConfDkUnholy', 'DeathStrikeDS')) end)
	}}, 
}

local _Cooldowns = {
	{ "47568", { -- Empower Rune Weapon
		"player.runicpower <= 70", 
		"player.runes(blood).count = 0", 
		"player.runes(unholy).count = 0", 
		"player.runes(frost).count = 0", 
		"player.runes(death).count = 0",
		(function() return NeP.Interface.fetchKey("NePConfDkUnholy", "ERP") == 'Allways' end)
	}},
	{ "96268" }, -- Death's Advance
	{ "49206", (function() return NeP.Interface.fetchKey("NePConfDkUnholy", "SG") == 'Allways' end) }, -- Summon Gargoyle
	{{ -- Unholy Blight
		{ "115989", { -- Unholy Blight
			"target.debuff(55095)",
			(function() return NeP.Interface.fetchKey("NePConfDkUnholy", "UB") == 'Allways' end) --was "SG"
		}}, 
		{ "115989", { -- Unholy Blight
			"target.debuff(55078)",
			(function() return NeP.Interface.fetchKey("NePConfDkUnholy", "UB") == 'Allways' end)
		}},
		{ "115989", { -- Unholy Blight -- For NP
			"target.debuff(155159)",
			(function() return NeP.Interface.fetchKey("NePConfDkUnholy", "UB") == 'Allways' end)
		}},
	}, "!talent(7, 1)" }, 
	{ "20572", (function() return NeP.Interface.fetchKey("NePConfDkUnholy", "BF") == 'Allways' end) }, -- Blood Fury
	{{-- Boss
	{ "47568", { -- Empower Rune Weapon
		"player.runicpower <= 70", 
		"player.runes(blood).count = 0", 
		"player.runes(unholy).count = 0", 
		"player.runes(frost).count = 0", 
		"player.runes(death).count = 0",
		(function() return NeP.Interface.fetchKey("NePConfDkUnholy", "ERP") == 'Boss' end)
	}}, -- Empower Rune Weapon
	{ "96268" }, -- Death's Advance
	{ "#118882" }, -- Scabbrad of Kyanos
	{ "49206", (function() return NeP.Interface.fetchKey("NePConfDkUnholy", "SG") == 'Boss' end) }, -- Summon Gargoyle
		{{-- Unholy Blight
			{ "115989", { -- Unholy Blight
				"target.debuff(55095)",
				(function() return NeP.Interface.fetchKey("NePConfDkUnholy", "UB") == 'Boss' end)
			}}, 
			{ "115989", { -- Unholy Blight
				"target.debuff(55078)",
				(function() return NeP.Interface.fetchKey("NePConfDkUnholy", "UB") == 'Boss' end)
			}}, 
			{ "115989", { -- Unholy Blight -- For NP
				"target.debuff(155159)",
				(function() return NeP.Interface.fetchKey("NePConfDkUnholy", "UB") == 'Boss' end)
			}},
			}, "!talent(7, 1)" },
		{ "20572", (function() return NeP.Interface.fetchKey("NePConfDkUnholy", "BF") == 'Boss' end) }, -- Blood Fury
	}, "target.boss" },
}

local _Diseases = {
	{ "77575", { --Outbreak
		"target.debuff(55095).duration < 2",
		"!talent(7, 1)",
	}, "target" },
	{ "77575", { --Outbreak 
		"target.debuff(55078).duration < 2",
		"!talent(7, 1)",
	}, "target" },
	{ "77575", { --Outbreak for NP
		"target.debuff(155159).duration < 2",
		"talent(7, 1)",
	}, "target" },
	{ "45462", { -- Plague Strike
		"target.debuff(55095).duration <= 9",
		"!talent(7, 1)", 
	}, "target" },
	{ "45462", { -- Plague Strike
		"target.debuff(55078).duration <= 9",
		"!talent(7, 1)", 
	}, "target" },
	{ "45462", { -- Plague Strike
		"target.debuff(155159).duration <= 9",
		"talent(7, 1)", 
	}, "target" },
}

local _AoE = {
	{ "43265", "target.range < 7", "target.ground" }, -- Death and Decay
	{ "152280", "target.range < 7", "target.ground" }, -- Defile
	{{ -- Only at range
		{ "50842", "player.runes(death).count >= 1" }, -- Blood Boil // death
		{{ -- Not NP
			{ "50842", { -- Blood Boil // blood
				"player.runes(blood).count >= 1",
				"target.debuff(55095).duration < 3", 
				"target.debuff(55078).duration <3",
			}},
			{ "50842", {  -- Blood Boil // death
				"player.runes(death).count >= 1",
				"target.debuff(55095).duration < 3", 
				"target.debuff(55078).duration <3",
			}},
		}, "!talent(7, 1)" },
		{{ -- NP
			{ "50842", "player.runes(blood).count >= 1" }, -- Blood Boil // blood // NP
			{ "50842", "player.runes(death).count >= 1" }, -- Blood Boil // death // NP
		}, {
			"talent(7, 1)",
			"target.debuff(155159).duration < 3",
		}},
	}, "target.range <= 10" },
	{ "85948", { --Testing // Festering Strike
		"player.runes(blood) = 2", 
		"player.runes(frost) = 2" 
	}, "target"  }, 
	{ "85948" }, -- Festering Strike
	{ "47541", "player.runicpower >= 40", "target" }, -- Death Coil
}

local _ST = {
	{ "55090", "player.runes(unholy) = 2", "target"  }, -- Scourge Strike
	{ "43265", { -- Death and Decay
		"target.range < 7",
		(function() return NeP.Interface.fetchKey("NePConfDkUnholy", "DnD") == 'Allways' end)
	}, "target.ground" }, 
	{ "152280", {
		"target.range < 7",
		(function() return NeP.Interface.fetchKey("NePConfDkUnholy", "Defile") == 'Allways' end)
	}, "target.ground" }, -- Defile
	{ "85948", { "player.runes(unholy) = 2", "player.runes(blood) = 2" }, "target"  }, --Festering Strike
	{ "55090" },-- Scourge Strike
	{ "85948" }, -- Festering Strike
	{ "47541" }, -- Death Coil

	-- Blood Tap
	{{
		{ "45529", "player.runes(unholy).count = 0" }, --Blood Tap
		{ "45529", "player.runes(frost).count = 0" }, -- Blood Tap
		{ "45529", "player.runes(blood).count = 0" }, -- Blood Tap
	},{
		"player.buff(Blood Charge).count >= 5",
		"player.runes(death).count = 0",
		"!lastcast(45529)"
	}},
}

local inCombat = {
	{{-- Interrupts 
		{ "47528" }, -- Mind freeze
		{ "47476", "!lastcast(47528)", "target" }, -- Strangulate
		{ "108194", "!lastcast(47528)", "target" }, -- Asphyxiate
		{ "47482" }, -- Leap
	}, "target.interruptAt(40)" },

	-- Spell Steal
	{ "77606", (function() return _DarkSimUnit('target') end), "target" }, -- Dark Simulacrum
	{ "77606", (function() return _DarkSimUnit('focus') end), "focus" },  -- Dark Simulacrum

	-- Plague Leech
	{ "123693", {
		"!talent(7, 1)",
		"target.debuff(55095)",-- Target With Frost Fever
		"target.debuff(55078)",-- Target With Blood Plague
		"player.runes(unholy).count = 0",-- With 0 Unholy Runes
		"player.runes(frost).count = 0",-- With 0 Frost Runes
		"player.runes(death).count = 0",-- With 0 Death Runes
		"!lastcast"
	}},
	{ "123693", {
		"talent(7, 1)",
		"target.debuff(155159)",-- Target With NP
		"player.runes(unholy).count = 0",-- With 0 Unholy Runes
		"player.runes(frost).count = 0",-- With 0 Frost Runes
		"player.runes(death).count = 0",-- With 0 Death Runes
		"!lastcast"
	}},  

	-- Proc
	{ "47541", "player.buff(Sudden Doom)", "target"  }, -- Death Coil w/t Sudden Doom

	-- Soul Reaper
	{ "130736", { "!target.debuff", "target.health < 45" }, "target" }, -- Soul Reaper

	-- Excess RP
	{ "47541", "player.runicpower >= 75", "target"  }, -- Death Coil

}


NeP.Engine.registerRotation(252, '[|cff'..NeP.Interface.addonColor..'NeP|r] Deathknight - Unholy', 
	{ -- In-Combat
		{_All},
		{_Survival},
		{_Cooldowns},
		{inCombat},
		{_Diseases},
		{_AoE, "modifer.multitarget"},
		{_ST, "!modifer.multitarget"}
	},{ -- Out-Combat
		{_All}
	}, exeOnLoad)
