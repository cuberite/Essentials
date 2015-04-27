function HandleHomeCommand(Split, Player)
	username = Player:GetName()
	if Split[2] ~= nil and Player:HasPermission("es.home.unlimited") == true and file_exists(homeDir..'/'..username..'.'..Split[2]) == true then
		coords = lines_from(homeDir..'/'..username..'.'..Split[2])
		Player:SendMessageSuccess('Teleporting you to home...')
		Player:TeleportToCoords(coords[1], coords[2], coords[3])
		if Player:GetWorld():GetName() ~= coords[4] then
			Player:MoveToWorld(coords[4])
		end
	elseif file_exists(homeDir..'/'..username..'.home') then
		coords = lines_from(homeDir..'/'..username..'.home')
		Player:SendMessageSuccess('Teleporting you to home...')
		Player:TeleportToCoords(coords[1], coords[2], coords[3])
		if Player:GetWorld():GetName() ~= coords[4] then
			Player:MoveToWorld(coords[4])
		end
	else
		Player:SendMessageFailure("Home doesn't exist")
	end
	return true
end

function HandleSetHomeCommand(Split, Player)
	username = Player:GetName()
	homeX = Player:GetPosX()
	homeY = Player:GetPosY()
	homeZ = Player:GetPosZ()
	if Split[2] ~= nil and Player:HasPermission("es.home.unlimited") == true then
		local file = io.open(homeDir..'/'..username..'.'..Split[2], "w")
		file:write(homeX..'\n'..homeY..'\n'..homeZ..'\n'..Player:GetWorld():GetName())
		file:close()
		Player:SendMessageSuccess('Home set! use /home to go home!')	
	else
		local file = io.open(homeDir..'/'..username..'.home', "w")
		file:write(homeX..'\n'..homeY..'\n'..homeZ..'\n'..Player:GetWorld():GetName())
		file:close()
		Player:SendMessageSuccess('Home set! use /home to go home!')	
	end
	return true
end

function HandleDelHomeCommand(Split, Player)
	username = Player:GetName()
	if Split[2] ~= nil and Player:HasPermission("es.home.unlimited") == true then
		os.remove(homeDir..'/'..username..'.'..Split[2], "w")
		Player:SendMessageSuccess("Home removed")	
	else
		os.remove(homeDir..'/'..username..'.home', "w")
		Player:SendMessageSuccess("Home removed")		
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
