local myCR 		= 'DNCR'							-- Change this to something Unique
local myClass 	= 'DeathKnight'						-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'Unholy'							-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
----------	Do not change unless you know what your doing ----------
local mKey 		=  myCR ..mySpec ..myClass			-- Do not change unless you know what your doing
local Sidnum 	= DarkNCR.classSpecNum[myClass..mySpec]
local config 	= DarkNCR.menuConfig[Sidnum]

local exeOnLoad = function()
	DarkNCR.Splash()
end
----------	END of do not change area ----------

---------- This Starts the Area of your Rotaion ----------
local Survival = {
	
	{'55233', 'UI(vampB)'}, -- Vampiric Blood
	{'Lifeblood'},
	{'Berserking'},
	{'Blood Fury'},
	{'#trinket1', 'UI(trink1)'},
	{'#trinket2', 'UI(trink2)'},
}

local Cooldowns = {
    { '207349' , 'player.runicpower >= 70' }, 														--Dark Artbiter with enough RP for Death Coil
    { '49206' }, 																					--Summon Gargoyle
}
 
local Healing = {
    { '49998' , { 'player.buff(101568)' , 'player.health <= 80' }}, 								--Death Strike with Proc
    { '49998', { 'player.buff(101568).duration < 2' , 'player.health <= 95' }}, 					--Death Strike anyway since proc is falling off.
}

local Interrupts = {
		
}

local Buffs = {
	
}

local Pet = {
	{'46584', '!pet.exists'}, 																					-- Raise Dead

}

local Pet_inCombat = {

}

local AoE = {

}

local ST = {
	{Healing},
	-- SINGLE TARGET
    {{
		{ '47541' , { 'player.spell(207349).cooldown >= 3' , 'player.runicpower >= 50' }}, 			--Death Coil if CD we wont have a Dark Arbiter soon.
        { '47541' , { 'player.runicpower >= 50' , '!toggle(cooldowns)' }}, 						--Death Coil
        { '47541' , 'player.spell(207349).cooldown >= 165' },  						  				--Death Coil to increase the DPS from Dark Arbiter.
	}, 'talent(7, 1)' },				
    { '47541' , 'player.runicpower >= 50' }, 														--Death Coil
    { '47541' , 'player.buff(49530)'}, 																--Free Death Coil With Sudden Doom
    { '63560', 'pet.exists' },																		--Dark Transformation
    { '130736' , 'target.debuff(194310).count >= 3' }, 												--Soul Reaper with Festering Wound (need a better check)
    { '207311' , 'target.debuff(194310).count >= 3' },										 		--Clawing Shadows
    { '77575', 'target.debuff(191587).duration <= 3' }, 											--Outbreak
    { '85948' , '!target.debuff(194310)' }, 														--Festering Strike to gain Festering Wound
    { '47541' , { 'player.spell(207349).cooldown >= 1' , 'talent(7, 1)'}}, 							--Death Coil filler 
    { '47541' , '!toggle(cooldowns)' }, 															--Death Coil filler if we dont plan to use Dark Arbiter
}

local Keybinds = {
	-- Pause
	{'pause', 'keybind(alt)'},
	{'43265', 'keybind(lcontrol)', 'mouseover.ground' },														-- DnD
	{'42650', 'keybind(lshift)'},
}

local outCombat = {
	{Keybinds},
}

NeP.CR:Add(Sidnum, '[|cff'..DarkNCR.Interface.addonColor ..myCR..'|r]'  ..mySpec.. ' '..myClass, 
	{-- In-Combat
		{Keybinds},
		{Survival, 'player.health < 100'},
		{Cooldowns, 'toggle(cooldowns)'},
		{Pet},
		{Pet_inCombat},
		{AoE, 'player.area(8).enemies >= 3'},
		{ST}
	}, outCombat, exeOnLoad)