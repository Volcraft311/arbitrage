--[[
        © AsterionStaff 2024.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

function Moderation:InitPostEntity()
    local toolgun = weapons.GetStored("gmod_tool")
    if !istable(toolgun) then return end

    function toolgun:DoShootEffect(hitpos, hitnorm, ent, physbone, predicted)
        self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
        self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    end
end