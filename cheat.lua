function HandleMoreCommand(Split,Player)
    if Split[2] == nil then
        HoldedItem = Player:GetEquippedItem()
        if(not(HoldedItem:IsEmpty())) then
            --Set Equipped slot number to 64
            HoldedItem.m_ItemCount = 64
            Player:GetInventory():SetHotbarSlot(Player:GetInventory():GetEquippedSlotNum(), HoldedItem)
            Player:SendMessageSuccess("Item amount set to 64")
            return true
        else
            --If player doesn't hold an item, notify
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
            return true
        end
    end
    if(Player:HasPermission("es.more.other")) then
        if (not(cRoot:Get():FindAndDoWithPlayer(Split[2], More))) then
            Player:SendMessageFailure("Player not found")
        end
    end
    return true
end

function HandleRepairCommand(Split, Player)
    Item = Player:GetEquippedItem()
    if(Item:IsDamageable()) then
        --Give a new item with the same type than the actual but with 0 damage, this way we avoid relogging
        Item.m_ItemDamage = 0
        Player:GetInventory():SetHotbarSlot(Player:GetInventory():GetEquippedSlotNum(), Item)
        Player:SendMessageSuccess("Item repaired")
    else
        Player:SendMessageFailure("Please hold an item to repair")
    end
    return true
end

function HandleFeedCommand(Split, Player)
    if Split[2] == nil then
        Player:SetFoodLevel(20)
        Player:SendMessageSuccess("You have no more hunger!")
    elseif(Player:HasPermission("es.feed.other")) then
        local Feed = function(OtherPlayer)
            if (OtherPlayer:GetName() == Split[2]) then
                --Set player food level to 20 (max)
                OtherPlayer:SetFoodLevel(20)
                Player:SendMessageSuccess(Split[2].." has no more hunger")
                return true
            end
        end
        if (not(cRoot:Get():FindAndDoWithPlayer(Split[2], Feed))) then
            Player:SendMessageFailure("Player not found")
        end
    end
    return true
end

function HandleHealCommand(Split, Player)
    if Split[2] == nil then
        Player:SetFoodLevel(20)
        Player:Heal(20)
        Player:SendMessageSuccess("You have been healed")
    elseif(Player:HasPermission("es.heal.other")) then
        local Heal = function(OtherPlayer)
            if (OtherPlayer:GetName() == Split[2]) then
                --Restore hunger and health
                OtherPlayer:SetFoodLevel(20)
                OtherPlayer:Heal(20)
                Player:SendMessageSuccess(Split[2].." has been healed")
                return true
            end
        end
        if (not(cRoot:Get():FindAndDoWithPlayer(Split[2], Heal))) then
            Player:SendMessageFailure("Player not found")
        end
    end
    return true
end

