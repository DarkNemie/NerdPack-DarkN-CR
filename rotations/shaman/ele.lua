local myCR 		= 'DarkNCR'									-- Change this to something Unique
local myClass 	= 'Shaman'									-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'Elemental'									-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
----------	Do not change unless you know what your doing ----------
local mKey 		=  myCR ..mySpec ..myClass					-- Do not change unless you know what your doing
local Sidnum 	= DNCRlib.classSpecNum(myClass ..mySpec)	-- Do not change unless you know what your doing
local config 	= {
	key 	 = mKey,
	profiles = true,
	title 	 = '|T'..DarkNCR.Interface.Logo..':10:10|t' ..myCR.. ' ',
	subtitle = ' ' ..mySpec.. ' '..myClass.. ' Settings',
	color 	 = NeP.Core.classColor('player'),	
	width 	 = 250,
	height 	 = 500,
	config 	 = DNCRClassMenu.Config(Sidnum)
}
NeP.Interface.buildGUI(config)
local E = DarkNCR.dynEval
local F = function(key) return NeP.Interface.fetchKey(mKey, key, 100) end

local exeOnLoad = function()
	DarkNCR.Splash()
	DarkNCR.ClassSetting(mKey)
end

local healthstn = function() 
	return E('player.health <= ' .. F('Healthstone')) 
end
--------------- END of do not change area ----------------
--
--	Notes:
--
---------- This Starts the Area of your Rotaion ----------
local Survival = {
	-- Put skills or items here that are used to keep you alive!  Example: {'skillid'}, or {'#itemid'},


	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
	{'#5512', healthstn}, 														-- Health stone
	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
}

local Cooldowns = {
	--Put items you want used on CD below:     Example: {'skillid'},  
	
	{'Lifeblood'},
	{'Berserking'},
	{'Blood Fury'},
	{'#trinket1', (function() return F('trink1') end)},
	{'#trinket2', (function() return F('trink2') end)},
}

local Interrupts = {
	
	-- Place skills that interrupt casts below:		Example: {'skillid'},
	
}

local Buffs = {

	--Put buffs that are applied out of combat below:     Example: {'skillid'}, 

}

local Pet = {

	--Put skills in here that apply to your pet needs, while out of combat! 

}

local Pet_inCombat = {

	-- Place your pets combat rotation here if it has one! 	Example: {'skillID'},

}

local AoE = {
	-- AoE Rotation goes here.
	
}

local ST = {
	-- Single target Rotation goes here
	
}

local Keybinds = {

	{'pause', 'modifier.alt'},													-- Pause
	
}

local outCombat = {
	{Keybinds},
	{Buffs},
	{Pet}
}

NeP.Engine.registerRotation(Sidnum, '[|cff'..DarkNCR.Interface.addonColor ..myCR..'|r]'  ..mySpec.. ' '..myClass, 
	{-- In-Combat
		{Keybinds},
		{Interrupts, 'target.interruptAt(15)'},
		{Survival, 'player.health < 100'},
		{Cooldowns, 'modifier.cooldowns'},
		{Pet_inCombat},
		{AoE, {'player.area(8).enemies >= 3','toggle.AoE'}},
		{ST}
	}, outCombat, exeOnLoad)local dynEval = DarkNCR.dynEval
local PeFetch = NeP.Interface.fetchKey

