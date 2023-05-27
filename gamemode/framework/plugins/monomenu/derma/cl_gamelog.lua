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

function PANEL:Init()
    self:SetTitle("")
    self:SetPos(0, 0)
    self:SetSize(W(960 * 1.3), H(540 * 1.3))
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self:Center()
    self:ShowCloseButton(false)

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

    self:SetData()
end

local deleteMat = Material("danganronpa/ui/delete.png")
local editMat = Material("danganronpa/ui/settings.png")
function PANEL:SetData()
    if IsValid(self.mainPanel) then self.mainPanel:Remove() end
    if IsValid(self.addButton) then self.addButton:Remove() end

    self.mainPanel = self:Add("Panel")
    self.mainPanel:SetWide(W(250))
    self.mainPanel:Dock(FILL)
    self.mainPanel:DockMargin(W(5), H(45), W(5), H(5))
    self.mainPanel.Paint = function(_, w, h)
        surface.SetDrawColor(27, 10, 13, 150)
        surface.DrawRect(0, 0, w, h)
    end

    self.addButton = self:Add("DButton")
    self.addButton:DockMargin(0, H(5), 0, H(5))
    self.addButton:SetText("")
    self.addButton:SetTall(H(25))
    self.addButton:Dock(BOTTOM)
    self.addButton.alpha = 0
    self.addButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("Добавить новое дело", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    self.addButton.DoClick = function()
        local subMenu = vgui.Create("arb.MonoGameLogSub")
        subMenu:SetData(nil, nil, nil, nil, nil, function()
            self:SetData()
        end, nil)
    end

    self.gamelogPanel = self.mainPanel:Add("DScrollPanel")
    self.gamelogPanel:Dock(FILL)
    self.gamelogPanel:DockMargin(W(5), H(5), W(5), H(5))

    for k, v in ipairs(Arbitrage.GetGameLogs()) do
        local inflictorID, investigationType, time = v[1], v[3], v[5]
        local info = MonoPad.chapterTypes[investigationType]

        local inflictorFaction = Character.team:GetByID(inflictorID)
        local timeString = Arbitrage.FormatTime(time)

        local panel = self.gamelogPanel:Add("DPanel")
        panel:SetTall(H(30))
        panel:Dock(TOP)
        panel:DockMargin(0, 0, 0, 0)
        panel.Paint = function(_, w, h)
            if k % 2 == 0 then
                surface.SetDrawColor(255, 61, 96, 1)
                surface.DrawRect(0, 0, w, h)
            end

            draw.DrawText(k, "arb.Font_FuturaPTBook_7", W(15), H(4), color_white, TEXT_ALIGN_LEFT)
            draw.DrawText(inflictorFaction and inflictorFaction:GetName() or "Неизвестно", "arb.Font_FuturaPTBook_7", W(150 - 15), H(4), color_white, TEXT_ALIGN_LEFT)
            draw.DrawText(info[1], "arb.Font_FuturaPTBook_7", W(300 - 15), H(4), color_white, TEXT_ALIGN_LEFT)
            draw.DrawText(timeString, "arb.Font_FuturaPTBook_7", W(550 - 15), H(4), color_white, TEXT_ALIGN_LEFT)
        end

        local remove = panel:Add("DButton")
        remove:SetText("")
        remove:Dock(RIGHT)
        remove:DockMargin(0, 0, W(10), 0)
        remove:SetWide(panel:GetTall())
        remove.alpha = 0
        remove.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)

            surface.SetDrawColor(Color(255, 255, 255, _.alpha))
            surface.SetMaterial(deleteMat)
            surface.DrawTexturedRect(6, 6, w - 12, h - 12)
        end
        remove.DoClick = function()
            netstream.Start("arb.MonoRemoveGameLog", k)

            timer.Simple(0.5, function()
                self:SetData()
            end)
        end

        local edit = panel:Add("DButton")
        edit:SetText("")
        edit:Dock(RIGHT)
        edit:DockMargin(0, 0, W(10), 0)
        edit:SetWide(panel:GetTall())
        edit.alpha = 0
        edit.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)

            surface.SetDrawColor(Color(255, 255, 255, _.alpha))
            surface.SetMaterial(editMat)
            surface.DrawTexturedRect(6, 6, w - 12, h - 12)
        end
        edit.DoClick = function()
            local subMenu = vgui.Create("arb.MonoGameLogSub")
            subMenu:SetData(v[1], v[2], v[3], v[4], v[5], function()
                self:SetData()
            end, k)
        end
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

    draw.DrawText("Редактор журнала игры", "arb.Font_FuturaPTDemi_8", W(10), H(3), color_white, TEXT_ALIGN_LEFT)

    draw.DrawText("Номер", "arb.Font_FuturaPTBook_7", W(30), H(45), color_white, TEXT_ALIGN_LEFT)
    draw.DrawText("Персонаж", "arb.Font_FuturaPTBook_7", W(150), H(45), color_white, TEXT_ALIGN_LEFT)
    draw.DrawText("Статус", "arb.Font_FuturaPTBook_7", W(300), H(45), color_white, TEXT_ALIGN_LEFT)
    draw.DrawText("Время", "arb.Font_FuturaPTBook_7", W(550), H(45), color_white, TEXT_ALIGN_LEFT)
