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
                else
                    Player:SendMessageFailure("Player not found")
                end
            end
            cRoot:Get():FindAndDoWithPlayer(Split[3], SpawnMob);
        end
    end
    return true
end



