DNCRClassMenu = {
	Version = '0.0.1',
	Branch 	= 'ALPHA',
	Author 	= 'DarkNemie'
}


DNCRClassMenu.table = {

--[[MageArcane]]			[62] = {},		
--[[MageFire]]				[63] = {
	key 	 = mKey,
	profiles = true,
	title 	 = '|T'..DarkNCR.Interface.Logo..':10:10|t' ..myCR.. ' ',
	subtitle = ' ' ..mySpec.. ' '..myClass.. ' Settings',
	color 	 = NeP.Core.classColor('player'),	
	width 	 = 250,
	height 	 = 500,
	config 	 = {
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
			

		}
},					
--[[MageFrost]]				[64] = {},		
	
--[[PaladinHoly]]			[65] = {},		
--[[PaladinProtection]]		[66] = {},		
--[[PaladinRetribution]]	[70] = {},		

--[[WarriorArms]]			[71] = {},		
--[[WarriorFury]]			[72] = {},		
--[[WarriorProtection]]		[73] = {},		

--[[DruidBalance]]			[102] = {},		
--[[DruidFeral]]			[103] = {},		
--[[DruidGuardian]]			[104] = {},		
--[[DruidRestoration]]		[105] = {},		

--[[DeathKnightBlood]]		[250] = {},		
--[[DeathKnightFrost]]		[251] = {},		
--[[DeathKnightUnholy]]		[252] = {},		

--[[HunterBeastMastery]]	[253] = {},		
--[[HunterMarksmanship]]	[254] = {},		
--[[HunterSurvival]]		[255] = {},

--[[PriestDiscipline]]		[256] = {},		
--[[PriestHoly]]			[257] = {},		
--[[PriestShadow]]			[258] = {},		

--[[RogueAssassination]]	[259] = {},		
--[[RogueCombat]]			[260] = {},		
--[[RogueSubtlety]]			[261] = {},		

--[[ShamanElemental]]		[262] = {},		
--[[ShamanEnhancement]]		[263] = {},		
--[[ShamanRestoration]]		[264] = {},		

--[[WarlockAffliction]]		[265] = {},		
--[[WarlockDemonology]]		[266] = {},		
--[[WarlockDestruction]]	[267] = {},		

--[[MonkBrewmaster]]		[268] = {},		
--[[MonkWindwalker]]		[269] = {},		
--[[MonkMistweaver]]		[270] = {},		
	
--[[DemonHunterHavoc]]		[577] = {},		
--[[DemonHunterVengeance]]	[581] = {},		
	
}




