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
        draw.DrawText(L("#vote_title"), "arb.Font_FuturaPTDemi_15", 0, 0, color_white, TEXT_ALIGN_LEFT)
        draw.DrawText(L("#vote_text"), "arb.Font_FuturaPTBook_10", W(380), H(10), Color(255, 255, 255, 50), TEXT_ALIGN_LEFT)
    end

    self.timerPanel = titlePanel:Add("Panel")
    self.timerPanel:SetWide(W(190))
    self.timerPanel:Dock(RIGHT)
    self.timerPanel.Paint = function(_, w, h)
        asterionlib.DrawRect(0, 0, w, 2, {255, 255, 255, 3})
        asterionlib.DrawRect(0, h - 2, w, 2)

        local thisTime = self.startTime - RealTime()

        local minutes = math.floor(math.fmod(thisTime, 3600) / 60)
        local seconds = math.floor(math.fmod(thisTime, 60))
        local miliseconds = math.floor(math.fmod(thisTime, 1) * 100)

        local _m = ("%d"):format(minutes)
        local _s = ("%d"):format(seconds)
        local _ms = ("%d"):format(miliseconds)

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

    local Scroll = fillPanel:Add("DScrollPanel")
    Scroll:Dock(FILL)

    do
        local bar = Scroll:GetVBar()
        bar:SetWide(3)
        bar:DockMargin(0, 0, 0, 0)

        bar.Paint = function(_, w, h)
            asterionlib.DrawRect(0, 0, w, h, {255, 255, 255, 3})
        end
        bar.btnUp.Paint = function(_, w, h) end
        bar.btnDown.Paint = function(_, w, h) end
        bar.btnGrip.Paint = function(_, w, h)
            asterionlib.DrawRect(0, 0, w, h, {255, 255, 255})
        end
    end

    self.charactersPanel = Scroll:Add("DIconLayout")
    self.charactersPanel:SetWide(W(635))
    self.charactersPanel:SetSpaceY(H(50))
    self.charactersPanel:SetSpaceX(W(25))
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

    local data = Character.team:GetByID(faction)
    local splashscreen = Material(data:GetAssets().splash)

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

            asterionlib.DrawTexturedRect(splashscreen, w / 2 - size / 2, h / 2 - size / 2, size, size, {255, 255, 255})
        end

        self.panels[#self.panels + 1] = self.infoPanel

        local parsed = asterionlib.markup.Parse(L("#vote_voted"))

        local textPanel = self.infoPanel:Add("Panel")
        textPanel:Dock(FILL)
        textPanel.Paint = function(_, w, h)
            asterionlib.DrawRect(w * 0.2, h - H(179), w - (w * 0.2) * 2, 2, {255, 220, 228, 10})

            draw.DrawText(L(data:GetName()), "arb.Font_FuturaPTBook_14", w / 2, h - H(230), Color(255, 220, 228), TEXT_ALIGN_CENTER)
            draw.DrawText(L(data:GetTitle()), "arb.Font_FuturaPTBook_9", w / 2, h - H(170), Color(255, 220, 228), TEXT_ALIGN_CENTER)

            if self.voting == steamid then
                parsed:draw(w / 2, h - H(136), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)
            end
        end

        local selectButton = self.infoPanel:Add("DButton")
        selectButton:SetText("")
        selectButton:SetPos(self.selectPanel:GetWide() / 2 - W(250) / 2, self.selectPanel:GetTall() - H(55))
        selectButton:SetSize(W(250), H(55))
        selectButton.alpha = 0.2
        selectButton.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() and _:IsEnabled()) and 1 or 0.2)

            asterionlib.DrawRect(0, 0, w, h, {27, 10, 13, 204 * _.alpha})
            asterionlib.DrawOutlinedRect(0, 0, w, h, 2, {255, 61, 96, 165.75 * _.alpha})

            draw.DrawText(L("#vote_confirm"), "arb.Font_FuturaPTBook_9", w / 2, H(13), Color(255, 220, 228, 255 * _.alpha), TEXT_ALIGN_CENTER)
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

        local factionData = Character.team:GetByID(faction)
        if !factionData then continue end

        local mat = Material(factionData:GetAssets().logo)
        local mat2 = Material(factionData:GetAssets().select)

        local character = self.charactersPanel:Add("DButton")
        character:SetAlpha(0)
        character:AlphaTo(255, 0.3)
        character:SetText("")
        character:SetEnabled(isVoting)
        character:SetSize(W(139.5), H(135))
        character.alpha = 0
        character.alpha2 = 0
        character.Paint = function(_, w, h)
            local ft = FrameTime()

            _.alpha = Lerp(ft * 10, _.alpha, (_:IsHovered() or self.character == faction) and 1 or 0.4)
            _.alpha2 = Lerp(ft * 10, _.alpha2, self.voting == steamid and 1 or -0.1)

            if !alive then _.alpha = 0.05 end

            local xPos = w / 2 - (W(100) / 2)

            asterionlib.DrawRect(xPos, 0, W(100), H(100), {27, 10, 13, 204 * _.alpha})
            asterionlib.DrawTexturedRect(mat, xPos + 6, 9, W(100) - 12, H(100) - 12, {255, 255, 255, _.alpha * 255})
            asterionlib.DrawTexturedRect(mat2, xPos + 6, 9, W(100) - 12, H(100) - 12, {255, 255, 255, 255 * _.alpha2})

            Arbitrage.DrawTextBlur(L(factionData.name), "arb.Font_FuturaPTBook_7", w / 2, h - H(25), Color(255, 238, 177, 255 * _.alpha2), TEXT_ALIGN_CENTER)

            if self.voting != steamid then
                draw.DrawText(L(factionData.name), "arb.Font_FuturaPTBookBlurN_7", w / 2, h - H(25), Color(255, 234, 238, 255 * _.alpha), TEXT_ALIGN_CENTER)
            end

            asterionlib.DrawOutlinedRect(xPos, 3, W(100), H(100), 2, {255, 61, 96, 165.75 * (_.alpha + 0.5)})
            Arbitrage.DrawOutlinedRectBlur(xPos, 3, W(100), H(100), Color(255, 238, 177, 255 * _.alpha2), 2, 4)
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

    local factionData = Character.team:GetByID(data)
    if !factionData then return end

    local mat = Material(factionData:GetAssets().splash)

    local size = math.Round(self:GetTall() * 0.61111111111)

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
        asterionlib.DrawTexturedRect(mat, 0, 0, w, h, {255, 255, 255})
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

