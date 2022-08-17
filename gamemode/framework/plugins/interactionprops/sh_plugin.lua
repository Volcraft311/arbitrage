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


local PLUGIN = PLUGIN
Interaction = PLUGIN

PLUGIN.name = "Interaction Props"

function PLUGIN:GetToolData(client)
    if !client:IsUsesTool("Interaction Tool") then return end

    local trace = client:GetEyeTrace()
    local entity = trace.Entity

    local data = {
        entity = entity
    }

    return data
end

Arbitrage.base.Include("sv_plugin.lua")