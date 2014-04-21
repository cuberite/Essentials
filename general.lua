
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
                Player:SendMessageSuccess(OtherPlayer:GetName() .. " held item amount was set to 64")
            else
                Player:SendMessageFailure(OtherPlayer:GetName() .. " isn't holding an item")
            end
        else
            Player:SendMessageFailure("Player not found")
        end
    end
    if(Player:HasPermission("cb.more.other")) then
        cRoot:Get():FindAndDoWithPlayer(Split[2], More);
    end
    return true
end


function HandleSpawnMobCommand(Split,Player)
    if Split[2] == nil then
        Player:SendMessageInfo("Usage: /spawnmob [mobtype] [player]")
    end
    Mob = StringToMobType(Split[2])
    if Mob == mtInvalidType then
        Player:SendMessageFailure("Unknown mob type")
    else
        if Split[3] == nil then
            Player:GetWorld():SpawnMob(Player:GetPosX(), Player:GetPosY(), Player:GetPosZ(), Mob)
            Player:SendMessageSuccess("Mob spawned")
        elseif Player:HasPermission("cb.spawnmob.other") then
            local SpawnMob = function(OtherPlayer)
                if (OtherPlayer:GetName() == Split[3]) then
                    OtherPlayer:GetWorld():SpawnMob(OtherPlayer:GetPosX(), OtherPlayer:GetPosY(), OtherPlayer:GetPosZ(), Mob)
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




