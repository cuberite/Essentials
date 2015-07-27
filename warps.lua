function HandleWarpCommand( Split, Player )
	if #Split < 2 then
		--No warp given, list warps available.
		HandleListWarpCommand( Split, Player )
		return true
	end
	local Tag = Split[2]

	local warpSearch = database:prepare("SELECT * FROM Warps WHERE Name=?")
	warpSearch:bind(1, Tag)
	if warpSearch:step() ~= sqlite3.ROW then
		Player:SendMessageFailure('Warp "' .. Tag .. '" is invalid.')
		return true
	end
	local warpData = warpSearch:get_values()
	warpSearch:finalize()

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

	local addWarp = database:prepare("INSERT OR IGNORE INTO Warps (Name, World, X, Y, Z) VALUES (?1, ?2, ?3, ?4, ?5)")
	addWarp:bind_values(Tag, World, pX, pY, pZ)
  addWarp:step()
	addWarp:finalize()
	
	local updateWarp = database:prepare("UPDATE Warps SET World=?2, X=?3, Y=?4, Z=?5 WHERE Name=?1")
	updateWarp:bind_values(Tag, World, pX, pY, pZ)
  updateWarp:step()
  updateWarp:finalize()
	
	Player:SendMessageSuccess("Warp \"" .. Tag .. "\" set to World:'" .. World .. "' x:'" .. math.floor(pX + 0.5) .. "' y:'" .. math.floor(pY + 0.5) .. "' z:'" .. math.floor(pZ + 0.5) .. "'")
	return true
end

function HandleDelWarpCommand( Split, Player)
	if #Split < 2 then
		Player:SendMessageInfo('Usage: '..Split[1]..' <warp>')
		return true
	end
	local Tag = Split[2]

	local warpSearch = database:prepare("SELECT * FROM Warps WHERE Name=?")
	warpSearch:bind(1, Tag)
	if warpSearch:step() ~= sqlite3.ROW then
		Player:SendMessageFailure("Warp \"" .. Tag .. "\" was not found.")
		return true
	end
	warpSearch:finalize()

	local warpDelete = database:prepare("DELETE FROM Warps WHERE Name=?")
	warpDelete:bind(1, Tag)
	warpDelete:step()
	warpDelete:finalize()

	Player:SendMessageSuccess("Warp \"" .. Tag .. "\" was removed.")
	return true
end

function HandleListWarpCommand( Split, Player)
	local warpStr = ""
	function Callback(udata, cols, values, names)
		warpStr = warpStr .. values[1] .. ", "
		return 0
	end
	database:exec("SELECT Name FROM Warps", Callback)
	Player:SendMessageInfo('Warps: ' ..  cChatColor.LightGreen ..  string.sub(warpStr, 1, -3))
	return true
end
