--Global variables
lastsender = {}
ticks = {}
timer = {}
BackCoords = {}
TpRequestTimeLimit = 0
TpsCache = {}
GlobalTps = {}
Muted = {}
db = {}

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

	--Set dirs which will be used later on
	localdir = Plugin:GetLocalFolder()

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

	--Open database and initialize tables if necessary
	Database.open("essentials.sqlite3")
	local status;
	--Enable foreign key support for the database
	Database.pragma("foreign_keys", "ON")
	Database.initializeTable("Main", [[
		UserId INTEGER PRIMARY KEY AUTOINCREMENT,
		UUID VARCHAR(36),
		Username VARCHAR(16)
	]])
	Database.initializeTable("Jails", [[
		Name VARCHAR(255) UNIQUE NOT NULL,
		World VARCHAR(255) NOT NULL,
		X SINGLE NOT NULL,
		Y SINGLE NOT NULL,
		Z SINGLE NOT NULL
	]])
	Database.initializeTable("Prisoners", [[
		UserId INT UNIQUE,
		JailName VARCHAR(255),
		ExpiryTicks INT NOT NULL,
		OldWorld VARCHAR(255) NOT NULL,
		OldX SINGLE NOT NULL,
		OldY SINGLE NOT NULL,
		OldZ SINGLE NOT NULL,
		FOREIGN KEY(UserId) REFERENCES Main(UserId),
		FOREIGN KEY(JailName) REFERENCES Jails(Name)
	]])
	Database.initializeTable("Warps", [[
		Name VARCHAR(255) UNIQUE NOT NULL,
		World VARCHAR(255) NOT NULL,
		X SINGLE NOT NULL,
		Y SINGLE NOT NULL,
		Z SINGLE NOT NULL
	]])
	Database.initializeTable("Homes", [[
		UserId INT,
		Name VARCHAR(255) NOT NULL,
		World VARCHAR(255) NOT NULL,
		X SINGLE NOT NULL,
		Y SINGLE NOT NULL,
		Z SINGLE NOT NULL,
		FOREIGN KEY(UserId) REFERENCES Main(UserId)
	]])

	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	return true
	--Finish!
end

function OnDisable()
	Database:close()
	LOG("Disabled Essentials!")
end