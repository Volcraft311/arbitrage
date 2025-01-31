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
    AdminNotify.panel = self

    self:SetPos(0, ScrH() * 0.2)
    self:SetSize(ScrW(), ScrH() - ScrH() * 0.2)
    self:SetZPos(-99999)
    self:SetMouseInputEnabled(false)
    self:SetKeyboardInputEnabled(false)

    self.panels = self.panels or {}
end

function PANEL:AddNewNotify(data)
    self.panels = self.panels or {}

    local str = "<font=ixAdminNotifyFont>"
    local colorSet = false
    for k, v in pairs(data) do
        if isstring(v) or isnumber(v) then
            str = str .. v
        elseif istable(v) then
            if colorSet then str = str .. "</colour>" end
            str = str .. "<colour=" .. v.r .. "," .. v.g .. "," .. v.b .. "," .. v.a .. ">"
        end
    end

    if colorSet then str = str .. "</colour>" end
    str = str .. "</font>"

    local onlyString = ""
    for k, v in pairs(data) do
        if isstring(v) or isnumber(v) then
            onlyString = onlyString .. v
        end
    end

    surface.SetFont( "ixAdminNotifyFont" )
    local width, height = surface.GetTextSize(onlyString)

    local panel = self:Add("ixAdminNotifyAdd")
    panel.text = str
    panel.text2 = onlyString
    panel.width = width + 8
    panel.height = height + 8
    panel.id = #self.panels + 1
    panel.time = SysTime() + AdminNotify.guiTime
    panel.parsed = markup.Parse(str or "")

    self.panels[panel.id] = panel

    timer.Simple(AdminNotify.guiTime, function()
        if IsValid(panel) then
            panel.width = 0
            panel.height = 0

            panel:AlphaTo(0, 0.5, 0, function()
                self.panels[panel.id] = nil
                panel:Remove()
            end)
        end
    end)
end

function PANEL:Think()
    local y = 0
    for k, v in pairs(self.panels or {}) do
        if IsValid(v) then
            y = y + v:GetTall() + 8
            v.__y = y
        end
    end
end

vgui.Register("ixAdminNotify", PANEL, "Panel")


PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(0, 0)
    self:SetDrawOnTop(true)
    self:SetZPos(-99999)
    self:SetMouseInputEnabled(false)
    self:SetKeyboardInputEnabled(false)

    self:SetAlpha(0)
    self:AlphaTo(255, 0.1)

    self._w = 0
    self._h = 0
    self._y = 0
    self.bHovered = false
end

function PANEL:OnHovered()
    self:AlphaTo(0, 0.1)
end

function PANEL:OnUnHovered()
    self:AlphaTo(255, 0.1)
end

function PANEL:Paint(w, h)
    local t = (self.time or 0) - SysTime()

    surface.SetDrawColor(0, 0, 0, 175)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(255, 61, 96)
    surface.DrawRect(0, h - 2, t * (w / AdminNotify.guiTime), 2)

    draw.SimpleText(self.text2 or "", "ixAdminNotifyFont", 4, 5, color_black, TEXT_ALIGN_LEFT)
    self.parsed:Draw(4, 4, TEXT_ALIGN_LEFT)

    local x, y = self:LocalToScreen(0, 0)
    local mouseX, mouseY = gui.MousePos()
    if mouseX >= x and mouseX <= x + w and mouseY >= y and mouseY <= y + h then
        if !self.bHovered then
            self:OnHovered()

            self.bHovered = true
        end
    else
        if self.bHovered then
            self:OnUnHovered()

            self.bHovered = false
        end
    end
end

function PANEL:Think()
    local ft = FrameTime()

    self._w = Lerp(ft * 10, self._w, self.width or 0)
    self._h = Lerp(ft * 10, self._h, self.height or 0)
    self._y = Lerp(ft * 10, self._y, self.__y or ScrH())

    self:SetWide(self._w)
    self:SetTall(self._h)
    self:SetY(self._y)
    self:SetX(ScrW() - self._w - 24)
end

vgui.Register("ixAdminNotifyAdd", PANEL, "DPanel")