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


local deleteMat = Material("danganronpa/ui/delete.png")
local settingsMat = Material("danganronpa/ui/settings.png")

local PLUGIN = PLUGIN

local PANEL = {}

function PANEL:Init()
    self:SetTitle("")
    self:SetPos(0, 0)
    self:SetSize(W(960 * 1.3), H(540 * 1.3))
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self:Center()
    self:ShowCloseButton(false)

    PLUGIN.panel = self

    local close = self:Add("DButton")
    close:SetPos(self:GetWide() - H(70), 0)
    close:SetSize(H(70), H(30))
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

    local playButton = self:Add("DButton")
    playButton:DockMargin(0, H(5), 0, H(5))
    playButton:SetText("")
    playButton:SetTall(H(25))
    playButton:Dock(BOTTOM)
    playButton.alpha = 0
    playButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("Запустить музыку", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    playButton.DoClick = function()
        Derma_StringRequest("Запустить музыку", "Укажите путь к файлу или URL", "", function(url)
            netstream.Start("ScriptMusic:ChangeMusic", url)

        end, nil, "Запустить", "Отменить")
    end

    local addButton = self:Add("DButton")
    addButton:DockMargin(0, H(5), 0, H(5))
    addButton:SetText("")
    addButton:SetTall(H(25))
    addButton:Dock(BOTTOM)
    addButton.alpha = 0
    addButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("Создать новый плейлист", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    addButton.DoClick = function()
        local id = #self.data[2] + 1
        local data = {"", {}}

        local panel = vgui.Create("ScriptMusic:MenuSub")
        panel:SetData(id, data)
    end

    local playEvent = self:Add("DButton")
    playEvent:DockMargin(0, H(5), 0, H(5))
    playEvent:SetText("")
    playEvent:SetTall(H(25))
    playEvent:Dock(BOTTOM)
    playEvent.alpha = 0
    playEvent.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("Запустить ивент", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    playEvent.DoClick = function()
        local func = function(data)
            netstream.Start("ScriptMusic:ChangeTheme", data, true)

            Arbitrage.notify.NotifyChat("Вы поменяли тему на: " .. data)
        end

        local menu = DermaMenu()
        for k, v in SortedPairsByMemberValue(PLUGIN:GetEvents(), "name") do
            menu:AddOption(v.name, function() func(k) end)
        end

        menu:AddOption("Выключить тему", function()
            func("none")
        end)

        menu:Open()
    end

    Arbitrage.gui.whitelist = self
end

function PANEL:SetData(data)
    self.data = data

    if IsValid(self.mainPanel) then self.mainPanel:Remove() end

    self.mainPanel = self:Add("Panel")
    self.mainPanel:SetWide(W(250))
    self.mainPanel:Dock(FILL)
    self.mainPanel:DockMargin(W(5), H(45), W(5), H(5))
    self.mainPanel.Paint = function(_, w, h)
        surface.SetDrawColor(27, 10, 13, 150)
        surface.DrawRect(0, 0, w, h)
    end


    self.playlistPanel = self.mainPanel:Add("DPanelList")
    self.playlistPanel:EnableVerticalScrollbar()
    self.playlistPanel:Dock(FILL)
    self.playlistPanel:DockMargin(W(5), H(5), W(5), H(5))

    local num = 0
    for k, v in pairs(self.data[2] or {}) do
        local panel = self.playlistPanel:Add("DButton")
        panel.num = num
        panel:SetText("")
        panel:SetTall(H(30))
        panel:Dock(TOP)
        panel:DockMargin(0, 0, 0, H(0))
        panel.alpha = 0
        panel.Paint = function(_, w, h)
            if _.num % 2 == 0 then
                surface.SetDrawColor(255, 61, 96, 1)
                surface.DrawRect(0, 0, w, h)
            end

            _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() or self.data[1] == k) and 10 or 0)

            surface.SetDrawColor(255, 61, 96, _.alpha)
            surface.DrawRect(0, 0, w, h)

            if self.data[1] == k then
                surface.SetDrawColor(255, 61, 96, _.alpha * 5)
                surface.DrawOutlinedRect(0, 0, w, h)
            end

            draw.DrawText(v[1], "arb.Font_FuturaPTBook_7", W(10), H(4), color_white, TEXT_ALIGN_LEFT)
            draw.DrawText(k, "arb.Font_FuturaPTBook_7", w - W(200), H(4), color_white, TEXT_ALIGN_LEFT)
        end
        panel.DoClick = function()
            self.data[1] = k
            netstream.Start("ScriptMusic:ChangeCurrentPlayList", k)
        end

        local deleteButton = panel:Add("DButton")
        deleteButton:SetText("")
        deleteButton:Dock(RIGHT)
        deleteButton:SetWide(panel:GetTall())
        deleteButton.alpha = 0
        deleteButton.DoClick = function()
            local menu = DermaMenu()

            menu:AddOption("Удалить Плейлист", function()
                netstream.Start("ScriptMusic:RemovePlayList", k)
            end)

            menu:Open()
        end
        deleteButton.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)

            surface.SetDrawColor(255, 255, 255, _.alpha)
            surface.SetMaterial(deleteMat)
            surface.DrawTexturedRect(5, 5, w - 10, h - 10)
        end

        local editButton = panel:Add("DButton")
        editButton:SetText("")
        editButton:Dock(RIGHT)
        editButton:SetWide(panel:GetTall())
        editButton.alpha = 0
        editButton.DoClick = function()
            netstream.Start("ScriptMusic:OpenMenuSub", k)
        end
        editButton.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)

            surface.SetDrawColor(255, 255, 255, _.alpha)
            surface.SetMaterial(settingsMat)
            surface.DrawTexturedRect(5, 5, w - 10, h - 10)
        end

        self.playlistPanel:AddItem(panel)
        num = num + 1
    end
