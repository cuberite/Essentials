function HandleWarpCommand(Split, Player )
	if Split[2] == nil then
		--No warp given, list warps available.
		HandleListWarpCommand(Split, Player)
	elseif Warps[table.concat(Split, " ", 2)] == nil then 
		Player:SendMessageFailure("Warp \"" .. Split[2] .. "\" is invalid")
	else
		if Player:GetWorld():GetName() ~= Warps[Split[2]]["w"] then
			Player:MoveToWorld(cRoot:Get():GetWorld(Warps[Split[2]]["w"]), true, Vector3d(Warps[Split[2]]["x"] + 0.5, Warps[Split[2]]["y"], Warps[Split[2]]["z"] + 0.5))
		else
			Player:TeleportToCoords(Warps[Split[2]]["x"] + 0.5 , Warps[Split[2]]["y"] , Warps[Split[2]]["z"] + 0.5)
		end
		Player:SendMessageSuccess("Successfully warped to \"" .. Split[2] .. "\"")
		if change_gm_when_changing_world == true then
			Player:SetGameMode(Player:GetWorld():GetGameMode())
		end
	end
	return true
end

function HandleSetWarpCommand(Split, Player)
	local World = Player:GetWorld():GetName()
	local PosX = math.floor(Player:GetPosX())
	local PosY = math.floor(Player:GetPosY())
	local PosZ = math.floor(Player:GetPosZ())
	if Split[2] == nil then
		Player:SendMessageInfo("Usage: " .. Split[1] .. " <name>")
		return true
	end
	if Warps[Split[2]] == nil then 
		Warps[Split[2]] = {}
	end
	if WarpsINI:FindKey(Split[2])<0 then
		Warps[Split[2]]["w"] = World
		Warps[Split[2]]["x"] = PosX
		Warps[Split[2]]["y"] = PosY
		Warps[Split[2]]["z"] = PosZ
		WarpsINI:AddKeyName(Split[2])
		WarpsINI:SetValue(Split[2] , "w" , World)
		WarpsINI:SetValue(Split[2] , "x" , PosX)
		WarpsINI:SetValue(Split[2] , "y" , PosY)
		WarpsINI:SetValue(Split[2] , "z" , PosZ)
		WarpsINI:WriteFile("warps.ini");
		Player:SendMessageSuccess("Warp \"" .. Split[2] .. "\" set to world:\"" .. World .. "\", X:" .. PosX .. ", Y:" .. PosY .. ", Z:" .. PosZ)
	else
		Player:SendMessageFailure("Warp \"" .. Split[2] .. "\" already exists")
	end
	return true
end

function HandleDelWarpCommand(Split, Player)
	if Split[2] == nil then
		Player:SendMessageInfo("Usage: " .. Split[1] .. " <warp>")
		return true
	end
	Warps[Split[2]] = nil
	if WarpsINI:FindKey(Split[2])>-1 then
		WarpsINI:DeleteKey(Split[2])
		WarpsINI:WriteFile("warps.ini")
	else
		Player:SendMessageFailure("Warp \"" .. Split[2] .. "\" was not found")
		return true
	end
	Player:SendMessageSuccess("Successfully removed warp \"" .. Split[2] .. "\"")
	return true
end

function HandleListWarpCommand(Split, Player)
	local WarpName = ""
	for k, v in pairs (Warps) do
		WarpName = WarpName .. k .. ", "
	end
	Player:SendMessageInfo("Warps: " .. cChatColor.LightGreen .. WarpName:sub(1, WarpName:len() - 2))
	return true
end
