function HandleWarpCommand( Split, Player )
	if #Split < 2 then
		--No warp given, list warps available.
		HandleListWarpCommand( Split, Player )
		return true
	end
	local Tag = Split[2]

	local warpData = Database.getRow("Warps", "Name=?1", { Tag })
	if warpData == nil then
		Player:SendMessageFailure('Warp "' .. Tag .. '" is invalid.')
		return true
	end

	local OnAllChunksAvaliable = function()
		if (Player:GetWorld():GetName() ~= warpData[2]) then
			Player:MoveToWorld(warpData[2])
		end
		Player:TeleportToCoords(warpData[3], warpData[4], warpData[5])
		Player:SendMessageSuccess('Warped to "' .. Tag .. '".')
			
		if change_gm_when_changing_world == true then
			if Player:GetGameMode() == 1 and Player:GetWorld():GetGameMode() == 0 and clear_inv_when_going_from_creative_to_survival == true then
				Player:GetInventory():Clear()
			end
			Player:SetGameMode(Player:GetWorld():GetGameMode())
			return true
		end
	end
	cRoot:Get():GetWorld(warpData[2]):ChunkStay({{warpData[3]/16, warpData[5]/16}}, OnChunkAvailable, OnAllChunksAvaliable)
	return true
end

function HandleSetWarpCommand( Split, Player)
	local World = Player:GetWorld():GetName()
	local pX = Player:GetPosX()
	local pY = Player:GetPosY()
	local pZ = Player:GetPosZ()

	if #Split < 2 then
		Player:SendMessageInfo('Usage: '..Split[1]..' <warpname>')
		return true
	end
	local Tag = Split[2]

	Database.upsertRow("Warps", "Name=?1", { Name = "?1", World = "?2", X = "?3", Y = "?4", Z = "?5" }, { Tag, World, pX, pY, pZ })
	
	Player:SendMessageSuccess("Warp \"" .. Tag .. "\" set to World:'" .. World .. "' x:'" .. math.floor(pX + 0.5) .. "' y:'" .. math.floor(pY + 0.5) .. "' z:'" .. math.floor(pZ + 0.5) .. "'")
	return true
end

function HandleDelWarpCommand( Split, Player)
	if #Split < 2 then
		Player:SendMessageInfo('Usage: '..Split[1]..' <warp>')
		return true
	end
	local Tag = Split[2]

	if not Database.rowExists("Warps", "Name=?1", { Tag }) then
		Player:SendMessageFailure("Warp \"" .. Tag .. "\" was not found.")
		return true
	end

	Database.deleteRow("Warps", "Name=?1", { Tag })

	Player:SendMessageSuccess("Warp \"" .. Tag .. "\" was removed.")
	return true
end

function HandleListWarpCommand( Split, Player)
	local warpStr = ""
	local rows = Database.getRows("Warps", "1", {})
	for i=1, #rows do
		warpStr = warpStr .. rows[i][1] .. ", "
	end

	Player:SendMessageInfo('Warps: ' ..  cChatColor.LightGreen ..  string.sub(warpStr, 1, -3))
	return true
end
