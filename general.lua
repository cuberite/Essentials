
function HandleMoreCommand(Split,Player)
	if Split[2] == nil then
	    HoldedItem = Player:GetEquippedItem()
        if(not(HoldedItem:IsEmpty())) then
            HoldedItem.m_ItemCount = 64
            Player:GetInventory():SetHotbarSlot(Player:GetInventory():GetEquippedSlotNum(), HoldedItem)
            Player:SendMessageSuccess("Item amount set to 64")
            return true
        else
            Player:SendMessageFailure("Please hold an item")
            return true
        end
    end
    local More = function(OtherPlayer)
        if (OtherPlayer:GetName() == Split[2]) then
            HoldedItem = Player:GetEquippedItem()
            if(not(HoldedItem:IsEmpty())) then
                HoldedItem.m_ItemCount = 64
                Player:GetInventory():SetHotbarSlot(Player:GetInventory():GetEquippedSlotNum(), HoldedItem)
                OtherPlayer:SendMessageSuccess("Item amount set to 64")
                Player:SendMessageSuccess(Split[2] .. " held item amount was set to 64")
            else
                Player:SendMessageFailure(Split[2] .. " isn't holding an item")
            end
        else
            Player:SendMessageFailure("Player not found")
        end
    end
    if(Player:HasPermission("es.more.other")) then
        cRoot:Get():FindAndDoWithPlayer(Split[2], More);
    end
    return true
end


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

function HandleBiomeCommand(Split,Player)
    if Split[2] == nil then
        biome = GetStringFromBiome(Player:GetWorld():GetBiomeAt(Player:GetPosX(), Player:GetPosZ()))
        Player:SendMessageInfo("You're in ".. biome)
    elseif Player:HasPermission("es.spawnmob.other") then
        local GetBiome = function(OtherPlayer)
            if (OtherPlayer:GetName() == Split[2]) then
                biome = GetStringFromBiome(OtherPlayer:GetWorld():GetBiomeAt(OtherPlayer:GetPosX(), OtherPlayer:GetPosZ()))
                Player:SendMessageInfo(OtherPlayer:GetName().. " is in ".. biome)
            else
                Player:SendMessageFailure("Player not found")
            end
        end
        cRoot:Get():FindAndDoWithPlayer(Split[2], GetBiome);
    end
    return true
end



