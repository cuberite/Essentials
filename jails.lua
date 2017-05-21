function HandleJailCommand(Split, Player)
	local JailPlayer = function(OtherPlayer)
		if Jailed[OtherPlayer:GetUUID()] then
			Player:SendMessageFailure("Player \"" .. OtherPlayer:GetName() .. "\" is jailed")
		end
		if OtherPlayer:GetWorld():GetName() ~= Jails[Split[3]]["w"] then
			OtherPlayer:MoveToWorld(cRoot:Get():GetWorld(Jails[Split[3]]["w"]), true, Vector3d(Jails[Split[3]]["x"] + 0.5, Jails[Split[3]]["y"], Jails[Split[3]]["z"] + 0.5))
		else
			OtherPlayer:TeleportToCoords(Jails[Split[3]]["x"] + 0.5, Jails[Split[3]]["y"], Jails[Split[3]]["z"] + 0.5)
		end
		UsersINI:SetValue(OtherPlayer:GetUUID(), "Jailed", "true")
		UsersINI:WriteFile("users.ini")
		Jailed[OtherPlayer:GetUUID()] = true
		OtherPlayer:SendMessageInfo("You have been jailed")
	end
	if Split[2] == nil then
		HandleListJailCommand(Split, Player)
	elseif Split[3] == nil then
		Player:SendMessageInfo("Usage: " .. Split[1] .. " <player> <jail>")
	elseif Jails[Split[3]] == nil then
		Player:SendMessageFailure("Jail \"" .. Split[3] .. "\" is invalid")
	else
		if Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], JailPlayer) then
			Player:SendMessageFailure("Player \"" .. Split[2] .. "\" not found")
		end
	end
	return true
end

function HandleUnJailCommand(Split, Player)
	local UnjailPlayer = function(OtherPlayer)
		local World = OtherPlayer:GetWorld()
		OtherPlayer:TeleportToCoords(World:GetSpawnX(), World:GetSpawnY(), World:GetSpawnZ())
		UsersINI:SetValue(OtherPlayer:GetUUID(), "Jailed", "false")
		UsersINI:WriteFile("users.ini")
		Jailed[OtherPlayer:GetUUID()] = false
		OtherPlayer:SendMessageInfo("You have been unjailed")
		Player:SendMessageSuccess("Successfully unjailed player \"" .. OtherPlayer:GetName() .. "\"")
	end
	if Split[2] == nil then
		Player:SendMessageInfo("Usage: " .. Split[1] .. " <player> <jail>")
	else
		if Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], UnjailPlayer) then
			Player:SendMessageFailure("Player \"" .. Split[2] .. "\" not found")
		end
	end
	return true
end

function HandleSetJailCommand(Split, Player)
	local World = Player:GetWorld():GetName()
	local PosX = math.floor(Player:GetPosX())
	local PosY = math.floor(Player:GetPosY())
	local PosZ = math.floor(Player:GetPosZ())
	if Split[2] == nil then
		Player:SendMessageInfo("Usage: " .. Split[1] .. " <name>")
		return true
	end
	if Jails[Split[2]] == nil then 
		Jails[Split[2]] = {}
	end
	if JailsINI:FindKey(Split[2])<0 then
		Jails[Split[2]]["w"] = World
		Jails[Split[2]]["x"] = PosX
		Jails[Split[2]]["y"] = PosY
		Jails[Split[2]]["z"] = PosZ
		JailsINI:AddKeyName(Split[2])
		JailsINI:SetValue(Split[2] , "w" , World)
		JailsINI:SetValue(Split[2] , "x" , PosX)
		JailsINI:SetValue(Split[2] , "y" , PosY)
		JailsINI:SetValue(Split[2] , "z" , PosZ)
		JailsINI:WriteFile("jails.ini")
		Player:SendMessageSuccess("Jail \"" .. Split[2] .. "\" set to world:\"" .. World .. "\", X:" .. PosX .. ", Y:" .. PosY .. ", Z:" .. PosZ)
	else
		Player:SendMessageFailure("Jail \"" .. Split[2] .. "\" already exists")
	end
	return true
end

function HandleDelJailCommand(Split, Player)
	if Split[2] == nil then
		Player:SendMessageInfo("Usage: " .. Split[1] .. " <jail>")
		return true
	end
	Jails[Split[2]] = nil
	if JailsINI:FindKey(Split[2])>-1 then
		JailsINI:DeleteKey(Split[2])
		JailsINI:WriteFile("jails.ini")
	else
		Player:SendMessageFailure("Jail \"" .. Split[2] .. "\" was not found")
		return true
	end
	Player:SendMessageSuccess("Successfully removed jail \"" .. Split[2] .. "\"")
	return true
end

function HandleListJailCommand(Split, Player)
	local JailName = ""
	for k, v in pairs (Jails) do
		JailName = JailName .. k .. ", "
	end
	Player:SendMessageInfo("Jails: " .. cChatColor.LightGreen .. JailName:sub(1, JailName:len() - 2))
	return true
end
