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
PLUGIN.pos = 0
PLUGIN.alpha = 0
PLUGIN.pos2 = 0
PLUGIN.alpha2 = 0
PLUGIN.realtime = RealTime()
PLUGIN.lerp = 0
PLUGIN.lerp2 = 0

local mat = Arbitrage.GetMaterial("danganronpa/hud/voice.png")
local standingOffset = Vector(0, 0, 72)
local crouchingOffset = Vector(0, 0, 38)
local boneOffset = Vector(0, 0, 15)
local textColor = Color(250, 250, 250)
local shadowColor = Color(66, 66, 66)

function PLUGIN:GetTypingIndicatorPosition(client)
    local head

    for i = 1, client:GetBoneCount() do
        local name = client:GetBoneName(i)

        if (string.find(name:lower(), "head")) then
            head = i
            break
        end
    end

    local position = head and client:GetBonePosition(head) or ((client:Crouching() and crouchingOffset or standingOffset) + client:GetPos())
    return position + boneOffset
end

function PLUGIN:PlayerStartVoice(client)
    self.players[client] = true

    hook.Run("ArbitrageVoiceStart", client)

    return true -- disable old VoiceDraw
end

function PLUGIN:PlayerEndVoice(client)
    self.players[client] = nil
end

function PLUGIN:HUDPaint()
    local client = LocalPlayer()
    local size = ScrW() * 0.05
    local value = LocalPlayer():GetNetVar("arb.voicescale", 0.5)
    local bShow = self.realtime >= RealTime()

    self.pos = Lerp(FrameTime() * 10, self.pos, self.players[LocalPlayer()] and 100 or 0)
    self.alpha = Lerp(FrameTime() * 40, self.alpha, self.players[LocalPlayer()] and 255 or 0)

    if self.alpha > 0.2 then
        local color = client:GetNetVar("arbGlobalVoice") and Color(255, 61, 96, self.alpha) or Color(255, 255, 255, self.alpha * value)

        surface.SetDrawColor(color)
        surface.SetMaterial(mat)
        surface.DrawTexturedRect(ScrW() / 2 - 40 / 2, ScrH() - self.pos, 40, 40)
    end

    self.pos2 = Lerp(FrameTime() * 10, self.pos2, bShow and 100 or 0)
    self.alpha2 = Lerp(FrameTime() * 20, self.alpha2, bShow and 255 or 0)
    self.lerp = Lerp(FrameTime() * 15, self.lerp, (size * 2) * value)

    if self.alpha2 > 0.2 then
        draw.SimpleText("Дальность голоса " .. value * 100 .. "%", "arb.Font_FuturaPTBook_6", ScrW() / 2, ScrH() - self.pos2 * 3 - ScrH() * 0.025, Color(255, 255, 255, self.alpha2), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 255, 255, self.alpha2 * 0.1)
        surface.DrawRect(ScrW() / 2 - size, ScrH() - self.pos2 * 3, size * 2, 5)

        surface.SetDrawColor(255, 255, 255, self.alpha2)
        surface.DrawRect(ScrW() / 2 - size, ScrH() - self.pos2 * 3, self.lerp, 5)
    end
end

function PLUGIN:KeyPressID(client, id, bIsVisibleGUI)
    if bIsVisibleGUI then return end
    if id != "voice_up" and id != "voice_down" then return end
    if Arbitrage.gui.chat:GetActive() then return end

    self.realtime = RealTime() + 2
    netstream.Start("VOICEDIST:ChangeVoiceVolume", id == "voice_up" and true or false)
end

do
    function surface.draw_circle_outline(x, y, radius, thickness, passes)
        render.ClearStencil()
        render.SetStencilEnable(true)
        render.SetStencilWriteMask(255)
        render.SetStencilTestMask(255)
        render.SetStencilReferenceValue(28)
        render.SetStencilFailOperation(STENCIL_REPLACE)

        render.SetStencilCompareFunction(STENCIL_EQUAL)
            surface.draw_circle(x, y, radius - (thickness or 1), passes)
            render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
            surface.draw_circle(x, y, radius, passes)
            render.SetStencilEnable(false)
        render.ClearStencil()
    end

    function surface.draw_circle(x, y, radius, passes)
        local info = Arbitrage.hud.GeneratePoly(x, y, radius, passes)

        draw.NoTexture()
        surface.DrawPoly(info)
    end
end

function PLUGIN:PostDrawTranslucentRenderables()
    if Arbitrage.lawEnable then return end

    local client = LocalPlayer()

    for k, v in pairs(player.GetAll()) do
        if v == client then continue end
        if v:IsNocliping() then continue end

        v.arbTextAlpha = v.arbTextAlpha or 0
        v.arbTextAlpha = Lerp(FrameTime() * 8, v.arbTextAlpha, self.players[v] and 1 or 0)

        if v.arbTextAlpha <= 0.1 then continue end

        local fraction = v.arbTextAlpha
        local distance = v:GetPos():DistToSqr(LocalPlayer():GetPos())

        local angle = EyeAngles()
        angle:RotateAroundAxis(angle:Forward(), 90)
        angle:RotateAroundAxis(angle:Right(), 90)

        cam.Start3D2D(self:GetTypingIndicatorPosition(v), Angle(0, angle.y, 90), 0.05)
            surface.SetFont("arb.Font_FuturaPTBook_30")

            local _, textHeight = surface.GetTextSize(self.text)
            local alpha = (1 - math.min(distance, 100000) / 100000) * 255 * fraction

            draw.SimpleTextOutlined(self.text, "arb.Font_FuturaPTBook_30", 0, -textHeight * 0.5 * fraction, ColorAlpha(textColor, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 4, ColorAlpha(shadowColor, alpha))
        cam.End3D2D()
    end

    if self.alpha2 > 0.2 then
        local value = LocalPlayer():GetNetVar("arb.voicescale", 0.5)
        local dist = 650

        self.lerp2 = Lerp(FrameTime() * 10, self.lerp2, value)

        cam.Start3D2D(client:GetPos() + Vector(0, 0, 5), Angle(0, 0, 0), 1)
            surface.SetDrawColor(0, 255, 85, self.alpha2)
            surface.draw_circle_outline(0, 0, dist * 1, 3, 50)

            surface.SetDrawColor(255, 0, 0, self.alpha2)
            surface.draw_circle_outline(0, 0, dist * 0.1, 3, 50)

            surface.SetDrawColor(255, 255, 255, self.alpha2)
            surface.draw_circle_outline(0, 0, dist * self.lerp2, 3, 50)
        cam.End3D2D()
    end
end