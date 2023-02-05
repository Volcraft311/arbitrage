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

local PLUGIN = PLUGIN
PLUGIN.dot = 1

function PLUGIN:Think()
    local client = LocalPlayer()

    if !client:oldAlive() then return end
    if !client:GetNetVar("inbed") then client.inbedpos = client:EyePos() client.inbedang = client:EyeAngles() return end

    if input.IsKeyDown(KEY_SPACE) and !vgui.CursorVisible() and (!client.BedCD or CurTime() >= client.BedCD) then
        netstream.Start("arb.GetUpBed")
        client.BedCD = CurTime() + 5
    end
end

function PLUGIN:CalcView(client, pos, angles, fov)
    if !client:oldAlive() then return end
    if !client:GetNetVar("inbed") then return end

    client.inbedpos = client.inbedpos or client:EyePos()
    client.inbedang = client.inbedang or client:EyeAngles()

    local entity = client:GetNetVar("inbed")
    if entity and IsValid(entity) then
        local posinfo = self.allowBed[entity:GetModel()].eye

        client.inbedpos = Lerp(FrameTime() * 1, client.inbedpos, posinfo.pos(entity:GetPos(), entity:GetAngles()))

        for i = 1, 3, 2 do
            client.inbedang[i] = Lerp(FrameTime() * 1, client.inbedang[i], entity:GetAngles()[i] + posinfo.ang[i])
        end

        local view = {
            origin = client.inbedpos,
            angles = client.inbedang,
            fov = fov,
            drawviewer = false
        }

        return view
    end
end

function PLUGIN:RenderScreenspaceEffects()
    local client = LocalPlayer()

    if !client:oldAlive() then return end

    local isSleep = client:GetNetVar("inbed") or client:GetLocalVar("sleeping")

    client.bedalpha = client.bedalpha or 0
    client.bedalpha = Lerp(FrameTime() * 1.5, client.bedalpha, isSleep and 257 or -3)

    if client.bedalpha <= 0.05 then return end

    surface.SetDrawColor(0, 0, 0, math.Clamp(client.bedalpha, 0, 255))
    surface.DrawRect(-1, -1, ScrW() + 2, ScrH() + 2)

    if (!self.dotUpdate or CurTime() >= self.dotUpdate) then
        self.dot = self.dot >= 4 and 1 or self.dot + 1
        self.dotUpdate = CurTime() + 1
    end

    local actionAlpha = Arbitrage.action.data and ((Arbitrage.action.data.alpha and Arbitrage.action.data.alpha or 0) + 1) or 0

    draw.SimpleText("Вы спите" .. string.rep(".", self.dot), "arb.Font_FuturaPTDemi_20", ScrW() / 2, ScrH() * 0.4, Color(255, 255, 255, client.bedalpha - actionAlpha), TEXT_ALIGN_CENTER)

    if !isSleep then return end
    if client:GetLocalVar("sleeping") then return end

    draw.SimpleText("Чтобы проснуться нажмите на \"Пробел\"", "arb.Font_FuturaPTBook_12", ScrW() / 2, ScrH() * 0.45, Color(255, 255, 255, client.bedalpha - actionAlpha), TEXT_ALIGN_CENTER)
end