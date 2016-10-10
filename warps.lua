function HandleWarpCommand( Split, Player )
	if #Split < 2 then
		--No warp given, list warps available.
		HandleListWarpCommand( Split, Player )
		return true
	end
	local Tag = Split[2]
	
	if warps[Tag] == nil then 
		Player:SendMessageFailure('Warp "' .. Tag .. '" is invalid.')
		return true
	end
	local OnAllChunksAvaliable = function()
		if (Player:GetWorld():GetName() ~= warps[Tag]["w"]) then
			Player:MoveToWorld(cRoot:Get():GetWorld(warps[Tag]["w"]), true,
				Vector3d(warps[Tag]["x"] + 0.5, warps[Tag]["y"], warps[Tag]["z"] + 0.5))
			Player:SendMessageSuccess('Warped to "' .. Tag .. '".')
			if change_gm_when_changing_world == true then
				Player:SetGameMode(Player:GetWorld():GetGameMode())
				return true
			end
		else
			Player:TeleportToCoords( warps[Tag]["x"] + 0.5 , warps[Tag]["y"] , warps[Tag]["z"] + 0.5)
			Player:SendMessageSuccess('Warped to "' .. Tag .. '".')
		end
	end
	cRoot:Get():GetWorld(warps[Tag]["w"]):ChunkStay({{warps[Tag]["x"]/16, warps[Tag]["z"]/16}}, OnChunkAvailable, OnAllChunksAvaliable)
	return true
end

function HandleSetWarpCommand( Split, Player)
	local Server = cRoot:Get():GetServer()
	local World = Player:GetWorld():GetName()
	local pX = math.floor(Player:GetPosX())
	local pY = math.floor(Player:GetPosY())
	local pZ = math.floor(Player:GetPosZ())

	if #Split < 2 then
		Player:SendMessageInfo('Usage: '..Split[1]..' <warpname>')
		return true
	end
	local Tag = Split[2]
	
	if warps[Tag] == nil then 
		warps[Tag] = {}
	end
	
	if (WarpsINI:FindKey(Tag)<0) then
		warps[Tag]["w"] = World
		warps[Tag]["x"] = pX
		warps[Tag]["y"] = pY
		warps[Tag]["z"] = pZ
	end

	if (WarpsINI:FindKey(Tag)<0) then
		WarpsINI:AddKeyName(Tag);
		WarpsINI:SetValue( Tag , "w" , World)
		WarpsINI:SetValue( Tag , "x" , pX)
		WarpsINI:SetValue( Tag , "y" , pY)
		WarpsINI:SetValue( Tag , "z" , pZ)
		WarpsINI:WriteFile("warps.ini");
	
		Player:SendMessageSuccess("Warp \"" .. Tag .. "\" set to World:'" .. World .. "' x:'" .. pX .. "' y:'" .. pY .. "' z:'" .. pZ .. "'")
	else
		Player:SendMessageFailure('Warp "' .. Tag .. '" already exists')
	end
	return true
end

function HandleDelWarpCommand( Split, Player)
	local Server = cRoot:Get():GetServer()
	
	if #Split < 2 then
		Player:SendMessageInfo('Usage: '..Split[1]..' <warp>')
		return true
	end
	local Tag = Split[2]
	warps[Tag] = nil
	
	if (WarpsINI:FindKey(Tag)>-1) then
		WarpsINI:DeleteKey(Tag);
		WarpsINI:WriteFile("warps.ini");
	else
		Player:SendMessageFailure("Warp \"" .. Tag .. "\" was not found.")
		return true
	end
	
	Player:SendMessageSuccess("Warp \"" .. Tag .. "\" was removed.")
	return true
end

function HandleListWarpCommand( Split, Player)
	local warpStr = ""
	local inc = 0
	for k, v in pairs (warps) do
		inc = inc + 1
		warpStr = warpStr .. k .. ", "
	end
	Player:SendMessageInfo('Warps: ' ..  cChatColor.LightGreen ..  warpStr)
	return true
end
