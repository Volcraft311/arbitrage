--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


hook("EntityTakeDamage", function(target, dmginfo)
    if dmginfo:GetDamageType() == 1 then -- Удар от пропа
        return dmginfo:SetDamage(0)
    end

    local attacker = dmginfo:GetAttacker()
    if attacker and IsValid(attacker) and attacker:IsPlayer() then
        local weapon = attacker:GetActiveWeapon()
        if !IsValid(weapon) then return end

        local class = weapon:GetClass()
        if class != "academy_first" then return end

        dmginfo:SetDamage(target:Health() <= 5 and 0 or 2)

        if target:IsPlayer() and target:Health() <= 5 then
            target.fistDamageCount = (target.fistDamageCount or 0) + 1

            if target.fistDamageCount >= 5 then
                target:FallOver(30)

                target.fistDamageCount = 0
            end
        end
    end
end)