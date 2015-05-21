-- Info.lua

-- Implements the g_PluginInfo standard plugin description

g_PluginInfo =
{
	Name = "Essentials",
	Version = "0.1",
	Description = [[Adds some useful commands to MCServer.]],

	Commands =
	{
		["/antioch"] =
		{
			Permission = "es.antioch",
			HelpString = "Spawn a TNT in the location you're looking at.",
			Handler = HandleAntiOchCommand,
			Alias = { "/grenade", "/tnt", }
		},
		["/biome"] =
		{
			Permission =  "es.biome",
			HelpString =  "Tells you the biome in which you are.",
			Handler =  HandleBiomeCommand,
		},
		["/broadcast"] =
		{
			Permission =  "es.broadcast",
			HelpString =  "Broadcast a message to all players.",
			Handler =  HandleBroadcastCommand,
			Alias = { "/say", "/bcast", "/bc", }
		},
		["/burn"] =
		{
			Permission =  "es.burn",
			HelpString =  "Set a player on fire.",
			Handler =  HandleBurnCommand,
		},
		["/delhome"] =
		{
			Permission =  "es.delhome",
			HelpString =  "Delete a home.",
			Handler =  HandleDelHomeCommand,
			Alias = { "/remhome", "/rmhome", }
		},
		["/deljail"] =
		{
			Permission =  "jail.deljail",
			HelpString =  "Delete a jail.",
			Handler =  HandleDelJailCommand,
			Alias = { "/remjail", "/rmjail", }
		},
		["/delwarp"] =
		{
			Permission =  "warp.dropwarp",
			HelpString =  "Delete a warp.",
			Handler =  HandleDelWarpCommand,
			Alias = { "/remwarp", "/rmwarp", }
		},
		["/feed"] =
		{
			Permission =  "es.feed",
			HelpString =  "Satisfy the hunger.",
			Handler =  HandleFeedCommand,
			Alias = "/eat"
		},
		["/flyspeed"] =
		{
			Permission = "es.flyspeed",  
			Handler =  HandleFlySpeedCommand,  
			HelpString = "Change a player's flying speed.", 
			Alias = "/fspeed", 
			Category = "Cheat",
		},
		["/hat"] =
		{
			Permission =  "es.hat",
			HelpString =  "Use your equipped item as a helmet.",
			Handler =  HandleHatCommand,
			Alias = "/head"
		},
		["/heal"] =
		{
			Permission =  "es.heal",
			HelpString =  "Heal a player.",
			Handler =  HandleHealCommand,
		},
		["/home"] =
		{
			Permission =  "es.home",
			HelpString =  "Teleport to your home.",
			Handler =  HandleHomeCommand,
		},
		["/itemdb"] =
		{
			Permission =  "es.itemdb",
			HelpString =  "Displays the item information of an item you are holding.",
			Handler =  HandleItemdbCommand,
			Alias = { "/iteminfo", "/itemno", "/durability", "/dura", }
		},
		["/jail"] =
		{
			Permission =  "jail.jail",
			HelpString =  "Jail a player.",
			Handler =  HandleJailCommand,
		},
		["/jails"] =
		{
			Permission =  "jail.listjail",
			HelpString =  "Lists all jails.",
			Handler =  HandleListJailCommand,
		},
		["/lightning"] =
		{
			Permission =  "es.lightning",
			HelpString =  "Damage the specified player with lightning.",
			Handler =  HandleLightningCommand,
			Alias = { "/shock", "/strike", "/smite", "/thor", }
		},
		["/more"] =
		{
			Permission =  "es.more",
			HelpString =  "Increases the item amount in the held stack to 64 items.",
			Handler =  HandleMoreCommand,
		},
		["/mute"] =
		{
			Permission =  "es.mute",
			HelpString =  "Mute a player.",
			Handler =  HandleMuteCommand,
			Alias = "/silence"
		},
		["/ping"] =
		{
			Permission =  "es.ping",
			HelpString =  "Check if the server is alive.",
			Handler =  HandlePingCommand,
			Alias = { "/pong", "/echo", }
		},
		["/place"] =
		{
			Permission =  "es.place",
			HelpString =  "Teleport a player where you are looking.",
			Handler =  HandlePlaceCommand,
		},
		["/repair"] =
		{
			Permission =  "es.repair",
			HelpString =  "Repair the item you are holding.",
			Handler =  HandleRepairCommand,
			Alias = "/fix"
		},
		["/runspeed"] =
		{
			Permission = "es.runspeed",  
			Handler =  HandleRunSpeedCommand,  
			HelpString = "Change a player's sprinting speed.", 
			Alias = "/rspeed", 
			Category = "Cheat",
		},
		["/sethome"] =
		{
			Permission =  "es.sethome",
			HelpString =  "Set your home.",
			Handler =  HandleSetHomeCommand,
			Alias = "/createhome"
		},
		["/setjail"] =
		{
			Permission =  "jail.setjail",
			HelpString =  "Create a jail at your location.",
			Handler =  HandleSetJailCommand,
			Alias = "/createjail"
		},
		["/setwarp"] =
		{
			Permission =  "warp.setwarp",
			HelpString =  "Create a warp at your location.",
			Handler =  HandleSetWarpCommand,
			Alias = "/createwarp"
		},
		["/shout"] =
		{
			Permission =  "es.shout",
			HelpString =  "Chat in a range of 128 blocks.",
			Handler =  HandleShoutCommand,
			Alias = "/whisper"
		},
		["/spawnmob"] =
		{
			Permission =  "es.spawnmob",
			HelpString =  "Spawn a mob.",
			Handler =  HandleSpawnMobCommand,
			Alias = "/mob"
		},
		["/unjail"] =
		{
			Permission =  "jail.unjail",
			HelpString =  "Unjail a player.",
			Handler =  HandleUnJailCommand,
		},
		["/unmute"] =
		{
			Permission =  "es.unmute",
			HelpString =  "Unmute a player.",
			Handler =  HandleUnmuteCommand,
		},
		["/walkspeed"] =
		{
			Permission = "es.walkspeed",  
			Handler =  HandleWalkSpeedCommand,  
			HelpString = "Change a player's flying speed.", 
			Alias = "/wspeed", 
			Category = "Cheat",
		},
		["/warp"] =
		{
			Permission =  "warp.warp",
			HelpString =  "Moves player to location of warp [Tag].",
			Handler =  HandleWarpCommand,
		},
		["/warps"] =
		{
			Permission =  "warp.listwarp",
			HelpString =  "Lists all warps.",
			Handler =  HandleListWarpCommand,
		},
		["/whereami"] =
		{
			Permission =  "es.getpos",
			HelpString =  "Get your current location in the world.",
			Handler =  HandleGetPosCommand,
			Alias = { "/getpos", "/getlocation", "/getloc", "/coords", "/position", }
		},
		["/whois"] =
		{
			Permission =  "es.whois",
			HelpString =  "Get information about the specified player.",
			Handler =  HandleWhoisCommand,
		},
		["/xp"] =
		{
			Permission = "es.xp",  
			Handler = HandleXPCommand,  
			HelpString = "Manage xp for a player.",
			Alias = "/exp",
			Category = "Cheat",
			Subcommands =
			{
				show =
				{
					HelpString = "Show xp of specified player.",
					Permission = "es.xp.show",
					Handler = HandleXPCommand,
				},
				set =
				{
					HelpString = "Set player's current xp.",
					Permission = "es.xp.set",
					Handler = HandleXPCommand,
				},
				give =
				{
					HelpString = "Give xp to the specified player.",
					Permission = "es.xp.give",
					Handler = HandleXPCommand,
				},
			},
		},
	},
}
