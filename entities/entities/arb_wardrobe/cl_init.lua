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

include("cl_panel.lua")
include("shared.lua")

function ENT:Draw()
    self:DrawModel()
end

function ENT:Tooltip(tooltip)
    tooltip:SetTitle("Гардероб")
    tooltip:SetDescription("Шкаф с одеждой, можно попробовать сменить свою одежду.")
    tooltip:SetIcon("asterion/academy/ui/tooltip/wardrobe.png")
end