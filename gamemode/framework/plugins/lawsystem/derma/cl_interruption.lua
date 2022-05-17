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


local PANEL = {}

local assets = {
    Material("danganronpa/law/argue/asset1.png"),
    Material("danganronpa/law/argue/asset2.png")
}

local bg = Material("danganronpa/law/argue/bg1.png")
local bgA = Material("danganronpa/law/argue/bg2.png")

local text = Material("danganronpa/law/argue/text.png")
local textA = Material("danganronpa/law/argue/textblur.png")

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

local speed = 0.3

function PANEL:Init()
    local sizeW, sizeH = ScrW(), ScrH()

    self:SetZPos(9999)
    self:SetAlpha(0)
    self:AlphaTo(255, 0.2)
    self:SetPos(ScrW() / 2 - sizeW / 2, sizeH)
    self:SizeTo(sizeW, sizeH, speed)
    self:MoveTo(self:GetX(), 0, speed)

    self.character = Material("err.png")
    self.StartTime = RealTime()

    timer.Simple(2.5, function()
        if !IsValid(self) then return end

        self:MoveTo(self:GetX() - self:GetWide() / 3, self:GetY() - self:GetTall() / 3, 0.3)
        self:SizeTo(self:GetWide() * 1.5, self:GetTall() * 1.5, 0.3)
        self:AlphaTo(0, 0.2, 0, function()
            self:Remove()
        end)
    end)
end

function PANEL:Paint(w, h)
    local time = RealTime()

    local movePos = -((time - self.StartTime) * 30)
    local tick_assets = math.floor(time * 15 % 2 + 1)
    local tick_anim = math.floor(time * 50 % 4)
    local tick_texts = math.floor(time * 20 % 3 + 1)

    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(bg)
    surface.DrawTexturedRect(2, 0, w, h)

    surface.SetMaterial(bgA)
    surface.DrawTexturedRect(2 + tick_anim, 0, w, h)

    hideRender()
        local poly = {
            {x = w * 0.25, y = 0},
            {x = w * 0.85, y = 0},
            {x = w * 0.44, y = h},
            {x = w * 0.12, y = h}
        }

        draw.NoTexture()
        surface.DrawPoly(poly)
    showRender()
        surface.SetMaterial(self.character)
        surface.DrawTexturedRect(-10, movePos * 1.2 + 100, w - movePos, h - movePos)
    disableRender()

    surface.SetDrawColor(255, 3, 48)
    surface.SetMaterial(textA)
    surface.DrawTexturedRect(0, movePos * 1.5 - tick_texts, w, h)

    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(text)
    surface.DrawTexturedRect(0, movePos * 1.5 - tick_texts, w, h)

    surface.SetMaterial(assets[tick_assets])
    surface.DrawTexturedRect(0, 0, w, h)
end

function PANEL:SetCharacter(data)
    local faction = Arbitrage.teams.Get(data)
    if !faction then return end

    local argue = faction.argue
    if argue then
        self.character = Material(argue)
    end
end

vgui.Register("arb.InterruptionMenu", PANEL, "EditablePanel")