-- Info.lua

-- Implements the g_PluginInfo standard plugin description




g_PluginInfo =
{
    Name = "Essentials",
    Version = "0.1",
    Description = "Adds some usefull commands taken from bukkit's Essentials",

    Commands =
    {
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
        },

        ["/feed"] =
        {
            Permission =  "es.feed",
            HelpString =  " Satisfy the hunger.",
            Handler =  HandleFeedCommand,
        },

        ["/heal"] =
        {
            Permission =  "es.heal",
            HelpString =  " Heals a player.",
            Handler =  HandleHealCommand,
        },

        ["/enchant"] =
        {
            Permission =  "es.enchant",
            HelpString =  " Enchants the item you are holding.",
            Handler =  HandleEnchantCommand,
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
        },

        ["/hat"] =
        {
            Permission =  "es.hat",
            HelpString =  " Use your equipped item as helmet.",
            Handler =  HandleHatCommand,
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
        },

        ["/delwarp"] =
        {
            Permission =  "warp.dropwarp",
            HelpString =  " - Deletes a warp.",
            Handler =  HandleDelWarpCommand,
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
        },

        ["/deljail"] =
        {
            Permission =  "jail.deljail",
            HelpString =  " - Deletes a jail.",
            Handler =  HandleDelJailCommand,
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
        },

        ["/delhome"] =
        {
            Permission =  "es.delhome",
            HelpString =  " - Delete a home!",
            Handler =  HandleDelHomeCommand,
        },

        ["/lightning"] =
        {
            Permission =  "es.lightning",
            HelpString =  " - Get a lightning damage the specified player",
            Handler =  HandleLightningCommand,
            Alias = "/shock"
        },

        ["/tphere"] =
        {
            Permission =  "es.tphere",
            HelpString =  " - Teleports a player to you",
            Handler =  HandleTPHereCommand,
            Alias = "/bring"
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
            Alias = "/getpos"
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
            Alias = "/say"
        },
        
        ["/itemdb"] =
        {
            Permission =  "es.itemdb",
            HelpString =  "Displays the item information attached to an item.",
            Handler =  HandleItemdbCommand,
            Alias = "/iteminfo"
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
		
        ["/r"] =
        {
            Permission =  "es.r",
            HelpString =  "Answer quickly to latest private message you recieved.",
            Handler =  HandleRCommand,
        },
		
        ["/mute"] =
        {
            Permission =  "es.mute",
            HelpString =  "Mute a player.",
            Handler =  HandleMuteCommand,
        },
		
        ["/unmute"] =
        {
            Permission =  "es.unmute",
            HelpString =  "Unmute a player.",
            Handler =  HandleUnmuteCommand,
        },
    },
}