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

local PLUGIN = PLUGIN

local PANEL = {}

function PANEL:Init()
    local old_requestAPI = nil
    if IsValid(Arbitrage.gui.workshop) then
        old_requestAPI = Arbitrage.gui.workshop.requestAPI
        Arbitrage.gui.workshop:Remove()
    else
        self:SetAlpha(0)
        self:AlphaTo(255, 0.3)

        netstream.Start("WORKSHOP:GetStatus")

        timer.Simple(10, function()
            if !IsValid(self) then return end

            if self.requestAPI == nil then
                self.requestAPI = false
            end
        end)
    end

    Arbitrage.gui.workshop = self

    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()

    self.installArray = {}
    self.removeArray = {}

    self.requestAPI = old_requestAPI

    self:CreateTitle()
    self:CreateStatus()
    self:CreateSearch()
    self:CreateMain()
    self:CreateLogger()
end

function PANEL:CreateTitle()
    local panel = self:Add("DPanel")
    panel:Dock(TOP)
    panel:DockMargin(0, 0, 0, 5)
    panel:SetTall(H(30))
    panel.Paint = function(_, w, h)
        surface.SetDrawColor(255, 61, 96, 165.75)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        surface.SetDrawColor(255, 61, 96, 20)
        surface.DrawRect(0, 0, w, h)
    end

    local label = panel:Add("DLabel")
    label:SetText("Авто-установщик дополнений")
    label:SetFont("arb.Font_FuturaPTDemi_8")
    label:SetTextColor(Color(255, 255, 255))
    label:Dock(FILL)
    label:SetContentAlignment(4)
    label:DockMargin(10, 0, 0, 0)
    label:SizeToContents()

    local close = panel:Add("DButton")
    close:Dock(RIGHT)
    close:DockMargin(0, 0, 5, 0)
    close:SetWide(panel:GetTall())
    close:SetText("")
    close.alpha = 40
    close.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 40)
        draw.DrawText("X", "arb.Font_FuturaPTBook_7", w / 2, H(4), Color(255, 255, 255, _.alpha), TEXT_ALIGN_LEFT)
    end
    close.DoClick = function()
        self:AlphaTo(0, 0.2, 0, function()
            self:Remove()
        end)
    end
end

local function get(a)
    local color = a == nil and Color(255, 255, 255) or (a and Color(0, 255, 0) or Color(255, 0, 0))
    local text = a == nil and "Ожидаем..." or (a and "Работает" or "Не работает")

    return color, text
end

local statusFont = "arb.Font_FuturaPTBook_7"

function PANEL:CreateStatus()
    local panel = self:Add("DPanel")
    panel:Dock(TOP)
    panel:DockMargin(5, 0, 5, 0)
    panel.Paint = function(this, w, h)
        surface.SetDrawColor(27, 10, 13, 150)
        surface.DrawRect(0, 0, w, h)

        local padding = 5
        local _wR, _hR = draw.SimpleText("Статус API обработчика:", statusFont, 0, padding, Color(255, 255, 255), TEXT_ALIGN_LEFT)
        do
            local color, text = get(self.requestAPI)

            draw.SimpleText(text, statusFont, _wR + 10, padding, color, TEXT_ALIGN_LEFT)
        end
        padding = padding + _hR

        padding = padding + 5
        if this:GetTall() != padding then
            this:SetTall(padding)
        end
    end
end

function PANEL:CreateSearch()
    local panel = self:Add("DTextEntry")
    panel:SetTall(H(30))
    panel:Dock(TOP)
    panel:DockMargin(30, 15, 30, 5)
    panel:SetFont("arb.Font_FuturaPTDemi_7")
    panel:SetPlaceholderText("Вставьте ID предмета, ссылку, коллекцию сюда...")
    panel.OnEnter = function(this)
        local data = this:GetValue()
        data = string.Replace(data, "steamcommunity.com/sharedfiles/filedetails/?id=", "")
        data = string.Replace(data, "steamcommunity.com/workshop/filedetails/?id=", "")
        data = string.Replace(data, "https://", "")
        data = string.Replace(data, "http://", "")
        data = string.Replace(data, "www.", "")

        if data:find("&") then
            data = data:match("(.-)&.*")
        end

        local id = tonumber(data)
        if !id then return end

        local subPanel = vgui.Create("WORKSHOP:MenuSub")
        subPanel:SetData(id)

        this:SetText("")
    end
end

