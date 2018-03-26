-- Info.lua

-- Implements the g_PluginInfo standard plugin description

g_PluginInfo =
{
	Name = "Essentials",
	Version = "2",
	Date = "2018-03-26",
	Description = [[This plugin aims to port commands from Bukkit's Essentials to Cuberite, but also to implement new commands. It provides non-vanilla commands that do not exist in Core.]],

	AdditionalInfo =
	{
		{
			Title = "Warp Sign Template",
			Contents = [[
			[Warp]
			warpname]],
		},
		{
			Title = "Command Sign Template",
			Contents = [[
			[Command]
			/tell player 
 			hello <-- Notice the space before "hello" (alternatively at end of "/tell player")]],
		},
		{
			Title = "Enchant Sign Template",
			Contents = [[
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
		["/adventure"] =
		{
			Permission = "es.gm.adventure",
			HelpString = "Changes a player's gamemode to adventure",
			Handler = HandleGamemodeCommand,
			Alias = "/gma"
		},
		["/antioch"] =
		{
			Permission = "es.antioch",
			HelpString = "Spawns a TNT at the position you're looking at",
			Handler = HandleAntiOchCommand,
			Alias = { "/grenade", "/tnt", }
		},
		["/back"] =
		{
			Permission = "es.back",
			HelpString = "Returns you to your previous position",
			Handler = HandleBackCommand,
			Alias = "/return"
		},
		["/biome"] =
		{
			Permission = "es.biome",
			HelpString = "Tells you the biome in which you are",
			Handler = HandleBiomeCommand,
		},
		["/broadcast"] =
		{
			Permission = "es.broadcast",
			HelpString = "Broadcasts a message to all players",
			Handler = HandleBroadcastCommand,
			Alias = { "/bcast", "/bc", }
		},
		["/burn"] =
		{
			Permission = "es.burn",
			HelpString = "Sets a player on fire",
			Handler = HandleBurnCommand,
		},
		["/creative"] =
		{
			Permission = "es.gm.creative",
			HelpString = "Changes a player's gamemode to creative",
			Handler = HandleGamemodeCommand,
			Alias = "/gmc"
		},
		["/delhome"] =
		{
			Permission = "es.delhome",
			HelpString = "Removes your home",
			Handler = HandleDelHomeCommand,
			Alias = { "/remhome", "/rmhome", }
		},
		["/deljail"] =
		{
			Permission = "es.deljail",
			HelpString = "Removes a jail",
			Handler = HandleDelJailCommand,
			Alias = { "/remjail", "/rmjail", }
		},
		["/delwarp"] =
		{
			Permission = "es.dropwarp",
			HelpString = "Removes a warp",
			Handler = HandleDelWarpCommand,
			Alias = { "/remwarp", "/rmwarp", }
		},
		["/depth"] =
		{
			Permission = "es.depth",
			HelpString = "Displays your height relative to sea level",
			Handler = HandleDepthCommand,
			Alias = "/height"
		},
		["/ext"] =
		{
			Permission = "es.ext",
			HelpString = "Extinguishes a player",
			Handler = HandleExtinguishCommand,
			Alias = "/extinguish"
		},
		["/feed"] =
		{
			Permission = "es.feed",
			HelpString = "Satisfies the hunger",
			Handler = HandleFeedCommand,
			Alias = "/eat"
		},
		["/fireball"] =
		{
			Permission = "es.fireball",
			HelpString = "Shoots a fireball",
			Handler = HandleFireballCommand,
		},
		["/fly"] =
		{
			Permission = "es.fly",
			HelpString = "Enables or disables flying",
			Handler = HandleFlyCommand,
		},
		["/flyspeed"] =
		{
			Permission = "es.flyspeed",
			HelpString = "Changes a player's flying speed",
			Handler = HandleSpeedCommand,
		},
		["/god"] =
		{
			Permission = "es.god",
			HelpString = "Makes you immortal",
			Handler = HandleGodCommand,
			Alias = { "/godmode", "/tgm", }
		},
		["/hat"] =
		{
			Permission = "es.hat",
			HelpString = "Use your equipped item as a helmet",
			Handler = HandleHatCommand,
			Alias = "/head"
		},
		["/heal"] =
		{
			Permission = "es.heal",
			HelpString = "Heals a player",
			Handler =  HandleHealCommand,
		},
		["/home"] =
		{
			Permission = "es.home",
			HelpString = "Teleports you home",
			Handler = HandleHomeCommand,
		},
		["/itemdb"] =
		{
			Permission = "es.itemdb",
			HelpString = "Displays the item information of an item you are holding",
			Handler = HandleItemdbCommand,
			Alias = { "/iteminfo", "/itemno", "/durability", "/dura", }
		},
		["/jail"] =
		{
			Permission = "es.jail",
			HelpString = "Jails a player",
			Handler = HandleJailCommand,
		},
		["/jails"] =
		{
			Permission = "es.listjail",
			HelpString = "Lists all available jails",
			Handler = HandleListJailCommand,
		},
		["/lightning"] =
		{
			Permission = "es.lightning",
			HelpString = "Spawns lightning near a player",
			Handler = HandleLightningCommand,
			Alias = { "/shock", "/strike", "/smite", "/thor", }
		},
		["/locate"] =
		{
			Permission = "es.locate",
			HelpString = "Displays your current coordinates",
			Handler = HandleLocateCommand,
			Alias = { "/getpos", "/whereami", "/getloc", "/coords", "/position" }
		},
		["/more"] =
		{
			Permission = "es.more",
			HelpString = "Increases the item amount in the held stack to 64 items",
			Handler = HandleMoreCommand,
		},
		["/mute"] =
		{
			Permission = "es.mute",
			HelpString = "Mutes a player",
			Handler = HandleMuteCommand,
			Alias = "/silence"
		},
		["/near"] =
		{
			Permission = "es.near",
			HelpString = "Displays a list of nearby players",
			Handler = HandleNearCommand,
			Alias = "/nearby"
		},
		["/nuke"] =
		{
			Permission = "es.nuke",
			HelpString = "Spawns a nuke above players",
			Handler = HandleNukeCommand,
		},
		["/ping"] =
		{
			Permission = "es.ping",
			HelpString = "Displays a message if the server is alive",
			Handler = HandlePingCommand,
			Alias = { "/pong", "/echo", }
		},
		["/place"] =
		{
			Permission = "es.place",
			HelpString = "Teleports a player where you are looking",
			Handler = HandlePlaceCommand,
		},
		["/powertool"] = 
		{
			Permission = "es.powertool",
			HelpString = "Binds a command to the item you are holding",
			Handler = HandlePowertoolCommand,
			Alias = "/pt"
		},
		["/repair"] =
		{
			Permission = "es.repair",
			HelpString = "Repairs the item you are holding",
			Handler = HandleRepairCommand,
			Alias = "/fix"
		},
		["/runspeed"] =
		{
			Permission = "es.runspeed",
			HelpString = "Changes a player's running speed",
			Handler = HandleSpeedCommand,
		},
		["/sethome"] =
		{
			Permission = "es.sethome",
			HelpString = "Sets your home",
			Handler = HandleSetHomeCommand,
			Alias = "/createhome"
		},
		["/setjail"] =
		{
			Permission = "es.setjail",
			HelpString = "Creates a jail at your location",
			Handler = HandleSetJailCommand,
			Alias = "/createjail"
		},
		["/setwarp"] =
		{
			Permission = "es.setwarp",
			HelpString = "Creates a warp at your location",
			Handler = HandleSetWarpCommand,
			Alias = "/createwarp"
		},
		["/shout"] =
		{
			Permission = "es.shout",
			HelpString = "Displays a chat message in a range of 128 blocks",
			Handler = HandleShoutCommand,
		},
		["/skull"] =
		{
			Permission = "es.skull",
			HelpString = "Allows you to change the skin of a skull",
			Handler = HandleSkullCommand,
		},
		["/socialspy"] = 
		{
			Permission = "es.socialspy",
			HelpString = "Displays other players' private messages",
			Handler = HandleSocialSpyCommand,
		},	
		["/spawnmob"] =
		{
			Permission = "es.spawnmob",
			HelpString = "Spawns a mob",
			Handler = HandleSpawnMobCommand,
			Alias = "/mob"
		},
		["/spectator"] =
		{
			Permission = "es.gm.spectator",
			HelpString = "Changes a player's gamemode to spectator",
			Handler = HandleGamemodeCommand,
			Alias = "/gmsp"
		},
		["/speed"] =
		{
			Permission = "es.speed",
			HelpString = "Changes a player's moving speed",
			Handler = HandleSpeedCommand,
			Subcommands =
			{
				fly =
				{
					HelpString = "Changes a player's flying speed",
					Permission = "es.flyspeed",
					Handler = HandleSpeedCommand,
				},
				walk =
				{
					HelpString = "Changes a player's walk speed",
					Permission = "es.walkspeed",
					Handler = HandleSpeedCommand,
				},
				run =
				{
					HelpString = "Changes a player's running speed",
					Permission = "es.runspeed",
					Handler = HandleSpeedCommand,
				},
			},
		},
		["/survival"] =
		{
			Permission = "es.gm.survival",
			HelpString = "Changes a player's gamemode to survival",
			Handler = HandleGamemodeCommand,
			Alias = "/gms"
		},
		["/top"] =
		{
			Permission = "es.top",
			HelpString = "Teleports you to the highest block",
			Handler = HandleTopCommand,
		},
		["/tpa"] =
		{
			Permission = "es.tpa",
			HelpString = "Requests teleportation to a player",
			Handler = HandleTPACommand,
			Alias = { "/call", "/tpask", }
		},
		["/tpaccept"] =
		{
			Permission = "es.tpa",
			HelpString = "Accepts teleportation request",
			Handler = HandleTPAcceptDenyCommand,
			Alias = "/tpyes"
		},
		["/tpahere"] =
		{
			Permission = "es.tpa",
			HelpString = "Requests teleportation of another player to you",
			Handler = HandleTPACommand,
		},
		["/tpdeny"] =
		{
			Permission = "es.tpa",
			HelpString = "Denies teleportation request",
			Handler =  HandleTPAcceptDenyCommand,
			Alias = "/tpno"
		},
		["/tphere"] =
		{
			Permission = "es.tp",
			HelpString = "Teleports a player to you",
			Handler = HandleTPHereCommand,
			Alias = { "/bring", "/s", }
		},
		["/tps"] =
		{
			Permission = "es.tps",
			HelpString = "Returns the tps (ticks per second) from the server",
			Handler = HandleTPSCommand,
			Alias = "/lag"
		},
		["/unjail"] =
		{
			Permission = "es.unjail",
			HelpString = "Unjails a player",
			Handler = HandleUnJailCommand,
		},
		["/unmute"] =
		{
			Permission = "es.unmute",
			HelpString = "Unmutes a player",
			Handler = HandleUnmuteCommand,
		},
		["/vanish"] =
		{
			Permission = "es.vanish",
			HelpString = "Enables or disables player visibility",
			Handler = HandleVanishCommand,
			Alias = { "/hide", "/v", }
		},
		["/walkspeed"] =
		{
			Permission = "es.walkspeed",
			HelpString = "Changes a player's walking speed",
			Handler = HandleSpeedCommand,
		},
		["/warp"] =
		{
			Permission = "es.warp",
			HelpString = "Moves player to location of a warp",
			Handler = HandleWarpCommand,
		},
		["/warps"] =
		{
			Permission = "es.listwarp",
			HelpString = "Lists all warps",
			Handler = HandleListWarpCommand,
		},
		["/whisper"] =
		{
			Permission = "es.whisper",
			HelpString = "Displays a chat message in a range of 16 blocks",
			Handler = HandleShoutCommand,
		},
		["/whois"] =
		{
			Permission = "es.whois",
			HelpString = "Displays information about the specified player",
			Handler = HandleWhoisCommand,
		},
		["/xp"] =
		{
			Permission = "es.xp",  
			Handler = HandleXPCommand,  
			HelpString = "Manage XP for a player",
			Alias = "/exp",
			Subcommands =
			{
				show =
				{
					HelpString = "Shows XP of a player",
					Permission = "es.xp.show",
					Handler = HandleXPCommand,
				},
				set =
				{
					HelpString = "Sets current XP of a player",
					Permission = "es.xp.set",
					Handler = HandleXPCommand,
				},
				give =
				{
					HelpString = "Gives XP to a player",
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
			HelpString =  "Returns the tps (ticks per second) from the server",
			Handler =  HandleConsoleTPS,
			Alias = "lag",
		},
	},  
	
	
	
	Permissions = 
	{
		["es.biome.other"] =
		{
			Description = "Shows you in which biome another player is",
			RecommendedGroups = "admins, mods",
		},
		["es.commandsign"] =
		{
			Description = "Allows a player to create signs which execute commands",
			RecommendedGroups = "admins, mods",
		},		
		["es.createportal"] =
		{
			Description = "Allows a player to create a portal",
			RecommendedGroups = "admins, mods",
		},
		["es.enchantsign"] =
		{
			Description = "Allows a player to create Enchant Signs",
			RecommendedGroups = "admins, mods",
		},
		["es.feed.other"] =
		{
			Description = "Satisfies the hunger of another player",
			RecommendedGroups = "admins, mods",
		},
		["es.fly.other"] =
		{
			Description = "Enables or disables flying for another player",
			RecommendedGroups = "admins, mods",
		},
		["es.gm.adventure.other"] =
		{
			Description = "Changes the gamemode of another player to adventure",
			RecommendedGroups = "admins, mods",
		},
		["es.gm.creative.other"] =
		{
			Description = "Changes the gamemode of another player to creative",
			RecommendedGroups = "admins, mods",
		},
		["es.gm.spectator.other"] =
		{
			Description = "Changes the gamemode of another player to spectator",
			RecommendedGroups = "admins, mods",
		},
		["es.gm.survival.other"] =
		{
			Description = "Changes the gamemode of another player to survival",
			RecommendedGroups = "admins, mods",
		},
		["es.heal.other"] =
		{
			Description = "Heals another player",
			RecommendedGroups = "admins, mods",
		},
		["es.home.unlimited"] =
		{
			Description = "Allows a player to have an unlimited amount of homes",
			RecommendedGroups = "mods, players",
		},
		["es.locate.other"] =
		{
			Description = "Displays the position of another player",
			RecommendedGroups = "admins, mods",
		},
		["es.more.other"] =
		{
			Description = "Increases the item amount in another player's held stack to 64 items",
			RecommendedGroups = "admins, mods",
		},
		["es.spawnmob.other"] =
		{
			Description = "Spawns a mob near another player",
			RecommendedGroups = "admins, mods",
		},
		["es.vanish.other"] =
		{
			Description = "Enables or disables visibility for another player",
			RecommendedGroups = "admins, mods",
		},
		["es.warpsign"] =
		{
			Description = "Allows a player to create Warp Signs.",
			RecommendedGroups = "admins, mods",
		},
	},
}
