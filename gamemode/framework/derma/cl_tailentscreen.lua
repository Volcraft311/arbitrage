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

local indentList = {
    chihiro = 120,

    hiyoko = 180,
    teruteru = 190,

    ryoma = 300,

    monokuma = 300,

    jataro = 200,
    kotoko = 200,
    masaru = 200,
    monaca = 200,
    nagisa = 200,
}

local PANEL = {}

local size = 2.1
function PANEL:Init()
    timer.Simple(4, function()
        if IsValid(self) then
            self:AlphaTo(0, 0.5, 0, function()
                self:Remove()
            end)
        end
    end)

    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)

    self.nameAlpha = 0
    self.nameMove = self:GetWide()

    self.name = "???"
    self.title = "???"
    self.color = Color(0, 0, 0)
    self.sprite = nil

    self.BmoveX = 0
    self.BmoveY = 0
    self.Bsize = 1

    local sizeH = self:GetTall()
    local sizeW = sizeH * 0.634765625

    self.spriteW = sizeW * size
    self.spriteH = sizeH * size

    self.spriteX = self:GetWide()
    self.spriteY = -self.spriteH * 0.17

    self.lines = {}
    for i = 1, 12 do
        self.lines[i] = {math.random(), 0}
    end

    self.cylinderX = 0

    local character = Character.team:GetByID(LocalPlayer():Team())
    if !character then return end

    self.name = character:GetName()
    self.title = character:GetTitle()
    self.color = character:GetColor()
    self.uniqueID = character:GetUniqueID()

    self.indent = 0
    if indentList[self.uniqueID] then
        self.indent = indentList[self.uniqueID]
    end

    local assets = character:GetAssets()
    self.sprite = Material(assets.hud)

    self.charList = {}
    for i = 1, utf8.len(self.name) do
        self.charList[i] = {
            symbol = utf8.sub(self.name, i, i),
            size = 0.9 + math.random() * 0.1,
            ang = math.random(-10, 10)
        }
    end

    surface.SetFont("arb.Font_FuturaPTBook_35")
    self.sizeSymbols, _ = surface.GetTextSize(self.name)

    self:GenerateCubes()
    LocalPlayer():EmitSound("academy/tailentscreen/song.mp3")
end

local cylinderMat = Material("danganronpa/law/cylinder.png")
local circleMat1 = Material("danganronpa/tailentscreen/circle_nonblur_white.png")
local circleMat2 = Material("danganronpa/tailentscreen/circle_blur_white.png")

function PANEL:DrawCylinder(w, h)
    local cylinderSize = h * 0.95
    self.cylinderX = Lerp(FrameTime() * 10, self.cylinderX, w + cylinderSize * 0.5 - h * 0.2)

    local rot = RealTime() * 30 % 360

    local add = 70
    local color = Color(self.color.r + add, self.color.g + add, self.color.b + add, 180)

    surface.SetDrawColor(color)
    surface.SetMaterial(cylinderMat)
    surface.DrawTexturedRectRotated(-cylinderSize + self.cylinderX, h / 2, cylinderSize, cylinderSize, rot)

    surface.SetMaterial(circleMat1)
    surface.DrawTexturedRectRotated(-cylinderSize + self.cylinderX, h / 2, cylinderSize * 1.45, cylinderSize * 1.45, -rot)

    surface.SetMaterial(circleMat2)
    surface.DrawTexturedRectRotated(-cylinderSize + self.cylinderX, h / 2, cylinderSize * 1.45, cylinderSize * 1.45, -rot)
end

function PANEL:DrawSprite()
    surface.SetDrawColor(0, 0, 0)
    surface.SetMaterial(self.sprite)
    surface.DrawTexturedRect(self.spriteX - self.BmoveX, self.spriteY - self.BmoveY - self.indent, self.spriteW * self.Bsize, self.spriteH * self.Bsize)

    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(self.sprite)
    surface.DrawTexturedRect(self.spriteX, self.spriteY - self.indent, self.spriteW, self.spriteH)
