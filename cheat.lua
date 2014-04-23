
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





