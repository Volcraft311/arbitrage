local matBG = Arbitrage.GetMaterial("danganronpa/ui/bg.png")

local PANEL = {}

-- function PANEL:CreateText(text, x, y, alpha)
--     for i = 1, 2 do
--         draw.DrawText(text, "arb.LawTimerFontBlur", x, y, Color(254, 110, 21, alpha), TEXT_ALIGN_CENTER)
--     end

--     draw.DrawText(text, "arb.LawTimerFont", x, y, Color(255, 238, 177, alpha), TEXT_ALIGN_CENTER)
-- end

function PANEL:Init()
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()

    self:SetAlpha(0)
    self:AlphaTo(255, 0.5, 0)
    self.startTime = RealTime() + 60

    Arbitrage.gui.votescreen = self

    local mainPanel = self:Add("Panel")
    mainPanel:Dock(FILL)
    mainPanel:DockMargin(W(220), H(60), W(150), H(180))

    local titlePanel = mainPanel:Add("Panel")
    titlePanel:SetTall(H(60))
    titlePanel:Dock(TOP)
    titlePanel.Paint = function(_, w, h)
        draw.DrawText("ВРЕМЯ ГОЛОСОВАТЬ", "arb.Font_FuturaPTDemi_15", 0, 0, Color(255, 255, 255), TEXT_ALIGN_LEFT)
        draw.DrawText("Выбираем того, кто является убийцей", "arb.Font_FuturaPTBook_10", W(380), H(10), Color(255, 255, 255, 50), TEXT_ALIGN_LEFT)
    end

    self.timerPanel = titlePanel:Add("Panel")
    self.timerPanel:SetWide(W(190))
    self.timerPanel:Dock(RIGHT)
    self.timerPanel.Paint = function(_, w, h)
        surface.SetDrawColor(255, 255, 255, 3)

        surface.DrawRect(0, 0, w, 2)
        surface.DrawRect(0, h - 2, w, 2)

        local thisTime = self.startTime - RealTime()

        local minutes = math.floor(math.fmod(thisTime, 3600) / 60)
        local seconds = math.floor(math.fmod(thisTime, 60))
        local miliseconds = math.floor(math.fmod(thisTime, 1) * 100)

        local _m = string.format("%d", minutes)
        local _s = string.format("%d", seconds)
        local _ms = string.format("%d", miliseconds)

        if tonumber(_m) < 10 then _m = "0" .. _m end
        if tonumber(_s) < 10 then _s = "0" .. _s end
        if tonumber(_ms) < 10 then _ms = "0" .. _ms end

        local timeString = Format("%s:%s:%s", _m, _s, _ms)
        if thisTime <= 0 then timeString = "00:00:00" end

        Arbitrage.DrawTextBlur(timeString, "arb.Font_FuturaPTBook_15", w / 2, H(6), Color(255, 238, 177, 255), TEXT_ALIGN_CENTER)
    end

    local fillPanel = mainPanel:Add("Panel")
    fillPanel:Dock(FILL)
    fillPanel:DockMargin(0, H(60), W(30), 0)

    self.charactersPanel = fillPanel:Add("DIconLayout")
    self.charactersPanel:SetWide(W(635))
    self.charactersPanel:SetSpaceY(Arbitrage.ResolutionH(50))
    self.charactersPanel:SetSpaceX(Arbitrage.ResolutionW(25))
    self.charactersPanel:Dock(LEFT)

    self.selectPanel = fillPanel:Add("Panel")
    self.selectPanel:SetWide(W(750))
    self.selectPanel:Dock(RIGHT)
end

function PANEL:Think()
    local thisTime = self.startTime - RealTime()

    if thisTime <= 0 and !self.closing then
        self.closing = true
        self:RemovingPanels()
    end
end