function PANEL:CreateMain()
    local mainPanel = self:Add("DPanel")
    mainPanel:Dock(FILL)
    mainPanel:DockMargin(5, 15, 5, 15)
    mainPanel.Paint = function(_, w, h)
        surface.SetDrawColor(27, 10, 13, 150)
        surface.DrawRect(0, 0, w, h)
    end

    local leftPanel = mainPanel:Add("Panel")
    leftPanel:Dock(LEFT)
    leftPanel:SetWide(self:GetWide() / 2)
    leftPanel.Paint = function(_, w, h)
        surface.SetDrawColor(255, 61, 96, 50)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
    end

    local leftPanelTitle = leftPanel:Add("DPanel")
    leftPanelTitle:SetTall(H(25))
    leftPanelTitle:Dock(TOP)
    leftPanelTitle.Paint = function(_, w, h)
        surface.SetDrawColor(255, 61, 96, 50)
        surface.DrawRect(0, 0, w, h)

        draw.SimpleText("На проверке", "arb.Font_FuturaPTBook_7", 5, 0, color_white, TEXT_ALIGN_LEFT)
    end


    self.leftPanelScroll = leftPanel:Add("DScrollPanel")
    self.leftPanelScroll:Dock(FILL)

    do
        local bar = self.leftPanelScroll:GetVBar()
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

    if LocalPlayer():IsSuperAdmin() or LocalPlayer():GetUserGroup() == "gamemaster" then
        local installButton = leftPanel:Add("DButton")
        installButton:SetText("")
        installButton:SetTall(H(25))
        installButton:Dock(BOTTOM)
        installButton:DockMargin(0, 0, 0, 5)
        installButton.alpha = 0
        installButton.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
            draw.DrawText("Установить " .. table.Count(self.installArray) .. " дополнений", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

            surface.SetDrawColor(255, 61, 96, 30)
            surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
        end
        installButton.DoClick = function()
            if table.Count(self.installArray) <= 0 then return end

            netstream.Start("Workshop:Install", self.installArray)
        end
    end

    local cancelButton = leftPanel:Add("DButton")
    cancelButton:SetText("")
    cancelButton:SetTall(H(25))
    cancelButton:Dock(BOTTOM)
    cancelButton:DockMargin(0, 0, 0, 5)
    cancelButton.alpha = 0
    cancelButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("Отменить " .. table.Count(self.installArray) .. " дополнений", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    cancelButton.DoClick = function()
        if table.Count(self.installArray) <= 0 then return end

        netstream.Start("Workshop:Cancel", self.installArray)
    end

    local rightPanel = mainPanel:Add("Panel")
    rightPanel:Dock(FILL)
    rightPanel.Paint = function(_, w, h)
        surface.SetDrawColor(255, 61, 96, 50)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
    end

    local rightPanelTitle = rightPanel:Add("DPanel")
    rightPanelTitle:SetTall(H(25))
    rightPanelTitle:Dock(TOP)
    rightPanelTitle.Paint = function(_, w, h)
        surface.SetDrawColor(255, 61, 96, 50)
        surface.DrawRect(0, 0, w, h)

        draw.SimpleText("Установлены", "arb.Font_FuturaPTBook_7", 5, 0, color_white, TEXT_ALIGN_LEFT)
    end

    self.rightPanelScroll = rightPanel:Add("DScrollPanel")
    self.rightPanelScroll:Dock(FILL)

    do
        local bar = self.rightPanelScroll:GetVBar()
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

    local removeButton = rightPanel:Add("DButton")
    removeButton:SetText("")
    removeButton:SetTall(H(25))
    removeButton:Dock(BOTTOM)
    removeButton:DockMargin(0, 0, 0, 5)
    removeButton.alpha = 0
    removeButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("Удалить " .. table.Count(self.removeArray) .. " дополнений", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    removeButton.DoClick = function()
        if table.Count(self.removeArray) <= 0 then return end

        netstream.Start("Workshop:Remove", self.removeArray)
    end
end

function PANEL:CreateLogger()
    self.logger = self:Add("RichText")
    self.logger:Dock(BOTTOM)
    self.logger:DockMargin(5, 0, 5, 0)
    self.logger:SetTall(150)
    self.logger.Paint = function(_, w, h)
        surface.SetDrawColor(27, 10, 13, 150)
        surface.DrawRect(0, 0, w, h)
    end

    for _, v in ipairs(PLUGIN.logs) do
        local info = PLUGIN.logsTypes[v[1]]
        local data = info:format(unpack(v[2]))

        self.logger:AppendText(data .. "\n")
    end

    self.logger.PerformLayout = function(this, w, h)
        this:GotoTextEnd()
    end
end

local starMat = Material("icon16/star.png")
local function createPanel(scrollPanel, array, icon, id, author)
    local title = "Загрузка..."
    local tags = "Загрузка..."
    local image = nil
    local stars = 0
    local total = 0

    local panel = scrollPanel:Add("DButton")
    panel:SetText("")
    panel:Dock(TOP)
    panel:SetTall(H(60))
    panel.alpha = 0

    panel.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 20 or 0)

        surface.SetDrawColor(255, 61, 96, _.alpha)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(255, 61, 96, 50)
        surface.DrawOutlinedRect(0, 0, w, h, 1)

        if image then
            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(image)
            surface.DrawTexturedRect(2, 2, h - 4, h - 4)
        end

        local _w = draw.SimpleText(title, "arb.Font_FuturaPTDemi_9", h + 5, 0, color_white, TEXT_ALIGN_LEFT)
        draw.SimpleText("(" .. id .. ")", "arb.Font_FuturaPTBook_7", _w + h + 15, H(4), color_white, TEXT_ALIGN_LEFT)

        draw.SimpleText(tags, "arb.Font_FuturaPTBook_6", h + 5, H(25), Color(255, 255, 255, 80), TEXT_ALIGN_LEFT)
        draw.SimpleText("Добавил: " .. author, "arb.Font_FuturaPTBook_5", h + 5, H(43), Color(255, 255, 255, 100), TEXT_ALIGN_LEFT)

        local margin = 0
        local size = h * 0.4
        for i = 1, 5 do
            surface.SetDrawColor(255, 255, 255, 20)
            surface.SetMaterial(starMat)
            surface.DrawTexturedRect(w / 2 + (i - 1) * size, h - size - (h / 2 - size), size, size)

            if i == 5 then
                margin = w / 2 + (i - 1) * size + size
            end
        end

        for i = 1, stars do
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(starMat)
            surface.DrawTexturedRect(w / 2 + (i - 1) * size, h - size - (h / 2 - size), size, size)
        end

        draw.SimpleText("Оценок: " .. total, "arb.Font_FuturaPTBook_6", margin + 5, h - size - (h / 2 - size) + H(5), ColorAlpha(color_white, 100), TEXT_ALIGN_LEFT)

        if array[id] then
            surface.SetDrawColor(255, 61, 96, 50)
            surface.DrawRect(w - 10, 0, 10, h)
        end

        if PLUGIN.requestList[id] then
            size = h * 0.3

            surface.SetDrawColor(255, 255, 255, 255 * math.abs(math.sin(RealTime() * 3)))
            surface.SetMaterial(icon)
            surface.DrawTexturedRect(w - size - 15, h / 2 - size / 2, size, size)
        end
    end

    panel.DoClick = function()
        if array[id] then
            array[id] = nil
        else
            array[id] = true
        end
    end

    panel.DoRightClick = function()
        steamworks.ViewFile(id)
    end

    panel.DoDoubleClick = function()
        steamworks.ViewFile(id)
    end

    steamworks.FileInfo(id, function(info)
        if !IsValid(panel) then return end
        if !info then return end

        title = info.title
        tags = info.tags
        stars = math.Round((info.score * 10) / 2)
        total = info.total

        asterionlib.downloader:Image(info.previewurl, function(matPath, path)
            if !IsValid(panel) then return end

            image = matPath
        end)
    end)
end

function PANEL:SetData(data)
    self.data = data

    self.leftPanelScroll:Clear()
    self.rightPanelScroll:Clear()

    for k, v in pairs(data[1]) do
        createPanel(self.leftPanelScroll, self.installArray, Material("danganronpa/ui/info_2.png"), k, v)
    end

    for k, v in pairs(data[2]) do
        createPanel(self.rightPanelScroll, self.removeArray, Material("danganronpa/ui/info_1.png"), k, v)
    end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(41, 22, 25)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(255, 61, 96, 165.75)
    surface.DrawOutlinedRect(0, 0, w, h, 2)
end

vgui.Register("WORKSHOP:Menu", PANEL, "EditablePanel")



local PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self.startTime = SysTime()

    self.id = nil
    self.image = nil
    self.title = ""
    self.description = ""
    self.tags = ""

    local t = H(300)
    self.main = self:Add("Panel")
    self.main:SetPos(ScrW() / 2 - (W(600)) / 2, ScrH() / 2 - (t / 2))
    self.main:SetSize(W(600), 0)

    self.main.Think = function(this)
        this:SetTall(Lerp(FrameTime() * 10, this:GetTall(), t))
    end

    self.main.Paint = function(panel, w, h)
        surface.SetDrawColor(41, 22, 25)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(255, 61, 96, 165.75)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        surface.SetDrawColor(255, 61, 96, 165.75)
        surface.DrawOutlinedRect(0, 0, w, H(23), 2)

        surface.SetDrawColor(255, 61, 96, 20)
        surface.DrawRect(0, 0, w, H(23))

        draw.DrawText(self.isCollection and "Добавить дополнения из коллекции" or "Добавить новое дополнение", "arb.Font_FuturaPTBook_5", W(10), H(3), color_white, TEXT_ALIGN_LEFT)
    end

    local close = self.main:Add("DButton")
    close:SetPos(self.main:GetWide() - H(70 / 2), 0)
    close:SetSize(H(70 / 2), H(23))
    close:SetText("")
    close.alpha = 40
    close.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 40)
        draw.DrawText("X", "arb.Font_FuturaPTBook_5", w / 2, H(4), Color(255, 255, 255, _.alpha), TEXT_ALIGN_LEFT)
    end
    close.DoClick = function()
        self:AlphaTo(0, 0.2, 0, function()
            self:Remove()
        end)
    end

    local infoPanel = self.main:Add("DPanel")
    infoPanel:Dock(FILL)
    infoPanel:DockMargin(0, H(23), 0, 0)
    infoPanel.Paint = function(_, w, h)
        if self.image then
            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(self.image)
            surface.DrawTexturedRect(2, 2, h - 4, h - 4)
        end

        local padding = 0
        local _, h1 = draw.SimpleText(self.title, "arb.Font_FuturaPTDemi_7", h + 5, padding, color_white, TEXT_ALIGN_LEFT)
        padding = padding + h1

        local _, h1 = draw.SimpleText(self.tags, "arb.Font_FuturaPTBook_5", h + 5, padding, color_white, TEXT_ALIGN_LEFT)
        padding = padding + h1 + 5

        local data = asterionlib.WrapText(self.description, w - h - 15, "arb.Font_FuturaPTBook_5", true)
        for k, v in ipairs(data) do
            local _, h1 = draw.SimpleText(v, "arb.Font_FuturaPTBook_5", h + 5, padding, color_white, TEXT_ALIGN_LEFT)
            padding = padding + h1
        end
    end

    local submitButton = self.main:Add("DButton")
    submitButton:DockMargin(0, H(5), 0, H(5))
    submitButton:SetText("")
    submitButton:SetTall(H(25))
    submitButton:Dock(BOTTOM)
    submitButton.alpha = 0
    submitButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("Добавить", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    submitButton.DoClick = function()
        if !self.id then return end

        self:AlphaTo(0, 0.3, 0, function()
            self:Remove()
        end)

        local info = {self.id}

        if self.allowAttachment or self.isCollection then
            if self.isCollection then
                info = {}
            end

            for k, v in ipairs(self.collectionChildren) do
                info[#info + 1] = v
            end
        end

        netstream.Start("Workshop:Add", info)
    end

    local openButton = self.main:Add("DButton")
    openButton:DockMargin(0, H(5), 0, H(5))
    openButton:SetText("")
    openButton:SetTall(H(25))
    openButton:Dock(BOTTOM)
    openButton.alpha = 0
    openButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("Посмотреть", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    openButton.DoClick = function()
        if !self.id then return end

        steamworks.ViewFile(self.id)
    end

    local attachmentCheckBox = self.main:Add("DCheckBoxLabel")
    attachmentCheckBox:DockMargin(W(10), H(5), 0, H(5))
    attachmentCheckBox:SetText("Принимать дополнительный контент дополнения")
    attachmentCheckBox:SetValue(true)
    attachmentCheckBox:SetTall(H(25))
    attachmentCheckBox:Dock(BOTTOM)
    attachmentCheckBox.OnChange = function(this, value)
        self.allowAttachment = value
    end

    local collectionCheckBox = self.main:Add("DCheckBoxLabel")
    collectionCheckBox:DockMargin(W(10), H(5), 0, H(5))
    collectionCheckBox:SetText("Данный аддон является коллекцией")
    collectionCheckBox:SetValue(false)
    collectionCheckBox:SetTall(H(25))
    collectionCheckBox:Dock(BOTTOM)
    collectionCheckBox.OnChange = function(this, value)
        self.isCollection = value
    end
end

function PANEL:SetData(id)
    self.id = id
    self.isCollection = false
    self.allowAttachment = true
    self.collectionChildren = {}

    self.title = "Загрузка..."
    self.description = "Загрузка..."
    self.tags = "Загрузка..."

    steamworks.FileInfo(id, function(info)
        if !IsValid(self) then return end
        if !info then return end

        self.title = info.title
        self.description = info.description
        self.tags = info.tags

        if info.children and #info.children > 0 then
            self.collectionChildren = info.children
        end

        asterionlib.downloader:Image(info.previewurl, function(matPath, path)
            if !IsValid(self) then return end

            self.image = matPath
        end)
    end)
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.startTime)
end

vgui.Register("WORKSHOP:MenuSub", PANEL, "EditablePanel")