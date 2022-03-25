--[[
        © Asterion Project 2021.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local PANEL = {}

function PANEL:Init()
    Arbitrage.gui.context = self

    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)

    self:SetKeyboardInputEnabled(false)

    local leftPanel = self:Add("Panel")
    leftPanel:SetWide(W(276))
    leftPanel:Dock(LEFT)
    leftPanel:DockMargin(W(40), 0, 0, 0)

    self.actPanel = leftPanel:Add("Panel")
    self.actPanel:Dock(TOP)
    self.actPanel:DockMargin(0, 0, 0, W(20))
    self.actPanel:SetTall(H(57))
    self.actPanel.Paint = function(_, w, h)
        surface.SetDrawColor(5, 2, 2, 204)
        surface.DrawRect(0, 0, w, h)
    end

    local aTitle = self.actPanel:Add("Panel")
    aTitle:Dock(TOP)
    aTitle:SetTall(H(57))
    aTitle.Paint = function(_, w, h)
        surface.SetDrawColor(255, 61, 96, 89.25)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        draw.SimpleText("Действия", "arb.Font_FuturaPTDemi_12", w / 2, H(7), Color(255, 220, 228, 255), TEXT_ALIGN_CENTER)
    end



    self.dancePanel = leftPanel:Add("Panel")
    self.dancePanel:Dock(TOP)
    self.dancePanel:SetTall(H(57))
    self.dancePanel.Paint = function(_, w, h)
        surface.SetDrawColor(5, 2, 2, 204)
        surface.DrawRect(0, 0, w, h)
    end

    local dTitle = self.dancePanel:Add("Panel")
    dTitle:Dock(TOP)
    dTitle:SetTall(H(57))
    dTitle.Paint = function(_, w, h)
        surface.SetDrawColor(255, 61, 96, 89.25)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        draw.SimpleText("Эмоции", "arb.Font_FuturaPTDemi_12", w / 2, H(7), Color(255, 220, 228, 255), TEXT_ALIGN_CENTER)
    end

    self.dancePanelScroll = self.dancePanel:Add("DScrollPanel")
    self.dancePanelScroll:Dock(FILL)

    local bar = self.dancePanelScroll:GetVBar()
    bar:SetWide(3)
    bar:DockMargin(0, 0, 5, 0)

    bar.Paint = function(_, w, h)
        surface.SetDrawColor(255, 255, 255, 3)
        surface.DrawRect(0, 10, w, h - 20)
    end
    bar.btnUp.Paint = function(_, w, h) end
    bar.btnDown.Paint = function(_, w, h) end
    bar.btnGrip.Paint = function(_, w, h)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawRect(0, 10, w, h - 20)
    end

    hook.Run("ArbitrageContextMenu", self)
end

function PANEL:AddDance(name, command, icon)
    local panel = self.dancePanelScroll:Add("DButton")
    panel:SetText("")
    panel:Dock(TOP)
    panel:SetTall(H(45))
    panel.color = Color(255, 234, 238)
    panel.Paint = function(_, w, h)
        draw.SimpleText(name, "arb.Font_FuturaPTBook_8", W(66), H(10), Color(_.color.r, _.color.g, _.color.b), TEXT_ALIGN_LEFT)

        local ishover = _:IsHovered()
        local frame = FrameTime() * 10

        _.color.r = Lerp(frame, _.color.r, ishover and 255 or 255)
        _.color.g = Lerp(frame, _.color.g, ishover and 61 or 234)
        _.color.b = Lerp(frame, _.color.b, ishover and 96 or 238)

        if icon then
            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(icon)
            surface.DrawTexturedRect(W(66) - W(10) - W(30), h / 2 - H(30) / 2, H(30), H(30))
        end
    end
    panel.DoClick = function()
        RunConsoleCommand("act", command)
    end

    self:FixTall()
end

function PANEL:AddAction(name, callback, icon)
    local panel = self.actPanel:Add("DButton")
    panel:SetText("")
    panel:Dock(TOP)
    panel:SetTall(H(45))
    panel.color = Color(255, 234, 238)
    panel.Paint = function(_, w, h)
        draw.SimpleText(name, "arb.Font_FuturaPTBook_8", W(66), H(10), Color(_.color.r, _.color.g, _.color.b), TEXT_ALIGN_LEFT)

        local ishover = _:IsHovered()
        local frame = FrameTime() * 10

        _.color.r = Lerp(frame, _.color.r, ishover and 255 or 255)
        _.color.g = Lerp(frame, _.color.g, ishover and 61 or 234)
        _.color.b = Lerp(frame, _.color.b, ishover and 96 or 238)

        if icon then
            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(icon)
            surface.DrawTexturedRect(W(66) - W(10) - W(30), h / 2 - H(30) / 2, H(30), H(30))
        end
    end
    panel.DoClick = function()
        if !callback then return end

        callback(LocalPlayer())
    end

    self.actPanel:SetTall(self.actPanel:GetTall() + Arbitrage.ResolutionH(45))
    self.dancePanel:SetTall(H(465))

    self:FixTall()
end

function PANEL:FixTall()
    local actTall = self.actPanel:GetTall()
    local danceTall = self.dancePanel:GetTall()

    local a = actTall + danceTall

    self.actPanel:DockMargin(0, ScrH() / 2 - a / 2, 0, W(20))
end

function PANEL:Paint(w, h)
end

vgui.Register("arb.ContextMenu", PANEL, "DPanel")