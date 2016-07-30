DNCRClassMenu = {
	Version = '0.0.1',
	Branch 	= 'ALPHA',
	Author 	= 'DarkNemie'
}

--[[    -------- Maybe Revisit this at some point -------
 local _general = {
	[1] = 	{type = 'rule'},
	[2]	=	{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
	[3]	=	{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
	[4]	=	{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
	[5]	=	{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
 }
function DNCRClassMenu.general()
	return  _general
end
]]
 local _Config = {
  
--[[MageArcane]]			[62] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},
		
--[[MageFire]]				[63] = {		
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 50},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = mySpec, align = 'center'},
	},
	
--[[MageFrost]]				[64] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},		
	
--[[PaladinHoly]]			[65] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
		
			-- This is menu settings from before 7.0.3 i am sure they need to be reworked
			{type = 'checkbox', text = 'Run Faster', key = 'RunFaster', default = false},
			{type = 'checkbox', text = 'Crusader Strike', key = 'CrusaderStrike', default = true ,},
			{type = 'dropdown',
				text = 'Buff:', key = 'Buff', 
				list = {
					{text = 'Kings',key = 'Kings'},
					{text = 'Might',key = 'Might'}
			   }, 
				default = 'Kings', 
				desc = 'Select What buff to use The moust...' 
		   },
			{type = 'dropdown', text = 'Seal:', key = 'seal', 
				list = {
					{text = 'Insight',key = 'Insight'},
					{text = 'Command',key = 'Command'}
				}, 
				default = 'Insight', 
				desc = 'Select What Seal to use...' 
		   },
			{type = 'spinner', text = 'Holy Light', key = 'HolyLightOCC', default = 100, desc = 'Holy Light when outside of combat.'},

		-- Survival
		{type = 'rule'},
		{type = 'header', text = 'Survival settings:', align = 'center'},
			{type = 'spinner', text = 'Divine Protection', key = 'DivineProtection', default = 90},
			{type = 'spinner', text = 'Divine Shield', key = 'DivineShield', default = 20},
			{type = 'rule'},
			{type = 'header', text = 'Proc\'s settings:', align = 'center'},
			{type = 'text', text = 'Divine Purpose: ', align = 'center'},
			{type = 'spinner', text = 'Word of Glory', key = 'WordofGloryDP', default = 80},
			{type = 'spinner', text = 'Eternal Flame', key = 'EternalFlameDP', default = 85},
			{type = 'text', text = 'Selfless Healer: ', align = 'center'},
			{type = 'spinner', text = 'Flash of light', key = 'FlashofLightSH', default = 85},
			{type = 'text', text = 'Infusion of Light: ', align = 'center'},
			{type = 'spinner', text = 'Holy Light', key = 'HolyLightIL', default = 100},

		-- Tank/Focus
		{type = 'rule'},
		{type = 'header', text = 'Tank/Focus settings:', align = 'center'},
			{type = 'spinner', text = 'Hand of Sacrifice', key = 'HandofSacrifice', default = 40},
			{type = 'spinner', text = 'Lay on Hands', key = 'LayonHandsTank', default = 15},
			{type = 'spinner', text = 'Flash of Light', key = 'FlashofLightTank', default = 40},
			{type = 'spinner', text = 'Execution Sentence', key = 'ExecutionSentenceTank', default = 80},
			{type = 'spinner', text = 'Eternal Flame', key = 'EternalFlameTank', default = 75, desc = 'With 3 Holy Power.'},
			{type = 'spinner', text = 'Word of Glory', key = 'WordofGloryTank', default = 80, desc = 'With 3 Holy Power.'},
			{type = 'spinner', text = 'Holy Shock', key = 'HolyShockTank', default = 100},
			{type = 'spinner', text = 'Holy Prism', key = 'HolyPrismTank', default = 85},
			{type = 'spinner', text = 'Sacred Shield', key = 'SacredShieldTank', default = 100, desc = 'With 1 charge or more.'},
			{type = 'spinner', text = 'Holy Light', key = 'HolyLightTank', default = 100},

		-- Raid/party
		{type = 'rule'},
		{type = 'header', text = 'Raid/Party settings:', align = 'center'},
			{type = 'spinner', text = 'Lay on Hands', key = 'LayonHands', default = 15},
			{type = 'spinner', text = 'Flash of Light', key = 'FlashofLight', default = 35},
			{type = 'spinner', text = 'Execution Sentence', key = 'ExecutionSentence', default = 10},
			{type = 'spinner', text = 'Eternal Flame', key = 'EternalFlame', default = 93, desc = 'With 1 Holy Power.'},
			{type = 'spinner', text = 'Word of Glory', key = 'WordofGlory', default = 80, desc = 'With 3 Holy Power.'},
			{type = 'spinner', text = 'Holy Shock', key = 'HolyShock', default = 100},
			{type = 'spinner', text = 'Holy Prism', key = 'HolyPrism', default = 85},
			{type = 'spinner', text = 'Sacred Shield', key = 'SacredShield', default = 80, desc = 'With 2 charge or more.'},
			{type = 'spinner',text = 'Holy Light', key = 'HolyLight', default = 100},
},	
--[[PaladinProtection]]		[66] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},		
--[[PaladinRetribution]]	[70] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},		

