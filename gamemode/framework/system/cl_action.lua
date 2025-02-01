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

local asterionlib = asterionlib
local Arbitrage = Arbitrage
local netstream = netstream
local istable = istable
local tostring = tostring
local tonumber = tonumber
local SysTime = SysTime
local FrameTime = FrameTime
local math_Clamp = math.Clamp
local Color = Color
local draw_SimpleText = draw.SimpleText
local surface_SetDrawColor = surface.SetDrawColor
local draw_NoTexture = draw.NoTexture
local surface_DrawPoly = surface.DrawPoly
local surface_DrawRect = surface.DrawRect
local IsValid = IsValid
local vgui_Create = vgui.Create
local ScrH = ScrH
local ScrW = ScrW
local gui_MousePos = gui.MousePos
local LerpColor = LerpColor
local render_SetScissorRect = render.SetScissorRect
local vgui_Register = vgui.Register

Arbitrage.action = Arbitrage.library.Add("action")

netstream.Hook("arb.ActionEnd", function()
    Arbitrage.action.data = Arbitrage.action.data or {}

    if !IsValid(Arbitrage.gui.action) then return end

    Arbitrage.gui.action.bOnClose = true
    Arbitrage.gui.action:CreateAnimation(delay, {
        index = 4,
        target = {alpha = 0},
        easing = "outQuint",
        Think = function(animation, panel)
            panel:SetAlpha(panel.alpha)
        end,
        OnComplete = function()
            Arbitrage.gui.action:Remove()
        end
    })
end)

netstream.Hook("arb.ActionRun", function(data)
    if !data then return end
    if !istable(data) then return end

    if IsValid(Arbitrage.gui.action) then
        Arbitrage.gui.action:Remove()
    end

    local panel = vgui_Create("Action:Menu")
    panel:SetData({
        text = tostring(data.text),
        time = tonumber(data.time),
        systime = -SysTime()
    })

    Arbitrage.gui.action = panel
end)


local size = ScrH() * 0.3
local PANEL = {}

function PANEL:Init()
    self:SetPos(ScrW() / 2 - size / 2, ScrH() / 2 - size / 2)
    self:SetSize(size, size)
    self:SetZPos(-99999)
    self:SetMouseInputEnabled(false)
    self:SetKeyboardInputEnabled(false)
    self:SetDrawOnTop(true)

    self.hovered = false
    self.outAnimation = 1
    self.data = {}

    self.alpha = 0
    self:SetAlpha(self.alpha)
    self:CreateAnimation(1, {
        index = 4,
        target = {alpha = 255},
        easing = "outQuint",

        Think = function(animation, panel)
            panel:SetAlpha(panel.alpha)
        end
    })
end

function PANEL:SetData(data)
    self.data = data

    self.data.text = self.data.text or "Отсутствует"
    self.data.color = self.data.color or Color(255, 255, 255)
end

function PANEL:HoverPaint(w, h)
    local x, y = self:LocalToScreen(0, 0)
    local mouseX, mouseY = gui_MousePos()

    if mouseX >= x and mouseX <= x + w and mouseY >= y and mouseY <= y + h then
        if !self.hovered then
            self.hovered = true

            if !self.bOnClose then
                self:CreateAnimation(0.5, {
                    index = 4,
                    target = {alpha = 50},
                    easing = "outQuint",
                    Think = function(animation, panel)
                        panel:SetAlpha(panel.alpha)
                    end
                })
            end
        end
    elseif self.hovered then
        self.hovered = false

        if !self.bOnClose then
            self:CreateAnimation(0.5, {
                index = 4,
                target = {alpha = 255},
                easing = "outQuint",

                Think = function(animation, panel)
                    panel:SetAlpha(panel.alpha)
                end
            })
        end
    end
end

local color_unfinished = Color(255, 255, 255)
local color_finished = Color(255, 61, 96)
function PANEL:Paint(w, h)
    self:HoverPaint(w, h)

    local alpha = self:GetAlpha()
    local ft = FrameTime()
    local st = SysTime()
    local circleClamp = math_Clamp((st + self.data.systime) * (360 / self.data.time), 0, 360)

    local bOnFinished = circleClamp >= 300
    self.data.color = LerpColor(ft * 2, self.data.color, bOnFinished and color_finished or color_unfinished)

    draw_SimpleText(self.data.text .. ("."):rep(st * 2 % 5), "arb.Font_FuturaPTBook_10", w / 2, h / 2 + 30, self.data.color, TEXT_ALIGN_CENTER)

    local circle = Arbitrage.hud.GeneratePoly(w / 2, h / 2, 25, 25)
    surface_SetDrawColor(0, 0, 0, alpha * 0.3)
    draw_NoTexture()
    surface_DrawPoly(circle)

    asterionlib.DrawRender(function()
        asterionlib.CircleCustom(w / 2, h / 2, 25, 5, circleClamp, color_white, -12.5, 0)
    end, function()
        surface_SetDrawColor(self.data.color.r, self.data.color.g, self.data.color.b, alpha * 0.5)
        surface_DrawRect(w / 2 - 50, h / 2 - 50, 100, 100)
    end)
end

function PANEL:PaintOver(w, h)
    render_SetScissorRect(0, 0, 0, 0, false)
end

vgui_Register("Action:Menu", PANEL, "DPanel")