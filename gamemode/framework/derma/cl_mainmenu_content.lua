local PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetAlpha(0)

    self.paddingLeft = 100
    self.paddingTop = 72
    self.percent = 0
    self.percentTo = 0

    -- self.countAddons = 0
    -- self.addonMax = 0
    self.addonName = ""
    self.loadingText = ""

    local material_logo = Material("asterion/academy/ui/bg_logo.png", "smooth")
    local wide_logo = ScrH() * 0.27777777777
    self.logo = self:Add("DPanel")
    self.logo:Dock(TOP)
    self.logo:DockMargin(self.paddingLeft, self.paddingTop, 0, 0)
    self.logo:SetTall(ScrH() * 0.0787037037)
    self.logo.Paint = function(_, w, h)
        local color = Arbitrage.theme:GetVisLogos()

        surface.SetDrawColor(color.r, color.g, color.b, 255)
        surface.SetMaterial(material_logo)
        surface.DrawTexturedRect(0, 0, wide_logo, h)
    end

    timer.Simple(3, function()
        if !IsValid(self) then return end

        self:AlphaTo(255, 1)
        self:WaitingLoadingAddons()
    end)
end

function PANEL:WaitingLoadingAddons()
    local startTime = RealTime() + 20

    local data = {}
    for id in pairs(asterionlib.workshop.list) do
        data[#data + 1] = id
    end

    local countAddons = #data

    self.checkTime = RealTime()
    self.Think = function()
        if RealTime() <= self.checkTime then return end

        if RealTime() > startTime then
            self.Think = nil
            self:CheckContent()

            return
        end

        local id = data[1]
        if id then
            local addon = asterionlib.workshop.list[id]
            if addon then
                self.addonName = (addon.stored and addon.stored.title or ""):gsub("\n", ""):gsub("\t", ""):Trim()
                self.loadingText = (countAddons - #data + 1) .. "/" .. countAddons

                local s_m = countAddons - #data + 1
                local s_tm = countAddons
                local s_m_interest = math.floor(100 / (s_tm / s_m))
                self.percentTo = s_m_interest / 100

                if addon.bLoading and !addon.bDownloading then
                    table.remove(data, 1)
                end
            else
                table.remove(data, 1)
            end
        else
            self.Think = nil
            self:CheckContent()
        end

        self.checkTime = RealTime() + 0.01
    end
end

function PANEL:CheckContent()
    self.percentTo = 0
    self.addonName = ""
    self.loadingText = ""

    local startTime = RealTime() + 20
    local errors = {}
    local data = {}
    for id, info in pairs(asterionlib.workshop.stored) do
        if info.onCheck and asterionlib.workshop.list[id] then
            data[#data + 1] = id
        end
    end

    local countAddons = #data

    self.checkTime = RealTime()
    self.Think = function()
        if RealTime() <= self.checkTime then return end

        if RealTime() > startTime then
            self.Think = nil
            self:ShowErrors(errors)

            return
        end

        local id = data[1]
        if id then
            local addon = asterionlib.workshop.stored[id]
            if addon then
                self.addonName = (asterionlib.workshop.list[id].stored.title):gsub("\n", ""):gsub("\t", ""):Trim()

                local s_m = countAddons - #data + 1
                local s_tm = countAddons
                local s_m_interest = math.floor(100 / (s_tm / s_m))
                self.percentTo = s_m_interest / 100

                self.loadingText = ("%s //: %s"):format(math.floor(self.percent * 100) .. "%", self.addonName)

                local bAllow = asterionlib.workshop.stored[id].onCheck()
                if !bAllow then
                    errors[#errors + 1] = id
                end

                table.remove(data, 1)
            else
                table.remove(data, 1)
            end
        else
            self.Think = nil
            self:ShowErrors(errors)
        end

        self.checkTime = RealTime() + math.random() / 5 + 0.25
    end
end

function PANEL:ShowErrors(errors, bFirstIgnore)
    if !bFirstIgnore then
        local number = asterionlib.data:Get("connections", 0, true)

        if number <= 1 then
            return self:NotifyMenu(
                "ВНИМАНИЕ",
                "Мы заметили, что вы заходите на сервер в первый раз. Во избежание\nпроблем с контентом и его корректной работы, мы рекомендуем\nперезайти на сервер. При игнорировании, проблемы будут\nустранены после следующего захода на сервер",
                "ПЕРЕЗАЙТИ", function()
                    RunConsoleCommand("retry")
                end,
                "ПРОДОЛЖИТЬ ИГРУ", function(panel)
                    panel:AlphaTo(0, 0.5, 0, function()
                        panel:Remove()

                        self:ShowErrors(errors, true)
                    end)
                end
            )
        end
    end

    if #errors > 0 then
        self:ErrorMenu(errors)
    else
        self:AlphaTo(0, 1, 0, function()
            self:Remove()

            local primaryMenu = Arbitrage.menu:Add("arb.mainmenu:MenuPrimary")
            primaryMenu:Dock(FILL)
        end)
    end
end

function PANEL:ErrorMenu(errors)
    local panel = self:Add("DPanel")
    panel:SetPos(0, 0)
    panel:SetSize(ScrW(), ScrH())
    panel:SetAlpha(0)
    panel:AlphaTo(255, 1)
    panel.Paint = function(this, w, h)
        asterionlib.DrawBlur(this, 15, nil, panel:GetAlpha())

        surface.SetDrawColor(0, 0, 0, 180)
        surface.DrawRect(0, 0, w, h)
    end

    local titleFont = "arb.Font_FuturaPTDemi_16"
    local titleFontHeight = draw.GetFontHeight(titleFont)
    local descriptionFont = "arb.Font_FuturaPTBook_9"
    local descriptionFontHeight = draw.GetFontHeight(descriptionFont)
    local buttonFont = "arb.Font_FuturaPTDemi_14"
    local buttonFontHeight = draw.GetFontHeight(buttonFont)
    local rectHeigth = titleFontHeight * 0.61

    local topPanel = panel:Add("DPanel")
    topPanel:SetTall(titleFontHeight + 10 + descriptionFontHeight)
    topPanel:Dock(TOP)
    topPanel:DockMargin(0, 120, 0, 0)
    topPanel.Paint = function(_, w, h)
        local informationColor = Arbitrage.theme:GetInformation()

        surface.SetDrawColor(informationColor.r, informationColor.g, informationColor.b)
        surface.DrawRect(0, titleFontHeight - rectHeigth * 1.25, 330, rectHeigth)

        draw.SimpleText("РЕКОМЕНДАЦИИ", titleFont, 350, 0, informationColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText("Были обнаружены проблемы с контентом сервера. Пожалуйста, установите данные дополнения:", descriptionFont, 150, titleFontHeight + 10, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    local fillPanel = panel:Add("Panel")
    fillPanel:Dock(FILL)
    fillPanel:DockMargin(0, 70, 0, 70)

    local scrollPanel = fillPanel:Add("DHorizontalScroller")
    scrollPanel:SetAlpha(0)
    scrollPanel:Dock(FILL)
    scrollPanel:DockMargin(100, 0, 100, 0)
    scrollPanel:SetOverlap(-70)
    scrollPanel.btnLeft.Paint = function()
    end
    scrollPanel.btnRight.Paint = function()
    end
    scrollPanel.Paint = function(this, w, h)
        local informationColor = Arbitrage.theme:GetInformation()

        surface.SetDrawColor(255, 255, 255, 3)
        surface.DrawRect(0, h - 4, w, 4)

        local s_m = this.OffsetX
        local s_tm = this.pnlCanvas:GetWide() - this:GetWide() + (100 * 2)
        local s_m_interest = math.floor(100 / (s_tm / s_m)) / 100

        surface.SetDrawColor(informationColor.r, informationColor.g, informationColor.b)
        surface.DrawRect(w * s_m_interest, h - 4, 100, 4)
    end

    -- perform layout
    timer.Simple(0.5, function()
        scrollPanel:AlphaTo(255, 0.5)

        local itemSize = scrollPanel:GetTall() * 0.67
        local iconSize = itemSize * 0.16

        local errorMat = Material("danganronpa/ui/info_5.png", "smooth")
        local successMat = Material("danganronpa/ui/info_7.png", "smooth")

        for _, id in ipairs(errors) do
            local name = "undefined"
            local image = nil
            local addon = asterionlib.workshop.list[id]
            local bIsOptional = asterionlib.workshop.stored[id].bOptional

            if addon then
                name = addon.name

                asterionlib.downloader:Image(addon.image, function(matPath)
                    image = matPath
                end)
            end

            local itemPanel = scrollPanel:Add("DButton")
            itemPanel:SetText("")
            itemPanel:SetWide(itemSize)
            itemPanel:SetTall(scrollPanel:GetTall())
            itemPanel.alpha = 0.4
            itemPanel.Paint = function(this, w, h)
                local informationColor = Arbitrage.theme:GetInformation()

                this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 1 or 0.4)

                if image then
                    surface.SetDrawColor(255, 255, 255, 255 * this.alpha)
                    surface.SetMaterial(image)
                    surface.DrawTexturedRect(0, 0, w, w)
                end

                surface.SetDrawColor(informationColor.r, informationColor.g, informationColor.b)
                surface.DrawOutlinedRect(0, 0, w, w, 2)

                local isSub = steamworks.IsSubscribed(id)
                surface.SetDrawColor(255, 255, 255)
                surface.SetMaterial(isSub and successMat or errorMat)
                surface.DrawTexturedRect(w - iconSize, 0, iconSize, iconSize)

                local height = w + 15
                if bIsOptional then
                    height = height + select(2, draw.SimpleText(L("#content_optional"), "arb.Font_FuturaPTBook_6", w / 2, height, Color(255, 166, 0, 255 * this.alpha), TEXT_ALIGN_CENTER))
                end

                draw.SimpleText(name, "arb.Font_FuturaPTBook_8", w / 2, height, Color(255, 255, 255, 255 * this.alpha), TEXT_ALIGN_CENTER)
            end
            itemPanel.DoClick = function()
                steamworks.ViewFile(id)
            end
            itemPanel.DoRightClick = function()
                steamworks.ViewFile(id)
            end

            scrollPanel:AddPanel(itemPanel)
        end
    end)

    local buttonsPanel = fillPanel:Add("Panel")
    buttonsPanel:SetTall(buttonFontHeight + 10)
    buttonsPanel:Dock(BOTTOM)
    buttonsPanel:DockMargin(0, 80, 0, 0)

    local sizeButton = buttonFontHeight * 7

    local retryButton = buttonsPanel:Add("DButton")
    retryButton:SetText("")
    retryButton:SetWide(sizeButton)
    retryButton:Dock(LEFT)
    retryButton:DockMargin(self:GetWide() * 0.5 - sizeButton - 20, 0, 40, 0)
    retryButton.alpha = 0.2
    retryButton.Paint = function(this, w, h)
        local informationColor = Arbitrage.theme:GetInformation()

        this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 1 or 0.2)

        surface.SetDrawColor(informationColor.r, informationColor.g, informationColor.b, 255 * this.alpha)
        surface.DrawRect(0, 0, w, h)

        draw.SimpleText("ПЕРЕЗАЙТИ НА СЕРВЕР", "arb.Font_FuturaPTDemi_10", w / 2, h / 2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    retryButton.DoClick = function()
        RunConsoleCommand("retry")
    end

    local continueButton = buttonsPanel:Add("DButton")
    continueButton:SetText("")
    continueButton:SetWide(sizeButton)
    continueButton:Dock(LEFT)
    continueButton.alpha = 0.2
    continueButton.Paint = function(this, w, h)
        local informationColor = Arbitrage.theme:GetInformation()

        this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 1 or 0.2)

        surface.SetDrawColor(informationColor.r, informationColor.g, informationColor.b, 255 * this.alpha)
        surface.DrawRect(0, 0, w, h)

        draw.SimpleText("ПРОДОЛЖИТЬ ИГРУ", "arb.Font_FuturaPTDemi_10", w / 2, h / 2, Color(0, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    continueButton.DoClick = function()
        local countNoSubscribe = 0
        local countAddons = 0
        for _, id in ipairs(errors) do
            local bIsOptional = asterionlib.workshop.stored[id].bOptional

            if !bIsOptional then
                if !steamworks.IsSubscribed(id) then
                    countNoSubscribe = countNoSubscribe + 1
                end

                countAddons = countAddons + 1
            end
        end

        if countAddons <= 0 then
            self:AlphaTo(0, 0.5, 0, function()
                self:Remove()
            end)

            self:AlphaTo(0, 0.25, 0, function()
                self:Remove()

                local primaryMenu = Arbitrage.menu:Add("arb.mainmenu:MenuPrimary")
                primaryMenu:Dock(FILL)
            end)

            return
        end

        if countNoSubscribe <= 0 then
            return self:NotifyMenu(
                "ПРЕДУПРЕЖДЕНИЕ",
                "Вам необходимо перезайти в игру, чтобы дополнения на которые вы подписали\nначали работать стабильно!",
                "ПЕРЕЗАЙТИ В ИГРУ",
                function(pPanel)
                    os.date("%l")
                end,
                "ПРОДОЛЖИТЬ ИГРУ",
                function(pPanel)
                    pPanel:AlphaTo(0, 0.25, 0, function()
                        pPanel:Remove()

                        self:AlphaTo(0, 0.25, 0, function()
                            self:Remove()

                            local primaryMenu = Arbitrage.menu:Add("arb.mainmenu:MenuPrimary")
                            primaryMenu:Dock(FILL)
                        end)
                    end)
                end
            )
        else
            return self:NotifyMenu(
                "ПРЕДУПРЕЖДЕНИЕ",
                "Вы подписались не на все дополнения с которыми возникли проблемы.\nЕсли вы продолжите игру, то можете столкнуться с проблемами внутри клиента!",
                "НАЗАД", function(pPanel)
                    pPanel:AlphaTo(0, 0.5, 0, function()
                        pPanel:Remove()
                    end)
                end,
                "ПРОДОЛЖИТЬ ИГРУ", function(pPanel)
                    pPanel:AlphaTo(0, 0.25, 0, function()
                        pPanel:Remove()

                        self:AlphaTo(0, 0.25, 0, function()
                            self:Remove()

                            local primaryMenu = Arbitrage.menu:Add("arb.mainmenu:MenuPrimary")
                            primaryMenu:Dock(FILL)
                        end)
                    end)
                end
            )
        end
    end

    local bottomPanel = panel:Add("DPanel")
    bottomPanel:SetTall(titleFontHeight + 20 + descriptionFontHeight + descriptionFontHeight)
    bottomPanel:Dock(BOTTOM)
    bottomPanel:DockMargin(0, 0, 0, 120)
    bottomPanel.Paint = function(_, w, h)
        local informationColor = Arbitrage.theme:GetInformation()
        local width = draw.SimpleText("ДОПОЛНИТЕЛЬНО", titleFont, w - w * 0.5, 0, informationColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

        surface.SetDrawColor(informationColor.r, informationColor.g, informationColor.b)
        surface.DrawRect(w - w * 0.5 + 20 + width, titleFontHeight - rectHeigth * 1.25, w, rectHeigth)

        draw.DrawText("Если ошибка не решилась, то рекомендуем обратиться к администрации\nпроекта Asterion Academy. Сделать это можно в соц. сетях:", descriptionFont, w - w * 0.5, titleFontHeight + 20, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    local vkButton = bottomPanel:Add("DButton")
    vkButton:SetText("")
    vkButton:SetPos(self:GetWide() - descriptionFontHeight * 1.8519 - 80, titleFontHeight + 20 + descriptionFontHeight * 0.25)
    vkButton:SetSize(descriptionFontHeight * 1.8519, descriptionFontHeight * 1.8519)
    vkButton.alpha = 0.2
    vkButton.Paint = function(this, w, h)
        local informationColor = Arbitrage.theme:GetInformation()
        this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 1 or 0.2)

        surface.SetDrawColor(informationColor.r, informationColor.g, informationColor.b, 255 * this.alpha)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(0, 0, 0)
        surface.SetMaterial(Material("asterion/academy/ui/icons/vk.png", "smooth"))
        surface.DrawTexturedRect(0, 0, w, h)
    end
    vkButton.DoClick = function()
        gui.OpenURL("https://vk.com/asterionacademy")
    end

    local discordButton = bottomPanel:Add("DButton")
    discordButton:SetText("")
    discordButton:SetPos(self:GetWide() - descriptionFontHeight * 1.8519 - 80 - 20 - descriptionFontHeight * 1.8519, titleFontHeight + 20 + descriptionFontHeight * 0.25)
    discordButton:SetSize(descriptionFontHeight * 1.8519, descriptionFontHeight * 1.8519)
    discordButton.alpha = 0.2
    discordButton.Paint = function(this, w, h)
        local informationColor = Arbitrage.theme:GetInformation()

        this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 1 or 0.2)

        surface.SetDrawColor(informationColor.r, informationColor.g, informationColor.b, 255 * this.alpha)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(0, 0, 0)
        surface.SetMaterial(Material("asterion/academy/ui/icons/discord.png", "smooth"))
        surface.DrawTexturedRect(0, 0, w, h)
    end
    discordButton.DoClick = function()
        gui.OpenURL("https://asterion.games/academy")
    end
end

function PANEL:NotifyMenu(title, description, buttonPrimaryText, buttonPrimaryCallback, buttonSecondaryText, buttonSecondaryCallback)
    local panel = self:Add("DPanel")
    panel:SetPos(0, 0)
    panel:SetSize(ScrW(), ScrH())
    panel:SetAlpha(0)
    panel:AlphaTo(255, 1)
    panel.Paint = function(this, w, h)
        asterionlib.DrawBlur(this, 15, nil, panel:GetAlpha())

        surface.SetDrawColor(0, 0, 0, 180)
        surface.DrawRect(0, 0, w, h)
    end

    local titleFont = "arb.Font_FuturaPTDemi_18"
    local descFont = "arb.Font_FuturaPTBook_10"
    local buttonFont = "arb.Font_FuturaPTDemi_14"
    local buttonFontHeight = draw.GetFontHeight(buttonFont)

    local sizeButton = buttonFontHeight * 7

    local titlePanel = panel:Add("DLabel")
    titlePanel:Dock(TOP)
    titlePanel:DockMargin(0, self:GetTall() * 0.4, 0, 40)
    titlePanel:SetContentAlignment(5)
    titlePanel:SetTextColor(Arbitrage.theme:GetTextAttention())
    titlePanel:SetText(title)
    titlePanel:SetFont(titleFont)
    titlePanel:SizeToContents()
    titlePanel.Paint = function(_, w, h)
        local color = Arbitrage.theme:GetVisSelectionLine()

        surface.SetDrawColor(color.r, color.g, color.b)
        surface.DrawRect(0, 0, w, h)
    end

    local descPanel = panel:Add("DLabel")
    descPanel:Dock(TOP)
    descPanel:DockMargin(0, 0, 0, 60)
    descPanel:SetText(description)
    descPanel:SetTextColor(Arbitrage.theme:GetTextPrimary())
    descPanel:SetFont(descFont)
    descPanel:SetContentAlignment(5)
    descPanel:SizeToContents()
    descPanel.Paint = function(_, w, h)
        descPanel:SetText("") -- это пиздец, ебучий SetContentAlignment не центрирует текст

        draw.DrawText(description, descFont, w / 2, 0, Arbitrage.theme:GetTextPrimary(), TEXT_ALIGN_CENTER)
    end

    local buttonsPanel = panel:Add("Panel")
    buttonsPanel:Dock(TOP)
    buttonsPanel:SetTall(buttonFontHeight + 10)

    local buttonPrimary = buttonsPanel:Add("DButton")
    buttonPrimary:SetText("")
    buttonPrimary:SetWide(sizeButton)
    buttonPrimary:Dock(LEFT)
    buttonPrimary:DockMargin(self:GetWide() / 2 - (buttonPrimary:GetWide() + 25), 0, 50, 0)
    buttonPrimary.outlinecolor = Arbitrage.theme:GetVisButtonUnselected()
    buttonPrimary.textcolor = Arbitrage.theme:GetTextUnSelected()
    buttonPrimary.Paint = function(this, w, h)
        this.outlinecolor = LerpColor(FrameTime() * 10, this.outlinecolor, this:IsHovered() and Arbitrage.theme:GetVisButtonSelected() or Arbitrage.theme:GetVisButtonUnselected())
        this.textcolor = LerpColor(FrameTime() * 10, this.textcolor, this:IsHovered() and Arbitrage.theme:GetTextSelected() or Arbitrage.theme:GetTextUnSelected())

        local backgroundColor = Arbitrage.theme:GetVisButtonBackground()
        surface.SetDrawColor(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a)
        surface.DrawRect(0, 0, w, h)

        local selectedColor = this.outlinecolor
        surface.SetDrawColor(selectedColor.r, selectedColor.g, selectedColor.b, selectedColor.a)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        draw.SimpleText(buttonPrimaryText, "arb.Font_FuturaPTDemi_10", w / 2, h / 2, this.textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    buttonPrimary.DoClick = function()
        buttonPrimaryCallback(panel)
    end

    local buttonSecondary = buttonsPanel:Add("DButton")
    buttonSecondary:SetText("")
    buttonSecondary:SetWide(sizeButton)
    buttonSecondary:Dock(LEFT)
    buttonSecondary.outlinecolor = Arbitrage.theme:GetVisButtonUnselected()
    buttonSecondary.textcolor = Arbitrage.theme:GetTextUnSelected()
    buttonSecondary.Paint = function(this, w, h)
        this.outlinecolor = LerpColor(FrameTime() * 10, this.outlinecolor, this:IsHovered() and Arbitrage.theme:GetVisButtonSelected() or Arbitrage.theme:GetVisButtonUnselected())
        this.textcolor = LerpColor(FrameTime() * 10, this.textcolor, this:IsHovered() and Arbitrage.theme:GetTextSelected() or Arbitrage.theme:GetTextUnSelected())

        local backgroundColor = Arbitrage.theme:GetVisButtonBackground()
        surface.SetDrawColor(backgroundColor.r, backgroundColor.g, backgroundColor.b, backgroundColor.a)
        surface.DrawRect(0, 0, w, h)

        local selectedColor = this.outlinecolor
        surface.SetDrawColor(selectedColor.r, selectedColor.g, selectedColor.b, selectedColor.a)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        draw.SimpleText(buttonSecondaryText, "arb.Font_FuturaPTDemi_10", w / 2, h / 2, this.textcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    buttonSecondary.DoClick = function()
        buttonSecondaryCallback(panel)
    end
end

local loading_mat = Material("asterion/academy/ui/icons/loading.png", "smooth")
function PANEL:Paint(w, h)
    local ft = FrameTime()

    self.percent = Lerp(ft * 10, self.percent, self.percentTo)

    local linebgColor = Arbitrage.theme:GetVisBackground()
    surface.SetDrawColor(linebgColor.r, linebgColor.g, linebgColor.b, linebgColor.a)
    surface.DrawRect(self.paddingLeft, h - self.paddingLeft - 4, w - self.paddingLeft * 2, 5 + 8)

    local lineColor = Arbitrage.theme:GetVisForeground()
    surface.SetDrawColor(lineColor.r, lineColor.g, lineColor.b, lineColor.a)
    surface.DrawRect(self.paddingLeft + 4, h - self.paddingLeft, (w - self.paddingLeft * 2) * self.percent - 8, 5)

    local _, height = draw.SimpleText(self.loadingText, "arb.Font_FuturaPTBook_11", self.paddingLeft, h - self.paddingLeft - 4 - 10, Arbitrage.theme:GetTextCategory(), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    draw.SimpleText("В данный момент загружается контент сервера, пожалуйста подождите...", "arb.Font_FuturaPTBook_8", self.paddingLeft, h - self.paddingLeft - 4 + 5 + 8 + 10, Arbitrage.theme:GetTextPrimary(), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

    local loadingColor = Arbitrage.theme:GetVisLogos()
    surface.SetDrawColor(loadingColor.r, loadingColor.g, loadingColor.b, loadingColor.a)
    surface.SetMaterial(loading_mat)
    surface.DrawTexturedRectRotated(self.paddingLeft + w - self.paddingLeft * 2 - height / 2, h - self.paddingLeft - 4 - height / 2 - 10, height, height, (SysTime() * 100) % 360)
end

vgui.Register("arb.mainmenu:Content", PANEL, "Panel")