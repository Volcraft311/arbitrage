local function draw_circle(x, y, radius, seg)
    local cir = {}

    table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
    for i = 0, seg do
        local a = math.rad( ( i / seg ) * -360 )
        table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
    end

    local a = math.rad(0)
    table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

    surface.DrawPoly(cir)
end

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
        if IsValid(self.editablePanel) then
            timer.Simple(0, function()
                this.bOnClick = false
            end)

            return
        end

        parent:UnHideUI()

        self:AlphaTo(0, 0.5, 0, function()
            self:Remove()
        end)
    end)
end

function PANEL:AddPanel(parent, theme)
    local bAllowSelect = true
    local onCanSelect = theme.onCanSelect
    if onCanSelect then
        bAllowSelect = onCanSelect(theme)
    end

    local panel = parent:Add("DButton")
    panel:SetText("")
    panel:SetTall(ScrH() * 0.06388888888)
    panel:Dock(TOP)
    panel.alpha = 0
    panel.Paint = function(this, w, h)
        this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and (bAllowSelect and 1 or 0) or 0)

        if this.alpha > 0.05 then
            local _w = w * 1
            local _h = _w * 0.5625

            local material = Arbitrage.theme:ProcessMaterial(theme.images.primary_bg)
            if material then
                surface.SetDrawColor(255, 255, 255, 255 * this.alpha)
                surface.SetMaterial(material)
                surface.DrawTexturedRect(0, -_h * 0.5, _w, _h)
            end

            Arbitrage.DrawGradient(GRADIENT_LEFT, 0, 0, w * (0.1 * this.alpha), h, theme.information)
        end

        draw.SimpleText(theme.name, "arb.Font_FuturaPTBook_11", 150, h / 2, Color(255, 255, 255, 50 + this.alpha * 205), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        local color = Arbitrage.theme:GetInformation()
        Arbitrage.DrawGradient(GRADIENT_RIGHT, 0, h - 2, w, 2, Color(color.r, color.g, color.b, 15))
    end
    panel.DoClick = function(_, w, h)
        if !bAllowSelect then return end

        RunConsoleCommand("arb_theme", theme.uniqueID)
    end

    return panel
end

function PANEL:CreateMenu()
    local mat = Material("asterion/academy/ui/icons/wiki_ct.png", "smooth")

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

        draw.SimpleText("КАСТОМИЗАЦИЯ", titleFont, titleFontHeight * 1.26984126984, h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local fillPanel = self:Add("Panel")
    fillPanel:Dock(FILL)

    local leftPanel = fillPanel:Add("Panel")
    leftPanel:Dock(LEFT)
    leftPanel:DockMargin(0, 0, 0, 50)
    leftPanel:SetWide(ScrW() * 0.35)

    self.scrollPanel = leftPanel:Add("DScrollPanel")
    self.scrollPanel:Dock(FILL)

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

    local brushIcon = Material("asterion/academy/ui/icons/brush.png", "smooth")

    for theme_id, theme in pairs(Arbitrage.theme.stored) do
        if theme.onEdit then
            local panel = self:AddPanel(leftPanel, theme)
            panel:Dock(BOTTOM)

            local bAllowEdit = true
            local onCanEdit = theme.onCanEdit
            if onCanEdit then
                bAllowEdit = onCanEdit(theme, LocalPlayer())
            end

            local editButton = panel:Add("DButton")
            editButton:SetText("")
            editButton:Dock(RIGHT)
            editButton:SetTall(panel:GetWide())
            editButton.alpha = 0.3
            editButton.Paint = function(this, w, h)
                this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and (bAllowEdit and 1 or 0.3) or 0.3)

                local size = h * 0.3
                local color = Arbitrage.theme:GetInformation()

                surface.SetDrawColor(color.r, color.g, color.b, this.alpha * 255)
                surface.SetMaterial(brushIcon)
                surface.DrawTexturedRect(w / 2 - size / 2 , h / 2 - size / 2, size, size)
            end
            editButton.DoClick = function()
                if !bAllowEdit then return end

                self:AlphaTo(0, 0.5)

                self.editablePanel = self:Add("arb.mainmenu:CustomizationEditable")
                self.editablePanel:SetTheme(theme)
            end
        else
            self:AddPanel(self.scrollPanel, theme)
        end
    end

    local categoryFont = "arb.Font_FuturaPTMedium_12"
    local categoryFontHeight = draw.GetFontHeight(categoryFont)

    local categoryUser = leftPanel:Add("DPanel")
    categoryUser:Dock(BOTTOM)
    categoryUser:SetTall(categoryFontHeight)
    categoryUser.Paint = function(this, w, h)
        local color = Arbitrage.theme:GetInformation()

        local width = draw.SimpleText("ПОЛЬЗОВАТЕЛЬСКИЕ", categoryFont, w / 2, h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(color.r, color.g, color.b)
        surface.DrawRect(150, h / 2 - 1, w / 2 - 25 - 150, 2)

        surface.SetDrawColor(color.r, color.g, color.b)
        surface.DrawRect(w / 2 + width + 25, h / 2 - 1, w / 2, 2)
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

vgui.Register("arb.mainmenu:Customization", PANEL, "Panel")


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
        self:AlphaTo(0, 0.5, 0, function()
            self:Remove()
        end)

        parent:AlphaTo(255, 0.5)
    end)
end

function PANEL:CreateMenu()
    local mat = Material("asterion/academy/ui/icons/settings_ct.png", "smooth")

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

        draw.SimpleText("ИЗМЕНЕНИЕ ТЕМЫ", titleFont, titleFontHeight * 1.26984126984, h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local buttonFont = "arb.Font_FuturaPTMedium_9"
    local buttonFontHeight = draw.GetFontHeight(buttonFont)
    local pageFont = "arb.Font_FuturaPTMedium_9"

    local importButton = title:Add("DButton")
    importButton:SetText("")
    importButton:Dock(RIGHT)
    importButton:DockMargin(30, 0, self.paddingRight, 0)
    importButton:SetWide(buttonFontHeight * 4.5)
    importButton.alpha = 0
    importButton.color = Arbitrage.theme:GetTextPrimary()
    importButton.Paint = function(this, w, h)
        this.color = LerpColor(FrameTime() * 10, this.color, this:IsHovered() and Arbitrage.theme:GetTextTitle() or Arbitrage.theme:GetTextPrimary())
        this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 1 or 0)

        local _, height = draw.SimpleText("ИМПОРТ", pageFont, w / 2, h / 2, this.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        local size = h * 0.3
        local color = Arbitrage.theme:GetInformation()
        surface.SetDrawColor(color.r, color.g, color.b)
        surface.DrawOutlinedRect(0, h / 2 - size / 2, w, size, 2)
    end
    importButton.DoClick = function()
        local menu = DermaMenu()
        menu:SetAlpha(0)
        menu:AlphaTo(255, 0.25)

        paintMenu(menu)

        local files = Arbitrage.theme:GetConfigs()
        for _, name in ipairs(files) do
            local button = menu:AddOption(name, function()
                Arbitrage.theme:Import(name, self.theme.uniqueID)
            end)

            paintOption(button)
        end

        menu:Open()
    end

    local exportButton = title:Add("DButton")
    exportButton:SetText("")
    exportButton:Dock(RIGHT)
    exportButton:DockMargin(30, 0, 0, 0)
    exportButton:SetWide(buttonFontHeight * 5.8)
    exportButton.alpha = 0
    exportButton.color = Arbitrage.theme:GetTextPrimary()
    exportButton.Paint = function(this, w, h)
        this.color = LerpColor(FrameTime() * 10, this.color, this:IsHovered() and Arbitrage.theme:GetTextTitle() or Arbitrage.theme:GetTextPrimary())
        this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 1 or 0)

        local _, height = draw.SimpleText("ЭКСПОРТ", pageFont, w / 2, h / 2, this.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        local size = h * 0.3
        local color = Arbitrage.theme:GetInformation()
        surface.SetDrawColor(color.r, color.g, color.b)
        surface.DrawOutlinedRect(0, h / 2 - size / 2, w, size, 2)
    end
    exportButton.DoClick = function()
        Derma_StringRequest("Название файла", "Укажите с каким названием вы хотите экспортировать тему", "", function(text)
            Arbitrage.theme:Export(text, self.theme.uniqueID)
        end, nil)
    end
end

local names = {
    text_title = "Заглавление в тексте",
    text_category = "Оглавления категорий",
    text_primary = "Информационный текст в блоках",
    text_secondary = "Второстепенный текст",
    text_tertriary = "Третьестепенный текст",

    text_header = "Выбранная текстовая категория",
    text_button = "Текст размещенный на кнопках",
    text_selected = "Текст для выбранных элементов",
    text_unheader = "Невыбранная текстовая категория",
    text_unselected = "Текст для невыбранных элементов",
    text_locked = "Текст для заблокированных элементов",
    text_hover = "Текст при наведении на него курсором",

    player_title = "Ник персонажа в главном меню",

    vis_logos = "Логотипы, иконки",
    vis_titles = "Фон для плашек",
    vis_selection_line = "Выделение при выборе опций",
    vis_selection_square = "Выделение при выборе элементов",
    vis_thumb = "Ползунок в скроллбар",
    vis_details_title = "Первая детализация",
    vis_details_main = "Вторая детализация",
    vis_category_selected = "Выделенная выбранная категория",
    vis_category_unselected = "Не выбранная категория",
    vis_scrollbar = "Область скроллбара",

    primary_bg = "Основной задний фон",
    primary_bg_active = "Основной активный задний фон",
    primary_bg_character = "Персонаж на заднем фоне",
    primary_bg_parallax_p = "Первый элемент на заднем фоне",
    primary_bg_parallax_s = "Второй элемент на заднем фоне"
}

function PANEL:AddPanel(key, value)
    local panel = self.scrollPanel:Add("DButton")
    panel:SetText("")
    panel:Dock(TOP)
    panel:SetTall(ScrH() * 0.06388888888)
    panel:Dock(TOP)
    panel.alpha = 0
    panel.Paint = function(this, w, h)
        local color = Arbitrage.theme:GetInformation()

        this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 1 or 0)

        if this.alpha > 0.05 then
            Arbitrage.DrawGradient(GRADIENT_LEFT, 0, 0, w * (0.5 * this.alpha), h, color)
        end

        draw.SimpleText(names[key] or key, "arb.Font_FuturaPTBook_11", 150, h / 2, Color(255, 255, 255, 50 + this.alpha * 205), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        Arbitrage.DrawGradient(GRADIENT_RIGHT, 0, h - 2, w, 2, Color(color.r, color.g, color.b, 15))
    end

    return panel
end

function PANEL:SetTheme(theme)
    self.theme = theme

    local fillPanel = self:Add("Panel")
    fillPanel:Dock(FILL)

    local leftPanel = fillPanel:Add("Panel")
    leftPanel:Dock(LEFT)
    leftPanel:DockMargin(0, 0, 0, 50)
    leftPanel:SetWide(ScrW() * 0.5)

    self.scrollPanel = leftPanel:Add("DScrollPanel")
    self.scrollPanel:Dock(FILL)

    ApplySmoothScroll(self.scrollPanel)

    local bar = self.scrollPanel:GetVBar()
    bar:SetWide(30)
    bar:DockMargin(0, 0, 0, 0)

    bar.Paint = function(_, w, h)
        surface.SetDrawColor(255, 255, 255, 3)
        surface.DrawRect(20 + 7, 30, w, h - 60)
    end
    bar.btnUp.Paint = function(_, w, h) end
    bar.btnDown.Paint = function(_, w, h) end
    bar.btnGrip.Paint = function(_, w, h)
        local informationColor = Arbitrage.theme:GetInformation()

        surface.SetDrawColor(informationColor.r, informationColor.g, informationColor.b)
        surface.DrawRect(20 + 7, 0, w, h)
    end

    local categoryFont = "arb.Font_FuturaPTMedium_12"
    local categoryFontHeight = draw.GetFontHeight(categoryFont)

    local categoryColors = self.scrollPanel:Add("DPanel")
    categoryColors:Dock(TOP)
    categoryColors:SetTall(categoryFontHeight)
    categoryColors.Paint = function(this, w, h)
        local color = Arbitrage.theme:GetInformation()

        local width = draw.SimpleText("ЦВЕТА", categoryFont, 50 + 150, h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(color.r, color.g, color.b)
        surface.DrawRect(150, h / 2 - 1, 50 - 25, 2)

        surface.SetDrawColor(color.r, color.g, color.b)
        surface.DrawRect(50 + 25 + width + 150, h / 2 - 1, w * 2, 2)
    end

    for key, value in pairs(theme.colors) do
        local panel = self:AddPanel(key, value)

        local editButton = panel:Add("DButton")
        editButton:SetText("")
        editButton:Dock(RIGHT)
        editButton:SetTall(panel:GetWide())
        editButton.Paint = function(this, w, h)
            local size = h * 0.4

            local data = theme.colors[key]

            surface.SetDrawColor(data.r or 255, data.g or 255, data.b or 255, data.a or 255)
            surface.DrawRect(w / 2 - size / 2 , h / 2 - size / 2, size, size)

            local color = Arbitrage.theme:GetInformation()

            surface.SetDrawColor(color.r, color.g, color.b, 255)
            surface.DrawOutlinedRect(w / 2 - size / 2 , h / 2 - size / 2, size, size, 2)
        end
        editButton.DoClick = function(this)
            local x, y = input.GetCursorPos()

            if IsValid(self.frame) then
                self.frame:Remove()
            end

            self.frame = self:Add("EditablePanel")
            self.frame:SetAlpha(0)
            self.frame:AlphaTo(255, 0.5)
            self.frame:SetSize(260, 400)
            self.frame:SetPos(x + 25, math.Clamp(y, 0, ScrH() - self.frame:GetTall()))
            self.frame.Paint = function(frame, w, h)
                asterionlib.DrawBlur(frame, 2)

                surface.SetDrawColor(0, 0, 0, 100)
                surface.DrawRect(0, 0, w, h)
            end

            local buttonsPanel = self.frame:Add("Panel")
            buttonsPanel:Dock(TOP)
            buttonsPanel:DockMargin(0, 5, 0, 0)
            buttonsPanel:SetTall(S(30))
            buttonsPanel.Paint = function(_, w, h)
                local color = Arbitrage.theme:GetInformation()

                surface.SetDrawColor(color.r, color.g, color.b)
                surface.DrawRect(0, h - 2, w, 2)
            end

            local mixer = self.frame:Add("DColorMixer")
            mixer:Dock(FILL)
            mixer:DockMargin(10, 10, 10, 10, 10)
            mixer:SetPalette(true)
            mixer:SetAlphaBar(false)
            mixer:SetWangs(false)

            local data = theme.colors[key]
            mixer:SetColor(Color(data.r or 255, data.g or 255, data.b or 255, data.a or 255))

            local slider = mixer.HSV:GetChildren()[1]
            local sizeW, sizeH = slider:GetSize()
            slider:SetSize(sizeW * 2, sizeH * 2)
            slider.Paint = function(_, w, h)
                local color = mixer:GetColor()

                surface.SetDrawColor(color.r, color.g, color.b, color.a or 255)
                draw.NoTexture()
                draw_circle(w / 2, h / 2, h / 2, 50)
                surface.DrawCircle(w / 2, h / 2, h / 2, 0, 0, 0, 255)
            end

            local saveButton = buttonsPanel:Add("DButton")
            saveButton:SetText("")
            saveButton:Dock(RIGHT)
            saveButton:DockMargin(5, 0, 10, 5)
            saveButton:SetWide(buttonsPanel:GetTall() - 5)
            saveButton.color = color_white
            saveButton.Paint = function(this2, w, h)
                this2.color = LerpColor(FrameTime() * 10, this2.color, this2:IsHovered() and Arbitrage.theme:GetInformation() or color_white)

                local size = h
                surface.SetDrawColor(this2.color.r, this2.color.g, this2.color.b)
                surface.SetMaterial(Material("asterion/academy/ui/icons/save.png", "smooth"))
                surface.DrawTexturedRect(w / 2 - size / 2, h / 2 - size / 2, size, size)

                local color = Arbitrage.theme:GetInformation()
                surface.SetDrawColor(color.r, color.g, color.b)
                surface.DrawOutlinedRect(0, 0, w, h, 2)
            end
            saveButton.DoClick = function()
                local onEdit = theme.onEdit
                if onEdit then
                    local color = mixer:GetColor()
                    local set = Color(color.r or 255, color.g or 255, color.b or 255, theme.default.colors[key].a)

                    onEdit(theme, key, set)
                end
            end

            local defaultButton = buttonsPanel:Add("DButton")
            defaultButton:SetText("")
            defaultButton:Dock(RIGHT)
            defaultButton:DockMargin(5, 0, 0, 5)
            defaultButton:SetWide(buttonsPanel:GetTall() - 5)
            defaultButton.color = color_white
            defaultButton.Paint = function(this2, w, h)
                this2.color = LerpColor(FrameTime() * 10, this2.color, this2:IsHovered() and Arbitrage.theme:GetInformation() or color_white)

                local size = h
                surface.SetDrawColor(this2.color.r, this2.color.g, this2.color.b)
                surface.SetMaterial(Material("asterion/academy/ui/icons/reset.png", "smooth"))
                surface.DrawTexturedRect(w / 2 - size / 2, h / 2 - size / 2, size, size)

                local color = Arbitrage.theme:GetInformation()
                surface.SetDrawColor(color.r, color.g, color.b)
                surface.DrawOutlinedRect(0, 0, w, h, 2)
            end
            defaultButton.DoClick = function()
                local color = theme.default.colors[key]
                local set = Color(color.r, color.g, color.b, color.a)

                mixer:SetColor(set)
            end

            local closeButton = buttonsPanel:Add("DButton")
            closeButton:SetText("")
            closeButton:Dock(RIGHT)
            closeButton:DockMargin(5, 0, 0, 5)
            closeButton:SetWide(buttonsPanel:GetTall() - 5)
            closeButton.color = color_white
            closeButton.Paint = function(this2, w, h)
                this2.color = LerpColor(FrameTime() * 10, this2.color, this2:IsHovered() and Arbitrage.theme:GetInformation() or color_white)

                local size = h
                surface.SetDrawColor(this2.color.r, this2.color.g, this2.color.b)
                surface.SetMaterial(Material("asterion/academy/ui/icons/close.png", "smooth"))
                surface.DrawTexturedRect(w / 2 - size / 2, h / 2 - size / 2, size, size)

                local color = Arbitrage.theme:GetInformation()
                surface.SetDrawColor(color.r, color.g, color.b)
                surface.DrawOutlinedRect(0, 0, w, h, 2)
            end
            closeButton.DoClick = function()
                self.frame:AlphaTo(0, 0.25, 0, function()
                    self.frame:Remove()
                end)
            end
        end
    end

    local categoryImages = self.scrollPanel:Add("DPanel")
    categoryImages:Dock(TOP)
    categoryImages:SetTall(categoryFontHeight)
    categoryImages.Paint = function(this, w, h)
        local color = Arbitrage.theme:GetInformation()

        local width = draw.SimpleText("ИЗОБРАЖЕНИЯ", categoryFont, 50 + 150, h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        surface.SetDrawColor(color.r, color.g, color.b)
        surface.DrawRect(150, h / 2 - 1, 50 - 25, 2)
        surface.DrawRect(50 + 25 + width + 150, h / 2 - 1, w / 2, 2)
    end

    for key, value in pairs(theme.images) do
        local panel = self:AddPanel(key, value)

        local editButton = panel:Add("DButton")
        editButton:SetText("")
        editButton:Dock(RIGHT)
        editButton:SetTall(panel:GetWide())
        editButton.color = color_white
        editButton.Paint = function(this, w, h)
            this.color = LerpColor(FrameTime() * 10, this.color, this:IsHovered() and Arbitrage.theme:GetInformation() or color_white)

            local size = h * 0.4

            surface.SetDrawColor(this.color.r, this.color.g, this.color.b)
            surface.SetMaterial(Material("asterion/academy/ui/icons/image.png", "smooth"))
            surface.DrawTexturedRect(w / 2 - size / 2, h / 2 - size / 2, size, size)

            local color = Arbitrage.theme:GetInformation()

            surface.SetDrawColor(color.r, color.g, color.b, 255)
            surface.DrawOutlinedRect(w / 2 - size / 2 , h / 2 - size / 2, size, size, 2)
        end
        editButton.DoClick = function(this)
            local x, y = input.GetCursorPos()

            if IsValid(self.frame) then
                self.frame:Remove()
            end

            local data = theme.images[key]

            self.frame = self:Add("EditablePanel")
            self.frame:SetAlpha(0)
            self.frame:AlphaTo(255, 0.5)
            self.frame:SetSize(500, 400)
            self.frame:SetPos(x + 25, math.Clamp(y, 0, ScrH() - self.frame:GetTall()))
            self.frame.Paint = function(frame, w, h)
                asterionlib.DrawBlur(frame, 2)

                surface.SetDrawColor(0, 0, 0, 100)
                surface.DrawRect(0, 0, w, h)
            end

            local buttonsPanel = self.frame:Add("Panel")
            buttonsPanel:Dock(TOP)
            buttonsPanel:DockMargin(0, 5, 0, 0)
            buttonsPanel:SetTall(S(30))
            buttonsPanel.Paint = function(_, w, h)
                local color = Arbitrage.theme:GetInformation()

                surface.SetDrawColor(color.r, color.g, color.b)
                surface.DrawRect(0, h - 2, w, 2)
            end

            local saveButton = buttonsPanel:Add("DButton")
            saveButton:SetText("")
            saveButton:Dock(RIGHT)
            saveButton:DockMargin(5, 0, 10, 5)
            saveButton:SetWide(buttonsPanel:GetTall() - 5)
            saveButton.color = color_white
            saveButton.Paint = function(this2, w, h)
                this2.color = LerpColor(FrameTime() * 10, this2.color, this2:IsHovered() and Arbitrage.theme:GetInformation() or color_white)

                local size = h
                surface.SetDrawColor(this2.color.r, this2.color.g, this2.color.b)
                surface.SetMaterial(Material("asterion/academy/ui/icons/save.png", "smooth"))
                surface.DrawTexturedRect(w / 2 - size / 2, h / 2 - size / 2, size, size)

                local color = Arbitrage.theme:GetInformation()
                surface.SetDrawColor(color.r, color.g, color.b)
                surface.DrawOutlinedRect(0, 0, w, h, 2)
            end
            saveButton.DoClick = function()
                local onEdit = theme.onEdit
                if onEdit then
                    local set = self.frame.dTextEntry:GetValue()

                    self.frame.dTextEntry.value = set
                    onEdit(theme, key, set)
                end
            end

            local defaultButton = buttonsPanel:Add("DButton")
            defaultButton:SetText("")
            defaultButton:Dock(RIGHT)
            defaultButton:DockMargin(5, 0, 0, 5)
            defaultButton:SetWide(buttonsPanel:GetTall() - 5)
            defaultButton.color = color_white
            defaultButton.Paint = function(this2, w, h)
                this2.color = LerpColor(FrameTime() * 10, this2.color, this2:IsHovered() and Arbitrage.theme:GetInformation() or color_white)

                local size = h
                surface.SetDrawColor(this2.color.r, this2.color.g, this2.color.b)
                surface.SetMaterial(Material("asterion/academy/ui/icons/reset.png", "smooth"))
                surface.DrawTexturedRect(w / 2 - size / 2, h / 2 - size / 2, size, size)

                local color = Arbitrage.theme:GetInformation()
                surface.SetDrawColor(color.r, color.g, color.b)
                surface.DrawOutlinedRect(0, 0, w, h, 2)
            end
            defaultButton.DoClick = function()
                local image = theme.default.images[key]

                self.frame.dTextEntry:SetValue(image)
                self.frame.dTextEntry.value = image
            end

            local closeButton = buttonsPanel:Add("DButton")
            closeButton:SetText("")
            closeButton:Dock(RIGHT)
            closeButton:DockMargin(5, 0, 0, 5)
            closeButton:SetWide(buttonsPanel:GetTall() - 5)
            closeButton.color = color_white
            closeButton.Paint = function(this2, w, h)
                this2.color = LerpColor(FrameTime() * 10, this2.color, this2:IsHovered() and Arbitrage.theme:GetInformation() or color_white)

                local size = h
                surface.SetDrawColor(this2.color.r, this2.color.g, this2.color.b)
                surface.SetMaterial(Material("asterion/academy/ui/icons/close.png", "smooth"))
                surface.DrawTexturedRect(w / 2 - size / 2, h / 2 - size / 2, size, size)

                local color = Arbitrage.theme:GetInformation()
                surface.SetDrawColor(color.r, color.g, color.b)
                surface.DrawOutlinedRect(0, 0, w, h, 2)
            end
            closeButton.DoClick = function()
                self.frame:AlphaTo(0, 0.25, 0, function()
                    self.frame:Remove()
                end)
            end

            self.frame.dTextEntry = self.frame:Add("DTextEntry")
            self.frame.dTextEntry:SetValue(data)
            self.frame.dTextEntry:SetFont("arb.Font_FuturaPTBook_7")
            self.frame.dTextEntry:SetTextColor(Color(0, 0, 0))
            self.frame.dTextEntry:Dock(TOP)
            self.frame.dTextEntry:DockMargin(10, 10, 10, 10)
            self.frame.dTextEntry:SetPlaceholderText("https://i.ibb.co/43SJdHG/lang.png")
            self.frame.dTextEntry:SizeToContents()
            self.frame.dTextEntry.value = data
            self.frame.dTextEntry.OnEnter = function(this2)
                local text = this2:GetValue()

                this2.value = text
            end

            local imagePanel = self.frame:Add("DPanel")
            imagePanel:Dock(FILL)
            imagePanel:DockMargin(10, 0, 10, 0)
            imagePanel.Paint = function(this2, w, h)
                local mat = Arbitrage.theme:ProcessMaterial(self.frame.dTextEntry.value)

                if mat then
                    local texWidth = mat:Width()
                    local texHeight = mat:Height()

                    local widthRatio = w / texWidth
                    local heightRatio = h / texHeight

                    local drawWidth, drawHeight
                    local x, y

                    local scale = math.max(widthRatio, heightRatio)

                    drawWidth = texWidth * scale
                    drawHeight = texHeight * scale

                    x = (w - drawWidth) / 2
                    y = (h - drawHeight) / 2

                    surface.SetDrawColor(255, 255, 255)
                    surface.SetMaterial(mat)
                    surface.DrawTexturedRect(x, y, drawWidth, drawHeight)
                end

                local color = Arbitrage.theme:GetInformation()
                surface.SetDrawColor(color.r, color.g, color.b)
                surface.DrawOutlinedRect(0, 0, w, h, 2)
            end
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

function PANEL:OnRemove()
    if IsValid(self.frame) then
        self.frame:Remove()
    end
end

function PANEL:Paint(w, h)
    asterionlib.DrawBlur(self, 8)
end

vgui.Register("arb.mainmenu:CustomizationEditable", PANEL, "EditablePanel")