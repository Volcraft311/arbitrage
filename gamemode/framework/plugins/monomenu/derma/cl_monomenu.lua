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

    Arbitrage.gui.monomenu = self
end

function PANEL:InitPlayersCategory()
    if IsValid(self.charactersPanel) then self.charactersPanel:Remove() end
    if IsValid(self.notcharactersPanel) then self.notcharactersPanel:Remove() end
    if IsValid(self.monoList) then self.monoList:Remove() end

    self.charactersPanel = self.playersPanel:Add("Panel")
    self.charactersPanel:SetTall(H(22))
    self.charactersPanel:DockMargin(0, 0, 0, H(35))
    self.charactersPanel:Dock(TOP)
    self.charactersPanel.pl = {}
    self.charactersPanel.Paint = function(_, w, h)
        draw.DrawText("В игре", "arb.Font_FuturaPTBook_6", w / 2, 0, Color(255, 255, 255, 50), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 255, 255, 50)
        surface.DrawRect(w * 0.15, 22 - 2, w - w * 0.3, 2)
    end

    self.notcharactersPanel = self.playersPanel:Add("Panel")
    self.notcharactersPanel:SetTall(H(22))
    self.notcharactersPanel:Dock(TOP)
    self.notcharactersPanel.Paint = function(_, w, h)
        draw.DrawText("Остальные", "arb.Font_FuturaPTBook_6", w / 2, 0, Color(255, 255, 255, 50), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 255, 255, 50)
        surface.DrawRect(w * 0.15, 22 - 2, w - w * 0.3, 2)
    end
end

function PANEL:ClearCategory()
    if IsValid(self.mainPanel) then self.mainPanel:Remove() end

    self.mainPanel = self:Add("Panel")
    self.mainPanel:Dock(FILL)
    self.mainPanel:DockMargin(0, H(4), 0, 0)

    local _ = self.mainPanel:Add("Panel")
    _:SetWide(W(300))
    _:Dock(LEFT)
    _:DockMargin(W(5), H(45), W(5), H(5))
    _.Paint = function(_, w, h)
        surface.SetDrawColor(27, 10, 13, 150)
        surface.DrawRect(0, 0, w, h)
    end

    self.gamePanel = _:Add("DScrollPanel")
    self.gamePanel:SetPadding(H(5))
    self.gamePanel:Dock(FILL)
    self.gamePanel:DockMargin(W(5), H(5), W(5), H(5))

    do
        local bar = self.gamePanel:GetVBar()
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

    local _ = self.mainPanel:Add("Panel")
    _:SetWide(W(250))
    _:Dock(LEFT)
    _:DockMargin(W(5), H(45), W(5), H(5))
    _.Paint = function(_, w, h)
        surface.SetDrawColor(27, 10, 13, 150)
        surface.DrawRect(0, 0, w, h)
    end

    self.adminPanel = _:Add("DScrollPanel")
    self.adminPanel:SetPadding(H(5))
    self.adminPanel:Dock(FILL)
    self.adminPanel:DockMargin(W(5), H(5), W(5), H(5))

    do
        local bar = self.adminPanel:GetVBar()
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

    local _ = self.mainPanel:Add("Panel")
    _:Dock(FILL)
    _:DockMargin(W(5), H(45), W(5), H(5))
    _.Paint = function(_, w, h)
        surface.SetDrawColor(27, 10, 13, 150)
        surface.DrawRect(0, 0, w, h)
    end

    self.playersPanel = _:Add("DScrollPanel")
    self.playersPanel:SetPadding(H(25))
    self.playersPanel:Dock(FILL)
    self.playersPanel:DockMargin(W(5), H(5), W(5), H(5))

    do
        local bar = self.playersPanel:GetVBar()
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
end

local settingMat = Material("danganronpa/ui/settings.png")
function PANEL:AddAction(panel, data, bInGame)
    data.ingame = bInGame

    local actionButton = panel:Add("DButton")
    actionButton:SetText("")
    actionButton:SetWide(W(30))
    actionButton:Dock(RIGHT)
    actionButton.alpha = 0
    actionButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)

        surface.SetDrawColor(255, 255, 255, _.alpha)
        surface.SetMaterial(settingMat)
        surface.DrawTexturedRect(6, 6, w - 12, h - 12)
    end

    actionButton.DoClick = function()
        if IsValid(self.monoList) then self.monoList:Remove() end

        asterionlib.EmitSound(PLUGIN.ClickSound)

        PLUGIN:OpenEntityMenu(data)
    end
end

