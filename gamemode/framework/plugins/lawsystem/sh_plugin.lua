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
PLUGIN.name = "LawSystem"
LawSystem = PLUGIN

Arbitrage.law = PLUGIN
Arbitrage.lawEnable = Arbitrage.lawEnable or false

local function getclientpos(client)
    local lawPos = client:LawPlace()
    if lawPos >= 0 and Arbitrage.camPosPlaces then
        local pos = Arbitrage.camPosPlaces[lawPos]

        if pos then
            return pos
        end
    end

    return Arbitrage.camPosEnd
end

PLUGIN.CamAnimData = {
    [1] = function(plugin, camPos, camAngles, camFov, client)
        local WPos = client:LocalToWorld(Vector(0, 0, 0))
        Ang = WPos - camPos
        Ang = Ang:Angle()

        for k, v in ipairs({"y", "z"}) do
            local speed = 5
            if camAngles.y >= Ang.y - 5 and camAngles.y <= Ang.y + 5 then
                speed = 1
            end

            camAngles[v] = Lerp(FrameTime() * speed, camAngles[v], Ang[v])
        end

        camPos = Lerp(FrameTime() * 5, camPos, getclientpos(client))
        camFov = Lerp(FrameTime(), camFov, 90)

        return camPos, camAngles, camFov, client
    end,
    [2] = function(plugin, camPos, camAngles, camFov, client)
        if plugin.oldEntity != client then
            camPos = getclientpos(client)

            camFov = 130
        end

        local WPos = client:LocalToWorld(Vector(0, 0, 0))
        Ang = WPos - camPos
        Ang = Ang:Angle()

        for k, v in ipairs({"y", "z"}) do
            camAngles[v] = Ang[v]
        end

        camFov = Lerp(FrameTime(), camFov, 80)

        return camPos, camAngles, camFov, client
    end,
    [3] = function(plugin, camPos, camAngles, camFov, client)
        if plugin.oldEntity != client then
            camPos = getclientpos(client)

            camFov = 90
            camPos.z = camPos.z - 15
        end

        camPos.z = Lerp(FrameTime() * 0.4, camPos.z, getclientpos(client).z)

        local WPos = client:LocalToWorld(Vector(0, 0, 0))
        Ang = WPos - camPos
        Ang = Ang:Angle()

        for k, v in ipairs({"y", "z"}) do
            camAngles[v] = Ang[v]
        end

        camFov = Lerp(FrameTime(), camFov, 80)

        return camPos, camAngles, camFov, client
    end,
    [4] = function(plugin, camPos, camAngles, camFov, client)
        local WPos = client:LocalToWorld(Vector(0, 0, 0))
        Ang = WPos - camPos
        Ang = Ang:Angle()

        for k, v in ipairs({"y", "z"}) do
            camAngles[v] = Ang[v]
        end

        if plugin.oldEntity != client then
            camPos = getclientpos(client)

            camPos = camPos + Ang:Right() * 15
            camFov = 100
        end

        for k, v in ipairs({"x", "y", "z"}) do
            camPos[v] = Lerp(FrameTime() * 0.5, camPos[v], getclientpos(client)[v])
        end

        camFov = Lerp(FrameTime() * 0.3, camFov, 75)

        return camPos, camAngles, camFov, client
    end,
    [5] = function(plugin, camPos, camAngles, camFov, client)
        local WPos = client:LocalToWorld(Vector(0, 0, 0))
        Ang = WPos - camPos
        Ang = Ang:Angle()

        for k, v in ipairs({"y", "z"}) do
            camAngles[v] = Ang[v]
        end

        if plugin.oldEntity != client then
            camPos = getclientpos(client)

            camPos = camPos + Ang:Right() * -15
            camFov = 100
        end

        for k, v in ipairs({"x", "y", "z"}) do
            camPos[v] = Lerp(FrameTime() * 0.5, camPos[v], getclientpos(client)[v])
        end

        camFov = Lerp(FrameTime() * 0.3, camFov, 75)

        return camPos, camAngles, camFov, client
    end,
    [6] = function(plugin, camPos, camAngles, camFov, client)
        if plugin.oldEntity != client then
            camPos = getclientpos(client)

            camFov = 90
            camPos.z = camPos.z + 15
        end

        camPos.z = Lerp(FrameTime() * 0.4, camPos.z, getclientpos(client).z)

        local WPos = client:LocalToWorld(Vector(0, 0, 0))
        Ang = WPos - camPos
        Ang = Ang:Angle()

        for k, v in ipairs({"y", "z"}) do
            camAngles[v] = Ang[v]
        end

        camFov = Lerp(FrameTime(), camFov, 80)

        return camPos, camAngles, camFov, client
    end,
}

function PLUGIN:StartCommand(client, ucmd)
    if Arbitrage.lawEnable then
        ucmd:RemoveKey(IN_JUMP)
        ucmd:RemoveKey(IN_DUCK)
        ucmd:RemoveKey(IN_ATTACK)
        ucmd:RemoveKey(IN_USE)

        ucmd:RemoveKey(IN_LEFT)
        ucmd:RemoveKey(IN_RIGHT)

        ucmd:ClearMovement()

        ucmd:SetForwardMove(0)
        ucmd:SetUpMove(0)
        ucmd:SetSideMove(0)

        ucmd:SetMouseX(0)
        ucmd:SetMouseY(0)
        ucmd:SetMouseWheel(0)

        local var = client:LawPlace()
        local place = Arbitrage.placesList[var]

        if place then
            client:SetEyeAngles(place[2])
        end
    end
end

function Arbitrage.IsShowClassTrial()
    return GetNetVar("arb.ClassTrial") and true or false
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")