end

function PANEL:RotatedText(text, x, y, ang, scale, color)
    local m = Matrix()
    m:Translate(Vector(x, y, 0))
    m:Rotate(Angle(0, ang, 0))
    m:Scale(scale)

    cam.PushModelMatrix(m)
        draw.SimpleText(text, "arb.Font_FuturaPTBook_35", 0, 0, ColorAlpha(color, self.nameAlpha), TEXT_ALIGN_LEFT)
    cam.PopModelMatrix()
end

function PANEL:DrawLines(w, h)
    for k, v in ipairs(self.lines) do
        self.lines[k][2] = Lerp(FrameTime() * (3 + v[1] * 5), self.lines[k][2], w)
    end

    local y = h * 0.4
    local RSize = h * 0.09259259259

    local add = 60
    local color = Color(self.color.r + add, self.color.g + add, self.color.b + add, 255)

    do
        local ang = 11

        local m = Matrix()
        m:Rotate(Angle(0, ang, 0))
        m:Scale(Vector(1.1, 1.1, 1))

        cam.PushModelMatrix(m)
            surface.SetDrawColor(0, 0, 0)
            surface.DrawRect(0, y - RSize * 0.5, self.lines[2][2], RSize * 0.5)

            surface.SetDrawColor(color)
            surface.DrawRect(0, y - RSize * 0.5 - RSize * 0.25, self.lines[3][2], RSize * 0.25)
            Arbitrage.DrawGradient(GRADIENT_DOWN, 0, y - RSize * 0.5 - 10, self.lines[3][2], 10, color_black)

            surface.SetDrawColor(0, 0, 0)
            surface.DrawRect(0, y - RSize * 0.5 - RSize * 0.25 - RSize * 0.3, self.lines[4][2], RSize * 0.1)

            surface.SetDrawColor(0, 0, 0)
            surface.DrawRect(0, y - RSize * 0.5 - RSize * 0.25 - RSize * 0.3 - RSize * 0.4, self.lines[5][2], RSize * 0.05)

            surface.SetDrawColor(255, 255, 255)
            surface.DrawRect(0, y - RSize * 0.5 - RSize * 0.25 - RSize * 0.3 - RSize * 0.4 - RSize * 0.6, self.lines[6][2], RSize * 0.6)
            Arbitrage.DrawGradient(GRADIENT_DOWN, 0, y - RSize * 0.5 - RSize * 0.25 - RSize * 0.3 - RSize * 0.4 - RSize * 0.6 - 10, self.lines[3][2], 10, color_white)

            surface.SetDrawColor(255, 255, 255)
            surface.DrawRect(0, y - RSize * 0.5 - RSize * 0.25 - RSize * 0.3 - RSize * 0.4 - RSize * 0.6 - RSize * 0.3, self.lines[7][2], RSize * 0.06)

            surface.SetDrawColor(92, 128, 163)
            surface.DrawRect(0, y + RSize * 1.1, self.lines[8][2], RSize * 0.03)

            surface.SetDrawColor(255, 255, 255)
            surface.DrawRect(0, y + RSize * 1.1 + RSize * 0.1, self.lines[9][2], RSize * 0.1)

            surface.SetDrawColor(0, 0, 0)
            surface.DrawRect(0, y + RSize * 1.1 + RSize * 0.4, self.lines[10][2], RSize * 0.09)

            surface.SetDrawColor(0, 0, 0)
            surface.DrawRect(0, y + RSize * 1.1 + RSize * 0.4 + RSize * 0.25, self.lines[11][2], RSize * 0.05)

            surface.SetDrawColor(37, 71, 83)
            surface.DrawRect(0, y + RSize * 1.1 + RSize * 0.4 + RSize * 0.25 + RSize * 0.2, self.lines[12][2], RSize * 0.06)

            local moving = 0
            for k, v in ipairs(self.cubeList) do
                local x = v.size / 2
                draw.NoTexture()
                surface.SetDrawColor(0, 0, 0, self.nameAlpha * 10)
                surface.DrawTexturedRectRotated(w / 2 - self.sizeAllCube / 2 + x + moving + RSize * 2.9 + self.nameMove, y - RSize * 0.5, v.size, v.size, v.rotate)

                moving = moving + v.size - 1
            end

            Arbitrage.DrawGradient(GRADIENT_DOWN, 0, y - 10, self.lines[1][2], 10, color_white)
            surface.SetDrawColor(255, 255, 255)
            surface.DrawRect(0, y, self.lines[1][2], RSize)
            Arbitrage.DrawGradient(GRADIENT_UP, 0, y + RSize, self.lines[1][2], 10, color_white)

            Arbitrage.DrawTextBlur(self.title, "arb.Font_FuturaPTBook_30", self.lines[1][2] * 0.65, y, Color(0, 0, 0), TEXT_ALIGN_CENTER, color)
        cam.PopModelMatrix()
    end

    do
        local move = 0
        local padding = 0
        local font = "arb.Font_FuturaPTBook_35"
        for k, v in ipairs(self.charList) do
            local symbol = v.symbol
            local ang = v.ang

            surface.SetFont(font)
            local width, _ = surface.GetTextSize(symbol)

            self:RotatedText(symbol, w / 2 - self.sizeSymbols / 2 + move + RSize * 2.5 + self.nameMove, y + RSize * 1.3 + padding, 11 + ang, Vector(v.size, v.size, 1), k == 1 and color or color_white)

            move = move + width + 10
            padding = padding + ScrH() * 0.009
        end
    end
