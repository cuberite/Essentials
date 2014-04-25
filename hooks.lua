function OnTakeDamage(Receiver, TDI)
    Player = tolua.cast(Receiver,"cPlayer")
    if Receiver:IsPlayer() == true and Player:CanFly() == true and TDI.DamageType == dtFalling then
        return true
    end
end