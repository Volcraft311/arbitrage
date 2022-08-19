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
Container = PLUGIN

function PLUGIN:GetToolData(client)
    if !client:IsUsesTool("Container Tool") then return end

    local trace = client:GetEyeTrace()
    local entity = trace.Entity
    local angles = trace.HitNormal:Angle()
    angles:RotateAroundAxis(angles:Up(), 90)
    angles:RotateAroundAxis(angles:Forward(), 90)

    local tool = client:GetTool()

    local containerName = tool:GetClientInfo("name")
    local containerW = tool:GetClientInfo("w")
    local containerH = tool:GetClientInfo("h")

    if IsValid(entity) and !entity:IsPlayer() and !entity:IsWorld() then
        -- eh...
    else
        entity = NULL
    end

    local data = {
        name = containerName,
        w = containerW,
        h = containerH,
        entity = entity
    }

    return data
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")