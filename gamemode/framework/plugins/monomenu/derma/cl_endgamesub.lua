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

    local t = H(500)

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

        draw.DrawText(L("#monomenu_splash_startscreen"), "arb.Font_FuturaPTBook_5", W(10), H(3), color_white, TEXT_ALIGN_LEFT)

        draw.DrawText(L("#monomenu_endgame_settitle"), "arb.Font_FuturaPTBook_7", W(10), H(28), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText(L("#monomenu_endgame_titleexample"), "arb.Font_FuturaPTBook_7", W(10), H(50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText(L("#monomenu_endgame_setfirst"), "arb.Font_FuturaPTBook_7", W(10), H(80 + 28), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText(L("#monomenu_endgame_firstexample"), "arb.Font_FuturaPTBook_7", W(10), H(80 + 50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText(L("#monomenu_endgame_setsecond"), "arb.Font_FuturaPTBook_7", W(10), H(80 + 80 + 28), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText(L("#monomenu_endgame_secondexample"), "arb.Font_FuturaPTBook_7", W(10), H(80 + 80 + 50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText(L("#monomenu_endgame_settext1"), "arb.Font_FuturaPTBook_7", W(10), H(80 + 80 + 80 + 28), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText(L("#monomenu_endgame_text1example"), "arb.Font_FuturaPTBook_7", W(10), H(80 + 80 + 80 + 50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText(L("#monomenu_endgame_settext2"), "arb.Font_FuturaPTBook_7", W(10), H(80 + 80 + 80 + 80 + 28), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText(L("#monomenu_endgame_text2example"), "arb.Font_FuturaPTBook_7", W(10), H(80 + 80 + 80 + 80 + 50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)
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
    self.title:SetValue(L("#monomenu_endgame_gameover"))
    self.title:SetPos(W(5), H(75))
    self.title:SetSize(self.main:GetWide() - W(10), H(25))
    self.title:SetPlaceholderText(L("#monomenu_endgame_gameover"))
    self.title:SetFont("arb.Font_FuturaPTBook_8")

    self.attackerBox = self.main:Add("DComboBox")
    self.attackerBox:SetFont("arb.Font_FuturaPTBook_8")
    self.attackerBox:SetPos(W(5), H(155))
    self.attackerBox:SetSize(self.main:GetWide() - W(10), H(25))
    self.attackerBox.OnSelect = function(_, index, value, data)
        self.attackerS = data
    end

    self.targetBox = self.main:Add("DComboBox")
    self.targetBox:SetFont("arb.Font_FuturaPTBook_8")
    self.targetBox:SetPos(W(5), H(235))
    self.targetBox:SetSize(self.main:GetWide() - W(10), H(25))
    self.targetBox.OnSelect = function(_, index, value, data)
        self.targetS = data
    end

    self.text1 = self.main:Add("DTextEntry")
    self.text1:SetValue(L("#monomenu_endgame_text1example"))
    self.text1:SetPos(W(5), H(315))
    self.text1:SetSize(self.main:GetWide() - W(10), H(25))
    self.text1:SetPlaceholderText(L("#monomenu_endgame_text1example"))
    self.text1:SetFont("arb.Font_FuturaPTBook_8")

    self.text2 = self.main:Add("DTextEntry")
    self.text2:SetValue(L("#monomenu_endgame_text2example"))
    self.text2:SetPos(W(5), H(395))
    self.text2:SetSize(self.main:GetWide() - W(10), H(25))
    self.text2:SetPlaceholderText(L("#monomenu_endgame_text2example"))
    self.text2:SetFont("arb.Font_FuturaPTBook_8")

    for k, v in SortedPairsByMemberValue(Character.team.instances, "name") do
        if v:GetAssets().pixel then
            self.attackerBox:AddChoice(L(v:GetName()), k)
            self.targetBox:AddChoice(L(v:GetName()), k)
        end
    end

    local submitButton = self.main:Add("DButton")
    submitButton:DockMargin(0, H(5), 0, H(5))
    submitButton:SetText("")
    submitButton:SetTall(H(25))
    submitButton:Dock(BOTTOM)
    submitButton.alpha = 0
    submitButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText(L("#monomenu_splash_start"), "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end

    submitButton.DoClick = function()
        local a, b, c, d, e = self.title:GetValue(), self.attackerS, self.targetS, self.text1:GetValue(), self.text2:GetValue()
        if a == "" or !b or !c or d == "" or e == "" then return end

        self:AlphaTo(0, 0.3, 0, function()
            self:Remove()
        end)

        netstream.Start("arb.MonoEndGame", a, b, c, d, e)
    end
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.startTime)
end

vgui.Register("arb.MonoMenuEndGameSub", PANEL, "EditablePanel")