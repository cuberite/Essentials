
function Initialize(Plugin)
	Plugin:SetName("CommandBook")
	Plugin:SetVersion(3)

	
    cPluginManager.BindCommand( "/more",          "cb.more",      HandleMoreCommand,   " Changes the held stack to have 64 items." )
    cPluginManager.BindCommand( "/spawnmob",          "cb.spawnmob",      HandleSpawnMobCommand,   " Spawn a mob." )
	LOG("Initialized " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	return true
end





