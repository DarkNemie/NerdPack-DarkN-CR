local myCR 		= 'DNCR'									-- Change this to something Unique
local myClass 	= 'DemonHunter'								-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'Havoc'									-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
----------	Do not change unless you know what your doing ----------
local mKey 		=  myCR ..mySpec ..myClass					-- Do not change unless you know what your doing
local Sidnum 	= DarkNCR.classSpecNum[myClass..mySpec]	-- Do not change unless you know what your doing
local config 	= {
	key 	 = mKey,
	profiles = true,
	title 	 = '|T'..DarkNCR.Interface.Logo..':10:10|t' ..myCR.. ' ',
	subtitle = ' ' ..mySpec.. ' '..myClass.. ' Settings',
	color 	 = NeP.Core.classColor('player'),	
	width 	 = 250,
	height 	 = 500,
	config 	 = DarkNCR.menuConfig[Sidnum]
}

local E = DarkNCR.dynEval
local F = function(key) return NeP.Interface.fetchKey(mKey, key, 100) end

local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface.buildGUI(config)
	DarkNCR.ClassSetting(mKey)

end

local healthstn = function() 
	return E('player.health <= ' .. F('Healthstone')) 
end
--------------- END of do not change area ----------------
--------------- Testing Zone -----------------------------
	
DarkNCR.GcD = function()
local  start, duration = GetSpellCooldown(61304)
	if start ~= nil and debugprofilestop() - (start*1000 ) < (duration*1000) then
		local GcDRemain = (debugprofilestop() - (start*1000 ))
		print('Remaing GCD: '..string.format("%.3f",(GcDRemain/1000))..'s' )
		return string.format("%.3f",(GcDRemain/1000))
	end
end
--------------- End Testing Zone--------------------------

---------- This Starts the Area of your Rotaion ----------
local Survival = {
	-- Put skills or items here that are used to keep you alive!  Example: {'skillid'}, or {'#itemid'},
	--{ 'Darkness', },
	--{ 'Darkness', 'modifier.cooldowns' },
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
	{ 'Consume Magic'},
}

local Buffs = {
	--Put buffs that are applied out of combat below:     Example: {'skillid'}, 

}

local Pet = {
	--Put skills in here that apply to your pet needs while out of combat! 


}

local Pet_inCombat = {
	-- Place your pets combat rotation here if it has one! 	Example: {'skillID'},
	
}
--[[ --------------- Currently not using this.
local AoE = {
	{ 'Eye Beam',{ 
		  'target.range <= 8', 
		  'player.area(8).enemies >= 2'}, 'target' },
	{ 'Chaos Strike', { 
		  'target.range <= 8',
		  'talent(1, 2)',
		  'player.area(8).enemies >= 2',
		  'toggle.AoE' 
		}, 'target' }, 											--Chaos Cleave Talent(1,2)
  	{ 'Blade Dance', {
		  {'player.fury >= 70' , 'target.range <= 8'}, 
		  {'player.area(8).enemies >= 2','toggle.AoE'},
		}, 'target' },
	{ 'Throw Glaive', {'target.range >= 15','target.area(8).enemies >= 2'}, 'target' },
}
]]--
--[[------------ to be added later

	--{ 'Anguish' },--Artifact
  	--{ 'Felblade', 'talent(3,1)' },--102 Talent(3,1)
  	--{ 'Fel Eruption', 'talent(5,2)' },--106 Talent(5,2)
  	--{ 'Nemesis', 'talent(5,3)' },--106 Talent(5,3)
  	--{ 'Chaos Blades', 'talent(7,1)' },--110 Talent(7,1)
  	--{ 'Fel Barrage', 'talent(7,2)' },--110 Talent(7,2)
	--{ 'Fel Rush' },--2nd time
	-- {'Death Sweep'}

]]--

local ST = {
	{ 'Eye Beam',{ 
		  'target.range <= 18', 
		  'player.area(15).enemies >= 2'}, 'target' },
	{ 'Vengeful Retreat', {
		'!last.spell(188499)','!last.spell(210152)', 
		'player.fury <= 45', 'player.area(6).enemies >= 2',
		'toggle.AoE','!toggle.Raidme'},'target' }, 
	{ 'Fel Rush', {
		'target.range >= 10', 'target.range <= 25',
		'toggle.AoE','!toggle.Raidme'  
		} , 'target'},																		--1st time Fel rush after vengeful Retreat
													
	{'Throw Glaive', 'target.area(15).enemies >= 2'},												-- glave toss out of melee range																				
	{ 'Blade Dance', {
		  'player.fury >= 40' , 'target.range <= 10', 
		  'player.area(15).enemies >= 4','toggle.AoE'
		}, 'target' },
	{ 'Death Sweep', {																		-- Death Seep with Metamorphosis
		  'player.buff(Metamorphosis)',
		  'player.fury >= 40' , 'target.range <= 10', 
		  'player.area(15).enemies >= 3','toggle.AoE',
		}, 'target' },
  	{ 'Annihilation', 'player.buff(Metamorphosis)', 'target' },		--Metamorphosis Buff
  	{ 'Chaos Strike', 'player.fury >= 15', 'target' },									--Chaos Strike
	{ '162243', { '!talent(2, 2)', 'player.fury <= 95'}, 'target' },	--Demon bite Not Demon Blades Talent(2,2)
  	{ 'Throw Glaive' },																		--cd filler
}

local Keybinds = {
	{ '!Metamorphosis', 'modifier.lshift' ,'mouseover.ground' },
	{'pause', 'modifier.alt'},													-- Pause
	{ '!Chaos Nova', 'modifier.lcontrol' },
		-- Defence
  	--{ 'Netherwalk', { 'talent(4,1)',  'modifier.rcontrol' } },--104 Talent(4,1)
  	--{ 'Blur', { 'modifier.rcontrol' } },--104
  	
}

local outCombat = {
	{Keybinds},
	{Buffs},
	{Pet}
}

NeP.Engine.registerRotation(Sidnum, '[|cff'..DarkNCR.Interface.addonColor ..myCR..'|r]'  ..mySpec.. ' '..myClass, 
	{-- In-Combat
		--{DarkNCR.GcD},
		{Keybinds},
		{Interrupts, 'target.interruptAt(15)'},
		{Survival, 'player.health < 100'},
		{Cooldowns, 'modifier.cooldowns'},
		{Pet_inCombat},
		--{AoE, 'player.infront' },
		{ST, 'player.infront'},
	}, outCombat, exeOnLoad)