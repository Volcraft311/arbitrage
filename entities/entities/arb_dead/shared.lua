--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru (not work)
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

ENT.Type = "anim"
ENT.Author = "Selenter"
ENT.PrintName = "Табличка с игроком"
ENT.Category = "Asterion Academy"
ENT.Spawnable = false
ENT.PhysgunDisable = true
ENT.bNoPersist = true

function ENT:GetCharacter()
    return self:GetNetVar("character")
end