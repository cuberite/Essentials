--Global variables
warps = {}
jails = {}
lastsender = {}
ticks = {}
timer = {}
BackCoords = {}
TpRequestTimeLimit = 0
TpsCache = {}
GlobalTps = {}

--Initialize the plugin
function Initialize(Plugin)

	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")

	Plugin:SetName(g_PluginInfo.Name)
	Plugin:SetVersion(g_PluginInfo.Version)

	--Register hooks
	cPluginManager:AddHook(cPluginManager.HOOK_TAKE_DAMAGE, OnTakeDamage);
	cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_RIGHT_CLICK, OnPlayerRightClick)
	cPluginManager.AddHook(cPluginManager.HOOK_UPDATING_SIGN, OnUpdatingSign);
	cPluginManager:AddHook(cPluginManager.HOOK_CHAT, OnChat)
	cPluginManager:AddHook(cPluginManager.HOOK_EXECUTE_COMMAND, OnExecuteCommand)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_BREAKING_BLOCK, OnPlayerBreakingBlock)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_PLACING_BLOCK, OnPlayerPlacingBlock)
	cPluginManager:AddHook(cPluginManager.HOOK_WORLD_TICK, OnWorldTick);
	cPluginManager:AddHook(cPluginManager.HOOK_TICK, OnTick);
	cPluginManager:AddHook(cPluginManager.HOOK_ENTITY_TELEPORT, OnEntityTeleport);

	RegisterPluginInfoCommands();

	--Read the warps (stored in ini file)
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

	--Set dirs which will be used later on
	localdir = Plugin:GetLocalFolder()
	homeDir = Plugin:GetLocalFolder().."/homes"

	--Read jails (from ini file)
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

	--If there's no home folder, plugin will create it
	if cFile:IsFolder(homeDir) ~= true then
		cFile:CreateFolder(homeDir)
	end

	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	return true
	--Finish!
end
