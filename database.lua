Database = {}
local db = {}

Database.error = function(errorMessage)
	if db ~= nil then
		if db:errcode() ~= sqlite3.OK then
			LOG("Database error code: " .. db:errcode())
			LOG("Database error message: " .. db:errmsg())
		end
		Database.close()
	end
	error(errorMessage)
end

Database.open = function(path)
	db = sqlite3.open("essentials.sqlite3")
	if (db == nil) or (not db:isopen()) then
		--This error could be caused by insufficient write permissions
		--Or a corrupted database
		checkTable.finalize()
		Database.error("Could not initialize database")
	end
end

Database.close = function()
	db:close()
end

Database.pragma = function(name, value)
	if db:exec("PRAGMA " .. name .. " = " .. value) ~= sqlite3.OK then
		Database.error("Could not load settings")
	end
end

Database.initializeTable = function(name, columns)
	local status = db:exec("CREATE TABLE IF NOT EXISTS " .. name .. "(" .. columns .. ")")

	local checkTable = db:prepare("SELECT name FROM sqlite_master WHERE type='table' AND name=?")
	checkTable:bind(1, name)

	if (status ~= sqlite3.OK) or (checkTable:step() ~= sqlite3.ROW) then
		Database.error("Could not initialize table " .. name)
	end
end

Database.getUserId = function(Username, UUID)
	local userIdQuery
	if (UUID == nil) or (string.len(UUID) == 0) then
		UUID = nil
		userIdQuery = db:prepare("SELECT UserId FROM Main WHERE Username=?")
		userIdQuery:bind(1, Username)
	else
		userIdQuery = db:prepare("SELECT UserId FROM Main WHERE UUID=?")
		userIdQuery:bind(1, UUID)
	end

	if userIdQuery:step() ~= sqlite3.ROW then
		local insertQuery = db:prepare("INSERT INTO Main (Username, UUID) VALUES (?1, ?2)")
		insertQuery:bind_values(Username, UUID)
		local insertStatus = insertQuery:step()
		insertQuery:finalize()
		if insertStatus ~= sqlite3.DONE then
			userIdQuery:finalize()
			return nil
		end
		userIdQuery:finalize()
		return Database.getUserId(Username, UUID)
	end
	local userId = userIdQuery:get_value(0)
	userIdQuery:finalize()
	return userId
end

Database.getRow = function(table, condition, parameters)
	local rowSearch = db:prepare("SELECT * FROM " .. table .. " WHERE " .. condition)
	for i=1, math.min(#parameters, rowSearch:bind_parameter_count()) do
		rowSearch:bind(i, parameters[i])
	end
	if rowSearch:step() == sqlite3.ROW then
		local row = rowSearch:get_values()
		rowSearch:finalize()
		return row
	else
		rowSearch:finalize()
		return nil
	end
end

Database.getRows = function(table, condition, parameters)
	local rows = {}
	local rowSearch = db:prepare("SELECT * FROM " .. table .. " WHERE " .. condition)
	for i=1, math.min(#parameters, rowSearch:bind_parameter_count()) do
		rowSearch:bind(i, parameters[i])
	end

	local i=1
	while rowSearch:step() == sqlite3.ROW do
		rows[i] = rowSearch:get_values()
		i = i + 1
	end
	rowSearch:finalize()

	return rows
end

Database.rowExists = function(table, condition, parameters)
	return Database.getRow(table, condition, parameters) ~= nil
end

Database.insertRow = function(table, keyValuePairs, parameters)
	local columns = ""
	local values = ""
	for k, v in pairs(keyValuePairs) do
		columns = columns .. k .. ", "
		values = values .. v .. ", "
	end
	columns = string.sub(columns, 1, -3)
	values = string.sub(values, 1, -3)

	local stmt = db:prepare("INSERT INTO " .. table .. " (" .. columns .. ") VALUES (" .. values .. ")")
	for i=1, math.min(#parameters, stmt:bind_parameter_count()) do
		stmt:bind(i, parameters[i])
	end
	if stmt:step() ~= sqlite3.DONE then
		stmt:finalize()
		Database.error("Error attempting to insert a database row")
	end
	stmt:finalize()
end

Database.updateRow = function(table, condition, keyValuePairs, parameters)
	local set = ""
	for k, v in pairs(keyValuePairs) do
		set = set .. k .. "=" .. v .. ", "
	end
	set = string.sub(set, 1, -3)

	local stmt = db:prepare("UPDATE " .. table .. " SET " .. set .. " WHERE " .. condition)
	for i=1, math.min(#parameters, stmt:bind_parameter_count()) do
		stmt:bind(i, parameters[i])
	end
	if stmt:step() ~= sqlite3.DONE then
		stmt:finalize()
		Database.error("Error attempting to update database value(s)")
	end
	stmt:finalize()
end

Database.upsertRow = function(table, condition, keyValuePairs, parameters)
	if Database.rowExists(table, condition, parameters) then
		Database.updateRow(table, condition, keyValuePairs, parameters)
	else
		Database.insertRow(table, keyValuePairs, parameters)
	end
end

Database.deleteRow = function(table, condition, parameters)
	local stmt = db:prepare("DELETE FROM " .. table .. " WHERE " .. condition)
	for i=1, math.min(#parameters, stmt:bind_parameter_count()) do
		stmt:bind(i, parameters[i])
	end
	if stmt:step() ~= sqlite3.DONE then
		stmt:finalize()
		Database.error("Error attempting to remove a database row")
	end
	stmt:finalize()
end
