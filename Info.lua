-- Info.lua

-- Implements the g_PluginInfo standard plugin description

g_PluginInfo =
{
	Name = "Essentials",
	Version = "0.1",
	Description = [[This plugin aims to port commands from Bukkit's Essentials to MCServer, but also to implement new commands. It provides non-vanilla commands that do not exist in Core.]],

	AdditionalInfo =
	{
		{
			Title = "Warp Signs",
			Contents = [[To create a warp sign, use the following template:
			[Warp]
			warpname]],
		},
		{
			Title = "Enchant Signs",
			Contents = [[To create an enchant sign, use the following template:
			[Enchant]
			EnchantmentID
			EnchantmentLevel
			RequiredXPLevelToEnchant]],
		},
		{
			Title = "Portals",
			Contents = [[To create a portal, place a sign underneath a block with the following template:
			[Portal]
			Warpname
			
			When walking on top of the block, you will get teleported to the specified warp.]],
		},
	},
	Commands =
	{
		["/antioch"] =
		{
			Permission = "es.antioch",
			HelpString = "Spawn a TNT in the location you're looking at.",
			Handler = HandleAntiOchCommand,
			Alias = { "/grenade", "/tnt", }
		},
		["/back"] =
		{
			Permission =  "es.back",
			HelpString =  "Return to last known position.",
			Handler =  HandleBackCommand,
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
			Permission =  "es.deljail",
			HelpString =  "Delete a jail.",
			Handler =  HandleDelJailCommand,
			Alias = { "/remjail", "/rmjail", }
		},
		["/delwarp"] =
		{
			Permission =  "es.dropwarp",
			HelpString =  "Delete a warp.",
			Handler =  HandleDelWarpCommand,
			Alias = { "/remwarp", "/rmwarp", }
		},
                ["/ext"] =
                {
                        Permission =  "es.ext",
                        HelpString =  "Extinguish a player.",
                        Handler =  HandleExtinguishCommand,
                        Alias = { "/extinguish", },
                },
		["/feed"] =
		{
			Permission =  "es.feed",
			HelpString =  "Satisfy the hunger.",
			Handler =  HandleFeedCommand,
			Alias = "/eat"
		},
		["/fly"] =
		{
			Permission = "es.fly",  
			Handler =  HandleFlyCommand,  
			HelpString = "Toggle flying.",  
			Category = "Cheat",
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
			Permission =  "es.jail",
			HelpString =  "Jail a player.",
			Handler =  HandleJailCommand,
		},
		["/jails"] =
		{
			Permission =  "es.listjail",
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
		["/locate"] =
		{
			Permission =  "es.locate",
			HelpString =  "Get your current coords.",
			Handler =  HandleLocateCommand,
			Alias = { "/getpos", "/whereami", "/getloc", "/coords", "/position" }
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
			Permission =  "es.setjail",
			HelpString =  "Create a jail at your location.",
			Handler =  HandleSetJailCommand,
			Alias = "/createjail"
		},
		["/setwarp"] =
		{
			Permission =  "es.setwarp",
			HelpString =  "Create a warp at your location.",
			Handler =  HandleSetWarpCommand,
			Alias = "/createwarp"
		},
		["/shout"] =
		{
			Permission =  "es.shout",
			HelpString =  "Chat in a range of 128 blocks.",
			Handler =  HandleShoutCommand,
		},
		["/spawnmob"] =
		{
			Permission =  "es.spawnmob",
			HelpString =  "Spawn a mob.",
			Handler =  HandleSpawnMobCommand,
			Alias = "/mob"
		},
		["/top"] =
		{
			Permission =  "es.top",
			HelpString =  "Teleport to the highest block.",
			Handler =  HandleTopCommand,
		},
		["/tpa"] =
		{
			Permission =  "es.tpa",
			HelpString =  "Request teleport to someone's position.",
			Handler =  HandleTPACommand,
		},
		["/tpaccept"] =
		{
			Permission =  "es.tpa",
			HelpString =  "Accept teleport request.",
			Handler =  HandleTPAcceptCommand,
		},
		["/tpahere"] =
		{
			Permission =  "es.tpa",
			HelpString =  "Request teleport to your position.",
			Handler =  HandleTPACommand,
		},
		["/tpdeny"] =
		{
			Permission =  "es.tpa",
			HelpString =  "Deny teleport request.",
			Handler =  HandleTPDenyCommand,
		},
		["/tphere"] =
		{
			Permission =  "es.tp",
			HelpString =  "Teleport a player to your position.",
			Handler =  HandleTPHereCommand,
			Alias = "/bring"
		},
		["/tps"] =
		{
			Permission =  "es.tpa",
			HelpString =  "Measure server lag.",
			Handler =  HandleTPSCommand,
			Alias = "/lag"
		},
		["/unjail"] =
		{
			Permission =  "es.unjail",
			HelpString =  "Unjail a player.",
			Handler =  HandleUnJailCommand,
		},
		["/unmute"] =
		{
			Permission =  "es.unmute",
			HelpString =  "Unmute a player.",
			Handler =  HandleUnmuteCommand,
		},
		["/vanish"] =
		{
			Permission =  "es.vanish",
			HelpString =  "Toggle visibility",
			Handler =  HandleVanishCommand,
			Alias = "/hide"
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
			Permission =  "es.warp",
			HelpString =  "Moves player to location of warp [Tag].",
			Handler =  HandleWarpCommand,
		},
		["/warps"] =
		{
			Permission =  "es.listwarp",
			HelpString =  "Lists all warps.",
			Handler =  HandleListWarpCommand,
		},
		["/whisper"] =
		{
			Permission =  "es.whisper",
			HelpString =  "Chat in a range of 16 blocks.",
			Handler =  HandleShoutCommand,
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
	ConsoleCommands =
	{		
		["tps"] =
		{
			Handler =  HandleConsoleTPS,
			HelpString =  " - Returns the tps (ticks per second) from the server.",
		},
	},  
	Permissions = 
	{
		["es.biome.other"] =
		{
			Description = "Shows you in which biome another player is.",
			RecommendedGroups = "admins, mods",
		},
		["es.createportal"] =
		{
			Description = "Allows a player to create a portal.",
			RecommendedGroups = "admins, mods",
		},
		["es.enchantsign"] =
		{
			Description = "Allows a player to create Enchant Signs.",
			RecommendedGroups = "admins, mods",
		},
		["es.feed.other"] =
		{
			Description = "Satisfy the hunger of another player.",
			RecommendedGroups = "admins, mods",
		},
		["es.fly.other"] =
		{
			Description = "Toggle flying for other players.",
			RecommendedGroups = "admins, mods",
		},
		["es.getpos.other"] =
		{
			Description = "Get the position of another player.",
			RecommendedGroups = "admins, mods",
		},
		["es.heal.other"] =
		{
			Description = "Heal another player.",
			RecommendedGroups = "admins, mods",
		},
		["es.home.unlimited"] =
		{
			Description = "Allows a player to have an unlimited amount of homes.",
			RecommendedGroups = "mods, players",
		},
		["es.more.other"] =
		{
			Description = "Increases the item amount in another player's held stack to 64 items.",
			RecommendedGroups = "admins, mods",
		},
		["es.spawnmob.other"] =
		{
			Description = "Spawns a mob near a player.",
			RecommendedGroups = "admins, mods",
		},
		["es.warpsign"] =
		{
			Description = "Allows a player to create Warp Signs.",
			RecommendedGroups = "admins, mods",
		},
	},
}
