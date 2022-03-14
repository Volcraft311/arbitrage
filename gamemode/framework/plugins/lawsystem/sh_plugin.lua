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

local PLUGIN = PLUGIN
PLUGIN.name = "LawSystem"
PLUGIN.author = "Selenter"

Arbitrage.law = PLUGIN

Arbitrage.lawEnable = Arbitrage.lawEnable or false

PLUGIN.copy = {}

function PLUGIN:ReplaceVariables()
    -- Позиции начальной камеры
    PLUGIN.camPos = {
        ["drp_hopespeak"] = {
            [1] = {pos = Vector(-557.674011, -2769.518799, -690.412659), ang = Angle(36.070911, 36.665367, 0.000000)},
            -- eh...
        }
    }
    PLUGIN.copy.camPos = table.Copy(PLUGIN.camPos)

    -- Где должна находится камера в конце
    PLUGIN.camPosEnd = {
        ["drp_hopespeak"] = Vector(-201.094284, -2496.078613, -887.968750)
    }
    PLUGIN.copy.camPosEnd = table.Copy(PLUGIN.camPosEnd)


    -- Где должен сидеть Моно "CUM"?
    PLUGIN.monokumPlace = {
        ["drp_hopespeak"] = {pos = Vector(-528.077271, -2354.913086, -822.366394), ang = Angle(-1.174964, -27.304247, 0.093104)}
    }
    PLUGIN.copy.monokumPlace = table.Copy(PLUGIN.monokumPlace)

    -- Камера которая смотрит на МоноКуму
    PLUGIN.monokumCam = {
        ["drp_hopespeak"] = Vector(-393.274109, -2414.661377, -842.831726)
    }
    PLUGIN.copy.monokumCam = table.Copy(PLUGIN.monokumCam)


    -- Список мест
    PLUGIN.placesList = {
        ["drp_hopespeak"] = {
            {pos = Vector(-198.881119, -2401.409668, -887.968750), ang = Angle(-1.486018, -90.389771, 0.000000)},
            {pos = Vector(-238.035492, -2404.347412, -887.968750), ang = Angle(-0.034027, -68.741699, 0.000000)},
            {pos = Vector(-277.119537, -2427.784424, -887.968750), ang = Angle(-0.902689, -44.751057, -0.039650)},
            {pos = Vector(-299.753387, -2465.804443, -887.968750), ang = Angle(-1.282923, -21.863527, -0.045863)},
            {pos = Vector(-302.587067, -2503.919434, -887.968750), ang = Angle(-0.980000, -0.037211, -0.069704)},
            {pos = Vector(-299.616333, -2542.128662, -887.968750), ang = Angle(-1.189690, 21.964031, -0.086604)},
            {pos = Vector(-278.177643, -2579.131348, -887.968750), ang = Angle(-0.513964, 45.297821, 0.025415)},
            {pos = Vector(-238.179596, -2603.757568, -887.968750), ang = Angle(-0.535176, 68.749794, -0.047656)},
            {pos = Vector(-200.064972, -2606.583984, -887.968750), ang = Angle(-0.623258, 90.194252, 0.000393)},
            {pos = Vector(-161.853333, -2603.610840, -887.968750), ang = Angle(-0.782074, 111.488228, 0.098710)},
            {pos = Vector(-122.848984, -2580.183594, -887.968750), ang = Angle(-0.238875, 134.212341, 0.015548)},
            {pos = Vector(-100.236328, -2542.160889, -887.968750), ang = Angle(1.261051, 157.526886, 0.095551)},
            {pos = Vector(-97.406654, -2504.047119, -887.968750), ang = Angle(-0.472908, 179.155533, 0.011351)},
            {pos = Vector(-100.362938, -2465.932617, -887.968750), ang = Angle(-0.172372, -158.530289, -0.097806)},
            {pos = Vector(-123.768608, -2426.896484, -887.968750), ang = Angle(-0.933975, -135.699966, 0.012694)},
            {pos = Vector(-161.782700, -2404.253418, -887.968750), ang = Angle(0.147995, -112.951431, -0.043005)}
        }
    }
    PLUGIN.copy.placesList = table.Copy(PLUGIN.placesList)

    -- Записываем место Монокумы на 0 ID
    if PLUGIN.placesList[game.GetMap()] and PLUGIN.monokumPlace[game.GetMap()] then
        PLUGIN.placesList[game.GetMap()][0] = PLUGIN.monokumPlace[game.GetMap()]
    end
end
PLUGIN:ReplaceVariables()

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

        camPos = Lerp(FrameTime() * 5, camPos, client:MonoLawPlace() and plugin.monokumCam[game.GetMap()] or plugin.camPosEnd[game.GetMap()])
        camFov = Lerp(FrameTime(), camFov, 90)

        return camPos, camAngles, camFov, client
    end,
    [2] = function(plugin, camPos, camAngles, camFov, client)
        if plugin.oldEntity != client then
            camPos = client:MonoLawPlace() and plugin.monokumCam[game.GetMap()] or plugin.camPosEnd[game.GetMap()]

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
            camPos = client:MonoLawPlace() and plugin.monokumCam[game.GetMap()] or plugin.camPosEnd[game.GetMap()]

            camFov = 90
            camPos.z = camPos.z - 15
        end

        camPos.z = Lerp(FrameTime() * 0.4, camPos.z, client:MonoLawPlace() and plugin.monokumCam[game.GetMap()].z or plugin.camPosEnd[game.GetMap()].z)

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
            camPos = client:MonoLawPlace() and plugin.monokumCam[game.GetMap()] or plugin.camPosEnd[game.GetMap()]

            camPos = camPos + Ang:Right() * 15
            camFov = 100
        end

        for k, v in ipairs({"x", "y", "z"}) do
            camPos[v] = Lerp(FrameTime() * 0.5, camPos[v], client:MonoLawPlace() and plugin.monokumCam[game.GetMap()][v] or plugin.camPosEnd[game.GetMap()][v])
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
            camPos = client:MonoLawPlace() and plugin.monokumCam[game.GetMap()] or plugin.camPosEnd[game.GetMap()]

            camPos = camPos + Ang:Right() * -15
            camFov = 100
        end

        for k, v in ipairs({"x", "y", "z"}) do
            camPos[v] = Lerp(FrameTime() * 0.5, camPos[v], client:MonoLawPlace() and plugin.monokumCam[game.GetMap()][v] or plugin.camPosEnd[game.GetMap()][v])
        end

        camFov = Lerp(FrameTime() * 0.3, camFov, 75)

        return camPos, camAngles, camFov, client
    end,
    [6] = function(plugin, camPos, camAngles, camFov, client)
        if plugin.oldEntity != client then
            camPos = client:MonoLawPlace() and plugin.monokumCam[game.GetMap()] or plugin.camPosEnd[game.GetMap()]

            camFov = 90
            camPos.z = camPos.z + 15
        end

        camPos.z = Lerp(FrameTime() * 0.4, camPos.z, client:MonoLawPlace() and plugin.monokumCam[game.GetMap()].z or plugin.camPosEnd[game.GetMap()].z)

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

        local var = client:GetNetVar("arbLaw", -1)
        local place = self.placesList[game.GetMap()][var]

        if place then
            client:SetEyeAngles(place.ang)
        end
    end
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")