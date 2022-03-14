local PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self.startTime = SysTime()

    local t = Arbitrage.ResolutionH(350)

    self.main = self:Add("Panel")
    self.main:SetPos(ScrW() / 2 - (Arbitrage.ResolutionW(600)) / 2, ScrH() / 2 - (t / 2))
    self.main:SetSize(Arbitrage.ResolutionW(600), 0)

    self.main.Think = function(panel)
        panel:SetTall(Lerp(FrameTime() * 10, panel:GetTall(), t))
    end

    self.main.Paint = function(panel, w, h)
        surface.SetDrawColor(41, 22, 25)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(255, 61, 96, 165.75)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        surface.SetDrawColor(255, 61, 96, 165.75)
        surface.DrawOutlinedRect(0, 0, w, Arbitrage.ResolutionH(23), 2)

        surface.SetDrawColor(255, 61, 96, 20)
        surface.DrawRect(0, 0, w, Arbitrage.ResolutionH(23))

        draw.DrawText("Запустить заставку", "arb.Font_FuturaPTBook_5", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(3), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("Введите название главы", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(28), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
        draw.DrawText("Пример: A Thin Line Devides Heaven and Hell", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("Введите номер главы", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(80 + 28), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
        draw.DrawText("Пример: 2", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(80 + 50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("Введите конечный текст", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(80 + 80 + 28), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
        draw.DrawText("Пример: Продолжение следует", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(80 + 80 + 50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)
    end

    local close = self.main:Add("DButton")
    close:SetPos(self.main:GetWide() - Arbitrage.ResolutionH(70 / 2), 0)
    close:SetSize(Arbitrage.ResolutionH(70 / 2), Arbitrage.ResolutionH(23))
    close:SetText("")
    close.alpha = 40
    close.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 40)
        draw.DrawText("X", "arb.Font_FuturaPTBook_5", w / 2, Arbitrage.ResolutionH(4), Color(255, 255, 255, _.alpha), TEXT_ALIGN_LEFT)
    end
    close.DoClick = function()
        self:AlphaTo(0, 0.2, 0, function()
            self:Remove()
        end)
    end

    self.nameEntry = self.main:Add("DTextEntry")
    self.nameEntry:SetPos(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(75))
    self.nameEntry:SetSize(self.main:GetWide() - Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(25))
    self.nameEntry:SetPlaceholderText("A Thin Line Devides Heaven and Hell")
    self.nameEntry:SetFont("arb.Font_FuturaPTBook_8")

    self.idEntry = self.main:Add("DTextEntry")
    self.idEntry:SetPos(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(155))
    self.idEntry:SetSize(self.main:GetWide() - Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(25))
    self.idEntry:SetPlaceholderText("2")
    self.idEntry:SetFont("arb.Font_FuturaPTBook_8")

    self.descEntry = self.main:Add("DTextEntry")
    self.descEntry:SetValue("Продолжение следует")
    self.descEntry:SetPos(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(235))
    self.descEntry:SetSize(self.main:GetWide() - Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(25))
    self.descEntry:SetPlaceholderText("Продолжение следует")
    self.descEntry:SetFont("arb.Font_FuturaPTBook_8")

    local submitButton = self.main:Add("DButton")
    submitButton:DockMargin(0, Arbitrage.ResolutionH(5), 0, Arbitrage.ResolutionH(5))
    submitButton:SetText("")
    submitButton:SetTall(Arbitrage.ResolutionH(25))
    submitButton:Dock(BOTTOM)
    submitButton.alpha = 0
    submitButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("Запустить", "arb.Font_FuturaPTBook_8", w / 2, Arbitrage.ResolutionH(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end

    submitButton.DoClick = function()
        local a, b, c = self.nameEntry:GetValue(), self.idEntry:GetValue(), self.descEntry:GetValue()
        if a == "" or b == "" or c == "" then return end

        self:AlphaTo(0, 0.3, 0, function()
            self:Remove()
        end)

        netstream.Start("arb.MonoSplashScreen", {
            a, b, c
        })
    end
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.startTime)
end

vgui.Register("arb.MonoMenuSplashScreenSub", PANEL, "EditablePanel")