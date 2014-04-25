function OnTakeDamage(Receiver, TDI)
    Player = tolua.cast(Receiver,"cPlayer")
    if Receiver:IsPlayer() == true and Player:CanFly() == true and TDI.DamageType == dtFalling then
        return true
    end
end

function OnPlayerRightClick(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ)
    World = Player:GetWorld()
    if (BlockType == E_BLOCK_SIGN) then	
        Read, Line1, Line2, Line3, Line4 = World:GetSignLines( BlockX, BlockY, BlockZ , "", "", "", "" )
        if Line1 == "[SignWarp]" or Line1 == "[Warp]" then
            local Tag = Line2
            
            if warps[Tag] == nil then 
                Player:SendMessage(cChatColor.Red .. 'Warp "' .. Tag .. '" is invalid.')
                return true
            end
            if (Player:GetWorld():GetName() ~= warps[Tag]["w"]) then
                Player:TeleportToCoords( warps[Tag]["x"] + 0.5 , warps[Tag]["y"] , warps[Tag]["z"] + 0.5)
                Player:MoveToWorld(warps[Tag]["w"])
            end
            if Player:GetGameMode() == 1  and clear_inv_when_going_from_creative_to_survival == true then
                Player:GetInventory():Clear()
            end
            
            Player:TeleportToCoords( warps[Tag]["x"] + 0.5 , warps[Tag]["y"] , warps[Tag]["z"] + 0.5)
            Player:SendMessage(cChatColor.Green .. 'Warped to "' .. Tag .. '".')
            if change_gm_when_changing_world == true then
                Player:SetGameMode(Player:GetWorld():GetGameMode())
                return true
            end
            return true
        end
    end
end

function OnUpdatingSign(World, BlockX, BlockY, BlockZ, Line1, Line2, Line3, Line4, Player)
    if Line1 == "[SignWarp]" or Line1 == "[Warp]" then
        if (not(Player:HasPermission("warp.createsign") == true)) then
            return true
        elseif (Line2 == "") then
            Player:SendMessage(cChatColor.Red .. 'Must supply a tag for the warp.')
            return true
        end
    end
end

function OnPlayerBreakingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, BlockType, BlockMeta)
      if (UsersIni:GetValue(Player:GetName(),   "Jailed") == "true") and (IsDiggingEnabled == false) then 
             Player:SendMessage(cChatColor.Red .. "You are jailed")
             return true
      else
             return false
      end
end

function OnPlayerPlacingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ, BlockType)
      if (UsersIni:GetValue(Player:GetName(),   "Jailed") == "true") and (IsPlaceEnabled == false) then 
             Player:SendMessage(cChatColor.Red .. "You are jailed")
             return true
      else 
             return false
      end
end

function OnExecuteCommand(Player, CommandSplit)
      if (UsersIni:GetValue(Player:GetName(),   "Jailed") == "true") and (AreCommandsEnabled == false) then
             Player:SendMessage(cChatColor.Red .. "You are jailed") 
             return true
      else 
             return false
      end
end

function OnChat(Player, Message)
      if (UsersIni:GetValue(Player:GetName(),   "Jailed") == "true") and (IsChatEnabled == false) then 
             Player:SendMessage(cChatColor.Red .. "You are jailed")
             return true
      else 
             return false
      end
end