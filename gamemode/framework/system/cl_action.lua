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

local asterionlib = asterionlib
local Arbitrage = Arbitrage
local netstream = netstream
local istable = istable
local tostring = tostring
local tonumber = tonumber
local SysTime = SysTime
local render_ClearStencil = render.ClearStencil
local render_SetStencilEnable = render.SetStencilEnable
local render_SetStencilWriteMask = render.SetStencilWriteMask
local render_SetStencilTestMask = render.SetStencilTestMask
local render_SetStencilFailOperation = render.SetStencilFailOperation
local render_SetStencilPassOperation = render.SetStencilPassOperation
local render_SetStencilZFailOperation = render.SetStencilZFailOperation
local render_SetStencilCompareFunction = render.SetStencilCompareFunction
local render_SetStencilReferenceValue = render.SetStencilReferenceValue
local Lerp = Lerp
local FrameTime = FrameTime
local CurTime = CurTime
local math_Clamp = math.Clamp
local Color = Color
local draw_SimpleText = draw.SimpleText
local string_rep = string.rep
local surface_SetDrawColor = surface.SetDrawColor
local draw_NoTexture = draw.NoTexture
local surface_DrawPoly = surface.DrawPoly
local surface_DrawRect = surface.DrawRect

Arbitrage.action = Arbitrage.library.Add("action")

netstream.Hook("arb.ActionEnd", function()
    Arbitrage.action.data = Arbitrage.action.data or {}

    Arbitrage.action.data.run = false
end)

netstream.Hook("arb.ActionRun", function(data)
    if !data then return end
    if !istable(data) then return end

    Arbitrage.action.data = {
        text = tostring(data.text),
        time = tonumber(data.time),
        systime = -SysTime(),
        run = true,
    }
end)

local function hideRender()
    render_ClearStencil()
    render_SetStencilEnable(true)

    render_SetStencilWriteMask(1)
    render_SetStencilTestMask(1)

    render_SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render_SetStencilPassOperation(STENCILOPERATION_ZERO)
    render_SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render_SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render_SetStencilReferenceValue(1)
end

local function showRender()
    render_SetStencilFailOperation(STENCILOPERATION_ZERO)
    render_SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render_SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render_SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render_SetStencilReferenceValue(1)
end

local function disableRender()
    render_SetStencilEnable(false)
    render_ClearStencil()
end

function Arbitrage.action.Draw()
    if !Arbitrage.action.data then return end
    if !istable(Arbitrage.action.data) then return end
    if !Arbitrage.action.data.systime then return end

    Arbitrage.action.data.alpha = Arbitrage.action.data.alpha or 0
    Arbitrage.action.data.alpha = Lerp(FrameTime() * 5, Arbitrage.action.data.alpha, Arbitrage.action.data.run and 256 or -1)

    if Arbitrage.action.data.alpha <= 0.05 then return end

    if (!Arbitrage.action.timeDot or CurTime() >= Arbitrage.action.timeDot) then
        Arbitrage.action.dot = Arbitrage.action.dot and (Arbitrage.action.dot + 1) or 0
        if Arbitrage.action.dot >= 5 then Arbitrage.action.dot = 1 end

        Arbitrage.action.timeDot = CurTime() + 1
    end

    local circledraw = math_Clamp((SysTime() + Arbitrage.action.data.systime) * (360 / Arbitrage.action.data.time), 0, 360)

    Arbitrage.action.data.color = Arbitrage.action.data.color or {
        r = 255,
        g = 255,
        b = 255
    }

    Arbitrage.action.data.color.r = Lerp(FrameTime() * 2, Arbitrage.action.data.color.r, circledraw >= 300 and 255 or 255)
    Arbitrage.action.data.color.g = Lerp(FrameTime() * 2, Arbitrage.action.data.color.g, circledraw >= 300 and 61 or 255)
    Arbitrage.action.data.color.b = Lerp(FrameTime() * 2, Arbitrage.action.data.color.b, circledraw >= 300 and 96 or 255)

    local color = Color(
        Arbitrage.action.data.color.r,
        Arbitrage.action.data.color.g,
        Arbitrage.action.data.color.b,
        Arbitrage.action.data.alpha
    )

    local text = Arbitrage.action.data.text or "Отсутствует"

    draw_SimpleText(text .. string_rep(".", Arbitrage.action.dot), "arb.Font_FuturaPTBook_10", ScrW() / 2, ScrH() / 2 + 30, color, TEXT_ALIGN_CENTER)

    local circle = Arbitrage.hud.GeneratePoly(ScrW() / 2, ScrH() / 2, 25, 25)
    surface_SetDrawColor(Color(0, 0, 0, Arbitrage.action.data.alpha * 0.3))
    draw_NoTexture()
    surface_DrawPoly(circle)

    hideRender()

    asterionlib.CircleCustom(ScrW() / 2, ScrH() / 2, 25, 5, circledraw, Color(255, 255, 255), -12.5, 0)

    showRender()

    surface_SetDrawColor(Color(Arbitrage.action.data.color.r, Arbitrage.action.data.color.g, Arbitrage.action.data.color.b, Arbitrage.action.data.alpha * 0.5))
    surface_DrawRect(ScrW() / 2 - 50, ScrH() / 2 - 50, 100, 100)

    disableRender()
end