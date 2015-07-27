--Global variables
lastsender = {}
ticks = {}
timer = {}
BackCoords = {}
TpRequestTimeLimit = 0
TpsCache = {}
GlobalTps = {}
Muted = {}
database = {}

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
	database = sqlite3.open("essentials.sqlite3")
	local checkTable = database:prepare("SELECT name FROM sqlite_master WHERE type='table' AND name=?")
	if checkTable == nil then
		--This error could be caused by insufficient write permissions
		--Or a corrupted database
		error("Could not initialize database")
  end
	local status;
	--Enable foreign key support for the database
	status = database:exec("PRAGMA foreign_keys = ON")
	if status ~= sqlite3.OK then
		error("Could not configure foreign keys")
	end
	status = database:exec([[CREATE TABLE IF NOT EXISTS Main(
		UserId INTEGER PRIMARY KEY AUTOINCREMENT,
		UUID VARCHAR(36),
		Username VARCHAR(16)
	)]])
	checkTable:bind(1, "Main")
	if (status ~= sqlite3.OK) or (checkTable:step() ~= sqlite3.ROW) then
		error("Could not initialize table Main")
	end
	database:exec([[CREATE TABLE IF NOT EXISTS Jails(
		Name VARCHAR(255) UNIQUE NOT NULL,
		World VARCHAR(255) NOT NULL,
		X SINGLE NOT NULL,
		Y SINGLE NOT NULL,
		Z SINGLE NOT NULL
	)]])
	checkTable:reset()
	checkTable:bind(1, "Jails")
	if (status ~= sqlite3.OK) or (checkTable:step() ~= sqlite3.ROW) then
		error("Could not initialize table Jails")
	end
	database:exec([[CREATE TABLE IF NOT EXISTS Prisoners(
		UserId INT UNIQUE,
		JailName VARCHAR(255),
		ExpiryTicks INT NOT NULL,
		OldWorld VARCHAR(255) NOT NULL,
		OldX SINGLE NOT NULL,
		OldY SINGLE NOT NULL,
		OldZ SINGLE NOT NULL,
		FOREIGN KEY(UserId) REFERENCES Main(UserId),
		FOREIGN KEY(JailName) REFERENCES Jails(Name)
	)]])
	checkTable:reset()
	checkTable:bind(1, "Prisoners")
	if (status ~= sqlite3.OK) or (checkTable:step() ~= sqlite3.ROW) then
		error("Could not initialize table Prisoners")
	end
	database:exec([[CREATE TABLE IF NOT EXISTS Warps(
		Name VARCHAR(255) UNIQUE NOT NULL,
		World VARCHAR(255) NOT NULL,
		X SINGLE NOT NULL,
		Y SINGLE NOT NULL,
		Z SINGLE NOT NULL
	)]])
	checkTable:reset()
	checkTable:bind(1, "Warps")
	if (status ~= sqlite3.OK) or (checkTable:step() ~= sqlite3.ROW) then
		error("Could not initialize table Warps")
	end
	database:exec([[CREATE TABLE IF NOT EXISTS Homes(
		UserId INT,
		Name VARCHAR(255) NOT NULL,
		World VARCHAR(255) NOT NULL,
		X SINGLE NOT NULL,
		Y SINGLE NOT NULL,
		Z SINGLE NOT NULL,
		FOREIGN KEY(UserId) REFERENCES Main(UserId)
	)]])
	checkTable:reset()
	checkTable:bind(1, "Homes")
	if (status ~= sqlite3.OK) or (checkTable:step() ~= sqlite3.ROW) then
		error("Could not initialize table Homes")
	end
	checkTable:finalize()

	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	return true
	--Finish!
end

function OnDisable()
	database:close()
	LOG("Disabled Essentials!")
end

function GetUserIdFromUsername(Username, UUID)
	if UUID == nil or string.len(UUID) == 0 then
		UUID = nil
	end

	local userIdQuery = database:prepare("SELECT UserId FROM Main WHERE Username=?")
	userIdQuery:bind(1, Username)
	if userIdQuery:step() ~= sqlite3.ROW then
		local insertQuery = database:prepare("INSERT INTO Main (Username, UUID) VALUES (?1, ?2)")
		insertQuery:bind_values(Username, UUID)
		local insertStatus = insertQuery:step()
		if insertStatus ~= sqlite3.DONE then
			insertQuery:finalize()
			return nil
		end
		insertQuery:finalize()
		return GetUserIdFromUsername(Username)
	end
	local userId = userIdQuery:get_value(0)
	userIdQuery:finalize()
	return userId
end