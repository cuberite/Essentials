function HandleHomeCommand(Split, Player)
	local UUID = Player:GetUUID()
	local World = Player:GetWorld():GetName()
	if Split[2] and Player:HasPermission("es.home.unlimited") and file_exists(HomesFolder .. "/" .. UUID .. "." .. Split[2]) then
		local Coords = lines_from(HomesFolder .. "/" .. UUID .. "." .. Split[2])
		if World ~= Coords[4] then
			Player:MoveToWorld(cRoot:Get():GetWorld(Coords[4]), true, Vector3d(Coords[1], Coords[2], Coords[3]))
		else
			Player:TeleportToCoords(Coords[1], Coords[2], Coords[3])
		end
		Player:SendMessageSuccess("Teleported you to \"" .. Split[2] .. "\" home")
	elseif file_exists(HomesFolder .. "/" .. UUID .. ".home") then
		local Coords = lines_from(HomesFolder .. "/" .. UUID .. ".home")
		if World ~= Coords[4] then
			Player:MoveToWorld(cRoot:Get():GetWorld(Coords[4]), true, Vector3d(Coords[1], Coords[2], Coords[3]))
		else
			Player:TeleportToCoords(Coords[1], Coords[2], Coords[3])
		end
		Player:SendMessageSuccess("Teleported you home")
	else
		Player:SendMessageFailure("That home doesn't exist")
	end
	return true
end

function HandleSetHomeCommand(Split, Player)
	local UUID = Player:GetUUID()
	local PosX = Player:GetPosX()
	local PosY = Player:GetPosY()
	local PosZ = Player:GetPosZ()
	local World = Player:GetWorld():GetName()
	if Split[2] and Player:HasPermission("es.home.unlimited") then
		local file = io.open(HomesFolder .. "/" .. UUID .. "." .. Split[2], "w")
		file:write(PosX .. "\n" .. PosY .. "\n" .. PosZ .. "\n" .. World)
		file:close()
		Player:SendMessageSuccess("Successfully set home \"" .. Split[2] .. "\". Use \"/home " .. Split[2] .. "\" to teleport to it.")	
	else
		local file = io.open(HomesFolder .. "/" .. UUID .. ".home", "w")
		file:write(PosX .. "\n" .. PosY .. "\n" .. PosZ .. "\n" .. World)
		file:close()
		Player:SendMessageSuccess("Successfully set main home. Use \"/home\" to teleport to it.")	
	end
	return true
end

function HandleDelHomeCommand(Split, Player)
	local UUID = Player:GetUUID()
	if Split[2] and Player:HasPermission("es.home.unlimited") and file_exists(HomesFolder .. "/" .. UUID .. "." .. Split[2]) then
		os.remove(HomesFolder .. "/" .. UUID .. "." .. Split[2], "w")
		Player:SendMessageSuccess("Successfully removed home \"" ..Split[2] .. "\"")	
	elseif file_exists(HomesFolder .. "/" .. UUID .. ".home") then
		os.remove(HomesFolder .. "/" .. UUID .. ".home", "w")
		Player:SendMessageSuccess("Successfully removed main home")	
	else
		Player:SendMessageFailure("That home doesn't exist")
	end
	return true
end

function file_exists(file)
	local f = io.open(file, "rb")
	if f then
		f:close()
		return true
	end
	return f ~= nil
end

function lines_from(file)
	if not file_exists(file) then return {} end
	lines = {}
	for line in io.lines(file) do 
		lines[#lines + 1] = line
	end
	return lines
end
