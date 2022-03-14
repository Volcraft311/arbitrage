local PANEL = {}

local stagesData = {
    ["game_process"] = function(panel)
        local parent = panel:GetParent()

        panel:SettingsCreatePanels()

        panel.titleText = "НАСТРОЙКИ"
        panel.titleDesc = "Настраиваем игру под себя"
        panel.titleAlpha = 0

        for k, v in pairs(SETTINGS.GetStored().options) do
            local createPanel = v.type
            local isHidden = v.IsHidden
            local bShow = true

            if isfunction(isHidden) then
                bShow = isHidden(LocalPlayer())
            end

            if !bShow then continue end

            if createPanel and isfunction(createPanel) then
                createPanel(v, panel.scrollPanel, panel.informationPanel)
            end
        end
    end,
    ["control"] = function(panel, data)
        local parent = panel:GetParent()

        panel.titleText = "НАСТРОЙКИ"
        panel.titleDesc = "Настраиваем игру под себя"
        panel.titleAlpha = 0

        panel:SettingsCreatePanels()

        for k, v in pairs(SETTINGS.GetStored().binds) do
            SETTINGS.type.bind(v, panel.scrollPanel, panel.informationPanel)
        end
    end,
    ["content"] = function(panel, data)
        local parent = panel:GetParent()

        panel.titleText = "НАСТРОЙКИ"
        panel.titleDesc = "Настраиваем игру под себя"
        panel.titleAlpha = 0

        panel.scrollPanel = panel:Add("DHorizontalScroller")
        panel.scrollPanel:SetAlpha(0)
        panel.scrollPanel:AlphaTo(255, 0.3)
        panel.scrollPanel:SetSize(ScrW() - (W(237) * 2), H(251))
        panel.scrollPanel:SetPos(W(237), ScrH() - H(248) - H(231))

        panel.scrollPanel:GetChildren()[2]:SetAlpha(0)
        panel.scrollPanel:GetChildren()[3]:SetAlpha(0)

        local test = panel.scrollPanel:Add("DPanel")
        test:SetTall(H(15))
        test:Dock(BOTTOM)
        test.Paint = function(_, w, h)
            local main = panel.scrollPanel
            local x = main.OffsetX
            local sX = main.pnlCanvas:GetWide()

            local size = 500000 / sX
            local pos = x - size

            pos = math.Clamp(pos, 0, w - size)

            surface.SetDrawColor(255, 255, 255, 3)
            surface.DrawRect(0, h - 3, w, 3)

            surface.SetDrawColor(255, 255, 255)
            surface.DrawRect(pos, h - 3, size, 3)
        end

        panel.informationPanel = panel:Add("Panel")
        panel.informationPanel:SetAlpha(0)
        panel.informationPanel:AlphaTo(255, 0.3)
        panel.informationPanel:SetSize(ScrW() - (W(237) * 2), H(350))
        panel.informationPanel:SetPos(W(237), H(211))

        local text = "Для стабильной и комфортной игры на сервере, Asterion Academy использует коллекцию аддонов и материалов.\nДля того, чтобы значительно сократить время захода на сервер, вы также можете подписаться на них в Workshop’е. Для этого достаточно\nкликнуть по нижерасположанным обложкам необходимого контента.\n\nВ случае возникновения проблем с контентом используйте данную вкладку для выявления непрогруженного контента. Если весь\nконтент фунционирует исправнно, а ошибки с отображение материалов остались — свяжитесь с нами."

        local labelTitle = panel.informationPanel:Add("DLabel")
        labelTitle:SetText("Управление контентом")
        labelTitle:SetFont("arb.Font_FuturaPTBook_11")
        labelTitle:SetTextColor(Color(255, 41, 80))
        labelTitle:Dock(TOP)
        labelTitle:DockMargin(0, 0, 0, H(6))
        labelTitle:SizeToContents()

        local labelDesc = panel.informationPanel:Add("DPanel")
        labelDesc:Dock(FILL)
        labelDesc.Paint = function(_, w, h)
            draw.DrawText(text, "arb.Font_FuturaPTBook_8", 0, 0, Color(255, 234, 238), TEXT_ALIGN_LEFT)
        end

        if WORKSHOP and WORKSHOP.gui then
            WORKSHOP.gui(panel.scrollPanel, panel.informationPanel)
        end
    end
}

