local PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 1)

    self.paddingTop = 62
    self.paddingRight = 80

    self:CreateMenu()

    local keyFont = "arb.Font_FuturaPTDemi_9"
    local keyFontHeight = draw.GetFontHeight(keyFont)
    self.bottomPanel = self:Add("Panel")
    self.bottomPanel:Dock(BOTTOM)
    self.bottomPanel:DockMargin(self.paddingRight, 0, 0, self.paddingTop)
    self.bottomPanel:SetTall(keyFontHeight)

    local parent = self:GetParent()
    self:AddKey(KEY_ESCAPE, "ESC", "НАЗАД", function(this)
        parent:UnHideUI()

        self:AlphaTo(0, 0.5, 0, function()
            self:Remove()
        end)
    end)
end

function PANEL:CreateMenu()
    local mat = Material("asterion/academy/ui/icons/localization_ct.png", "smooth")

    local titleFont = "arb.Font_FuturaPTDemi_21"
    local titleFontHeight = draw.GetFontHeight(titleFont)

    local title = self:Add("Panel")
    title:SetTall(titleFontHeight * 2.14285714286)
    title:Dock(TOP)
    title:DockMargin(0, 0, 0, 30)
    title.Paint = function(_, w, h)
        local matColor = ColorAlpha(Arbitrage.theme:GetVisLogos(), 50)
        surface.SetDrawColor(matColor.r, matColor.g, matColor.b, 50)
        surface.SetMaterial(mat)
        surface.DrawTexturedRect(0, 0, h * 1.47058823529, h)

        local lineColor = Arbitrage.theme:GetVisForeground()
        surface.SetDrawColor(lineColor.r, lineColor.g, lineColor.b, 255)
        surface.DrawRect(0, h - 1, w, 1)

        draw.SimpleText("ВЫБОР ЯЗЫКА", titleFont, titleFontHeight * 1.26984126984, h / 2, Arbitrage.theme:GetTextCategory(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    self.scrollPanel = self:Add("DScrollPanel")
    self.scrollPanel:Dock(FILL)
    self.scrollPanel:DockMargin(0, 70, 0, 0)

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

    local buttonFont = "arb.Font_FuturaPTBook_11"
    local buttonFontHeight = draw.GetFontHeight(buttonFont) * 1.21212121212

    for lang_id, info in pairs(Arbitrage.language.stored) do
        local name = info.information.name:utf8upper()

        local panel = self.scrollPanel:Add("DButton")
        panel:SetText("")
        panel:SetTall(buttonFontHeight)
        panel:Dock(TOP)
        panel.alpha = 0
        panel.color = Arbitrage.theme:GetTextButton()
        panel.Paint = function(this, w, h)
            this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 1 or 0)
            this.color = LerpColor(FrameTime() * 10, this.color, this:IsHovered() and Arbitrage.theme:GetTextHover() or Arbitrage.theme:GetTextButton())

            if this:GetDisabled() then
                this.color = Arbitrage.theme:GetTextLocked()
            end

            local lineColor = Arbitrage.theme:GetVisSelectionLine()
            surface.SetDrawColor(lineColor.r, lineColor.g, lineColor.b, 255 * this.alpha)
            surface.DrawRect(0, 0, w * this.alpha, h)

            draw.SimpleText(name, buttonFont, 150, h / 2, this.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
        panel.DoClick = function(_, w, h)
            RunConsoleCommand("arb_lang", lang_id)
        end
    end
end

function PANEL:AddKey(key, keyName, keyDescription, callback)
    local keyFont = "arb.Font_FuturaPTDemi_7"
    local keyFontHeight = draw.GetFontHeight(keyFont)
    local size = keyFontHeight * 0.7

    local keyNameSize = size * utf8.len(keyName) + 2
    local keyDescriptionSize = size * utf8.len(keyDescription)

    local button = self.bottomPanel:Add("DButton")
    button:SetText("")
    button:Dock(LEFT)
    button:SetWide(keyNameSize + keyDescriptionSize + 20)
    button.bOnClick = false
    button.outlinecolor = Arbitrage.theme:GetVisButtonSelected()
    button.textcolor = Arbitrage.theme:GetTextSelected()
    button.Paint = function(this, w, h)
        local backgroundColor = Arbitrage.theme:GetVisButtonBackground()
        surface.SetDrawColor(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a)
        surface.DrawRect(0, 0, w, h)

        local selectedColor = this.outlinecolor
        surface.SetDrawColor(selectedColor.r, selectedColor.g, selectedColor.b, selectedColor.a)
        surface.DrawOutlinedRect(0, 0, keyNameSize, h, 2)

        draw.SimpleText(keyName, keyFont, 10, h / 2, this.textcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(keyDescription, keyFont, keyNameSize + 10, h / 2, this.textcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    button.DoClick = function(this)
        if this.bOnClick then return end

        callback(this)

        this.bOnClick = true
    end
    button.Think = function(this)
        if this.bOnClick then return end

        if input.IsKeyDown(key) then
            callback(this)

            this.bOnClick = true
        end
    end
end

function PANEL:Paint(w, h)
    asterionlib.DrawBlur(self, 8)
end

vgui.Register("arb.mainmenu:Lang", PANEL, "Panel")