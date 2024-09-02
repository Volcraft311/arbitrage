--[[
        © AsterionStaff 2023.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

ENT.Type = "anim"
ENT.Author = "Selenter"
ENT.PrintName = "Контейнер"
ENT.Category = "Asterion Academy"
ENT.Spawnable = false
ENT.PhysgunDisable = true
ENT.bNoPersist = true

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "ContainerName")
    self:NetworkVar("Int", 0, "InventoryID")
end