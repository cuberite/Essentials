function HandleMoreCommand(Split, Player)
	local AddMoreItems = function(OtherPlayer)
		local HeldItem = Player:GetEquippedItem()
		if HeldItem:IsEmpty() then
			if Split[2] then
				Player:SendMessageFailure("Player \"" .. OtherPlayer:GetName() .. "\" isn't holding an item")
			else
				OtherPlayer:SendMessageFailure("Please hold an item")
			end
		else
			HeldItem.m_ItemCount = 64
			Player:GetInventory():SetHotbarSlot(Player:GetInventory():GetEquippedSlotNum(), HeldItem)
			OtherPlayer:SendMessageSuccess("Held item number set to 64")
			if Split[2] then
				Player:SendMessageSuccess("Successfully set held item number of player \"" .. OtherPlayer:GetName() .. "\" to 64")
			end
		end
	end
	if Split[2] == nil then
		AddMoreItems(Player)
	elseif Player:HasPermission("es.more.other") then
		if Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], AddMoreItems) then
			Player:SendMessageFailure("Player \"" .. Split[2] .. "\" not found")
		end
	end
	return true
end

function HandleRepairCommand(Split, Player)
	local Item = Player:GetEquippedItem()
	if Item:IsDamageable() then
		--Give a new item with the same type than the actual but with 0 damage, this way we avoid relogging
		Item.m_ItemDamage = 0
		Player:GetInventory():SetHotbarSlot(Player:GetInventory():GetEquippedSlotNum(), Item)
		Player:SendMessageSuccess("Successfully repaired item")
	else
		Player:SendMessageFailure("Please hold a repairable item")
	end
	return true
end

function HandleFeedCommand(Split, Player)
	local Feed = function(OtherPlayer)
		OtherPlayer:SetFoodLevel(20)
		OtherPlayer:SendMessageSuccess("Your hunger has been satisfied")
		if Split[2] and Split[2] ~= "*" and Split[2] ~= "**" then
			Player:SendMessageSuccess("Successfully fed player \"" .. OtherPlayer:GetName() .. "\"")
		end
	end
	if Split[2] == nil then
		Feed(Player)
	elseif Split[2] == "*" or Split[2] == "**" then
		cRoot:Get():ForEachPlayer(Feed)
		Player:SendMessageInfo("Successfully fed all players")
	elseif Player:HasPermission("es.feed.other") then
		if Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], Feed) then
			Player:SendMessageFailure("Player \"" .. Split[2] .. "\" not found")
		end
	end
	return true
end

function HandleHealCommand(Split, Player)
	local Heal = function(OtherPlayer)
		OtherPlayer:SetFoodLevel(20)
		OtherPlayer:Heal(20)
		OtherPlayer:ClearEntityEffects()
		OtherPlayer:SendMessageInfo("You have been healed")
		if Split[2] and Split[2] ~= "*" and Split[2] ~= "**" then
			Player:SendMessageSuccess("Successfully healed player \"" .. OtherPlayer:GetName() .. "\"")
		end
	end
	if Split[2] == nil then
		Heal(Player)
	elseif Split[2] == "*" or Split[2] == "**" then
		cRoot:Get():ForEachPlayer(Heal)
		Player:SendMessageSuccess("Successfully healed all players")
	elseif Player:HasPermission("es.heal.other") then
		if Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], Heal) then
			Player:SendMessageFailure("Player \"" .. Split[2] .. "\" not found")
		end
	end
	return true
end

