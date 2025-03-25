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

-- Localize Global Calls
local RealTime = RealTime
local Material = Material
local Vector = Vector
local Color = Color
local hook_Run = hook.Run
local netstream = netstream
local render_ClearStencil = render.ClearStencil
local render_SetStencilEnable = render.SetStencilEnable
local render_SetStencilWriteMask = render.SetStencilWriteMask
local render_SetStencilTestMask = render.SetStencilTestMask
local render_SetStencilReferenceValue = render.SetStencilReferenceValue
local render_SetStencilFailOperation = render.SetStencilFailOperation
local render_SetStencilCompareFunction = render.SetStencilCompareFunction
local surface = surface
local draw_NoTexture = draw.NoTexture
local surface_DrawPoly = surface.DrawPoly
local IsValid = IsValid
local timer_Create = timer.Create
local ipairs = ipairs
local player_GetAll = player.GetAll
local EyePos = EyePos
local ScrW = ScrW
local Lerp = Lerp
local FrameTime = FrameTime
local ScrH = ScrH
local surface_SetDrawColor = surface.SetDrawColor
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local draw_SimpleText = draw.SimpleText
local surface_DrawRect = surface.DrawRect
local math_min = math.min
local LerpColor = LerpColor
local ColorAlpha = ColorAlpha
local EyeAngles = EyeAngles
local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize
local cam_Start3D2D = cam.Start3D2D
local Angle = Angle
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local cam_End3D2D = cam.End3D2D

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

        if name:lower():find("head") then
            head = i
            break
        end
    end

    local position = head and client:GetBonePosition(head) or ((client:Crouching() and crouchingOffset or standingOffset) + client:GetPos())
    return position + boneOffset
end

function PLUGIN:PlayerStartVoice(client)
    self.players[client] = true

    hook_Run("ArbitrageVoiceStart", client)

    if client == LocalPlayer() then
        net.Start("VoiceDist:StartVoice")
        net.SendToServer()
    end

    return true
end

function PLUGIN:PlayerEndVoice(client)
    self.players[client] = nil

    hook_Run("ArbitrageVoiceEnd", client)

    if client == LocalPlayer() then
        net.Start("VoiceDist:EndVoice")
        net.SendToServer()
    end
end

hook("KeyPressID", function(client, id, bIsVisibleGUI)
    if bIsVisibleGUI then return end
    if id != "voice_up" and id != "voice_down" then return end
    if Arbitrage.gui.chat:GetActive() then return end

    PLUGIN.realtime = RealTime() + 2
    netstream.Start("VOICEDIST:ChangeVoiceVolume", id == "voice_up" and true or false)
end)