function HandleXPCommand(Split, Player)
    if( #Split <= 2 ) then
        Player:SendMessageInfo("Usage: /xp <show|set|give> [playername] [amount]")
    elseif Split[2] == "show" and Player:HasPermission("es.xp.show") then 
        local GetXP = function(OtherPlayer)
            if (OtherPlayer:GetName() == Split[3]) then
                xp = OtherPlayer:GetCurrentXp()
                --Get the xp level
                level = xp/17
                Player:SendMessageSuccess(Split[3].." current xp is "..xp)
            else
                Player:SendMessageFailure("Player not found")
            end    
        end
        cRoot:Get():FindAndDoWithPlayer(Split[3],GetXP);
    elseif Split[2] == "set" and Split[4] ~= nil and Player:HasPermission("es.xp.set") then 
        local SetXP = function(OtherPlayer)
            if (OtherPlayer:GetName() == Split[3]) then
                --Set player XP to the specified amoount
                OtherPlayer:SetCurrentExperience(Split[4])
                Player:SendMessageSuccess("Set "..Split[3].." xp to "..Split[4])
            else
                Player:SendMessageFailure("Player not found")
            end    
        end
        cRoot:Get():FindAndDoWithPlayer(Split[3],SetXP);
    elseif Split[2] == "set" and Split[4] == nil and Player:HasPermission("es.xp.set") then 
        Player:SendMessageFailure("You must specify the experience to set")
    elseif Split[2] == "give" and Split[4] ~= nil and Player:HasPermission("es.xp.set") then 
        local GiveXP = function(OtherPlayer)
            if (OtherPlayer:GetName() == Split[3]) then
                OtherPlayer:SetCurrentExperience(Player:GetCurrentXp() + Split[4])
                Player:SendMessageSuccess("Gave "..Split[4].." xp to "..Split[3])
            else
                Player:SendMessageFailure("Player not found")
            end    
        end
        cRoot:Get():FindAndDoWithPlayer(Split[3],GiveXP);
    elseif Split[2] == "give" and Split[4] == nil and Player:HasPermission("es.xp.set") then 
        Player:SendMessageFailure("You must specify the experience to give to the player")
    end
    return true
end

function HandleHatCommand(Split, Player)
    hat = cItem(Player:GetEquippedItem())
    hat.m_ItemCount = 1
    armorslot = Player:GetInventory():GetArmorSlot(0)
    if (not(armorslot:IsEmpty())) then
        Player:GetInventory():AddItem(armorslot)
    end
    --Set chestplate slot to the item the player is holding
    Player:GetInventory():SetArmorSlot(0, hat)
    Player:GetInventory():RemoveOneEquippedItem()
    Player:SendMessageSuccess("Enjoy your new helmet!")
    return true
end

function HandleFlySpeedCommand(Split, Player)
    if Split[2] == nil then
        Player:SendMessageInfo("Usage: /flyspeed <speed> [player]")
    elseif Split[3] == nil then
        Player:SetFlyingMaxSpeed(Split[2])
        Player:SendMessageInfo("Your fly speed has been set to "..Split[2])
    else
        local FlySpeed = function(OtherPlayer)
            if (OtherPlayer:GetName() == Split[3]) then
                --Set new fly speed
                OtherPlayer:SetFlyingMaxSpeed(Split[2])
                Player:SendMessageSuccess(Split[3].." fly speed has been set to "..Split[2])
                OtherPlayer:SendMessageInfo("Your fly speed has been set to "..Split[2])
                return true
            end
        end
        if (not(cRoot:Get():FindAndDoWithPlayer(Split[3], FlySpeed))) then
            Player:SendMessageFailure("Player not found")
        end
    end
    return true
end

function HandleWalkSpeedCommand(Split, Player)
    if Split[2] == nil then
        Player:SendMessageInfo("Usage: /walkspeed <speed> [player]")
    elseif Split[3] == nil then
        --Set new walk speed
        Player:SetNormalMaxSpeed(Split[2])
        Player:SendMessageInfo("Your walk speed has been set to "..Split[2])
    else
        local WalkSpeed = function(OtherPlayer)
            if (OtherPlayer:GetName() == Split[3]) then
                OtherPlayer:SetNormalMaxSpeed(Split[2])
                Player:SendMessageSuccess(Split[3].." walk speed has been set to "..Split[2])
                OtherPlayer:SendMessageInfo("Your walk speed has been set to "..Split[2])
                return true
            end
        end
        if (not(cRoot:Get():FindAndDoWithPlayer(Split[3], WalkSpeed))) then
            Player:SendMessageFailure("Player not found")
        end
    end
    return true
end

function HandleRunSpeedCommand(Split, Player)
    if Split[2] == nil then
        Player:SendMessageInfo("Usage: /runspeed <speed> [player]")
    elseif Split[3] == nil then
        --Set new sprinting speed
        Player:SetSprintingMaxSpeed(Split[2])
        Player:SendMessageInfo("Your sprinting speed has been set to "..Split[2])
    else
        local RunSpeed = function(OtherPlayer)
            if (OtherPlayer:GetName() == Split[3]) then
                OtherPlayer:SetSprintingMaxSpeed(Split[2])
                Player:SendMessageSuccess(Split[3].." sprinting speed has been set to "..Split[2])
                OtherPlayer:SendMessageInfo("Your sprinting speed has been set to "..Split[2])
                return true
            end
        end
        if (not(cRoot:Get():FindAndDoWithPlayer(Split[3], RunSpeed))) then
            Player:SendMessageFailure("Player not found")
        end
    end
    return true
end


