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
Jailed = {}
Muted = {}

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
	cPluginManager:AddHook(cPluginManager.HOOK_KILLED, OnKilled);
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED, OnPlayerJoined);

	RegisterPluginInfoCommands();
	
	RegisterPluginInfoConsoleCommands();

	--Read the warps (stored in ini file)
	WarpsINI = cIniFile()
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
	JailsINI = cIniFile()
	if (JailsINI:ReadFile("jails.ini")) then
		jailNum = JailsINI:GetNumKeys();
		for i=0, jailNum do
			local Tag = JailsINI:GetKeyName(i)
			jails[Tag] = {}
			jails[Tag]["w"] = JailsINI:GetValue( Tag , "w")
			jails[Tag]["x"] = JailsINI:GetValueI( Tag , "x")
			jails[Tag]["y"] = JailsINI:GetValueI( Tag , "y")
			jails[Tag]["z"] = JailsINI:GetValueI( Tag , "z")
		end
	end

	UsersINI = cIniFile()
	UsersINI:ReadFile("users.ini")

	--Read tpa timeout config--
	local SettingsINI = cIniFile()
	SettingsINI:ReadFile("settings.ini")
	TpRequestTimeLimit = SettingsINI:GetValueSetI("Teleport", "RequestTimeLimit", 0)
	if SettingsINI:GetNumKeyComments("Teleport") == 0 then
		SettingsINI:AddKeyComment("Teleport", "RequestTimeLimit: Time after which tpa/tpahere will timeout, 0 - disabled");
	end
	SettingsINI:WriteFile("settings.ini")
	
	cRoot:Get():ForEachPlayer(CheckPlayer)
	
	--If there's no home folder, plugin will create it
	if cFile:IsFolder(homeDir) ~= true then
		cFile:CreateFolder(homeDir)
	end

	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	return true
	--Finish!
end