function PANEL:Init()
    local parent = self:GetParent()

    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self:SetSize(ScrW(), ScrH())

    self.titleText = ""
    self.titleDesc = ""
    self.select = ""
    self.pressedCD = RealTime()
    self.titleAlpha = 0

    self.optionPanel = self:Add("Panel")
    self.optionPanel:SetTall(H(24))
    self.optionPanel:Dock(BOTTOM)
    self.optionPanel:DockMargin(W(150), 0, W(150), H(80))

    self.categoryOpPanel = parent:RegisterCategory(self, self:GetWide() - W(150) - W(585), H(60), W(585), H(62))
    :AddButton("Игровой процесс", W(235), function()
        self:OpenStages(true, "game_process")
    end, true)
    :AddSlash()
    :AddButton("Управление", W(165), function()
        self:OpenStages(true, "control")
    end)
    :AddSlash()
    :AddButton("Контент", W(125), function()
        self:OpenStages(true, "content")
    end)

    parent:AddOption(self.optionPanel, "ESC", "Назад", W(50), W(100))
end

function PANEL:SettingsCreatePanels()
    self.scrollPanel = self:Add("DScrollPanel")
    self.scrollPanel:SetAlpha(0)
    self.scrollPanel:AlphaTo(255, 0.3)
    self.scrollPanel:SetPos(W(150), H(211))
    self.scrollPanel:SetSize(W(800), ScrH() - H(422))

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
        surface.SetDrawColor(255, 255, 255)
        surface.DrawRect(20 + 7, 0, w, h)
    end

    local posX = W(150) + W(800) + W(130)

    self.informationPanel = self:Add("DScrollPanel")
    self.informationPanel:SetAlpha(0)
    self.informationPanel:AlphaTo(255, 0.3)
    self.informationPanel:SetPos(posX, H(211))
    self.informationPanel:SetSize(ScrW() - posX - W(150), ScrH() - H(422))
    self.informationPanel.panels = {}

    local bar = self.informationPanel:GetVBar()
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
end

function PANEL:ClearGarbage()
    local data = {
        self.scrollPanel,
        self.informationPanel
    }

    for k, v in ipairs(data) do
        if !IsValid(v) then continue end

        v:Remove()
    end
end

function PANEL:Think()
    local parent = self:GetParent()

    if RealTime() <= self.pressedCD then return end

    if input.IsKeyDown(KEY_ESCAPE) then
        if self.select == "game_process" or self.select == "control" or self.select == "content" then
            self:AlphaTo(0, 0.3, 0, function()
                self:Remove()
                parent:Bluring(false)
                parent:ShowLogo(true)
                parent.menu:Show(true)
            end)

            self.pressedCD = RealTime() + 0.3
        end
    end
end

function PANEL:OpenStages(bClear, data, ...)
    if !stagesData[data] then return end

    if bClear then
        self:ClearGarbage()
    end

    stagesData[data](self, ...)

    self.select = data
end

function PANEL:Paint()
    self.titleAlpha = Lerp(FrameTime() * 3, self.titleAlpha, 1)

    draw.DrawText(self.titleText, "arb.Font_FuturaPTDemi_17", W(150), H(60), Color(255, 234, 238, 255 * self.titleAlpha), TEXT_ALIGN_LEFT)

    surface.SetFont("arb.Font_FuturaPTDemi_17")
    local width, _ = surface.GetTextSize(self.titleText)

    draw.DrawText(self.titleDesc, "arb.Font_FuturaPTBook_10", width + W(170), H(74), Color(255, 234, 238, 20 * self.titleAlpha), TEXT_ALIGN_LEFT)
end

vgui.Register("arb.MainRemake:Settings", PANEL, "EditablePanel")