end

vgui.Register("arb.MonoGameLog", PANEL, "DFrame")

local PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self.startTime = SysTime()

    local t = H(470)
    self.main = self:Add("Panel")
    self.main:SetPos(ScrW() / 2 - (W(600)) / 2, ScrH() / 2 - (t / 2))
    self.main:SetSize(W(600), 0)

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

        draw.DrawText("Добавить новое дело", "arb.Font_FuturaPTBook_5", W(10), H(3), color_white, TEXT_ALIGN_LEFT)

        draw.DrawText("Выберете персонажа в деле", "arb.Font_FuturaPTBook_7", W(10), H(28), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText("Пример: Химико Юмено", "arb.Font_FuturaPTBook_7", W(10), H(50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("Введите название главы", "arb.Font_FuturaPTBook_7", W(10), H(80 + 28), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText("Пример: Потерянные цепи отчаяния", "arb.Font_FuturaPTBook_7", W(10), H(80 + 50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("Выбирете тип дела", "arb.Font_FuturaPTBook_7", W(10), H(80 + 28 + 80), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText("Пример: Активное расследование", "arb.Font_FuturaPTBook_7", W(10), H(80 + 50 + 80), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("Выберете винового персонажа", "arb.Font_FuturaPTBook_7", W(10), H(80 + 28 + 80 + 80), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText("Пример: Каэде Акамацу", "arb.Font_FuturaPTBook_7", W(10), H(80 + 50 + 80 + 80), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        if self.id then
            draw.DrawText("Укажите время начала дела в секундах", "arb.Font_FuturaPTBook_7", W(10), H(80 + 28 + 80 + 80 + 80), color_white, TEXT_ALIGN_LEFT)
            draw.DrawText("Пример: 1000", "arb.Font_FuturaPTBook_7", W(10), H(80 + 50 + 80 + 80 + 80), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)
        end
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

    self.inflictorBox = self.main:Add("DComboBox")
    self.inflictorBox:SetFont("arb.Font_FuturaPTBook_8")
    self.inflictorBox:SetPos(W(5), H(75))
    self.inflictorBox:SetSize(self.main:GetWide() - W(10), H(25))
    self.inflictorBox.OnSelect = function(_, index, value, data)
        self.inflictorID = data
    end

    self.chapterEntry = self.main:Add("DTextEntry")
    self.chapterEntry:SetPos(W(5), H(155))
    self.chapterEntry:SetSize(self.main:GetWide() - W(10), H(25))
    self.chapterEntry:SetPlaceholderText("Название главы")
    self.chapterEntry:SetFont("arb.Font_FuturaPTBook_8")

    self.investigationID = 2
    local sizeW = W(150)
    for k, v in ipairs(MonoPad.chapterTypes) do
        local button = self.main:Add("DButton")
        button:SetText(v[1])
        button:SetTextColor(color_white)
        button:SetPos(W(5) + (k - 1) * sizeW + (k - 1) * W(10), H(235))
        button:SetSize(sizeW, H(25))
        button.alpha = 0.1
        button.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() or self.investigationID == k) and 1 or 0.1)

            _:SetTextColor(Color(255, 255, 255, 255 * _.alpha))

            surface.SetDrawColor(15, 5, 6, 204)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(155, 35, 57, 255 * _.alpha)
            surface.DrawOutlinedRect(0, 0, w, h, 2)
        end
        button.DoClick = function()
            self.investigationID = k
        end
    end

    self.attackerBox = self.main:Add("DComboBox")
    self.attackerBox:SetFont("arb.Font_FuturaPTBook_8")
    self.attackerBox:SetPos(W(5), H(315))
    self.attackerBox:SetSize(self.main:GetWide() - W(10), H(25))
    self.attackerBox.OnSelect = function(_, index, value, data)
        self.attackerID = data
    end

    self.inflictorBox:AddChoice("Неизвестно", nil, true)
    self.attackerBox:AddChoice("Неизвестно", nil, true)
    for k, v in SortedPairsByMemberValue(Character.team.instances, "name") do
        if v:GetAssets().pixel then
            self.inflictorBox:AddChoice(v:GetName(), k)
            self.attackerBox:AddChoice(v:GetName(), k)
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
        draw.DrawText(self.id and "Изменить" or "Добавить", "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end

    submitButton.DoClick = function()
        local a, b, c, d, e, f = self.inflictorID, self.chapterEntry:GetValue(), tonumber(self.investigationID), self.attackerID, self.timeEntry and tonumber(self.timeEntry:GetValue()), self.id
        if !c then return end

        if string.Trim(b) == "" then
            b = "Отсутствует"
        end

        if !e then
            e = Arbitrage.ReturnTime()
        end

        netstream.Start(f and "arb.MonoEditGameLog" or "arb.MonoAddGameLog", {a, b, c, d, e, f})

        if !f and self.startInvestigation then
            netstream.Start("arb.MonoChangeStyle", "Расследование", 222, 27, 163)
            netstream.Start("ScriptMusic:ChangeTheme", "investigation", true)
        end

        local cb = self.callback
        timer.Simple(0.5, function()
            if cb then
                cb()
            end
        end)

        self:AlphaTo(0, 0.3, 0, function()
            self:Remove()
        end)
    end
end

function PANEL:SetData(inflictorID, chapterTitle, investigationType, attackerID, time, callback, id)
    if inflictorID then
        self.inflictorID = inflictorID
        self.inflictorBox:SetValue(Character.team:GetByID(inflictorID).name)
    end

    if chapterTitle then
        self.chapterEntry:SetValue(chapterTitle)
    end

    if investigationType then
        self.investigationID = investigationType
    end

    if attackerID then
        self.attackerID = attackerID
        self.attackerBox:SetValue(Character.team:GetByID(attackerID).name)
    end

    self.callback = callback
    self.id = id

    if self.id then
        self.timeEntry = self.main:Add("DTextEntry")
        self.timeEntry:SetValue(time or Arbitrage.ReturnTime())
        self.timeEntry:SetPos(W(5), H(395))
        self.timeEntry:SetSize(self.main:GetWide() - W(10), H(25))
        self.timeEntry:SetPlaceholderText("Время")
        self.timeEntry:SetFont("arb.Font_FuturaPTBook_8")
    else
        self.checkBox = self.main:Add("DCheckBoxLabel")
        self.checkBox:SetText("Запустить расследование")
        self.checkBox:SetPos(W(5), H(360))
        self.checkBox:SetSize(self.main:GetWide() - W(10), H(25))
        self.checkBox:SetFont("arb.Font_FuturaPTBook_8")
        self.checkBox.OnChange = function(_, val)
            self.startInvestigation = val
        end
    end
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.startTime)
end

vgui.Register("arb.MonoGameLogSub", PANEL, "EditablePanel")