local vote_emptyMat = Material("danganronpa/ui/vote_empty.png")
local vote_markMat = Material("danganronpa/ui/vote_mark.png")
function PANEL:ShowVotings(winning, votingData)
    local data = {}
    for k, v in pairs(self.data) do
        local steamid = v[1]
        local faction = v[2]

        data[steamid] = {
            faction,
            0
        }
    end

    for k, v in pairs(votingData) do
        local find

        for k2, v2 in pairs(self.data) do
            if v2[1] == v then
                find = v2
                break
            end
        end

        if find then
            local steamid = find[1]

            data[steamid][2] = data[steamid][2] + 1
        end
    end

    local padding = W(10)

    local panel = self:Add("DIconLayout")
    panel:SetPos(W(250), H(160))
    panel:SetSize(W(1000), ScrH())
    panel:SetSpaceY(H(5))
    panel:SetSpaceX(padding)

    local count = #self.data

    for steamid, stored in pairs(data) do
        local faction = stored[1]
        local votes = stored[2]

        local factionData = Character.team:GetByID(faction)
        if !factionData then continue end

        local name = factionData.name
        local mat = Material(factionData:GetAssets().logo)

        local ListItem = panel:Add("DPanel")
        ListItem:SetAlpha(0)
        ListItem:AlphaTo(255, 1)
        ListItem:SetSize(panel:GetWide() / 2 - padding * 2, H(50))
        ListItem.Paint = function(_, w, h)
            asterionlib.DrawBlur(self, 3)

            asterionlib.DrawRect(0, 0, w, h, {0, 0, 0, 90})
            asterionlib.DrawRect(0, 0, h, h, {0, 0, 0, 100})
            asterionlib.DrawTexturedRect(mat, 0, 0, h, h, {255, 255, 255})

            local sizeH = h * 0.55
            local sizeW = sizeH * 0.3

            for i = 0, count - 1 do
                asterionlib.DrawTexturedRect(vote_emptyMat, h + W(10) + (sizeW * i) + (i * H(5)), h - sizeH, sizeW, sizeH, {255, 255, 255})
            end

            for i = 0, votes - 1 do
                asterionlib.DrawTexturedRect(vote_markMat, h + W(10) + (sizeW * i) + (i * H(5)), h - sizeH, sizeW, sizeH, {255, 255, 255})
            end

            Arbitrage.DrawTextBlur(L(name), "arb.Font_FuturaPTBook_7", h + W(10), 0, Color(255, 238, 177), TEXT_ALIGN_LEFT)

            asterionlib.DrawOutlinedRect(0, 0, w, h, {255, 61, 96, 40})
        end
    end

    timer.Simple(5, function()
        self:ShowWinning(winning)
    end)
