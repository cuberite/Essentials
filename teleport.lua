function HandlePlaceCommand(Split,Player)
    if Split[2] == nil then
        Player:SendMessageInfo("Usage: "..Split[1].." [player]")
    else
        pos = GetPlayerLookPosPlace(Player)
        local Teleport = function(OtherPlayer)
            if (OtherPlayer:GetName() == Split[2]) then
                if pos.x == 0 and pos.y == 0 and pos.z == 0 then
                    Player:SendMessageFailure("You're not looking at a block (or it's too far)")
                else
                    OtherPlayer:TeleportToCoords(pos.x, pos.y + 1, pos.z)
                    Player:SendMessageSuccess("Teleported "..Split[2].." where you are looking")
                end
                return true
            end
        end
        if (not(cRoot:Get():FindAndDoWithPlayer(Split[2], Teleport))) then
            Player:SendMessageFailure("Player not found")
        end
    end
    return true
end

