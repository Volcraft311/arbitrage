local PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.5)

    self.paddingTop = 62
    self.paddingRight = 80

    local keyFont = "arb.Font_FuturaPTDemi_9"
    local keyFontHeight = draw.GetFontHeight(keyFont)
    self.bottomPanel = self:Add("Panel")
    self.bottomPanel:Dock(BOTTOM)
    self.bottomPanel:DockMargin(self.paddingRight, 0, 0, self.paddingTop)
    self.bottomPanel:SetTall(keyFontHeight)

    self:CreateMenu()

    local parent = self:GetParent()
    self:AddKey(KEY_ESCAPE, "ESC", "НАЗАД", function(this)
        if self.bSelectCategory then
            if self.characterPanel.uniqueID != nil or self.characterPanel:GetAlpha() >= 10 then
                self.characterPanel:DoClose()

                timer.Simple(0, function()
                    self.characterPanel:DoClose()
                    this.bOnClick = false
                end)

                return
            end

            self.mainPanel:AlphaTo(0, 0.25, 0, function()
                this.bOnClick = false

                self:CreateCategories()
            end)

            if IsValid(self.characterPanel) then
                self.characterPanel:AlphaTo(0, 0.25, 0, function()
                    self.characterPanel:Remove()
                end)
            end
        else
            parent:UnHideUI()
            self:AlphaTo(0, 0.5, 0, function()
                self:Remove()
            end)
        end
    end)
end

