
function Initialize(Plugin)
	Plugin:SetName("Essentials")
	Plugin:SetVersion(0)

	
    cPluginManager.BindCommand( "/more",          "es.more",      HandleMoreCommand,   " Changes the held stack to have 64 items." )
    cPluginManager.BindCommand( "/spawnmob",          "es.spawnmob",      HandleSpawnMobCommand,   " Spawn a mob." )
    cPluginManager.BindCommand( "/biome",          "es.biome",      HandleBiomeCommand,   " Tells you the biome in wich you are." )
	LOG("Initialized " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	return true
end





