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

        draw.DrawText("Введите название текста сверху", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(28), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
        draw.DrawText("Пример: A Thin Line Devides Heaven and Hell", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("Выберите нападавшего персонажа", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(80 + 28), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
        draw.DrawText("Монокума", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(80 + 50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("Выберите убегающего персонажа", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(80 + 80 + 28), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
        draw.DrawText("Кируми Тоджо", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(80 + 80 + 50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)
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

    self.title = self.main:Add("DTextEntry")
    self.title:SetValue("КОНЕЦ ИГРЫ")
    self.title:SetPos(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(75))
    self.title:SetSize(self.main:GetWide() - Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(25))
    self.title:SetPlaceholderText("КОНЕЦ ИГРЫ")
    self.title:SetFont("arb.Font_FuturaPTBook_8")

    self.attackerBox = self.main:Add("DComboBox")
    self.attackerBox:SetFont("arb.Font_FuturaPTBook_8")
    self.attackerBox:SetPos(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(155))
    self.attackerBox:SetSize(self.main:GetWide() - Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(25))
    self.attackerBox.OnSelect = function(_, index, value, data)
        self.attackerS = data
    end

    self.targetBox = self.main:Add("DComboBox")
    self.targetBox:SetFont("arb.Font_FuturaPTBook_8")
    self.targetBox:SetPos(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(235))
    self.targetBox:SetSize(self.main:GetWide() - Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(25))
    self.targetBox.OnSelect = function(_, index, value, data)
        self.targetS = data
    end

    for k, v in SortedPairsByMemberValue(Arbitrage.teams.data, "name") do
        if v.pixel then
            self.attackerBox:AddChoice(v.name, k)
            self.targetBox:AddChoice(v.name, k)
        end
    end

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
        local a, b, c = self.title:GetValue(), self.attackerS, self.targetS
        if a == "" or !b or !c then return end

        self:AlphaTo(0, 0.3, 0, function()
            self:Remove()
        end)

        netstream.Start("arb.MonoEndGame", a, b, c)
    end
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.startTime)
end

vgui.Register("arb.MonoMenuEndGameSub", PANEL, "EditablePanel")