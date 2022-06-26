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

function Container:IsUsesTool(client)
    if !IsValid(client) then return false end

    local weapon = client:GetActiveWeapon()
    if !IsValid(weapon) then return false end

    local class = weapon:GetClass()
    if class != "gmod_tool" then return false end

    local tool = client:GetTool() and client:GetTool().Name or nil
    if tool != "Container Tool" then return false end

    return true
end

function PLUGIN:GetToolData(client)
    if !self:IsUsesTool(client) then return end

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

Arbitrage.base.Include("sv_plugin.lua")