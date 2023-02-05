--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local PANEL = {}

local subscribeMat = Material("danganronpa/ui/info_7.png")
local installMat = Material("danganronpa/ui/info_6.png")
local noInstallMat = Material("danganronpa/ui/info_5.png")

local statusMat = {
    [0] = {
        text = "Не установлен",
        mat = noInstallMat,
        color = Color(255, 65, 23)
    },
    [1] = {
        text = "Временно скачан",
        mat = installMat,
        color = Color(255, 176, 56)
    },
    [2] = {
        text = "Установлен",
        mat = subscribeMat,
        color = Color(14, 255, 110)
    }
}

local function workshop_gui(scrollPanel, informationPanel)    
    local selected = nil

    local List = scrollPanel:Add("DIconLayout")
    List:Dock(FILL)

    for k, v in pairs(asterionlib.workshop.list) do
        local image, imageSize = nil, W(120)
        asterionlib.DownloadImage(v.image, function(matPath)
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
        ListItem.Paint = function(this, w, h)
            local isSelect = selected == k
            local blacked = bInstall and 255 or 100

            this.alpha = Lerp(FrameTime() * 10, this.alpha, isSelect and 1 or -0.1)

            local x, y = w / 2 - imageSize / 2, 4

            if image then
                surface.SetDrawColor(blacked, blacked, blacked)
                surface.SetMaterial(image)
                surface.DrawTexturedRect(x, y, imageSize, imageSize)
            end

            surface.SetDrawColor(15, 15, 15)
            surface.DrawOutlinedRect(x, y, imageSize, imageSize, 2)

            Arbitrage.DrawTextBlur(name, "arb.Font_FuturaPTBook_7", w / 2, imageSize + H(10), Color(255, 238, 177, 255 * this.alpha), TEXT_ALIGN_CENTER)

            if !isSelect then
                draw.SimpleText(name, "arb.Font_FuturaPTBook_7", w / 2, imageSize + H(10), Color(blacked, blacked, blacked), TEXT_ALIGN_CENTER)
            end

            Arbitrage.DrawOutlinedRectBlur(x, y, imageSize, imageSize, Color(255, 238, 177, 255 * this.alpha), 2, 4)

            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(statusMat[tonumber(v.status)].mat)
            surface.DrawTexturedRect(imageSize - 12, 0, 33, 33)
        end

        local function sel()
            selected = k

            informationPanel.title.text = v.name
            informationPanel.title.status = v.status

            local desc = v.stored.description
            informationPanel.desc:SetValue(desc)

            informationPanel:SetAlpha(0)
            informationPanel:AlphaTo(255, 0.3)
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

local stagesData = {
    ["game_process"] = function(panel)
        local parent = panel:GetParent()

        panel:SettingsCreatePanels()

        panel.titleText = "НАСТРОЙКИ"
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
        panel.titleAlpha = 0

        panel:SettingsCreatePanels()

        for k, v in pairs(SETTINGS.GetStored().binds) do
            SETTINGS.type.bind(v, panel.scrollPanel, panel.informationPanel)
        end
    end,
    ["content"] = function(panel, data)
        local parent = panel:GetParent()

        panel.titleText = "НАСТРОЙКИ"
        panel.titleAlpha = 0

        panel.scrollPanel = panel:Add("DScrollPanel")
        panel.scrollPanel:SetAlpha(0)
        panel.scrollPanel:AlphaTo(255, 0.3)
        panel.scrollPanel:SetPos(W(140), H(156))
        panel.scrollPanel:SetSize(W(840), H(786))

        do
            local bar = panel.scrollPanel:GetVBar()
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

        panel.informationPanel = panel:Add("Panel")
        panel.informationPanel:SetAlpha(0)
        panel.informationPanel:SetSize(W(700), H(786))
        panel.informationPanel:SetPos(ScrW() - W(150) - panel.informationPanel:GetWide(), H(156))

        local Title = panel.informationPanel:Add("DPanel")
        Title:Dock(TOP)
        Title:SetTall(H(35))
        Title.text = ""
        Title.status = 0
        Title.Paint = function(this, w, h)
            if this.text == "" then return end

            local width, height = draw.SimpleText(this.text, "arb.Font_FuturaPTBook_10", 0, 0, color_white, TEXT_ALIGN_LEFT)

            draw.SimpleText(statusMat[this.status].text, "arb.Font_FuturaPTBook_10", width + 44, 0, statusMat[this.status].color, TEXT_ALIGN_LEFT)

            surface.SetDrawColor(255, 255, 255, 20)
            surface.DrawRect(width + 20, 0, 2, h)
        end

        panel.informationPanel.title = Title

        local Desc = panel.informationPanel:Add("DTextEntry")
        Desc:SetFont("arb.Font_FuturaPTBook_7")
        Desc:SetTextColor(color_white)
        Desc:SetValue("")
        Desc:Dock(FILL)
        Desc:DockMargin(0, 5, 0, 0)
        Desc:SetMultiline(true)
        Desc:SetPaintBackground(false)

        panel.informationPanel.desc = Desc

        workshop_gui(panel.scrollPanel, panel.informationPanel)
    end
}

function PANEL:Init()
    local parent = self:GetParent()

    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self:SetSize(ScrW(), ScrH())

    self.titleText = ""
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
end

vgui.Register("arb.MainRemake:Settings", PANEL, "EditablePanel")
