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

local material_logo = Arbitrage.GetMaterial("danganronpa/ui/logo.png")

local material_bg = Arbitrage.GetMaterial("danganronpa/ui/bg.png")
local material_bg_glass = Arbitrage.GetMaterial("danganronpa/ui/bg_glassshards.png")
local material_bg_light = Arbitrage.GetMaterial("danganronpa/ui/bg_light.png")

function PANEL:Init()
    Arbitrage.menu = self

    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.2)

    self.logo = self:Add("DPanel")
    self.logo:SetSize(W(646), H(80))
    self.logo:SetPos(ScrW() / 2 - W(646) / 2, H(80))
    self.logo.Paint = function(_, w, h)
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(material_logo)
        surface.DrawTexturedRect(0, 0, w, h)
    end

    self.bluring = false
    self.bluringM = 0
    self.listCircle = {}
end

function PANEL:DesignButton(panel, text, w, h, icon)
    panel.alpha = panel.alpha or 0.1
    panel.alpha = Lerp(FrameTime() * 10, panel.alpha, (panel:IsHovered() and panel:IsEnabled()) and 1 or 0.1)

    surface.SetDrawColor(15, 5, 6, 204)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(155, 35, 57, 255 * panel.alpha)
    surface.DrawOutlinedRect(0, 0, w, h, 2)

    if text then
        draw.DrawText(text, "arb.Font_FuturaPTBook_10", w / 2, H(9), Color(255, 234, 238, 255 * panel.alpha), TEXT_ALIGN_CENTER)
    end

    if icon then
        surface.SetDrawColor(255, 255, 255, 255 * panel.alpha)
        surface.SetMaterial(icon)
        surface.DrawTexturedRect(0, 0, w, h)
    end
end

function PANEL:AddOption(panel, buttonText, descText, buttonWide, descWide)
    local option = panel:Add("Panel")
    option:Dock(LEFT)

    local button = option:Add("DLabel")
    button:SetFont("arb.Font_FuturaPTDemi_6")
    button:SetText(buttonText)
    button:SetContentAlignment(5)
    button:Dock(LEFT)
    button:SetWide(buttonWide)
    button.Paint = function(_, w, h)
        surface.SetDrawColor(15, 5, 6, 204)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(155, 35, 57, 100)
        surface.DrawOutlinedRect(0, 0, w, h, 2)
    end

    local desc = option:Add("DLabel")
    desc:SetFont("arb.Font_FuturaPTDemi_9")
    desc:SetText(descText)
    desc:Dock(LEFT)
    desc:SetWide(descWide)
    desc:DockMargin(W(10), 0, 0, 0)
    desc:SizeToContents()

    option:SetWide(buttonWide + descWide)

    return option
end