function HandleXPCommand(Split, Player)
	local HandleXP = function(OtherPlayer)
		if Split[2] == "show" then
			Player:SendMessageSuccess("The current XP of player \"" .. OtherPlayer:GetName() .. "\" is ".. OtherPlayer:GetCurrentXp())
		elseif Split[2] == "set" then
			if tonumber(Split[4]) == nil then
				Player:SendMessageFailure("\"" .. Split[4] .. "\" is not a valid number")
			else
				--Set player XP to the specified amount
				OtherPlayer:SetCurrentExperience(Split[4])
				Player:SendMessageSuccess("Successfully set XP of player \"" .. OtherPlayer:GetName() .. "\" to ".. Split[4])
			end
		elseif Split[2] == "give" then
			if tonumber(Split[4]) == nil then
				Player:SendMessageFailure("\"" .. Split[4] .. "\" is not a valid number")
			else
				OtherPlayer:SetCurrentExperience(Player:GetCurrentXp() + Split[4])
				Player:SendMessageSuccess("Successfully gave " .. Split[4] .. " XP to player \"" .. OtherPlayer:GetName() .. "\"")
			end
		end
	end
	if Split[2] == nil then
		Player:SendMessageInfo("Usage: " .. Split[1] .. " <show|set|give> <player> [value]")	
	elseif Split[3] == nil or Split[2] ~= "show" and Split[4] == nil then
		if Split[2] == "show" then
			Player:SendMessageInfo("Usage: " .. Split[1] .. " " .. Split[2] .. " <player>")
		else
			Player:SendMessageInfo("Usage: " .. Split[1] .. " " .. Split[2] .. " <player> <value>")
		end
	else
		if Split[3] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[3], HandleXP) then
			Player:SendMessageFailure("Player \"" .. Split[3] .. "\" not found")
		end
	end
	return true
end

function HandleHatCommand(Split, Player)
	local Hat = cItem(Player:GetEquippedItem())
	Hat.m_ItemCount = 1
	local ArmorSlot = Player:GetInventory():GetArmorSlot(0)
	if not ArmorSlot:IsEmpty() then
		Player:GetInventory():AddItem(ArmorSlot)
	end
	--Set chestplate slot to the item the player is holding
	if not Player:GetEquippedItem():IsEmpty() then
		Player:GetInventory():SetArmorSlot(0, Hat)
		Player:GetInventory():RemoveOneEquippedItem()
		Player:SendMessageSuccess("Enjoy your new hat!")
	else
		Player:SendMessageFailure("Please hold an item")
	end
	return true
end

function HandleSpeedCommand(Split, Player)
	local SpeedType = Split[1]:gsub("/", ""):gsub("speed", "")
	local Speed = Split[2]
	local PlayerName = Split[3]
	if Split[1] == "/speed" then
		SpeedType = Split[2]
		Speed = Split[3]
		PlayerName = Split[4]
	end
	local SetSpeed = function(OtherPlayer)
		if tonumber(Speed) == nil then
			Player:SendMessageFailure("\"" .. Speed .. "\" is not a valid number")
		else
			--Set new speed
			if tonumber(Speed) > 100 then
				Speed = 100
			end
			if Split[1] == "/flyspeed" or Split[1] == "/speed" and Split[2] == "fly" then
				OtherPlayer:SetFlyingMaxSpeed(Speed)
			elseif Split[1] == "/walkspeed" or Split[1] == "/speed" and Split[2] == "walk" then
				OtherPlayer:SetNormalMaxSpeed(Speed)
			elseif Split[1] == "/runspeed" or Split[1] == "/speed" and Split[2] == "run" then
				OtherPlayer:SetSprintingMaxSpeed(Speed)
			end
			OtherPlayer:SendMessageSuccess("Your " .. SpeedType .. " speed has been set to " .. Speed)
			if PlayerName then
				Player:SendMessageSuccess("Successfully set " .. SpeedType .. " speed of player \"" .. OtherPlayer:GetName() .. "\" to " .. Speed)
			end
		end
	end
	if Speed == nil then
		if Split[1] == "/speed" then
			if SpeedType then
				Player:SendMessageInfo("Usage: " .. Split[1] .. " " .. SpeedType .. " <speed> [player]")
			else
				Player:SendMessageInfo("Usage: " .. Split[1] .. " <fly|walk|run> <speed> [player]")	
			end
		else
			Player:SendMessageInfo("Usage: " .. Split[1] .. " <speed> [player]")
		end
	elseif PlayerName == nil then
		SetSpeed(Player)
	else
		if PlayerName == "" or not cRoot:Get():FindAndDoWithPlayer(PlayerName, SetSpeed) then
			Player:SendMessageFailure("Player \"" .. PlayerName .. "\" not found")
		end
	end
	return true
