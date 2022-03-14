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

local gradientLeft = surface.GetTextureID("vgui/gradient-l")

local PANEL = {}
function PANEL:Init()
    self:SetPos(ScrW() - ScrW() * 0.2, 0)
    self:SetSize(ScrW() * 0.2, ScrH())
end

function PANEL:Paint(w, h)
end

vgui.Register("arb.NotifyPanel", PANEL, "DPanel")


local PANEL = {}
function PANEL:Init()
    if !IsValid(Arbitrage.notifypanel) then return end

    self.timer = 0
    self.emergence = Arbitrage.notifypanel:GetWide()
    self.disappearance = 0
    self.alpha = 255

    self.lines = {}
    for i = 1, 4 do
        self.lines[i] = 0
    end

    Arbitrage.Client():EmitSound("garrysmod/content_downloaded.wav")
end

function PANEL:Paint(w, h)
    local color = self.warning and Color(224, 152, 59) or Color(255, 61, 96)
    w = w + self.emergence + self.disappearance

    surface.SetDrawColor(0, 0, 0, self.alpha * (100 / 255))
    surface.DrawRect(self.disappearance, 0, w, h)

    surface.SetTexture(gradientLeft)
    surface.SetDrawColor(ColorAlpha(color, self.alpha))
    surface.DrawTexturedRect(self.timer, 0, w, h)

    surface.DrawRect(self.disappearance, 0, self.lines[1], 2)
    surface.DrawRect(self.disappearance + w - self.disappearance - 2, 0, 2, self.lines[2])
    surface.DrawRect(w - self.lines[3], h - 2, w + self.lines[3], 2)
    surface.DrawRect(self.disappearance, h - self.lines[4], 2, h + self.lines[4])

    local descHeight = draw.GetFontHeight("ArcadeDescFont")
    local y = -descHeight

    for i, _ in pairs(self.text) do
        local y2 = y + (descHeight * i)
        draw.DrawText(self.text[i], "ArcadeGenericFont", w - 10, y2, ColorAlpha(Color(255, 255, 255), self.alpha), TEXT_ALIGN_RIGHT)
    end

    local time = 1000

    self.lines[2] = self.lines[2] + FrameTime() * time

    if self.lines[2] >= h then
        self.lines[3] = self.lines[3] + FrameTime() * time
    end

    if self.lines[3] >= Arbitrage.notifypanel:GetWide() then
        self.lines[4] = self.lines[4] + FrameTime() * time
    end

    if self.lines[4] >= h then
        self.lines[1] = self.lines[1] + FrameTime() * time
    end

    self.emergence = Lerp(FrameTime() * 10, self.emergence, 0)
    self.timer = self.timer + FrameTime() * (Arbitrage.notifypanel:GetWide() * 0.3)

    if self.timer >= Arbitrage.notifypanel:GetWide() then
        self.alpha = Lerp(FrameTime() * 20, self.alpha, 0)
        self.disappearance = Lerp(FrameTime() * 5, self.disappearance, Arbitrage.notifypanel:GetWide() + 30)
    end

    if self.disappearance >= Arbitrage.notifypanel:GetWide() + 28 and IsValid(self) then
        self:Remove()
    end
end

function PANEL:SetWarning(data)
    self.warning = data
end

function PANEL:SetData(data)
    self.data = data

    local descHeight = draw.GetFontHeight("ArcadeDescFont")
    self.text = Arbitrage.WrapText(self.data, Arbitrage.notifypanel:GetWide() * 0.85, "ArcadeDescFont")

    local y = 0

    for i, _ in pairs(self.text) do
        y = y + descHeight
    end

    self:SetTall(y + 5)
end

vgui.Register("arb.Notify", PANEL, "DPanel")