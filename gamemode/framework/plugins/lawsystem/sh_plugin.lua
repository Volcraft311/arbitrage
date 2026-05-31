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


---@type TrialPlugin
local PLUGIN = PLUGIN
PLUGIN.name = "LawSystem"
LawSystem = PLUGIN

local Vector = Vector

Arbitrage.lawEnable = Arbitrage.lawEnable or false

Arbitrage.Trial = PLUGIN

function PLUGIN.GetPlaces()
    return GetNetVar("Arb_Trial_Places", {})
end

function PLUGIN.GetCameras()
    return GetNetVar("Arb_Trial_Cameras", {})
end

function PLUGIN.GetFocusCamera()
    return (GetNetVar("Arb_Trial_FocusCamera", 0))
end

function PLUGIN.GetStartCamera()
    return table.Copy(GetNetVar("Arb_Trial_StartPosCamera", { pos = Vector(0, 0, 0), ang = Angle(0,0,0) }))
end

function PLUGIN.GetEndPosCamera()
    return GetNetVar("Arb_Trial_EndPosCamera", Vector(0, 0, 0))
end

function PLUGIN.IsRebuttalShowdowns()
    return GetNetVar("Arb_Trial_RebuttalShowdowns", false)
end

function PLUGIN:GetClientPos(client)
    local lawPos = client:LawPlace()
    local cameras = Arbitrage.Trial.GetCameras()
    if lawPos >= 0 and cameras[lawPos] then
        local _pos = cameras[lawPos].pos
        local pos = Vector(_pos.x, _pos.y, _pos.z) -- Меня убьют, но из-за того что мне пришлось выкатывать это в спешке, придётся создавать новый вектор, иначе анимация не будет возвращать на исходную

        if pos then return pos end
    end

    return PLUGIN.GetEndPosCamera()
end

function PLUGIN:GetClientAng(client, pos)
    local WPos = client:LocalToWorld(Vector(0, 0, 0))
    local Ang = WPos - pos
    Ang = Ang:Angle()

    return Ang
end

function IsFirstStart(new, old)
    return new != old
end

local rotateRan = 0
PLUGIN.CamAnimData = {
    [1] = function(camPos, camAngles, camFov, client, newAnimID, oldAnimID)
        local Ang = PLUGIN:GetClientAng(client, camPos)

        if IsFirstStart(newAnimID, oldAnimID) then
            camAngles.z = 0
            rotateRan = math.random(-15, 15)
        end

        for k, v in ipairs({"y"}) do
            local speed = 5
            if camAngles.y >= Ang.y - 5 and camAngles.y <= Ang.y + 5 then
                speed = 1
            end

            camAngles[v] = Lerp(FrameTime() * speed, camAngles[v], Ang[v])
        end

        camAngles.z = Lerp(FrameTime() * 0.3, camAngles.z, rotateRan)

        camPos = Lerp(FrameTime() * 5, camPos, PLUGIN:GetClientPos(client))
        camFov = Lerp(FrameTime(), camFov, 90)

        return camPos, camAngles, camFov, client
    end,
    [2] = function(camPos, camAngles, camFov, client, newAnimID, oldAnimID)
        local Ang = PLUGIN:GetClientAng(client, camPos)

        if IsFirstStart(newAnimID, oldAnimID) then
            camPos = PLUGIN:GetClientPos(client)
            camFov = 130

            camAngles.z = 0
            rotateRan = math.random(-15, 15)
        end

        camAngles.y = Ang.y
        camAngles.z = Lerp(FrameTime() * 0.3, camAngles.z, rotateRan)

        camFov = Lerp(FrameTime(), camFov, 80)

        return camPos, camAngles, camFov, client
    end,
    [3] = function(camPos, camAngles, camFov, client, newAnimID, oldAnimID)
        local Ang = PLUGIN:GetClientAng(client, camPos)

        if IsFirstStart(newAnimID, oldAnimID) then
            camPos = PLUGIN:GetClientPos(client)

            camFov = 90
            camPos.z = camPos.z - 15

            camAngles.z = 0
            rotateRan = math.random(-15, 15)
        end

        camPos.z = Lerp(FrameTime() * 0.4, camPos.z, PLUGIN:GetClientPos(client).z)

        camAngles.y = Ang.y
        camAngles.z = Lerp(FrameTime() * 0.3, camAngles.z, rotateRan)

        camFov = Lerp(FrameTime(), camFov, 80)

        return camPos, camAngles, camFov, client
    end,
    [4] = function(camPos, camAngles, camFov, client, newAnimID, oldAnimID)
        local Ang = PLUGIN:GetClientAng(client, camPos)

        if IsFirstStart(newAnimID, oldAnimID) then
            camPos = PLUGIN:GetClientPos(client)

            camPos = camPos + Ang:Right() * 15
            camFov = 100

            camAngles.z = 0
            rotateRan = math.random(-15, 15)
        end

        camAngles.y = Ang.y
        camAngles.z = Lerp(FrameTime() * 0.3, camAngles.z, rotateRan)

        for k, v in ipairs({"x", "y", "z"}) do
            camPos[v] = Lerp(FrameTime() * 0.5, camPos[v], PLUGIN:GetClientPos(client)[v])
        end

        camFov = Lerp(FrameTime() * 0.3, camFov, 75)

        return camPos, camAngles, camFov, client
    end,
    [5] = function(camPos, camAngles, camFov, client, newAnimID, oldAnimID)
        local Ang = PLUGIN:GetClientAng(client, camPos)

        if IsFirstStart(newAnimID, oldAnimID) then
            camPos = PLUGIN:GetClientPos(client)

            camPos = camPos + Ang:Right() * -15
            camFov = 100

            camAngles.z = 0
            rotateRan = math.random(-15, 15)
        end

        camAngles.y = Ang.y
        camAngles.z = Lerp(FrameTime() * 0.3, camAngles.z, rotateRan)

        for k, v in ipairs({"x", "y", "z"}) do
            camPos[v] = Lerp(FrameTime() * 0.5, camPos[v], PLUGIN:GetClientPos(client)[v])
        end

        camFov = Lerp(FrameTime() * 0.3, camFov, 75)

        return camPos, camAngles, camFov, client
    end,
    [6] = function(camPos, camAngles, camFov, client, newAnimID, oldAnimID)
        if IsFirstStart(newAnimID, oldAnimID) then
            camPos = PLUGIN:GetClientPos(client)

            camFov = 90
            camPos.z = camPos.z + 15

            camAngles.z = 0
            rotateRan = math.random(-15, 15)
        end

        camPos.z = Lerp(FrameTime() * 0.4, camPos.z, PLUGIN:GetClientPos(client).z)

        local Ang = PLUGIN:GetClientAng(client, camPos)

        camAngles.y = Ang.y
        camAngles.z = Lerp(FrameTime() * 0.3, camAngles.z, rotateRan)

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
        local place = Arbitrage.Trial.GetPlaces() and Arbitrage.Trial.GetPlaces()[var]

        if place then
            client:SetEyeAngles(place.ang)
        end
    end
end

---@param place Place
function PLUGIN.AddPlace(place)
    PLUGIN.Data.PlacesList[#PLUGIN.Data.PlacesList+1] = place
    PLUGIN.LastPlaceId = #PLUGIN.Data.PlacesList
    return PLUGIN.LastPlaceId
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("cl_editor.lua")
Arbitrage.base.Include("sv_plugin.lua")