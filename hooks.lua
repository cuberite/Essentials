function OnTakeDamage(Receiver, TDI)
	--Avoid fall damage if player is flying
	Player = tolua.cast(Receiver,"cPlayer")
	if Receiver:IsPlayer() == true and Player:CanFly() == true and TDI.DamageType == dtFalling then
		return true
	end
end

function OnPlayerRightClick(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ)
	local World = Player:GetWorld()
	if(not(Player:GetEquippedItem():IsCustomNameEmpty())) then
		cRoot:Get():GetPluginManager():ExecuteCommand( Player, Player:GetEquippedItem().m_CustomName )
		return true
	end
	--Check for a sign
	local isSign, Line1, Line2, Line3, Line4 = World:GetSignLines(BlockX, BlockY, BlockZ)
	if isSign then
		--If the sign is written like it should, teleport the player
		if Line1 == "[SignWarp]" or Line1 == "[Warp]" then
			cPluginManager:Get():ExecuteCommand(Player, "/warp "..Line2)
			return true
		--If the sign is written like it should, enchant the item
		elseif Line1 == "[Enchant]" and Line2 ~= "" and Line3 ~= "" and Line4 ~= "" then
			HeldItem = Player:GetEquippedItem();
			HeldItemType = HeldItem.m_ItemType;
			ItemEnchant = HeldItem.m_Enchantments;
			level = Player:GetXpLevel();
			Enchantment = cEnchantments:StringToEnchantmentID(Line2);
			MaxLevel = Line3;
			LevelNeeded = Line4;
			CurrentItemLevel = HeldItem.m_Enchantments:GetLevel(Enchantment);
			NextLevel = CurrentItemLevel + 1;
			toremove = tonumber(Line4) * NextLevel
			if CurrentItemLevel == tonumber(Line3) or level < tonumber(Line4) then
				return false
			else
				if IsEnchantable() == true then
					ItemEnchant:SetLevel(Enchantment, NextLevel)
					Player:GetInventory():SetHotbarSlot(Player:GetInventory():GetEquippedSlotNum(), HeldItem)
					Player:DeltaExperience(-toremove * 17)
					Player:SendMessageSuccess("Successfully enchanted item")
				else
					Player:SendMessageWarning("This item is not enchantable")
				end
			end
		--If the sign is written like it should, execute the command
		elseif Line1 == "[Command]" then
			if Line3 ~= "" then
				if Line4 ~= "" then
					cPluginManager:Get():ExecuteCommand(Player, Line2..Line3..Line4)
					return true
				end
				cPluginManager:Get():ExecuteCommand(Player, Line2..Line3)
				return true
			end
			cPluginManager:Get():ExecuteCommand(Player, Line2)
			return true
		end
	end
end

function OnUpdatingSign(World, BlockX, BlockY, BlockZ, Line1, Line2, Line3, Line4, Player)
	--Avoid creating of warp signs by non-allowed users
	if Line1 == "[SignWarp]" or Line1 == "[Warp]" then
		if (not(Player:HasPermission("es.warpsign") == true)) then
			return true
		elseif (Line2 == "") then
			Player:SendMessageFailure('Must supply a tag for the warp.')
			return true
		end
	elseif Line1 == "[Portal]" then
		if (not(Player:HasPermission("es.createportal") == true)) then
			return true
		elseif (Line2 == "") then
			Player:SendMessageFailure('Must supply a warp to teleport.')
			return true
		end
	elseif Line1 == "[Enchant]" then
		if (not(Player:HasPermission("es.enchantsign") == true)) then
			return true
		end
	elseif Line1 == "[Command]" then
		if (not(Player:HasPermission("es.commandsign") == true)) then
			return true
		elseif (Line2 == "") then
			Player:SendMessageFailure('Must supply a command to execute.')
			return true
		end
	end
end

function OnPlayerBreakingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, BlockType, BlockMeta)
	if (Jailed[Player:GetUUID()] == true) and (IsDiggingEnabled == false) then 
		Player:SendMessageWarning("You are jailed")
		return true
	else
		return false
	end
end

function OnPlayerPlacingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ, BlockType)
	if (Jailed[Player:GetUUID()] == true) and (IsPlaceEnabled == false) then 
		Player:SendMessageWarning("You are jailed")
		return true
	else 
		return false
	end
end

