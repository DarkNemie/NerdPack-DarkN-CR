local myCR 		= 'DarkNCR'									-- Change this to something Unique
local myClass 	= 'Shaman'									-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'Enhancement'									-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
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
	key = 'NePConfShamanEnhance',
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Shaman Enhancement Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		{type = 'text', text = 'Keybinds:', align = 'center'},		
			{type = 'text', text = 'Alt: Pause Rotation',align = 'left'},
		{type = 'spacer'},{type = 'rule'},
		{type = 'text', text = 'Self Healing:', align = 'center'},
			{type = 'checkspin', text = 'Healthstone', key = 'healthstone', default_spin = 30, default_check = true},
			{type = 'checkspin', text = 'Healing Stream Totem', key = 'healingstreamtotem', default_spin = 40, default_check = false},
			{type = 'checkspin', text = 'Healing Surge', key = 'healingsurge', default_spin = 30, default_check = true},
			{type = 'checkspin', text = 'Healing Surge Out of Combat', key = 'healingsurgeOCC', default_spin = 90, default_check = true},
			{type = 'checkspin', text = 'Feral Spirit - Glyphed', key = 'fspirit', desc = 'Use only with Glyph of Feral Spirit for Healing.', default_spin = 35, default_check = false},
		{type = 'spacer'},{type = 'rule'},
		{type = 'text', text = 'Self Survivability:', align = 'center'},
			{type = 'checkbox', default = true, text = 'Tremor Totem', key = 'tremortotem'},
			{type = 'checkbox', default = true, text = 'Windwalk Totem', key = 'windwalktotem'},
			{type = 'checkbox', default = false, text = 'Shamanistic Rage', key = 'shamrage', desc = 'Cast Shamanistic Rage when stunned.'},
			{type = 'checkbox', default = false, text = 'Ancestral Guidance', key = 'guidance', desc = 'Cast Ancestral Guidance when Ascendance and Spirit Walker\'s Grace are active.'},
		{type = 'spacer'},{type = 'rule'},
		{type = 'text', text = 'Proximity Spells:', align = 'center'},
			{type = 'checkbox', default = false, text = 'Earthbind / Earthgrab', key = 'earthbind'},	
			}
}

NeP.Interface.buildGUI(config)

local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfShamanEnhance') end)
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
	{'Unleash Elements'},
	{'Feral Spirit'},
	{'#trinket1', 'player.buff(Ascendance)'}, 
	{'#trinket2', 'player.buff(Ascendance)'}, 
	{'Ascendance', '!player.buff(Ascendance)'}
}

local _Survival = {
	{'Healing Surge', { 
		(function() return dynEval('player.health <= '..PeFetch('NePConfShamanEnhance', 'healingsurge_spin')) end), 
		(function() return PeFetch('NePConfShamanEnhance', 'healingsurge_check') end) 
	}},
	{'Feral Spirit', { 
		(function() return dynEval('player.health <= '..PeFetch('NePConfShamanEnhance', 'fspirit_spin')) end), 
		(function() return PeFetch('NePConfShamanEnhance', 'fspirit_check') end) 
	}},
	{'Healing Stream Totem', { 
		'!player.totem(Healing Stream Totem)', 
		(function() return dynEval('player.health <= '..PeFetch('NePConfShamanEnhance', 'healingstreamtotem_spin')) end), 
		(function() return PeFetch('NePConfShamanEnhance', 'healingstreamtotem_check') end)
	}},
	{'#5512', {-- Healthstone (5512)
		(function() return dynEval('player.health <= '..PeFetch('NePConfShamanEnhance', 'healthstone_spin')) end), 
		(function() return PeFetch('NePConfShamanEnhance', 'healthstone_check') end)
	}}, 
}

local _totems = {
	{'Ancestral Guidance', { 
		'player.buff(Ascendance)', 
		'player.buff(Spiritwalker\'s Grace)', 
		(function() return PeFetch('NePConfShamanEnhance', 'guidance') end) 
	}},
	{{ -- Windwalk Totem
		{'Windwalk Totem', 'player.state.root'}, 
		{'Windwalk Totem', 'player.state.snare'}, 
	},{
		'!player.buff(Windwalk Totem)', 
		'!player.totem(Windwalk Totem)', 
		(function() return PeFetch('NePConfShamanEnhance', 'windwalktotem') end)
	}},
	{'Shamanistic Rage', { 
		'player.state.stun', 
		(function() return PeFetch('NePConfShamanEnhance', 'shamrage') end) 
	}},
	{'Tremor Totem', { 
		'!player.buff', 
		'player.state.fear', 
		'!player.totem(Tremor Totem)', 
		(function() return PeFetch('NePConfShamanEnhance', 'tremortotem') end) 
	}},
	{{	-- Proximity Survival
		{'Earthbind Totem', { 
			'!player.totem(Earthbind Totem)', 
			'!talent(2, 2)', 
			(function() return PeFetch('NePConfShamanEnhance', 'earthbind') end) 
		}},
  		{'Earthgrab Totem', { 
  			'!player.totem(Earthbind Totem)', 
  			'talent(2, 2)', 
  			(function() return PeFetch('NePConfShamanEnhance', 'earthbind') end) 
  		}},
	}, 'player.area(8).enemies >= 2'},
}

