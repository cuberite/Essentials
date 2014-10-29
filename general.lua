
function HandleBiomeCommand(Split,Player)
    if Split[2] == nil then
        biome = GetStringFromBiome(Player:GetWorld():GetBiomeAt(Player:GetPosX(), Player:GetPosZ()))
        Player:SendMessageInfo("You're in ".. biome)
    elseif Player:HasPermission("es.biome.other") then
        local GetBiome = function(OtherPlayer)
            if (OtherPlayer:GetName() == Split[2]) then
                biome = GetStringFromBiome(OtherPlayer:GetWorld():GetBiomeAt(OtherPlayer:GetPosX(), OtherPlayer:GetPosZ()))
                Player:SendMessageInfo(Split[2].. " is in ".. biome)
                return true
            end
        end
        if (not(cRoot:Get():FindAndDoWithPlayer(Split[2], GetBiome))) then
            Player:SendMessageFailure("Player not found")
        end
    end
    return true
end


function HandleGetPosCommand(Split,Player)
    if Split[2] == nil then
        Player:SendMessageInfo("Your position: X:"..Player:GetPosX()..", Y:"..Player:GetPosY()..", Z:"..Player:GetPosZ())
    elseif Player:HasPermission("es.getpos.other") then
        local GetPos = function(OtherPlayer)
            if (OtherPlayer:GetName() == Split[2]) then
                Player:SendMessageInfo(Split[2].." position: X:"..OtherPlayer:GetPosX()..", Y:"..OtherPlayer:GetPosY()..", Z:"..OtherPlayer:GetPosZ())
                return true
            end
        end
        if (not(cRoot:Get():FindAndDoWithPlayer(Split[2], GetPos))) then
            Player:SendMessageFailure("Player not found")
        end
    end
    return true
end

function HandleWhoisCommand(Split,Player)
    if Split[2] == nil then
        Player:SendMessageInfo("Your username is "..Player:GetName())
        Player:SendMessageInfo("Your IP is "..Player:GetIP())
        Player:SendMessageInfo("Your ping is "..Player:GetClientHandle():GetPing())
        Player:SendMessageInfo("Your language is "..Player:GetClientHandle():GetLocale())
    else
        local GetInfo = function(OtherPlayer)
            if (OtherPlayer:GetName() == Split[2]) then
                Player:SendMessageInfo("Username: "..OtherPlayer:GetName())
                Player:SendMessageInfo("IP: "..OtherPlayer:GetIP())
                Player:SendMessageInfo("Ping: "..OtherPlayer:GetClientHandle():GetPing())
                Player:SendMessageInfo("Language: "..OtherPlayer:GetClientHandle():GetLocale())
                return true
            end
        end
        if (not(cRoot:Get():FindAndDoWithPlayer(Split[2], GetInfo))) then
            Player:SendMessageFailure("Player not found")
        end
    end
    return true
end

function HandleBroadcastCommand(Split,Player)
    if Split[2] == nil then
        Player:SendMessageInfo("Usage: "..Split[1].." <message>")
    else
        cRoot:Get():QueueExecuteConsoleCommand("say "..Split[2])
    end
    return true
end

function HandleRCommand(Split,Player)
    if Split[2] == nil then
        Player:SendMessageInfo("Usage: "..Split[1].." <message>")
    else
        local SendMessage = function(OtherPlayer)
            if (OtherPlayer:GetName() == lastsender[Player:GetName()]) then
                local newSplit = table.concat( Split, " ", 2 )
                Player:SendMessageSuccess( "Message to player " .. lastsender[Player:GetName()] .. " sent!" )
                OtherPlayer:SendMessagePrivateMsg(newSplit, Player:GetName())
                lastsender[OtherPlayer:GetName()] = Player:GetName()
                return true
            end
        end
        if lastsender[Player:GetName()] == nil then
            Player:SendMessageFailure("No last sender found")
        else
            if (not(cRoot:Get():FindAndDoWithPlayer(lastsender[Player:GetName()], SendMessage))) then
                Player:SendMessageFailure("Player not found")
            end
        end
    end
    return true
end
