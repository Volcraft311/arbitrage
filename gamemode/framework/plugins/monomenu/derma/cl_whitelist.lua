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

    Arbitrage.gui.whitelist = self
end

local deleteMat = Arbitrage.GetMaterial("danganronpa/ui/delete.png")
function PANEL:SetData(data)
    self.data = data
    self.data.players = self.data.players or {}
    self.data.settings = self.data.settings or false

    if IsValid(self.mainPanel) then self.mainPanel:Remove() end
    if IsValid(self.settingButton) then self.settingButton:Remove() end
    if IsValid(self.addButton) then self.addButton:Remove() end

    self.mainPanel = self:Add("Panel")
    self.mainPanel:SetWide(Arbitrage.ResolutionW(250))
    self.mainPanel:Dock(FILL)
    self.mainPanel:DockMargin(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(45), Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(5))
    self.mainPanel.Paint = function(_, w, h)
        surface.SetDrawColor(27, 10, 13, 150)
        surface.DrawRect(0, 0, w, h)
    end

    self.settingButton = self:Add("DButton")
    self.settingButton:SetText("")
    self.settingButton:SetTall(Arbitrage.ResolutionH(25))
    self.settingButton:Dock(BOTTOM)
    self.settingButton.alpha = 0
    self.settingButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("Сделать сервер: " .. (self.data.settings and "Приватным" or "Общедоступным"), "arb.Font_FuturaPTBook_8", w / 2, Arbitrage.ResolutionH(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    self.settingButton.DoClick = function()
        netstream.Start("arb.MonoSetSettings", !self.data.settings)
    end

    self.addButton = self:Add("DButton")
    self.addButton:DockMargin(0, Arbitrage.ResolutionH(5), 0, Arbitrage.ResolutionH(5))
    self.addButton:SetText("")
    self.addButton:SetTall(Arbitrage.ResolutionH(25))
    self.addButton:Dock(BOTTOM)
    self.addButton.alpha = 0
    self.addButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("Добавить нового участника в список Whitelist-а", "arb.Font_FuturaPTBook_8", w / 2, Arbitrage.ResolutionH(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    self.addButton.DoClick = function()
        vgui.Create("arb.MonoMenuWhiteListSub")
    end

    self.playersPanel = self.mainPanel:Add("DPanelList")
    self.playersPanel:EnableVerticalScrollbar()
    self.playersPanel:Dock(FILL)
    self.playersPanel:DockMargin(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(5), Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(5))

    local newData = data.players
    for k, v in pairs(PLUGIN.WhiteListStandart) do
        newData[k] = v
    end

    local num = 0
    for k, v in pairs(newData) do
        local steamid = k
        local name = v
        local steamid64 = util.SteamIDTo64(steamid)

        local panel = self.playersPanel:Add("Panel")
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

            draw.DrawText(steamid, "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(15), Arbitrage.ResolutionH(4), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
            draw.DrawText(name, "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(390), Arbitrage.ResolutionH(4), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
            draw.DrawText(steamid64, "arb.Font_FuturaPTBook_7", w - Arbitrage.ResolutionW(100), Arbitrage.ResolutionH(4), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
        end

        local bEdit = !PLUGIN.WhiteListStandart[steamid]

        local button = panel:Add("DButton")
        button:SetText("")
        button:Dock(RIGHT)
        button:DockMargin(0, 0, Arbitrage.ResolutionW(10), 0)
        button:SetWide(panel:GetTall())
        button.alpha = 0
        button.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)

            local color = !bEdit and Color(191, 60, 60) or Color(255, 255, 255, _.alpha)

            surface.SetDrawColor(color)
            surface.SetMaterial(deleteMat)
            surface.DrawTexturedRect(6, 6, w - 12, h - 12)
        end

        button.DoClick = function()
            if !bEdit then return end

            local dermaPanel = DermaMenu()
            dermaPanel:AddOption("Удалить из WhiteList-а", function()
                Arbitrage.Client():EmitSound(PLUGIN.ClickSound)
                netstream.Start("arb.MonoRemoveWhiteList", k)
            end)
            dermaPanel:Open()
        end

        self.playersPanel:AddItem(panel)

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

    draw.DrawText("WhiteList список", "arb.Font_FuturaPTDemi_8", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(3), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)

    draw.DrawText("SteamID", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(30), Arbitrage.ResolutionH(45), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    draw.DrawText("Описание", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(405), Arbitrage.ResolutionH(45), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    draw.DrawText("SteamID64", "arb.Font_FuturaPTBook_7", w - Arbitrage.ResolutionW(115), Arbitrage.ResolutionH(45), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
end

vgui.Register("arb.MonoMenuWhiteList", PANEL, "DFrame")



local PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self.startTime = SysTime()


    self.main = self:Add("Panel")
    self.main:SetPos(ScrW() / 2 - (Arbitrage.ResolutionW(600)) / 2, ScrH() / 2 - (Arbitrage.ResolutionH(250) / 2))
    self.main:SetSize(Arbitrage.ResolutionW(600), 0)

    local t = Arbitrage.ResolutionH(250)
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

        draw.DrawText("Добавить нового участника", "arb.Font_FuturaPTBook_5", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(3), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("Введите SteamID человека, которого вы хотите добавить в WhiteList", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(28), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
        draw.DrawText("Пример: STEAM_0:1:127526733", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText("Введите описание, которое будет отображаться рядом со SteamID", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(80 + 28), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
        draw.DrawText("Пример: Selenter", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(80 + 50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)
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

    self.steamidEntry = self.main:Add("DTextEntry")
    self.steamidEntry:SetPos(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(75))
    self.steamidEntry:SetSize(self.main:GetWide() - Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(25))
    self.steamidEntry:SetPlaceholderText("STEAM_0:0:00000")
    self.steamidEntry:SetFont("arb.Font_FuturaPTBook_8")

    self.descriptionEntry = self.main:Add("DTextEntry")
    self.descriptionEntry:SetPos(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(155))
    self.descriptionEntry:SetSize(self.main:GetWide() - Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(25))
    self.descriptionEntry:SetPlaceholderText("Описание")
    self.descriptionEntry:SetFont("arb.Font_FuturaPTBook_8")

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
        local a, b = self.steamidEntry:GetValue(), self.descriptionEntry:GetValue()
        if !string.find(a, "STEAM_(%d+):(%d+):(%d+)") then return end

        self:AlphaTo(0, 0.3, 0, function()
            self:Remove()
        end)

        netstream.Start("arb.MonoAddWhiteList", a, b)
    end
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.startTime)
end

vgui.Register("arb.MonoMenuWhiteListSub", PANEL, "EditablePanel")