end

function PANEL:End(winning, votingData)
    self:RemovingPanels()

    timer.Simple(1, function()
        if !IsValid(self) then return end

        self:ShowVotings(winning, votingData)
    end)
end

local material_bg = Material("danganronpa/ui/bg.png")
local material_bg_glass = Material("danganronpa/ui/bg_glassshards.png")
local material_bg_light = Material("danganronpa/ui/bg_light.png")

local lerpX, lerpY = 0, 0
local lerpX_g, lerpY_g = lerpX, lerpY
local lerpX_l, lerpY_l = lerpX, lerpY

local padding = 0.07
local speed = 1

function PANEL:Paint(w, h)
    local ft = FrameTime()

    local x, y = math.Clamp(gui.MouseX(), 0, w), math.Clamp(gui.MouseY(), 0, h)
    local Wx, Wy = -((w / 2 - x) * padding), -((h / 2 - y) * padding)

    local sizeX = w / 2 * padding
    local sizeY = h / 2 * padding

    lerpX = Lerp(ft * speed, lerpX, Wx)
    lerpY = Lerp(ft * speed, lerpY, Wy)

    lerpX_g = Lerp(ft * (speed * 3), lerpX_g, Wx)
    lerpY_g = Lerp(ft * (speed * 3), lerpY_g, Wy)

    lerpX_l = Lerp(ft * (speed * 10), lerpX_l, Wx)
    lerpY_l = Lerp(ft * (speed * 10), lerpY_l, Wy)

    asterionlib.DrawTexturedRect(material_bg, 0 - lerpX - sizeX, 0 - lerpY - sizeY, w + sizeX * 2, h + sizeY * 2, {255, 255, 255})
    asterionlib.DrawRect(0, 0, w, h, {0, 0, 0, 190})
    asterionlib.DrawTexturedRect(material_bg_glass, 0 - lerpX_g - sizeX, 0 - lerpY_g - sizeY, w + sizeX * 2, h + sizeY * 2, {255, 255, 255, 150})
    asterionlib.DrawTexturedRect(material_bg_light, 0 - lerpX_l - sizeX, 0 - lerpY_l - sizeY, w + sizeX * 2, h + sizeY * 2, {255, 255, 255, 25})

    asterionlib.DrawBlur(self, 5)
end

vgui.Register("arb.VoteScreen", PANEL, "EditablePanel")

concommand.Add("arb_close_votescreen", function(client, command, arguments)
    if IsValid(Arbitrage.gui.votescreen) then
        Arbitrage.gui.votescreen:Remove()
    end
end)