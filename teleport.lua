function HandlePlaceCommand(Split, Player)
	local Teleport = function(OtherPlayer)
		local LookPos = GetPlayerLookPos(Player)
		if LookPos == nil then
			Player:SendMessageFailure("You're not looking at a block, or it's too far away")
		else
			--Teleport the player
			OtherPlayer:TeleportToCoords(LookPos.x, LookPos.y + 1, LookPos.z)
			Player:SendMessageSuccess("Successfully teleported player \"" .. OtherPlayer:GetName() .. "\" where you are looking")
		end
	end
	if Split[2] == nil then
		Player:SendMessageInfo("Usage: " .. Split[1] .. " <player>")
	else
		if Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], Teleport) then
			Player:SendMessageFailure("Player \"" .. Split[2] .. "\" not found")
		end
	end
	return true
end

function HandleTPHereCommand(Split, Player)
	local Teleport = function(OtherPlayer)
		local OrigWorld = OtherPlayer:GetWorld():GetName()
		local DestWorld = Player:GetWorld():GetName()
		if OrigWorld ~= DestWorld then
			OtherPlayer:MoveToWorld(DestWorld)
		end
		OtherPlayer:TeleportToEntity(Player)
		Player:SendMessageSuccess("Player \"" .. OtherPlayer:GetName() .. "\" teleported to you")
		OtherPlayer:SendMessageSuccess("You teleported to player \"" .. Player:GetName() .. "\"")
	end
	if Split[2] == nil then
		Player:SendMessageInfo("Usage: " .. Split[1] .. " <player>")
	else
		if Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], Teleport) then
			Player:SendMessageFailure("Player \"" .. Split[2] .. "\" not found")
		end
	end
	return true
end

function HandleTPACommand(Split, Player)
	local Teleport = function(OtherPlayer)
		if Split[1] == "/tpa" then
			OtherPlayer:SendMessageInfo("Player \"" .. Player:GetName() .. cChatColor.Plain .. "\" has requested to teleport to you")
		else
			OtherPlayer:SendMessageInfo("Player \"" .. Player:GetName() .. cChatColor.Plain .. "\" has requested you to teleport to them")
		end
		if TpRequestTimeLimit > 0 then
			OtherPlayer:SendMessageInfo("This request will timeout after " .. TpRequestTimeLimit .. " seconds")
		end
		OtherPlayer:SendMessageInfo("To teleport, type " .. cChatColor.LightGreen .. "/tpaccept")
		OtherPlayer:SendMessageInfo("To deny this request, type " .. cChatColor.Rose .. "/tpdeny")
		TeleportRequests[OtherPlayer:GetUUID()] = {Type = Split[1], Requester = Player:GetName(), Time = GetTime()}
		Player:SendMessageSuccess("Successfully sent teleportation request to player \"" .. OtherPlayer:GetName() .. "\"")
	end
	if Split[2] == nil then
		Player:SendMessageInfo("Usage: " .. Split[1] .. " <player>" )
	else
		if Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], Teleport) then
			Player:SendMessageFailure("Player \"" .. Split[2] .. "\" not found")
		end
	end
	return true
end

function HandleTPAcceptDenyCommand(Split, Player)
	local Teleport = function(OtherPlayer)
		if Split[1] == "/tpaccept" then
			if OtherPlayer:GetWorld():GetName() ~= Player:GetWorld():GetName() then
				if TeleportRequests[Player:GetUUID()].Type == "/tpa" then
					OtherPlayer:MoveToWorld(Player:GetWorld():GetName())
				elseif TeleportRequests[Player:GetUUID()].Type == "/tpahere" then
					Player:MoveToWorld(OtherPlayer:GetWorld():GetName())
				end
			end
			if TeleportRequests[Player:GetUUID()].Type == "/tpa" then
				OtherPlayer:TeleportToEntity(Player)
				Player:SendMessageSuccess("Player \"" .. OtherPlayer:GetName() .. "\" teleported to you")
				OtherPlayer:SendMessageSuccess("You teleported to player \"" .. Player:GetName() .. "\"")
			elseif TeleportRequests[Player:GetUUID()].Type == "/tpahere" then
				Player:TeleportToEntity(OtherPlayer)
				OtherPlayer:SendMessageSuccess("Player \"" .. Player:GetName() .. "\" teleported to you.")
				Player:SendMessageSuccess("You teleported to player \"" .. OtherPlayer:GetName() .. "\"")
			end
		elseif Split[1] == "/tpdeny" then
			OtherPlayer:SendMessageFailure("Player \"" .. Player:GetName() .. "\" has denied your teleportation request")
			Player:SendMessageSuccess("Successfully denied teleportation request")
		end
		TeleportRequests[Player:GetUUID()] = nil
	end
	if TeleportRequests[Player:GetUUID()] == nil then
		Player:SendMessageFailure("Nobody has sent you a teleportation request")
	elseif TpRequestTimeLimit > 0 and TeleportRequests[Player:GetUUID()].Time + TpRequestTimeLimit < GetTime() then
		TeleportRequests[Player:GetUUID()] = nil
		Player:SendMessageFailure("Teleportation request timed out")
	else
		if not cRoot:Get():FindAndDoWithPlayer(TeleportRequests[Player:GetUUID()].Requester, Teleport) then
			Player:SendMessageFailure("Player is no longer online")
		end
	end
	return true
end

function HandleBackCommand(Split, Player)
	local BackCoords = BackCoords[Player:GetName()]
	if BackCoords == nil then
		Player:SendMessageFailure("No known last position")
	else
		local CurWorld = Player:GetWorld()
		local OldWorld = BackWorld[Player:GetName()]
		if CurWorld ~= OldWorld then
			Player:MoveToWorld(OldWorld, true, Vector3d(BackCoords.x, BackCoords.y, BackCoords.z))
		else
			Player:TeleportToCoords(BackCoords.x, BackCoords.y, BackCoords.z)
		end
		Player:SendMessageSuccess("Successfully teleported back to your last known position")
	end
	return true
end

function HandleTopCommand(Split, Player)
	local World = Player:GetWorld()
	local Pos = Player:GetPosition()
	local Height = World:GetHeight(math.floor(Pos.x), math.floor(Pos.z))
	Player:TeleportToCoords(Pos.x, Height+1, Pos.z)
	Player:SendMessageSuccess("Successfully teleported to the topmost block")
	return true
end