function PANEL:CreateCharacters(characters)
    self.bSelectCategory = true

    self.pages:AlphaTo(0, 0.25)

    if IsValid(self.mainPanel) then
        self.mainPanel:Remove()
    end

    self.mainPanel = self:Add("Panel")
    self.mainPanel:Dock(FILL)
    self.mainPanel:SetAlpha(0)
    self.mainPanel:AlphaTo(255, 0.25)

    local titleFont = "arb.Font_FuturaPTDemi_7"
    local titleFontHeight = draw.GetFontHeight(titleFont)

    local charactersPanel = self.mainPanel:Add("Panel")
    charactersPanel:SetPos(100, 52)
    charactersPanel:SetSize(0, ScrH() - self.title:GetTall() - 30 - self.bottomPanel:GetTall() - self.paddingTop - 130 - 52)
    charactersPanel.offset = 100
    charactersPanel.setOffset = 100
    -- charactersPanel.Paint = function(this, w, h)
    --     surface.SetDrawColor(0, 0, 255)
    --     surface.DrawOutlinedRect(0, 0, w, h)
    -- end
    charactersPanel.Think = function(this)
        this.offset = Lerp(FrameTime() * 10, this.offset, this.setOffset)

        this:SetX(this.offset)
    end

    for _, character in ipairs(characters) do
        local assets = character:GetAssets()

        local greeting = Material(assets.greeting, "smooth")
        local greeting_splash = Material(assets.greeting_splash, "smooth")

        local panel = charactersPanel:Add("DButton")
        panel:SetText("")
        panel:Dock(LEFT)
        panel:DockMargin(0, 0, 10, 0)
        panel:SetWide(charactersPanel:GetTall() * 0.31055900621)
        panel.alpha = 0.1
        panel.Paint = function(this, w, h)
            this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 1 or 0.1)

            surface.SetDrawColor(255, 255, 255, this.alpha * 255)
            surface.SetMaterial(greeting)
            surface.DrawTexturedRect(0, 0, w, h)
        end
        panel.DoClick = function()
            local uniqueID = character:GetUniqueID()
            if self.characterPanel.uniqueID == uniqueID then return end

            self.characterPanel.offset = ScrW()
            self.characterPanel.setOffset = ScrW() - self.characterPanel:GetWide()

            self.characterPanel.name = L(character:GetName())

            self.characterPanel.description = L(character:GetDescription())
            self.descriptionPanel:SetText(self.characterPanel.description)

            self.characterPanel.title = L(character:GetTitle())
            self.characterPanel.uniqueID = uniqueID
            self.characterPanel.material = greeting_splash

            self.characterPanel:SetAlpha(0)
            self.characterPanel:AlphaTo(255, 0.5)
        end

        charactersPanel:SetWide(charactersPanel:GetWide() + panel:GetWide() + 10)
    end

    -- local leftButton = self.mainPanel:Add("DButton")

    local leftMat = Material("asterion/academy/ui/icons/arrow2_left.png", "smooth")
    local leftButton = self.mainPanel:Add("DButton")
    leftButton:SetText("")
    leftButton:SetSize(80, charactersPanel:GetTall())
    leftButton:SetPos(charactersPanel:GetX(), charactersPanel:GetY())
    leftButton.alpha = 0.1
    leftButton.Paint = function(this, w, h)
        this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 1 or 0.1)

        local size = h * 0.07

        local color = Arbitrage.theme:GetTextTitle()
        surface.SetDrawColor(color.r, color.g, color.b, this.alpha * 255)
        surface.SetMaterial(leftMat)
        surface.DrawTexturedRect(w / 2 - size / 2, h / 2 - size / 2, size, size)
    end
    leftButton.DoClick = function(this)
        if charactersPanel.setOffset >= 80 then return end

        charactersPanel.setOffset = charactersPanel.setOffset + titleFontHeight * 80
    end

    local rightMat = Material("asterion/academy/ui/icons/arrow2_right.png", "smooth")
    local rightButton = self.mainPanel:Add("DButton")
    rightButton:SetText("")
    rightButton:SetSize(80, charactersPanel:GetTall())
    rightButton:SetPos(ScrW() - charactersPanel:GetX() - rightButton:GetWide(), charactersPanel:GetY())
    rightButton.alpha = 0.1
    rightButton.Paint = function(this, w, h)
        this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 1 or 0.1)

        local size = h * 0.07

        local color = Arbitrage.theme:GetTextTitle()
        surface.SetDrawColor(color.r, color.g, color.b, this.alpha * 255)
        surface.SetMaterial(rightMat)
        surface.DrawTexturedRect(w / 2 - size / 2, h / 2 - size / 2, size, size)
    end
    rightButton.DoClick = function(this)
        local offset = charactersPanel:GetWide() + charactersPanel:GetX()
        local bAllowOffset = offset > ScrW()
        if !bAllowOffset then return end

        charactersPanel.setOffset = charactersPanel.setOffset - titleFontHeight * 80
    end

    self.characterPanel = self:Add("Panel")
    self.characterPanel:SetAlpha(0)
    self.characterPanel:SetPos(ScrW(), 0)
    self.characterPanel:SetSize(ScrW() * 0.45, ScrH())
    self.characterPanel.name = ""
    self.characterPanel.description = ""
    self.characterPanel.title = ""
    self.characterPanel.uniqueID = nil
    self.characterPanel.offset = ScrW()
    self.characterPanel.setOffset = ScrW()
    self.characterPanel.material = nil
    self.characterPanel.DoClose = function(this)
        this:AlphaTo(0, 0.5)
        this.setOffset = ScrW()
        this.uniqueID = nil
    end
    self.characterPanel.Think = function(this)
        this.offset = Lerp(FrameTime() * 10, this.offset, this.setOffset)

        this:SetX(this.offset)
    end
    self.characterPanel.Paint = function(this, w, h)
        asterionlib.DrawBlur(this, 10)

        if this.material then
            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(this.material)
            surface.DrawTexturedRect(w - h, 0, h, h)
        end

        surface.SetDrawColor(0, 0, 0, 150)
        surface.DrawRect(0, 0, w, h)
    end

    local _nameFont = "arb.Font_FuturaPTHeavy_23"
    local _nameFontHeight = draw.GetFontHeight(_nameFont)

    local namePanel = self.characterPanel:Add("DPanel")
    namePanel:Dock(TOP)
    namePanel:DockMargin(120, 200, 0, 0)
    namePanel:SetTall(_nameFontHeight)
    namePanel.Paint = function(_, w, h)
        local color = Arbitrage.theme:GetInformation()

        draw.SimpleText(self.characterPanel.name, _nameFont, 0, 0, color, TEXT_ALIGN_LEFT)
    end

    local _titleFont = "arb.Font_FuturaPTMedium_13"
    local _titleFontHeight = draw.GetFontHeight(_titleFont)

    local titlePanel = self.characterPanel:Add("DPanel")
    titlePanel:Dock(TOP)
    titlePanel:DockMargin(120, 0, 0, 0)
    titlePanel:SetTall(_titleFontHeight)
    titlePanel.Paint = function(_, w, h)
        local color = color_white

        draw.SimpleText(self.characterPanel.title, _titleFont, 0, 0, color, TEXT_ALIGN_LEFT)
    end

    local _buttonFont = "arb.Font_FuturaPTMedium_11"
    local _buttonFontHeight = draw.GetFontHeight(_buttonFont)

    local buttonsPanel = self.characterPanel:Add("Panel")
    buttonsPanel:Dock(BOTTOM)
    buttonsPanel:DockMargin(120, 0, 0, 160)
    buttonsPanel:SetTall(_buttonFontHeight * 1.3)

    local closeButton = buttonsPanel:Add("DButton")
    closeButton:SetText("")
    closeButton:SetWide(self.characterPanel:GetWide() * 0.25)
    closeButton:Dock(LEFT)
    closeButton.alpha = 0.3
    closeButton.Paint = function(this, w, h)
        this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 1 or 0.3)

        surface.SetDrawColor(0, 0, 0, this.alpha * 255)
        surface.DrawRect(0, 0, w, h)

        local color = color_white

        draw.SimpleText("НАЗАД", _buttonFont, w / 2, h / 2, Color(color.r, color.g, color.b, this.alpha * 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        local color_information = Arbitrage.theme:GetInformation()

        surface.SetDrawColor(color_information.r, color_information.g, color_information.b, this.alpha * 255)
        surface.DrawOutlinedRect(0, 0, w, h, 2)
    end
    closeButton.DoClick = function()
        self.characterPanel:DoClose()
    end

    local selectButton = buttonsPanel:Add("DButton")
    selectButton:SetText("")
    selectButton:SetWide(self.characterPanel:GetWide() * 0.25)
    selectButton:Dock(LEFT)
    selectButton:DockMargin(15, 0, 0, 0)
    selectButton.alpha = 0.3
    selectButton.Paint = function(this, w, h)
        this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 1 or 0.3)

        surface.SetDrawColor(0, 0, 0, this.alpha * 255)
        surface.DrawRect(0, 0, w, h)

        local color = color_white

        draw.SimpleText("ПОДТВЕРДИТЬ", _buttonFont, w / 2, h / 2, Color(color.r, color.g, color.b, this.alpha * 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        local color_information = Arbitrage.theme:GetInformation()

        surface.SetDrawColor(color_information.r, color_information.g, color_information.b, this.alpha * 255)
        surface.DrawOutlinedRect(0, 0, w, h, 2)
    end
    selectButton.DoClick = function()
        local faction = Character.team:GetByUniqueID(self.characterPanel.uniqueID)
        if !faction then return end

        if faction.admin and !LocalPlayer():IsAdmin() then return end

        netstream.Start("arb.SelectCharacter", faction.id)

        Arbitrage.menu:AlphaTo(0, 0.25, 0, function()
            Arbitrage.menu:Remove()
        end)
    end

    local _descriptionFont = "arb.Font_FuturaPTBook_10"

    self.descriptionPanel = self.characterPanel:Add("DTextEntry")
    self.descriptionPanel:SetTextColor(color_white)
    self.descriptionPanel:Dock(FILL)
    self.descriptionPanel:DockMargin(120, 30, self.characterPanel:GetWide() * 0.25, 60)
    self.descriptionPanel:SetMultiline(true)
    self.descriptionPanel:SetFont(_descriptionFont)
    self.descriptionPanel:SetText("")
    self.descriptionPanel:SetEditable(false)
    self.descriptionPanel:SetPaintBackground(false)
end

function PANEL:CreateCategories()
    self.bSelectCategory = nil

    self.pages:AlphaTo(255, 0.25)

    if IsValid(self.mainPanel) then
        self.mainPanel:Remove()
    end

    self.mainPanel = self:Add("Panel")
    self.mainPanel:Dock(FILL)
    self.mainPanel:SetAlpha(0)
    self.mainPanel:AlphaTo(255, 0.25)

    local categoryPanel = self.mainPanel:Add("Panel")
    categoryPanel:SetAlpha(0)
    categoryPanel.alpha = 0
    categoryPanel:Dock(FILL)
    categoryPanel.select = nil
    categoryPanel.bg_mat = nil
    categoryPanel.char_mat = nil
    categoryPanel.char_offset = -ScrW() * 0.5
    categoryPanel.cat_mat = nil
    categoryPanel.Paint = function(this, w, h)
        this.alpha = Lerp(FrameTime() * 2.5, this.alpha, 255)
        this:SetAlpha(this.alpha)

        if this.bg_mat then
            local old = DisableClipping(true)
                local size_w = ScrW()
                local size_h = size_w * 0.5625

                surface.SetDrawColor(255, 255, 255)
                surface.SetMaterial(this.bg_mat)
                surface.DrawTexturedRect(w / 2 - size_w / 2, h / 2 - size_h / 2 - self.title:GetTall() * 0.3, size_w, size_h)
            DisableClipping(old)
        end

        if this.char_mat then
            this.char_offset = Lerp(FrameTime() * 10, this.char_offset, 0)

            local old = DisableClipping(true)
                local size_w = ScrW()
                local size_h = size_w * 0.5625

                surface.SetDrawColor(255, 255, 255)
                surface.SetMaterial(this.char_mat)
                surface.DrawTexturedRect(w / 2 - size_w / 2 + this.char_offset, h / 2 - size_h / 2 - self.title:GetTall() * 0.3, size_w, size_h)
            DisableClipping(old)
        end

        if this.cat_mat then
            local size_h = S(90)
            local size_w = size_h * 3,125

            surface.SetDrawColor(Arbitrage.theme:GetTextTitle())
            surface.SetMaterial(this.cat_mat)
            surface.DrawTexturedRect(w - size_w - 70, 0, size_w, size_h)
        end

        -- surface.SetDrawColor(0, 255, 0)
        -- surface.DrawOutlinedRect(0, 0, w, h)
    end

    local titleFont = "arb.Font_FuturaPTDemi_7"
    local titleFontHeight = draw.GetFontHeight(titleFont)

    local s_460 = titleFontHeight * 21.9047619048
    local s_380 = titleFontHeight * 18.0952380952
    local s_230 = titleFontHeight * 10.9523809524

    local bottomPanel = self.mainPanel:Add("Panel")
    bottomPanel:SetSize(s_460 - s_380, s_230)
    bottomPanel:SetPos(80, ScrH() - bottomPanel:GetTall() - self.bottomPanel:GetTall() - self.paddingTop - 80 - self.title:GetTall() - 30)
    bottomPanel.offset = 80
    bottomPanel.setOffset = 80
    bottomPanel.Think = function(this)
        this.offset = Lerp(FrameTime() * 10, this.offset, this.setOffset)

        this:SetX(this.offset)
    end
    -- bottomPanel.Paint = function(this, w, h)
    --     surface.SetDrawColor(0, 0, 255)
    --     surface.DrawOutlinedRect(0, 0, w, h)
    -- end

    local leftMat = Material("asterion/academy/ui/icons/arrow3_left.png", "smooth")
    local leftButton = self.mainPanel:Add("DButton")
    leftButton:SetText("")
    leftButton:SetSize(80, s_230)
    leftButton:SetPos(0, ScrH() - leftButton:GetTall() - self.bottomPanel:GetTall() - self.paddingTop - 80 - self.title:GetTall() - 30)
    leftButton.alpha = 0.1
    leftButton.Paint = function(this, w, h)
        this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 1 or 0.1)

        local size = h * 0.07

        local color = Arbitrage.theme:GetTextTitle()
        surface.SetDrawColor(color.r, color.g, color.b, this.alpha * 255)
        surface.SetMaterial(leftMat)
        surface.DrawTexturedRect(w / 2 - size / 2, h / 2 - size / 2, size, size)
    end
    leftButton.DoClick = function(this)
        if bottomPanel.setOffset >= 80 then return end

        bottomPanel.setOffset = bottomPanel.setOffset + titleFontHeight * 80
    end

    local rightMat = Material("asterion/academy/ui/icons/arrow3_right.png", "smooth")
    local rightButton = self.mainPanel:Add("DButton")
    rightButton:SetText("")
    rightButton:SetSize(80, s_230)
    rightButton:SetPos(ScrW() - rightButton:GetWide(), ScrH() - rightButton:GetTall() - self.bottomPanel:GetTall() - self.paddingTop - 80 - self.title:GetTall() - 30)
    rightButton.alpha = 0.1
    rightButton.Paint = function(this, w, h)
        this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 1 or 0.1)

        local size = h * 0.07

        local color = Arbitrage.theme:GetTextTitle()
        surface.SetDrawColor(color.r, color.g, color.b, this.alpha * 255)
        surface.SetMaterial(rightMat)
        surface.DrawTexturedRect(w / 2 - size / 2, h / 2 - size / 2, size, size)
    end
    rightButton.DoClick = function(this)
        local offset = bottomPanel:GetWide() + bottomPanel:GetX()
        local bAllowOffset = offset > ScrW()
        if !bAllowOffset then return end

        bottomPanel.setOffset = bottomPanel.setOffset - titleFontHeight * 80
    end

    local categories = {}
    -- for i = 1, 2 do
    for _, category in pairs(Character.category.instances) do
        if category.title and category.background and category.backdrop then
            categories[#categories + 1] = category
        end
    end
    -- end

    for idx, category in ipairs(categories) do
        local name = F(category.name)
        local mat = Material(category.background, "smooth")

        local panel = bottomPanel:Add("DButton")
        panel:SetText("")
        panel:Dock(LEFT)
        panel:DockMargin(0, 0, 30, 0)
        panel.size = s_380
        panel:SetWide(panel.size)
        panel.alpha = 0.25
        panel.color = Arbitrage.theme:GetTextPrimary()
        panel.Paint = function(this, w, h)
            local bSelected = categoryPanel.select == idx

            this.alpha = Lerp(FrameTime() * 10, this.alpha, bSelected and 1 or 0.25)
            this.color = LerpColor(FrameTime() * 10, this.color, bSelected and Arbitrage.theme:GetTextTitle() or Arbitrage.theme:GetTextPrimary())

            local size_w = this:GetWide()
            local size_h = size_w * 0.52631578947
            local cg = size_w - s_380

            local _h = s_380 * 0.52631578947

            surface.SetDrawColor(70, 70, 70)
            surface.SetMaterial(mat)
            surface.DrawTexturedRect(w / 2 - size_w / 2, cg * 0.52631578947, size_w, size_h)

            local old = DisableClipping(true)
                local a = this.alpha * 255

                surface.SetDrawColor(a, a, a)
                surface.SetMaterial(mat)
                surface.DrawTexturedRect(w / 2 - size_w / 2, -cg * 0.52631578947, size_w, size_h)
            DisableClipping(old)

            surface.SetDrawColor(0, 0, 0, 200)
            surface.DrawRect(0, _h, w, h)

            draw.SimpleText(name, titleFont, w / 2, h - titleFontHeight * 0.28571428571, this.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

            -- surface.SetDrawColor(255, 0, 0)
            -- surface.DrawOutlinedRect(0, 0, w, h)
        end
        panel.DoSelect = function()
            categoryPanel.select = idx
            categoryPanel.char_offset = -ScrW() * 0.5
            categoryPanel.alpha = 0

            if category.backdrop then
                categoryPanel.bg_mat = Material(category.backdrop, "smooth")
            end

            if category.characters then
                categoryPanel.char_mat = Material(category.characters, "smooth")
            end

            if category.title then
                categoryPanel.cat_mat = Material(category.title, "smooth")
            end
        end
        panel.Think = function(this)
            local bSelected = categoryPanel.select == idx
            this.size = Lerp(FrameTime() * 10, this.size, bSelected and s_460 or s_380)

            panel:SetWide(this.size)

            if this:IsHovered() and categoryPanel.select != idx then
                this:DoSelect()
            end
        end
        panel.DoClick = function()
            local characters = {}
            for _, character in pairs(Character.team.instances) do
                if F(character.category) == F(category.name) then
                    characters[#characters + 1] = character
                end
            end

            self:CreateCharacters(characters)
        end

        if idx == 1 then
            panel:DoSelect()
        end

        bottomPanel:SetWide(bottomPanel:GetWide() + panel:GetWide() + 30)
    end
end

function PANEL:CreateMenu()
    local mat = Material("asterion/academy/ui/icons/characters_ct.png", "smooth")

    local titleFont = "arb.Font_FuturaPTDemi_21"
    local titleFontHeight = draw.GetFontHeight(titleFont)

    self.title = self:Add("Panel")
    self.title:SetTall(titleFontHeight * 2.14285714286)
    self.title:Dock(TOP)
    self.title:DockMargin(0, 0, 0, 30)
    self.title.Paint = function(_, w, h)
        local matColor = ColorAlpha(Arbitrage.theme:GetVisLogos(), 50)
        surface.SetDrawColor(matColor.r, matColor.g, matColor.b, 50)
        surface.SetMaterial(mat)
        surface.DrawTexturedRect(0, 0, h * 1.47058823529, h)

        local lineColor = Arbitrage.theme:GetVisForeground()
        surface.SetDrawColor(lineColor.r, lineColor.g, lineColor.b, 255)
        surface.DrawRect(0, h - 1, w, 1)

        draw.SimpleText(self.bSelectCategory and "ВЫБОР ПЕРСОНАЖА" or "ВЫБОР ГЛАВЫ", titleFont, titleFontHeight * 1.26984126984, h / 2, Arbitrage.theme:GetTextCategory(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local pageFont = "arb.Font_FuturaPTMedium_9"
    local pageFontHeight = draw.GetFontHeight(pageFont)

    self.pages = self.title:Add("Panel")
    self.pages:Dock(RIGHT)
    self.pages:SetWide(ScrW() * 0.5)
    self.pages:DockMargin(0, self.title:GetTall() * 0.35, 80, self.title:GetTall() * 0.35)

    local presentersButton = self.pages:Add("DButton")
    presentersButton:SetText("")
    presentersButton:Dock(RIGHT)
    presentersButton:DockMargin(30, 0, 0, 0)
    presentersButton:SetWide(pageFontHeight * 6.03703703704)
    presentersButton.alpha = 0
    presentersButton.color = Arbitrage.theme:GetTextUnHeader()
    presentersButton.Paint = function(this, w, h)
        this.color = LerpColor(FrameTime() * 10, this.color, this:IsHovered() and Arbitrage.theme:GetTextHeader() or Arbitrage.theme:GetTextUnHeader())
        this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 1 or 0)

        draw.SimpleText("ВЕДУЩИЕ", pageFont, w / 2, h / 2, this.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if this.alpha > 0.05 then
            Arbitrage.DrawGradient(GRADIENT_RIGHT, 0, h - 2, w / 2, 2, ColorAlpha(this.color, this.alpha * 255))
            Arbitrage.DrawGradient(GRADIENT_LEFT, w / 2, h - 2, w / 2, 2, ColorAlpha(this.color, this.alpha * 255))
        end
    end
    presentersButton.DoClick = function()
        if self.bSelectCategory then return end

        local characters = {}
        for _, character in pairs(Character.team.instances) do
            if F(character.category) == F("#category_button_mm") then
                characters[#characters + 1] = character
            end
        end

        self:CreateCharacters(characters)
    end

    local applicantsButton = self.pages:Add("DButton")
    applicantsButton:SetText("")
    applicantsButton:Dock(RIGHT)
    applicantsButton:DockMargin(30, 0, 0, 0)
    applicantsButton:SetWide(pageFontHeight * 6.03703703704)
    applicantsButton.alpha = 1
    applicantsButton.color = Arbitrage.theme:GetTextHeader()
    applicantsButton.Paint = function(this, w, h)
        draw.SimpleText("ПРЕТЕНДЕНТЫ", pageFont, w / 2, h / 2, this.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        Arbitrage.DrawGradient(GRADIENT_RIGHT, 0, h - 2, w / 2, 2, ColorAlpha(this.color, this.alpha * 255))
        Arbitrage.DrawGradient(GRADIENT_LEFT, w / 2, h - 2, w / 2, 2, ColorAlpha(this.color, this.alpha * 255))
    end

    self:CreateCategories()
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

vgui.Register("arb.mainmenu:Characters", PANEL, "Panel")