local deltaPosition = Vector3d( 0.5, 0, 0.5 )

local function GetListWarpByName()
	local Result = {}
	for k, _ in pairs (warps) do
		table.insert( Result, k )
	end
	return Result
end

local function GetWarpByName( WarpName )
	return warps[WarpName]
end

local function SetWarpByName( WarpName, NeoValue )
	if (WarpsINI:FindKey(WarpName) == cIniFile.noID) then
		WarpsINI:AddKeyName(WarpName)
		WarpsINI:SetValue( WarpName , "w" , NeoValue.w )
		WarpsINI:SetValueI( WarpName , "x" , NeoValue.position.x )
		WarpsINI:SetValueI( WarpName , "y" , NeoValue.position.y )
		WarpsINI:SetValueI( WarpName , "z" , NeoValue.position.z )
		WarpsINI:SetValueI( WarpName , "f" , NeoValue.facing )
		WarpsINI:WriteFile("warps.ini")
		warps[WarpName] = NeoValue
		return true
	end
	return false
end

local function UnsetWarpByName( WarpName )
	if (WarpsINI:FindKey(WarpName) ~= cIniFile.noID) then
		WarpsINI:DeleteKey(WarpName);
		WarpsINI:WriteFile("warps.ini");
		warps[WarpName] = nil
		return true
	end
	return false
end

function LoadChunkAndTeleport( Player, Destination, PostActions )

	PostActions = PostActions or {}
	local OldWorld = Player:GetWorld()
	local DestWorld
	if ( Destination.w ) then
		DestWorld = cRoot:Get():GetWorld(Destination.w)
	else
		DestWorld = OldWorld
	end
	local FinalPosition = Destination.position + deltaPosition

	if Destination.facing then
		table.insert(PostActions, function(Player)
			Player:SetYaw((((Player:GetYaw() + 180 + 45) % 90 + Destination.facing * 90) % 360) - 45 - 180)
		end)
	end

	if DestWorld then
		local PlayerUID = Player:GetUniqueID()
		local OnAllChunksAvailable = function()
			OldWorld:DoWithEntityByID(PlayerUID, function (Entity)
				local a_Player = tolua.cast(Entity, "cPlayer")
				AwaitingPostWarpActions[PlayerUID] = PostActions
				if ( DestWorld ~= OldWorld ) then
					if ( change_gm_when_changing_world == true ) then
						table.insert(PostActions, function(Player)
							Player:SetGameMode(DestWorld:GetGameMode())
						end)
					end
					a_Player:ScheduleMoveToWorld( DestWorld, FinalPosition )
				else
					a_Player:TeleportToCoords( FinalPosition.x, FinalPosition.y, FinalPosition.z )
				end
			end)
		end -- OnAllChunksAvailable
		DestWorld:ChunkStay({{ math.floor(FinalPosition.x / 16), math.floor(FinalPosition.z / 16) }}, nil, OnAllChunksAvailable)
	end
end

local function ExtractWarpName( Parts )
	local Tag = table.concat( Parts, ' ', 2 )
	local Silent = false
	if( Tag:sub(1,1) == '@' ) then
		Tag = Tag:sub(2)
		Silent = true
	end

	return Tag, Silent
end

function HandleWarpCommand( Split, Player )
	if (#Split < 2) then
		-- No warp given, list warps available.
		HandleListWarpCommand( Split, Player )
		return true
	end
	local Tag, Silent = ExtractWarpName( Split )

	local Destination = GetWarpByName( Tag )
	if not(Destination) then
		BackIgnoreNextTP[Player:GetUniqueID()] = nil	-- Set if we were on a misconfigured portal sign
		Player:SendMessageFailure( string.format("Warp %s%s%s doesn't exist, yet.", cChatColor.Gold, Tag, cChatColor.Plain) )
		return true
	end

	local PostActions = {}
	if not(Silent) then
		table.insert(PostActions, function(Player)
			Player:SendMessage( string.format("Warped to %s%s%s.", cChatColor.LightGreen, Tag, cChatColor.Plain) )
		end)
	end

	LoadChunkAndTeleport(Player, Destination, PostActions)

	return true
end

function HandleSetWarpCommand( Split, Player )
	if #Split < 2 then
		Player:SendMessageInfo( string.format("Usage: %s <warpname>", Split[1]) )
		return true
	end
	local Tag = ExtractWarpName( Split )

	local NewWarp = {
		w = Player:GetWorld():GetName(),
		position = Vector3d(Player:GetPosition():Floor()),
		facing = GetFacing(Player)
	}

	if SetWarpByName(Tag, NewWarp) then
		local Destination = GetWarpByName( Tag )
		if not(Destination) then
			Player:SendMessageFatal( string.format("Warp %s%s%s not effectively set !", cChatColor.Gold, Tag, cChatColor.Plain) )
			return true
		end
		Player:SendMessageSuccess( string.format( "Warp %s%s%s set to World: %s [X:%i Y:%i Z:%i]", cChatColor.LightGreen, Tag, cChatColor.Plain, Destination.w, Destination.position.x, Destination.position.y, Destination.position.z) )
	else
		Player:SendMessageFailure( string.format( "Warp %s%s%s already exists or couldn't be set.", cChatColor.LightGreen, Tag, cChatColor.Plain) )
	end
	return true
end

function HandleDelWarpCommand( Split, Player)
	if #Split < 2 then
		Player:SendMessageInfo( string.format("Usage: %s <warp>", Split[1]) )
		return true
	end
	local Tag = ExtractWarpName( Split )
	
	if UnsetWarpByName(Tag) then
		Player:SendMessageSuccess( string.format("Warp %s%s%s was removed.", cChatColor.LightGreen, Tag, cChatColor.Plain) )
	else
		Player:SendMessageFailure( string.format("Warp %s%s%s doesn't exist or couldn't be removed.", cChatColor.LightGreen, Tag, cChatColor.Plain) )
	end
	
	return true
end

function HandleListWarpCommand( Split, Player)
	local Names = GetListWarpByName()
	local FilteredBy = ""
	if (#Split > 1) then
		local Filter = string.lower(table.concat( Split, ' ', 2 ))
		local Filtered = {}
		for _, Name in pairs(Names) do
			if string.find(string.lower(Name), Filter) then
				table.insert(Filtered, Name)
			end
		end
		if (#Filtered == 0) then
			Player:SendMessage( string.format("No warp having a name matching '%s%s%s', try %s to see all warps", cChatColor.LightBlue, Filter, cChatColor.Plain, Split[1] ) )
			return true
		end
		Names = Filtered
		FilteredBy = "filtered by '" .. cChatColor.LightBlue .. Filter .. cChatColor.Plain .. "' "
	end
	table.sort( Names )
	Player:SendMessage( string.format("Warps %s: %s%s", FilteredBy, cChatColor.LightGreen, table.concat( Names, cChatColor.Plain .. ", " .. cChatColor.LightGreen ) ) )
	return true
end
