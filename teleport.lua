--When someone uses tpa or tpahere request is saved in this array under targeted player uuid
--Type - Request type(used command - "/tpahere" or "/tpa"), Requester - uuid of requesting player, Time - request time
local TeleportRequests = {}


function HandlePlaceCommand(Split,Player)
	if Split[2] == nil then
		Player:SendMessageInfo("Usage: "..Split[1].." <player>")
	else
		pos = GetPlayerLookPosPlace(Player)
		local Teleport = function(OtherPlayer)
			if (OtherPlayer:GetName() == Split[2]) then
				if pos.x == 0 and pos.y == 0 and pos.z == 0 then
					Player:SendMessageFailure("You're not looking at a block (or it's too far)")
				else
					--Teleport the player
					OtherPlayer:TeleportToCoords(pos.x, pos.y + 1, pos.z)
					Player:SendMessageSuccess("Teleported "..Split[2].." where you are looking")
				end
				return true
			end
		end
		if (not(cRoot:Get():FindAndDoWithPlayer(Split[2], Teleport))) then
			Player:SendMessageFailure("Player not found")
		end
	end
	return true
end


function HandleTPHereCommand(Split, Player)
	
	local flag = 0
	
	if #Split == 2 then

		local teleport = function( OtherPlayer )
			SetBackCoordinates(OtherPlayer)
			if OtherPlayer:GetWorld():GetName() ~= Player:GetWorld():GetName() then
				OtherPlayer:MoveToWorld( Player:GetWorld():GetName() )
			end
			OtherPlayer:TeleportToEntity( Player )
			Player:SendMessageSuccess( OtherPlayer:GetName() .. " teleported to you." )
			OtherPlayer:SendMessageSuccess( "You teleported to " .. Player:GetName() )
			flag = 1
		end
		
		cRoot:Get():FindAndDoWithPlayer(Split[2], teleport)
		
		if flag == 0 then
			Player:SendMessageFailure("Player " ..  Split[2] .. " not found!")
		end
		
		return true
	else
		Player:SendMessage( "Usage: /tphere [PlayerName]" )
		return true
	end

end


function HandleTPACommand( Split, Player )

	local flag = 0
	
	if Split[2] == nil then
		Player:SendMessageInfo("Usage: " .. Split[1] .. " [Player]" )
		return true
	end
	
	if Split[2] == Player:GetName() then
		Player:SendMessageInfo("You can't teleport to yourself!" )
		return true
	end

	local loopPlayer = function( OtherPlayer )
		if OtherPlayer:GetName() == Split[2] then
		
			if Split[1] == "/tpa" then
				OtherPlayer:SendMessage( Player:GetName() .. cChatColor.Plain .. " has requested to teleport to you." )
			else
				OtherPlayer:SendMessage( Player:GetName() .. cChatColor.Plain .. " has requested you to teleport to him." )
			end
			
			if TpRequestTimeLimit > 0 then
				OtherPlayer:SendMessage("This request will timeout after " .. TpRequestTimeLimit .. " seconds" )
			end
			
			OtherPlayer:SendMessage("To teleport, type " .. cChatColor.LightGreen .. "/tpaccept" )
			OtherPlayer:SendMessage("To deny this request, type " .. cChatColor.Rose .. "/tpdeny" )
			Player:SendMessageSuccess("Request sent to " .. OtherPlayer:GetName() )
			
			TeleportRequests[OtherPlayer:GetUniqueID()] = {Type = Split[1], Requester = Player:GetUniqueID(), Time = GetTime() }
			
			flag = 1
		end
	end

	cRoot:Get():ForEachPlayer(loopPlayer)
	
	if flag == 0 then
		Player:SendMessageFailure("Player " ..  Split[2] .. " not found!")
	end
	
	return true

end


function HandleTPAcceptCommand( Split, Player )

	local flag = 0
	
	if TeleportRequests[Player:GetUniqueID()] == nil then
		Player:SendMessageFailure("Nobody has send you a teleport request." )
		return true
	end
	
	if TpRequestTimeLimit > 0 then
		if TeleportRequests[Player:GetUniqueID()].Time + TpRequestTimeLimit < GetTime() then
			TeleportRequests[Player:GetUniqueID()] = nil
			Player:SendMessageFailure("Teleport request timed out." )
			return true
		end
	end
	
	local loopPlayer = function( OtherPlayer )
	
		if TeleportRequests[Player:GetUniqueID()].Requester == OtherPlayer:GetUniqueID() then
			if OtherPlayer:GetWorld():GetName() ~= Player:GetWorld():GetName() then
				if TeleportRequests[Player:GetUniqueID()].Type == "/tpa" then
					OtherPlayer:MoveToWorld( Player:GetWorld():GetName() )
				elseif TeleportRequests[Player:GetUniqueID()].Type == "/tpahere" then
					Player:MoveToWorld( OtherPlayer:GetWorld():GetName() )
				end
			end
			
			if TeleportRequests[Player:GetUniqueID()].Type == "/tpa" then
				SetBackCoordinates(OtherPlayer)
				OtherPlayer:TeleportToEntity( Player )
				Player:SendMessageSuccess(OtherPlayer:GetName() .. " teleported to you." )
				OtherPlayer:SendMessageSuccess("You teleported to " .. Player:GetName() )
			elseif TeleportRequests[Player:GetUniqueID()].Type == "/tpahere" then
				SetBackCoordinates(Player)
				Player:TeleportToEntity( OtherPlayer )
				OtherPlayer:SendMessageSuccess(Player:GetName() .. " teleported to you." )
				Player:SendMessageSuccess("You teleported to " .. OtherPlayer:GetName() )
			end
			
			flag = 1
		end
	end

	cRoot:Get():ForEachPlayer(loopPlayer)
	
	TeleportRequests[Player:GetUniqueID()] = nil
	
	if flag == 0 then
		Player:SendMessageFailure("Other player isn't online anymore!")
	end
	
	return true

end


function HandleTPDenyCommand( Split, Player )

	if TeleportRequests[Player:GetUniqueID()] == nil then
		Player:SendMessageFailure("Nobody has send you a teleport request." )
		return true
	end
	
	if TpRequestTimeLimit > 0 then
		if TeleportRequests[Player:GetUniqueID()].Time + TpRequestTimeLimit < GetTime() then
			TeleportRequests[Player:GetUniqueID()] = nil
			Player:SendMessageFailure("Teleport request timed out." )
			return true
		end
	end
	
	Player:SendMessageSuccess("Request denied.")
	
	local loopPlayer = function( OtherPlayer )
		if TeleportRequests[Player:GetUniqueID()].Requester == OtherPlayer:GetUniqueID() then
			OtherPlayer:SendMessageFailure(Player:GetName() .. " has denied your request." )
		end
	end

	cRoot:Get():ForEachPlayer(loopPlayer)
	
	TeleportRequests[Player:GetUniqueID()] = nil
	
	return true

end

function HandleBackCommand( Split, Player )
	local BackPosition = BackCoords[Player:GetName()]

	if (BackPosition == nil) then
		Player:SendMessageFailure("No known last position")
		return true
	end

	SetBackCoordinates(Player)
	local OnAllChunksAvaliable = function()
		Player:TeleportToCoords(BackPosition.x, BackPosition.y, BackPosition.z)
		Player:SendMessageSuccess("Teleported back to your last known position")
	end

	Player:GetWorld():ChunkStay({{BackPosition.x/16, BackPosition.z/16}}, OnChunkAvailable, OnAllChunksAvaliable)
	return true
end