local config = {
	key = 'NePConfShamanEle',
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Shaman Elemental Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		{type = 'text', text = 'Keybinds:', align = 'center'},		
			{type = 'text', text = 'Control: Earthquake mouseover location', align = 'left'},
			{type = 'text', text = 'Shift: Cleanse on mouseover target', align = 'left'},
			{type = 'text', text = 'Alt: Pause Rotation',align = 'left'},
		{type = 'spacer'},{type = 'rule'},
		{type = 'text', text = 'Self Healing:', align = 'center'},
			{type = 'checkspin', text = 'Healthstone', key = 'healthstone', default_spin = 30, default_check = true},
			{type = 'checkspin', text = 'Healing Stream Totem', key = 'healingstreamtotem', default_spin = 40, default_check = false},
			{type = 'checkspin', text = 'Healing Surge', key = 'healingsurge', default_spin = 30, default_check = true},
			{type = 'checkspin', text = 'Healing Surge Out of Combat', key = 'healingsurgeOCC', default_spin = 90, default_check = true},
		{type = 'spacer'},{type = 'rule'},
		{type = 'text', text = 'Self Survivability:', align = 'center'},
			{type = 'checkbox', default = true, text = 'Tremor Totem', key = 'tremortotem'},
			{type = 'checkbox', default = true, text = 'Windwalk Totem', key = 'windwalktotem'},
			{type = 'checkbox', default = false, text = 'Shamanistic Rage', key = 'shamrage', desc = 'Cast Shamanistic Rage when stunned.'},
			{type = 'checkbox', default = false, text = 'Ancestral Guidance', key = 'guidance', desc = 'Cast Ancestral Guidance when Ascendance and Spirit Walker\'s Grace are active.'},
		{type = 'spacer'},{type = 'rule'},
		{type = 'text', text = 'Proximity Spells:', align = 'center'},
			{type = 'checkbox', default = false, text = 'Earthbind / Earthgrab', key = 'earthbind'},	
			{type = 'checkbox', default = false, text = 'Thunderstorm', key = 'thunderstorm'},
			{type = 'checkbox', default = false, text = 'Frostshock', key = 'frostshock', desc = 'Requiers talent (Frozen Power).'},
	}
}

NeP.Interface.buildGUI(config)

local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfShamanEle') end)
	NeP.Interface.CreateToggle(
		'cleavemode', 
		'Interface\\Icons\\spell_nature_chainlightning', 'Enable Cleaves', 
		'Enables casting of earthquake and chain lightning for cleaves.')
	NeP.Interface.CreateToggle(
		'totems', 
		'Interface\\Icons\\spell_fire_flameshock', 
		'Enable Automated use of totems', 
		'Enable Automated use of totems.')
end

local _ALL = {
	-- Buffs
	{'Lightning Shield', '!player.buff(Lightning Shield)'},

	-- Keybinds
	{'pause', 'modifier.lalt'},
}

local _Cooldowns = {
	{'Ancestral Swiftness'},  
	{'Fire Elemental Totem'}, 
	{'Storm Elemental Totem'},  
	{'Elemental Mastery'},  
	{'#trinket1', 'player.buff(Ascendance)'}, 
	{'#trinket2', 'player.buff(Ascendance)'}, 
	{'Ascendance', '!player.buff(Ascendance)'}
}

local _Survival = {
	{'Healing Surge', { 
		(function() return dynEval('player.health <= '..PeFetch('NePConfShamanEle', 'healingsurge_spin')) end), 
		(function() return PeFetch('NePConfShamanEle', 'healingsurge_check') end) 
	}},
	{'Healing Stream Totem', { 
		'!player.totem(Healing Stream Totem)', 
		(function() return dynEval('player.health <= '..PeFetch('NePConfShamanEle', 'healingstreamtotem_spin')) end), 
		(function() return PeFetch('NePConfShamanEle', 'healingstreamtotem_check') end) 
	}},
	{'#5512', {-- Healthstone (5512)
		(function() return dynEval('player.health <= '..PeFetch('NePConfShamanEle', 'healthstone_spin')) end), 
		(function() return PeFetch('NePConfShamanEle', 'healthstone_check') end)
	}}, 
}

local _totems = {
	{'Ancestral Guidance', { 
		'player.buff(Ascendance)', 
		'player.buff(Spiritwalker\'s Grace)', 
		(function() return PeFetch('NePConfShamanEle', 'guidance') end) 
	}},
	{{ -- Windwalk Totem
		{'Windwalk Totem', 'player.state.root'}, 
		{'Windwalk Totem', 'player.state.snare'}, 
	},{
		'!player.buff(Windwalk Totem)', 
		'!player.totem(Windwalk Totem)', 
		(function() return PeFetch('NePConfShamanEle', 'windwalktotem') end)
	}},
	{'Shamanistic Rage', { 
		'player.state.stun', 
		(function() return PeFetch('NePConfShamanEle', 'shamrage') end) 
	}},
	{'Tremor Totem', { 
		'!player.buff', 
		'player.state.fear', 
		'!player.totem(Tremor Totem)', 
		(function() return PeFetch('NePConfShamanEle', 'tremortotem') end) 
	}},
	{{	-- Proximity Survival
		{'Earthbind Totem', { 
			'!player.totem(Earthbind Totem)', 
			'!talent(2, 2)', 
			(function() return PeFetch('NePConfShamanEle', 'earthbind') end) 
		}},
  		{'Earthgrab Totem', { 
  			'!player.totem(Earthbind Totem)', 
  			'talent(2, 2)', 
  			(function() return PeFetch('NePConfShamanEle', 'earthbind') end) 
  		}},
		{'Frostshock', { 
			'talent(2, 1)', 
			'target.debuff(Flame Shock)', 
			(function() return PeFetch('NePConfShamanEle', 'frostshock') end) 
		}},  
		{'Thunderstorm', (function() return PeFetch('NePConfShamanEle', 'thunderstorm') end)}
	}, 'player.area(8).enemies >= 2'},
}

