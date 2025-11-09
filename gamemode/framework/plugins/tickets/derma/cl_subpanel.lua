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


local gradientWhiteColor = Color(50, 50, 50)
local timeColor = Color(200, 200, 200)

local cornerRadius = 5
local function paintMenu(panel)
    panel.Paint = function(_, w, h)
        local color = Arbitrage.theme:GetInformation()

        draw.RoundedBox(cornerRadius, 0, 0, w, h, Color(color.r, color.g, color.b, 165.75))
        draw.RoundedBox(cornerRadius, 2, 2, w - 4, h - 4, Color(color.r * 0.15, color.g * 0.15, color.b * 0.15))
    end
end

local function paintOption(panel)
    panel:SetFont("arb.Font_FuturaPTBook_6")
    panel.Paint = function(_, w, h)
        local alpha = 130

        if _:IsHovered() and _:IsEnabled() then
            surface.SetDrawColor(27, 10, 13, 200)
            surface.DrawRect(2, 2, w - 4, h - 4)

            alpha = 255
        end

        if !_:IsEnabled() then
            surface.SetDrawColor(255, 0, 0, 20)
            surface.DrawRect(2, 0, w - 4, h)

            alpha = 255
        end

        panel:SetTextColor(Color(240, 240, 240, alpha))
    end
end

local PANEL = {}