end

function HandleFlyCommand(Split, Player)
	local ToggleFly = function(OtherPlayer)
		OtherPlayer:SetCanFly(not OtherPlayer:CanFly())
		if OtherPlayer:CanFly() then
			OtherPlayer:SendMessageSuccess("Fly mode has been enabled")
		else
			OtherPlayer:SendMessageSuccess("Fly mode has been disabled")
		end
		if Split[2] then
			if OtherPlayer:CanFly() then
				Player:SendMessageSuccess("Successfully enabled fly mode for player \"" .. OtherPlayer:GetName() .. "\"")
			else
				Player:SendMessageSuccess("Successfully disabled fly mode for player \"" .. OtherPlayer:GetName() .. "\"")
			end
		end
	end
	if Split[2] == nil then
		ToggleFly(Player)
	elseif Player:HasPermission("es.fly.other") then
		if Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], ToggleFly) then
			Player:SendMessageFailure("Player \"" .. Split[2] .. "\" not found")
		end
	end
	return true
end

function HandleVanishCommand(Split, Player)
	local ToggleVanish = function(OtherPlayer)
		OtherPlayer:SetVisible(not OtherPlayer:IsVisible())
		if OtherPlayer:IsVisible() then
			OtherPlayer:SendMessageSuccess("You aren't hidden anymore")
		else
			OtherPlayer:SendMessageSuccess("You are now hidden")
		end
		if Split[2] then
			if OtherPlayer:IsVisible() then
				Player:SendMessageSuccess("Successfully enabled visibility for player \"" .. OtherPlayer:GetName() .. "\"")
			else
				Player:SendMessageSuccess("Successfully disabled visibility for player \"" .. OtherPlayer:GetName() .. "\"")
			end
		end
	end
	if Split[2] == nil then
		ToggleVanish(Player)
	elseif Player:HasPermission("es.vanish.other") then
		if Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], ToggleVanish) then
			Player:SendMessageFailure("Player \"" .. Split[2] .. "\" not found")
		end
	end
	return true
end

function HandlePowertoolCommand(Split, Player)
	local HeldItem = Player:GetEquippedItem()
	if Split[2] == nil then
		Player:SendMessageInfo("Usage: " .. Split[1] .. " <command> [arguments ...]")
	elseif not HeldItem:IsEmpty() then
		string.startswith = function(self, str) 
			return self:find("^" .. str) ~= nil
		end
		if table.concat(Split, " ", 2):startswith("/") then
			HeldItem.m_CustomName = table.concat(Split, " ", 2)
		else
			HeldItem.m_CustomName = "/" .. table.concat(Split, " ", 2)
		end
		Player:GetInventory():SetHotbarSlot(Player:GetInventory():GetEquippedSlotNum(), HeldItem)
		Player:SendMessageSuccess("Successfully bound command to item")
	else
		--If player doesn't hold an item, notify
		Player:SendMessageFailure("Please hold an item")
	end
	return true
end

function HandleFireballCommand(Split, Player)
	local World = Player:GetWorld()
	local X = Player:GetPosX()
	local Y = Player:GetPosY() + 1.5
	local Z = Player:GetPosZ()
	local Speed = Player:GetLookVector() * 30
	if Split[2] == "small" then
		World:CreateProjectile(X, Y, Z, cProjectileEntity.pkFireCharge, Player, Player:GetEquippedItem(), Speed)
	else
		World:CreateProjectile(X, Y, Z, cProjectileEntity.pkGhastFireball, Player, Player:GetEquippedItem(), Speed)
	end
	return true
end

