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

local fontDescription = "arb.Font_FuturaPTBook_6"
local fontDescriptionHeight = draw.GetFontHeight(fontDescription)

local colorTitle = Color(255, 18, 61)

local PANEL = {}

function PANEL:Init()
    if IsValid(Arbitrage.tooltip) then
        Arbitrage.tooltip:Remove()
    end

    Arbitrage.tooltip = self

    self:SetPos(0, 0)
    self:SetSize(500, fontTitleHeight)
    self:NoClipping(false)
    self:SetAlpha(0)
    self:AlphaTo(255, 0.5)

    self.fraction = 0
    self.arrowX = 0
    self.arrowY = 0
    self.pX = ScrW() / 2
    self.pY = ScrH() / 2
    self.subpanels = {}
    self.entity = nil
    self.noTrace = RealTime() + 1

    self.title = self:Add("DPanel")
    self.title:Dock(TOP)
    self.title:SetTall(fontTitleHeight)
    self.title.Paint = function(_, w, h)
        surface.SetDrawColor(colorTitle)
        surface.DrawRect(0, 0, w, h)
    end

    self.titleIcon = self.title:Add("DImage")
    self.titleIcon:Dock(RIGHT)
    self.titleIcon:DockMargin(0, 0, 0, 0)
    self.titleIcon:SetWide(fontTitleHeight)

    self.titleLabel = self.title:Add("DLabel")
    self.titleLabel:SetTextColor(color_white)
    self.titleLabel:Dock(FILL)
    self.titleLabel:DockMargin(8, 0, 0, 0)
    self.titleLabel:SetFont(fontTitle)

    self.description = self:Add("Panel")
    self.description:Dock(TOP)
    self.description:SetTall(0)

    self.descriptionPanel = self.description:Add("DPanel")
    self.descriptionPanel:Dock(FILL)
    self.descriptionPanel:DockMargin(15, 15 / 2, 15, 15 / 2)
    self.descriptionPanel.Paint = function(_, w, h)
        for k, v in ipairs(self.descriptionTextData or {}) do
            draw.SimpleText(v, fontDescription, 0, (k - 1) * fontDescriptionHeight, color_white, TEXT_ALIGN_LEFT)
        end
    end
end

function PANEL:SetTitle(title)
    title = string.Trim(title)
    title = string.utf8upper(string.utf8sub(title, 1, 1)) .. string.utf8sub(title, 2, string.utf8len(title))

    self.titleLabel:SetText(title)
end

function PANEL:SetIcon(material)
    self.titleIcon:SetImage(material)
end

function PANEL:SetDescription(description)
    description = description:gsub("Количество патрон: %d+", "")
    description = description:gsub("Количество: %d+/%d+", "")
    description = description:gsub("Осталось: %d+/%d+", "")
    description = description:gsub("Количество: %d+", "")
    description = string.Trim(description)

    description = string.utf8upper(string.utf8sub(description, 1, 1)) .. string.utf8sub(description, 2, string.utf8len(description))

    if description != "" and description != " " then
        local symbol = string.Right(description, 1)
        if symbol != "." and symbol != "!" and symbol != "?" and symbol != ";" then
            description = description .. "."
        end
    end

    self.descriptionText = description
end

function PANEL:SetEntity(entity)
    self.entity = entity
end

