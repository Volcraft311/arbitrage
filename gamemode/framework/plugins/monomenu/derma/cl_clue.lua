--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru (not work)
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local PLUGIN = PLUGIN

local PANEL = {}

function PANEL:Init()
    self:SetTitle("")
    self:SetPos(0, 0)
    self:SetSize(Arbitrage.ResolutionW(960 * 1.3), Arbitrage.ResolutionH(540 * 1.3))
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self:Center()
    self:ShowCloseButton(false)

    local close = self:Add("DButton")
    close:SetPos(self:GetWide() - Arbitrage.ResolutionH(70), 0)
    close:SetSize(Arbitrage.ResolutionH(70), Arbitrage.ResolutionH(30))
    close:SetText("")
    close.alpha = 40
    close.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 40)
        draw.DrawText("X", "arb.Font_FuturaPTBook_7", w / 2, Arbitrage.ResolutionH(4), Color(255, 255, 255, _.alpha), TEXT_ALIGN_LEFT)
    end
    close.DoClick = function()
        self:AlphaTo(0, 0.2, 0, function()
            self:Remove()
        end)
    end

    Arbitrage.gui.clue = self

    self:InitClue()
end

local deleteMat = Arbitrage.GetMaterial("danganronpa/ui/delete.png")
function PANEL:InitClue()
    if IsValid(self.mainPanel) then self.mainPanel:Remove() end
    if IsValid(self.createButton) then self.createButton:Remove() end
    if IsValid(self.addButton) then self.addButton:Remove() end

    self.mainPanel = self:Add("Panel")
    self.mainPanel:SetWide(Arbitrage.ResolutionW(250))
    self.mainPanel:Dock(FILL)
    self.mainPanel:DockMargin(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(45), Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(5))
    self.mainPanel.Paint = function(_, w, h)
        surface.SetDrawColor(27, 10, 13, 150)
        surface.DrawRect(0, 0, w, h)
    end

    self.createButton = self:Add("DButton")
    self.createButton:SetText("")
    self.createButton:SetTall(Arbitrage.ResolutionH(25))
    self.createButton:Dock(BOTTOM)
    self.createButton.alpha = 0
    self.createButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("Создать улику в мире", "arb.Font_FuturaPTBook_8", w / 2, Arbitrage.ResolutionH(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    self.createButton.DoClick = function()
        vgui.Create("arb.MonoMenuClueSubC")
    end

    self.addButton = self:Add("DButton")
    self.addButton:DockMargin(0, Arbitrage.ResolutionH(5), 0, Arbitrage.ResolutionH(5))
    self.addButton:SetText("")
    self.addButton:SetTall(Arbitrage.ResolutionH(25))
    self.addButton:Dock(BOTTOM)
    self.addButton.alpha = 0
    self.addButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("Зарегистрировать новую улику на сервере", "arb.Font_FuturaPTBook_8", w / 2, Arbitrage.ResolutionH(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    self.addButton.DoClick = function()
        vgui.Create("arb.MonoMenuClueSub")
    end

    self.cluePanel = self.mainPanel:Add("DPanelList")
    self.cluePanel:EnableVerticalScrollbar()
    self.cluePanel:Dock(FILL)
    self.cluePanel:DockMargin(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(5), Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(5))

    local num = 0
    for k, v in pairs(Arbitrage.evidence.data or {}) do
        local id = k
        local name = v.name
        local time = os.date( "%H:%M:%S - %d/%m/%Y", v.time)
        local creator = v.creator

        local d = Arbitrage.evidence.materials
        local mat = Arbitrage.GetMaterial(d[v.mat] and d[v.mat] or d[1])

        local panel = self.cluePanel:Add("Panel")
        panel.num = num
        panel:SetText("")
        panel:SetTall(Arbitrage.ResolutionH(30))
        panel:Dock(TOP)
        panel:DockMargin(0, 0, 0, Arbitrage.ResolutionH(0))
        panel.Paint = function(_, w, h)
            if _.num % 2 == 0 then
                surface.SetDrawColor(255, 61, 96, 1)
                surface.DrawRect(0, 0, w, h)
            end

            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(mat)
            surface.DrawTexturedRect(2, 2, h - 4, h - 4)

            draw.DrawText(name, "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(40), Arbitrage.ResolutionH(4), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
            draw.DrawText(id, "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(390), Arbitrage.ResolutionH(4), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
            draw.DrawText(creator, "arb.Font_FuturaPTBook_7", w - Arbitrage.ResolutionW(400), Arbitrage.ResolutionH(4), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
            draw.DrawText(time, "arb.Font_FuturaPTBook_7", w - Arbitrage.ResolutionW(95), Arbitrage.ResolutionH(4), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
        end

        local button = panel:Add("DButton")
        button:SetText("")
        button:Dock(RIGHT)
        button:DockMargin(0, 0, Arbitrage.ResolutionW(10), 0)
        button:SetWide(panel:GetTall())
        button.alpha = 0
        button.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)

            local color = Color(255, 255, 255, _.alpha)

            surface.SetDrawColor(color)
            surface.SetMaterial(deleteMat)
            surface.DrawTexturedRect(6, 6, w - 12, h - 12)
        end

        button.DoClick = function()
            local dermaPanel = DermaMenu()
            dermaPanel:AddOption("Удалить данную улику", function()
                LocalPlayer():EmitSound(PLUGIN.ClickSound)
                netstream.Start("arb.RemoveEvidence", id)

                timer.Simple(0.2, function()
                    if !IsValid(self) then return end

                    self:InitClue()
                end)
            end)
            dermaPanel:Open()
        end

        self.cluePanel:AddItem(panel)

        num = num + 1
    end
end


function PANEL:Paint(w, h)
    surface.SetDrawColor(41, 22, 25)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(255, 61, 96, 165.75)
    surface.DrawOutlinedRect(0, 0, w, h, 2)

    surface.SetDrawColor(255, 61, 96, 165.75)
    surface.DrawOutlinedRect(0, 0, w, Arbitrage.ResolutionH(30), 2)

    surface.SetDrawColor(255, 61, 96, 20)
    surface.DrawRect(0, 0, w, Arbitrage.ResolutionH(30))

    draw.DrawText("Меню улик", "arb.Font_FuturaPTDemi_8", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(3), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)

    draw.DrawText("Название улики", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(55), Arbitrage.ResolutionH(45), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    draw.DrawText("Уникальный ID", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(405), Arbitrage.ResolutionH(45), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    draw.DrawText("Создал", "arb.Font_FuturaPTBook_7", w - Arbitrage.ResolutionW(415), Arbitrage.ResolutionH(45), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
    draw.DrawText("Время создания", "arb.Font_FuturaPTBook_7", w - Arbitrage.ResolutionW(115), Arbitrage.ResolutionH(45), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
end

vgui.Register("arb.MonoMenuClue", PANEL, "DFrame")




local PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self.startTime = SysTime()

    self.matIndex = nil -- select mat

    local t = Arbitrage.ResolutionH(600)

    self.main = self:Add("Panel")
    self.main:SetPos(ScrW() / 2 - (Arbitrage.ResolutionW(600)) / 2, ScrH() / 2 - (t / 2))
    self.main:SetSize(Arbitrage.ResolutionW(600), 0)

    self.main.Think = function(panel)
        panel:SetTall(Lerp(FrameTime() * 10, panel:GetTall(), t))
    end

    self.main.Paint = function(panel, w, h)
        surface.SetDrawColor(41, 22, 25)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(255, 61, 96, 165.75)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        surface.SetDrawColor(255, 61, 96, 165.75)
        surface.DrawOutlinedRect(0, 0, w, Arbitrage.ResolutionH(23), 2)

        surface.SetDrawColor(255, 61, 96, 20)
        surface.DrawRect(0, 0, w, Arbitrage.ResolutionH(23))

        draw.DrawText("Зарегистрировать новую улику", "arb.Font_FuturaPTBook_5", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(3), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("Введите название улики", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(28), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
        draw.DrawText("Пример: Кровавый нож", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("Введите Уникальный ID улики", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(80 + 28), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
        draw.DrawText("Пример: knife", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(80 + 50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("Введите описание улики", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(80 + 80 + 28), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
        draw.DrawText("Пример: Описание", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(80 + 80 + 50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("Выберите материал улики", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(80 + 80 + 200), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    end

    local close = self.main:Add("DButton")
    close:SetPos(self.main:GetWide() - Arbitrage.ResolutionH(70 / 2), 0)
    close:SetSize(Arbitrage.ResolutionH(70 / 2), Arbitrage.ResolutionH(23))
    close:SetText("")
    close.alpha = 40
    close.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 40)
        draw.DrawText("X", "arb.Font_FuturaPTBook_5", w / 2, Arbitrage.ResolutionH(4), Color(255, 255, 255, _.alpha), TEXT_ALIGN_LEFT)
    end
    close.DoClick = function()
        self:AlphaTo(0, 0.2, 0, function()
            self:Remove()
        end)
    end

    self.nameEntry = self.main:Add("DTextEntry")
    self.nameEntry:SetPos(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(75))
    self.nameEntry:SetSize(self.main:GetWide() - Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(25))
    self.nameEntry:SetPlaceholderText("Кровавый нож")
    self.nameEntry:SetFont("arb.Font_FuturaPTBook_8")

    self.idEntry = self.main:Add("DTextEntry")
    self.idEntry:SetPos(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(155))
    self.idEntry:SetSize(self.main:GetWide() - Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(25))
    self.idEntry:SetPlaceholderText("knife ")
    self.idEntry:SetFont("arb.Font_FuturaPTBook_8")

    self.descEntry = self.main:Add("DTextEntry")
    self.descEntry:SetMultiline(true)
    self.descEntry:SetPos(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(235))
    self.descEntry:SetSize(self.main:GetWide() - Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(120))
    self.descEntry:SetPlaceholderText("Описание")
    self.descEntry:SetFont("arb.Font_FuturaPTBook_8")

    self.inPanel = self.main:Add("DScrollPanel")
    self.inPanel:SetPos(Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(390))
    self.inPanel:SetSize(self.main:GetWide() - Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(120))
    self.inPanel:SetAlpha(0)
    self.inPanel:AlphaTo(255, 0.3)

    local bar = self.inPanel:GetVBar()
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

    self.List = self.inPanel:Add("DIconLayout")
    self.List:Dock(FILL)
    self.List:SetSpaceY(5)
    self.List:SetSpaceX(5)

    for k, v in ipairs(Arbitrage.evidence.materials) do
        local mat = Arbitrage.GetMaterial(v)

        local ListItem = self.List:Add("DButton")
        ListItem:SetText("")
        ListItem:SetSize(Arbitrage.ResolutionW(55), Arbitrage.ResolutionH(55))
        ListItem.alpha = 0
        ListItem.index = k
        ListItem.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() or self.matIndex == _.index) and 100 or 0)

            surface.SetDrawColor(255, 61, 96, _.alpha)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(mat)
            surface.DrawTexturedRect(5, 5, w - 10, h - 10)

            surface.SetDrawColor(255, 61, 96, 50)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
        end

        ListItem.DoClick = function()
            self.matIndex = k
        end
    end

    local submitButton = self.main:Add("DButton")
    submitButton:DockMargin(0, Arbitrage.ResolutionH(5), 0, Arbitrage.ResolutionH(5))
    submitButton:SetText("")
    submitButton:SetTall(Arbitrage.ResolutionH(25))
    submitButton:Dock(BOTTOM)
    submitButton.alpha = 0
    submitButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("Добавить", "arb.Font_FuturaPTBook_8", w / 2, Arbitrage.ResolutionH(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end

    submitButton.DoClick = function()
        local a, b, c, d = self.nameEntry:GetValue(), self.idEntry:GetValue(), self.descEntry:GetValue(), self.matIndex
        if a == "" or b == "" or c == "" or !d then return end

        self:AlphaTo(0, 0.3, 0, function()
            self:Remove()
        end)

        netstream.Start("arb.CreateNewEvidence", b, {
            name = a,
            desc = c,
            mat = d
        })

        timer.Simple(0.2, function()
            if !IsValid(Arbitrage.gui.clue) then return end

            Arbitrage.gui.clue:InitClue()
        end)
    end
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.startTime)
end

vgui.Register("arb.MonoMenuClueSub", PANEL, "EditablePanel")

local PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self.startTime = SysTime()
    self.selected = ""

    local t = Arbitrage.ResolutionH(250)

    self.main = self:Add("Panel")
    self.main:SetPos(ScrW() / 2 - (Arbitrage.ResolutionW(600)) / 2, ScrH() / 2 - (t / 2))
    self.main:SetSize(Arbitrage.ResolutionW(600), 0)

    self.main.Think = function(panel)
        panel:SetTall(Lerp(FrameTime() * 10, panel:GetTall(), t))
    end

    self.main.Paint = function(panel, w, h)
        surface.SetDrawColor(41, 22, 25)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(255, 61, 96, 165.75)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        surface.SetDrawColor(255, 61, 96, 165.75)
        surface.DrawOutlinedRect(0, 0, w, Arbitrage.ResolutionH(23), 2)

        surface.SetDrawColor(255, 61, 96, 20)
        surface.DrawRect(0, 0, w, Arbitrage.ResolutionH(23))

        draw.DrawText("Создать улику в мире", "arb.Font_FuturaPTBook_5", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(3), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("Выберите нужную вам улику", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(28), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    end

    local close = self.main:Add("DButton")
    close:SetPos(self.main:GetWide() - Arbitrage.ResolutionH(70 / 2), 0)
    close:SetSize(Arbitrage.ResolutionH(70 / 2), Arbitrage.ResolutionH(23))
    close:SetText("")
    close.alpha = 40
    close.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 40)
        draw.DrawText("X", "arb.Font_FuturaPTBook_5", w / 2, Arbitrage.ResolutionH(4), Color(255, 255, 255, _.alpha), TEXT_ALIGN_LEFT)
    end
    close.DoClick = function()
        self:AlphaTo(0, 0.2, 0, function()
            self:Remove()
        end)
    end

    self.cluePanel = self.main:Add("DPanelList")
    self.cluePanel:EnableVerticalScrollbar()
    self.cluePanel:SetSpacing(5)
    self.cluePanel:Dock(FILL)
    self.cluePanel:DockMargin(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(55), Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(5))

    local submitButton = self.main:Add("DButton")
    submitButton:DockMargin(0, Arbitrage.ResolutionH(5), 0, Arbitrage.ResolutionH(5))
    submitButton:SetText("")
    submitButton:SetTall(Arbitrage.ResolutionH(25))
    submitButton:Dock(BOTTOM)
    submitButton.alpha = 0
    submitButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("Создать", "arb.Font_FuturaPTBook_8", w / 2, 0, Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end

    submitButton.DoClick = function()
        if self.selected == "" then return end

        netstream.Start("arb.CreateWorld", self.selected)

        self:AlphaTo(0, 0.3, 0, function()
            self:Remove()
        end)
    end

    for k, v in pairs(Arbitrage.evidence.data, {}) do
        local panel = self.cluePanel:Add("DButton")
        panel.id = k
        panel:SetText("")
        panel:Dock(TOP)
        panel:DockMargin(0, 0, 0, 5)
        panel:SetTall(Arbitrage.ResolutionH(25))
        panel.alpha = 0.2
        panel.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() or self.selected == panel.id) and 1 or 0.2)
            surface.SetDrawColor(255, 61, 96, 20 * _.alpha)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(255, 61, 96, 165.75 * _.alpha)
            surface.DrawOutlinedRect(0, 0, w, h, 2)

            draw.DrawText(v.name, "arb.Font_FuturaPTBook_8", 10, 0, Color(255, 220, 228, 255 * _.alpha), TEXT_ALIGN_LEFT)
            draw.DrawText(k, "arb.Font_FuturaPTBook_6", w - 10, Arbitrage.ResolutionH(2), Color(255, 220, 228, 255 * 0.2), TEXT_ALIGN_RIGHT)
        end

        panel.DoClick = function()
            self.selected = panel.id
        end

        self.cluePanel:AddItem(panel)
    end
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.startTime)
end

vgui.Register("arb.MonoMenuClueSubC", PANEL, "EditablePanel")