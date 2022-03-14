--[[
        © Asterion Project 2021.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

include("cl_panel.lua")
include("shared.lua")

function ENT:Draw()
    self:DrawModel()
end

netstream.Hook("arb.OpenNote", function(data, bEdit, bClose)
    if bClose and IsValid(Arbitrage.gui.note) then
        Arbitrage.gui.note:Remove()
    end

    local panel = IsValid(Arbitrage.gui.note) and Arbitrage.gui.note or vgui.Create("arb.OpenNote")
    panel:SetData(data, bEdit)
end)