function PANEL:Init()
    self.titleText = ""
    self.titlePixel = nil
    self.ticket = nil
    self.font = "arb.Font_FuturaPTBook_6"

    local titleFont = "arb.Font_FuturaPTBook_7"
    local timeFont = "arb.Font_FuturaPTBook_6"
    local titleHeight = draw.GetFontHeight(titleFont) * 1.3
    self:SetTall(titleHeight)

    local titlePanel = self:Add("Panel")
    titlePanel:Dock(TOP)
    titlePanel:SetTall(titleHeight)
    titlePanel.alpha = 0
    titlePanel.Paint = function(_, w, h)
        Arbitrage.DrawGradient(GRADIENT_LEFT, 0, 0, w, h, gradientWhiteColor)

        if titlePanel.alpha > 0.05 then
            local color = Arbitrage.theme:GetInformation()

            Arbitrage.DrawGradient(GRADIENT_LEFT, 0, 0, w * 2, h, Color(color.r, color.g, color.b, 50 * titlePanel.alpha))
        end

        if self.titlePixel then
            local size = h * 1.35

            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(self.titlePixel)
            surface.DrawTexturedRect(h / 2 - size / 2, h / 2 - size / 2, size, size)
        end

        local _w = draw.SimpleText(F(self.titleText), titleFont, 30, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        if self.ticket then
            draw.SimpleText("(" .. string.FormattedTime(os.time() - self.ticket.time, "%02i:%02i") .. ")", timeFont, 30 + _w + 10, h / 2, timeColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end

    local closeMat = Material("asterion/academy/ui/tickets/close.png")

    local closeButton = titlePanel:Add("DButton")
    closeButton:SetText("")
    closeButton:Dock(RIGHT)
    closeButton:SetWide(titleHeight)
    closeButton.bAlpha = 0
    closeButton.color = Color(255, 255, 255)
    closeButton.DoClick = function(this)
        local menu = DermaMenu()
        menu:SetAlpha(0)
        menu:AlphaTo(255, 0.25)
        paintMenu(menu)

        local textButton = menu:AddOption("Закрыть тикет?")
        textButton:SetEnabled(false)
        paintOption(textButton)

        local yesButton = menu:AddOption("Да", function()
            if !self.ticket then return end

            self.ticket:CloseRequest()
        end)
        yesButton:SetIcon("icon16/accept.png")
        paintOption(yesButton)

        local noButton = menu:AddOption("Нет", function()
        end)
        noButton:SetIcon("icon16/cancel.png")
        paintOption(noButton)

        menu:Open()
    end
    closeButton.Paint = function(this, w, h)
        this.bAlpha = Lerp(FrameTime() * 10, this.bAlpha, this:IsHovered() and 1 or 0)
        this.color = LerpColor(FrameTime() * 10, this.color, this:IsHovered() and Color(255, 65, 65) or Color(255, 255, 255))

        surface.SetDrawColor(this.color.r, this.color.g, this.color.b, 55 + this.bAlpha * 255)
        surface.SetMaterial(closeMat)
        surface.DrawTexturedRect(0, 0, w, h)
    end

    local disclosureMat = Material("asterion/academy/ui/tickets/disclosure.png")

    self.disclosureButton = titlePanel:Add("DButton")
    self.disclosureButton:SetText("")
    self.disclosureButton:Dock(RIGHT)
    self.disclosureButton:SetWide(titleHeight)
    self.disclosureButton.bOpen = false
    self.disclosureButton.rotate = 180
    self.disclosureButton.bAlpha = 0
    self.disclosureButton.DoClick = function(this)
        this.bOpen = !this.bOpen

        if this.bOpen then
            self:SizeTo(self:GetWide(), titleHeight * 7, 0.25, 0)
            self.bgTextEntryPanel:SizeTo(self:GetWide(), titleHeight, 0.25, 0)
        else
            self:SizeTo(self:GetWide(), titleHeight, 0.25, 0)
            self.bgTextEntryPanel:SizeTo(self:GetWide(), 0, 0.25, 0)
        end
    end
    self.disclosureButton.Paint = function(this, w, h)
        this.bAlpha = Lerp(FrameTime() * 10, this.bAlpha, this:IsHovered() and 1 or 0)
        this.rotate = Lerp(FrameTime() * 10, this.rotate, this.bOpen and 0 or 180)
        titlePanel.alpha = Lerp(FrameTime() * 10, titlePanel.alpha, this.bOpen and 1 or 0)

        if titlePanel.alpha > 0.05 then
            local color = Arbitrage.theme:GetInformation()

            surface.SetDrawColor(color.r, color.g, color.b, 40 * titlePanel.alpha)
            surface.DrawRect(0, 0, w, h)
        end

        surface.SetDrawColor(255, 255, 255, 55 + this.bAlpha * 255 + 200 * titlePanel.alpha)
        surface.SetMaterial(disclosureMat)
        surface.DrawTexturedRectRotated(h / 2, h / 2, h, h, this.rotate)
    end

    local settingsMat = Material("asterion/academy/ui/tickets/settings.png")

    local settingButton = titlePanel:Add("DButton")
    settingButton:SetText("")
    settingButton:Dock(RIGHT)
    settingButton:SetWide(titleHeight)
    settingButton.bAlpha = 0
    settingButton.DoClick = function(this)
        if !LocalPlayer():IsAdmin() then return end

        local owner = self.ticket:GetOwner()
        if IsValid(owner) then
            MonoMenu:OpenEntityMenu(owner)
        end
    end
    settingButton.Paint = function(this, w, h)
        local bAccess = LocalPlayer():IsAdmin()
        this.bAlpha = Lerp(FrameTime() * 10, this.bAlpha, this:IsHovered() and (bAccess and 1 or -1) or (bAccess and 0 or -1))

        surface.SetDrawColor(255, 255, 255, 55 + this.bAlpha * 255)
        surface.SetMaterial(settingsMat)
        surface.DrawTexturedRect(0, 0, w, h)
    end

    self.scrollPanel = self:Add("DScrollPanel")
    self.scrollPanel:Dock(FILL)
    self.scrollPanel.ScrollBottom = function(this)
        local bar = this:GetVBar()
        bar:SetScroll(9999999)
    end

    do
        local bar = self.scrollPanel:GetVBar()
        bar:SetWide(3)
        bar:DockMargin(0, 0, 0, 0)

        bar.Paint = function(_, w, h)
            surface.SetDrawColor(255, 255, 255, 3)
            surface.DrawRect(0, 0, w, h)
        end
        bar.btnUp.Paint = function(_, w, h) end
        bar.btnDown.Paint = function(_, w, h) end
        bar.btnGrip.Paint = function(_, w, h)
            surface.SetDrawColor(255, 255, 255)
            surface.DrawRect(0, 0, w, h)
        end
    end

    self.bgTextEntryPanel = self:Add("EditablePanel")
    self.bgTextEntryPanel:Dock(BOTTOM)
    self.bgTextEntryPanel:SetTall(0)
    self.bgTextEntryPanel.Paint = function(_, w, h)
        local color = Arbitrage.theme:GetInformation()

        Arbitrage.DrawGradient(GRADIENT_LEFT, 0, 0, w * 2, h, Color(color.r, color.g, color.b, 10))
    end

    local textEntryPanel = self.bgTextEntryPanel:Add("DTextEntry")
    textEntryPanel:SetText("")
    textEntryPanel:SetPlaceholderText(" Написать сообщение...")
    textEntryPanel:SetTextColor(color_white)
    textEntryPanel:SetCursorColor(color_white)
    textEntryPanel:SetPaintBackground(false)
    textEntryPanel:SetFont(titleFont)
    textEntryPanel:Dock(FILL)
    textEntryPanel.panel = nil
    textEntryPanel.oldPaint = textEntryPanel.Paint
    textEntryPanel.OnGetFocus = function(this)
        if IsValid(this.panel) then
            this.panel:Remove()
        end

        -- Magic DTextEntry
        this.panel = vgui.Create("EditablePanel")
        this.panel:MakePopup()

        this.panel.newTextEntryPanel = this.panel:Add("DTextEntry")
        this.panel.newTextEntryPanel:SetText(textEntryPanel:GetValue())
        this.panel.newTextEntryPanel:SetPlaceholderText(" Написать сообщение...")
        this.panel.newTextEntryPanel:SetTextColor(color_white)
        this.panel.newTextEntryPanel:SetCursorColor(color_white)
        this.panel.newTextEntryPanel:SetPaintBackground(false)
        this.panel.newTextEntryPanel:SetFont(titleFont)
        this.panel.newTextEntryPanel:Dock(FILL)
        this.panel.newTextEntryPanel.OnLoseFocus = function(newthis)
            this:SetText(newthis:GetValue())

            this.panel:Remove()

            textEntryPanel.Paint = textEntryPanel.oldPaint
        end
        this.panel.newTextEntryPanel.Think = function(newthis)
            local mouseX, mouseY = input.GetCursorPos()
            local x, y = this:LocalToScreen(0, 0)
            local w, h = this:GetSize()

            this.panel:SetPos(x, y)
            this.panel:SetSize(w, h)

            if !(mouseX >= x and mouseX <= x + w and mouseY >= y and mouseY <= y + h) and input.IsMouseDown(MOUSE_LEFT) then
                newthis:OnLoseFocus()
            end
        end
        this.panel.newTextEntryPanel.OnEnter = textEntryPanel.OnEnter

        this.panel.newTextEntryPanel:RequestFocus()
        this.panel.newTextEntryPanel:SetCaretPos(utf8.len(textEntryPanel:GetValue()))

        textEntryPanel.Paint = function() end
    end
    textEntryPanel.OnEnter = function(_, value)
        textEntryPanel:SetText("")
        textEntryPanel.panel.newTextEntryPanel:SetText("")

        self.ticket:SendMessage(value)
    end
    textEntryPanel.OnRemove = function(this)
        if IsValid(this.panel) then
            this.panel:Remove()
        end
    end
end

function PANEL:SetTicket(ticket)
    self.ticket = ticket
    self.titleText = ticket.title

    local owner = ticket:GetOwner()
    if IsValid(owner) then
        local character = owner:GetCharacter()

        if character then
            local assets = character:GetAssets()
            local pixel = assets.pixel

            if pixel then
                self.titlePixel = Material(pixel)
            end
        end

        if owner == LocalPlayer() then
            timer.Simple(0.5, function()
                if !IsValid(self) then return end

                self.disclosureButton:DoClick()
            end)
        end

        self.titleText = ("%s[%s]"):format(owner:Name(), owner:SteamName())
    end

    self.titleText = self.titleText

    timer.Simple(1, function()
        if !IsValid(self) then return end

        for _, message in ipairs(ticket.messages or {}) do
            self:AddMessage(message)
        end
    end)
end

function PANEL:AddMessage(data)
    local heigthFont = draw.GetFontHeight(self.font)

    local message = data.message
    message = L(data.title) .. ": " .. message

    local time = "[" .. data.time .. "] "


    -- hm???
    local timeWidth = draw.SimpleText(time, self.font, 0, 0, color_white, TEXT_ALIGN_LEFT)


    local wrapText = asterionlib.WrapText(message, self:GetWide() - timeWidth, self.font, true)

    local panel = self.scrollPanel:Add("DButton")
    panel:SetText("")
    panel:SetAlpha(0)
    panel:AlphaTo(255, 1.5)
    panel:Dock(TOP)
    panel:SetTall(heigthFont * #wrapText)
    panel:DockMargin(0, 0, 0, 5)
    panel.yText = -heigthFont
    panel.Paint = function(this, w, h)
        if this:IsHovered() then
            surface.SetDrawColor(0, 0, 0, 150)
            surface.DrawRect(0, 0, w, h)
        end

        if this.yText < -0.05 then
            this.yText = Lerp(FrameTime() * 5, this.yText, 0)
        end

        draw.SimpleText(time, self.font, 0, this.yText, timeColor, TEXT_ALIGN_LEFT)

        for k, v in ipairs(wrapText or {}) do
            draw.SimpleText(v, self.font, timeWidth, this.yText + (k - 1) * heigthFont, color_white, TEXT_ALIGN_LEFT)
        end
    end
    panel.DoClick = function()
        SetClipboardText(message)
    end

    timer.Simple(0.2, function()
        self.scrollPanel:ScrollBottom()
    end)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(13, 13, 13, 251)
    surface.DrawRect(0, 0, w, h)

    -- boom!!!
    if self.ticket and !self.ticket:IsReciver(LocalPlayer()) then
        self.ticket:Remove()
    end
end

vgui.Register("Ticket:SubPanel", PANEL, "EditablePanel")