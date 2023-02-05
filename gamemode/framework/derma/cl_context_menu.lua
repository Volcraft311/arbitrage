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

    local aTitle = self.favoritesPanel:Add("Panel")
    aTitle:Dock(TOP)
    aTitle:SetTall(H(57))
    aTitle.Paint = function(_, w, h)
        surface.SetDrawColor(255, 61, 96, 89.25)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        draw.SimpleText("Избранное", "arb.Font_FuturaPTDemi_12", w / 2, H(7), Color(255, 220, 228, 255), TEXT_ALIGN_CENTER)
    end

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


    self:FixTall()
end

function PANEL:FixTall()
    local a = self.favoritesPanel:GetTall()

    self.favoritesPanel:DockMargin(0, ScrH() / 2 - a / 2, 0, W(20))
end

vgui.Register("arb.ContextMenu", PANEL, "EditablePanel")