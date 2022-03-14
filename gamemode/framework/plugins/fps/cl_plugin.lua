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


-- ПЕРЕПИСАТЬ НУЖНО ДА КОГДА НИТЬ

--[[
local PLUGIN = PLUGIN

CreateClientConVar("asterion_fps_show", 0, FCVAR_NONE)
CreateClientConVar("asterion_fps_size", 0.4, FCVAR_NONE)
CreateClientConVar("asterion_fps_shift", 30, FCVAR_NONE)
CreateClientConVar("asterion_fps_line", 1, FCVAR_NONE)

surface.CreateFont("asterion.FPSFont", {
    font = "Arial",
    size = 13,
    weight = 500,
    antialias = true,
})

local x = 50
local fpsData = {0, 50, 100, 150, 200, 250, 300}
PLUGIN.data = {}
PLUGIN.history = {}

PLUGIN.curFps = 0
PLUGIN.minFPS = 0
PLUGIN.maxFPS = 0

function PLUGIN:Think()
    if !GetConVar("asterion_fps_show"):GetBool() then return end

    local curFPS = math.Round(1 / FrameTime())
    local minFPS = self.minFPS or 60
    local maxFPS = self.maxFPS or 100

    local time = math.floor(RealTime() % 3 * 10)
    if time == 0 then self.data = {} end

    self.data[time] = curFPS

    if #self.history >= 1000 then
        table.remove(self.history, 1)
    end

    self.history[#self.history + 1] = curFPS

    if !self.onesec or CurTime() >= self.onesec then
        local a = 0
        for k, v in pairs(self.history) do
            a = a + v
        end

        self.averageFPS = math.Round(a / #self.history)
        self.curFPS = math.Round(1 / FrameTime())

        self.onesec = CurTime() + 0.2
    end

    if curFPS > maxFPS then
        self.maxFPS = curFPS
    end

    if curFPS < minFPS then
        self.minFPS = curFPS
    end
end

function PLUGIN:HUDPaint( )
    if !GetConVar("asterion_fps_show"):GetBool() then return end

    local size = GetConVar("asterion_fps_size"):GetFloat()
    local shift = GetConVar("asterion_fps_shift"):GetFloat()

    local curFPS = self.curFPS or 60
    local averageFPS = self.averageFPS or 60
    local minFPS = self.minFPS or 60
    local maxFPS = self.maxFPS or 100

    draw.SimpleText("Сейчас: " .. curFPS .. " FPS", "asterion.FPSFont", ScrW() - 600 - 10, ScrH() - 130 + 6 + 30, Color( 240, 173, 48, 255 ), TEXT_ALIGN_LEFT, 1)
    draw.SimpleText("Среднее: " .. averageFPS .. " FPS", "asterion.FPSFont", ScrW() - 600 - 10, ScrH() - 130 + 6 + 45, Color( 95, 172, 208), TEXT_ALIGN_LEFT, 1)
    draw.SimpleText("Макс: " .. maxFPS .. " FPS", "asterion.FPSFont", ScrW() - 600 - 10, ScrH() - 130 + 6 + 60, Color( 150, 255, 150, 255 ), TEXT_ALIGN_LEFT, 1)
    draw.SimpleText("Мин: " .. minFPS .. " FPS", "asterion.FPSFont", ScrW() - 600 - 10, ScrH() - 130 + 6 + 75, Color( 255, 150, 150, 255 ), TEXT_ALIGN_LEFT, 1)

    for k, v in pairs(fpsData) do
        local y = v * size

        draw.SimpleText(v, "asterion.FPSFont", ScrW() - 600, ScrH() - 130 - y, Color( 255, 255, 255, 50), TEXT_ALIGN_LEFT, 1)
        surface.SetDrawColor(255, 255, 255, 2)
        surface.DrawRect(ScrW() - 600 - 10, ScrH() - 130 - y + 6, 1000, 1)
    end

    if GetConVar("asterion_fps_line"):GetBool() then
        surface.SetDrawColor(95, 172, 208)
        surface.DrawRect(x + ScrW() - 600 - 10, ScrH() - 130 + 6 - averageFPS * size, 1000, 1)

        surface.SetDrawColor(150, 255, 150, 50)
        surface.DrawRect(x + ScrW() - 600 - 10, ScrH() - 130 + 6 - maxFPS * size, 1000, 1)

        surface.SetDrawColor(255, 150, 150, 50)
        surface.DrawRect(x + ScrW() - 600 - 10, ScrH() - 130 + 6 - minFPS * size, 1000, 1)
    end

    for i = 0, 17 do
        draw.SimpleText(i, "asterion.FPSFont", x + ScrW() - 600 - 10 + i * shift, ScrH() - 130 + 15, Color( 255, 255, 255, 50), TEXT_ALIGN_CENTER, 1)
    end

    for k, v in pairs(self.data) do
        if !v then continue end

        local oldFps = self.data[k - 1]
        if !oldFps then continue end

        local nextFps = self.data[k + 1]
        if !nextFps then continue end

        v = v * size
        oldFps = oldFps * size
        -- nextFps = nextFps * size

        surface.SetDrawColor(240, 173, 48)
        surface.DrawLine(x + ScrW() - 600 - 10 + (k - 1) * shift, ScrH() - 130 - 0 + 6 - oldFps, x + ScrW() - 600 - 10 + k * shift, ScrH() - 130 - 0 + 6 - v)
        draw.SimpleText(self.data[k - 1], "asterion.FPSFont", x + ScrW() - 600 - 10 + (k - 1) * shift, ScrH() - 130 - 0 + 6 - oldFps, Color( 255, 255, 255, 100 ), TEXT_ALIGN_CENTER, 1)
    end
end

]]--