local _Echo = {
	{'Magma Totem', {
		'!player.totem(Fire Elemental Totem)',
		'!player.totem(Magma Totem)',
		'player.area(8).enemies >= 2' 
	}},
	{'Searing Totem', { 
		'!player.totem(Fire Elemental Totem)', 
		'!player.totem(Searing Totem)', 
		'target.ttd >= 10'
	}},
	{'Stormstrike', {
		'!player.buff(Ascendance)',
		'player.spell(Stormstrike).charges >= 1',
		'target.ttd <= 5',
		'player.spell(Stormstrike).recharge < 1.3'
	}},
	{'Windstrike', {
		'player.buff(Ascendance)',
		'player.spell(Windstrike).charges >= 1',
		'player.spell(Windstrike).recharge < 1.3'
	}},
	{'Lava Lash', {
		'player.spell(Lava Lash).charges >= 1',
		'target.ttd <= 5',
		'player.spell(Lava Lash).recharge < 1.3'
	}},
	{'Lightning Bolt', {
		'player.area(15).enemies >= 2',
		'player.buff(Maelstrom Weapon).count <= 5'
	}},
	{'Chain Lightning', {
		'player.area(12).enemies >= 2',
		'player.buff(Maelstrom Weapon).count <= 5'
	}},
	{'Unleash Elements'},
	{'Fire Nova', 'player.area(12).enemies >= 2'},
	{'Flame Shock', { 
		'target.debuff(Flame Shock).duration < 9',
		'player.buff(Unleash Flame)'
	}},
	{'Frost Shock', 'player.area(15).enemies >= 3'},
}

local _AoE = {
	{'Magma Totem', {
		'!player.totem(Fire Elemental Totem)',
		'!player.totem(Magma Totem)'
	}},
	{'Chain Lightning', {
		'player.buff(Maelstrom Weapon).count <= 5',
	}},
	{'Unleash Elements'},
	{'Fire Nova'},
	{'Flame Shock', { 
		'target.debuff(Flame Shock).duration < 9',
		'player.buff(Unleash Flame)'
	}},
	{'Stormstrike', {
		'talent(4, 3)',
		'!player.buff(Ascendance)',
		'player.spell(Stormstrike).charges >= 1',
		'target.ttd <= 5',
		'player.spell(Stormstrike).recharge < 1.3'
	}},
	{'Windstrike', {
		'talent(4, 3)',
		'player.buff(Ascendance)',
		'player.spell(Windstrike).charges >= 1',
		'player.spell(Windstrike).recharge < 1.3'
	}},
	{'Lava Lash', {
		'talent(4, 3)',
		'player.spell(Lava Lash).charges >= 1',
		'target.ttd <= 5',
		'player.spell(Lava Lash).recharge < 1.3'
	}},
}
	
local ST = {
	{'Magma Totem', {
		'!player.totem(Fire Elemental Totem)',
		'!player.totem(Magma Totem)',
		'player.area(12).enemies >= 3'
	}},
	{'Searing Totem', { 
		'!player.totem(Fire Elemental Totem)', 
		'!player.totem(Searing Totem)', 
		'target.ttd >= 10'
	}},
	{'Chain Lightning', {
		'player.buff(Maelstrom Weapon).count <= 5',
		'player.area(12).enemies >= 3'
	}},
	{'Unleash Elements'},
	{'Fire Nova', 'player.area(12).enemies >= 3'},
	{'Flame Shock', { 
		'target.debuff(Flame Shock).duration < 9',
		'player.buff(Unleash Flame)'
		}},
	{'Lightning Bolt', {
		'player.area(12).enemies >= 3',
		'player.buff(Maelstrom Weapon).count <= 5'
	}},
	{'Stormstrike', '!player.buff(Ascendance)'},
	{'Windstrike', 'player.buff(Ascendance)'},
	{'Lava Lash'},  
	{'Frost Shock', 'player.area(12).enemies >= 3'},
}

local outCombat = {
	{_ALL},

	{'Healing Surge', { 
		(function() return dynEval('player.health <= '..PeFetch('NePConfShamanEnhance', 'healingsurgeOCC_spin')) end), 
		(function() return PeFetch('NePConfShamanEnhance', 'healingsurgeOCC_check') end) 
	}},
}

NeP.Engine.registerRotation(263, '[|cff'..NeP.Interface.addonColor..'NeP|r] Shamman - Enhancement', 
	{ -- In-Combat
		{{ -- Conditions
			{_ALL},
			{'Wind Shear', 'target.interruptAt(40)'},
			{_Cooldowns, 'modifier.cooldowns'},
			{_Survival, 'player.health < 100'},
			{_totems, 'toggle.totems'},
			{_AoE, 'player.area(12).enemies >= 3' },
			{_Echo, 'talent(4, 3)'},
			{ST},
		}, {'!player.moving', --[[INSERT BUFF CHECK FOR WOLF]] } },
	}, outCombat, exeOnLoad)