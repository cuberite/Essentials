function HandleBiomeCommand(Split,Player)
	if Split[2] == nil then
	--Get the name of the biome where the player is and store it in a variable
		biome = GetStringFromBiome(Player:GetWorld():GetBiomeAt(Player:GetPosX(), Player:GetPosZ()))
		Player:SendMessageInfo("You're in ".. biome)
	elseif Player:HasPermission("es.biome.other") then
		local GetBiome = function(OtherPlayer)
			if (OtherPlayer:GetName() == Split[2]) then
				biome = GetStringFromBiome(OtherPlayer:GetWorld():GetBiomeAt(OtherPlayer:GetPosX(), OtherPlayer:GetPosZ()))
				Player:SendMessageInfo(Split[2].. " is in ".. biome)
				return true
			end
		end
		if (not(cRoot:Get():FindAndDoWithPlayer(Split[2], GetBiome))) then
			Player:SendMessageFailure("Player not found")
		end
	end
	return true
end

function HandleDepthCommand(Split,Player)
	local YPos = Player:GetPosY()
	if YPos == 63 then
		Player:SendMessageInfo("You are at sea level")
	elseif YPos < 63 then
		Player:SendMessageInfo("You are "..(63-YPos).." block(s) below sea level.")
	else
		Player:SendMessageInfo("You are "..(YPos-63).." block(s) above sea level.")
	end
	return true
end

function HandleLocateCommand(Split,Player)
	if Split[2] == nil then
		Player:SendMessageInfo("Your position: X:"..Player:GetPosX()..", Y:"..Player:GetPosY()..", Z:"..Player:GetPosZ().." in world "..Player:GetWorld():GetName())
	elseif Player:HasPermission("es.locate.other") then
		local GetPos = function(OtherPlayer)
			if (OtherPlayer:GetName() == Split[2]) then
				Player:SendMessageInfo(Split[2].." position: X:"..OtherPlayer:GetPosX()..", Y:"..OtherPlayer:GetPosY()..", Z:"..OtherPlayer:GetPosZ())
				return true
			end
		end
		if (not(cRoot:Get():FindAndDoWithPlayer(Split[2], GetPos))) then
			Player:SendMessageFailure("Player not found")
		end
	end
	return true
end

function HandleWhoisCommand(Split,Player)
	if Split[2] == nil then
		--Get Player information and show it as a mesage	
		Player:SendMessageInfo("Your username is "..Player:GetName())
		Player:SendMessageInfo("Your IP is "..Player:GetIP())
		Player:SendMessageInfo("Your ping is "..Player:GetClientHandle():GetPing())
		Player:SendMessageInfo("Your language is "..Player:GetClientHandle():GetLocale())
	else
		local GetInfo = function(OtherPlayer)
			if (OtherPlayer:GetName() == Split[2]) then
				Player:SendMessageInfo("Username: "..OtherPlayer:GetName())
				Player:SendMessageInfo("IP: "..OtherPlayer:GetIP())
				Player:SendMessageInfo("Ping: "..OtherPlayer:GetClientHandle():GetPing())
				Player:SendMessageInfo("Language: "..OtherPlayer:GetClientHandle():GetLocale())
				return true
			end
		end
		if (not(cRoot:Get():FindAndDoWithPlayer(Split[2], GetInfo))) then
			Player:SendMessageFailure("Player not found")
		end
	end
	return true
end

function HandleBroadcastCommand(Split,Player)
	if Split[2] == nil then
		Player:SendMessageInfo("Usage: "..Split[1].." <message>")
	else
		--Send all Split[x]	
		cRoot:Get():QueueExecuteConsoleCommand("say "..table.concat( Split , " " , 2 ))
	end
	return true
end

function HandleShoutCommand(Split,Player)
	if Split[2] == nil then
		Player:SendMessageInfo("Usage: "..Split[1].." <message>")
	elseif Split[1] == "/shout" then
		range = cBoundingBox(Player:GetPosX() - 128, Player:GetPosX() + 128, Player:GetPosY() - 128, Player:GetPosY() + 128, Player:GetPosZ() - 128, Player:GetPosZ() + 128)
		action = "[SHOUT]"
	elseif Split[1] == "/whisper" then
		range = cBoundingBox(Player:GetPosX() - 16, Player:GetPosX() + 16, Player:GetPosY() - 16, Player:GetPosY() + 16, Player:GetPosZ() - 16, Player:GetPosZ() + 16)
		action = "[WHISPER]"
	end
	world = Player:GetWorld()
	local Send = function(Entity)
		if Entity:IsPlayer() then
			Player = tolua.cast(Entity, "cPlayer")
			Player:SendMessage(cChatColor.Yellow..""..action..""..cChatColor.White.." <"..Player:GetName().."> "..table.concat( Split , " " , 2 ))
		end
	end
	world:ForEachEntityInBox(range, Send)
	return true
end

