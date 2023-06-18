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

local PLUGIN = PLUGIN

function PLUGIN:EntityTakeDamage(target, dmginfo)
    local attacker = dmginfo:GetAttacker()

    if dmginfo:GetDamageType() == 1 then -- Удар от пропа
        return dmginfo:SetDamage(0)
    end

    if attacker and IsValid(attacker) and attacker:IsPlayer() then
        local weapon = attacker:GetActiveWeapon()
        if weapon and IsValid(weapon) then
        	local class = weapon:GetClass()
        	if class != "academy_first" then return end

            dmginfo:SetDamage(target:Health() <= 5 and 0 or 2)
        end
    end
end