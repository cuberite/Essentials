function OnTakeDamage(Receiver, TDI)
	--Avoid fall damage if player is flying
	if Receiver:IsPlayer() and Receiver:CanFly() and TDI.DamageType == dtFalling then
		return true
	end
end

function OnPlayerRightClick(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ)
	local World = Player:GetWorld()
	if not Player:GetEquippedItem():IsCustomNameEmpty() then
		cRoot:Get():GetPluginManager():ExecuteCommand(Player, Player:GetEquippedItem().m_CustomName)
	end
	local Read, Line1, Line2, Line3, Line4 = World:GetSignLines(BlockX, BlockY, BlockZ)
	--If the sign is written like it should, teleport the player
	if Line1 == "[SignWarp]" or Line1 == "[Warp]" then
		cPluginManager:Get():ExecuteCommand(Player, "/warp " .. Line2)
		return true
	--If the sign is written like it should, enchant the item
	elseif Line1 == "[Enchant]" and Line2 ~= "" and Line3 ~= "" and Line4 ~= "" then
		local HeldItem = Player:GetEquippedItem()
		HeldItemType = HeldItem.m_ItemType
		local ItemEnchant = HeldItem.m_Enchantments
		local Enchantment = cEnchantments:StringToEnchantmentID(Line2)
		local CurrentItemLevel = HeldItem.m_Enchantments:GetLevel(Enchantment)
		local NextLevel = CurrentItemLevel + 1
		local toremove = tonumber(Line4) * NextLevel
		if IsEnchantable() then
			ItemEnchant:SetLevel(Enchantment, NextLevel)
			Player:GetInventory():SetHotbarSlot(Player:GetInventory():GetEquippedSlotNum(), HeldItem)
			Player:DeltaExperience(-toremove * 17)
			Player:SendMessageSuccess("Successfully enchanted item")
		else
			Player:SendMessageWarning("This item is not enchantable")
		end
		return true
	--If the sign is written like it should, execute the command
	elseif Line1 == "[Command]" then
		cPluginManager:Get():ExecuteCommand(Player, Line2 .. Line3 .. Line4)
		return true
	end
end

function OnUpdatingSign(World, BlockX, BlockY, BlockZ, Line1, Line2, Line3, Line4, Player)
	--Avoid creating of warp signs by non-allowed users
	if Line1 == "[SignWarp]" or Line1 == "[Warp]" then
		if not Player:HasPermission("es.warpsign") then
			Player:SendMessageFailure("You do not have permission to create a warp sign")
			return true
		elseif Line2 == "" then
			Player:SendMessageFailure("You must specify a warp name")
			return true
		end
	elseif Line1 == "[Portal]" then
		if not Player:HasPermission("es.createportal") then
			Player:SendMessageFailure("You do not have permission to create a portal sign")
			return true
		elseif Line2 == "" then
			Player:SendMessageFailure("You must specify a warp name")
			return true
		end
	elseif Line1 == "[Enchant]" then
		if not Player:HasPermission("es.enchantsign") then
			Player:SendMessageFailure("You do not have permission to create an enchant sign")
			return true
		end
	elseif Line1 == "[Command]" then
		if not Player:HasPermission("es.commandsign") then
			Player:SendMessageFailure("You do not have permission to create a command sign")
			return true
		elseif Line2 == "" then
			Player:SendMessageFailure("You must specify a command to execute")
			return true
		end
	end
end

function OnPlayerBreakingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, BlockType, BlockMeta)
	if Jailed[Player:GetUUID()] and not IsDiggingEnabled then 
		Player:SendMessageInfo("You are not allowed to build while jailed")
		return true
	end
end

function OnPlayerPlacingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ, BlockType)
	if Jailed[Player:GetUUID()] and not IsPlaceEnabled then 
		Player:SendMessageInfo("You are not allowed to build while jailed")
		return true
	end
end

function OnExecuteCommand(Player, CommandSplit)
	if Player and Jailed[Player:GetUUID()] and not AreCommandsEnabled then
		Player:SendMessageInfo("You are not allowed to use commands while jailed") 
		return true
	end

	local DisplayCommand = function(OtherPlayer)
		if SocialSpyList[OtherPlayer:GetUUID()] ~= nil then
			OtherPlayer:SendMessage(cChatColor.Gray .. "[" .. cChatColor.LightGray .. Player:GetName() .. cChatColor.Gray .. "] " .. cChatColor.White .. table.concat(CommandSplit , " " , 1))
		end
	end

	if CommandSplit[1] == "/msg" and CommandSplit[2] ~= nil and CommandSplit[3] ~= nil or CommandSplit[1] == "/r" and CommandSplit[2] ~= nil or CommandSplit[1] == "/tell" and CommandSplit[2] ~= nil and CommandSplit[3] ~= nil then
		cRoot:Get():ForEachPlayer(DisplayCommand)
	end
end

function OnChat(Player, Message)
	if Muted[Player:GetUUID()] then 
		Player:SendMessageInfo("You are muted")
		return true
	elseif Jailed[Player:GetUUID()] and not IsChatEnabled then 
		Player:SendMessageInfo("You are not allowed to chat while jailed")
		return true
	end
end

function OnWorldTick(World, TimeDelta)
	--Check each 20 ticks if there's a sign above the player, if there is, teleport
	if PortalTimer[World:GetName()] == nil then
		PortalTimer[World:GetName()] = 0
	elseif PortalTimer[World:GetName()] == 20 then
		local CheckPortal = function(Player)
			local CheckPortalPos = Player:GetPosY() - 2
			local Read, Line1, Line2, Line3, Line4 = World:GetSignLines(Player:GetPosX(), CheckPortalPos, Player:GetPosZ())
			if Line1 == "[Portal]" then
				if Line4 ~= "" then
					Player:TeleportToCoords(Line2, Line3, Line4)
				else
					cPluginManager:Get():ExecuteCommand(Player, "/warp " .. Line2)
				end
			end
		end
		World:ForEachPlayer(CheckPortal)
		PortalTimer[World:GetName()] = 0
	else
		PortalTimer[World:GetName()] = PortalTimer[World:GetName()] + 1
	end
end

function OnEntityChangingWorld(Entity, World)
	if Entity:IsPlayer() then
		BackWorld[Entity:GetName()] = Entity:GetWorld()
		BackCoords[Entity:GetName()] = Vector3d(Entity:GetPosX(), Entity:GetPosY(), Entity:GetPosZ())
	end
end

function OnEntityTeleport(Entity, OldPosition, NewPosition)
	if Entity:IsPlayer() then
		BackWorld[Entity:GetName()] = Entity:GetWorld()
		BackCoords[Entity:GetName()] = Vector3d(OldPosition)
	end
end

function OnKilled(Victim, TDI, DeathMessage)
	if Victim:IsPlayer() then
		BackWorld[Victim:GetName()] = Victim:GetWorld()
		BackCoords[Victim:GetName()] = Vector3d(Victim:GetPosX(), Victim:GetPosY(), Victim:GetPosZ())
	end
end

function OnPlayerJoined(Player)
	CheckPlayer(Player)
end
