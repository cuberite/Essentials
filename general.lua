function HandleBiomeCommand(Split, Player)
	local GetBiome = function(OtherPlayer)
		--Get the name of the biome where the player is and store it in a variable
		local Biome = BiomeToString(OtherPlayer:GetWorld():GetBiomeAt(math.floor(OtherPlayer:GetPosX()), math.floor(OtherPlayer:GetPosZ())))
		if Split[2] then
			Player:SendMessageInfo("Player \"" .. OtherPlayer:GetName() .. "\" is in " .. Biome)
		else
			OtherPlayer:SendMessageInfo("You're in " .. Biome)
		end
	end
	if Split[2] == nil then
		GetBiome(Player)
	elseif Player:HasPermission("es.biome.other") then
		if Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], GetBiome) then
			Player:SendMessageFailure("Player \"" .. Split[2] .. "\" not found")
		end
	end
	return true
end

function HandleDepthCommand(Split, Player)
	local PosY = Player:GetPosY()
	if PosY > 63 then
		Player:SendMessageInfo("You are "..(PosY-63).." block(s) above sea level")
	elseif PosY < 63 then
		Player:SendMessageInfo("You are "..(63-PosY).." block(s) below sea level")
	else
		Player:SendMessageInfo("You are at sea level")
	end
	return true
end

function HandleLocateCommand(Split, Player)
	local GetPos = function(OtherPlayer)
		local PosX = math.floor(OtherPlayer:GetPosX())
		local PosY = math.floor(OtherPlayer:GetPosY())
		local PosZ = math.floor(OtherPlayer:GetPosZ())
		local World = OtherPlayer:GetWorld():GetName()
		if Split[2] then
			Player:SendMessageInfo("Position of player \"" .. OtherPlayer:GetName() .. "\": X:" .. PosX .. ", Y:" .. PosY .. ", Z:" .. PosZ .. " in world \"" .. World .. "\"")
		else
			OtherPlayer:SendMessageInfo("Your position: X:" .. PosX .. ", Y:" .. PosY .. ", Z:" .. PosZ .. " in world \"" .. World .. "\"")
		end
	end
	if Split[2] == nil then
		GetPos(Player)
	elseif Player:HasPermission("es.locate.other") then
		if Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], GetPos) then
			Player:SendMessageFailure("Player \"" .. Split[2] .. "\" not found")
		end
	end
	return true
end

function HandleWhoisCommand(Split, Player)
	local GetInfo = function(OtherPlayer)
		Player:SendMessageInfo("Username: " .. OtherPlayer:GetName())
		Player:SendMessageInfo("UUID: " .. OtherPlayer:GetUUID())
		Player:SendMessageInfo("IP: " .. OtherPlayer:GetIP())
		if OtherPlayer:IsFlying() then
			Player:SendMessageInfo("Flying: true")
		else
			Player:SendMessageInfo("Flying: false")
		end
		if GodModeList[OtherPlayer:GetUUID()] == nil then
			Player:SendMessageInfo("God Mode: disabled")
		else
			Player:SendMessageInfo("God Mode: enabled")
		end
		if OtherPlayer:IsVisible() then
			Player:SendMessageInfo("Hidden: false")
		else
			Player:SendMessageInfo("Hidden: true")
		end
		Player:SendMessageInfo("Ping: " .. OtherPlayer:GetClientHandle():GetPing())
		Player:SendMessageInfo("Language: " .. OtherPlayer:GetClientHandle():GetLocale())
	end
	if Split[2] == nil then	
		GetInfo(Player)
	else
		if Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], GetInfo) then
			Player:SendMessageFailure("Player \"" .. Split[2] .. "\" not found")
		end
	end
	return true
end

function HandleBroadcastCommand(Split, Player)
	if Split[2] == nil then
		Player:SendMessageInfo("Usage: " .. Split[1] .. " <message ...>")
	else	
		cRoot:Get():BroadcastChat(cChatColor.Gold .. "[SERVER] " .. cChatColor.Yellow .. table.concat(Split, " ", 2))
	end
	return true
end

function HandleShoutCommand(Split, Player)
	local PosX = Player:GetPosX()
	local PosY = Player:GetPosY()
	local PosZ = Player:GetPosZ()
	local World = Player:GetWorld()

	if Split[2] == nil then
		Player:SendMessageInfo("Usage: " .. Split[1] .. " <message ...>")
	elseif Split[1] == "/shout" then
		Range = cBoundingBox(PosX - 128, PosX + 128, PosY - 128, PosY + 128, PosZ - 128, PosZ + 128)
		Action = "[SHOUT]"
	elseif Split[1] == "/whisper" then
		Range = cBoundingBox(PosX - 16, PosX + 16, PosY - 16, PosY + 16, PosZ - 16, PosZ + 16)
		Action = "[WHISPER]"
	end

	local SendMessage = function(Entity)
		if Entity:IsPlayer() then
			Entity:SendMessage(cChatColor.Yellow .. Action .. cChatColor.White .. " <" .. Player:GetName() .. "> " .. table.concat(Split , " " , 2))
		end
	end
	World:ForEachEntityInBox(Range, SendMessage)
	return true
end

