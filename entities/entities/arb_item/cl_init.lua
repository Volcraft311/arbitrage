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

include("shared.lua")

function ENT:Draw()
    self:DrawModel()
end

function ENT:Tooltip(tooltip)
    local item = self:GetItem()
    if !item then return end

    item:Tooltip(tooltip)
end

function ENT:OnCanTooltip()
    local stored = ItemBase.actionMenu.stored

    if stored[self] then
        return false
    end

    if LocalPlayer():GetNetVar("bIsHoldingObject", false) then
        return false
    end
end