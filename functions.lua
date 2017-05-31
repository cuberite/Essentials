function GetPlayerLookPos(Player)
	local World = Player:GetWorld()
	local Start = Player:GetEyePosition()
	local End = Start + Player:GetLookVector() * 150
	local HitCoords = nil
	local Callbacks =
	{
		OnNextBlock = function(X, Y, Z, BlockType)
			if BlockType ~= E_BLOCK_AIR then
				HitCoords = {x = X, y = Y, z = Z}
				return true
			end
		end
	}
	cLineBlockTracer:Trace(World, Callbacks, Start.x, Start.y, Start.z, End.x, End.y, End.z)
	return HitCoords
end

function IsEnchantable()
	if HeldItemType >= 256 and HeldItemType <= 259 then
		return true
	elseif HeldItemType >= 267 and HeldItemType <= 279 then
		return true
	elseif HeldItemType >= 283 and HeldItemType <= 286 then
		return true
	elseif HeldItemType >= 290 and HeldItemType <= 294 then
		return true
	elseif HeldItemType >= 298 and HeldItemType <= 317 then
		return true
	elseif HeldItemType >= 290 and HeldItemType <= 294 then
		return true
	elseif HeldItemType == 346 or HeldItemType == 359 or HeldItemType == 261 then
		return true
	end
end

function GetAverageNum(Table)
	local Sum = 0
	for i,Num in ipairs(Table) do
		Sum = Sum + Num
	end
	return (Sum / #Table)
end

function CheckPlayer(Player)
	if UsersINI:GetValue(Player:GetUUID(), "Jailed") == "true" then
		Jailed[Player:GetUUID()] = true
	else
		Jailed[Player:GetUUID()] = false
	end
	if UsersINI:GetValue(Player:GetUUID(), "Muted") == "true" then
		Muted[Player:GetUUID()] = true
	else
		Muted[Player:GetUUID()] = false
	end
end
