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
--	NeP.Interface.CreateToggle('dpstest', 'Interface\\Icons\\inv_misc_pocketwatch_01', 'DPS Test', 'Stop combat after 5 minutes in order to do a controlled DPS test')
end

local healthstn = function() 
	return E('player.health <= ' .. F('Healthstone')) 
end
--------------- END of do not change area ----------------
--[[--------------- Testing Zone -----------------------------
	
DarkNCR.GcD = function()
local  start, duration = GetSpellCooldown(61304)
	if start ~= nil and debugprofilestop() - (start*1000 ) < (duration*1000) then
		local GcDRemain = (debugprofilestop() - (start*1000 ))
		print('Remaing GCD: '..string.format("%.3f",(GcDRemain/1000))..'s' )
		return string.format("%.3f",(GcDRemain/1000))
	end
end
--------------- End Testing Zone--------------------------
DarkNCR.strinket1 = function()
	start, duration, enabled = GetItemCooldown(137486)  -- Bubble trinket
	cdtime = (start + duration - GetTime())  
	if not start then return false end
	if cdtime <= 93 then return true end	

end

local stupidtrink1 = DarkNCR.strinket1
]]
---------- This Starts the Area of your Rotaion ----------
local Survival = {
	-- Put skills or items here that are used to keep you alive!  Example: {'skillid'}, or {'#itemid'},
	--{ 'Darkness', },
	--{ 'Darkness', 'modifier.cooldowns' },
	--{'#127834', 'player.health < 40'}, 											-- Healing Tonic
	{'#5512', healthstn}, 														-- Health stone
	--{'#109223', 'player.health < 40'}, 											-- Healing Tonic 201633
}

local Cooldowns = {
	--Put items you want used on CD below:     Example: {'skillid'},
	{'Fury of the Illidari', {'target.range <= 6','player.buff(208628)'}, 'target'}, 
	{'Fury of the Illidari', {'target.range <= 6','!talent(5,1)'}, 'target'},  
  	{ 'Chaos Blades', 'talent(7,1)' },--110 Talent(7,1)
  	{ 'Nemesis', 'talent(5,3)','target' },--106 Talent(5,3)
	{'Lifeblood'},
	{'Berserking'},
	{'Blood Fury'},
	{'#trinket1', {(function() return F('trink1') end), stupidtrink1 }},
--	{'#trinket2', {(function() return F('trink2') end), '!player.buff(215956)'  }},
--	{'#trinket2'},
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

]]--208628
local meta = {
--	{ "/stopcasting\n/stopattack\n/cleartarget\n/stopattack\n/cleartarget\n/petpassive", { "player.time >= 300", "toggle.dpstest" }},
	{ 'Eye Beam',{ 
		  'target.range <= 8', 
		  'player.area(15).enemies >= 2','player.buff(208628)'}, 'target' },
	{ 'Eye Beam',{ 
		  'target.range <= 8', 
		  'player.area(15).enemies >= 2','!talent(5,1)'}, 'target' },
  	{ 'Death Sweep', {  'target.range <= 10', 
		  'player.area(15).enemies >= 2','toggle.AoE',
		}, 'target' },
	{'Throw Glaive', 'target.range <= 30', 'target' },	
	{ 'Annihilation', 'player.fury >= 15', 'target' },							--Metamorphosis Buff
  	{ '162243', 'player.fury <= 99', 'target' },
}

local ST = {
--	{ "/stopcasting\n/stopattack\n/cleartarget\n/stopattack\n/cleartarget\n/petpassive", { "player.time >= 300", "toggle.dpstest" }},
	{ 'Felblade', 'talent(3,1)' },										--102 Talent(3,1)
	{ 'Eye Beam',{ 
		  'target.range <= 8', 
		  'player.area(15).enemies >= 2','player.buff(208628)'}, 'target' },
	{ 'Eye Beam',{ 
		  'target.range <= 8', 
		  'player.area(15).enemies >= 2','!talent(5,1)'}, 'target' },	  
	{ 'Vengeful Retreat', {
		'!last.spell(188499)','!last.spell(210152)', 
		'player.fury <= 45', 'player.area(6).enemies >= 2',
		'toggle.AoE','!toggle.Raidme'},'target' }, 
	{ 'Fel Rush', {
		'target.range >= 10', 'target.range <= 25',
		'toggle.AoE','!toggle.Raidme'  
		} , 'target'},																		--1st time Fel rush after vengeful Retreat				
	{ 'Blade Dance', {
		 'target.range <= 10', 
		  'player.area(8).enemies >= 2','toggle.AoE'
		}, 'target' },
	{ 'Throw Glaive', 'target.range <= 30', 'target' },			    	-- glave toss out of melee range																				
	{ 'Chaos Strike', 'player.fury >= 15', 'target' },					--Chaos Strike
	{ '162243', 'player.fury <= 99', 'target' },						--Demon bite 
 	{ 'Fel Eruption', 'talent(5,2)' },									--106 Talent(5,2)
  	{ 'Fel Barrage', 'talent(7,2)' },									--110 Talent(7,2)
  	--{ 'Throw Glaive' },												--cd filler
}

local Keybinds = {
--	{ "/stopcasting\n/stopattack\n/cleartarget\n/stopattack\n/cleartarget\n/petpassive", { "player.time >= 300", "toggle.dpstest" }},
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
		{Keybinds},
		{Interrupts, 'target.interruptAt(25)'},
		{Survival, 'player.health < 100'},
		{Cooldowns, 'modifier.cooldowns'},
		{meta,'player.buff(Metamorphosis)'},
		{ST, 'player.infront'},
	}, outCombat, exeOnLoad)