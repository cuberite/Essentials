function GetPlayerLookPos(Player)
	local World = Player:GetWorld()
	local Tracer = cTracer(World)

	local EyePos = Vector3f(Player:GetEyePosition().x, Player:GetEyePosition().y, Player:GetEyePosition().z)
	local EyeVector = Vector3f(Player:GetLookVector().x, Player:GetLookVector().y, Player:GetLookVector().z)
	Tracer:Trace(EyePos , EyeVector, 25)
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