--[[WarriorArms]]			[71] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
			
},		
--[[WarriorFury]]			[72] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},

			
			{type = 'spinner',text = 'Enraged Regeneration', key = 'ERG', default = 60,},
},		
--[[WarriorProtection]]		[73] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', 	text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},

			{type = 'spinner',text = 'Impending Victory', key = 'IVT', default = 100,},
			{type = "spinner",text = "Last Stand - HP",key = "LastStand",width = 50,min = 0,max = 100,default = 20,step = 5},
			{type = "spinner",text = "Shield Wall - HP",key = "ShieldWall",width = 50,min = 0,max = 100,default = 30,step = 5},
		
},		
--[[DruidBalance]]			[102] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},		
--[[DruidFeral]]			[103] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},		
--[[DruidGuardian]]			[104] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},		
--[[DruidRestoration]]		[105] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},		

--[[DeathKnightBlood]]		[250] = 
	{ 
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
			
			-- Survival Settings:
			{ type = 'checkbox', text = 'Vampiric Blood', key = 'vampB', default = true, desc = 'Enable the usage of VP.'},
	},
--[[DeathKnightFrost]]		[251] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},	
--[[DeathKnightUnholy]]		[252] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},	

--[[HunterBeastMastery]]	[253] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
		{type = 'spinner', text = 'Pet Slot to use: 1 - 5', key = 'ptsltnum', default = 1, min = 1 , max = 5 },
},	
--[[HunterMarksmanship]]	[254] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
		{type = 'spinner', text = 'Pet Slot to use: 1 - 5', key = 'ptsltnum', default = 1, min = 1 , max = 5 },
},		
--[[HunterSurvival]]		[255] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
		{type = 'spinner', text = 'Pet Slot to use: 1 - 5', key = 'ptsltnum', default = 1, min = 1 , max = 5 }, 
},

--[[PriestDiscipline]]		[256] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},		
--[[PriestHoly]]			[257] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},	
--[[PriestShadow]]			[258] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},		

--[[RogueAssassination]]	[259] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},		
--[[RogueCombat]]			[260] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},		
--[[RogueSubtlety]]			[261] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},		

--[[ShamanElemental]]		[262] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},		
--[[ShamanEnhancement]]		[263] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},		
--[[ShamanRestoration]]		[264] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},		

--[[WarlockAffliction]]		[265] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},		
--[[WarlockDemonology]]		[266] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},		
--[[WarlockDestruction]]	[267] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},		

--[[MonkBrewmaster]]		[268] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},		
--[[MonkWindwalker]]		[269] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},		
--[[MonkMistweaver]]		[270] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},		
	
--[[DemonHunterHavoc]]		[577] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},	
--[[DemonHunterVengeance]]	[581] = 
{
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--Trinket usage settings:
			{type = 'checkbox', text = 'Use Trinket 1', key = 'trink1', default = true},
			{type = 'checkbox', text = 'Use Trinket 2', key = 'trink2', default = true},
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
			
		--Spec Specific settings
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Spec Specific Settings', align = 'center'},
},		
	
}



function DNCRClassMenu.Config(_type)
	return  _Config[_type]
end




