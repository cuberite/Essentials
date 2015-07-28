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

	local jailData = Database.getRow("Jails", "Name=?1", { Tag })
	if jailData == nil then
		Player:SendMessageFailure('Jail "' .. Tag .. '" is invalid.')
		return true
	end

	local JailFailure = "Player not found"
	local JailPlayer = function(OtherPlayer)
		if (OtherPlayer:GetName() ~= Split[2]) then
			return true
		end

		local UserId = Database.getUserId(OtherPlayer:GetName(), OtherPlayer:GetUUID())
		if UserId == nil then
			return true
		end

		local OldWorld, OldX, OldY, OldZ;
		local prisonerData = Database.getRow("Prisoners", "UserId=?1", { UserId })
		if oldPrisonerData ~= nil then
			OldWorld = oldPrisonerData[4]
			OldX = prisonerData[5]
			OldY = prisonerData[6]
			OldZ = prisonerData[7]
		else
			OldWorld = OtherPlayer:GetWorld():GetName()
			OldX = OtherPlayer:GetPosX()
			OldY = OtherPlayer:GetPosY()
			OldZ = OtherPlayer:GetPosZ()
		end

		if (OtherPlayer:GetWorld():GetName() ~= jailData[2]) then
			OtherPlayer:TeleportToCoords( jailData[3] + 0.5 , jailData[4] , jailData[5] + 0.5)
			OtherPlayer:MoveToWorld(jailData[2])
		end
		OtherPlayer:TeleportToCoords( jailData[3] + 0.5 , jailData[4] , jailData[5] + 0.5)

		Database.upsertRow("Prisoners", "UserId=?1", { UserId = "?1", JailName = "?2", ExpiryTicks = "?3", OldWorld = "?4", OldX = "?5", OldY = "?6", OldZ = "?7" }, { UserId, jailData[1], -1, OldWorld, OldX, OldY, OldZ })

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

		local UserId = Database.getUserId(OtherPlayer:GetName(), OtherPlayer:GetUUID())
		if UserId == nil then
			return true
		end

		local prisonerData = Database.getRow("Prisoners", "UserId=?1", { UserId })
		if prisonerData == nil then
			JailFailure = OtherPlayer:GetName() .. ' is not in jail.'
			return true
		end

		Database.prisonerDelete("Prisoners", "UserId=?1", { UserId })

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

	if Database.rowExists("Jails", "Name=?1", { Split[2] }) then
		Player:SendMessageFailure('Jail "' .. Tag .. '" already exists')
		return true
	end

	Database.insertRow("Jails", { Name = "?1", World = "?2", X = "?3", Y = "?4", Z = "?5" }, { Tag, World, pX, pY, pZ })

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

	if not Database.rowExists("Jails", "Name=?1", { Split[2] }) then
		Player:SendMessageFailure("Jail \"" .. Tag .. "\" was not found.")
		return true
	end

	Database.deleteRow("Jails", "Name=?1", { Split[2] })

	Player:SendMessageSuccess("Jail \"" .. Tag .. "\" was removed.")
	return true
end

function HandleListJailCommand( Split, Player)
	local jailStr = ""
	local rows = Database.getRows("Jails", "1", {})
	for i=1, #rows do
		jailStr = jailStr .. rows[i][1] .. ", "
	end

	Player:SendMessageInfo('Jail(s): ' ..  cChatColor.LightGreen ..  string.sub(jailStr, 1, -3))
	return true
end
