-- Info.lua

-- Implements the g_PluginInfo standard plugin description




g_PluginInfo =
{
    Name = "Essentials",
    Version = "0.1",
    Description = "Adds some useful commands taken from Bukkit's Essentials",

    Commands =
    {
        ["/antioch"] =
        {
            Permission = "es.antioch",
            HelpString = "TNT!",
            Handler = HandleAntiOchCommand,
            Alias = { "/grenade", "/tnt", }
        },
        ["/more"] =
        {
            Permission =  "es.more",
            HelpString =  " Changes the held stack to have 64 items.",
            Handler =  HandleMoreCommand,
        },

        ["/spawnmob"] =
        {
            Permission =  "es.spawnmob",
            HelpString =  " Spawn a mob.",
            Handler =  HandleSpawnMobCommand,
            Alias = "/mob"
        },

        ["/biome"] =
        {
            Permission =  "es.biome",
            HelpString =  " Tells you the biome in wich you are.",
            Handler =  HandleBiomeCommand,
        },

        ["/repair"] =
        {
            Permission =  "es.repair",
            HelpString =  " Repairs the item you are holding.",
            Handler =  HandleRepairCommand,
            Alias = "/fix"
        },

        ["/feed"] =
        {
            Permission =  "es.feed",
            HelpString =  " Satisfy the hunger.",
            Handler =  HandleFeedCommand,
            Alias = "/eat"
        },

        ["/heal"] =
        {
            Permission =  "es.heal",
            HelpString =  " Heals a player.",
            Handler =  HandleHealCommand,
        },

        ["/burn"] =
        {
            Permission =  "es.burn",
            HelpString =  " Set a player on fire.",
            Handler =  HandleBurnCommand,
        },

        ["/ping"] =
        {
            Permission =  "es.ping",
            HelpString =  " Check if the server is alive.",
            Handler =  HandlePingCommand,
            Alias = { "/pong", "/echo", }
        },

        ["/hat"] =
        {
            Permission =  "es.hat",
            HelpString =  " Use your equipped item as helmet.",
            Handler =  HandleHatCommand,
            Alias = "/head"
        },

        ["/warp"] =
        {
            Permission =  "warp.warp",
            HelpString =  " - Moves player to location of warp [Tag].",
            Handler =  HandleWarpCommand,
        },

        ["/setwarp"] =
        {
            Permission =  "warp.setwarp",
            HelpString =  " - Creates a warp at players location.",
            Handler =  HandleSetWarpCommand,
            Alias = "/createwarp"
        },

        ["/delwarp"] =
        {
            Permission =  "warp.dropwarp",
            HelpString =  " - Deletes a warp.",
            Handler =  HandleDelWarpCommand,
            Alias = { "/remwarp", "/rmwarp", }
        },

        ["/warps"] =
        {
            Permission =  "warp.listwarp",
            HelpString =  " - Lists all warps.",
            Handler =  HandleListWarpCommand,
        },

        ["/jail"] =
        {
            Permission =  "jail.jail",
            HelpString =  " - Jails a player.",
            Handler =  HandleJailCommand,
        },

        ["/unjail"] =
        {
            Permission =  "jail.unjail",
            HelpString =  " - unjails a player.",
            Handler =  HandleUnJailCommand,
        },

        ["/setjail"] =
        {
            Permission =  "jail.setjail",
            HelpString =  " - Creates a jail at players location.",
            Handler =  HandleSetJailCommand,
            Alias = "/createjail"
        },

        ["/deljail"] =
        {
            Permission =  "jail.deljail",
            HelpString =  " - Deletes a jail.",
            Handler =  HandleDelJailCommand,
            Alias = { "/remjail", "/rmjail", }
        },

        ["/jails"] =
        {
            Permission =  "jail.listjail",
            HelpString =  " - Lists all jails.",
            Handler =  HandleListJailCommand,
        },

        ["/home"] =
        {
            Permission =  "es.home",
            HelpString =  " - Go Home",
            Handler =  HandleHomeCommand,
        },

        ["/sethome"] =
        {
            Permission =  "es.sethome",
            HelpString =  " - Set your home!",
            Handler =  HandleSetHomeCommand,
            Alias = "/createhome"
        },

        ["/delhome"] =
        {
            Permission =  "es.delhome",
            HelpString =  " - Delete a home!",
            Handler =  HandleDelHomeCommand,
            Alias = { "/remhome", "/rmhome", }
        },

        ["/lightning"] =
        {
            Permission =  "es.lightning",
            HelpString =  " - Get a lightning damage the specified player",
            Handler =  HandleLightningCommand,
            Alias = { "/shock", "/strike", "/smite", "/thor", }
        },

        ["/place"] =
        {
            Permission =  "es.place",
            HelpString =  " - Teleports a player where you are looking",
            Handler =  HandlePlaceCommand,
        },

        ["/whereami"] =
        {
            Permission =  "es.getpos",
            HelpString =  " - Get your current location in the world",
            Handler =  HandleGetPosCommand,
            Alias = { "/getpos", "/getlocation", "/getloc", "/coords", "/position", }
        },

        ["/whois"] =
        {
            Permission =  "es.whois",
            HelpString =  " - Get information about the specified player",
            Handler =  HandleWhoisCommand,
        },
        
		["/xp"] =
		{
			Permission = "es.xp",  
			Handler = HandleXPCommand,  
			HelpString = " Give, set, or look xp from a player.",
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
					HelpString = "Give xp to the specified player",
					Permission = "es.xp.give",
					Handler = HandleXPCommand,
				},
			},
		},
		
        ["/broadcast"] =
        {
            Permission =  "es.broadcast",
            HelpString =  "Broadcast to all players.",
            Handler =  HandleBroadcastCommand,
            Alias = { "/say", "/bcast", "/bc", }
        },
        
        ["/itemdb"] =
        {
            Permission =  "es.itemdb",
            HelpString =  "Displays the item information attached to an item.",
            Handler =  HandleItemdbCommand,
            Alias = { "/iteminfo", "/itemno", "/durability", "/dura", }
        },
        
		["/flyspeed"] =
		{
			Permission = "es.flyspeed",  
			Handler =  HandleFlySpeedCommand,  
			HelpString = "Change player's flying speed.", 
            Alias = "/fspeed", 
			Category = "Cheat",
		},
		
		["/walkspeed"] =
		{
			Permission = "es.walkspeed",  
			Handler =  HandleWalkSpeedCommand,  
			HelpString = "Change player's flying speed.", 
            Alias = "/wspeed", 
			Category = "Cheat",
		},
		["/runspeed"] =
		{
			Permission = "es.runspeed",  
			Handler =  HandleRunSpeedCommand,  
			HelpString = "Change player's sprinting speed.", 
            Alias = "/rspeed", 
			Category = "Cheat",
		},

        ["/mute"] =
        {
            Permission =  "es.mute",
            HelpString =  "Mute a player.",
            Handler =  HandleMuteCommand,
            Alias = "/silence"
        },
        ["/unmute"] =
        {
            Permission =  "es.unmute",
            HelpString =  "Unmute a player.",
            Handler =  HandleUnmuteCommand,
        },
    },
}