local _Moving = {
	{'Spiritwalker\'s Grace', 'player.buff(Ascendance)'},
	{'Spiritwalker\'s Grace', 'glyph(Glyph of Spiritwalker\'s Focus)'},
	{'Unleash Flame'},
	{'Lava Burst', 'player.buff(Lava Surge)'},
	{'Flame Shock', { 
		'player.buff(Unleash Flame)', 
		'target.debuff(Flame Shock).duration < 19' 
	}},
	{'Flame Shock', 'target.debuff(Flame Shock).duration < 9'},
	{'Earth Shock'},
	{'Searing Totem', { 
		'!player.totem(Fire Elemental Totem)', 
		'!player.totem(Searing Totem)', 
		'target.ttd >= 10'
	}},
	{{ -- Ancestral Swiftness
		{'Chain Lightning', 'player.area(8).enemies >= 4'},
		{'Lava Burst'},
		{'Elemental Blast'},
	}, 'player.buff(Ancestral Swiftness)'},
}

local _AoE = {
	{'Lava Beam', 'player.buff(Ascendance)'},
	{'Chain Lightning', '!player.buff(Enhanced Chain Lightning)'},
	{'Earthquake', 'player.buff(Enhanced Chain Lightning)', 'target.ground'},
	{'Earth Shock', { 
		'player.buff(Lightning Shield)', 
		'player.buff(Lightning Shield).count >= 18' 
	}},
	{'Chain Lightning'},
}

local _Cleave = {
	{'Chain Lightning'},
	{'Chain Lightning', { 
		'!player.buff(Enhanced Chain Lightning)', 
		'player.spell(Earthquake).cooldown < 1' 
	}},
	{'Earthquake', 'player.buff(Enhanced Chain Lightning)', 'target.ground'},
}

local ST = {
	{'Flame Shock', '!target.debuff(Flame Shock)'},
	{'Unleash Flame', 'talent(6, 1)'},
	{'Lava Burst'},
	{'Elemental Blast'},  
	{'Earth Shock', { 
		'player.buff(Lightning Shield)', 
		'player.buff(Lightning Shield).count >= 15', 
		'target.debuff(Flame Shock).duration >= 9' 
	}},
	{'Flame Shock', 'target.debuff(Flame Shock).duration < 9'},
	{'Searing Totem', { 
		'!player.totem(Fire Elemental Totem)', 
		'!player.totem(Searing Totem)', 
		'target.ttd >= 10'
	}},
	{'Lightning Bolt'},
}

local outCombat = {
	{_ALL},

	{'Healing Surge', { 
		(function() return dynEval('player.health <= '..PeFetch('NePConfShamanEle', 'healingsurgeOCC_spin')) end), 
		(function() return PeFetch('NePConfShamanEle', 'healingsurgeOCC_check') end) 
	}},
}

NeP.Engine.registerRotation(262, '[|cff'..NeP.Interface.addonColor..'NeP|r] Shamman - Elemental', 
	{ -- In-Combat
		{_Moving, {'player.moving', '!player.buff(Spiritwalker\'s Grace)'}},
		{{ -- Conditions
			{_ALL},
			{'Wind Shear', 'target.interruptAt(40)'},
			{_Cooldowns, 'modifier.cooldowns'},
			{_Survival, 'player.health < 100'},
			{_totems, 'toggle.totems'},
			{'Earth Shock', '@DarkNCR.aDot(2)'},
			{_AoE, 'player.area(8).enemies >= 5'},
			{_Cleave, 'toggle.cleavemode'},
			{ST},
		}, {'!player.moving', --[[INSERT BUFF CHECK FOR WOLF]] } },
	}, outCombat, exeOnLoad)