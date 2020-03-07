function HandleSpawnMobCommand(Split, Player)
	local SpawnMob = function(OtherPlayer)
		local LookPos = GetPlayerLookPos(Player)
		local PosX = OtherPlayer:GetPosX()
		local PosY = OtherPlayer:GetPosY()
		local PosZ = OtherPlayer:GetPosZ()
		local World = OtherPlayer:GetWorld()
		local IsBaby = false

		-- Check if mob name contains :baby
		if string.find(Split[2], ":") then
			Split[2], data = string.match(Split[2], "(%w+):(%w+)")
			if data == "baby" then
				IsBaby = true
			end
		end

		local MobID = cMonster:StringToMobType(Split[2])

		if Split[3] or LookPos == nil then
			World:SpawnMob(PosX + 2, PosY, PosZ + 2, MobID, IsBaby)
		else
			World:SpawnMob(LookPos.x, LookPos.y + 1, LookPos.z, MobID, IsBaby)
		end

		if MobID == -1 then
			Player:SendMessageFailure("Unknown mob type \"" .. Split[2] .. "\"")
		else
			if Split[3] then
				Player:SendMessageSuccess("Successfully spawned mob near player \"" .. OtherPlayer:GetName() .. "\"")
			else
				Player:SendMessageSuccess("Successfully spawned mob " .. Split[2])
			end
		end
	end

	if Split[2] == nil then
		Player:SendMessageInfo("Usage: " .. Split[1] .. " <mobtype[:baby]> [player]")
	elseif Split[3] == nil then
		SpawnMob(Player)
	elseif Player:HasPermission("es.spawnmob.other") then
		if Split[3] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[3], SpawnMob) then
			Player:SendMessageFailure("Player \"" .. Split[3] .. "\" not found")
		end
	end
	return true
end

function HandleBurnCommand(Split, Player)
	local BurnPlayer = function(OtherPlayer)
		if Split[3] == nil then
			--Burn the player for 10s
			OtherPlayer:StartBurning(200)
		else
			--Burn the player for the specified time
			OtherPlayer:StartBurning(Split[3] * 20)
		end
		Player:SendMessageSuccess("Successfully set player \"" .. OtherPlayer:GetName() .. "\" on fire")
	end
	if Split[2] == nil then
		Player:SendMessageInfo("Usage: " .. Split[1] .. " <player> [seconds]")
	else
		if Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], BurnPlayer) then
			Player:SendMessageFailure("Player \"" .. Split[2] .. "\" not found")
		end
	end
	return true
end

function HandleExtinguishCommand(Split, Player)
	local ExtPlayer = function(OtherPlayer)
		OtherPlayer:StopBurning()
		Player:SendMessageSuccess("Successfully extinguished player \"" .. OtherPlayer:GetName() .. "\"")
	end
	if Split[2] == nil then
		Player:SendMessageInfo("Usage: " .. Split[1] .. " <player>")
	else
		if Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], ExtPlayer) then
			Player:SendMessageFailure("Player \"" .. Split[2] .. "\" not found")
		end
	end
	return true
end

function HandlePingCommand(Split, Player)
	if Split[2] then
		Player:SendMessage(table.concat(Split, " ", 2))
	else
		Player:SendMessage(cChatColor.Green.. "Pong!")
	end
	return true
end

function HandleLightningCommand(Split, Player)
	local CreateLightning = function(OtherPlayer)
		local LookPos = GetPlayerLookPos(Player)
		if Split[2] == nil then
			if LookPos == nil then
				Player:GetWorld():CastThunderbolt(Vector3i(Player:GetPosition()))
			else
				Player:GetWorld():CastThunderbolt(Vector3i(LookPos.x, LookPos.y, LookPos.z))
			end
		else
			OtherPlayer:GetWorld():CastThunderbolt(Vector3i(OtherPlayer:GetPosition()))
			OtherPlayer:SendMessageInfo("A lightning hit you")
			OtherPlayer:TakeDamage(dtLightning, nil, 5, 5, 0)
		end
	end
	if Split[2] == nil then
		CreateLightning(Player)
	elseif Split[2] == "*" or Split[2] == "**" then
		cRoot:Get():ForEachPlayer(CreateLightning)
	else
		if Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], CreateLightning) then
			Player:SendMessageFailure("Player \"" .. Split[2] .. "\" not found")
		end
	end
	return true
end

function HandleItemdbCommand(Split, Player)
	local Item = cItem()
	if Split[2] == nil then
		local ItemString = ItemToString(Player:GetEquippedItem())
		local Item = Player:GetEquippedItem()
		Player:SendMessageInfo("You are holding " .. Item.m_ItemCount .. " " .. ItemString .. ", ID: " .. Item.m_ItemType .. ":" .. Item.m_ItemDamage)
	elseif StringToItem(Split[2], Item) then
		Player:SendMessageInfo("Item: " .. ItemToString(Item) .. ", ID: " .. Item.m_ItemType .. ":" .. Item.m_ItemDamage)
	else
		Player:SendMessageFailure("Specify a valid item name")
	end
	return true
end

