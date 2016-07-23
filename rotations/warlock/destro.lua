local config = {
	key = 'NePConfWarlockDestro',
	profiles = true,
	title = '|T'..NeP.Interface.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Warlock Destruction Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		{type = 'text', text = 'Keybinds', align = 'center'},		
			--stuff
		{type = 'spacer'},{type = 'rule'},
		{type = 'text', text = 'DPS', align = 'center'},
			--stuff
		{type = 'spacer'},{type = 'rule'},
		{type = 'text', text = 'Survival', align = 'center'},
			--stuff
	}
}

NeP.Interface.buildGUI(config)

local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface.CreateSetting('Class Settings', function() NeP.Interface.ShowGUI('NePConfWarlockDestro') end)
end

local Shared = {
	-- Buff
	{'Dark Intent', '!player.buff(Dark Intent)'},
}

local Cooldowns = {
	--[[Dark Soul: Instability is your main DPS cooldown. 
	It increases your critical strike chance by 30% for. 
	The general approach is very simply: use Dark Soul on cooldown and try to max out your Burning Embers before using it, 
	so that you can cast Chaos Bolt Icon Chaos Bolt as many times while your critical strike chance is increased. 
	For advanced usage of Dark Soul, please refer to our advanced Dark Soul usage.]]
	{'Dark Soul: Instability', '!player.buff(Dark Soul: Instability)'},

	--[[Summon Doomguard Icon Summon Doomguard and Summon Infernal Icon Summon Infernal share a cooldown. 
	As such, you will have to decide which of the two you will use. 
	These two abilities are on a 10-minute cooldown, so you will realistically only use them once per fight. 
	Summon Doomguard Icon Summon Doomguard is better when fighting 7 enemies or less, 
	while Summon Infernal Icon Summon Infernal is better when fighting 8 enemies or more.]]

	--[[If you choose Grimoire of Supremacy, as a Tier 5 talent, 
	then Summon Doomguard becomes Summon Terrorguard and Summon Infernal becomes Summon Abyssal.]]

}

local Moving = {
	
}

local AoE = {
	{{-- When fighting 6 or more enemies: 
		-- Use also use Fire and Brimstone to cast Conflagrate and Incinerate.
			-- FIXME: TO BE ADDED 
		-- Use Havoc with Chaos Bolt or Shadowburn has priority over using Fire and Brimstone.
			-- FIXME: TO BE ADDED
	}, 'player.area(40).enemies >= 6' },
	
	{{-- Starting from 5 enemies, you should: 
		-- apply Immolate with Fire and Brimstone. 
			-- FIXME: TO BE ADDED
		-- Use Rain of Fire, if the enemies will live for the full duration of the spell.
		{'Rain of Fire', '!player.buff(Rain of Fire)', 'target.ground'},
	}, 'player.area(40).enemies >= 5' },

	{{-- If Mannoroth's Fury Icon Mannoroth's Fury is your Tier 6 talent:
		{{-- when there are 3 or more targets.
			-- start using Mannoroth's Fury Icon Mannoroth's Fury 
			-- Rain of Fire Icon Rain of Fire.
		}, 'player.area(40).enemies >= 3' },
	}, 'talent(6, 3)' },

	{{-- When fighting 2 or 4 enemies, keep doing your single-target rotation on one enemy with the following tweaks:
		-- make Cataclysm (if talented) your top priority.
		{'Cataclysm', nil, 'target.ground'},
		-- use Havoc on Chaos Bolt (if no target is below 20% health) or Shadowburn (if there is a target below 20% health);
			-- FIXME: TO BE ADDED
		-- apply and refresh Immolate on as many enemies as possible;
		{'Immolate', '@DarkNCR.aDot(2)' },
	}, 'player.area(40).enemies >= 2' },
}

local inCombat = {
	-- Cast Shadowburn, when your target has less than 20% health and the conditions below for Chaos Bolt are met.
	{'Shadowburn', 'target.health <= 20', 'target'},
	-- Apply Immolate and refresh it, if it is about to drop and if Cataclysm will not come off cooldown before this happens (provided you took this Tier 7 talent).
	{'Immolate', '!target.debuff(Immolate).duration > 3', 'target'},
	-- Cast Conflagrate if you have two charges.
	{'Conflagrate', 'player.spell(Conflagrate).charges >= 2', 'target'},
	-- Cast Cataclysm if you chose it as your Tier 7 talent.
	{'Cataclysm', nil, 'target.ground'},
	-- Cast Chaos Bolt if
		-- you have more than 3.5 Burning Embers (2.5 with Charred Remains talented) or
		{'Chaos Bolt', 'player.embers >= 3.5', 'target'},
		-- you have a proc that is not +Haste or
		{'Chaos Bolt', 'player.buff(Backdraft)', 'target'},
		-- Dark Soul: Instability is up or
		{'Chaos Bolt', 'player.buff(Dark Soul: Instability)', 'target'},
		-- the target will die shortly.
		{'Chaos Bolt', 'target.ttd < 5', 'target'},
	-- Refresh Immolate, if it has less than 4.5 seconds remaining and if Cataclysm will not come off cooldown before Immolate expires (provided you took this Tier 7 talent).
	{'Immolate', 'target.debuff(Immolate).duration <= 4.5', 'target'},
	-- Cast Conflagrate if you have one charge.
	{'Conflagrate', 'player.spell(Conflagrate).charges == 1', 'target'},
	-- Cast Incinerate as a filler.
	{'Incinerate'}
}

local Demons = {
	--[[By default, you can summon one of four demons to help you fight your foes. 
	Except for the Voidwalker, they are all viable for raiding.
		
	The Felhunter will automatically cast the following abilities: Devour Magic and Shadow Bite. 
	It can also cast Spell Lock if you instruct it to.
	The Imp will automatically cast the following abilities: Firebolt and Singe Magic. 
	It can also cast Flee or Cauterize Master if you instruct it to.
	The Succubus will automatically cast the following abilities: 
		Lash of Pain Icon Lash of Pain, 
		Seduction Icon Seduction, 
		and Lesser Lesser Invisibility. 
	It can also cast Whiplash if you instruct it to.
	The Voidwalker will be your demon of choice while leveling up. It will automatically cast the following abilities: Shadow Bulwark Icon Shadow Bulwark,  Suffering Icon Suffering, and Torment Icon Torment.
	You also have two demons that you can use as DPS cooldowns: a Doomguard (Summon Doomguard Icon Summon Doomguard) for single-target damage or an Infernal (Summon Infernal Icon Summon Infernal) for AoE damage.

	Finally, you have the Command Demon ability, which, if put on your action bar, will change with the demon you are using:
		Imp: Cauterize Master;
		Voidwalker: Suffering;
		Succubus: Whiplash;
		Felhunter: Spell Lock.]]
}

local outCombat = {
	{Shared},
}

NeP.Engine.registerRotation(267, '[|cff'..NeP.Interface.addonColor..'NeP|r] Warlock - Destruction',
	{ -- In-Combat
		{Shared},
		{Moving, "player.moving"},
		{{ -- Conditions
			{Cooldowns, "modifier.cooldowns"},
			{AoE},
			{inCombat}
		}, "!player.moving" },
	}, outCombat, exeOnLoad)