--Global variables
PortalTimer = {}
Warps = {}
Jails = {}
BackCoords = {}
BackWorld = {}
TpRequestTimeLimit = 0
TeleportRequests = {}
Jailed = {}
Muted = {}
SocialSpyList = {}
GodModeList = {}

--Initialize the plugin
function Initialize(Plugin)
	Plugin:SetName(g_PluginInfo.Name)
	Plugin:SetVersion(g_PluginInfo.Version)

	--Register hooks
	cPluginManager:AddHook(cPluginManager.HOOK_TAKE_DAMAGE, OnTakeDamage)
	cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_RIGHT_CLICK, OnPlayerRightClick)
	cPluginManager.AddHook(cPluginManager.HOOK_UPDATING_SIGN, OnUpdatingSign)
	cPluginManager:AddHook(cPluginManager.HOOK_CHAT, OnChat)
	cPluginManager:AddHook(cPluginManager.HOOK_EXECUTE_COMMAND, OnExecuteCommand)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_BREAKING_BLOCK, OnPlayerBreakingBlock)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_PLACING_BLOCK, OnPlayerPlacingBlock)
	cPluginManager:AddHook(cPluginManager.HOOK_WORLD_TICK, OnWorldTick)
	cPluginManager:AddHook(cPluginManager.HOOK_ENTITY_TELEPORT, OnEntityTeleport)
	cPluginManager:AddHook(cPluginManager.HOOK_KILLED, OnKilled)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED, OnPlayerJoined)
	cPluginManager:AddHook(cPluginManager.HOOK_ENTITY_CHANGING_WORLD, OnEntityChangingWorld)

	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")
	RegisterPluginInfoCommands()
	RegisterPluginInfoConsoleCommands()

	--Set folders which will be used later on
	HomesFolder = Plugin:GetLocalFolder().."/homes"

	--If there's no home folder, the plugin will create it
	if not cFile:IsFolder(HomesFolder) then
		cFile:CreateFolder(HomesFolder)
	end

	--Read warps from the warps.ini file
	WarpsINI = cIniFile()
	if WarpsINI:ReadFile("warps.ini") then
		local WarpNum = WarpsINI:GetNumKeys() - 1
		for i=0, WarpNum do
			local Tag = WarpsINI:GetKeyName(i)
			Warps[Tag] = {}
			Warps[Tag]["w"] = WarpsINI:GetValue(Tag , "w")
			Warps[Tag]["x"] = WarpsINI:GetValueI(Tag , "x")
			Warps[Tag]["y"] = WarpsINI:GetValueI(Tag , "y")
			Warps[Tag]["z"] = WarpsINI:GetValueI(Tag , "z")
		end
	end

	--Read jails from the jails.ini file
	JailsINI = cIniFile()
	if JailsINI:ReadFile("jails.ini") then
		local JailNum = JailsINI:GetNumKeys() - 1
		for i=0, JailNum do
			local Tag = JailsINI:GetKeyName(i)
			Jails[Tag] = {}
			Jails[Tag]["w"] = JailsINI:GetValue(Tag , "w")
			Jails[Tag]["x"] = JailsINI:GetValueI(Tag , "x")
			Jails[Tag]["y"] = JailsINI:GetValueI(Tag , "y")
			Jails[Tag]["z"] = JailsINI:GetValueI(Tag , "z")
		end
	end

	UsersINI = cIniFile()
	UsersINI:ReadFile("users.ini")

	--Read tpa timeout config
	local SettingsINI = cIniFile()
	SettingsINI:ReadFile("settings.ini")
	TpRequestTimeLimit = SettingsINI:GetValueSetI("Teleport", "RequestTimeLimit", 0)
	if SettingsINI:GetNumKeyComments("Teleport") == 0 then
		SettingsINI:AddKeyComment("Teleport", "RequestTimeLimit: Time in seconds after which tpa/tpahere will timeout, 0 - disabled")
	end
	SettingsINI:WriteFile("settings.ini")

	cRoot:Get():ForEachPlayer(CheckPlayer)

	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	return true
end

function OnDisable()
	LOG("Disabled " .. cPluginManager:GetCurrentPlugin():GetName() .. "!")
end
