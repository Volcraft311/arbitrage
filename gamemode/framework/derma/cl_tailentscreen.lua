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
    self:SetZPos(30001)
    self:SetDrawOnTop(true)

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
    asterionlib.EmitSound("academy/tailentscreen/song.mp3")
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

    asterionlib.DrawTexturedRect(cylinderMat, -cylinderSize + self.cylinderX, h / 2, cylinderSize, cylinderSize, color, rot)
    asterionlib.DrawTexturedRect(circleMat1, -cylinderSize + self.cylinderX, h / 2, cylinderSize * 1.45, cylinderSize * 1.45, nil, -rot)
    asterionlib.DrawTexturedRect(circleMat2, -cylinderSize + self.cylinderX, h / 2, cylinderSize * 1.45, cylinderSize * 1.45, nil, -rot)
end

function PANEL:DrawSprite()
    asterionlib.DrawTexturedRect(self.sprite, self.spriteX - self.BmoveX, self.spriteY - self.BmoveY - self.indent, self.spriteW * self.Bsize, self.spriteH * self.Bsize, {0, 0, 0})
    asterionlib.DrawTexturedRect(self.sprite, self.spriteX, self.spriteY - self.indent, self.spriteW, self.spriteH, {255, 255, 255})
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

        local a = RSize * 0.5
        local b = RSize * 0.25
        local c = RSize * 0.3
        local d = RSize * 0.4
        local e = RSize * 1.1
        local f = RSize * 0.1
        local g = RSize * 0.2

        local m = Matrix()
        m:Rotate(Angle(0, ang, 0))
        m:Scale(Vector(1.1, 1.1, 1))

        cam.PushModelMatrix(m)
            asterionlib.DrawRect(0, y - a, self.lines[2][2], a, {0, 0, 0})
            asterionlib.DrawRect(0, y - a - b, self.lines[3][2], b, color)

            Arbitrage.DrawGradient(GRADIENT_DOWN, 0, y - a - 10, self.lines[3][2], 10, color_black)

            asterionlib.DrawRect(0, y - a - b - c, self.lines[4][2], f, {0, 0, 0})
            asterionlib.DrawRect(0, y - a - b - c - d, self.lines[5][2], RSize * 0.05)
            asterionlib.DrawRect(0, y - a - b - c - d - RSize * 0.6, self.lines[6][2], RSize * 0.6, {255, 255, 255})

            Arbitrage.DrawGradient(GRADIENT_DOWN, 0, y - a - b - c - d - RSize * 0.6 - 10, self.lines[3][2], 10, color_white)

            asterionlib.DrawRect(0, y - a - b - c - d - RSize * 0.6 - c, self.lines[7][2], RSize * 0.06, {255, 255, 255})
            asterionlib.DrawRect(0, y + e, self.lines[8][2], RSize * 0.03, {92, 128, 163})
            asterionlib.DrawRect(0, y + e + f, self.lines[9][2], f, {255, 255, 255})
            asterionlib.DrawRect(0, y + e + d, self.lines[10][2], RSize * 0.09, {0, 0, 0})
            asterionlib.DrawRect(0, y + e + d + b, self.lines[11][2], RSize * 0.05)
            asterionlib.DrawRect(0, y + e + d + b + g, self.lines[12][2], RSize * 0.06, {37, 71, 83})

            local moving = 0
            for k, v in ipairs(self.cubeList) do
                local x = v.size / 2
                draw.NoTexture()
                surface.SetDrawColor(0, 0, 0, self.nameAlpha * 10)
                surface.DrawTexturedRectRotated(w / 2 - self.sizeAllCube / 2 + x + moving + RSize * 2.9 + self.nameMove, y - RSize * 0.5, v.size, v.size, v.rotate)

                moving = moving + v.size - 1
            end

            Arbitrage.DrawGradient(GRADIENT_DOWN, 0, y - 10, self.lines[1][2], 10, color_white)
            asterionlib.DrawRect(0, y, self.lines[1][2], RSize, {255, 255, 255})
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

    asterionlib.DrawTexturedRect(bgMat, w / 2, h / 2, w, h, self.color, 180)
    asterionlib.DrawTexturedRect(bgEffect1, 0, 0, w, h, {0, 0, 0, 40})
    asterionlib.DrawTexturedRect(bgEffect2, 0, 0, w, h, {0, 0, 0, 70})

    self:DrawCylinder(w, h)
    self:DrawLines(w, h)
    self:DrawSprite()

    local sizeW, sizeH = w * 1.03, h * 1.03
    asterionlib.DrawTexturedRect(vignetteMat, w / 2 - sizeW / 2, h / 2 - sizeH / 2, sizeW, sizeH, self.color)
end

vgui.Register("arb.TailentScreen", PANEL, "EditablePanel")