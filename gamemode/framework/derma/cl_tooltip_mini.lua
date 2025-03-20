--[[
        © AsterionStaff 2024.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local fontTitle = "arb.Font_FuturaPTDemi_8"
local fontTitleHeight = draw.GetFontHeight(fontTitle)

local fontDescription = "arb.Font_FuturaPTBook_7"
local fontDescriptionHeight = draw.GetFontHeight(fontDescription)

local fontSub = "arb.Font_FuturaPTBook_7"
local fontSubHeight = draw.GetFontHeight(fontSub)

local PANEL = {}

function PANEL:Init()
    if IsValid(Arbitrage.tooltip) then
        Arbitrage.tooltip:Remove()
    end

    Arbitrage.tooltip = self

    self:SetPos(0, 0)
    self:SetSize(ScrW() * 0.2, 0)
    self:SetAlpha(0)

    self.titleLabel = self:Add("DLabel")
    self.titleLabel:SetTextColor(color_white)
    self.titleLabel:SetContentAlignment(8)
    self.titleLabel:Dock(TOP)
    self.titleLabel:DockMargin(0, 0, 0, 0)
    self.titleLabel:SetFont(fontTitle)
    self.titleLabel:SetTall(fontTitleHeight + 2)
    self.titleLabel.Paint = function(_, w, h)
        local value = self:GetAlpha() / 255

        surface.SetDrawColor(self.titleLabel:GetTextColor())
        surface.DrawRect(w / 2 - (self.titleLineWidth * value) * 0.5, h - 2, self.titleLineWidth * value, 2)
    end

    self.titleLineWidth = 0
    self.entity = nil
    self.subpanels = {}
    self.noTrace = RealTime() + 1
    self.updateTime = RealTime() + 2
    self.player = nil
end

function PANEL:SetTitle(title)
    title = F(title)
    title = string.Trim(title)
    title = string.utf8upper(string.utf8sub(title, 1, 1)) .. string.utf8sub(title, 2, string.utf8len(title))

    self.titleLabel:SetText(L(title))
    self.titleLabel:SetExpensiveShadow(1, Color(0, 0, 0, 255))

    surface.SetFont(fontTitle)
    local width = surface.GetTextSize(title)
    self.titleLineWidth = width

    local entity = self.entity:IsPlayer() and self.entity or self.player
    if IsValid(entity) then
        local color = team.GetColor(entity:Team())
        if color then
            self.titleLabel:SetTextColor(color)
        end
    end
end

function PANEL:SetDescription(description)
    description = description and F(description) or ""

    description = string.Trim(description)
    description = string.utf8upper(string.utf8sub(description, 1, 1)) .. string.utf8sub(description, 2, string.utf8len(description))

    if description != "" and description != " " then
        local symbol = string.Right(description, 1)
        if symbol != "." and symbol != "!" and symbol != "?" and symbol != ";" then
            description = description .. "."
        end
    end

    self.descriptionText = description

    -- создает тут ибо description не всегда нужен, либо SubPanel может быть выше description-а
    if description != "" and description != " " and !IsValid(self.descriptionPanel) then
        self.descriptionPanel = self:Add("DPanel")
        self.descriptionPanel:Dock(TOP)
        self.descriptionPanel:SetTall(0)
        self.descriptionPanel.Paint = function(_, w, h)
            for k, v in ipairs(self.descriptionTextData or {}) do
                draw.SimpleText(v, fontDescription, w / 2 + 1, 1 + (k - 1) * fontDescriptionHeight, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
                draw.SimpleText(v, fontDescription, w / 2, (k - 1) * fontDescriptionHeight, color_white, TEXT_ALIGN_CENTER)
            end
        end
    end
end

function PANEL:SetEntity(entity)
    self.entity = entity

    local distance = IsValid(entity) and LocalPlayer():GetPos():DistToSqr(entity:GetPos()) or 999999 -- hm?
    self:AlphaTo(255 - distance * 0.005 + 5, 0.5, 0, function()
        self.bOpen = true
    end)
end

function PANEL:AddSubMenu(title, callback)
    local panel = self:Add("Panel")
    panel:Dock(TOP)
    panel:SetTall(fontSubHeight)

    panel.title = panel:Add("DLabel")
    panel.title:SetText(F(title))
    panel.title:SetExpensiveShadow(1, Color(0, 0, 0, 255))
    panel.title:SetFont(fontSub)
    panel.title:SetTextColor(color_white)
    panel.title:SetContentAlignment(8)
    panel.title:Dock(FILL)
    panel.title:DockMargin(0, 0, 0, 0)

    if callback then
        callback(panel)
    end

    self.subpanels[#self.subpanels + 1] = panel
end

function PANEL:Complete()
    if self.descriptionText and self.descriptionText != "" and self.descriptionText != " " then
        self.descriptionTextData = asterionlib.WrapText(self.descriptionText, self:GetWide(), fontDescription)
        self.descriptionPanel:SetTall(#self.descriptionTextData * fontDescriptionHeight)
    end

    local height = self.titleLabel:GetTall()

    if IsValid(self.descriptionPanel) then
        height = height + self.descriptionPanel:GetTall()
    end

    for _, panel in ipairs(self.subpanels) do
        if !IsValid(panel) then continue end

        height = height + panel:GetTall()
    end

    self.pHeight = self:GetTall()
    self.height = height

    self:SetTall(self.height)
end

function PANEL:DoClose()
    if self.bClose then return end

    self.bClose = true
    self.height = 0
    self:AlphaTo(0, 0.4, 0, function()
        self:Remove()
    end)
end

function PANEL:Paint(w, h)
    asterionlib.DrawBlur(self, 1, nil, 150)

    local entity = self.entity
    if !IsValid(entity) then return end

    local padding = Vector(0, 0, 64 * 0.2)
    padding = (entity:IsPlayer() and entity:Crouching()) and Vector(0, 0, 0) or padding

    local point = entity:GetPos() + entity:OBBCenter() + padding
    local data2D = point:ToScreen()

    local x = data2D.x - self:GetWide() / 2
    local y = data2D.y - self:GetTall() / 2

    self:SetPos(x, y)

    self.updateTime = RealTime() + 1
end

function PANEL:Think()
    local ft = FrameTime()

    self.pHeight = Lerp(ft * 4, self.pHeight, self.height)
    self:SetTall(self.pHeight)

    local entity = self.entity
    local distance = IsValid(entity) and LocalPlayer():GetPos():DistToSqr(entity:GetPos()) or 999999 -- hm?
    local trace = LocalPlayer():GetEyeTrace().Entity
    if (distance >= 40000 or trace != entity) and !self.bClose then
        if RealTime() >= self.noTrace then
            self:DoClose()
        end
    else
        self.noTrace = RealTime() + 0.7
    end

    if RealTime() >= self.updateTime then
        self:DoClose()
    end

    if !IsValid(entity) then return end

    if self.bOpen and !self.bClose then
        self:SetAlpha(255 - distance * 0.005 + 5)
    end
end

vgui.Register("arb.tooltipmini", PANEL, "DPanel")