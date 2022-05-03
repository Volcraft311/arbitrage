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

include("cl_panel.lua")
include("shared.lua")

function ENT:Draw()
    self:DrawModel()
end

netstream.Hook("arb.OpenWardrobe", function(model)
    if bClose and IsValid(Arbitrage.gui.wardrobe) then
        Arbitrage.gui.wardrobe:Remove()
    end

    local panel = IsValid(Arbitrage.gui.wardrobe) and Arbitrage.gui.wardrobe or vgui.Create("arb.OpenWardrobe")
    panel:SetData(model)
end)