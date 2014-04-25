function HandleJailCommand( Split, Player )
	local UsersIni = cIniFile()
	if UsersIni:ReadFile("users.ini") == false then
		LOG( "Could not read users.ini!" )
	end
	if #Split < 2 and #Split < 3 then
		HandleListJailCommand( Split, Player )
		return true
	end
	if #Split < 2 or #Split < 3  then
		Player:SendMessage('Usage:/jail [player] [jail]')
		return true
	end
	local Tag = Split[3]

      Jailed = false
      local JailPlayer = function(OtherPlayer)
		if (OtherPlayer:GetName() == Split[2]) then
	          if (OtherPlayer:GetWorld():GetName() ~= jails[Tag]["w"]) then
	              OtherPlayer:TeleportToCoords( jails[Tag]["x"] + 0.5 , jails[Tag]["y"] , jails[Tag]["z"] + 0.5)
		        OtherPlayer:MoveToWorld(jails[Tag]["w"])
                    Jailed = true
                end

	          OtherPlayer:TeleportToCoords( jails[Tag]["x"] + 0.5 , jails[Tag]["y"] , jails[Tag]["z"] + 0.5)
	          OtherPlayer:SendMessage(cChatColor.Red .. 'You have been jailed')
                UsersIni:DeleteValue(OtherPlayer:GetName(),   "Jailed")
                UsersIni:SetValue(OtherPlayer:GetName(),   "Jailed",   "true")
                UsersIni:WriteFile("users.ini")
                Jailed = true
	          return true

		 end
	end
      cRoot:Get():FindAndDoWithPlayer(Split[2], JailPlayer);
	if (Jailed) then
          Player:SendMessage("Player "..Split[2].." is jailed")
          return true
      else
          Player:SendMessage(cChatColor.Red .. "Player not found")
	if jails[Tag] == nil then 
		Player:SendMessage(cChatColor.Red .. 'Jail "' .. Tag .. '" is invalid.')
		return true
      end
end
end

function HandleUnJailCommand( Split, Player )
	local UsersIni = cIniFile()

	if UsersIni:ReadFile("users.ini") == false then
		LOG( "Could not read users.ini!" )
	end

	if #Split < 2 then
            Player:SendMessage('Usage:/unjail [player] [jail]')
            return true
      end

      UnJailed = false
      local JailPlayer = function(OtherPlayer)
		if (OtherPlayer:GetName() == Split[2]) then
                World = OtherPlayer:GetWorld()
	          OtherPlayer:TeleportToCoords( World:GetSpawnX(), World:GetSpawnY(), World:GetSpawnZ())
	          OtherPlayer:SendMessage(cChatColor.Green .. 'You have been unjailed')
                UsersIni:DeleteValue(OtherPlayer:GetName(),   "Jailed")
                UsersIni:SetValue(OtherPlayer:GetName(),   "Jailed",   "false")
                UsersIni:WriteFile("users.ini")
                UnJailed = true
	          return true

		 end
	end
      cRoot:Get():FindAndDoWithPlayer(Split[2], JailPlayer);
	if (UnJailed) then
          Player:SendMessage("You unjailed "..Split[2])
          return true
      else
          Player:SendMessage(cChatColor.Red .. "Player not found")
          return true
end
end

function HandleSetJailCommand( Split, Player)
	local Server = cRoot:Get():GetServer()
	local World = Player:GetWorld():GetName()
	local pX = math.floor(Player:GetPosX())
	local pY = math.floor(Player:GetPosY())
	local pZ = math.floor(Player:GetPosZ())

	if #Split < 2 then
		Player:SendMessage(cChatColor.Red .. 'Must supply a tag for the jail.')
		return true
	end
	local Tag = Split[2]

	if jails[Tag] == nil then 
		jails[Tag] = {}
	end

	local jailsINI = cIniFile()
	jailsINI:ReadFile("jails.ini")

	if (jailsINI:FindKey(Tag)<0) then
	jails[Tag]["w"] = World
	jails[Tag]["x"] = pX
	jails[Tag]["y"] = pY
	jails[Tag]["z"] = pZ
	end



	if (jailsINI:FindKey(Tag)<0) then
		jailsINI:AddKeyName(Tag);
		jailsINI:SetValue( Tag , "w" , World)
		jailsINI:SetValue( Tag , "x" , pX)
		jailsINI:SetValue( Tag , "y" , pY)
		jailsINI:SetValue( Tag , "z" , pZ)
		jailsINI:WriteFile("jails.ini");

		Player:SendMessage("Jail \"" .. Tag .. "\" set to World:'" .. World .. "' x:'" .. pX .. "' y:'" .. pY .. "' z:'" .. pZ .. "'")
            return true
	else
		Player:SendMessage(cChatColor.Red .. 'Jail "' .. Tag .. '" already exist')
            return true
	end
return true
end

function HandleDelJailCommand( Split, Player)
	local Server = cRoot:Get():GetServer()

	if #Split < 2 then
		Player:SendMessage(cChatColor.Red .. 'Usage: /deljail [jail]')
		return true
	end
	local Tag = Split[2]
	jails[Tag] = nil

	local jailsINI = cIniFile()
	jailsINI:ReadFile("jails.ini")

	if (jailsINI:FindKey(Tag)>-1) then
		jailsINI:DeleteKey(Tag);
		jailsINI:WriteFile("jails.ini");
	else
		Player:SendMessage(cChatColor.Red .. "Jail \"" .. Tag .. "\" was not found.")
		return true
	end

	Player:SendMessage(cChatColor.Green .. "Jail \"" .. Tag .. "\" was removed.")
	return true
end

function HandleListJailCommand( Split, Player)
	local jailStr = ""
	local inc = 0
	for k, v in pairs (jails) do
		inc = inc + 1
		jailStr = jailStr .. k .. ", "
	end
	Player:SendMessage(cChatColor.Green .. 'Jail: ' ..  cChatColor.LightGreen ..  jailStr)
	return true
end