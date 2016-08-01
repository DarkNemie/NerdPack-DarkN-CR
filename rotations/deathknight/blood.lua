local myCR 		= 'DarkNCR'							-- Change this to something Unique
local myClass 	= 'DeathKnight'						-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'Blood'							-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
----------	Do not change unless you know what your doing ----------
local mKey 		=  myCR ..mySpec ..myClass			-- Do not change unless you know what your doing
local Sidnum 	= DarkNCR.classSpecNum[myClass..mySpec]
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
NeP.Interface.buildGUI(config)
local E = DarkNCR.dynEval
local F = function(key) return NeP.Interface.fetchKey(mKey, key) end

local exeOnLoad = function()
	DarkNCR.Splash()
	DarkNCR.ClassSetting(mKey)
	NeP.Interface.CreateToggle('saveDS','Interface\\Icons\\spell_deathknight_butcher2.png','Save a Death Strike','Saving Runic.')
	NeP.Interface.CreateToggle('dpstest', 'Interface\\Icons\\inv_misc_pocketwatch_01', 'DPS Test', 'Stop combat after 5 minutes in order to do a controlled DPS test')
	NeP.Interface.CreateToggle('myat', 'Interface\\Icons\\ability_hunter_snipershot', 'Auto Target', 'Automatically target the nearest enemy when target dies or does not exist')
end
----------	END of do not change area ----------
----- try my own range check----
local myRcheck = function ()
	local myRange = 0
	local myunit = 'target'
	if UnitExists(myunit) and UnitIsVisible(myunit) then
		myRange = IsSpellInRange('75',unit)
	end
	if myRange==1 then
		return true
	end
end

----- 
local healthstn = function()  
	return E('player.health <= ' .. F('Healthstone'))
end
---------- This Starts the Area of your Rotaion ----------
local dpsCheck ={
-- DPS Timmer
	{ "/stopcasting\n/stopattack\n/cleartarget\n/stopattack\n/cleartarget\n/petpassive", { "player.time >= 300", "toggle.dpstest" }},
}

local Survival = {
	{'Lifeblood'},
	{'Berserking'},
	{'Blood Fury'},
	{'#5512', healthstn}, 																			-- Health stone
}

local Cooldowns = {
	{'49028'}, 																						-- Dancing RuneWeapon
	{'55233', 'player.health <= 50'}, 																-- Vampiric Blood
	{'#trinket1', (function() return F('trink1') end)},
	{'#trinket2', (function() return F('trink2') end)},   
}

local Interrupts = {
	-- Place skills that interrupt casts below:		Example: {'skillid'},
	{'47528'},																						-- Mind Freeze
	{'221562'},																						-- Asphyxiate
}

local AoE = {

}

local ST = {
	{dpsCheck},
	--- my auto target
--	{ "/targetenemy [noexists]", { "toggle.myat", "!target.exists" } },
--	{ "/targetenemy [dead]", { "toggle.myat", "target.exists", "target.dead" } },
--player.spell(50842).charges >= 1 
	
	{ '50842', '!target.debuff(55078)', 'target'},															-- BloodBoil
	{ '195182', 'player.buff(195181).count <= 6', 'target'},												-- Marrowrend w Bone Shield
	{ '195182', 'player.buff(195181).duration <= 3', 'target'},												-- Marrowrend
	{ '49998', {'player.buff(55233)','!toggle.saveDS'}, 'target'},											-- Death Strike w Vampiric Blood
	{ '50842', 'player.spell(50842).charges >= 1', 'target'},												-- BloodBoil
	{ '43265', 'player.buff(81141)', 'target.ground' },														-- DnD
	{ '49998', {'player.health <= 90','!toggle.saveDS'}, 'target'},											-- Death Strike
    { '206930',{'player.buff(195181).count > 6', 'player.runes > 2'}, 'target'},													-- Heart Strike
    { '49998', {'player.energy >= 75','!toggle.saveDS'}, 'target'},											-- Death Strike
}

local Keybinds = {
	{'pause', 'modifier.alt'},																		-- Pause
	{'43265', 'modifier.lcontrol', 'target.ground' },												-- DnD
	{'108199', 'modifier.lshift'}																	-- GGrasp
}

local outCombat = {
	{Keybinds},
}

NeP.Engine.registerRotation(Sidnum, '[|cff'..DarkNCR.Interface.addonColor ..myCR..'|r]'  ..mySpec.. ' '..myClass, 
	{-- In-Combat
		--{dpsCheck},
		{Keybinds},
		{Survival, 'player.health < 100'},
		{Interrupts, 'target.interruptAt(15)'},
		{Cooldowns, 'modifier.cooldowns'},
		--{AoE, {'player.area(8).enemies >= 3','toggle.AoE'}},
		{ST}
	}, outCombat, exeOnLoad)