local Fly = {}


function Initialize(Plugin)
	Plugin:SetName("Essentials")
	Plugin:SetVersion(0)

	
    cPluginManager.BindCommand( "/more",          "es.more",      HandleMoreCommand,   " Changes the held stack to have 64 items." )
    cPluginManager.BindCommand( "/spawnmob",          "es.spawnmob",      HandleSpawnMobCommand,   " Spawn a mob." )
    cPluginManager.BindCommand( "/biome",          "es.biome",      HandleBiomeCommand,   " Tells you the biome in wich you are." )
    cPluginManager.BindCommand( "/repair",          "es.repair",      HandleRepairCommand,   " Repairs the item you are holding." )
    cPluginManager.BindCommand( "/feed",          "es.feed",      HandleFeedCommand,   " Satisfy the hunger." )
    cPluginManager.BindCommand( "/heal",          "es.heal",      HandleHealCommand,   " Heals a player." )
    cPluginManager.BindCommand( "/enchant",          "es.enchant",      HandleEnchantCommand,   " Enchants the item you are holding." )
    cPluginManager.BindCommand( "/xp",          "es.xp",      HandleXPCommand,   " Give, set, or look xp from a player." )
    cPluginManager.BindCommand( "/burn",          "es.burn",      HandleBurnCommand,   " Set a player on fire." )
    cPluginManager.BindCommand( "/ping",          "es.ping",      HandlePingCommand,   " Check if the server is alive." )
    cPluginManager.BindCommand( "/vanish",          "es.vanish",      HandleVanishCommand,   " Be invisible!." )
    cPluginManager.BindCommand( "/hat",          "es.hat",      HandleHatCommand,   " Use your equipped item as helmet." )
    cPluginManager.BindCommand( "/fly",          "es.fly",      HandleFlyCommand,   " Enable or disable flying." )
    
    cPluginManager:AddHook(cPluginManager.HOOK_TAKE_DAMAGE, OnTakeDamage);
	LOG("Initialized " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	return true
end





