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

local PLUGIN = PLUGIN

local PANEL = {}

function PANEL:Init()
    self:SetTitle("")
    self:SetPos(0, 0)
    self:SetSize(W(960 * 1.3), H(540 * 1.3))
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self:Center()
    self:ShowCloseButton(false)

    local close = self:Add("DButton")
    close:SetPos(self:GetWide() - H(70), 0)
    close:SetSize(H(70), H(30))
    close:SetText("")
    close.alpha = 40
    close.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 40)
        draw.DrawText("X", "arb.Font_FuturaPTBook_7", w / 2, H(4), Color(255, 255, 255, _.alpha), TEXT_ALIGN_LEFT)
    end

    close.DoClick = function()
        self:AlphaTo(0, 0.2, 0, function()
            self:Remove()
        end)
    end

    Arbitrage.gui.academycharter = self

    self.charterPanel = self:Add("DTextEntry")
    self.charterPanel:SetValue(GetNetVar("arb.Charter", ""))
    self.charterPanel:SetMultiline(true)
    self.charterPanel:SetFont("arb.Font_FuturaPTBook_8")
    self.charterPanel:Dock(FILL)
    self.charterPanel:DockMargin(W(5), H(10), W(5), H(5))
    self.charterPanel:SetDisabled(true)

    local saveButton = self:Add("DButton")
    saveButton:DockMargin(0, H(5), 0, H(5))
    saveButton:SetText("")
    saveButton:SetTall(H(25))
    saveButton:SetDisabled(true)
    saveButton:Dock(BOTTOM)
    saveButton.alpha = 0
    saveButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() and !_:GetDisabled()) and 255 or 30)
        draw.DrawText("Сохранить изменения", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    saveButton.DoClick = function()
        self:AlphaTo(0, 0.3, 0, function()
            self:Remove()
        end)

        netstream.Start("arb.MonoSetCharter", self.charterPanel:GetValue())
    end

    local editButton = self:Add("DButton")
    editButton:DockMargin(0, H(5), 0, H(5))
    editButton:SetText("")
    editButton:SetTall(H(25))
    editButton:Dock(BOTTOM)
    editButton.alpha = 0
    editButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() and self.charterPanel:GetDisabled()) and 255 or 30)
        draw.DrawText("Внести изменить", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    editButton.DoClick = function()
        self.charterPanel:SetDisabled(false)
        saveButton:SetDisabled(false)
    end
end


function PANEL:Paint(w, h)
    surface.SetDrawColor(41, 22, 25)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(255, 61, 96, 165.75)
    surface.DrawOutlinedRect(0, 0, w, h, 2)

    surface.SetDrawColor(255, 61, 96, 165.75)
    surface.DrawOutlinedRect(0, 0, w, H(30), 2)

    surface.SetDrawColor(255, 61, 96, 20)
    surface.DrawRect(0, 0, w, H(30))

    draw.DrawText("Устав академии", "arb.Font_FuturaPTDemi_8", W(10), H(3), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
end

vgui.Register("arb.MonoAcademyCharter", PANEL, "DFrame")