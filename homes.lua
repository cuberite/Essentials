function HandleHomeCommand(Split, Player)
	local UserId = GetUserIdFromUsername(Player:GetName(), Player:GetUUID())

	if not Player:HasPermission("es.home.unlimited") or Split[2] == nil then
		Split[2] = "home"
	end

	local homeSearch = database:prepare("SELECT * FROM Homes WHERE UserId=?1 AND Name=?2")
	homeSearch:bind_values(UserId, Split[2])
	if homeSearch:step() ~= sqlite3.ROW then
		if Split[2] == "home" then
			Player:SendMessageFailure("Home doesn't exist")
		else
			Player:SendMessageFailure("Home " .. Split[2] .. " doesn't exist")
		end
		return true
	end
	local homeData = homeSearch:get_values()
	homeSearch:finalize()

	Player:TeleportToCoords(homeData[4], homeData[5], homeData[6])
	if Player:GetWorld():GetName() ~= homeData[3] then
		Player:MoveToWorld(homeData[3])
	end
	Player:SendMessageSuccess('Teleporting you to home...')
	return true
end

function HandleSetHomeCommand(Split, Player)
	local UserId = GetUserIdFromUsername(Player:GetName(), Player:GetUUID())
	local homeWorld = Player:GetWorld():GetName()
	local homeX = Player:GetPosX()
	local homeY = Player:GetPosY()
	local homeZ = Player:GetPosZ()

	if not Player:HasPermission("es.home.unlimited") or Split[2] == nil then
		Split[2] = "home"
	end

	local homeExists = true
	local homeSearch = database:prepare("SELECT * FROM Homes WHERE UserId=?1 AND Name=?2")
	homeSearch:bind_values(UserId, Split[2])
	if homeSearch:step() ~= sqlite3.ROW then
		homeExists = false
	end
	homeSearch:finalize()

	if homeExists then
		local updateHome = database:prepare("UPDATE Homes SET World=?3, X=?4, Y=?5, Z=?6 WHERE UserId=?1 AND Name=?2")
		updateHome:bind_values(UserId, Split[2], homeWorld, homeX, homeY, homeZ)
		updateHome:step()
		updateHome:finalize()
	else
		local addHome = database:prepare("INSERT INTO Homes (UserId, Name, World, X, Y, Z) VALUES (?1, ?2, ?3, ?4, ?5, ?6)")
		addHome:bind_values(UserId, Split[2], homeWorld, homeX, homeY, homeZ)
		addHome:step()
		addHome:finalize()
	end

	Player:SendMessageSuccess('Home set! Use /home to go home!')
	return true
end

function HandleDelHomeCommand(Split, Player)
	local UserId = GetUserIdFromUsername(Player:GetName(), Player:GetUUID())

	if not Player:HasPermission("es.home.unlimited") or Split[2] == nil then
		Split[2] = "home"
	end

	local homeSearch = database:prepare("SELECT * FROM Homes WHERE UserId=?1 AND Name=?2")
	homeSearch:bind_values(UserId, Split[2])
	if homeSearch:step() ~= sqlite3.ROW then
		if Split[2] == "home" then
			Player:SendMessageFailure("Home doesn't exist")
		else
			Player:SendMessageFailure("Home " .. Split[2] .. " doesn't exist")
		end
		return true
	end
	homeSearch:finalize()

	local deleteHome = database:prepare("DELETE FROM Homes WHERE UserId=?1 AND Name=?2")
	deleteHome:bind_values(UserId, Split[2])
	deleteHome:step()
	deleteHome:finalize()

	Player:SendMessageSuccess("Home removed")
	return true
end