end


function PANEL:Paint(w, h)
    surface.SetDrawColor(41, 22, 25)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(255, 61, 96, 165.75)
    surface.DrawOutlinedRect(0, 0, w, h, 2)

    surface.SetDrawColor(255, 61, 96, 165.75)
    surface.DrawOutlinedRect(0, 0, w, H(30), 2)

    surface.SetDrawColor(255, 61, 96, 20)
    surface.DrawRect(0, 0, w, H(30))

    draw.DrawText("ScriptMusic редактор", "arb.Font_FuturaPTDemi_8", W(10), H(3), color_white, TEXT_ALIGN_LEFT)

    draw.DrawText("Название", "arb.Font_FuturaPTBook_7", W(30), H(45), color_white, TEXT_ALIGN_LEFT)
    draw.DrawText("ID", "arb.Font_FuturaPTBook_7", w - W(215), H(45), color_white, TEXT_ALIGN_LEFT)
end

vgui.Register("ScriptMusic:Menu", PANEL, "DFrame")







local PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self.startTime = SysTime()
    self.activemenu = ""


    self.main = self:Add("Panel")
    self.main:SetPos(ScrW() / 2 - (W(800)) / 2, ScrH() / 2 - (H(600) / 2))
    self.main:SetSize(W(800), 0)

    local t = H(600)
    self.main.Think = function(panel)
        panel:SetTall(Lerp(FrameTime() * 10, panel:GetTall(), t))
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

        draw.DrawText("Редактор плейлиста", "arb.Font_FuturaPTBook_5", W(10), H(3), color_white, TEXT_ALIGN_LEFT)

        draw.DrawText("Название плейлиста", "arb.Font_FuturaPTBook_7", W(10), H(28), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText("Пример: Тестовый плейлист", "arb.Font_FuturaPTBook_7", W(10), H(50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("Ивенты:", "arb.Font_FuturaPTBook_7", W(10), H(80 + 28), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText("Действия:", "arb.Font_FuturaPTBook_7", W(320), H(80 + 28), color_white, TEXT_ALIGN_LEFT)
    end

    self.nameEntry = self.main:Add("DTextEntry")
    self.nameEntry:SetPos(W(5), H(75))
    self.nameEntry:SetSize(self.main:GetWide() - W(10), H(25))
    self.nameEntry:SetPlaceholderText("Тестовый плейлист")
    self.nameEntry:SetFont("arb.Font_FuturaPTBook_8")

    self.mainPanel = self.main:Add("Panel")
    self.mainPanel:Dock(FILL)
    self.mainPanel:DockMargin(W(5), H(140), W(5), H(5))
    self.mainPanel.Paint = function(_, w, h)
        surface.SetDrawColor(27, 10, 13, 150)
        surface.DrawRect(0, 0, w, h)
    end

    self.eventsPanel = self.mainPanel:Add("DPanelList")
    self.eventsPanel:EnableVerticalScrollbar()
    self.eventsPanel:Dock(LEFT)
    self.eventsPanel:SetWide(W(300))
    self.eventsPanel:DockMargin(W(5), H(5), W(5), H(5))
    self.eventsPanel.Paint = function(_, w, h)
        surface.SetDrawColor(255, 61, 96, 165.75)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
    end

    local _actionPanel = self.mainPanel:Add("DPanel")
    _actionPanel:Dock(FILL)
    _actionPanel:DockMargin(W(5), H(5), W(5), H(5))
    _actionPanel.Paint = function(_, w, h)
        surface.SetDrawColor(255, 61, 96, 165.75)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
    end

    self.actionPanel = _actionPanel:Add("DPanelList")
    self.actionPanel:EnableVerticalScrollbar()
    self.actionPanel:Dock(FILL)

    local titlePanel = self.actionPanel:Add("DPanel")
    titlePanel:Dock(TOP)
    titlePanel:SetTall(H(20))
    titlePanel.Paint = function(_, w, h)
        draw.DrawText("ID", "arb.Font_FuturaPTBook_6", W(20), H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)
        draw.DrawText("Длительность", "arb.Font_FuturaPTBook_6", W(110), H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)
        draw.DrawText("Путь или URL", "arb.Font_FuturaPTBook_6", W(200), H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 5)
        surface.DrawRect(0, 0, w, h)
    end
    self.actionPanel:AddItem(titlePanel)

    local addSound = _actionPanel:Add("DButton")
    addSound:DockMargin(0, H(5), 0, H(5))
    addSound:SetText("")
    addSound:SetTall(H(20))
    addSound:Dock(BOTTOM)
    addSound.alpha = 0
    addSound.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("Добавить новую музыку", "arb.Font_FuturaPTBook_6", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    addSound.DoClick = function()
        local id_playlist = self.data[1]
        local id_type = self.activemenu

        if string.Trim(id_playlist) == "" then return end
        if !PLUGIN:GetEvents()[id_type] then return end

        Derma_StringRequest("Добавить новый трек", "Укажите путь к файлу или URL", "", function(path_file)
            local data = self.data

            data[2][1] = self.nameEntry:GetValue()
            data[2][2] = data[2][2] or {}

            data[2][2][id_type] = data[2][2][id_type] or {}

            table.insert(data[2][2][id_type], path_file)

            self.data = data

            local id = #data[2][2][id_type]

            self:AddTrack(id, path_file)
        end, nil, "Сохранить", "Отменить")
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


    local submitButton = self.main:Add("DButton")
    submitButton:DockMargin(0, H(5), 0, H(5))
    submitButton:SetText("")
    submitButton:SetTall(H(25))
    submitButton:Dock(BOTTOM)
    submitButton.alpha = 0
    submitButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("Изменить", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end

    submitButton.DoClick = function()
        local data = self.data

        local id_playlist = data[1]
        local data_playlist = data[2]

        data_playlist[1] = self.nameEntry:GetValue()

        netstream.Start("ScriptMusic:SavePlayList", id_playlist, data_playlist)

        self:AlphaTo(0, 0.2, 0, function()
            self:Remove()
        end)
    end
end

function PANEL:ClearTracks()
    self.trackPanels = self.trackPanels or {}

    for k, v in pairs(self.trackPanels) do
        if IsValid(v) then
            v:Remove()
        end

        self.trackPanels[k] = nil
    end
end

function PANEL:UpdateTracks(id)
    self:ClearTracks()

    for k, v in pairs(self.data[2][2][id] or {}) do
        self:AddTrack(k, v)
    end
end

function PANEL:AddTrack(id, path)
    local time = "???"

    PLUGIN:InitializeTrack(path, function(channel)
        local length = channel:GetLength()

        time = PLUGIN:GetNormalTime(length)
    end)

    local panel = self.actionPanel:Add("DButton")
    panel:SetText("")
    panel:SetTall(H(20))
    panel:Dock(TOP)
    panel.alpha = 0
    panel.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)

        surface.SetDrawColor(255, 61, 96, (_.alpha - 30) * 0.02)
        surface.DrawRect(0, 0, w, h)

        if time == "???" then
            local alpha_s = math.sin(CurTime() * 5) * 10

            surface.SetDrawColor(255, 0, 0, alpha_s)
            surface.DrawRect(0, 0, w, h)
        end

        draw.DrawText(id, "arb.Font_FuturaPTBook_6", W(10), H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_LEFT)
        draw.DrawText(time, "arb.Font_FuturaPTBook_6", W(70), H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_LEFT)
        draw.DrawText(path, "arb.Font_FuturaPTBook_6", W(165), H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_LEFT)
    end
    panel.DoClick = function()
        local menu = DermaMenu()

        menu:AddOption("Скопировать ID", function() SetClipboardText(id) end)
        menu:AddOption("Скопировать Длительность", function() SetClipboardText(time) end)
        menu:AddOption("Скопировать Путь", function() SetClipboardText(path) end)

        menu:Open()
    end

    local rmButton = panel:Add("DButton")
    rmButton:SetText("")
    rmButton:Dock(RIGHT)
    rmButton:SetWide(panel:GetTall())
    rmButton.alpha = 0
    rmButton.DoClick = function(_, w, h)
        local menu = DermaMenu()

        menu:AddOption("Удалить Трек", function()
            local active = self.activemenu

            local info = self.data[2][2][active]
            if !info then return end

            local song = info[id]
            if !song then return end

            table.remove(info, id)

            self:UpdateTracks(active)
        end)

        menu:Open()
    end
    rmButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)

        surface.SetDrawColor(255, 255, 255, _.alpha)
        surface.SetMaterial(deleteMat)
        surface.DrawTexturedRect(2, 2, w - 4, h - 4)
    end

    self.actionPanel:AddItem(panel)

    self.trackPanels = self.trackPanels or {}
    self.trackPanels[#self.trackPanels + 1] = panel
end

function PANEL:SetData(id, data)
    self.data = {id, data}

    self.nameEntry:SetValue(data[1])

    local num = 0

    for k, v in SortedPairsByMemberValue(PLUGIN:GetEvents(), "name") do
        local panel = self.eventsPanel:Add("DButton")
        panel.num = num
        panel:SetText("")
        panel:SetTall(H(30))
        panel:Dock(TOP)
        panel:DockMargin(0, 0, 0, H(0))
        panel.alpha = 0
        panel.Paint = function(_, w, h)
            if _.num % 2 == 0 then
                surface.SetDrawColor(255, 61, 96, 1)
                surface.DrawRect(0, 0, w, h)
            end

            _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() or self.activemenu == k) and 10 or 0)

            surface.SetDrawColor(255, 61, 96, _.alpha)
            surface.DrawRect(0, 0, w, h)

            if self.activemenu == k then
                surface.SetDrawColor(255, 61, 96, _.alpha * 5)
                surface.DrawOutlinedRect(0, 0, w, h)
            end

            draw.DrawText(v.name, "arb.Font_FuturaPTBook_7", W(10), H(4), color_white, TEXT_ALIGN_LEFT)
        end
        panel.DoClick = function()
            self.activemenu = k

            self:ClearTracks()
            self:UpdateTracks(k)
        end

        self.eventsPanel:AddItem(panel)
        num = num + 1
    end
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.startTime)
end

vgui.Register("ScriptMusic:MenuSub", PANEL, "EditablePanel")