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

local PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self.startTime = SysTime()

    local t = H(390)

    self.main = self:Add("Panel")
    self.main:SetPos(ScrW() / 2 - (W(600)) / 2, ScrH() / 2 - (t / 2))
    self.main:SetSize(W(600), 0)

    self.main.Think = function(panel)
        panel:SetTall(Lerp(FrameTime() * 10, panel:GetTall(), t))
    end

    self.main.Paint = function(panel, w, h)
        surface.SetDrawColor(41, 22, 25)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(255, 61, 96, 165.75)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        surface.SetDrawColor(255, 61, 96, 165.75)
        surface.DrawOutlinedRect(0, 0, w, H(23), 2)

        surface.SetDrawColor(255, 61, 96, 20)
        surface.DrawRect(0, 0, w, H(23))

        draw.DrawText("Запустить заставку", "arb.Font_FuturaPTBook_5", W(10), H(3), color_white, TEXT_ALIGN_LEFT)

        draw.DrawText("Введите название статуса", "arb.Font_FuturaPTBook_7", W(10), H(28), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText("Пример: Свободное время!", "arb.Font_FuturaPTBook_7", W(10), H(50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("Выберите нужный вам цвет", "arb.Font_FuturaPTBook_7", W(10), H(80 + 28), color_white, TEXT_ALIGN_LEFT)
    end

    local close = self.main:Add("DButton")
    close:SetPos(self.main:GetWide() - H(70 / 2), 0)
    close:SetSize(H(70 / 2), H(23))
    close:SetText("")
    close.alpha = 40
    close.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 40)
        draw.DrawText("X", "arb.Font_FuturaPTBook_5", w / 2, H(4), Color(255, 255, 255, _.alpha), TEXT_ALIGN_LEFT)
    end
    close.DoClick = function()
        self:AlphaTo(0, 0.2, 0, function()
            self:Remove()
        end)
    end

    self.title = self.main:Add("DTextEntry")
    self.title:SetValue("Свободное время!")
    self.title:SetPos(W(5), H(75))
    self.title:SetSize(self.main:GetWide() - W(10), H(25))
    self.title:SetPlaceholderText("Свободное время!")
    self.title:SetFont("arb.Font_FuturaPTBook_8")

    local BGPanel = self.main:Add("DPanel")
    BGPanel:SetSize(200, 200)
    BGPanel:SetPos(W(5), H(130))

    local color_label = Label("Color( 255, 255, 255 )", BGPanel)
    color_label:SetPos(40, 160)
    color_label:SetSize(150, 20)
    color_label:SetHighlight(true)
    color_label:SetColor(color_black)

    local color_picker = BGPanel:Add("DRGBPicker")
    color_picker:SetPos(5, 5)
    color_picker:SetSize(30, 190)

    local color_cube = BGPanel:Add("DColorCube")
    color_cube:SetPos(40, 5)
    color_cube:SetSize(155, 155)

    local color_select = nil
    local function UpdateColors(col)
        col.a = 100

        BGPanel:SetBackgroundColor(col)
        color_label:SetText("Color( "..col.r..", "..col.g..", "..col.b.." )")
        color_label:SetColor(Color((255-col.r), (255-col.g), (255-col.b)))
        SetClipboardText(color_label:GetText())

        color_select = col
    end

    function color_picker:OnChange(col)
        local h = ColorToHSV(col)
        local _, s, v = ColorToHSV(color_cube:GetRGB())
        
        col = HSVToColor(h, s, v)
        color_cube:SetColor(col)
        
        UpdateColors(col)
    end

    function color_cube:OnUserChanged(col)
        UpdateColors(col)
    end

    UpdateColors(Color(56, 174, 242, 100))

    local submitButton = self.main:Add("DButton")
    submitButton:DockMargin(0, H(5), 0, H(5))
    submitButton:SetText("")
    submitButton:SetTall(H(25))
    submitButton:Dock(BOTTOM)
    submitButton.alpha = 0
    submitButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("Запустить", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end

    submitButton.DoClick = function()
        local a, b = self.title:GetValue(), color_select
        if a == "" or !b then return end

        self:AlphaTo(0, 0.3, 0, function()
            self:Remove()
        end)

        netstream.Start("arb.MonoChangeStyle", a, b.r, b.g, b.b)
    end
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.startTime)
end

vgui.Register("arb.MonoChangeStyleSub", PANEL, "EditablePanel")