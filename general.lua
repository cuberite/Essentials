
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



