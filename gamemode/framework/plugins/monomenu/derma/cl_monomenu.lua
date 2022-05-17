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

    Arbitrage.gui.monomenu = self
end

function PANEL:InitPlayersCategory()
    if IsValid(self.charactersPanel) then self.charactersPanel:Remove() end
    if IsValid(self.notcharactersPanel) then self.notcharactersPanel:Remove() end
    if IsValid(self.monoList) then self.monoList:Remove() end

    self.charactersPanel = self.playersPanel:Add("Panel")
    self.charactersPanel:SetTall(Arbitrage.ResolutionH(22))
    self.charactersPanel:DockMargin(0, 0, 0, Arbitrage.ResolutionH(35))
    self.charactersPanel:Dock(TOP)
    self.charactersPanel.pl = {}
    self.charactersPanel.Paint = function(_, w, h)
        draw.DrawText("В игре", "arb.Font_FuturaPTBook_6", w / 2, 0, Color(255, 255, 255, 50), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 255, 255, 50)
        surface.DrawRect(w * 0.15, 22 - 2, w - w * 0.3, 2)
    end

    self.notcharactersPanel = self.playersPanel:Add("Panel")
    self.notcharactersPanel:SetTall(Arbitrage.ResolutionH(22))
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
    self.mainPanel:DockMargin(0, Arbitrage.ResolutionH(4), 0, 0)

    local _ = self.mainPanel:Add("Panel")
    _:SetWide(Arbitrage.ResolutionW(300))
    _:Dock(LEFT)
    _:DockMargin(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(45), Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(5))
    _.Paint = function(_, w, h)
        surface.SetDrawColor(27, 10, 13, 150)
        surface.DrawRect(0, 0, w, h)
    end

    self.gamePanel = _:Add("DScrollPanel")
    self.gamePanel:SetPadding(Arbitrage.ResolutionH(5))
    self.gamePanel:Dock(FILL)
    self.gamePanel:DockMargin(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(5), Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(5))

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
    _:SetWide(Arbitrage.ResolutionW(250))
    _:Dock(LEFT)
    _:DockMargin(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(45), Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(5))
    _.Paint = function(_, w, h)
        surface.SetDrawColor(27, 10, 13, 150)
        surface.DrawRect(0, 0, w, h)
    end

    self.adminPanel = _:Add("DScrollPanel")
    self.adminPanel:SetPadding(Arbitrage.ResolutionH(5))
    self.adminPanel:Dock(FILL)
    self.adminPanel:DockMargin(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(5), Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(5))

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
    _:DockMargin(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(45), Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(5))
    _.Paint = function(_, w, h)
        surface.SetDrawColor(27, 10, 13, 150)
        surface.DrawRect(0, 0, w, h)
    end

    self.playersPanel = _:Add("DScrollPanel")
    self.playersPanel:SetPadding(Arbitrage.ResolutionH(25))
    self.playersPanel:Dock(FILL)
    self.playersPanel:DockMargin(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(5), Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(5))

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
    actionButton:SetWide(Arbitrage.ResolutionW(30))
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

        LocalPlayer():EmitSound(PLUGIN.ClickSound)

        self.monoList = vgui.Create("arb.MonoMenuList")
        self.monoList:SetPos(gui.MouseX(), gui.MouseY())
        self.monoList:SetPlayer(data)
    end
end

