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

local PLUGIN = PLUGIN

local function getReceivers()
    local admins = {}

    for k, v in ipairs(player.GetAll()) do
        if v:IsAdmin() and (v:IsNocliping() or v:IsSpectating()) then
            admins[#admins + 1] = v
        end
    end

    return admins
end

local receivers = {}
timer.Simple(math.random(), function()
    timer.Create("AdminESP:UpdateReceivers", 2, 0, function()
        receivers = getReceivers()
    end)
end)

timer.Create("AdminESP:UpdatePlayersPosition", 0.35, 0, function()
    if #receivers <= 0 then return end

    for k, v in ipairs(player.GetAll()) do
        v:SetNetVar("esp.position", v:GetPos(), receivers)
    end
end)