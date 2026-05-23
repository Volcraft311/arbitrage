local PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 1)

    self.selectID = nil
    self.paddingTop = 62
    self.paddingRight = 80

    self:CreateCategoryMenu()

    local keyFont = "arb.Font_FuturaPTDemi_8"
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

    self:RebuildMainFrame(self.OptionsMenu)
end

function PANEL:RebuildMainFrame(callback)
    local function create()
        self.mainFrame = self:Add("Panel")
        self.mainFrame:SetAlpha(0)
        self.mainFrame:AlphaTo(255, 0.5)
        self.mainFrame:Dock(FILL)
        self.mainFrame:DockMargin(0, 67, self.paddingRight, 72)

        if callback then
            callback(self)
        end
    end

    if IsValid(self.mainFrame) then
        self.mainFrame:AlphaTo(0, 0.15, 0, function()
            self.mainFrame:Remove()

            create()
        end)
    else
        create()
    end
end

local subscribeMat = Material("danganronpa/ui/info_7.png", "smooth")
local installMat = Material("danganronpa/ui/info_6.png", "smooth")
local noInstallMat = Material("danganronpa/ui/info_5.png", "smooth")

local statusMat = {
    [0] = {
        text = "#addon_status_noinstalled",
        mat = noInstallMat,
        color = Color(255, 65, 23)
    },
    [1] = {
        text = "#addon_status_tempinstalled",
        mat = installMat,
        color = Color(255, 176, 56)
    },
    [2] = {
        text = "#addon_status_installed",
        mat = subscribeMat,
        color = Color(14, 255, 110)
    }
}

function PANEL:ContentMenu()
    self.selectID = "content"

    local scrollPanel = self.mainFrame:Add("DScrollPanel")
    scrollPanel:SetWide(self:GetWide() * 0.44)
    scrollPanel:Dock(LEFT)
    scrollPanel:DockMargin(150, 0, 80, 0)

    ApplySmoothScroll(scrollPanel)

    local bar = scrollPanel:GetVBar()
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

    local infoPanel = self.mainFrame:Add("Panel")
    infoPanel:Dock(FILL)

    local infoTitle = infoPanel:Add("DLabel")
    infoTitle:Dock(TOP)
    infoTitle:SetText("")
    infoTitle:SetFont("arb.Font_FuturaPTDemi_13")
    infoTitle:SizeToContents()

    local infoDesc = infoPanel:Add("DLabel")
    infoDesc:Dock(FILL)
    infoDesc:SetText("")
    infoDesc:SetFont("arb.Font_FuturaPTBook_8")
    infoDesc:SetContentAlignment(7)
    infoDesc:SetWrap(true)

    local selected = nil

    local List = scrollPanel:Add("DIconLayout")
    List:Dock(FILL)

    for k, v in pairs(asterionlib.workshop.list) do
        local image, imageSize = nil, W(120)
        asterionlib.downloader:Image(v.image, function(matPath)
            image = matPath
        end)

        local bInstall = v.status != 0
        local name = v.name
        local maxChar = 20
        if utf8.len(name) > maxChar then
            name = utf8.sub(name, 1, maxChar - 3) .. "..."
        end

        local ListItem = List:Add("DButton")
        ListItem:SetText("")
        ListItem:SetSize(W(160), H(200))
        ListItem.alpha = 0
        ListItem.color = color_white
        ListItem.Paint = function(this, w, h)
            local isSelect = selected == k
            local blacked = bInstall and 255 or 100

            this.alpha = Lerp(FrameTime() * 10, this.alpha, isSelect and 1 or -0.1)

            local color = Arbitrage.theme:GetInformation()
            this.color = LerpColor(FrameTime() * 10, this.color, isSelect and color or color_white)

            local x, y = w / 2 - imageSize / 2, 4

            if image then
                surface.SetDrawColor(blacked, blacked, blacked)
                surface.SetMaterial(image)
                surface.DrawTexturedRect(x, y, imageSize, imageSize)
            end

            surface.SetDrawColor(15, 15, 15)
            surface.DrawOutlinedRect(x, y, imageSize, imageSize, 2)

            if this.alpha > 0.05 then
                surface.SetDrawColor(this.color.r, this.color.g, this.color.b, this.alpha * 255)
                surface.DrawOutlinedRect(x, y, imageSize, imageSize, 2)
            end

            draw.SimpleText(name, "arb.Font_FuturaPTBook_7", w / 2, imageSize + H(10), this.color, TEXT_ALIGN_CENTER)

            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(statusMat[tonumber(v.status)].mat)
            surface.DrawTexturedRect(imageSize - 12, 0, 33, 33)
        end

        local function sel()
            selected = k

            infoTitle:SetText(v.name)
            infoTitle:SetAlpha(0)
            infoTitle:AlphaTo(255, 0.25)
            infoTitle:SizeToContents()

            infoDesc:SetText(v.stored.description)
            infoDesc:SetAlpha(0)
            infoDesc:AlphaTo(255, 0.25)
        end

        ListItem.DoClick = sel
        ListItem.DoDoubleClick = function()
            sel()
            steamworks.ViewFile(k)
        end
        ListItem.DoRightClick = function()
            sel()
            steamworks.ViewFile(k)
        end
    end
