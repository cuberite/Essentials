
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

function HandleEnchantCommand(Split, Player)
    if( #Split ~= 3 ) then
        Player:SendMessageInfo("Usage: /enchant [enchantment] [level]")
    else 
        Item = Player:GetEquippedItem()
        if(not(Item:IsEmpty())) then
            Item.m_Enchantments:SetLevel(cEnchantments:StringToEnchantmentID(Split[2]), Split[3])
            Player:GetInventory():SetHotbarSlot(Player:GetInventory():GetEquippedSlotNum(), Item)
            Player:SendMessageSuccess("Item enchanted")
        else
            Player:SendMessageFailure("Please hold an item to enchant")
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
    Player:GetInventory():SetArmorSlot(0, hat)
    Player:GetInventory():RemoveOneEquippedItem()
    Player:SendMessageSuccess("Enjoy your new helmet!")
    return true
end