do
    function surface.draw_circle_outline(x, y, radius, thickness, passes)
        render_ClearStencil()
        render_SetStencilEnable(true)
        render_SetStencilWriteMask(255)
        render_SetStencilTestMask(255)
        render_SetStencilReferenceValue(28)
        render_SetStencilFailOperation(STENCIL_REPLACE)

        render_SetStencilCompareFunction(STENCIL_EQUAL)
            surface.draw_circle(x, y, radius - (thickness or 1), passes)
            render_SetStencilCompareFunction(STENCIL_NOTEQUAL)
            surface.draw_circle(x, y, radius, passes)
            render_SetStencilEnable(false)
        render_ClearStencil()
    end

    function surface.draw_circle(x, y, radius, passes)
        local info = Arbitrage.hud.GeneratePoly(x, y, radius, passes)

        draw_NoTexture()
        surface_DrawPoly(info)
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
timer_Create("VoiceDist:Update", 1, 0, function()
    showPlayerList = {}

    local client = LocalPlayer()
    allow = isAllow(client)
    if !allow then return end

    for k, v in ipairs(player_GetAll()) do
        if v:IsSpectate() then continue end
        if v:IsNocliping() then continue end
        if v:IsDormant() then continue end

        if !Arbitrage.IsThirdPerson() and v == client then continue end

        local distance = v:GetPos():DistToSqr(EyePos())
        if distance > d then continue end

        v.arbTextAlphaVoice = v.arbTextAlphaVoice or 0
        v.arbTextAlphaChat = v.arbTextAlphaChat or 0
        v.arbTextColorChat = v.arbTextColorChat or Color(238, 220, 194)

        showPlayerList[#showPlayerList + 1] = v
    end
end)

local sizeMat = H(40)
function PLUGIN:DrawVoiceIcon()
    local client = LocalPlayer()
    local size = ScrW() * 0.05
    local ft = FrameTime()
    local value = client:GetNetVar("arb.voicescale", 0.5)
    local bShow = self.realtime >= RealTime()
    local isTalking = self.players[client]

    local a = isTalking and 100 or 0
    if (a == 0 and self.pos > 0.1) or (a == 100 and self.pos < 99.9) then
        self.pos = Lerp(ft * 10, self.pos, a)
    end

    if self.pos > 0.1 and self.pos < 99.9 then
        self.alpha = Lerp(ft * sizeMat, self.alpha, a * 2.55)
    end

    if self.alpha > 0.2 then
        local isGlobal = client:GetNetVar("arbGlobalVoice")
        local color = isGlobal and Color(255, 61, 96, self.alpha) or Color(255, 255, 255, self.alpha * value)

        local x = ScrW() / 2
        local y = ScrH() - self.pos

        surface_SetDrawColor(color)
        surface_SetMaterial(mat)
        surface_DrawTexturedRect(x - sizeMat / 2, y, sizeMat, sizeMat)

        if !isGlobal then
            draw_SimpleText(value * 100 .. "%", "arb.Font_FuturaPTBook_4", x, y + sizeMat * 1.2, color, TEXT_ALIGN_CENTER)
        end
    end

    local b = bShow and 100 or 0
    if (b == 0 and self.pos2 > 0.1) or (b == 100 and self.pos2 < 99.9) then
        self.pos2 = Lerp(ft * 10, self.pos2, b)
    end

    if self.pos2 > 0.1 and self.pos2 < 99.9 then
        self.alpha2 = Lerp(ft * 20, self.alpha2, b * 2.55)
    end

    local c = (size * 2) * value
    if self.lerp < c - 0.05 or self.lerp > c + 0.05 then
        self.lerp = Lerp(ft * 15, self.lerp, c)
    end

    if self.alpha2 > 0.2 then
        draw_SimpleText(L("#voice_range") .. ": " .. value * 100 .. "%", "arb.Font_FuturaPTBook_6", ScrW() / 2, ScrH() - self.pos2 * 3 - ScrH() * 0.025, Color(255, 255, 255, self.alpha2), TEXT_ALIGN_CENTER)

        surface_SetDrawColor(255, 255, 255, self.alpha2 * 0.1)
        surface_DrawRect(ScrW() / 2 - size, ScrH() - self.pos2 * 3, size * 2, 5)

        surface_SetDrawColor(255, 255, 255, self.alpha2)
        surface_DrawRect(ScrW() / 2 - size, ScrH() - self.pos2 * 3, self.lerp, 5)
    end
end

local colors = {
    ["me"] = Color(44, 176, 247),
    ["mec"] = Color(44, 176, 247),
    ["mel"] = Color(44, 176, 247),

    ["try"] = Color(44, 247, 85),
    ["tryc"] = Color(44, 247, 85),
    ["tryl"] = Color(44, 247, 85),

    ["it"] = Color(255, 255, 255),
    ["itc"] = Color(255, 255, 255),
    ["itl"] = Color(255, 255, 255),

    ["looc"] = Color(190, 62, 62),
    ["ooc"] = Color(236, 62, 62),
    ["roll"] = Color(209, 69, 69),
    ["command"] = Color(121, 17, 255),
}

local function getColor(client)
    local var = client:GetNetVar("arb.chattype")

    local color = colors[var]
    if color then
        return color
    end

    return Color(238, 220, 194)
end

local iconChatMat = Material("danganronpa/hud/chat_icon.png")
function PLUGIN:DrawPlayersChat()
    local eyepos = EyePos()
    local ft = FrameTime()

    for k, v in ipairs(showPlayerList) do
        if !IsValid(v) then continue end

        local a = v:IsTyping() and 1 or 0
        if (a == 1 and v.arbTextAlphaChat < 0.95) or (a == 0 and v.arbTextAlphaChat > 0.05) then
            v.arbTextAlphaChat = Lerp(ft * 8, v.arbTextAlphaChat, a)
        end

        local fraction = v.arbTextAlphaChat
        if fraction <= 0.1 then continue end

        local distance = v:GetPos():DistToSqr(eyepos)
        local alpha = (1 - math_min(distance, d) / d) * 255 * fraction

        local pos = self:GetTypingIndicatorPosition(v) - Vector(0, 0, 5 - fraction * 2)
        local data2D = pos:ToScreen()

        if !data2D.visible then continue end

        local bNotVisible = util.VectorObstructed(eyepos, pos, v)
        if bNotVisible then continue end

        v.arbTextColorChat = LerpColor(ft * 5, v.arbTextColorChat, getColor(v))

        local scale = (sizeMat * -distance * 0.00001) + 70 * 0.6
        local x, y = data2D.x, data2D.y
        asterionlib.DrawTexturedRect(iconChatMat, x - scale * 0.5, y - scale * 0.5, scale, scale, ColorAlpha(v.arbTextColorChat, alpha * 0.8))
    end
end

function PLUGIN:DrawPlayersVoice()
    local angle = EyeAngles()
    angle:RotateAroundAxis(angle:Forward(), 90)
    angle:RotateAroundAxis(angle:Right(), 90)

    surface_SetFont("arb.Font_FuturaPTBook_30")

    local ft = FrameTime()

    for k, v in ipairs(showPlayerList) do
        if !IsValid(v) then continue end

        local voiceDist = v:GetNetVar("arb.voicescale", 0.5) * 100

        local text = "Говорит"
        if voiceDist >= 70 then
            text = "Кричит"
        elseif voiceDist <= 30 then
            text = "Шепчет"
        end

        local _, textHeight = surface_GetTextSize(text)

        local a = self.players[v] and 1 or 0
        if (a == 1 and v.arbTextAlphaVoice < 0.95) or (a == 0 and v.arbTextAlphaVoice > 0.05) then
            v.arbTextAlphaVoice = Lerp(ft * 8, v.arbTextAlphaVoice, a)
        end

        local fraction = v.arbTextAlphaVoice
        if fraction <= 0.1 then continue end

        local distance = v:GetPos():DistToSqr(EyePos())
        local alpha = (1 - math_min(distance, d) / d) * 255 * fraction

        cam_Start3D2D(self:GetTypingIndicatorPosition(v), Angle(0, angle.y, 90), 0.05)
            draw_SimpleTextOutlined(text, "arb.Font_FuturaPTBook_30", 0, -textHeight * 0.5 * fraction, ColorAlpha(textColor, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 4, ColorAlpha(shadowColor, alpha))
        cam_End3D2D()
    end
end

function PLUGIN:DrawCircle()
    local client = LocalPlayer()

    if self.alpha2 > 0.2 then
        local value = client:GetNetVar("arb.voicescale", 0.5)
        local dist = 650

        if self.lerp2 < value - 0.00001 or self.lerp2 > value + 0.00001 then
            self.lerp2 = Lerp(FrameTime() * 10, self.lerp2, value)
        end

        cam_Start3D2D(client:GetPos() + Vector(0, 0, 5), Angle(0, 0, 0), 1)
            surface_SetDrawColor(0, 255, 85, self.alpha2)
            surface.draw_circle_outline(0, 0, dist * 1, 3, 50)

            surface_SetDrawColor(255, 0, 0, self.alpha2)
            surface.draw_circle_outline(0, 0, dist * 0.1, 3, 50)

            surface_SetDrawColor(255, 255, 255, self.alpha2)
            surface.draw_circle_outline(0, 0, dist * self.lerp2, 3, 50)
        cam_End3D2D()
    end
end


function PLUGIN:PostDrawTranslucentRenderables()
    if !allow then return end

    self:DrawPlayersVoice()
    self:DrawCircle()
end

function PLUGIN:HUDPaint()
    if SETTINGS.options.Get("show_chaticon") then
        self:DrawPlayersChat()
    end

    self:DrawVoiceIcon()
end