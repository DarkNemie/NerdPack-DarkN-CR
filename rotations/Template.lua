local dynEval = DarkNCR.dynEval
local PeFetch = NeP.Interface.fetchKey

local config = {
	key = 'key_used_for_menu_calls_needs_to_be_unique',
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Class config title',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			
		
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Survival', align = 'center'},
			
			-- Survival Settings:
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
	}
}

NeP.Interface.buildGUI(config)

local lib = function()
	DarkNCR.Splash()
	
	-- The following Line has a section that needs to be changed! MAKE SURE THE SHOWGUI KEY MATCHES WHAT YOU MADE ABOVE!!!!
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('Change_this_to_the_key_you_set_above') end)

	--[[
	This is a template for creating toggle buttons for use in the main bar:
	NeP.Interface.CreateToggle('var_name_can_be_anything_make_it_simple', 'Interface\\Icons\\Icon_name', 'readable name', 'tool-tip')
	]]--
	
end

--[[	This section is custom settings do not mess with them unless you understand what they do. ]]--
local trinkset1 = function()
	return PeFetch('Change_this_to_the_key_you_set_above', 'trink1')
end

local trinkset2 = function()
	return PeFetch('Change_this_to_the_key_you_set_above', 'trink2')
end

local healthstn = function() 
	return dynEval('player.health <= ' .. PeFetch('Change_this_to_the_key_you_set_above', 'Healthstone')) 
end
--[[	Custom section end please go back to happy editing!  ]]--

local Keybinds = {
	
	--[[ Place Key binds  below: 
	Example 1 Skill on use with left Ctrl usage on the ground at mouse location:
	{ 'SkillID' , 'modifier.lcontrol', 'target.ground' }, 
	
	Example 2 Skill usage with left alt 
	{'SkillID' , 'modifer.lalt'}
	]]--
}

local Buffs = {

	--Put buffs that are applied out of combat below:     Example: {'skillid'}, 

}

local Pet = {

	--Put skills in here that apply to your pet needs while out of combat! 
	--[[
	Here is an example from Hunter CR.
	{'/cast Call Pet 1', '!pet.exists'},										-- Summon Pet
  	{{ 																			-- Pet Dead
		{'55709', '!player.debuff(55711)'}, 									-- Heart of the Phoenix
		{'982'} 																-- Revive Pet
	}, {'pet.dead', 'toggle.ressPet'}},	
	]]--

}

local Pet_inCombat = {

	-- Place your pets combat rotation here if it has one! 	Example: {'skillID'},

}

local Cooldowns = {

	--Put items you want used on CD below:     Example: {'skillid'},  
	
	{'Lifeblood'},
	{'Berserking'},
	{'Blood Fury'},
	{'#trinket1', trinkset1},
	{'#trinket2', trinkset2},
}

local Survival = {

	-- Put skills or items here that are used to keep you alive!  Example: {'skillid'}, or {'#itemid'},


	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
	{'#5512', healthstn}, 														-- Health stone
	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
}

local Interrupts = {
	
	-- Place skills that interrupt casts below:		Example: {'skillid'},
	
}
	
local inCombat = {

	--[[
	Welcome to the main event! this is where your combat rotation will call home, below I 
	will show you a few examples of what your rotation should look like using Hunter MM skills. 
	Please keep in mind the rotation will run from top to bottom so put skills that are more
	important on top.
	Examples:
	-----------------------------------------------------------------------------------------------------------
	{'120360', 'toggle.AoE'}, 													-- Barrage // TALENT	
	{'214579', {'player.buff(223138)', 'toggle.AoE'}, 'target'},				-- SideWinder
	{'185358' , {'player.buff(193534).duration < 3','talent (1,2)'}, 'target'},	-- Arcane Shot /W Steady Focus
	{'19434', 'player.buff(194594)', 'target'},  								-- Aimed shot /w lnl
	{'185901', 'target.debuff(185365)'}, 										-- Marked Shot
	{'19434', {'player.focus > 50', 'target.debuff(187131)'}, 'target'},  		-- Aimed shot /w Vulnerable
	-----------------------------------------------------------------------------------------------------------
	This shows a variety of conditions that you can use in your skills to get them to cast like you want.
	]]--
	
}

local outCombat = {
	{Keybinds},
	{Buffs},
	{Pet}
}

NeP.Engine.registerRotation(254, '[|cff'..NeP.Interface.addonColor..'DarkNemie|r] Template_please_change',
	{ 																			-- In-Combat
		{Keybinds},
		{Buffs},
		{Interrupts, 'target.interruptAt(5)'},
		{{ 																		-- General Conditions
			{Survival, 'player.health < 100'},
			{Cooldowns, 'modifier.cooldowns'},
			{inCombat, {'target.infront', 'target.range <= 45'}},				-- target.range can be removed or edited for class type
		}, '!player.channeling'}												-- !player.channeling can be removed as needed
	}, outCombat, lib)