function PANEL:SetData(data)
    self:ClearCategory()
    self:InitPlayersCategory()

    self.data = data

    local count = -1
    for i = 1, 2 do
        local tableData = i == 1 and PLUGIN.GameData or PLUGIN.AdminData

        for k, v in ipairs(tableData) do
        	count = count + 1

        	timer.Simple(count * 0.01, function()
        		if !IsValid(self) then return end

	            local allow = true
	            if v.onCreate then
	                local bState = v.onCreate(LocalPlayer())

	                if !bState then
	                    allow = false
	                end
	            end

	            local h = Arbitrage.ResolutionH(30)
	            local text = isfunction(v.data) and v.data(client) or tostring(v.data)
	            local alpha = v.onRun and 255 or 150

	            local parsed = asterionlib.markup.Parse("<font=arb.Font_FuturaPTBook_7><colour=" .. alpha .. ", " .. alpha .. ", " .. alpha .. "><img=materials/" .. v.icon .. ", " .. h / 2 .. "x" .. h / 2 .. ", 255, 255, 255>  - " .. text .. "</colour></font>")

	            local panel_add = i == 1 and self.gamePanel or self.adminPanel

	            local button = panel_add:Add((v.onRun and allow) and "DButton" or "DPanel")
	            button:SetText("")
	            button:SetTall(Arbitrage.ResolutionH(30))
	            button:Dock(TOP)
	            button:DockMargin(0, 0, 0, Arbitrage.ResolutionH(5))
	            button.alpha = 0
	            button.Paint = function(_, w, h)
	                _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() and v.onRun and allow) and 200 or 0)

	                surface.SetDrawColor(27, 10, 13, _.alpha)
	                surface.DrawRect(0, 0, w, h)

	                parsed:draw(Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(4), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)

	                if !allow then
	                    surface.SetDrawColor(255, 0, 0, 20)
	                    surface.DrawRect(0, 0, w, h)
	                end
	            end

	            button.DoClick = function()
	                if v.onRun then
	                    LocalPlayer():EmitSound(PLUGIN.ClickSound)
	                    v.onRun(client)

	                    netstream.Start("arb.MonoRunCommandC", i, k)
	                end
	            end
	        end)
        end
    end

    local num = 1
    for k, v in pairs(data.character) do
        local factionData = Arbitrage.teams.Get(v.faction)
        local nameColor = (IsValid(v.client) and v.client:IsAdmin()) and Color(86, 191, 223) or Color(255, 255, 255)
        local aliveColor = (IsValid(v.client) and v.client:Alive()) and Color(71, 235, 117) or Color(204, 99, 99)
        local placeColor = v.place > 0 and Color(255, 255, 255) or (v.place == 0 and Color(86, 191, 223) or Color(242, 73, 73))

        local panel = self.charactersPanel:Add("Panel")
        panel:SetTall(Arbitrage.ResolutionH(30))
        panel:Dock(TOP)
        panel:DockMargin(0, num == 1 and Arbitrage.ResolutionH(25) or 0, 0, 0)
        panel.Paint = function(_, w, h)
            if num % 2 == 0 then
                surface.SetDrawColor(255, 61, 96, 1)
                surface.DrawRect(0, 0, w, h)
            end

            local circle = Arbitrage.hud.GeneratePoly(w - panel:GetTall() / 3 * 6, Arbitrage.ResolutionH(5) + panel:GetTall() / 3, panel:GetTall() / 3, 360)

            surface.SetDrawColor(aliveColor)
            draw.NoTexture()
            surface.DrawPoly(circle)

            draw.DrawText(v.steamname .. " (" .. v.steamid .. ")", "arb.Font_FuturaPTBook_5", Arbitrage.ResolutionW(45), Arbitrage.ResolutionH(8), nameColor, TEXT_ALIGN_LEFT)
            draw.DrawText(factionData.name, "arb.Font_FuturaPTBook_5", w / 2, Arbitrage.ResolutionH(8), Color(255, 255, 255), TEXT_ALIGN_CENTER)
            draw.DrawText("Место на суде: " .. v.place, "arb.Font_FuturaPTBook_5", w / 2 + Arbitrage.ResolutionW(200), Arbitrage.ResolutionH(8), placeColor, TEXT_ALIGN_CENTER)
        end

        local mat = (factionData and factionData.pixel) and Material(factionData.pixel) or nil

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
        local factionData = Arbitrage.teams.Get(v.faction)
        local nameColor = v.client:IsAdmin() and Color(86, 191, 223) or Color(255, 255, 255)
        local aliveColor = v.client:Alive() and Color(71, 235, 117) or Color(204, 99, 99)

        local panel = self.notcharactersPanel:Add("Panel")
        panel:SetTall(Arbitrage.ResolutionH(30))
        panel:Dock(TOP)
        panel:DockMargin(0, num == 1 and Arbitrage.ResolutionH(25) or 0, 0, 0)
        panel.Paint = function(_, w, h)
            if num % 2 == 0 then
                surface.SetDrawColor(255, 61, 96, 1)
                surface.DrawRect(0, 0, w, h)
            end

            local circle = Arbitrage.hud.GeneratePoly(w - panel:GetTall() / 3 * 6, Arbitrage.ResolutionH(5) + panel:GetTall() / 3, panel:GetTall() / 3, 360)

            surface.SetDrawColor(aliveColor)
            draw.NoTexture()
            surface.DrawPoly(circle)

            draw.DrawText(v.steamname .. " (" .. v.steamid .. ")", "arb.Font_FuturaPTBook_5", Arbitrage.ResolutionW(45), Arbitrage.ResolutionH(8), nameColor, TEXT_ALIGN_LEFT)
            draw.DrawText(factionData.name, "arb.Font_FuturaPTBook_5", w / 2, Arbitrage.ResolutionH(8), Color(255, 255, 255), TEXT_ALIGN_CENTER)
        end

        local mat = (factionData and factionData.pixel) and Material(factionData.pixel) or nil

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
    surface.DrawOutlinedRect(0, 0, w, Arbitrage.ResolutionH(30), 2)

    surface.SetDrawColor(255, 61, 96, 20)
    surface.DrawRect(0, 0, w, Arbitrage.ResolutionH(30))

    draw.DrawText("Моно-Меню (Панель администрации)", "arb.Font_FuturaPTDemi_8", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(3), c, TEXT_ALIGN_LEFT)

    draw.DrawText("Игровое меню", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(130), Arbitrage.ResolutionH(45), c, TEXT_ALIGN_CENTER)
    draw.DrawText("Админ-способности", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(390), Arbitrage.ResolutionH(45), c, TEXT_ALIGN_CENTER)
    draw.DrawText("Взаимодействие с игроками", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(900), Arbitrage.ResolutionH(45), c, TEXT_ALIGN_CENTER)
end

vgui.Register("arb.MonoMenu", PANEL, "DFrame")