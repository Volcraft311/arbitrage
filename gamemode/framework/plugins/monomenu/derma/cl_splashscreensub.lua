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

    local t = H(350)

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

        draw.DrawText("#monomenu_screen_start", "arb.Font_FuturaPTBook_5", W(10), H(3), color_white, TEXT_ALIGN_LEFT)

        draw.DrawText("#monomenu_screen_setname", "arb.Font_FuturaPTBook_7", W(10), H(28), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText("#monomenu_screen_nameexample", "arb.Font_FuturaPTBook_7", W(10), H(50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("#monomenu_screen_chapternumber", "arb.Font_FuturaPTBook_7", W(10), H(80 + 28), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText("#monomenu_screen_chapterexample", "arb.Font_FuturaPTBook_7", W(10), H(80 + 50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("#monomenu_screen_settext", "arb.Font_FuturaPTBook_7", W(10), H(80 + 80 + 28), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText("#monomenu_screen_textexample", "arb.Font_FuturaPTBook_7", W(10), H(80 + 80 + 50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)
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

    self.nameEntry = self.main:Add("DTextEntry")
    self.nameEntry:SetPos(W(5), H(75))
    self.nameEntry:SetSize(self.main:GetWide() - W(10), H(25))
    self.nameEntry:SetPlaceholderText("#monomenu_screen_example")
    self.nameEntry:SetFont("arb.Font_FuturaPTBook_8")

    self.idEntry = self.main:Add("DTextEntry")
    self.idEntry:SetPos(W(5), H(155))
    self.idEntry:SetSize(self.main:GetWide() - W(10), H(25))
    self.idEntry:SetPlaceholderText("2")
    self.idEntry:SetFont("arb.Font_FuturaPTBook_8")

    self.descEntry = self.main:Add("DTextEntry")
    self.descEntry:SetValue("#monomenu_screen_text")
    self.descEntry:SetPos(W(5), H(235))
    self.descEntry:SetSize(self.main:GetWide() - W(10), H(25))
    self.descEntry:SetPlaceholderText("#monomenu_screen_text")
    self.descEntry:SetFont("arb.Font_FuturaPTBook_8")

    self.changeChapter = self.main:Add("DCheckBoxLabel")
    self.changeChapter:SetText("#monomenu_screen_autoset")
    self.changeChapter:SetPos(W(5), H(270))
    self.changeChapter:SetSize(self.main:GetWide() - W(10), H(25))
    self.changeChapter:SetFont("arb.Font_FuturaPTBook_8")
    self.changeChapter:SetValue(true)

    local submitButton = self.main:Add("DButton")
    submitButton:DockMargin(0, H(5), 0, H(5))
    submitButton:SetText("")
    submitButton:SetTall(H(25))
    submitButton:Dock(BOTTOM)
    submitButton.alpha = 0
    submitButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("#monomenu_splash_start", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end

    submitButton.DoClick = function()
        local a, b, c, d = self.nameEntry:GetValue(), self.idEntry:GetValue(), self.descEntry:GetValue(), self.changeChapter:GetChecked()
        if a == "" or b == "" or c == "" then return end

        self:AlphaTo(0, 0.3, 0, function()
            self:Remove()
        end)

        netstream.Start("arb.MonoSplashScreen", {
            a, b, c, d
        })
    end
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.startTime)
end

vgui.Register("arb.MonoMenuSplashScreenSub", PANEL, "EditablePanel")