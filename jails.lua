function HandleJailCommand( Split, Player )
	if #Split < 2 and #Split < 3 then
		HandleListJailCommand( Split, Player )
		return true
	end
	if #Split < 2 or #Split < 3  then
		Player:SendMessageInfo('Usage: '..Split[1]..' <player> <jail>')
		return true
	end
	local Tag = Split[3]

	local IsJailed = false
	local JailPlayer = function(OtherPlayer)
		if (OtherPlayer:GetName() == Split[2]) then
			if (OtherPlayer:GetWorld():GetName() ~= jails[Tag]["w"]) then
				OtherPlayer:TeleportToCoords( jails[Tag]["x"] + 0.5 , jails[Tag]["y"] , jails[Tag]["z"] + 0.5)
				OtherPlayer:MoveToWorld(jails[Tag]["w"])
				IsJailed = true
			end
			OtherPlayer:TeleportToCoords( jails[Tag]["x"] + 0.5 , jails[Tag]["y"] , jails[Tag]["z"] + 0.5)
			OtherPlayer:SendMessageWarning('You have been jailed')
			UsersINI:SetValue(OtherPlayer:GetUUID(),   "Jailed",   "true")
			UsersINI:WriteFile("users.ini")
			Jailed[OtherPlayer:GetName()] = true
			IsJailed = true
		return true
		end
	end
	cRoot:Get():FindAndDoWithPlayer(Split[2], JailPlayer);
	if (IsJailed) then
		Player:SendMessageSuccess("Player "..Split[2].." is jailed")
		return true
	else
		Player:SendMessageFailure("Player not found")
		if jails[Tag] == nil then 
			Player:SendMessageFailure('Jail "' .. Tag .. '" is invalid.')
			return true
		end
	end
end

function HandleUnJailCommand( Split, Player )
	if #Split < 2 then
		Player:SendMessageInfo('Usage: '..Split[1]..' <player> <jail>')
		return true
	end

	local UnJailed = false
	local JailPlayer = function(OtherPlayer)
		if (OtherPlayer:GetName() == Split[2]) then
			World = OtherPlayer:GetWorld()
			OtherPlayer:TeleportToCoords( World:GetSpawnX(), World:GetSpawnY(), World:GetSpawnZ())
			OtherPlayer:SendMessageSuccess('You have been unjailed')
			UsersINI:SetValue(OtherPlayer:GetUUID(),   "Jailed",   "false")
			UsersINI:WriteFile("users.ini")
			Jailed[OtherPlayer:GetName()] = false
			UnJailed = true
			return true
		end
	end
	cRoot:Get():FindAndDoWithPlayer(Split[2], JailPlayer);
	if (UnJailed) then
		Player:SendMessageSuccess("You unjailed "..Split[2])
		return true
	else
		Player:SendMessageFailure("Player not found")
		return true
	end
end

function HandleSetJailCommand( Split, Player)
	local Server = cRoot:Get():GetServer()
	local World = Player:GetWorld():GetName()
	local pX = math.floor(Player:GetPosX())
	local pY = math.floor(Player:GetPosY())
	local pZ = math.floor(Player:GetPosZ())

	if #Split < 2 then
		Player:SendMessageInfo('Usage: '..Split[1]..' <jailname>')
		return true
	end
	local Tag = Split[2]

	if jails[Tag] == nil then 
		jails[Tag] = {}
	end

	if (JailsINI:FindKey(Tag)<0) then
		jails[Tag]["w"] = World
		jails[Tag]["x"] = pX
		jails[Tag]["y"] = pY
		jails[Tag]["z"] = pZ
	end

	if (JailsINI:FindKey(Tag)<0) then
		JailsINI:AddKeyName(Tag);
		JailsINI:SetValue( Tag , "w" , World)
		JailsINI:SetValue( Tag , "x" , pX)
		JailsINI:SetValue( Tag , "y" , pY)
		JailsINI:SetValue( Tag , "z" , pZ)
		JailsINI:WriteFile("jails.ini");

		Player:SendMessageSuccess("Jail \"" .. Tag .. "\" set to World:'" .. World .. "' x:'" .. pX .. "' y:'" .. pY .. "' z:'" .. pZ .. "'")
		return true
	else
		Player:SendMessageFailure('Jail "' .. Tag .. '" already exist')
		return true
	end
	return true
end

function HandleDelJailCommand( Split, Player)
	local Server = cRoot:Get():GetServer()

	if #Split < 2 then
		Player:SendMessageInfo('Usage: '..Split[1]..' <jail>')
		return true
	end
	local Tag = Split[2]
	jails[Tag] = nil

	if (JailsINI:FindKey(Tag)>-1) then
		JailsINI:DeleteKey(Tag);
		JailsINI:WriteFile("jails.ini");
	else
		Player:SendMessageFailure("Jail \"" .. Tag .. "\" was not found.")
		return true
	end

	Player:SendMessageSuccess("Jail \"" .. Tag .. "\" was removed.")
	return true
end

function HandleListJailCommand( Split, Player)
	local jailStr = ""
	local inc = 0
	for k, v in pairs (jails) do
		inc = inc + 1
		jailStr = jailStr .. k .. ", "
	end
	Player:SendMessageInfo('Jail: ' ..  cChatColor.LightGreen ..  jailStr)
	return true
end
