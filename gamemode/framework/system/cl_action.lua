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
    render.ClearStencil()
    render.SetStencilEnable(true)

    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)

    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)
end

local function showRender()
    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(1)
end

local function disableRender()
    render.SetStencilEnable(false)
    render.ClearStencil()
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

    local circledraw = math.Clamp((SysTime() + Arbitrage.action.data.systime) * (360 / Arbitrage.action.data.time), 0, 360)

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

    draw.DrawText(text .. string.rep(".", Arbitrage.action.dot), "arb.Font_FuturaPTBook_10", ScrW() / 2, ScrH() / 2 + 30, color, TEXT_ALIGN_CENTER)

    local circle = Arbitrage.hud.GeneratePoly(ScrW() / 2, ScrH() / 2, 25, 25)
    surface.SetDrawColor(Color(0, 0, 0, Arbitrage.action.data.alpha * 0.3))
    draw.NoTexture()
    surface.DrawPoly(circle)

    hideRender()

    draw.CircleCustom(ScrW() / 2, ScrH() / 2, 25, 5, circledraw, Color(255, 255, 255), -12.5, 0)

    showRender()

    surface.SetDrawColor(Color(Arbitrage.action.data.color.r, Arbitrage.action.data.color.g, Arbitrage.action.data.color.b, Arbitrage.action.data.alpha * 0.5))
    surface.DrawRect(ScrW() / 2 - 50, ScrH() / 2 - 50, 100, 100)

    disableRender()
end