--[[
        © Asterion Project 2021.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local matBG = Arbitrage.GetMaterial("danganronpa/note/bg.png")
local matYellow = Arbitrage.GetMaterial("danganronpa/note/yellow.png")
local matRed = Arbitrage.GetMaterial("danganronpa/note/red.png")

local size = 0.6

local actionList = {
    {
        {
            name = "❖ Сохранить данную страницу",
            onRun = function(data, panel)
                netstream.Start("arb.NoteAction", "SAVE_PAGE", data.entity, data.page, panel.note.title:GetValue(), panel.note.text:GetValue())
            end
        },
        {
            name = "√ Создать новую страницу",
            onCanRun = function(data, panel)
                return data.pages < NOTE_MAX_PAGES
            end,
            onRun = function(data, panel)
                netstream.Start("arb.NoteAction", "CREATE_PAGE", data.entity, data.page)
            end
        },
        {
            name = "⌦ Удалить последнюю страницу",
            onCanRun = function(data, panel)
                return data.pages > 1
            end,
            onRun = function(data, panel)
                netstream.Start("arb.NoteAction", "DELETE_PAGE", data.entity, data.page)
            end
        },
        {
            name = "☑ Добавить нового владельца",
            onCanRun = function(data, panel)
                return table.Count(panel.data.editors) < NOTE_MAX_EDITORS
            end,
            onRun = function(data, panel)
                local strPanel = Derma_StringRequest("Добавить нового Владельца", "Введите SteamID человека, которому вы хотите выдать полный доступ к своему блокноту.", "", function(text)
                    if !text then return end
                    if !string.find(text, "STEAM_") then return end

                    panel:AddEditorPanel(text)
                    netstream.Start("arb.NoteAction", "ADD_EDITOR", data.entity, text)
                end, nil, "Добавить", "Закрыть меню")
                strPanel.startTime = SysTime()

                strPanel.Paint = function(_, w, h)
                    Derma_DrawBackgroundBlur(_, _.startTime)

                    surface.SetDrawColor(235, 235, 235)
                    surface.SetMaterial(matYellow)
                    surface.DrawTexturedRect(0, 0, w, h)

                    surface.SetDrawColor(0, 0, 0, 185)
                    surface.DrawOutlinedRect(0, 0, w, h, 2)
                end

                strPanel:GetChildren()[4]:SetTextColor(Color(0, 0, 0, 200))
                strPanel:GetChildren()[5]:GetChildren()[1]:SetTextColor(Color(0, 0, 0, 185))
            end
        },
        {
            name = "✉ Перейти в режим чтение",
            onCanRun = function(data, panel)
                return table.Count(panel.data.editors) < NOTE_MAX_EDITORS
            end,
            onRun = function(data, panel)
                netstream.Start("arb.NoteAction", "READ_PAGE", data.entity, data.page)
            end
        }
    },
    {
        {
            name = "→ Следующая страница",
            onCanRun = function(data, panel)
                local nextPage = data.page + 1

                return data.pages >= nextPage
            end,
            onRun = function(data, panel)
                netstream.Start("arb.NoteAction", "CHANGE_PAGE", data.entity, data.page + 1, data.edit)
            end
        },
        {
            name = "← Предыдущая страница",
            onCanRun = function(data, panel)
                local previousPage = data.page - 1

                return previousPage > 0
            end,
            onRun = function(data, panel)
                netstream.Start("arb.NoteAction", "CHANGE_PAGE", data.entity, data.page - 1, data.edit)
            end
        },
        {
            name = "x Закрыть блокнот",
            onRun = function(data, panel)
                panel:AlphaTo(0, 0.3, 0, function()
                    panel:Remove()
                end)
            end
        }
    }
}

surface.CreateFont("arb.NoteTitleFont", {
    font = "Baskerville WGL4 BT",
    size = ScreenScale(14),
    extended = true,
    weight = 1000
})

surface.CreateFont("arb.NoteFont", {
    font = "Baskerville WGL4 BT",
    size = ScreenScale(7),
    extended = true,
    weight = 1000
})

local function GetFont(data)
    if NOTE_FONTS[data] then
        return NOTE_FONTS[data].font
    end

    return NOTE_FONTS[1].font
end

local PANEL = {}

function PANEL:Init()
    self:SetSize(Arbitrage.ResolutionW(1083 * size), Arbitrage.ResolutionH(1448 * size))
    self:SetAlpha(0)
    self:AlphaTo(255, 0.5, 0)

    self.main = self:Add("Panel")
    self.main:Dock(FILL)
    self.main:DockMargin(Arbitrage.ResolutionW(85), Arbitrage.ResolutionH(20), Arbitrage.ResolutionW(30), Arbitrage.ResolutionH(20))

    local titlePanel = self.main:Add("Panel")
    titlePanel:Dock(TOP)
    titlePanel:SetTall(Arbitrage.ResolutionH(60))
    titlePanel.Paint = function(_, w, h)
        draw.DrawText("Страница №" .. (self.data.page or 1), GetFont(self.data.font) .. 7, w, -2, Color(100, 100, 100), TEXT_ALIGN_RIGHT)

        surface.SetDrawColor(159, 159, 159)
        surface.DrawRect(w * 0.1, h - 2, w - (w * 0.1) * 2, 2)
    end

    self.title = titlePanel:Add("DTextEntry")
    self.title:Dock(FILL)
    self.title:SetDisabled(true)
    self.title:SetTextColor(Color(60, 60, 60))
    self.title:SetPaintBackground(false)

    local bottomPanel = self.main:Add("Panel")
    bottomPanel:Dock(BOTTOM)
    bottomPanel:SetTall(Arbitrage.ResolutionH(60))
    bottomPanel.Paint = function(_, w, h)
        surface.SetDrawColor(159, 159, 159)
        surface.DrawRect(w * 0.1, 0, w - (w * 0.1) * 2, 2)
    end

    local centerPanel = self.main:Add("Panel")
    centerPanel:Dock(FILL)
    centerPanel:DockMargin(0, Arbitrage.ResolutionH(20), 0, Arbitrage.ResolutionH(20))

    self.text = centerPanel:Add("DTextEntry")
    self.text:Dock(FILL)
    self.text:SetDisabled(true)
    self.text:SetVerticalScrollbarEnabled(true)
    self.text:SetMultiline(true)
    self.text:SetTextColor(Color(60, 60, 60))
    self.text:SetPaintBackground(false)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(matBG)
    surface.DrawTexturedRect(0, 0, w, h)
end

function PANEL:SetData(data)
    self.data = data

    self.title:SetValue(data.title)
    self.title:SetFont(GetFont(data.font) .. 14)

    self.text:SetValue(data.text)
    self.text:SetFont(GetFont(data.font) .. 7)
end

vgui.Register("arb.Note", PANEL, "EditablePanel")




local PANEL = {}

function PANEL:Init()
    self:SetSize(Arbitrage.ResolutionW(1683 * size), Arbitrage.ResolutionH(1448 * size))
    self:Center()
    self:MakePopup()

    self.attachment = self:Add("Panel")
    self.attachment:SetWide(Arbitrage.ResolutionW(610 * size))
    self.attachment:Dock(RIGHT)
    self.attachment:DockMargin(0, Arbitrage.ResolutionH(30), 0, Arbitrage.ResolutionH(30))

    local yellowPanel = self.attachment:Add("Panel")
    yellowPanel:SetSize(0, self:GetTall() * 0.65)
    yellowPanel.Paint = function(_, w, h)
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(matYellow)
        surface.DrawTexturedRect(0, 0, w, h)

        surface.SetDrawColor(0, 0, 0, 70)
        surface.DrawRect(0, 0, 10, h)
    end

    self.yellowPanel2 = yellowPanel

    self.yellowPanel = yellowPanel:Add("DScrollPanel")
    self.yellowPanel:Dock(FILL)

    self.infoPanel = yellowPanel:Add("Panel")
    self.infoPanel:SetTall(Arbitrage.ResolutionH(100))
    self.infoPanel:Dock(BOTTOM)
    self.infoPanel.Paint = function(_, w, h)
        draw.DrawText("Количество владельцев: " .. table.Count(self.data.editors) .. "/" .. NOTE_MAX_EDITORS, GetFont(self.data.font) .. 7, 25, Arbitrage.ResolutionH(3), Color(0, 0, 0, 155), TEXT_ALIGN_LEFT)
        draw.DrawText("Количество страниц: " .. self.data.pages .. "/" .. NOTE_MAX_PAGES, GetFont(self.data.font) .. 7, 25, Arbitrage.ResolutionH(23), Color(0, 0, 0, 155), TEXT_ALIGN_LEFT)
        draw.DrawText("Размер заголовка: " .. utf8.len(self.note.title:GetValue()) .. "/" .. NOTE_SIZE_TITLE, GetFont(self.data.font) .. 7, 25, Arbitrage.ResolutionH(43), Color(0, 0, 0, 155), TEXT_ALIGN_LEFT)
        draw.DrawText("Размер текста: " .. utf8.len(self.note.text:GetValue()) .. "/" .. NOTE_SIZE_TEXT, GetFont(self.data.font) .. 7, 25, Arbitrage.ResolutionH(63), Color(0, 0, 0, 155), TEXT_ALIGN_LEFT)
    end

    self.fontsPanel = yellowPanel:Add("DScrollPanel")
    self.fontsPanel:SetTall(Arbitrage.ResolutionH(120))
    self.fontsPanel:DockMargin(15, 0, 5, 5)
    self.fontsPanel:Dock(BOTTOM)
    self.fontsPanel.Paint = function(_, w, h)
        surface.SetDrawColor(0, 0, 0, 185)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    self.editorsPanel = yellowPanel:Add("DPanelList")
    self.editorsPanel:SetTall(Arbitrage.ResolutionH(180))
    self.editorsPanel:EnableVerticalScrollbar()
    self.editorsPanel:DockMargin(15, 0, 5, 5)
    self.editorsPanel:Dock(BOTTOM)
    self.editorsPanel.panels = {}
    self.editorsPanel.Paint = function(_, w, h)
        surface.SetDrawColor(0, 0, 0, 185)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    do
        local bar = self.yellowPanel:GetVBar()
        bar.Paint = function(_, w, h)
            surface.SetDrawColor(0, 0, 0, 100)
            surface.DrawRect(w * 0.2, bar.btnUp:GetTall(), w - w * 0.4, h - bar.btnUp:GetTall() * 2)
        end

        bar.btnUp.Paint = function() end
        bar.btnDown.Paint = function() end

        bar.btnGrip.Paint = function(_, w, h)
            surface.SetDrawColor(255, 255, 255, 100)
            surface.DrawRect(w * 0.2, 0, w - w * 0.4, h)
        end
    end

    self.redPanel = self.attachment:Add("DScrollPanel")
    self.redPanel:SetY(self:GetTall() * 0.65)
    self.redPanel:SetSize(0, self:GetTall() - self:GetTall() * 0.65 - Arbitrage.ResolutionH(60))
    self.redPanel.Paint = function(_, w, h)
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(matRed)
        surface.DrawTexturedRect(0, 0, w, h)

        surface.SetDrawColor(0, 0, 0, 100)

        if IsValid(self.yellowPanel) then
            surface.DrawRect(0, 0, w, 5)
            surface.DrawRect(0, 5, 10, h - 5)
        else
            surface.DrawRect(0, 0, 10, h)
        end

        draw.DrawText("Количество страниц: " .. self.data.pages, GetFont(self.data.font) .. 7, 25, h - Arbitrage.ResolutionH(25), Color(0, 0, 0, 155), TEXT_ALIGN_LEFT)
    end

    do
        local bar = self.redPanel:GetVBar()
        bar.Paint = function(_, w, h)
            surface.SetDrawColor(0, 0, 0, 100)
            surface.DrawRect(w * 0.2, bar.btnUp:GetTall(), w - w * 0.4, h - bar.btnUp:GetTall() * 2)
        end

        bar.btnUp.Paint = function() end
        bar.btnDown.Paint = function() end

        bar.btnGrip.Paint = function(_, w, h)
            surface.SetDrawColor(255, 255, 255, 100)
            surface.DrawRect(w * 0.2, 0, w - w * 0.4, h)
        end
    end

    timer.Simple(0.5, function()
        if !IsValid(yellowPanel) then return end

        yellowPanel.Think = function()
            local wide = yellowPanel:GetWide()
            local w = Lerp(FrameTime() * 5, wide, self.attachment:GetWide())
            yellowPanel:SetWide(w)
        end
    end)

    timer.Simple(1.3, function()
        if !IsValid(self.redPanel) then return end

        self.redPanel.Think = function()
            local wide = self.redPanel:GetWide()
            local w = Lerp(FrameTime() * 5, wide, self.attachment:GetWide() * 0.8)
            self.redPanel:SetWide(w)
        end
    end)

    timer.Simple(1.7, function()
        if IsValid(self.redPanel) then
            self.redPanel.Think = nil
        end

        if IsValid(self.yellowPanel) then
            yellowPanel.Think = nil
        end
    end)

    self.note = self:Add("arb.Note")

    Arbitrage.gui.note = self
end

function PANEL:AddEditorPanel(steamid)
    local panel = self.editorsPanel:Add("DCheckBoxLabel")
    panel:SetText(steamid)
    panel:SetFont(GetFont(self.data.font) .. 7)
    panel:Dock(TOP)
    panel:DockMargin(20, 0, 0, 0)
    panel:SetValue(true)
    panel:SetTextColor(Color(0, 0, 0, 185))
    panel.OnChange = function(_, value)
        if value then return end

        if LocalPlayer():SteamID() == steamid then
            return panel:SetValue(true)
        end

        netstream.Start("arb.NoteAction", "REMOVE_EDITOR", self.data.entity, steamid)
        panel:Remove()
    end

    self.editorsPanel:AddItem(panel)
    self.panels[#self.panels + 1] = panel

    return panel
end

function PANEL:SetData(data, bEdit)
    self.data = data

    self.note:SetData(data)

    if !bEdit then
        self.yellowPanel2:Remove()
    else
        self.note.title:SetDisabled(false)
        self.note.text:SetDisabled(false)
    end

    for k, v in pairs(self.panels or {}) do
        if IsValid(v) then
            v:Remove()
        end
    end

    for k, v in ipairs(NOTE_FONTS) do
        local panel = self.fontsPanel:Add("DButton")
        panel:SetText("")
        panel:SetFont(v.font .. 7)
        panel:Dock(TOP)
        panel.alpha = 185
        panel.width = 0
        panel.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() or self.data.font == k) and 255 or 185)

            draw.DrawText(v.name, v.font .. 7, 25, Arbitrage.ResolutionH(3), Color(0, 0, 0, _.alpha), TEXT_ALIGN_LEFT)

            surface.SetFont(v.font .. 7)
            local width = surface.GetTextSize(v.name)
            _.width = Lerp(FrameTime() * 5, _.width, (_:IsHovered() or self.data.font == k) and width or 0)

            surface.SetDrawColor(0, 0, 0, _.alpha)
            surface.DrawRect(25, h - 1, _.width, 1)
        end
        panel.DoClick = function(_, w, h)
            netstream.Start("arb.NoteAction", "CHANGE_FONT", data.entity, data.page, k)
        end
    end

    self.panels = {}

    if IsValid(self.editorsPanel) then
        for k, v in pairs(data.editors) do
            self:AddEditorPanel(k)
        end
    end

    for i = 1, 2 do
        if i == 1 and !bEdit then continue end

        for k, v in pairs(actionList[i]) do
            local selectPanel = i == 1 and self.yellowPanel or self.redPanel

            local panel = selectPanel:Add("DButton")
            panel:SetText("")
            panel:SetTall(Arbitrage.ResolutionH(30))
            panel:Dock(TOP)
            panel.alpha = 185
            panel.width = 0
            panel.onCan = true
            panel.Paint = function(_, w, h)
                _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() and _.onCan) and 230 or 185)

                draw.DrawText(v.name, GetFont(self.data.font) .. 7, 25, Arbitrage.ResolutionH(3), _.onCan and Color(0, 0, 0, _.alpha) or Color(255, 0, 0, _.alpha), TEXT_ALIGN_LEFT)

                surface.SetFont(GetFont(self.data.font) .. 7)
                local width = surface.GetTextSize(v.name)
                _.width = Lerp(FrameTime() * 5, _.width, (_:IsHovered() and _.onCan) and width or 0)

                surface.SetDrawColor(0, 0, 0, _.alpha)
                surface.DrawRect(25, h - 5, _.width, 1)
            end

            if v.onCanRun then
                panel.onCan = v.onCanRun(self.data, self)
            end

            panel.DoClick = function()
                if !panel.onCan then return end

                if v.onRun then
                    v.onRun(self.data, self)
                end
            end

            self.panels[#self.panels + 1] = panel
        end
    end
end

vgui.Register("arb.OpenNote", PANEL, "EditablePanel")