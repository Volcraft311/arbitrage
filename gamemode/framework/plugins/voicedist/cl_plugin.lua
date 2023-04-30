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
PLUGIN.pos = 0
PLUGIN.alpha = 0
PLUGIN.pos2 = 0
PLUGIN.alpha2 = 0
PLUGIN.realtime = RealTime()
PLUGIN.lerp = 0
PLUGIN.lerp2 = 0

local mat = Material("danganronpa/hud/voice.png")
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

    return true
end

function PLUGIN:PlayerEndVoice(client)
    self.players[client] = nil

    hook.Run("ArbitrageVoiceEnd", client)
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

local function isAllow(client)
    if !IsValid(client) then return false end

    if Arbitrage.lawEnable then return false end

    return true
end

local d = 150000
local showPlayerList = {}
local allow = false
timer.Create("VoiceDist:Update", 1, 0, function()
    showPlayerList = {}

    local client = LocalPlayer()
    allow = isAllow(client)
    if !allow then return end

    for k, v in pairs(player.GetAll()) do
        if v == client then continue end
        if v:IsNocliping() then continue end

        local distance = v:GetPos():DistToSqr(EyePos())
        if distance > d then continue end

        v.arbTextAlphaVoice = v.arbTextAlphaVoice or 0
        v.arbTextAlphaChat = v.arbTextAlphaChat or 0
        showPlayerList[#showPlayerList + 1] = v
    end
end)

local sizeMat = H(40)
function PLUGIN:DrawVoiceIcon()
    local client = LocalPlayer()
    local size = ScrW() * 0.05
    local value = LocalPlayer():GetNetVar("arb.voicescale", 0.5)
    local bShow = self.realtime >= RealTime()

    self.pos = Lerp(FrameTime() * 10, self.pos, self.players[LocalPlayer()] and 100 or 0)
    self.alpha = Lerp(FrameTime() * sizeMat, self.alpha, self.players[LocalPlayer()] and 255 or 0)

    if self.alpha > 0.2 then
        local isGlobal = client:GetLocalVar("arbGlobalVoice")
        local color = isGlobal and Color(255, 61, 96, self.alpha) or Color(255, 255, 255, self.alpha * value)

        local x = ScrW() / 2
        local y = ScrH() - self.pos

        surface.SetDrawColor(color)
        surface.SetMaterial(mat)
        surface.DrawTexturedRect(x - sizeMat / 2, y, sizeMat, sizeMat)

        if !isGlobal then
            draw.SimpleText(value * 100 .. "%", "arb.Font_FuturaPTBook_4", x, y + sizeMat * 1.2, color, TEXT_ALIGN_CENTER)
        end
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

local colors = {
    ["me"] = Color(44, 176, 247),
    ["try"] = Color(44, 247, 85),
    ["looc"] = Color(190, 62, 62),
    ["ooc"] = Color(236, 62, 62),
    ["it"] = Color(236, 62, 62),
    ["roll"] = Color(209, 69, 69),
    ["it"] = Color(255, 255, 255)
}

local function getColor(client)
    local var = client:GetNetVar("arb.chattype")

    local color = colors[var]
    if color then
        return color
    end

    return Color(238, 220, 194)
end

local oldColor = Color(238, 220, 194)
local iconChatMat = Material("danganronpa/hud/chat_icon.png")
function PLUGIN:DrawPlayersChat()
    for k, v in ipairs(showPlayerList) do
        if !IsValid(v) then continue end

        v.arbTextAlphaChat = Lerp(FrameTime() * 8, v.arbTextAlphaChat, v:IsTyping() and 1 or 0)

        local fraction = v.arbTextAlphaChat
        if fraction <= 0.1 then continue end

        local distance = v:GetPos():DistToSqr(EyePos())
        local alpha = (1 - math.min(distance, d) / d) * 255 * fraction

        local point = self:GetTypingIndicatorPosition(v) - Vector(0, 0, 5 - fraction * 2)
        local data2D = point:ToScreen()

        if !data2D.visible then continue end

        oldColor = LerpColor(FrameTime() * 5, oldColor, getColor(v))

        local scale = (sizeMat * -distance * 0.00001) + 70 * 0.6
        local x, y = data2D.x, data2D.y
        asterionlib.DrawTexturedRect(iconChatMat, x - scale * 0.5, y - scale * 0.5, scale, scale, ColorAlpha(oldColor, alpha * 0.8))
    end
end

function PLUGIN:DrawPlayersVoice()
    local angle = EyeAngles()
    angle:RotateAroundAxis(angle:Forward(), 90)
    angle:RotateAroundAxis(angle:Right(), 90)

    surface.SetFont("arb.Font_FuturaPTBook_30")

    for k, v in ipairs(showPlayerList) do
        if !IsValid(v) then continue end

        local voiceDist = v:GetNetVar("arb.voicescale", 0.5) * 100

        local text = "Говорит"
        if voiceDist >= 70 then
            text = "Кричит"
        elseif voiceDist <= 30 then
            text = "Шепчет"
        end

        local _, textHeight = surface.GetTextSize(text)

        v.arbTextAlphaVoice = Lerp(FrameTime() * 8, v.arbTextAlphaVoice, self.players[v] and 1 or 0)

        local fraction = v.arbTextAlphaVoice
        if fraction <= 0.1 then continue end

        local distance = v:GetPos():DistToSqr(EyePos())
        local alpha = (1 - math.min(distance, d) / d) * 255 * fraction

        cam.Start3D2D(self:GetTypingIndicatorPosition(v), Angle(0, angle.y, 90), 0.05)
            draw.SimpleTextOutlined(text, "arb.Font_FuturaPTBook_30", 0, -textHeight * 0.5 * fraction, ColorAlpha(textColor, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 4, ColorAlpha(shadowColor, alpha))
        cam.End3D2D()
    end
end

function PLUGIN:DrawCircle()
    local client = LocalPlayer()

    if self.alpha2 > 0.2 then
        local value = client:GetNetVar("arb.voicescale", 0.5)
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


function PLUGIN:PostDrawTranslucentRenderables()
    if !allow then return end

    self:DrawPlayersVoice()
    self:DrawCircle()
end

function PLUGIN:HUDPaint()
    self:DrawPlayersChat()
    self:DrawVoiceIcon()
end