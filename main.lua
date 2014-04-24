
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
	LOG("Initialized " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	return true
end





