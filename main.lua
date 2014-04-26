warps = {}
jails = {}


function Initialize(Plugin)
	Plugin:SetName("Essentials")
	Plugin:SetVersion(0)
	
	cPluginManager.BindCommand( "/more",        "es.more",      HandleMoreCommand,   " Changes the held stack to have 64 items." )
	cPluginManager.BindCommand( "/spawnmob",    "es.spawnmob",      HandleSpawnMobCommand,   " Spawn a mob." )
	cPluginManager.BindCommand( "/biome",       "es.biome",      HandleBiomeCommand,   " Tells you the biome in wich you are." )
	cPluginManager.BindCommand( "/repair",      "es.repair",      HandleRepairCommand,   " Repairs the item you are holding." )
	cPluginManager.BindCommand( "/feed",        "es.feed",      HandleFeedCommand,   " Satisfy the hunger." )
	cPluginManager.BindCommand( "/heal",        "es.heal",      HandleHealCommand,   " Heals a player." )
	cPluginManager.BindCommand( "/enchant",     "es.enchant",      HandleEnchantCommand,   " Enchants the item you are holding." )
	cPluginManager.BindCommand( "/xp",          "es.xp",      HandleXPCommand,   " Give, set, or look xp from a player." )
	cPluginManager.BindCommand( "/burn",        "es.burn",      HandleBurnCommand,   " Set a player on fire." )
	cPluginManager.BindCommand( "/ping",        "es.ping",      HandlePingCommand,   " Check if the server is alive." )
	cPluginManager.BindCommand( "/vanish",      "es.vanish",      HandleVanishCommand,   " Be invisible!." )
	cPluginManager.BindCommand( "/hat",         "es.hat",      HandleHatCommand,   " Use your equipped item as helmet." )
	cPluginManager.BindCommand( "/fly",         "es.fly",      HandleFlyCommand,   " Enable or disable flying." )
	cPluginManager:BindCommand("/warp",         "warp.warp",      	      HandleWarpCommand,      		      " - Moves player to location of warp [Tag].");
	cPluginManager:BindCommand("/setwarp",      "warp.setwarp",     	      HandleSetWarpCommand,   		      " - Creates a warp at players location.");
	cPluginManager:BindCommand("/delwarp",      "warp.dropwarp",            HandleDelWarpCommand,        	  " - Deletes a warp.");
	cPluginManager:BindCommand("/warps",        "warp.listwarp",            HandleListWarpCommand,              " - Lists all warps.");
	cPluginManager:BindCommand("/jail",         "jail.jail",      	    HandleJailCommand,      		  " - Jails a player.");
	cPluginManager:BindCommand("/unjail",       "jail.unjail",      	    HandleUnJailCommand,      	  " - unjails a player.");
	cPluginManager:BindCommand("/setjail",      "jail.setjail",     	    HandleSetJailCommand,   		  " - Creates a jail at players location.");
	cPluginManager:BindCommand("/deljail",      "jail.deljail",            HandleDelJailCommand,        	  " - Deletes a jail.");
	cPluginManager:BindCommand("/jails",        "jail.listjail",           HandleListJailCommand,            " - Lists all jails.");
	cPluginManager:BindCommand("/home",          "es.home",                HandleHomeCommand,                " - Go Home")
	cPluginManager:BindCommand("/sethome",       "es.sethome",            HandleSetHomeCommand,           " - Set your home!")
	cPluginManager:BindCommand("/delhome",       "es.delhome",            HandleDelHomeCommand,           " - Delete a home!")

	cPluginManager:AddHook(cPluginManager.HOOK_TAKE_DAMAGE, OnTakeDamage);
	cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_RIGHT_CLICK, OnPlayerRightClick)
	cPluginManager.AddHook(cPluginManager.HOOK_UPDATING_SIGN, OnUpdatingSign);
	cPluginManager:AddHook(cPluginManager.HOOK_CHAT, OnChat)
	cPluginManager:AddHook(cPluginManager.HOOK_EXECUTE_COMMAND, OnExecuteCommand)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_BREAKING_BLOCK, OnPlayerBreakingBlock)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_PLACING_BLOCK, OnPlayerPlacingBlock)
		
	local WarpsINI = cIniFile()
	if (WarpsINI:ReadFile("warps.ini")) then
		warpNum = WarpsINI:GetNumKeys();
		for i=0, warpNum do
			local Tag = WarpsINI:GetKeyName(i)
			warps[Tag] = {}
			warps[Tag]["w"] = WarpsINI:GetValue( Tag , "w")
			warps[Tag]["x"] = WarpsINI:GetValueI( Tag , "x")
			warps[Tag]["y"] = WarpsINI:GetValueI( Tag , "y")
			warps[Tag]["z"] = WarpsINI:GetValueI( Tag , "z")
		end
	end

	localdir = Plugin:GetLocalDirectory()
	homeDir = Plugin:GetLocalDirectory().."/homes"
    
	local jailsINI = cIniFile()
	if (jailsINI:ReadFile("jails.ini")) then
		jailNum = jailsINI:GetNumKeys();
		for i=0, jailNum do
			local Tag = jailsINI:GetKeyName(i)
			jails[Tag] = {}
			jails[Tag]["w"] = jailsINI:GetValue( Tag , "w")
			jails[Tag]["x"] = jailsINI:GetValueI( Tag , "x")
			jails[Tag]["y"] = jailsINI:GetValueI( Tag , "y")
			jails[Tag]["z"] = jailsINI:GetValueI( Tag , "z")
		end
	end

	UsersIni = cIniFile()
	UsersIni:ReadFile("users.ini")

	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	return true
end





