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


local PANEL = {}

function PANEL:Init()
    local parent = self:GetParent()

    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self:SetSize(ScrW(), ScrH())

    local logo = parent.logo
    if IsValid(logo) then
        logo:SetAlpha(0)
    end

    timer.Simple(3, function()
        if !IsValid(self) then return end

        self:WaitingLoadingAddons()
    end)
end

local logoMat = Material("asterion/academy/ui/logo.png")
function PANEL:WaitingLoadingAddons()
    local startTime = RealTime() + 20

    local data = {}
    for id in pairs(asterionlib.workshop.list) do
        data[#data + 1] = id
    end

    local countAddons = #data

    local idAddon = ""
    local nameAddon = ""

    local r, x, y = self:GetTall() * 0.15, self:GetWide() / 2, self:GetTall() * 0.6

    local background = asterionlib.Circles.New(CIRCLE_FILLED, r, x, y, 15)
    background:SetMaterial(true)
    background:SetColor(Color(0, 0, 0, 220))

    local outlined = asterionlib.Circles.New(CIRCLE_OUTLINED, r, x, y, 15)
    outlined:SetMaterial(true)
    outlined:SetColor(color_white)
    outlined:SetEndAngle(0)

    local value = 0
    local panel = self:Add("DPanel")
    panel:SetAlpha(0)
    panel:AlphaTo(255, 1)
    panel:Dock(FILL)
    panel.Paint = function(_, w, h)
        background()

        local s_m = countAddons - #data
        local s_tm = countAddons
        local s_m_interest = math.floor(100 / (s_tm / s_m))

        local maxValue = s_m_interest * 36 / 10
        value = Lerp(FrameTime() * 10, value, maxValue)

        outlined:SetEndAngle(value)
        outlined()

        local _, heigth = draw.SimpleText("ЗАГРУЗКА: " .. (countAddons - #data) .. "/" .. countAddons .. " (" .. s_m_interest .. "%)", "arb.Font_FuturaPTDemi_15", w / 2, y + r + 20, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText(nameAddon .. " (" .. idAddon .. ")", "arb.Font_FuturaPTBook_8", w / 2, y + r + heigth + 20, Color(78, 77, 77), TEXT_ALIGN_CENTER)

        local size = self:GetTall() * 0.0011
        local sizeW, sizeH = 405 * size, 110 * size

        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(logoMat)
        surface.DrawTexturedRect(x - sizeW / 2, y - r - sizeH - 105, sizeW, sizeH)
    end
    panel.checkTime = RealTime()
    panel.Think = function(this)
        if RealTime() <= this.checkTime then return end

        if RealTime() > startTime then
            panel:AlphaTo(0, 1, 0, function()
                panel:Remove()

                self:CheckContent()
            end)

            panel.Think = nil

            return
        end

        local id = data[1]
        if id then
            local addon = asterionlib.workshop.list[id]
            if addon then
                idAddon = id
                nameAddon = addon.stored and addon.stored.title or ""

                if addon.bLoading and !addon.bDownloading then
                    table.remove(data, 1)
                end
            else
                table.remove(data, 1)
            end
        else
            panel:AlphaTo(0, 1, 0, function()
                panel:Remove()

                self:CheckContent()
            end)

            panel.Think = nil
        end

        this.checkTime = RealTime() + 0.01
    end
end

local fontWelcome = "arb.Font_FuturaPTDemi_20"
local fontWelcomeHeight = draw.GetFontHeight(fontWelcome)

local fontDescription = "arb.Font_FuturaPTBook_12"
function PANEL:CheckContent()
    local startTime = RealTime() + 20

    local idAddon = ""
    local nameAddon = ""

    local errors = {}
    local data = {}
    for id, info in pairs(asterionlib.workshop.stored) do
        if info.onCheck and asterionlib.workshop.list[id] then
            data[#data + 1] = id
        end
    end
    local countAddons = #data

    local r, x, y = self:GetTall() * 0.2, self:GetWide() * 0.7, self:GetTall() / 2

    local background = asterionlib.Circles.New(CIRCLE_FILLED, r, x, y, 15)
    background:SetMaterial(true)
    background:SetColor(Color(0, 0, 0, 220))

    local outlined = asterionlib.Circles.New(CIRCLE_OUTLINED, r, x, y, 15)
    outlined:SetMaterial(true)
    outlined:SetColor(color_white)
    outlined:SetEndAngle(0)

    local color_circle = Color(255, 0, 0)
    local value = 0
    local panel = self:Add("DPanel")
    panel:SetAlpha(0)
    panel:AlphaTo(255, 1)
    panel:Dock(FILL)
    panel.Paint = function(_, w, h)
        local ft = FrameTime()

        local s_m = countAddons - #data
        local s_tm = countAddons
        local s_m_interest = math.floor(100 / (s_tm / s_m))

        local maxValue = s_m_interest * 36 / 10
        value = Lerp(ft * 10, value, maxValue)

        if value > 280 then
            color_circle = LerpColor(ft * 3, color_circle, Color(7, 190, 21))
        elseif value > 125 then
            color_circle = LerpColor(ft * 3, color_circle, Color(251, 169, 14))
        end

        background()

        outlined:SetMaterial(true)
        outlined:SetColor(color_circle)
        outlined:SetEndAngle(value)
        outlined()

        draw.DrawText("Сейчас происходит проверка игрового\nконтента на наличие ошибок,\nпожалуйста подождите завершение\nпроцесса.", fontDescription, 150, h / 2, color_white, TEXT_ALIGN_LEFT)
        draw.SimpleText("Добро пожаловать!", fontWelcome, 150, h / 2 - fontWelcomeHeight - 33, color_white, TEXT_ALIGN_LEFT)

        local _, heigth = draw.SimpleText("Проверено элементов: " .. (countAddons - #data) .. "/" .. countAddons .. " (" .. s_m_interest .. "%)", "arb.Font_FuturaPTDemi_13", x, y + r + 60, color_white, TEXT_ALIGN_CENTER)
        draw.SimpleText(nameAddon .. " (" .. idAddon .. ")", "arb.Font_FuturaPTBook_7", x, y + r + heigth + 60, Color(78, 77, 77), TEXT_ALIGN_CENTER)

        local size = self:GetTall() * 0.0011
        local sizeW, sizeH = 405 * size, 110 * size

        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(logoMat)
        surface.DrawTexturedRect(150, 130, sizeW, sizeH)
    end
    panel.checkTime = RealTime()
    panel.Think = function(this)
        if RealTime() <= this.checkTime then return end

        if RealTime() > startTime then
            panel:AlphaTo(0, 1, 0, function()
                panel:Remove()

                self:ShowErrors(errors)
            end)

            panel.Think = nil

            return
        end

        local id = data[1]
        if id then
            local addon = asterionlib.workshop.stored[id]
            if addon then
                idAddon = id
                nameAddon = asterionlib.workshop.list[id].stored.title

                local bAllow = asterionlib.workshop.stored[id].onCheck()
                if !bAllow then
                    errors[#errors + 1] = id
                end

                table.remove(data, 1)
            else
                table.remove(data, 1)
            end
        else
            panel:AlphaTo(0, 1, 0, function()
                panel:Remove()

                self:ShowErrors(errors)
            end)

            panel.Think = nil
        end

        this.checkTime = RealTime() + math.random() / 5 + 0.25
    end


    local playerPanel = panel:Add("Panel")
    playerPanel:SetTall(H(64))
    playerPanel:Dock(BOTTOM)
    playerPanel:DockMargin(150, 0, 0, 130)

    local playerAvatar = playerPanel:Add("AvatarImage")
    playerAvatar:Dock(LEFT)
    playerAvatar:DockMargin(0, 0, 20, 0)
    playerAvatar:SetWide(playerPanel:GetTall())
    playerAvatar:SetPlayer(LocalPlayer(), 64)
    playerAvatar.PaintOver = function(_, w, h)
        surface.SetDrawColor(193, 0, 0)
        surface.DrawOutlinedRect(0, 0, w, h, 2)
    end

    local titlePanel = playerPanel:Add("DLabel")
    titlePanel:Dock(TOP)
    titlePanel:SetText("Профиль: " .. LocalPlayer():SteamName())
    titlePanel:SetFont("arb.Font_FuturaPTDemi_11")
    titlePanel:SizeToContents()

    local descPanel = playerPanel:Add("DLabel")
    descPanel:Dock(TOP)
    descPanel:SetText("Вы находитесь на Asterion Academy!")
    descPanel:SetTextColor(Color(95, 95, 95))
    descPanel:SetFont("arb.Font_FuturaPTBook_8")
    descPanel:SizeToContents()
end

function PANEL:NotifyMenu(title, description, buttonPrimaryText, buttonPrimaryCallback, buttonSecondaryText, buttonSecondaryCallback)
    local panel = self:Add("DPanel")
    panel:SetAlpha(0)
    panel:AlphaTo(255, 1)
    panel:Dock(FILL)
    panel.Paint = function(this, w, h)
        asterionlib.DrawBlur(this, 15, nil, panel:GetAlpha())

        surface.SetDrawColor(0, 0, 0, 180)
        surface.DrawRect(0, 0, w, h)
    end

    local titleFont = "arb.Font_FuturaPTDemi_20"
    local descFont = "arb.Font_FuturaPTBook_12"
    local buttonFont = "arb.Font_FuturaPTBook_10"
    local buttonFontHeight = draw.GetFontHeight(buttonFont)

    local titlePanel = panel:Add("DLabel")
    titlePanel:Dock(TOP)
    titlePanel:DockMargin(0, self:GetTall() * 0.4, 0, 10)
    titlePanel:SetContentAlignment(5)
    titlePanel:SetText(title)
    titlePanel:SetFont(titleFont)
    titlePanel:SizeToContents()

    local descPanel = panel:Add("DLabel")
    descPanel:Dock(TOP)
    descPanel:DockMargin(0, 0, 0, 60)
    descPanel:SetContentAlignment(5)
    descPanel:SetText(description)
    descPanel:SetFont(descFont)
    descPanel:SizeToContents()

    local buttonsPanel = panel:Add("Panel")
    buttonsPanel:Dock(TOP)
    buttonsPanel:SetTall(buttonFontHeight + 15)

    local retryButton = buttonsPanel:Add("DButton")
    retryButton:SetText("")
    retryButton:SetWide(W(276))
    retryButton:Dock(LEFT)
    retryButton:DockMargin(self:GetWide() / 2 - (retryButton:GetWide() + 25), 0, 50, 0)
    retryButton.Paint = function(this, w, h)
        this.alpha = this.alpha or 0.1
        this.alpha = Lerp(FrameTime() * 10, this.alpha, (this:IsHovered() and this:IsEnabled()) and 1 or 0.1)

        surface.SetDrawColor(15, 5, 6, 204)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(155, 35, 57, 255 * this.alpha)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        draw.SimpleText(buttonPrimaryText, buttonFont, w / 2, h / 2, Color(255, 234, 238, 255 * this.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    retryButton.DoClick = function()
        buttonPrimaryCallback(panel)
    end

    local continueButton = buttonsPanel:Add("DButton")
    continueButton:SetText("")
    continueButton:SetWide(W(276))
    continueButton:Dock(LEFT)
    continueButton.Paint = function(this, w, h)
        this.alpha = this.alpha or 0.1
        this.alpha = Lerp(FrameTime() * 10, this.alpha, (this:IsHovered() and this:IsEnabled()) and 1 or 0.1)

        surface.SetDrawColor(15, 5, 6, 204)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(155, 35, 57, 255 * this.alpha)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        draw.SimpleText(buttonSecondaryText, buttonFont, w / 2, h / 2, Color(255, 234, 238, 255 * this.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    continueButton.DoClick = function()
        buttonSecondaryCallback(panel)
    end
end

function PANEL:ErrorMenu(errors)
    local panel = self:Add("DPanel")
    panel:SetAlpha(0)
    panel:AlphaTo(255, 1)
    panel:Dock(FILL)
    panel.Paint = function(this, w, h)
        asterionlib.DrawBlur(this, 15, nil, panel:GetAlpha())

        surface.SetDrawColor(0, 0, 0, 180)
        surface.DrawRect(0, 0, w, h)
    end

    local titleFont = "arb.Font_FuturaPTDemi_18"
    local descFont = "arb.Font_FuturaPTBook_10"
    local buttonFont = "arb.Font_FuturaPTBook_10"
    local buttonFontHeight = draw.GetFontHeight(buttonFont)

    local titlePanel = panel:Add("DLabel")
    titlePanel:Dock(TOP)
    titlePanel:DockMargin(150, H(100), 0, 10)
    titlePanel:SetContentAlignment(4)
    titlePanel:SetText("РЕКОМЕНДАЦИИ")
    titlePanel:SetFont(titleFont)
    titlePanel:SizeToContents()

    local descPanel = panel:Add("DLabel")
    descPanel:Dock(TOP)
    descPanel:DockMargin(150, 0, 0, 100)
    descPanel:SetContentAlignment(4)
    descPanel:SetText("Были обнаружены проблемы с контентом сервера. Пожалуйста, установите данные дополнения:")
    descPanel:SetFont(descFont)
    descPanel:SizeToContents()

    local infoPanel = panel:Add("Panel")
    infoPanel:Dock(FILL)

    local scrollPanel = infoPanel:Add("DScrollPanel")
    scrollPanel:SetWide(self:GetWide() * 0.3)
    scrollPanel:Dock(LEFT)
    scrollPanel:DockMargin(200, 0, 150, 0)

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
        surface.SetDrawColor(255, 255, 255)
        surface.DrawRect(20 + 7, 0, w, h)
    end

    local listPanel = scrollPanel:Add("DIconLayout")
    listPanel:Dock(FILL)
    listPanel:SetSpaceX(40)
    listPanel:SetSpaceY(40)

    local sizeIcon = H(178)
    local errorMat = Material("danganronpa/ui/info_5.png")
    local successMat = Material("danganronpa/ui/info_7.png")

    for _, id in ipairs(errors) do
        local name = "undefined"
        local image = nil
        local addon = asterionlib.workshop.list[id]
        local bIsOptional = asterionlib.workshop.stored[id].bOptional
        local alpha = 200

        if addon then
            name = addon.name

            asterionlib.downloader:Image(addon.image, function(matPath)
                image = matPath
            end)
        end

        local itemPanel = listPanel:Add("DPanel")
        itemPanel:SetSize(H(235), H(235))
        itemPanel.Paint = function(_, w, h)
            if image then
                surface.SetDrawColor(255, 255, 255)
                surface.SetMaterial(image)
                surface.DrawTexturedRect(w / 2 - sizeIcon / 2, 0, sizeIcon, sizeIcon)
            end

            surface.SetDrawColor(0, 0, 0, alpha)
            surface.DrawRect(w / 2 - sizeIcon / 2, 0, sizeIcon, sizeIcon)

            surface.SetDrawColor(13, 13, 13)
            surface.DrawOutlinedRect(w / 2 - sizeIcon / 2, 0, sizeIcon, sizeIcon)

            local height = 0

            if bIsOptional then
                height = select(2, draw.SimpleText("Не обязательный", "arb.Font_FuturaPTBook_6", w / 2, sizeIcon + 10, Color(255, 166, 0, 255 - alpha * 0.3), TEXT_ALIGN_CENTER))
            end

            draw.SimpleText(name, "arb.Font_FuturaPTBook_6", w / 2, sizeIcon + 10 + height, Color(255, 255, 255, 255 - alpha), TEXT_ALIGN_CENTER)
        end

        local size = H(40)
        local itemButton = itemPanel:Add("DButton")
        itemButton:SetText("")
        itemButton:Dock(FILL)
        itemButton.Paint = function(_, w, h)
            local isSub = steamworks.IsSubscribed(id)

            alpha = Lerp(FrameTime() * 10, alpha, (itemButton:IsHovered() or isSub) and 0 or 200)

            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(isSub and successMat or errorMat)
            surface.DrawTexturedRect(w / 2 + sizeIcon / 2 - size, 0, size, size)
        end
        itemButton.DoClick = function()
            steamworks.ViewFile(id)
        end
        itemButton.DoRightClick = function()
            steamworks.ViewFile(id)
        end
    end

    local informationPanel = infoPanel:Add("Panel")
    informationPanel:Dock(FILL)
    informationPanel:DockMargin(0, 0, 230, 0)

    local informationPanelText = informationPanel:Add("DLabel")
    informationPanelText:Dock(TOP)
    informationPanelText:SetContentAlignment(4)
    informationPanelText:SetText("Если ошибка не решилась, то рекомендуем обратиться к\nадминистрации проекта Asterion Academy. Сделать это\nможно в соц. сетях:")
    informationPanelText:SetFont(descFont)
    informationPanelText:SizeToContents()

    local buttonsPanel = panel:Add("Panel")
    buttonsPanel:Dock(BOTTOM)
    buttonsPanel:DockMargin(0, 30, 0, H(170))
    buttonsPanel:SetTall(buttonFontHeight + 15)

    local disconnectButton = buttonsPanel:Add("DButton")
    disconnectButton:SetText("")
    disconnectButton:SetWide(W(276))
    disconnectButton:Dock(LEFT)
    disconnectButton:DockMargin(self:GetWide() / 2 - (disconnectButton:GetWide() + 25), 0, 50, 0)
    disconnectButton.Paint = function(this, w, h)
        this.alpha = this.alpha or 0.1
        this.alpha = Lerp(FrameTime() * 10, this.alpha, (this:IsHovered() and this:IsEnabled()) and 1 or 0.1)

        surface.SetDrawColor(15, 5, 6, 204)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(155, 35, 57, 255 * this.alpha)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        draw.SimpleText("Отключиться от сервера", buttonFont, w / 2, h / 2, Color(255, 234, 238, 255 * this.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    disconnectButton.DoClick = function()
        RunConsoleCommand("disconnect")
    end

    local continueButton = buttonsPanel:Add("DButton")
    continueButton:SetText("")
    continueButton:SetWide(W(276))
    continueButton:Dock(LEFT)
    continueButton.Paint = function(this, w, h)
        this.alpha = this.alpha or 0.1
        this.alpha = Lerp(FrameTime() * 10, this.alpha, (this:IsHovered() and this:IsEnabled()) and 1 or 0.1)

        surface.SetDrawColor(15, 5, 6, 204)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(155, 35, 57, 255 * this.alpha)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        draw.SimpleText("Продолжить игру", buttonFont, w / 2, h / 2, Color(255, 234, 238, 255 * this.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    continueButton.DoClick = function()
        panel:AlphaTo(0, 0.5, 0, function()
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
                return self:Remove()
            end

            if countNoSubscribe <= 0 then
                return self:NotifyMenu(
                    "ПРЕДУПРЕЖДЕНИЕ",
                    "Вам необходимо перезайти в игру, чтобы дополнения на которые вы подписали\nначали работать стабильно!",
                    "Перезайти в игру",
                    function(pPanel)
                        os.date("%l") -- :)
                    end,
                    "Продолжить игру",
                    function(pPanel)
                        pPanel:AlphaTo(0, 0.5, 0, function()
                            self:Remove()
                        end)
                    end
                )
            else
                return self:NotifyMenu(
                    "ПРЕДУПРЕЖДЕНИЕ",
                    "Вы подписались не на все дополнения с которыми возникли проблемы.\nЕсли вы продолжите игру, то можете столкнуться с проблемами внутри клиента!",
                    "Назад",
                    function(pPanel)
                        pPanel:AlphaTo(0, 0.5, 0, function()
                            pPanel:Remove()

                            self:ShowErrors(errors, true)
                        end)
                    end,
                    "Продолжить игру",
                    function(pPanel)
                        pPanel:AlphaTo(0, 0.5, 0, function()
                            self:Remove()
                        end)
                    end
                )
            end
        end)
    end
end

function PANEL:ShowErrors(errors, bFirstIgnore)
    if !bFirstIgnore then
        local number = asterionlib.data:Get("connections", 0)

        if number <= 1 then
            return self:NotifyMenu(
                "ВПЕРВЫЕ С НАМИ?",
                "Похоже, что вы первый раз зашли на наш сервер. Чтобы всё работало\nкорректно необходимл перезайти на сервер. Если вы продолжите игру,\nто можете столкнуться с проблемами внутри клиента. Приятной игры!",
                "Перезайти на сервер",
                function()
                    RunConsoleCommand("retry")
                end,
                "Продолжить игру",
                function(panel)
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
        end)
    end
end

function PANEL:DoClose()
    if self.bClose then return end
    self.bClose = true

    self:AlphaTo(0, 0.3, 0, function()
        self:Remove()
    end)
end

function PANEL:OnRemove()
    local parent = self:GetParent()

    parent:ShowLogo()

    if SETTINGS.options.Get("show_beta_test") then
        parent:Menu()
    else
        parent:Intro()
    end
end

function PANEL:Paint()
    asterionlib.DrawBlur(self, 5)
end

vgui.Register("arb.MainRemake:Content", PANEL, "DPanel")