function PANEL:SetInfo(faction, steamid)
    if !faction then return end

    local data = Arbitrage.teams.Get(faction)
    local splashscreen = Arbitrage.GetMaterial(data.splash or "err.png")

    if IsValid(self.infoPanel) then
        self.infoPanel:AlphaTo(0, 0.25, 0, function()
            self.infoPanel:Remove()
        end)
    end

    self.character = faction

    timer.Simple(0.3, function()
        if IsValid(self.infoPanel) then
            self.infoPanel:Remove()
        end

        self.infoPanel = self.selectPanel:Add("Panel")
        self.infoPanel:SetAlpha(0)
        self.infoPanel:AlphaTo(255, 0.5)
        self.infoPanel:Dock(FILL)
        self.infoPanel.Paint = function(_, w, h)
            local size = h * 0.9

            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(splashscreen)
            surface.DrawTexturedRect(w / 2 - size / 2, h / 2 - size / 2, size, size)
        end

        self.panels[#self.panels + 1] = self.infoPanel

        local parsed = Arbitrage.markup.Parse("<font=arb.Font_FuturaPTBook_7><img=materials/danganronpa/ui/warning.png, 15x15, 255, 255, 255><colour=255,61,96,255> Вы уже проголосовали за данного персонажа</colour></font>")

        local textPanel = self.infoPanel:Add("Panel")
        textPanel:Dock(FILL)
        textPanel.Paint = function(_, w, h)
            surface.SetDrawColor(255, 220, 228, 10)
            surface.DrawRect(w * 0.2, h - Arbitrage.ResolutionH(179), w - (w * 0.2) * 2, 2)

            draw.DrawText(data.name, "arb.Font_FuturaPTBook_14", w / 2, h - Arbitrage.ResolutionH(230), Color(255, 220, 228), TEXT_ALIGN_CENTER)
            draw.DrawText(data.description, "arb.Font_FuturaPTBook_9", w / 2, h - Arbitrage.ResolutionH(170), Color(255, 220, 228), TEXT_ALIGN_CENTER)

            if self.voting == steamid then
                parsed:draw(w / 2, h - Arbitrage.ResolutionH(136), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)
            end
        end

        local selectButton = self.infoPanel:Add("DButton")
        selectButton:SetText("")
        selectButton:SetPos(self.selectPanel:GetWide() / 2 - W(250) / 2, self.selectPanel:GetTall() - H(55))
        selectButton:SetSize(W(250), H(55))
        selectButton.alpha = 0.2
        selectButton.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() and _:IsEnabled()) and 1 or 0.2)

            surface.SetDrawColor(27, 10, 13, 204 * _.alpha)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(255, 61, 96, 165.75 * _.alpha)
            surface.DrawOutlinedRect(0, 0, w, h, 2)

            draw.DrawText("Подтвердить голос", "arb.Font_FuturaPTBook_9", w / 2, Arbitrage.ResolutionH(13), Color(255, 220, 228, 255 * _.alpha), TEXT_ALIGN_CENTER)
        end
        selectButton.DoClick = function()
            self.voting = steamid

            netstream.Start("arb.SendVote", steamid)
        end
    end)
end

