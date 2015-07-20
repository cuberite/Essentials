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
	cPluginManager:AddHook(cPluginManager.HOOK_KILLED, OnKilled);

	RegisterPluginInfoCommands();
	
	RegisterPluginInfoConsoleCommands();

	--Read the warps (stored in ini file)
	INI = cIniFile()
	if (INI:ReadFile("warps.ini")) then
		warpNum = INI:GetNumKeys();
		for i=0, warpNum do
			local Tag = INI:GetKeyName(i)
			warps[Tag] = {}
			warps[Tag]["w"] = INI:GetValue( Tag , "w")
			warps[Tag]["x"] = INI:GetValueI( Tag , "x")
			warps[Tag]["y"] = INI:GetValueI( Tag , "y")
			warps[Tag]["z"] = INI:GetValueI( Tag , "z")
		end
	end

	--Set dirs which will be used later on
	localdir = Plugin:GetLocalFolder()
	homeDir = Plugin:GetLocalFolder().."/homes"

	--Read jails (from ini file)
	if (INI:ReadFile("jails.ini")) then
		jailNum = INI:GetNumKeys();
		for i=0, jailNum do
			local Tag = INI:GetKeyName(i)
			jails[Tag] = {}
			jails[Tag]["w"] = INI:GetValue( Tag , "w")
			jails[Tag]["x"] = INI:GetValueI( Tag , "x")
			jails[Tag]["y"] = INI:GetValueI( Tag , "y")
			jails[Tag]["z"] = INI:GetValueI( Tag , "z")
		end
	end

	INI:ReadFile("users.ini")

	--Read tpa timeout config--
	INI:ReadFile("settings.ini")
	TpRequestTimeLimit = INI:GetValueSetI("Teleport", "RequestTimeLimit", 0)
	if INI:GetNumKeyComments("Teleport") == 0 then
		INI:AddKeyComment("Teleport", "RequestTimeLimit: Time after which tpa/tpahere will timeout, 0 - disabled");
	end
	INI:WriteFile("settings.ini")

	--If there's no home folder, plugin will create it
	if cFile:IsFolder(homeDir) ~= true then
		cFile:CreateFolder(homeDir)
	end

	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	return true
	--Finish!
end