end

function PANEL:GenerateCubes()
    local i = 1
    local sizeCubeAll = 0
    self.cubeList = {}
    while true do
        local ranSize = math.random(80, 180)
        local ranRot = math.random(-20, 20)

        sizeCubeAll = sizeCubeAll + ranSize

        self.cubeList[i] = {
            size = ranSize,
            rotate = ranRot
        }

        i = i + 1
        if sizeCubeAll * 0.8 >= self.sizeSymbols then break end
    end

    self.sizeAllCube = sizeCubeAll
end

local bgMat = Material("danganronpa/splashscreen/bg.png")
local bgEffect1 = Material("danganronpa/tailentscreen/grid1.png")
local bgEffect2 = Material("danganronpa/tailentscreen/grid2.png")
local vignetteMat = Material("danganronpa/splashscreen/vignette.png")

local speedX, speedY, speedSize = 20, 19, 0.02
function PANEL:Paint(w, h)
    local ft = FrameTime()

    self.spriteX = Lerp(ft * 7, self.spriteX, -self.spriteW * 0.25)
    self.BmoveX = self.BmoveX + ft * speedX
    self.BmoveY = self.BmoveY + ft * speedY
    self.Bsize = self.Bsize + ft * speedSize
    self.nameAlpha = Lerp(ft, self.nameAlpha, 256)
    self.nameMove = Lerp(ft * 8, self.nameMove, 0)

    surface.SetDrawColor(self.color)
    surface.SetMaterial(bgMat)
    surface.DrawTexturedRectRotated(w / 2, h / 2, w, h, 180)

    surface.SetDrawColor(0, 0, 0, 40)
    surface.SetMaterial(bgEffect1)
    surface.DrawTexturedRect(0, 0, w, h)

    surface.SetDrawColor(0, 0, 0, 70)
    surface.SetMaterial(bgEffect2)
    surface.DrawTexturedRect(0, 0, w, h)

    self:DrawCylinder(w, h)
    self:DrawLines(w, h)
    self:DrawSprite()

    local sizeW, sizeH = w * 1.03, h * 1.03
    surface.SetDrawColor(self.color)
    surface.SetMaterial(vignetteMat)
    surface.DrawTexturedRect(w / 2 - sizeW / 2, h / 2 - sizeH / 2, sizeW, sizeH)
end

vgui.Register("arb.TailentScreen", PANEL, "EditablePanel")