warps = {}
jails = {}
lastsender = {}
ticks = {}
timer = {}


function Initialize(Plugin)

    dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")
    
	Plugin:SetName(g_PluginInfo.Name)
	Plugin:SetVersion(g_PluginInfo.Version)

	cPluginManager:AddHook(cPluginManager.HOOK_TAKE_DAMAGE, OnTakeDamage);
	cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_RIGHT_CLICK, OnPlayerRightClick)
	cPluginManager.AddHook(cPluginManager.HOOK_UPDATING_SIGN, OnUpdatingSign);
	cPluginManager:AddHook(cPluginManager.HOOK_CHAT, OnChat)
	cPluginManager:AddHook(cPluginManager.HOOK_EXECUTE_COMMAND, OnExecuteCommand)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_BREAKING_BLOCK, OnPlayerBreakingBlock)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_PLACING_BLOCK, OnPlayerPlacingBlock)
    cPluginManager:AddHook(cPluginManager.HOOK_WORLD_TICK, OnWorldTick);
		
    RegisterPluginInfoCommands();
		
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

    if cFile:IsFolder(homeDir) ~= true then
        cFile:CreateFolder(homeDir)
    end
        
	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	return true
end