function PANEL:RegisterCategory(panel, x, y, w, h)
    local category = panel:Add("Panel")
    category:SetPos(x, y)
    category:SetSize(w, h)
    category.panels = {}
    category:SetAlpha(0)
    category:AlphaTo(255, 0.3)
    category.Paint = function(_, w, h)
        surface.SetDrawColor(255, 234, 238, 20)
        surface.DrawRect(0, 0, w, H(2))
        surface.DrawRect(0, h - H(2), w, H(2))
    end

    function category:AddButton(text, wide, callback, bSelection)
        local button = category:Add("DButton")
        button:SetText("")
        button:SetWide(wide)
        button:Dock(LEFT)
        button.alpha = 0.1
        button.alpha2 = 0
        button.select = bSelection and true or false
        button.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 1 or 0.1)
            _.alpha2 = Lerp(FrameTime() * 10, _.alpha2, _.select and 1 or -0.1)

            Arbitrage.DrawTextBlur(text, "arb.Font_FuturaPTDemi_11", w / 2, H(12), Color(255, 238, 177, 255 * _.alpha2), TEXT_ALIGN_CENTER)

            if !button.select then
                draw.DrawText(text, "arb.Font_FuturaPTDemiBlurN_11", w / 2, H(12), Color(255, 234, 238, 255 * _.alpha), TEXT_ALIGN_CENTER)
            end
        end
        button.DoClick = function(_, bIgnore)
            if button.select and !bIgnore then return end
            if !callback then return end

            for k, v in ipairs(category.panels) do
                if !IsValid(v) then continue end

                v.select = false
            end

            button.select = true
            callback()
        end

        if button.select then
            button:DoClick(true)
        end

        category.panels[#category.panels + 1] = button

        return category
    end

    function category:AddSlash()
        local slash = category:Add("DLabel")
        slash:SetText("/")
        slash:SetWide(W(30))
        slash:SetContentAlignment(5)
        slash:SetFont("arb.Font_FuturaPTBook_11")
        slash:SetAlpha(20)
        slash:Dock(LEFT)

        return category
    end

    return category
end

function PANEL:Intro()
    self.intro = self:Add("arb.MainRemake:Intro")
end

function PANEL:Menu()
    self.menu = self:Add("arb.MainRemake:Menu")
end

function PANEL:Characters()
    self.characters = self:Add("arb.MainRemake:Characters")
end

function PANEL:Settings()
    self.settings = self:Add("arb.MainRemake:Settings")
end

function PANEL:ShowLogo(bState)
    if !IsValid(self.logo) then return end

    self.logo:AlphaTo(bState and 255 or 0, 0.3)
end

function PANEL:Bluring(bState)
    self.bluring = bState
end

function PANEL:RemoveButtons()
    local data = {}

    for k, v in pairs(IsValid(self.menu) and self.menu.panels or {}) do data[#data + 1] = v end
    data[#data + 1] = self.menu
    data[#data + 1] = self.logo
    data[#data + 1] = self.intro
    data[#data + 1] = self.characters

    for k, v in pairs(data) do
        if IsValid(v) then
            v:AlphaTo(0, 0.2, 0, function()
                v:Remove()
            end)
        end
    end
end

function PANEL:ClosePanel()
    self:RemoveButtons()
    self:SetMouseInputEnabled(false)
    self:SetKeyboardInputEnabled(false)
    self:AlphaTo(0, 0.5, 0, function()
        self:Remove()

        timer.Simple(1, function()
            Arbitrage.StartCaching()
        end)
    end)
end

local lerpX, lerpY = 0, 0
local lerpX_g, lerpY_g = lerpX, lerpY
local lerpX_l, lerpY_l = lerpX, lerpY

local padding = 0.07
local speed = 1

local mat = Arbitrage.GetMaterial("danganronpa/ui/circle.png")

local function GenerateCircle(screenWide, screenTall)
    local data = {
        x = math.random(0, screenWide),
        y = screenTall + math.random(0, screenTall),
        size = math.random(10, 45),
        alpha = math.random(0, 150),
        speedUplift = math.random(1, 25),
        speedPushing = math.random(1, 50),
        pushing = math.random(0, 1) == 1 and true or false
    }

    return data
end

function PANEL:Paint(w, h)
    -- АНИМАЦИЯ BG НА МЫШКУ
    local x, y = math.Clamp(gui.MouseX(), 0, ScrW()), math.Clamp(gui.MouseY(), 0, ScrH())
    local Wx, Wy = -((ScrW() / 2 - x) * padding), -((ScrH() / 2 - y) * padding)

    local sizeX = ScrW() / 2 * padding
    local sizeY = ScrH() / 2 * padding

    lerpX = Lerp(FrameTime() * speed, lerpX, Wx)
    lerpY = Lerp(FrameTime() * speed, lerpY, Wy)

    lerpX_g = Lerp(FrameTime() * (speed * 3), lerpX_g, Wx)
    lerpY_g = Lerp(FrameTime() * (speed * 3), lerpY_g, Wy)

    lerpX_l = Lerp(FrameTime() * (speed * 10), lerpX_l, Wx)
    lerpY_l = Lerp(FrameTime() * (speed * 10), lerpY_l, Wy)

    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(material_bg)
    surface.DrawTexturedRect(0 - lerpX - sizeX, 0 - lerpY - sizeY, w + sizeX * 2, h + sizeY * 2)

    surface.SetDrawColor(0, 0, 0, 160)
    surface.DrawRect(0, 0, w, h)

    draw.DrawText("Asterion Danganronpa © 2022 Asterion Staff", "arb.Font_FuturaPTBook_5", w / 2, h - H(30), Color(255, 234, 238, 7), TEXT_ALIGN_CENTER)
    draw.DrawText("v" .. Arbitrage.version, "arb.Font_FuturaPTBook_5", w - W(30), h - H(30), Color(255, 234, 238, 7), TEXT_ALIGN_RIGHT)

    surface.SetDrawColor(255, 255, 255, 150)
    surface.SetMaterial(material_bg_glass)
    surface.DrawTexturedRect(0 - lerpX_g - sizeX, 0 - lerpY_g - sizeY, w + sizeX * 2, h + sizeY * 2)

    surface.SetDrawColor(255, 255, 255, 25)
    surface.SetMaterial(material_bg_light)
    surface.DrawTexturedRect(0 - lerpX_l - sizeX, 0 - lerpY_l - sizeY, w + sizeX * 2, h + sizeY * 2)

    -- СОЗДАЕМ
    if #self.listCircle < 50 then
        local circle = GenerateCircle(ScrW(), ScrH())
        table.insert(self.listCircle, circle)
    end

    for k, v in pairs(self.listCircle) do
        -- ДВИГАЕМ
        local speedUplift = v.y - FrameTime() * v.speedUplift * 10
        local speedPush = FrameTime() * v.speedPushing * 5

        v.y = speedUplift
        v.x = v.x + (v.pushing and speedPush or -speedPush)

        -- МЕНЯЕМ СКОРОСТЬ ПО ПРИКОЛУ
        if math.random(0, 1000) == 1 then
            v.speedUplift = math.max(1, v.speedUplift + math.random(-5, 5))
            v.speedPushing = math.max(1, v.speedPushing + math.random(-5, 5))
        end

        -- РИСУЕМ
        if (v.x >= -100 and v.x <= ScrW() + 100) and (v.y >= -50 and v.y <= ScrH() + 50) then
            surface.SetDrawColor(255, 61, 96, v.alpha)
            surface.SetMaterial(mat)
            surface.DrawTexturedRect(lerpX + v.x, lerpY + v.y, v.size, v.size)
        end

        -- УДАЛЯЕМ
        if v.y <= -10 then table.remove(self.listCircle, k) end
        if v.x <= -100 or v.x >= ScrW() + 100 then table.remove(self.listCircle, k) end
    end

    self.bluringM = Lerp(FrameTime() * 2, self.bluringM, self.bluring and 1 or 0)

    if self.bluringM >= 0.01 then
        Arbitrage.DrawBlur(self, 10 * self.bluringM)

        surface.SetDrawColor(0, 0, 0, 200 * self.bluringM)
        surface.DrawRect(0, 0, w, h)
    end
end

vgui.Register("arb.MainRemake:UI", PANEL, "EditablePanel")



if LocalPlayer() and IsValid(Arbitrage.menu) then
    Arbitrage.menu:Remove()

    Arbitrage.menu = vgui.Create("arb.MainRemake:UI")

    if SETTINGS.options.Get("show_beta_test") then
        Arbitrage.menu:Menu()
    else
        Arbitrage.menu:Intro()
    end
end