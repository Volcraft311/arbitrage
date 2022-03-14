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

local PANEL = {}

local ffMat = Arbitrage.GetMaterial("danganronpa/law/timer/time_ff.png")
local baseMat = Arbitrage.GetMaterial("danganronpa/law/timer/base.png")
local baseSMat = Arbitrage.GetMaterial("danganronpa/law/timer/base_s.png")

function PANEL:Init()
    local sizeW, sizeH = Arbitrage.ResolutionW(450), Arbitrage.ResolutionH(64)

    self:SetPos(ScrW() - sizeW - 20, ScrH() - sizeH - 50)
    self:SetSize(sizeW, sizeH)

    Arbitrage.gui.timer = self

    self:SetAlpha(0)
    self:AlphaTo(255, 0.5)

    self.startTime = RealTime()
    self.nextThink = 0
    self.numbers = {}
end

function PANEL:Paint(w, h)
    local offset = Arbitrage.ResolutionW(150)

    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(baseMat)
    surface.DrawTexturedRect(Arbitrage.ResolutionW(50), 0, w - Arbitrage.ResolutionW(50), h)

    surface.SetMaterial(baseSMat)
    surface.DrawTexturedRect(0, 0, Arbitrage.ResolutionW(128), Arbitrage.ResolutionW(64))

    surface.SetMaterial(ffMat)
    surface.DrawTexturedRect(-Arbitrage.ResolutionW(25), Arbitrage.ResolutionH(10), Arbitrage.ResolutionW(128), Arbitrage.ResolutionW(64))

    local thisTime = (RealTime()) - self.startTime

    local hours = math.floor(math.fmod(thisTime, 86400) / 3600)
    local minutes = math.floor(math.fmod(thisTime, 3600) / 60)
    local seconds = math.floor(math.fmod(thisTime, 60))

    local _h = string.format("%d", hours)
    local _m = string.format("%d", minutes)
    local _s = string.format("%d", seconds)

    if tonumber(_h) < 10 then _h = "0" .. _h end
    if tonumber(_m) < 10 then _m = "0" .. _m end
    if tonumber(_s) < 10 then _s = "0" .. _s end

    local timeString = Format("%s:%s:%s", _h, _m, _s)

    for k, v in pairs(self.numbers) do
        v.alpha = Lerp(FrameTime() * 8, v.alpha, -10)
        v.x = v.x + FrameTime() * 10
        -- self:CreateText(v.text, offset + v.x + math.random(-5, 5), Arbitrage.ResolutionH(1) + v.y + math.random(-5, 5), v.alpha)
        Arbitrage.DrawTextBlur(v.text, "arb.Font_FuturaPTBook_18", offset + v.x + math.random(-5, 5), Arbitrage.ResolutionH(1) + v.y + math.random(-5, 5), Color(255, 238, 177, v.alpha), TEXT_ALIGN_LEFT)

        if v.alpha <= 0 then
            table.remove(self.numbers, k)
        end
    end

    --self:CreateText(timeString, offset, Arbitrage.ResolutionH(1), 255)
    Arbitrage.DrawTextBlur(timeString, "arb.Font_FuturaPTBook_18", offset, H(1), Color(255, 238, 177, 255), TEXT_ALIGN_LEFT)
end

function PANEL:Think()
    local time = RealTime()
    if time >= self.nextThink then
        table.insert(self.numbers, {
            text = math.random(0, 9),
            x = math.random(-Arbitrage.ResolutionW(10), Arbitrage.ResolutionW(170)),
            y = math.random(-6, 6),
            bias = math.random(0, 1) == 0,
            alpha = 100
        })

        self.nextThink = time + 0.1
    end
end

vgui.Register("arb.LawTimer", PANEL, "EditablePanel")