function PANEL:SetData(data)
    local client = LocalPlayer()

    self:ClearCategory()
    self:InitPlayersCategory()

    self.data = data

    for i = 1, 2 do
        local tableData = i == 1 and PLUGIN.GameData or PLUGIN.AdminData

        for k, v in ipairs(tableData) do
            local allow = true
            if v.onCreate then
                local bState = v.onCreate(client)

                if !bState then
                    allow = false
                end
            end

            local h = H(30)
            local text = isfunction(v.data) and v.data(client) or tostring(v.data)
            local alpha = 255

            local panel_add = i == 1 and self.gamePanel or self.adminPanel

            local panel = panel_add:Add("DPanel")
            panel:SetTall(H(30))
            panel:Dock(TOP)
            panel:DockMargin(0, 0, 0, H(5))
            panel.alpha = 0

            local a = panel:GetTall() * 0.25
            local icon = panel:Add("DImage")
            icon:Dock(LEFT)
            icon:DockMargin(a, a, a, a)
            icon:SetWide(panel:GetTall() - a * 2)
            icon:SetImage(v.icon)

            local isCheckBox = v.isCheckBox
            local CheckPanel = nil -- PerformLayout size
            if isCheckBox then
                local tall = H(7)

                CheckPanel = panel:Add("DPanel")
                CheckPanel:Dock(RIGHT)
                CheckPanel.Paint = function(_, w, h)
                    local color = v.OnCheck(client) and Color(42, 255, 42) or Color(223, 50, 50)

                    surface.SetDrawColor(color)
                    surface.DrawRect(tall, tall, w - tall * 2, h - tall * 2)
                end
            end

            local button = panel:Add(((v.onRun and allow) or isCheckBox) and "DButton" or "DPanel")
            button:SetText("")
            button:SetPos(0, 0)
            button:SetSize(panel:GetWide(), panel:GetTall())
            button.Paint = function()
            end

            button.DoClick = function()
                local function Csound()
                    asterionlib.EmitSound(PLUGIN.ClickSound)
                end

                if isCheckBox then
                    Csound()

                    local func = v.OnCheck(client) and v.onDisable or v.onEnable
                    func(client)

                    netstream.Start("arb.MonoRunCommandC", i, k)
                else
                    if v.onRun then
                        Csound()
                        v.onRun(client)

                        netstream.Start("arb.MonoRunCommandC", i, k)
                    end
                end
            end

            panel.PerformLayout = function(_, w, h)
                button:SetSize(w, h)

                if CheckPanel then
                    CheckPanel:SetSize(h, h)
                end
            end

            panel.Paint = function(_, w, h)
                _.alpha = Lerp(FrameTime() * 10, _.alpha, (button:IsHovered() and ((v.onRun and allow) or isCheckBox)) and 200 or 0)

                surface.SetDrawColor(27, 10, 13, _.alpha)
                surface.DrawRect(0, 0, w, h)

                draw.DrawText(text, "arb.Font_FuturaPTBook_7", panel:GetTall(), H(4), Color(alpha, alpha, alpha), TEXT_ALIGN_LEFT)

                if !allow then
                    surface.SetDrawColor(255, 0, 0, 20)
                    surface.DrawRect(0, 0, w, h)
                end
            end
        end
    end

    local num = 1
    for k, v in pairs(data.character) do
        local factionData = Character.team:GetByID(v.faction)
        local nameColor = (IsValid(v.client) and v.client:IsAdmin()) and Color(86, 191, 223) or Color(255, 255, 255)
        local factionColor = IsPlaying(v.faction) and Color(255, 255, 255) or Color(255, 0, 0)
        local aliveColor = (v.alive and IsValid(v.client)) and Color(71, 235, 117) or Color(204, 99, 99)
        local placeColor = v.place > 0 and Color(255, 255, 255) or (v.place == 0 and Color(86, 191, 223) or Color(242, 73, 73))

        local panel = self.charactersPanel:Add("Panel")
        panel:SetTall(H(30))
        panel:Dock(TOP)
        panel:DockMargin(0, num == 1 and H(25) or 0, 0, 0)
        panel.Paint = function(_, w, h)
            if num % 2 == 0 then
                surface.SetDrawColor(255, 61, 96, 1)
                surface.DrawRect(0, 0, w, h)
            end

            local circle = Arbitrage.hud.GeneratePoly(w - panel:GetTall() / 3 * 6, H(5) + panel:GetTall() / 3, panel:GetTall() / 3, 360)

            surface.SetDrawColor(aliveColor)
            draw.NoTexture()
            surface.DrawPoly(circle)

            draw.DrawText(v.steamname .. " (" .. v.steamid .. ")", "arb.Font_FuturaPTBook_5", W(45), H(8), nameColor, TEXT_ALIGN_LEFT)
            draw.DrawText(factionData.name, "arb.Font_FuturaPTBook_5", w / 2, H(8), factionColor, TEXT_ALIGN_CENTER)
            draw.DrawText("Место на суде: " .. v.place, "arb.Font_FuturaPTBook_5", w / 2 + W(200), H(8), placeColor, TEXT_ALIGN_CENTER)
        end

        local mat = (factionData and factionData:GetAssets().pixel) and Material(factionData:GetAssets().pixel) or nil

        local modelPanel = panel:Add("Panel")
        modelPanel:SetWide(panel:GetTall())
        modelPanel:Dock(LEFT)
        modelPanel.Paint = function(_, w, h)
            if mat and !mat:IsError() then
                surface.SetDrawColor(255, 255, 255)
                surface.SetMaterial(mat)
                surface.DrawTexturedRect(0, 0, w, h)
            end
        end

        self:AddAction(panel, v, true)

        self.charactersPanel:SetTall(self.charactersPanel:GetTall() + panel:GetTall())
        num = num + 1
    end

    num = 1
    for k, v in pairs(data.notcharacter) do
        local factionData = Character.team:GetByID(v.faction)
        local nameColor = v.client:IsAdmin() and Color(86, 191, 223) or Color(255, 255, 255)
        local aliveColor = v.client:Alive() and Color(71, 235, 117) or Color(204, 99, 99)

        local panel = self.notcharactersPanel:Add("Panel")
        panel:SetTall(H(30))
        panel:Dock(TOP)
        panel:DockMargin(0, num == 1 and H(25) or 0, 0, 0)
        panel.Paint = function(_, w, h)
            if num % 2 == 0 then
                surface.SetDrawColor(255, 61, 96, 1)
                surface.DrawRect(0, 0, w, h)
            end

            local circle = Arbitrage.hud.GeneratePoly(w - panel:GetTall() / 3 * 6, H(5) + panel:GetTall() / 3, panel:GetTall() / 3, 360)

            surface.SetDrawColor(aliveColor)
            draw.NoTexture()
            surface.DrawPoly(circle)

            draw.DrawText(v.steamname .. " (" .. v.steamid .. ")", "arb.Font_FuturaPTBook_5", W(45), H(8), nameColor, TEXT_ALIGN_LEFT)
            draw.DrawText(factionData.name, "arb.Font_FuturaPTBook_5", w / 2, H(8), Color(255, 255, 255), TEXT_ALIGN_CENTER)
        end

        local mat = (factionData and factionData:GetAssets().pixel) and Material(factionData:GetAssets().pixel) or nil

        local modelPanel = panel:Add("Panel")
        modelPanel:SetWide(panel:GetTall())
        modelPanel:Dock(LEFT)
        modelPanel.Paint = function(_, w, h)
            if mat and !mat:IsError() then
                surface.SetDrawColor(255, 255, 255)
                surface.SetMaterial(mat)
                surface.DrawTexturedRect(0, 0, w, h)
            end
        end

        self:AddAction(panel, v, false)

        self.notcharactersPanel:SetTall(self.notcharactersPanel:GetTall() + panel:GetTall())
        num = num + 1
    end
end

local c = Color(255, 255, 255, 255)
function PANEL:Paint(w, h)
    surface.SetDrawColor(41, 22, 25)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(255, 61, 96, 165.75)
    surface.DrawOutlinedRect(0, 0, w, h, 2)

    surface.SetDrawColor(255, 61, 96, 165.75)
    surface.DrawOutlinedRect(0, 0, w, H(30), 2)

    surface.SetDrawColor(255, 61, 96, 20)
    surface.DrawRect(0, 0, w, H(30))

    draw.DrawText("Моно-Меню (Панель администрации)", "arb.Font_FuturaPTDemi_8", W(10), H(3), c, TEXT_ALIGN_LEFT)

    draw.DrawText("Игровое меню", "arb.Font_FuturaPTBook_7", W(130), H(45), c, TEXT_ALIGN_CENTER)
    draw.DrawText("Админ-способности", "arb.Font_FuturaPTBook_7", W(390), H(45), c, TEXT_ALIGN_CENTER)
    draw.DrawText("Взаимодействие с игроками", "arb.Font_FuturaPTBook_7", W(900), H(45), c, TEXT_ALIGN_CENTER)
end

vgui.Register("arb.MonoMenu", PANEL, "DFrame")