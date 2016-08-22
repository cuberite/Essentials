function SendMessage(a_Player, a_Message)
	a_Player:SendMessageInfo(a_Message)
end

function SendMessageSuccess(a_Player, a_Message)
	a_Player:SendMessageSuccess(a_Message)
end

function SendMessageFailure(a_Player, a_Message)
	a_Player:SendMessageFailure(a_Message)
end

function GetPlayerLookPos(Player)
	local World = Player:GetWorld()
	local Tracer = cTracer(World)

	local EyePos = Vector3f(Player:GetEyePosition().x, Player:GetEyePosition().y, Player:GetEyePosition().z)
	local EyeVector = Vector3f(Player:GetLookVector().x, Player:GetLookVector().y, Player:GetLookVector().z)
	Tracer:Trace(EyePos , EyeVector, 25)
	return Tracer.BlockHitPosition
end

function GetPlayerLookPosPlace(Player)
	local World = Player:GetWorld()
	local Tracer = cTracer(World)

	local EyePos = Vector3f(Player:GetEyePosition().x, Player:GetEyePosition().y, Player:GetEyePosition().z)
	local EyeVector = Vector3f(Player:GetLookVector().x, Player:GetLookVector().y, Player:GetLookVector().z)
	Tracer:Trace(EyePos , EyeVector, 100)
	return Tracer.BlockHitPosition
end

function GetPlayerLookPos(OtherPlayer)
	local World = OtherPlayer:GetWorld()
	local Tracer = cTracer(World)

	local EyePos = Vector3f(OtherPlayer:GetEyePosition().x, OtherPlayer:GetEyePosition().y, OtherPlayer:GetEyePosition().z)
	local EyeVector = Vector3f(OtherPlayer:GetLookVector().x, OtherPlayer:GetLookVector().y, OtherPlayer:GetLookVector().z)
	Tracer:Trace(EyePos , EyeVector, 25)
	return Tracer.BlockHitPosition
end

function GetFacing(Entity)
	return( math.floor( ((Entity:GetYaw() + 180 + 45) % 360) / 90) )
end

function GetStringFromBiome(Biome)
	if Biome == 0 then
		return "ocean"
	elseif Biome == 1 then
		return "plains"
	elseif Biome == 2 then
		return "desert"
	elseif Biome == 3 then
		return "extreme hills"
	elseif Biome == 4 then
		return "forest"
	elseif Biome == 5 then
		return "taiga"
	elseif Biome == 6 then
		return "swampland"
	elseif Biome == 7 then
		return "river"
	elseif Biome == 8 then
		return "hell"
	elseif Biome == 9 then
		return "sky"
	elseif Biome == 10 then
		return "frozen ocean"
	elseif Biome == 11 then
		return "frozen river"
	elseif Biome == 12 then
		return "ice plains"
	elseif Biome == 13 then
		return "ice mountains"
	elseif Biome == 14 then
		return "mushroom island"
	elseif Biome == 15 then
		return "mushroom island shore"
	elseif Biome == 16 then
		return "beach"
	elseif Biome == 17 then
		return "desert hills"
	elseif Biome == 18 then
		return "forest hills"
	elseif Biome == 19 then
		return "taiga hills"
	elseif Biome == 20 then
		return "extreme hills edge"
	elseif Biome == 21 then
		return "jungle"
	elseif Biome == 22 then
		return "jungle hills"
	elseif Biome == 23 then
		return "jungle edge"
	elseif Biome == 24 then
		return "deep ocean"
	elseif Biome == 25 then
		return "stone beach"
	elseif Biome == 26 then
		return "cold beach"
	elseif Biome == 27 then
		return "birch forest"
	elseif Biome == 28 then
		return "birch forest hills"
	elseif Biome == 29 then
		return "roofed forest"
	elseif Biome == 30 then
		return "cold taiga"
	elseif Biome == 31 then
		return "cold taiga hills"
	elseif Biome == 32 then
		return "mega taiga"
	elseif Biome == 33 then
		return "mega taiga hills"
	elseif Biome == 34 then
		return "extreme hills+"
	elseif Biome == 35 then
		return "savanna"
	elseif Biome == 36 then
		return "savanna plateau"
	elseif Biome == 37 then
		return "mesa"
	elseif Biome == 38 then
		return "mesa plateau f"
	elseif Biome == 39 then
		return "mesa plateau"
	end
end

function IsEnchantable()
	if (HeldItemType >= 256) and (HeldItemType <= 259) then
		return true;
	elseif (HeldItemType >= 267) and (HeldItemType <= 279) then
		return true;
	elseif (HeldItemType >= 283) and (HeldItemType <= 286) then
		return true;
	elseif (HeldItemType >= 290) and (HeldItemType <= 294) then
		return true;
	elseif (HeldItemType >= 298) and (HeldItemType <= 317) then
		return true;
	elseif (HeldItemType >= 290) and (HeldItemType <= 294) then
		return true;
	elseif (HeldItemType == 346) or (HeldItemType == 359) or (HeldItemType == 261) then
		return true;
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
	if UsersINI:GetValue(Player:GetUUID(),   "Jailed") == "true" then
		Jailed[Player:GetUUID()] = true
	else
		Jailed[Player:GetUUID()] = false
	end
	if UsersINI:GetValue(Player:GetUUID(),   "Muted") == "true" then
		Muted[Player:GetUUID()] = true
	else
		Muted[Player:GetUUID()] = false
	end
end