function HandleMuteCommand(Split, Player)
	local MutePlayer = function(OtherPlayer)
		--Mute the player
		UsersINI:SetValue(OtherPlayer:GetUUID(), "Muted", "true")
		UsersINI:WriteFile("users.ini")
		Muted[OtherPlayer:GetUUID()] = true
		OtherPlayer:SendMessageInfo("You have been muted")
		Player:SendMessageSuccess("Successfully muted player \"" .. OtherPlayer:GetName() .. "\"")
	end
	if Split[2] == nil then
		Player:SendMessageInfo("Usage: " .. Split[1] .. " <player>")
	else
		if Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], MutePlayer) then
			Player:SendMessageFailure("Player \"" .. Split[2] .. "\" not found")
		end
	end
	return true
end

function HandleUnmuteCommand(Split, Player)
	local UnmutePlayer = function(OtherPlayer)
		UsersINI:SetValue(OtherPlayer:GetUUID(), "Muted", "false")
		UsersINI:WriteFile("users.ini")
		Muted[OtherPlayer:GetUUID()] = false
		OtherPlayer:SendMessageInfo("You have been unmuted")
		Player:SendMessageSuccess("Successfully unmuted player \"" .. OtherPlayer:GetName() .. "\"")
	end
	if Split[2] == nil then
		Player:SendMessageInfo("Usage: " .. Split[1] .. " <player>")
	else
		if Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], UnmutePlayer) then
			Player:SendMessageFailure("Player \"" .. Split[2] .. "\" not found")
		end
	end
	return true
end

function HandleAntiOchCommand(Split, Player)
	local LookPos = GetPlayerLookPos(Player)
	if LookPos == nil then
		Player:SendMessageFailure("You're not looking at a block, or it's too far away")
	else
		if Split[2] then
			cRoot:Get():BroadcastChat("...lobbest thou thy Holy Hand Grenade of Antioch towards thy foe,")
			cRoot:Get():BroadcastChat("who being naughty in My sight, shall snuff it.")
		end
		Player:GetWorld():SpawnPrimedTNT(Vector3d(LookPos.x, LookPos.y, LookPos.z), 35)
	end
	return true
end

function HandleSkullCommand(Split, Player)
	local UpdateHead = function(Head)
		local Head = tolua.cast(Head, "cMobHeadEntity")
		local OwnerUUID = cMojangAPI:GetUUIDFromPlayerName(Split[2])
		local OwnerName = Split[2]
		if OwnerUUID ~= "" then
			cUrlClient:Get("https://sessionserver.mojang.com/session/minecraft/profile/" .. OwnerUUID,
				function(Body, Data)
					local OwnerTexture = Body:match('"value":"(.-)"')
					Head:SetType(3)
					Head:SetOwner(OwnerUUID, OwnerName, OwnerTexture, "")
					Player:SendMessageSuccess("Successfully changed the skull to player " .. Head:GetOwnerName() .. "'s")
				end
			)
		else
			Player:SendMessageInfo("There is no Minecraft account with that username")
		end
	end
	local LookPos = GetPlayerLookPos(Player)
	if Split[2] == nil then
		Player:SendMessageInfo("Usage: " .. Split[1] .. " <username>")
	elseif not Player:GetWorld():DoWithMobHeadAt(LookPos.x, LookPos.y, LookPos.z, UpdateHead) then
		Player:SendMessageInfo("You have to look at a skull to change its owner")
	end
	return true
end

function HandleSocialSpyCommand(Split, Player)
	local ToggleSocialSpy = function(Player)
		if SocialSpyList[Player:GetUUID()] then
			SocialSpyList[Player:GetUUID()] = nil
			Player:SendMessageSuccess("Successfully disabled SocialSpy")
		else
			SocialSpyList[Player:GetUUID()] = true
			Player:SendMessageSuccess("Successfully enabled SocialSpy")
		end
	end
	ToggleSocialSpy(Player)
	return true
end

function HandleNearCommand(Split, Player)
	local PlayerTable = {}
	Player:GetWorld():ForEachPlayer(
		function(OtherPlayer)
			local Distance = math.floor((Player:GetPosition() - OtherPlayer:GetPosition()):Length())
			if tonumber(Split[2]) then
				DistanceLimit = tonumber(Split[2])
			else
				DistanceLimit = 200
			end
			if Distance <= DistanceLimit then
				if OtherPlayer:GetName() ~= Player:GetName() then
					table.insert(PlayerTable,
						{
							Name = OtherPlayer:GetName(),
							Distance = Distance,
						}
					)
				end
			end
		end
	)

	table.sort(PlayerTable,
		function (Player1, Player2)
			return Player1.Distance < Player2.Distance
		end
	)

	local String = {}
	for k, v in ipairs(PlayerTable) do
		table.insert(String, v.Name)
		table.insert(String, " " .. cChatColor.Plain .. "(")
		table.insert(String, v.Distance)
		table.insert(String, "m), ")
	end

	local String = table.concat(String, "")
	Player:SendMessageInfo("Players nearby: " .. cChatColor.Plain .. String:sub(1, String:len() - 2))
	return true
end