function PANEL:SetData(data, votingList)
    local isVoting = false

    for k, v in pairs(votingList or {}) do
        if LocalPlayer():SteamID() == (v.SteamID and v:SteamID()) then
            isVoting = true
        end
    end

    self.data = data
    self.panels = {}

    for k, v in pairs(data) do
        local steamid = v[1]
        local faction = v[2]
        local alive = true --v[3]

        local factionData = Arbitrage.teams.Get(faction)
        if !factionData then continue end

        local mat = Arbitrage.GetMaterial(factionData.logo or "err.png")

        local character = self.charactersPanel:Add("DButton")
        character:SetAlpha(0)
        character:AlphaTo(255, 0.3)
        character:SetText("")
        character:SetEnabled(isVoting)
        character:SetSize(Arbitrage.ResolutionW(139.5), Arbitrage.ResolutionH(135))
        character.alpha = 0
        character.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() or self.character == faction) and 1 or 0.4)

            if !alive then _.alpha = 0.05 end

            local xPos = w / 2 - (Arbitrage.ResolutionW(100) / 2)

            surface.SetDrawColor(27, 10, 13, 204 * _.alpha)
            surface.DrawRect(xPos, 0, Arbitrage.ResolutionW(100), Arbitrage.ResolutionH(100))

            surface.SetDrawColor(255, 255, 255, _.alpha * 255)
            surface.SetMaterial(mat)
            surface.DrawTexturedRect(xPos + 6, 6, Arbitrage.ResolutionW(100) - 12, Arbitrage.ResolutionH(100) - 12)

            if self.voting == steamid then
                surface.SetDrawColor(254, 110, 21, 165.75 * (_.alpha + 0.5))
                surface.DrawOutlinedRect(xPos, 0, Arbitrage.ResolutionW(100), Arbitrage.ResolutionH(100), 2)

                draw.DrawText(factionData.name, "arb.Font_FuturaPTBook_7", w / 2, h - Arbitrage.ResolutionH(25), Color(254, 110, 21 * _.alpha), TEXT_ALIGN_CENTER)
            else
                surface.SetDrawColor(255, 61, 96, 165.75 * (_.alpha + 0.5))
                surface.DrawOutlinedRect(xPos, 0, Arbitrage.ResolutionW(100), Arbitrage.ResolutionH(100), 2)

                draw.DrawText(factionData.name, "arb.Font_FuturaPTBook_7", w / 2, h - Arbitrage.ResolutionH(25), Color(255, 220, 228, 255 * _.alpha), TEXT_ALIGN_CENTER)
            end
        end
        character.DoClick = function()
            if !alive then return end

            self:SetInfo(faction, steamid)
        end

        self.panels[#self.panels + 1] = character
    end
end

function PANEL:RemovingPanels()
    for k, v in pairs(self.panels or {}) do
        if !IsValid(v) then continue end

        v:AlphaTo(0, 0.5, 0, function()
            v:Remove()
        end)
    end
end

function PANEL:ShowWinning(data)
    if !data then return self:AlphaTo(0, 1, 0, function() self:Remove() end) end

    local factionData = Arbitrage.teams.Get(data)
    if !factionData then return end

    local mat = Arbitrage.GetMaterial(factionData.splash or "err.png")

    local size = self:GetTall() * 0.7

    local panel = self:Add("Panel")
    panel:SetAlpha(0)
    panel:AlphaTo(255, 1)
    panel.size = 0
    panel.Think = function()
        local wide, tall = panel:GetWide(), panel:GetTall()

        panel.size = Lerp(FrameTime() * 5, panel.size, 1)

        panel:SetSize(size * panel.size, size * panel.size)
        panel:SetPos(ScrW() / 2 - wide / 2, ScrH() / 2 - tall / 2)
    end
    panel.Paint = function(_, w, h)
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(mat)
        surface.DrawTexturedRect(0, 0, w, h)
    end

    timer.Simple(5, function()
        self:ClosingAllPanels(panel)
    end)
end

function PANEL:ClosingAllPanels(panel)
    panel:AlphaTo(0, 0.5, 0, function()
        self:AlphaTo(0, 1, 0, function()
            self:Remove()
        end)
    end)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(matBG)
    surface.DrawTexturedRect(0, 0, w, h)

    surface.SetDrawColor(0, 0, 0, 190)
    surface.DrawRect(0, 0, w, h)

    Arbitrage.DrawBlur(self, 5, passes, alpha)
end

vgui.Register("arb.VoteScreen", PANEL, "EditablePanel")

concommand.Add("arb_close_votescreen", function(client, command, arguments)
    if IsValid(Arbitrage.gui.votescreen) then
        Arbitrage.gui.votescreen:Remove()
    end
end)