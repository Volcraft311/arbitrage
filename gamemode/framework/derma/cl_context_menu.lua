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

    self.favoritesPanel = leftPanel:Add("Panel")
    self.favoritesPanel:Dock(TOP)
    self.favoritesPanel:DockMargin(0, 0, 0, W(20))
    self.favoritesPanel:SetTall(H(57))
    self.favoritesPanel.Paint = function(_, w, h)
        surface.SetDrawColor(5, 2, 2, 204)
        surface.DrawRect(0, 0, w, h)
    end

    self.statusPanel = self:Add("Panel")
    self.statusPanel:SetWide(ScrH() * 0.3)
    self.statusPanel:Dock(RIGHT)
    self.statusPanel:DockMargin(0, H(100), 0, 0)

    local padding = W(40)
    local size = H(25)
    local i = 0
    for k, v in SortedPairsByMemberValue(LocalPlayer():GetTemporaryStatusEffects(), "delay") do
        local uniqueID = v.uniqueID
        local info = Medical.t_status_effects[uniqueID]

        if info.isHidden then continue end

        local material = Material(info.icon or "err.png")

        local isHover = false
        local tooltip = self:Add("DLabel")
        tooltip.text = Medical:FormatTemporaryDescription(uniqueID, info.description)
        tooltip.len = 0
        tooltip.lenMax = utf8.len(tooltip.text)
        tooltip:SetText("")
        tooltip:SetFont("arb.Font_FuturaPTBook_6")
        tooltip:SizeToContents()
        tooltip:SetAlpha(0)
        tooltip.Paint = function(this, w, h)
            asterionlib.DrawBlur(this, 6)

            surface.SetDrawColor(0, 0, 0, 100)
            surface.DrawRect(0, 0, w, h)

            local x, y = gui.MouseX() - w / 2, gui.MouseY() - h * 1.5

            if x + w >= ScrW() - 10 then x = ScrW() - w - 10 end
            if x <= 10 then x = 10 end

            if y + h >= ScrH() - 10 then y = ScrH() - h - 10 end
            if y <= 10 then y = 10 end

            this:SetPos(x, y)
        end
        local time = RealTime()
        tooltip.Think = function(this)
            if this:GetAlpha() <= 0 then return end
            if this.len >= this.lenMax then return end

            if RealTime() >= time then
                this.len = this.len + 2
                this:SetText(utf8.sub(this.text, 1, this.len))
                this:SizeToContents()

                time = RealTime() + 0.05
            end
        end

        local panel = self.statusPanel:Add("DPanel")
        panel:Dock(TOP)
        panel:DockMargin(0, 0, 0, 0)
        panel:SetTall(0)
        panel:SetAlpha(0)
        panel.Paint = function(_, w, h)
            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(material)
            surface.DrawTexturedRect(w - size - padding, 0, size, size)

            draw.SimpleText(info.name .. "  ", "arb.Font_FuturaPTBook_7", w - size - padding, size / 2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

            if panel:IsHovered() then
                if !isHover then
                    tooltip:AlphaTo(255, 0.5)
                    tooltip:SetText("")
                    tooltip:SizeToContents()

                    tooltip.len = 0
                end

                isHover = true
            else
                if isHover then
                    tooltip:AlphaTo(0, 0.5, 0, function()
                        tooltip:SetText("")
                        tooltip:SizeToContents()

                        tooltip.len = 0
                    end)
                end

                isHover = false
            end
        end

        timer.Simple(i * 0.3, function()
            if !IsValid(panel) then return end

            panel:SizeTo(-1, size + H(5), 0.3, 0, -1)
            panel:AlphaTo(255, 1)
        end)

        i = i + 1
    end

    local aTitle = self.favoritesPanel:Add("Panel")
    aTitle:Dock(TOP)
    aTitle:SetTall(H(57))
    aTitle.Paint = function(_, w, h)
        surface.SetDrawColor(255, 61, 96, 89.25)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        draw.SimpleText("Избранное", "arb.Font_FuturaPTDemi_12", w / 2, H(7), Color(255, 220, 228, 255), TEXT_ALIGN_CENTER)
    end

    if !LocalPlayer():IsSpectate() then
        local data = asterionlib.data:Get("radialmenu_favorites", {})

        local actions = RadialMenu:GetActionsList()
        for k, v in ipairs(data) do
            local action = actions[v]
            if !action then continue end

            local panel = self.favoritesPanel:Add("DButton")
            panel:SetText("")
            panel:Dock(TOP)
            panel:SetTall(H(45))
            panel.color = Color(255, 234, 238)
            panel.Paint = function(_, w, h)
                local color = Color(_.color.r, _.color.g, _.color.b)
                draw.SimpleText(action.name, "arb.Font_FuturaPTBook_8", W(66), H(10), color, TEXT_ALIGN_LEFT)

                local ishover = _:IsHovered()
                local frame = FrameTime() * 10

                _.color.r = Lerp(frame, _.color.r, ishover and 255 or 255)
                _.color.g = Lerp(frame, _.color.g, ishover and 61 or 234)
                _.color.b = Lerp(frame, _.color.b, ishover and 96 or 238)

                if action.icon then
                    surface.SetDrawColor(color)
                    surface.SetMaterial(action.icon)
                    surface.DrawTexturedRect(W(66) - W(10) - W(30), h / 2 - H(30) / 2, H(30), H(30))
                end
            end
            panel.DoClick = function()
                RunConsoleCommand("arb_radialmenu_action", v)
            end

            self.favoritesPanel:SetTall(self.favoritesPanel:GetTall() + H(45))
        end
    end


    self:FixTall()
end

function PANEL:FixTall()
    local a = self.favoritesPanel:GetTall()

    self.favoritesPanel:DockMargin(0, ScrH() / 2 - a / 2, 0, W(20))
end

vgui.Register("arb.ContextMenu", PANEL, "EditablePanel")