function HandleNukeCommand(Split, Player)
	local SpawnNuke = function(OtherPlayer)
		local X = OtherPlayer:GetPosX()
		local Y = OtherPlayer:GetPosY() + 35
		local Z = OtherPlayer:GetPosZ()
		OtherPlayer:SendMessageInfo("May death rain upon them")
		for x = -3, 3, 3 do
			for z = -3, 3, 3 do
				OtherPlayer:GetWorld():SpawnPrimedTNT(X + x, Y, Z + z, 52)
			end
		end
		if Split[2] then
			Player:SendMessageSuccess("Successfully spawned nuke above player " ..OtherPlayer:GetName())
		end
	end
	if Split[2] == nil then
		cRoot:Get():ForEachPlayer(SpawnNuke)
	else
		if not cRoot:Get():FindAndDoWithPlayer(table.concat(Split, " ", 2), SpawnNuke) then
			Player:SendMessageFailure("Player \"" .. table.concat(Split, " ", 2) ..  "\" not found")
		end
	end
	return true
end

function HandleGodCommand(Split, Player)
	local EnableGod = function(OtherPlayer)
		if GodModeList[OtherPlayer:GetUUID()] == nil then
			OtherPlayer:SetInvulnerableTicks(6048000)
			OtherPlayer:SendMessageSuccess("God mode has been enabled")
			if Split[2] then
				Player:SendMessageSuccess("Successfully enabled God mode for " .. OtherPlayer:GetName())
			end
			GodModeList[OtherPlayer:GetUUID()] = true
		else
			OtherPlayer:SetInvulnerableTicks(0)
			OtherPlayer:SendMessageSuccess("God mode has been disabled")
			if Split[2] then
				Player:SendMessageSuccess("Successfully disabled God mode for " .. OtherPlayer:GetName())
			end
			GodModeList[OtherPlayer:GetUUID()] = nil
		end
	end
	if Split[2] == nil then
		EnableGod(Player)
	elseif Player:HasPermission("es.god.other") then
		if Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], EnableGod) then
			Player:SendMessageFailure("Player \"" .. Split[2] ..  "\" not found")
		end
	end
	return true
end

function HandleGamemodeCommand(Split, Player)
	local ChangeGamemode = function(OtherPlayer)
		if Split[1] == "/adventure" or Split[1] == "/gma" then
			if Player:HasPermission("es.gm.adventure.other") then
				OtherPlayer:SetGameMode(2)
				OtherPlayer:SendMessageInfo("Gamemode set to adventure")
				if Split[2] then
					Player:SendMessageSuccess("Successfully set gamemode of player \"" .. OtherPlayer:GetName() .. "\" to adventure")
				end
			end
		elseif Split[1] == "/creative" or Split[1] == "/gmc" then
			if Player:HasPermission("es.gm.creative.other") then
				OtherPlayer:SetGameMode(1)
				OtherPlayer:SendMessageInfo("Gamemode set to creative")
				if Split[2] then
					Player:SendMessageSuccess("Successfully set gamemode of player \"" .. OtherPlayer:GetName() .. "\" to creative")
				end
			end
		elseif Split[1] == "/spectator" or Split[1] == "/gmsp" then
			if Player:HasPermission("es.gm.spectator.other") then
				OtherPlayer:SetGameMode(3)
				OtherPlayer:SendMessageInfo("Gamemode set to spectator")
				if Split[2] then
					Player:SendMessageSuccess("Successfully set gamemode of player \"" .. OtherPlayer:GetName() .. "\" to spectator")
				end
			end
		elseif Split[1] == "/survival" or Split[1] == "/gms" then
			if Player:HasPermission("es.gm.survival.other") then
				OtherPlayer:SetGameMode(0)
				OtherPlayer:SendMessageInfo("Gamemode set to survival")
				if Split[2] then
					Player:SendMessageSuccess("Successfully set gamemode of player \"" .. OtherPlayer:GetName() .. "\" to survival")
				end
			end
		end
	end
	if Split[2] == nil then
		ChangeGamemode(Player)
	else
		if Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], ChangeGamemode) then
			Player:SendMessageFailure("Player \"" .. Split[2] ..  "\" not found")
		end
	end
	return true
end
