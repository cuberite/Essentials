function HandleHomeCommand(Split, Player)
	local UserId = Database.getUserId(Player:GetName(), Player:GetUUID())

	if not Player:HasPermission("es.home.unlimited") or Split[2] == nil then
		Split[2] = "home"
	end

	local homeData = Database.getRow("Homes", "UserId=?1 AND Name=?2", {UserId, Split[2]})
	if homeData == nil then
		if Split[2] == "home" then
			Player:SendMessageFailure("Home doesn't exist")
		else
			Player:SendMessageFailure("Home " .. Split[2] .. " doesn't exist")
		end
		return true
	end

	Player:TeleportToCoords(homeData[4], homeData[5], homeData[6])
	if Player:GetWorld():GetName() ~= homeData[3] then
		Player:MoveToWorld(homeData[3])
	end
	Player:SendMessageSuccess('Teleporting you to home...')
	return true
end

function HandleSetHomeCommand(Split, Player)
	local UserId = Database.getUserId(Player:GetName(), Player:GetUUID())
	local homeWorld = Player:GetWorld():GetName()
	local homeX = Player:GetPosX()
	local homeY = Player:GetPosY()
	local homeZ = Player:GetPosZ()

	if not Player:HasPermission("es.home.unlimited") or Split[2] == nil then
		Split[2] = "home"
	end

	Database.upsertRow("Homes", "UserId=?1 AND Name=?2", { UserId = "?1", Name = "?2", World = "?3", X = "?4", Y = "?5", Z = "?6"}, { UserId, Split[2], homeWorld, homeX, homeY, homeZ })

	if Split[2] == "home" then
		Player:SendMessageSuccess('Home set! Use /home to go home!')
	else
		Player:SendMessageSuccess("Home set! Use /home " .. Split[2] .. " to go home!")
	end
	return true
end

function HandleDelHomeCommand(Split, Player)
	local UserId = Database.getUserId(Player:GetName(), Player:GetUUID())

	if not Player:HasPermission("es.home.unlimited") or Split[2] == nil then
		Split[2] = "home"
	end

	if not Database.rowExists("Homes", "UserId=?1 AND Name=?2", { UserId, Split[2] }) then
		if Split[2] == "home" then
			Player:SendMessageFailure("Home doesn't exist")
		else
			Player:SendMessageFailure("Home " .. Split[2] .. " doesn't exist")
		end
		return true
	end

	Database.deleteRow("Homes", "UserId=?1 AND Name=?2", { UserId, Split[2] })

	Player:SendMessageSuccess("Home removed")
	return true
end