end

function PANEL:BindsMenu()
    self.selectID = "binds"
    self.optionsSelectID = nil

    local scrollPanel = self.mainFrame:Add("DScrollPanel")
    scrollPanel:SetWide(self:GetWide() * 0.5)
    scrollPanel:Dock(LEFT)
    scrollPanel:DockMargin(0, 0, 80, 0)

    ApplySmoothScroll(scrollPanel)

    local bar = scrollPanel:GetVBar()
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

    local infoPanel = self.mainFrame:Add("Panel")
    infoPanel:Dock(FILL)

    local infoImage = infoPanel:Add("DPanel")
    infoImage:Dock(TOP)
    infoImage:DockMargin(0, 0, 0, 0)
    infoImage:SetTall(0)
    infoImage.image = nil
    infoImage.maxHeight = ScrH() * 0.4
    infoImage.Paint = function(this, w, h)
        if !this.image then return end

        local texWidth, texHeight = this.image:Width(), this.image:Height()
        local aspectRatio = texWidth / texHeight

        local targetHeight = w / aspectRatio

        if targetHeight > this.maxHeight then
            targetHeight = this.maxHeight

            w = targetHeight * aspectRatio
        end

        local x = (this:GetWide() - w) * 0.5

        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(this.image)
        surface.DrawTexturedRect(x, 0, w, targetHeight)
    end

    local infoTitle = infoPanel:Add("DLabel")
    infoTitle:Dock(TOP)
    infoTitle:SetText("")
    infoTitle:SetFont("arb.Font_FuturaPTDemi_13")
    infoTitle:SizeToContents()

    local infoDesc = infoPanel:Add("DLabel")
    infoDesc:Dock(FILL)
    infoDesc:SetText("")
    infoDesc:SetFont("arb.Font_FuturaPTBook_8")
    infoDesc:SetContentAlignment(7)
    infoDesc:SetWrap(true)

    local optionTitleFont = "arb.Font_FuturaPTMedium_15"
    local optionTitleFontHeight = draw.GetFontHeight(optionTitleFont)
    local informationColor = Arbitrage.theme:GetInformation()

    local data = {}
    for k, v in pairs(SETTINGS.GetStored().binds) do
        local category = v.category

        data[category] = data[category] or {}
        data[category][k] = v
    end

    local categoryFont = "arb.Font_FuturaPTMedium_12"
    local categoryFontHeight = draw.GetFontHeight(categoryFont)

    for category, info in SortedPairs(data) do
        local categoryPanel = scrollPanel:Add("DPanel")
        categoryPanel:Dock(TOP)
        categoryPanel:DockMargin(0, 20, 0, 0)
        categoryPanel:SetTall(categoryFontHeight)
        categoryPanel.Paint = function(this, w, h)
            local color = Arbitrage.theme:GetInformation()

            local width = draw.SimpleText(L(category), categoryFont, 50 + 150, h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            surface.SetDrawColor(color.r, color.g, color.b)
            surface.DrawRect(150, h / 2 - 1, 50 - 25, 2)
            surface.DrawRect(50 + 25 + width + 150, h / 2 - 1, w * 2, 2)
        end

        local panels = {}
        for k, v in pairs(info) do
            local optionPanel = scrollPanel:Add("DButton")
            optionPanel:SetText("")
            optionPanel:Dock(TOP)
            optionPanel:DockMargin(0, 0, 0, 5)
            optionPanel:SetTall(optionTitleFontHeight)
            optionPanel.alpha = 0
            optionPanel.color = informationColor
            optionPanel.Paint = function(this, w, h)
                local bSelected = k == self.optionsSelectID

                this.isHovered = this:IsHovered() or bSelected
                for k2, v2 in ipairs(optionPanel:GetChildren()) do
                    if v2:IsHovered() then
                        this.isHovered = true
                    end
                end

                this.alpha = Lerp(FrameTime() * 5, this.alpha, this.isHovered and 1 or 0)
                this.color = LerpColor(FrameTime() * 5, this.color, bSelected and Color(255, 255, 255) or informationColor)

                Arbitrage.DrawGradient(GRADIENT_LEFT, 0, 0, w * 0.7 * this.alpha, optionTitleFontHeight, Color(informationColor.r, informationColor.g, informationColor.b, 50 * this.alpha))
                draw.SimpleText(L(v.name), "arb.Font_FuturaPTMedium_11", 150, optionTitleFontHeight / 2, ColorAlpha(this.color, 100 + 155 * this.alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

                Arbitrage.DrawGradient(GRADIENT_RIGHT, 0, h - 2, w, 2, ColorAlpha(informationColor, 15))
            end
            optionPanel.DoClick = function()
                if self.optionsSelectID == k then return end

                self.optionsSelectID = k

                infoTitle:SetText(L(v.title))
                infoTitle:SetAlpha(0)
                infoTitle:AlphaTo(255, 0.25)
                infoTitle:SizeToContents()

                infoDesc:SetText(L(v.description))
                infoDesc:SetAlpha(0)
                infoDesc:AlphaTo(255, 0.25)

                infoImage:SetAlpha(0)
                infoImage:AlphaTo(255, 0.25)

                if v.image then
                    infoImage.image = Material(v.image, "smooth")

                    local texWidth, texHeight = infoImage.image:Width(), infoImage.image:Height()
                    local targetHeight = infoImage:GetWide() * (texHeight / texWidth)

                    if targetHeight > infoImage.maxHeight then
                        targetHeight = infoImage.maxHeight
                    end

                    infoImage:SetTall(targetHeight)
                    infoImage:DockMargin(0, 0, 0, 20)
                else
                    infoImage:SetTall(0)
                    infoImage:DockMargin(0, 0, 0, 0)
                end
            end

            local dButtonEdit = optionPanel:Add("DButton")
            dButtonEdit:SetText("")
            dButtonEdit:SetSize(optionTitleFontHeight * 2.9, optionTitleFontHeight)
            dButtonEdit:SetPos(scrollPanel:GetWide() - 30 - dButtonEdit:GetWide(), 0)
            dButtonEdit.isEdit = false
            dButtonEdit.Paint = function(this, w, h)
                local color = ColorAlpha(optionPanel.color, 100 + 155 * optionPanel.alpha)

                local key = input.GetKeyName(v.value) or "NULL"
                if this.isEdit then
                    key = "...."
                end

                draw.SimpleText(key:upper(), "arb.Font_FuturaPTMedium_10", w / 2, optionTitleFontHeight / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                for i = 1, 25 do
                    surface.DrawRect((i - 1) * 7 + 4 * (i - 1), optionTitleFontHeight - 2 - 6, 7, 2)
                end
            end
            dButtonEdit.DoClick = function(this)
                optionPanel:DoClick()

                for k2, v2 in pairs(panels) do
                    if !IsValid(v2) then continue end
                    if v2 == this then continue end

                    v2.isEdit = false
                end

                this.isEdit = !this.isEdit
            end
            dButtonEdit.Think = function(this)
                if !this.isEdit then return end

                local key = SETTINGS.binds.GetClampedKey()
                if key and key != MOUSE_LEFT then
                    this.isEdit = false

                    SETTINGS.binds.Set(v.id, key)
                    hook.Run("SETTINGS:OnBindChange", v.id, key)
                end
            end
            panels[#panels + 1] = dButtonEdit

            local matReset = Material("asterion/academy/ui/icons/reset2.png", "smooth")
            local resetBtn = optionPanel:Add("DButton")
            resetBtn:SetText("")
            resetBtn:SetSize(optionTitleFontHeight, optionTitleFontHeight)
            resetBtn:SetPos(scrollPanel:GetWide() - 30 - dButtonEdit:GetWide() - resetBtn:GetWide(), 0)
            resetBtn.alpha = 0
            resetBtn.Paint = function(this, w, h)
                this.alpha = Lerp(FrameTime() * 10, this.alpha, v.value != v.default and (this:IsHovered() and 1 or 0.35) or 0)

                local size = h * 0.5

                surface.SetDrawColor(informationColor.r, informationColor.g, informationColor.b, 255 * this.alpha)
                surface.SetMaterial(matReset)
                surface.DrawTexturedRect(w / 2 - size / 2, h / 2 - size / 2, size, size)
            end
            resetBtn.DoClick = function()
                SETTINGS.binds.Set(v.id, v.default)
                hook.Run("SETTINGS:OnOptionChange", v.id, v.default)
            end
        end
    end
end

function PANEL:OptionsMenu()
    self.selectID = "options"
    self.optionsSelectID = nil

    local scrollPanel = self.mainFrame:Add("DScrollPanel")
    scrollPanel:SetWide(self:GetWide() * 0.5)
    scrollPanel:Dock(LEFT)
    scrollPanel:DockMargin(0, 0, 80, 0)

    ApplySmoothScroll(scrollPanel)

    local bar = scrollPanel:GetVBar()
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

    local infoPanel = self.mainFrame:Add("Panel")
    infoPanel:Dock(FILL)

    local infoImage = infoPanel:Add("DPanel")
    infoImage:Dock(TOP)
    infoImage:DockMargin(0, 0, 0, 0)
    infoImage:SetTall(0)
    infoImage.image = nil
    infoImage.maxHeight = ScrH() * 0.4
    infoImage.Paint = function(this, w, h)
        if !this.image then return end

        local texWidth, texHeight = this.image:Width(), this.image:Height()
        local aspectRatio = texWidth / texHeight

        local targetHeight = w / aspectRatio

        if targetHeight > this.maxHeight then
            targetHeight = this.maxHeight

            w = targetHeight * aspectRatio
        end

        local x = (this:GetWide() - w) * 0.5

        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(this.image)
        surface.DrawTexturedRect(x, 0, w, targetHeight)
    end

    local infoTitle = infoPanel:Add("DLabel")
    infoTitle:Dock(TOP)
    infoTitle:SetText("")
    infoTitle:SetFont("arb.Font_FuturaPTDemi_13")
    infoTitle:SizeToContents()

    local infoDesc = infoPanel:Add("DLabel")
    infoDesc:Dock(FILL)
    infoDesc:SetText("")
    infoDesc:SetFont("arb.Font_FuturaPTBook_8")
    infoDesc:SetContentAlignment(7)
    infoDesc:SetWrap(true)

    local optionTitleFont = "arb.Font_FuturaPTMedium_15"
    local optionTitleFontHeight = draw.GetFontHeight(optionTitleFont)
    local informationColor = Arbitrage.theme:GetInformation()

    local data = {}
    for k, v in pairs(SETTINGS.GetStored().options) do
        local category = v.category

        data[category] = data[category] or {}
        data[category][k] = v
    end

    local categoryFont = "arb.Font_FuturaPTMedium_12"
    local categoryFontHeight = draw.GetFontHeight(categoryFont)

    for category, info in SortedPairs(data) do
        local categoryPanel = scrollPanel:Add("DPanel")
        categoryPanel:Dock(TOP)
        categoryPanel:DockMargin(0, 20, 0, 0)
        categoryPanel:SetTall(categoryFontHeight)
        categoryPanel.Paint = function(this, w, h)
            local color = Arbitrage.theme:GetInformation()

            local width = draw.SimpleText(L(category), categoryFont, 50 + 150, h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            surface.SetDrawColor(color.r, color.g, color.b)
            surface.DrawRect(150, h / 2 - 1, 50 - 25, 2)
            surface.DrawRect(50 + 25 + width + 150, h / 2 - 1, w * 2, 2)
        end

        for k, v in pairs(info) do
            local optionPanel = scrollPanel:Add("DButton")
            optionPanel:SetText("")
            optionPanel:Dock(TOP)
            optionPanel:DockMargin(0, 0, 0, 5)
            optionPanel:SetTall(optionTitleFontHeight)
            optionPanel.alpha = 0
            optionPanel.color = informationColor
            optionPanel.Paint = function(this, w, h)
                local bSelected = k == self.optionsSelectID

                this.isHovered = this:IsHovered() or bSelected
                for k2, v2 in ipairs(optionPanel:GetChildren()) do
                    if v2:IsHovered() then
                        this.isHovered = true
                    end
                end

                this.alpha = Lerp(FrameTime() * 5, this.alpha, this.isHovered and 1 or 0)
                this.color = LerpColor(FrameTime() * 5, this.color, bSelected and Color(255, 255, 255) or informationColor)

                Arbitrage.DrawGradient(GRADIENT_LEFT, 0, 0, w * 0.7 * this.alpha, optionTitleFontHeight, Color(informationColor.r, informationColor.g, informationColor.b, 50 * this.alpha))
                draw.SimpleText(L(v.name), "arb.Font_FuturaPTMedium_11", 150, optionTitleFontHeight / 2, ColorAlpha(this.color, 100 + 155 * this.alpha), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

                Arbitrage.DrawGradient(GRADIENT_RIGHT, 0, h - 2, w, 2, ColorAlpha(informationColor, 15))
            end
            optionPanel.DoClick = function()
                if self.optionsSelectID == k then return end

                self.optionsSelectID = k

                infoTitle:SetText(L(v.title))
                infoTitle:SetAlpha(0)
                infoTitle:AlphaTo(255, 0.25)
                infoTitle:SizeToContents()

                infoDesc:SetText(L(v.description))
                infoDesc:SetAlpha(0)
                infoDesc:AlphaTo(255, 0.25)

                infoImage:SetAlpha(0)
                infoImage:AlphaTo(255, 0.25)

                if v.image then
                    infoImage.image = Material(v.image, "smooth")

                    local texWidth, texHeight = infoImage.image:Width(), infoImage.image:Height()
                    local targetHeight = infoImage:GetWide() * (texHeight / texWidth)

                    if targetHeight > infoImage.maxHeight then
                        targetHeight = infoImage.maxHeight
                    end

                    infoImage:SetTall(targetHeight)
                    infoImage:DockMargin(0, 0, 0, 20)
                else
                    infoImage:SetTall(0)
                    infoImage:DockMargin(0, 0, 0, 0)
                end
            end

            if v.m_type == "bool" then
                local dComboBox = optionPanel:Add("DButton")
                dComboBox:SetText("")
                dComboBox:SetSize(optionTitleFontHeight * 2.9, optionTitleFontHeight)
                dComboBox:SetPos(scrollPanel:GetWide() - 30 - dComboBox:GetWide(), 0)
                dComboBox.bOpen = false
                dComboBox.mOpenLerp = 0
                dComboBox.Paint = function(this, w, h)
                    local color = ColorAlpha(optionPanel.color, 100 + 155 * optionPanel.alpha)

                    optionPanel:SetTall(optionTitleFontHeight + optionTitleFontHeight * this.mOpenLerp)

                    this.mOpenLerp = Lerp(FrameTime() * 10, this.mOpenLerp, this.bOpen and 1 or 0)
                    draw.SimpleText(v.value and "ВКЛЮЧИТЬ" or "ВЫКЛЮЧИТЬ", "arb.Font_FuturaPTMedium_7", 0, optionTitleFontHeight / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

                    surface.SetDrawColor(color)
                    surface.SetMaterial(Material("asterion/academy/ui/icons/combobox.png", "smooth"))
                    surface.DrawTexturedRectRotated(w - optionTitleFontHeight * 0.25, optionTitleFontHeight * 0.5, optionTitleFontHeight * 0.48, optionTitleFontHeight * 0.48, this.mOpenLerp * 180)

                    for i = 1, 25 do
                        surface.DrawRect((i - 1) * 7 + 4 * (i - 1), optionTitleFontHeight - 2 - 6, 7, 2)
                    end
                end
                dComboBox.DoClick = function(this)
                    optionPanel:DoClick()

                    this.bOpen = !this.bOpen
                end

                local dComboBoxReverse = optionPanel:Add("DButton")
                dComboBoxReverse:SetText("")
                dComboBoxReverse:SetSize(optionTitleFontHeight * 2.9, optionTitleFontHeight)
                dComboBoxReverse:SetPos(scrollPanel:GetWide() - 30 - dComboBoxReverse:GetWide(), optionTitleFontHeight)
                dComboBoxReverse.alpha = 0
                dComboBoxReverse.Paint = function(this, w, h)
                    this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 1 or 0)

                    local color = ColorAlpha(optionPanel.color, 35 + 225 * this.alpha)

                    draw.SimpleText(v.value and "ВЫКЛЮЧИТЬ" or "ВКЛЮЧИТЬ", "arb.Font_FuturaPTMedium_7", 0, optionTitleFontHeight / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                end
                dComboBoxReverse.DoClick = function()
                    dComboBox.bOpen = !dComboBox.bOpen

                    SETTINGS.options.Set(v.id, !v.value)
                    hook.Run("SETTINGS:OnOptionChange", v.id, !v.value)
                end

                local matReset = Material("asterion/academy/ui/icons/reset2.png", "smooth")
                local resetBtn = optionPanel:Add("DButton")
                resetBtn:SetText("")
                resetBtn:SetSize(optionTitleFontHeight, optionTitleFontHeight)
                resetBtn:SetPos(scrollPanel:GetWide() - 30 - dComboBoxReverse:GetWide() - resetBtn:GetWide(), 0)
                resetBtn.alpha = 0
                resetBtn.Paint = function(this, w, h)
                    this.alpha = Lerp(FrameTime() * 10, this.alpha, v.value != v.default and (this:IsHovered() and 1 or 0.35) or 0)

                    local size = h * 0.5

                    surface.SetDrawColor(informationColor.r, informationColor.g, informationColor.b, 255 * this.alpha)
                    surface.SetMaterial(matReset)
                    surface.DrawTexturedRect(w / 2 - size / 2, h / 2 - size / 2, size, size)
                end
                resetBtn.DoClick = function()
                    SETTINGS.options.Set(v.id, v.default)
                    hook.Run("SETTINGS:OnOptionChange", v.id, v.default)
                end
            elseif v.m_type == "number" then
                local dTitle = nil

                local sliderMat = Material("asterion/academy/ui/icons/slider.png", "smooth")
                local dSlider = optionPanel:Add("DButton")
                dSlider:SetText("")
                dSlider:Dock(RIGHT)
                dSlider:DockMargin(10, 0, 0, 0)
                dSlider:SetWide(optionTitleFontHeight * 4.1)
                dSlider:SetCursor("sizewe")
                dSlider.bDragging = false
                dSlider.value = v.value
                dSlider.Paint = function(this, w, h)
                    this.value = Lerp(FrameTime() * 10, this.value, v.value)

                    local color = ColorAlpha(optionPanel.color, 35 + 225 * optionPanel.alpha)

                    surface.SetDrawColor(color)
                    surface.DrawRect(0, h / 2, w, 2)

                    local sliderPos = (this.value - v.min) / (v.max - v.min)
                    local thumbX = math.Clamp(sliderPos * w, 7.5, w - 7.5)

                    surface.SetMaterial(sliderMat)
                    surface.DrawTexturedRect(thumbX - 7.5, h / 2 + 2, 15, 15)
                end
                dSlider.SetValue = function(this, newValue)
                    local oldValue = SETTINGS.options.Get(v.id)
                    local value = math.floor(math.Clamp(newValue, v.min, v.max))

                    if oldValue != value then
                        SETTINGS.options.Set(v.id, value)
                        hook.Run("SETTINGS:OnOptionChange", v.id, value)
                    end
                end
                dSlider.UpdateValueFromMouse = function(this)
                    local mouseX = this:ScreenToLocal(gui.MousePos())

                    local w = this:GetWide()

                    local normalizedValue = math.Clamp(mouseX / w, 0, 1)
                    local newValue = v.min + (normalizedValue * (v.max - v.min))

                    this:SetValue(newValue)
                end
                dSlider.OnMousePressed = function(this, mouseCode)
                    optionPanel:DoClick()

                    if mouseCode == MOUSE_LEFT then
                        this.isDragging = true
                        this:MouseCapture(true)
                        this:UpdateValueFromMouse()
                    end
                end
                dSlider.OnMouseReleased = function(this, mouseCode)
                    if mouseCode == MOUSE_LEFT then
                        this.isDragging = false
                        this:MouseCapture(false)
                    end
                end
                dSlider.Think = function(this)
                    if this.isDragging then
                        this:UpdateValueFromMouse()
                    end
                end

                dTitle = optionPanel:Add("DButton")
                dTitle:SetText("")
                dTitle:Dock(RIGHT)
                dTitle:SetWide(optionTitleFontHeight * 0.65)
                dTitle.Paint = function(_, w, h)
                    draw.SimpleText(v.value, "arb.Font_FuturaPTMedium_7", w, optionTitleFontHeight / 2, Color(255, 255, 255, 100 + 155 * optionPanel.alpha), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                end
                dTitle.DoClick = function()
                    optionPanel:DoClick()
                end

                local matReset = Material("asterion/academy/ui/icons/reset2.png", "smooth")
                local resetBtn = optionPanel:Add("DButton")
                resetBtn:SetText("")
                resetBtn:Dock(RIGHT)
                resetBtn:SetWide(optionTitleFontHeight)
                resetBtn.alpha = 0
                resetBtn.Paint = function(this, w, h)
                    this.alpha = Lerp(FrameTime() * 10, this.alpha, v.value != v.default and (this:IsHovered() and 1 or 0.35) or 0)

                    local size = h * 0.5

                    surface.SetDrawColor(informationColor.r, informationColor.g, informationColor.b, 255 * this.alpha)
                    surface.SetMaterial(matReset)
                    surface.DrawTexturedRect(w / 2 - size / 2, h / 2 - size / 2, size, size)
                end
                resetBtn.DoClick = function()
                    SETTINGS.options.Set(v.id, v.default)
                    hook.Run("SETTINGS:OnOptionChange", v.id, v.default)
                end
            end
        end
    end
end

function PANEL:CreateCategoryMenu()
    local mat = Material("asterion/academy/ui/icons/settings_ct.png", "smooth")

    local titleFont = "arb.Font_FuturaPTDemi_21"
    local titleFontHeight = draw.GetFontHeight(titleFont)

    local title = self:Add("Panel")
    title:SetTall(titleFontHeight * 2.14285714286)
    title:Dock(TOP)
    title:DockMargin(0, 0, 0, 0)
    title.Paint = function(_, w, h)
        local matColor = ColorAlpha(Arbitrage.theme:GetVisLogos(), 50)
        surface.SetDrawColor(matColor.r, matColor.g, matColor.b, 50)
        surface.SetMaterial(mat)
        surface.DrawTexturedRect(0, 0, h * 1.47058823529, h)

        local lineColor = Arbitrage.theme:GetVisForeground()
        surface.SetDrawColor(lineColor.r, lineColor.g, lineColor.b, 255)
        surface.DrawRect(0, h - 1, w, 1)

        draw.SimpleText("НАСТРОЙКИ", titleFont, titleFontHeight * 1.26984126984, h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    local buttonFont = "arb.Font_FuturaPTMedium_9"
    local buttonFontHeight = draw.GetFontHeight(buttonFont)
    local pageFont = "arb.Font_FuturaPTMedium_9"

    local contentButton = title:Add("DButton")
    contentButton:SetText("")
    contentButton:Dock(RIGHT)
    contentButton:DockMargin(30, 0, self.paddingRight, 0)
    contentButton:SetWide(buttonFontHeight * 4.5)
    contentButton.id = "content"
    contentButton.alpha = 0
    contentButton.color = Arbitrage.theme:GetTextPrimary()
    contentButton.Paint = function(this, w, h)
        local bSelected = self.selectID == this.id

        this.color = LerpColor(FrameTime() * 10, this.color, (this:IsHovered() or bSelected) and Arbitrage.theme:GetTextTitle() or Arbitrage.theme:GetTextPrimary())
        this.alpha = Lerp(FrameTime() * 10, this.alpha, (this:IsHovered() or bSelected) and 1 or 0)

        local _, height = draw.SimpleText("КОНТЕНТ", pageFont, w / 2, h / 2, this.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if this.alpha > 0.05 then
            Arbitrage.DrawGradient(GRADIENT_RIGHT, 0, h / 2 - 2 + 10 + height * 0.5, w / 2, 2, ColorAlpha(this.color, this.alpha * 255))
            Arbitrage.DrawGradient(GRADIENT_LEFT, w / 2, h / 2 - 2 + 10 + height * 0.5, w / 2, 2, ColorAlpha(this.color, this.alpha * 255))
        end
    end
    contentButton.DoClick = function()
        self:RebuildMainFrame(self.ContentMenu)
    end

    local bindsButton = title:Add("DButton")
    bindsButton:SetText("")
    bindsButton:Dock(RIGHT)
    bindsButton:DockMargin(30, 0, 0, 0)
    bindsButton:SetWide(buttonFontHeight * 5.8)
    bindsButton.id = "binds"
    bindsButton.alpha = 0
    bindsButton.color = Arbitrage.theme:GetTextPrimary()
    bindsButton.Paint = function(this, w, h)
        local bSelected = self.selectID == this.id

        this.color = LerpColor(FrameTime() * 10, this.color, (this:IsHovered() or bSelected) and Arbitrage.theme:GetTextTitle() or Arbitrage.theme:GetTextPrimary())
        this.alpha = Lerp(FrameTime() * 10, this.alpha, (this:IsHovered() or bSelected) and 1 or 0)

        local _, height = draw.SimpleText("УПРАВЛЕНИЕ", pageFont, w / 2, h / 2, this.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if this.alpha > 0.05 then
            Arbitrage.DrawGradient(GRADIENT_RIGHT, 0, h / 2 - 2 + 10 + height * 0.5, w / 2, 2, ColorAlpha(this.color, this.alpha * 255))
            Arbitrage.DrawGradient(GRADIENT_LEFT, w / 2, h / 2 - 2 + 10 + height * 0.5, w / 2, 2, ColorAlpha(this.color, this.alpha * 255))
        end
    end
    bindsButton.DoClick = function()
        self:RebuildMainFrame(self.BindsMenu)
    end

    local optionsButton = title:Add("DButton")
    optionsButton:SetText("")
    optionsButton:Dock(RIGHT)
    optionsButton:DockMargin(0, 0, 0, 0)
    optionsButton:SetWide(buttonFontHeight * 8.3)
    optionsButton.id = "options"
    optionsButton.alpha = 0
    optionsButton.color = Arbitrage.theme:GetTextPrimary()
    optionsButton.Paint = function(this, w, h)
        local bSelected = self.selectID == this.id

        this.color = LerpColor(FrameTime() * 10, this.color, (this:IsHovered() or bSelected) and Arbitrage.theme:GetTextTitle() or Arbitrage.theme:GetTextPrimary())
        this.alpha = Lerp(FrameTime() * 10, this.alpha, (this:IsHovered() or bSelected) and 1 or 0)

        local _, height = draw.SimpleText("ИГРОВОЙ ПРОЦЕСС", pageFont, w / 2, h / 2, this.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if this.alpha > 0.05 then
            Arbitrage.DrawGradient(GRADIENT_RIGHT, 0, h / 2 - 2 + 10 + height * 0.5, w / 2, 2, ColorAlpha(this.color, this.alpha * 255))
            Arbitrage.DrawGradient(GRADIENT_LEFT, w / 2, h / 2 - 2 + 10 + height * 0.5, w / 2, 2, ColorAlpha(this.color, this.alpha * 255))
        end
    end
    optionsButton.DoClick = function()
        self:RebuildMainFrame(self.OptionsMenu)
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

vgui.Register("arb.mainmenu:Settings", PANEL, "Panel")