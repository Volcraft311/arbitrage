--[[
        © AsterionStaff 2025.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local PLUGIN = PLUGIN

hook("EntityTakeDamage", function(target, dmginfo)
    if dmginfo:GetDamageType() == 1 then -- Удар от пропа
        return dmginfo:SetDamage(0)
    end

    -- Вообще это надо перенести в SWEP academy_first (когда нить)
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

hook("PostEntityFireBullets", function(client, bullet)
    local weapon = client:GetActiveWeapon()
    if IsValid(weapon) and weapon:IsTFA() then
        -- if weapon:GetIronSights(client) then
            local multiplier = PLUGIN:GetOffsetsMultiplier(client)
            local value = math.random() * 0.75 * multiplier

            local multRecoil = hook.Run("MultiplierRecoil", client)
            if multRecoil then
                value = value * multRecoil
            end

            client:SetLocalVar("tfa:recoil", math.Clamp(client:GetLocalVar("tfa:recoil", 0) + value, 0, 8))

            timer.Create("tfa:recoil_remove_" .. client:EntIndex(), 0.15, 1, function()
                client:SetLocalVar("tfa:recoil", nil)
            end)
        end

        -- local bulletBoxSize = Vector(2.5, 2.5, 2.5)
        -- debugoverlay.Box(bullet.Trace.HitPos, bulletBoxSize * -0.5, bulletBoxSize * 0.5, 15, Color(255, 208, 0), true)

        if weapon.Base and !weapon.Base:find("melee") then
            netstream.Start(nil, "TFA:CreationLight", client:GetShootPos() + client:GetAimVector() * 60, bullet.Trace.HitPos, bullet.Trace.Entity)
        end
    -- end
end)


netstream.Hook("TFA:OnAimedPlayer", function(client)
    local value = 0.75

    local multFear = hook.Run("MultiplierFear", client)
    if multFear then
        value = value * multFear
    end

    client:SetLocalVar("tfa:fear", value)
end)

netstream.Hook("TFA:OnNotAimedPlayer", function(client)
    client:SetLocalVar("tfa:fear", nil)
end)