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


local PANEL = {}

local size = 0.6
function PANEL:Init()
    if IsValid(Arbitrage.gui.workshop) then
        Arbitrage.gui.workshop:Remove()
    end

    Arbitrage.gui.workshop = self

    self:SetPos(0, 0)
    self:SetSize(W(800) * size, H(1080) * size)
    self:Center()
    self:MakePopup()
    self:SetTitle("")
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self:ShowCloseButton(false)

    self.panels = {}

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

    self.mainPanel = self:Add("DScrollPanel")
    self.mainPanel:SetWide(Arbitrage.ResolutionW(250))
    self.mainPanel:Dock(FILL)
    self.mainPanel:DockMargin(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(5), Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(5))
    self.mainPanel.Paint = function(_, w, h)
        surface.SetDrawColor(27, 10, 13, 150)
        surface.DrawRect(0, 0, w, h)
    end

    local addButton = self:Add("DButton")
    addButton:SetText("")
    addButton:SetTall(H(25))
    addButton:Dock(BOTTOM)
    addButton.alpha = 0
    addButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("Добавить новое дополнение", "arb.Font_FuturaPTBook_8", w / 2, Arbitrage.ResolutionH(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    addButton.DoClick = function()
        vgui.Create("WORKSHOP:MenuSub")
    end
end

function PANEL:SetData(data)
    self:CreateCategory("На проверке", function(category)
        for k, v in pairs(data[1]) do
            self:CreateUnderReview(category, k, v)
        end
    end)

    self:CreateCategory("Установлены", function(category)
        for k, v in pairs(data[2]) do
            self:CreateOnServer(category, k, v)
        end
    end)
end

local function panelInit(panel, id, author)
    panel.title = "Loading..."
    panel.tags = "Loading..."
    panel.size = 0
    panel.image = nil

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

        if panel.image then
            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(panel.image)
            surface.DrawTexturedRect(2, 2, h - 4, h - 4)
        end

        local _w = draw.SimpleText(panel.title, "arb.Font_FuturaPTDemi_9", h + 5, 0, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
        draw.SimpleText("(" .. id .. ")", "arb.Font_FuturaPTBook_7", _w + h + 15, H(4), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)

        draw.SimpleText(panel.tags, "arb.Font_FuturaPTBook_6", h + 5, H(25), Color(255, 255, 255, 80), TEXT_ALIGN_LEFT)
        draw.SimpleText("Добавил: " .. author, "arb.Font_FuturaPTBook_5", h + 5, H(43), Color(255, 255, 255, 100), TEXT_ALIGN_LEFT)
    end

    panel.DoClick = function()
        steamworks.ViewFile(id)
    end

    steamworks.FileInfo(id, function(data)
        if !IsValid(panel) then return end
        if !data then return end

        panel.title = data.title
        panel.tags = data.tags
        panel.size = string.NiceSize(data.previewsize)

        asterionlib.DownloadImage(data.previewurl, function(matPath, path)
            if !IsValid(panel) then return end

            panel.image = matPath
        end)
    end)
end

local _size = 10
local function paintButton(panel, img)
    panel:SetText("")
    panel:Dock(RIGHT)
    panel:DockMargin(0, H(_size), W(_size), H(_size))
    panel.size = 0.6
    panel.alpha = 30

    panel.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() and _:IsEnabled()) and 255 or 30)
        _.size = Lerp(FrameTime() * 10, _.size, (_:IsHovered() and _:IsEnabled()) and 0.7 or 0.6)

        local w_size, h_size = w * _.size, h * _.size

        surface.SetDrawColor(255, 255, 255, _.alpha)
        surface.SetMaterial(img)
        surface.DrawTexturedRect(w / 2 - w_size / 2, h / 2 - h_size / 2, w_size, h_size)
    end
end

function PANEL:CreateUnderReview(parent, id, author)
    local panel = parent:Add("DButton")
    panelInit(panel, id, author)

    local cancelButton = panel:Add("DButton")
    cancelButton:SetWide(panel:GetTall() - H(_size * 2))
    paintButton(cancelButton, Material("danganronpa/ui/info_1.png"))
    cancelButton.DoClick = function()
        netstream.Start("Workshop:Remove", id)
    end

    local acceptButton = panel:Add("DButton")
    acceptButton:SetWide(panel:GetTall() - H(_size * 2))
    paintButton(acceptButton, Material("danganronpa/ui/info_2.png"))
    acceptButton.DoClick = function()
        netstream.Start("Workshop:Install", id)
    end

    if !LocalPlayer():IsSuperAdmin() then
        acceptButton:SetEnabled(false)
        cancelButton:SetEnabled(false)
    end
end

function PANEL:CreateOnServer(parent, id, author)
    local panel = parent:Add("DButton")
    panelInit(panel, id, author)

    local deleteButton = panel:Add("DButton")
    deleteButton:SetWide(panel:GetTall() - H(_size * 2))
    paintButton(deleteButton, Material("danganronpa/ui/info_1.png"))
    deleteButton.DoClick = function()
        netstream.Start("Workshop:Remove", id)
    end

    if !LocalPlayer():IsSuperAdmin() then
        deleteButton:SetEnabled(false)
    end
end

function PANEL:CreateCategory(name, callback)
    local panel = self.mainPanel:Add("DPanel")
    panel:Dock(TOP)
    panel:SetTall(1000)
    panel:DockMargin(0, 0, 0, H(10))
    panel.Paint = function(_, w, h)
        surface.SetDrawColor(255, 61, 96, 50)
        surface.DrawOutlinedRect(0, 0, w, h, 1)
    end

    local title = panel:Add("DPanel")
    title:Dock(TOP)
    title.Paint = function(_, w, h)
        surface.SetDrawColor(255, 61, 96, 50)
        surface.DrawRect(0, 0, w, h)

        draw.SimpleText(name, "arb.Font_FuturaPTBook_7", 5, 0, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    end

    if callback then
        callback(panel)
    end

    panel.PerformLayout = function(_, w, h)
        panel:SizeToChildren(false, true)
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

    draw.DrawText("Авто добавление дополнений", "arb.Font_FuturaPTDemi_8", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(3), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
end

vgui.Register("WORKSHOP:Menu", PANEL, "DFrame")



local PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self.startTime = SysTime()

    local t = Arbitrage.ResolutionH(150)
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

        draw.DrawText("Добавить новое дополнение", "arb.Font_FuturaPTBook_5", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(3), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("Введите ID номер аддона", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(28), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
        draw.DrawText("Пример: 2838097694", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)
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

    self.addonidEntry = self.main:Add("DTextEntry")
    self.addonidEntry:SetPos(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(75))
    self.addonidEntry:SetSize(self.main:GetWide() - Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(25))
    self.addonidEntry:SetPlaceholderText("0000000000")
    self.addonidEntry:SetFont("arb.Font_FuturaPTBook_8")

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
        local a = self.addonidEntry:GetValue()
        if !tonumber(a) then return end

        self:AlphaTo(0, 0.3, 0, function()
            self:Remove()
        end)

        netstream.Start("Workshop:Add", a)
    end
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.startTime)
end

vgui.Register("WORKSHOP:MenuSub", PANEL, "EditablePanel")