function PANEL:AddSubMenu(title, callback)
    local panel = self:Add("Panel")
    panel:Dock(TOP)
    panel:SetTall(fontDescriptionHeight + 7)

    panel.title = panel:Add("DLabel")
    panel.title:SetText(title)
    panel.title:SetFont(fontDescription)
    panel.title:SetTextColor(color_white)
    panel.title:SetContentAlignment(9)
    panel.title:Dock(FILL)
    panel.title:DockMargin(0, 0, 10, 0)

    if callback then
        callback(panel)
    end

    self.subpanels[#self.subpanels + 1] = panel
end

function PANEL:Complete()
    surface.SetFont(fontTitle)
    local width = surface.GetTextSize(self.titleLabel:GetText()) + fontTitleHeight + 10 * 2 + 15 * 2

    self.pWidth = 0
    self.width = math.max(fontTitleHeight * 13, width)

    if self.descriptionText and self.descriptionText != "" and self.descriptionText != " " then
        self.descriptionTextData = asterionlib.WrapText(self.descriptionText, self.width - 15 * 2, fontDescription)
        self.description:SetTall(#self.descriptionTextData * fontDescriptionHeight + 10 + 10)
    end

    local height = self.title:GetTall()
    height = height + self.description:GetTall()

    for _, panel in ipairs(self.subpanels) do
        if !IsValid(panel) then continue end

        height = height + panel:GetTall()
    end

    self.pHeight = self:GetTall()
    self.height = height
end

local cubeSize = H(12)
function PANEL:Paint(w, h)
    asterionlib.DrawBlur(self, 2)

    surface.SetDrawColor(0, 0, 0, 160)
    surface.DrawRect(0, 0, w, h)

    local x, y = self:ScreenToLocal(self.arrowX, self.arrowY)

    local old = DisableClipping(true)
        local newX, newY = x * self.fraction, y * self.fraction

        surface.SetDrawColor(colorTitle)
        surface.DrawLine(0, self.title:GetTall() / 2, newX, newY)
        surface.DrawLine(0, self.title:GetTall() / 2 - 1, newX, newY - 1)

        surface.SetDrawColor(colorTitle)
        surface.DrawRect(newX - cubeSize + 2, newY + 2 - 1, cubeSize, cubeSize)

        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawRect(newX - cubeSize, newY - 1, cubeSize, cubeSize)
    DisableClipping(old)
end

function PANEL:DoClose()
    if self.bClose then return end

    self.bClose = true
    self.height = fontTitleHeight
    self:AlphaTo(0, 0.65, 0, function()
        self:Remove()
    end)
end

function PANEL:Think()
    local ft = FrameTime()

    self.fraction = Lerp(ft * 4, self.fraction, self.bClose and 0.1 or 1)
    self.pWidth = Lerp(ft * 4, self.pWidth, self.width)
    if self.pWidth >= self.width - 0.005 then
        self.pHeight = Lerp(ft * 4, self.pHeight, self.height)
    end

    self:SetTall(self.pHeight)
    self:SetWide(self.pWidth)

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

    if !IsValid(entity) then return end

    local min, max = entity:GetRotatedAABB(entity:OBBMins() * 0.5, entity:OBBMaxs() * 0.5)
    min = entity:LocalToWorld(min):ToScreen().x
    max = entity:LocalToWorld(max):ToScreen().x

    local x = math.Clamp(math.max(min, max), ScrW() * 0.5 + 320, ScrW() - self:GetWide())
    local y = ScrH() * 0.5 - self:GetTall() * 0.5

    self.pX = Lerp(ft * 2.5, self.pX, x)
    self.pY = Lerp(ft * 2.5, self.pY, y)

    self:SetPos(self.pX, self.pY)

    local position = select(1, entity:GetBonePosition(entity:LookupBone("ValveBiped.Bip01_Spine") or -1)) or entity:LocalToWorld(entity:OBBCenter())
    position = position:ToScreen()

    self.arrowX = math.Clamp(position.x, 0, ScrW())
    self.arrowY = math.Clamp(position.y, 0, ScrH())
end

vgui.Register("arb.tooltip", PANEL, "DPanel")

local oldEntity = nil
local traceCount = 0
timer.Create("Tooltip:Entity", 0.1, 0, function()
    if Arbitrage.lawEnable then return end

    local entity = LocalTraceEntity()
        if IsValid(entity) and entity == oldEntity then
            traceCount = traceCount + 1
        else
            traceCount = 0
        end
    oldEntity = entity

    if !IsValid(entity) then return end
    if IsValid(Arbitrage.tooltip) then return end

    local client = LocalPlayer()
    if client:IsSpectate() then return end

    if traceCount >= 7 then
        traceCount = 0

        local isPlayer = entity:IsPlayer()
        local tooltip = entity.Tooltip or entity.TooltipMini
        if tooltip or isPlayer then
            local onCanTooltip = entity.OnCanTooltip
            if onCanTooltip then
                local onCan = onCanTooltip(entity)
                if onCan == false then return end
            end

            if isPlayer then
                if entity:IsSpectate() then return end
                if entity:IsNocliping() then return end
            end

            local panel = vgui.Create(entity.Tooltip and "arb.tooltip" or "arb.tooltipmini")
            panel:SetEntity(entity)
                if isPlayer then
                    panel:SetTitle(entity:Name())
                    if !entity:GetNetVar("hideStatus") then
                        local color = Color(61, 210, 101)
                        local stText = "На вид в порядке"
                        local health = entity:Health()

                        if health <= 40 then
                            color = Color(218, 52, 52)
                            stText = "Выглядит неважно"
                        elseif health <= 80 then
                            color = Color(218, 162, 52)
                            stText = "Слегка потрепанный"
                        end

                        panel:AddSubMenu(stText, function(this)
                            this.title:SetTextColor(color)
                        end)
                    end

                    panel:SetDescription(entity:GetNetVar("description"))
                else
                    tooltip(entity, panel)
                end
            panel:Complete()
        end
    end
end)