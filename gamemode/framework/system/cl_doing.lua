--[[
        © AsterionStaff 2025.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local circles = asterionlib.Circles

local function FindSelected(x, y, segment_size)
    local mouse_pos = Vector(input.GetCursorPos())
    mouse_pos:Sub(Vector(x, y, 0))

    local mouse_ang = math.atan2(mouse_pos[2], mouse_pos[1]) * 180 / math.pi

    if mouse_ang < 0 then
        mouse_ang = 360 + mouse_ang
    end

    return math.floor(mouse_ang / segment_size)
end

local function LerpAngle(a, b, t)
    local delta = (b - a) % 360

    if delta > 180 then
        delta = delta - 360
    end

    return a + delta * t
end

Arbitrage.doing = Arbitrage.library.Add("doing")

local PANEL = {}

function PANEL:Init()
    if IsValid(Arbitrage.gui.doing) then
        Arbitrage.gui.doing:Remove()
    end

    Arbitrage.gui.doing = self

    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetMouseInputEnabled(true)
    self:SetKeyboardInputEnabled(false)
    self:SetAlpha(0)
    self:AlphaTo(255, 0.5)

    self.data = {}
    self.options = {}
    self.rotation = 0
    self.selected = 0
end

function PANEL:SetData(data)
    self.data = data

    self.options = {}
    for id, action in pairs(data.actions) do
        self.options[#self.options + 1] = {
            id = id,
            name = action.name
        }
    end

    self._r = ScrH() * 0.13888888888
    self._x = ScrW() / 2
    self._y = ScrH() - self._r * 1.5

    local radialSize = self._r * (0.5 + 0.25 * 0.75)

    self.background = circles.New(CIRCLE_OUTLINED, self._r, self._x, self._y, radialSize)
    self.background:SetMaterial(true)
    self.background:SetColor(Color(0, 0, 0, 255 * 0.5))

    local color_outline = Arbitrage.theme:GetInformation()
    self.outline1 = circles.New(CIRCLE_OUTLINED, self._r, self._x, self._y, 3)
    self.outline1:SetMaterial(true)
    self.outline1:SetColor(Color(color_outline.r * 0.75, color_outline.g * 0.75, color_outline.b * 0.75, 255))

    self.outline2 = circles.New(CIRCLE_OUTLINED, ScrH() * 0.04629629629, self._x, self._y, 3)
    self.outline2:SetMaterial(true)
    self.outline2:SetColor(Color(47, 47, 47, 255 * 0.75))

    self.wedge = circles.New(CIRCLE_OUTLINED, self._r, self._x, self._y, radialSize)
    self.wedge:SetMaterial(true)
    self.wedge:SetColor(Color(color_outline.r * 0.75, color_outline.g * 0.75, color_outline.b * 0.75, 100))
    self.wedge:SetEndAngle(360 / #self.options)

    self.wedge_outline = circles.New(CIRCLE_OUTLINED, ScrH() * 0.04629629629, self._x, self._y, 5)
    self.wedge_outline:SetMaterial(true)
    self.wedge_outline:SetColor(Color(color_outline.r * 0.95, color_outline.g * 0.95, color_outline.b * 0.95, 255))
    self.wedge_outline:SetEndAngle(360 / #self.options)

    self:CreatePanel(data.title, data.description)
end

function PANEL:CreatePanel(title, description)
    title = F(title)
    description = F(description)

    local width, heigth = 100, 100
    local x, y = ScrW() * 0.5 - width * 0.5, ScrH() * 0.375 - heigth * 0.5

    local titleFont = "arb.Font_FuturaPTBook_10"
    local descriptionFont = "arb.Font_FuturaPTBook_7"

    surface.SetFont(titleFont)
    width, heigth = surface.GetTextSize(title)
    width = math.max(heigth * 10, width)

    local color = Arbitrage.theme:GetInformation()
    local wraptext = asterionlib.WrapText(description, width, descriptionFont)

    self.panel = self:Add("DPanel")
    self.panel:SetPos(x, y)
    self.panel:SetSize(width, heigth * 4)
    self.panel.Paint = function(_, w, h)
        draw.SimpleText(title, titleFont, 0, 0, color_white, TEXT_ALIGN_LEFT)

        Arbitrage.DrawGradient(GRADIENT_LEFT, 0, heigth - 1, w, 2, color)

        local _y = heigth

        for _, v in ipairs(wraptext) do
            local _, __y = draw.SimpleText(v, descriptionFont, 0, _y, color_white, TEXT_ALIGN_LEFT)

            _y = _y + __y
        end
    end
end

function PANEL:SelectOption(id)
    local option = self.options[id]
    if !option then return end

    netstream.Start("Doing:Action", option.id)
end

function PANEL:OnLeftClick()
    if self.bClose then return end
    if !self.selected then return end

    self:SelectOption(self.selected + 1)
    self:NewClose()
end

function PANEL:HandleMouseInput()
    local onLeftClick = input.IsMouseDown(MOUSE_LEFT)
    if onLeftClick then
        if !self.bLeftClick then
            self:OnLeftClick()
        end

        self.bLeftClick = true
    else
        self.bLeftClick = nil
    end
end

function PANEL:Think()
    self:HandleMouseInput()

    local entity = self.data.entity
    if IsValid(entity) then
        local position = select(1, entity:GetBonePosition(entity:LookupBone("ValveBiped.Bip01_Head1") or -1)) or entity:LocalToWorld(entity:OBBCenter())
        position = position:ToScreen()

        local x = position.x + 75
        local y = position.y - 50

        if IsValid(self.panel) then
            x = math.Clamp(x, 50, ScrW() - self.panel:GetWide() - 50)
            y = math.Clamp(y, 50, ScrH() - self.panel:GetTall() - 50)

            self.panel:SetPos(x, y)
        end
    end
end

function PANEL:Paint(w, h)
    local ft = FrameTime()
    local color = Arbitrage.theme:GetInformation()

    if IsValid(self.data.entity) then
        outline.Add({self.data.entity}, color, 0)
    end

    local segment_size = 360 / #self.options
    self.selected = FindSelected(self._x, self._y, segment_size)

    self.background()

    self.outline1()
    self.outline2()

    self.rotation = LerpAngle(self.rotation, self.selected * segment_size, ft * 20)

    self.wedge:SetRotation(self.rotation)
    self.wedge()

    self.wedge_outline:SetRotation(self.rotation)
    self.wedge_outline()

    for i = 0, #self.options - 1 do
        local option = self.options[i + 1]
        local a = math.rad(segment_size * i + segment_size / 2)

        local x = self._x + math.cos(a) * self._r * 0.625
        local y = self._y + math.sin(a) * self._r * 0.625

        draw.SimpleText(option.name, "arb.Font_FuturaPTBook_9", x, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    if self.data.icon then
        local material = Material(self.data.icon)
        local size = ScrH() * 0.04629629629

        surface.SetDrawColor(color.r, color.g, color.b)
        surface.SetMaterial(material)
        surface.DrawTexturedRect(self._x - size / 2, self._y - size / 2, size, size)
    end
end

function PANEL:NewClose()
    if self.bClose then return end
    self.bClose = true

    self:SetMouseInputEnabled(false)
    self:AlphaTo(0, 0.3, 0, function()
        self:Remove()
    end)
end

vgui.Register("Doing:Menu", PANEL, "EditablePanel")


netstream.Hook("Doing:Send", function(data)
    local panel = vgui.Create("Doing:Menu")
    panel:SetData(data)
end)