function OnExecuteCommand(Player, CommandSplit)
	if Player == nil then
		return false
	elseif (Jailed[Player:GetUUID()] == true) and (AreCommandsEnabled == false) then
		Player:SendMessageWarning("You are jailed") 
		return true
	end

	local DisplayCommand = function(OtherPlayer)
		if SocialSpyList[OtherPlayer:GetUUID()] ~= nil then
			OtherPlayer:SendMessage(cChatColor.Gray .. "[" .. cChatColor.LightGray .. Player:GetName() .. cChatColor.Gray .. "] " .. cChatColor.White .. EntireCommand)
		end
	end

	if CommandSplit[1] == "/msg" and CommandSplit[2] ~= nil and CommandSplit[3] ~= nil or CommandSplit[1] == "/r" and CommandSplit[2] ~= nil or CommandSplit[1] == "/tell" and CommandSplit[2] ~= nil and CommandSplit[3] ~= nil then
		cRoot:Get():ForEachPlayer(DisplayCommand)
	end
end

function OnChat(Player, Message)
	if Muted[Player:GetUUID()] == true then 
		Player:SendMessageWarning("You are muted")
		return true
	elseif (Jailed[Player:GetUUID()] == true) and (IsChatEnabled == false) then 
		Player:SendMessageWarning("You are jailed")
		return true
	else 
		return false
	end
end

function EverySecond(World)

	-- Check if there's a Portal sign two blocks above any player and teleport if so
	local ScanForPortalSign = function(Player)
		local YBelowUs2 = Player:GetPosY() - 2
		if YBelowUs2 >= 0 then
			local pX = math.floor(Player:GetPosX())
			local pZ = math.floor(Player:GetPosZ())
			local isSign, Line1, Line2, Line3, Line4 = World:GetSignLines(pX, YBelowUs2, pZ)
			if isSign then
				if (Line1 == "[Portal]") then
					BackIgnoreNextTP[Player:GetUniqueID()] = true
					if Line4 ~= "" then
						local SignDestination = { position = Vector3d(1.0* Line2, 1.0* Line3, 1.0* Line4) }
						LoadChunkAndTeleport(Player, SignDestination)
					else
						cPluginManager:Get():ExecuteCommand(Player, "/warp "..Line2)
					end
				end
			end
		end
	end -- scanPortal()
	World:ForEachPlayer(ScanForPortalSign)

	World:ScheduleTask(20, EverySecond)
end

function OnWorldTick(World, TimeDelta)
	local WorldName = World:GetName()

	--Tps checking code--
	local WorldTps = TpsCache[WorldName]
	if (WorldTps == nil) then
		WorldTps = {}
		TpsCache[WorldName] = WorldTps
	end

	if (#WorldTps >= 10) then
		table.remove(WorldTps, 1)
	end

	table.insert(WorldTps, 1000 / TimeDelta)

end


function OnTick(TimeDelta)
	if (#GlobalTps >= 10) then
		table.remove(GlobalTps, 1)
	end

	table.insert(GlobalTps, 1000 / TimeDelta)
end

function RecordBackCoords( Player, Coordinates )
	local Coords

	if not(Coordinates) then
		Coords = {
			w = Player:GetWorld():GetName(),
			position = Vector3d(Player:GetPosition():Floor()),
			facing = GetFacing(Player)
		}
	else
		Coords = {
			w = Player:GetWorld():GetName(),
			position = Vector3d(Coordinates:Floor()),
			facing = GetFacing(Player)
		}
	end
	BackCoords[Player:GetName()] = Coords
end

local function CallAwaitingPostWarpActions(Player)
	local PlayerUID = Player:GetUniqueID()
	local PostActions = AwaitingPostWarpActions[PlayerUID]
	if PostActions then
		AwaitingPostWarpActions[PlayerUID] = nil
		for _, fn in ipairs(PostActions) do
			fn(Player)
		end
	end
end

function OnEntityChangedWorld(Entity, OldWorld)
	if Entity:IsPlayer() then
		local Player = tolua.cast(Entity, "cPlayer")
		CallAwaitingPostWarpActions(Player)
	end
end

function OnEntityTeleport(Entity, OldPosition, NewPosition)
	if Entity:IsPlayer() then
		local Player = tolua.cast(Entity, "cPlayer")
		local PlayerUID = Player:GetUniqueID()

		if BackIgnoreNextTP[PlayerUID] then
			BackIgnoreNextTP[PlayerUID] = nil
		else
			RecordBackCoords( Player, OldPosition )
		end

		CallAwaitingPostWarpActions(Player)
	end
	return false
end

function OnKilled(Victim, TDI, DeathMessage)
	if Victim:IsPlayer() then
		Player = tolua.cast(Victim, "cPlayer")
		RecordBackCoords(Player)
	end
end

function OnPlayerSpawned(Player)
	if not(BackCoords[Player:GetName()]) then
		RecordBackCoords(Player)
	end
end

function OnPlayerJoined(Player)
	CheckPlayer(Player)
end
