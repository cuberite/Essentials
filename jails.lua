function HandleJailCommand( Split, Player )
	if #Split == 1 then
		HandleListJailCommand( Split, Player )
		return true
	end
	if #Split ~= 3 then
		Player:SendMessageInfo('Usage: '..Split[1]..' <player> <jail>')
		return true
	end
	local Tag = Split[3]

	local jailSearchQuery = database:prepare("SELECT * FROM Jails WHERE Name=?")
	jailSearchQuery:bind(1, Tag)
	if jailSearchQuery:step() ~= sqlite3.ROW then
		Player:SendMessageFailure('Jail "' .. Tag .. '" is invalid.')
		return true
	end
	local jailData = jailSearchQuery:get_values()
	jailSearchQuery:finalize()

	local JailFailure = "Player not found"
	local JailPlayer = function(OtherPlayer)
		if (OtherPlayer:GetName() ~= Split[2]) then
			return true
		end

		local UserId = GetUserIdFromUsername(OtherPlayer:GetName(), OtherPlayer:GetUUID())
		if UserId == nil then
			return true
		end

		local OldWorld = OtherPlayer:GetWorld():GetName()
		local OldX = OtherPlayer:GetPosX()
		local OldY = OtherPlayer:GetPosY()
		local OldZ = OtherPlayer:GetPosZ()

		if (OtherPlayer:GetWorld():GetName() ~= jailData[2]) then
			OtherPlayer:TeleportToCoords( jailData[3] + 0.5 , jailData[4] , jailData[5] + 0.5)
			OtherPlayer:MoveToWorld(jailData[2])
		end
		OtherPlayer:TeleportToCoords( jailData[3] + 0.5 , jailData[4] , jailData[5] + 0.5)
		local addPrisoner = database:prepare("INSERT OR IGNORE INTO Prisoners (UserId, JailName, ExpiryTicks, OldWorld, OldX, OldY, OldZ) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7)")
		addPrisoner:bind_values(UserId, jailData[1], -1, OldWorld, OldX, OldY, OldZ)
		addPrisoner:step()
		addPrisoner:finalize()
		
		local updatePrisoner = database:prepare("UPDATE Prisoners SET (JailName=?2,ExpiryTicks=?3) WHERE UserId=?1");
		addPrisoner:bind_values(UserId, jailData[1], -1, OldWorld, OldX, OldY, OldZ)
    addPrisoner:step()
    addPrisoner:finalize()

		OtherPlayer:SendMessageWarning('You have been jailed')
		JailFailure = nil
		return true
	end
	cRoot:Get():FindAndDoWithPlayer(Split[2], JailPlayer);
	if (JailFailure ~= nil) then
		Player:SendMessageFailure(JailFailure)
		return true
	end

	Player:SendMessageSuccess("Player "..Split[2].." is jailed")
	return true
end

function HandleUnJailCommand( Split, Player )
	if #Split ~= 2 then
		Player:SendMessageInfo('Usage: '..Split[1]..' <player>')
		return true
	end

	local JailFailure = "Player not found"
	local JailPlayer = function(OtherPlayer)
		if (OtherPlayer:GetName() ~= Split[2]) then
			return true
		end

		local UserId = GetUserIdFromUsername(OtherPlayer:GetName(), OtherPlayer:GetUUID())
		if UserId == nil then
			return true
		end

		local prisonerSearchQuery = database:prepare("SELECT * FROM Prisoners WHERE UserId=?")
		prisonerSearchQuery:bind(1, UserId)
		if prisonerSearchQuery:step() ~= sqlite3.ROW then
			JailFailure = OtherPlayer:GetName() .. ' is not in jail.'
			return true
		end
		local prisonerData = prisonerSearchQuery:get_values()
		prisonerSearchQuery:finalize()

		local prisonerDelete = database:prepare("DELETE FROM Prisoners WHERE UserId=?")
		prisonerDelete:bind(1, UserId)
		prisonerDelete:step()
		prisonerDelete:finalize()

		if (OtherPlayer:GetWorld():GetName() ~= prisonerData[4]) then
			OtherPlayer:MoveToWorld(prisonerData[4])
		end

		OtherPlayer:TeleportToCoords(prisonerData[5], prisonerData[6], prisonerData[7])
		OtherPlayer:SendMessageSuccess('You have been unjailed')
		JailFailure = nil
	end
	cRoot:Get():FindAndDoWithPlayer(Split[2], JailPlayer);
	if (JailFailure ~= nil) then
		Player:SendMessageFailure(JailFailure)
		return true
	end

	Player:SendMessageSuccess("You unjailed "..Split[2])
	return true
end

function HandleSetJailCommand( Split, Player)
	local Server = cRoot:Get():GetServer()
	local World = Player:GetWorld():GetName()
	local pX = Player:GetPosX()
	local pY = Player:GetPosY()
	local pZ = Player:GetPosZ()

	if #Split ~= 2 then
		Player:SendMessageInfo('Usage: '..Split[1]..' <jailname>')
		return true
	end
	local Tag = Split[2]

	local searchQuery = database:prepare("SELECT * FROM Jails WHERE Name=?")
	searchQuery:bind(1, Split[2])

	if searchQuery:step() == sqlite3.ROW then
		Player:SendMessageFailure('Jail "' .. Tag .. '" already exists')
		return true
	end
	searchQuery:finalize()

	local insertQuery = database:prepare("INSERT INTO Jails (Name, World, X, Y, Z) VALUES (?1, ?2, ?3, ?4, ?5)")
	insertQuery:bind_values(Tag, World, pX, pY, pZ)
	insertQuery:step()
	insertQuery:finalize()

	Player:SendMessageSuccess("Jail \"" .. Tag .. "\" set to World:'" .. World .. "' x:'" .. pX .. "' y:'" .. pY .. "' z:'" .. pZ .. "'")
	return true
end

function HandleDelJailCommand( Split, Player)
	local Server = cRoot:Get():GetServer()

	if #Split < 2 then
		Player:SendMessageInfo('Usage: '..Split[1]..' <jail>')
		return true
	end
	local Tag = Split[2]

	local searchQuery = database:prepare("SELECT * FROM Jails WHERE Name=?")
	searchQuery:bind(1, Split[2])
	if searchQuery:step() ~= sqlite3.ROW then
		Player:SendMessageFailure("Jail \"" .. Tag .. "\" was not found.")
		return true
	end
	searchQuery:finalize()

	local deleteQuery = database:prepare("DELETE FROM Jails WHERE Name=?")
	deleteQuery:bind(1, Split[2])
	deleteQuery:step()
	deleteQuery:finalize()

	Player:SendMessageSuccess("Jail \"" .. Tag .. "\" was removed.")
	return true
end

function HandleListJailCommand( Split, Player)
	local jailStr = ""
	function Callback(udata, cols, values, names)
		jailStr = jailStr .. values[1] .. ", "
		return 0
	end
	database:exec("SELECT Name FROM Jails", Callback)
	Player:SendMessageInfo('Jail(s): ' ..  cChatColor.LightGreen ..  string.sub(jailStr, 1, -3))
	return true
end
