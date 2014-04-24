function HandleSpawnMobCommand(Split,Player)
    if Split[2] == nil then
        Player:SendMessageInfo("Usage: /spawnmob [mobtype] [player]")
    end
    Mob = StringToMobType(Split[2])
    if Mob == -1 then
        Player:SendMessageFailure("Unknown mob type")
    else
        if Split[3] == nil then
            pos = GetPlayerLookPos(Player)
            if pos.x == 0 and pos.y == 0 and pos.z == 0 then
                Player:GetWorld():SpawnMob(Player:GetPosX() + 5, Player:GetPosY(), Player:GetPosZ() + 5, Mob)
            else
                Player:GetWorld():SpawnMob(pos.x, pos.y + 1, pos.z, Mob)
            end
            Player:SendMessageSuccess("Mob spawned")
        elseif Player:HasPermission("es.spawnmob.other") then
            local SpawnMob = function(OtherPlayer)
                if (OtherPlayer:GetName() == Split[3]) then
                    pos = GetPlayerLookPos(OtherPlayer)
                    if pos.x == 0 and pos.y == 0 and pos.z == 0 then
                        OtherPlayer:GetWorld():SpawnMob(OtherPlayer:GetPosX() + 5, OtherPlayer:GetPosY(), OtherPlayer:GetPosZ(), Mob)
                    else
                        OtherPlayer:GetWorld():SpawnMob(pos.x, pos.y + 1, pos.z, Mob)
                    end
                    Player:SendMessageSuccess("Spawned mob near "..Split[3])
                    return true
                end
            end
            if (not(cRoot:Get():FindAndDoWithPlayer(Split[3], SpawnMob))) then
                Player:SendMessageFailure("Player not found")
            end
        end
    end
    return true
end

function HandleBurnCommand(Split, Player)
    if Split[2] == nil then
        Player:SendMessageInfo("Usage: /burn [player] [seconds]")
    else
        local BurnPlayer = function(OtherPlayer)
            if (OtherPlayer:GetName() == Split[2]) then
                if Split[3] == nil then
                    Player:StartBurning(200)
                else
                    Player:StartBurning(Split[3] * 20)
                end
                return true
            end
        end
        if (not(cRoot:Get():FindAndDoWithPlayer(Split[2], BurnPlayer))) then
            Player:SendMessageFailure("Player not found")
        end
    end                  
    return true
end

function HandlePingCommand(Split, Player)
    Player:SendMessage(cChatColor.Green.. "Pong!")
    return true
end

function HandleVanishCommand(Split, Player)
 	if (Split[2] == nil) then
 	    if Player:IsVisible() == true then
            Player:SetVisible(false)
            Player:SendMessageInfo("You're now invisible!")
        else
            Player:SetVisible(true)
            Player:SendMessageInfo("You're now visible!")
        end
    elseif Player:HasPermission("es.vanish.other") then
        local VanishPlayer = function(OtherPlayer)
            if (OtherPlayer:GetName() == Split[2]) then
                if OtherPlayer:IsVisible() == true then
                    OtherPlayer:SetVisible(false)
                    OtherPlayer:SendMessageInfo("You're now invisible!")
                    Player:SendMessageSuccess( "Player " .. Split[2] .. " is now invisible" )
                else
                    OtherPlayer:SetVisible(true)
                    OtherPlayer:SendMessageInfo("You're now visible!")
                    Player:SendMessageSuccess( "Player " .. Split[2] .. " is now visible" )
                end    
                return true
            end
        end
        if (not(cRoot:Get():FindAndDoWithPlayer(Split[2], VanishPlayer))) then
            Player:SendMessageFailure("Player not found")
        end
 	end
 	return true
end

