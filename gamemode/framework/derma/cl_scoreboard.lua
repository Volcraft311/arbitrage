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

local function P(this, w, h)
    surface.SetDrawColor(255, 0, 0, 255)
    -- surface.DrawOutlinedRect(0, 0, w, h)
end

local function getCasteCount()
    local casteCount = 0
    for k, v in ipairs(player.GetAll()) do
        if v:Alive() then -- Alive переписанный метод режимом Arbitrage!
            casteCount = casteCount + 1
        end
    end

    return casteCount
end

local function getHostName()
    local name = GetHostName()

    -- eh...

    return name
end

local path = "danganronpa/scoreboard/%s.png"
local pingData = {
    {
        data = Format(path, "connect_5"),
        min = 1,
        max = 49
    },
    {
        data = Format(path, "connect_4"),
        min = 50,
        max = 99
    },
    {
        data = Format(path, "connect_3"),
        min = 100,
        max = 149
    },
    {
        data = Format(path, "connect_2"),
        min = 150,
        max = 249
    }
}

local function getMatPing(ping)
    local matPing = Format(path, "connect_1")
    for k2, v2 in ipairs(pingData) do
        if ping >= v2.min and ping <= v2.max then
            matPing = v2.data
            break
        end
    end

    return Material(matPing)
end

local groupData = {
    founder = "Владелец",
    curator = "Куратор",
    gamemaster = "Игровой мастер",
    guard = "Администратор",
    developer = "Разработчик"
}

local function getGroupName(name)
    local newName = groupData[name:lower()]
    if newName then
        return newName
    end

    return name
end

function PANEL:Init()
    Arbitrage.gui.scoreboard = self

    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)

    self:SetKeyboardInputEnabled(false)

    self.countProgressPanel = 0

    self:CreateLeftPanel()
    self:CreateMiddlePanel()
    self:CreateRightPanel()

    self:CreateTooltip()
end

function PANEL:CreateTooltip()
    self.tooltip = self:Add("DPanel")
    self.tooltip:SetAlpha(0)
    self.tooltip:SetPos(0, 0)
    self.tooltip:SetSize(100, 100)
    self.tooltip.select_panel = nil
    self.tooltip.panels = {}
    self.tooltip.UpdateWide = function(this, wide)
        this:SetWide(math.max(wide * 5, W(200)))
    end
    self.tooltip.UpdateTall = function(this)
        local tall = 0

        for k, v in ipairs(this.panels) do
            local _, t_margin, _, b_margin = v:GetDockMargin()

            tall = tall + v:GetTall() + t_margin + b_margin
        end

        this:SetTall(tall)
    end
    self.tooltip.AddPanel = function(this, name, parent)
        local panel = this:Add(name, parent)
        this.panels[#this.panels + 1] = panel

        return panel
    end
    self.tooltip.ClearPanels = function(this)
        for k, v in ipairs(this.panels) do
            if IsValid(v) then
                v:Remove()
            end
        end

        this.panels = {}
    end
    self.tooltip.Paint = function(this, w, h)
        asterionlib.DrawBlur(this, 6)

        surface.SetDrawColor(0, 0, 0, 100)
        surface.DrawRect(0, 0, w, h)

        local x, y = gui.MouseX() + 15, gui.MouseY() - 15

        if x + w >= ScrW() - 10 then x = ScrW() - w - 10 end
        if x <= 10 then x = 10 end

        if y + h >= ScrH() - 10 then y = ScrH() - h - 10 end
        if y <= 10 then y = 10 end

        this:SetPos(x, y)
    end
    self.tooltip.Think = function(this)
        local panel = vgui.GetHoveredPanel()
        if IsValid(this.select_panel) then
            if panel != this.select_panel then
                this:SetAlpha(this:GetAlpha() - FrameTime() * 400)

                if this:GetAlpha() <= 0 then
                    this.select_panel = nil
                end
            else
                if RealTime() >= this.openTime then
                    this:SetAlpha(math.Clamp(this:GetAlpha() + FrameTime() * 500, 0, 255))
                end
            end
        end

        if IsValid(panel) then
            if !isfunction(panel.TooltipInfo) then return end

            if this.select_panel != panel and this:GetAlpha() <= 0 then
                this:Draw(panel)
            end
        end
    end
    self.tooltip.Draw = function(this, panel)
        this.select_panel = panel

        this:SetAlpha(0)
        this:ClearPanels()
        panel:TooltipInfo(this)
        this:UpdateTall()

        this.openTime = RealTime() + 0.5
    end
    self.tooltip.Clear = function()
    end
end

function PANEL:CreateLeftPanel()
    local mainPanel = self:Add("DPanel")
    mainPanel:SetWide(W(500))
    mainPanel:Dock(LEFT)
    mainPanel:DockMargin(50, 50, 0, 50)
    mainPanel.Paint = P

    local topPanel = mainPanel:Add("DPanel")
    topPanel:SetTall(ScrH() * 0.3)
    topPanel:Dock(TOP)
    topPanel.Paint = P


    self:CreateText(topPanel, getHostName(), "arb.Font_FuturaPTDemi_13")
    self:CreateText(topPanel, game.GetMap(), "arb.Font_FuturaPTBook_8")

    self:CreateEmptiness(topPanel, 100)

    self:CreateText(topPanel, ("На сервере: %s/%s"):format(#player.GetAll(), game.MaxPlayers()), "arb.Font_FuturaPTBook_7")
    self:CreateText(topPanel, ("В касте: %s"):format(getCasteCount()), "arb.Font_FuturaPTBook_7")


    local bottomPanel = mainPanel:Add("DPanel")
    bottomPanel:Dock(FILL)
    bottomPanel.Paint = P

    local serverstat = asterionlib.serverstat:Get()
    -- local p_cpu = math.floor(serverstat.ProcessCPUUsage)
    local s_cpu = math.Clamp(math.floor(serverstat.SystemCPUUsage) * 2, 0, 100)
    local s_m = math.floor(serverstat.SystemMemoryUsage)
    local s_tm = math.floor(serverstat.SystemTotalMemory)
    local s_m_interest = math.floor(100 / (s_tm / s_m))

    self:CreateProgressPanel(bottomPanel, "System Memory: " .. s_m_interest .. "% (" .. s_m .. "/" .. s_tm .. " MiB)", s_m_interest, {Color(106, 230, 106), Color(255, 187, 0), Color(255, 57, 57)})
    self:CreateProgressPanel(bottomPanel, "System CPU: " .. s_cpu .. "%", s_cpu, {Color(106, 230, 106), Color(255, 187, 0), Color(255, 57, 57)})
    -- self:CreateProgressPanel(bottomPanel, "Process CPU: " .. p_cpu .. "%", p_cpu, {Color(106, 230, 106), Color(255, 187, 0), Color(255, 57, 57)})
end

function PANEL:CreateText(parent, data, font, bReverse)
    local dataFunc = isfunction(data)

    local panel = parent:Add("DLabel")
    panel:Dock(TOP)
    panel:SetText(dataFunc and data() or data)
    panel:SetFont(font)
    panel:SetContentAlignment(bReverse and 6 or 4)
    panel:SizeToContents()

    if dataFunc then
        panel.Paint = function(this)
            this:SetText(data())
        end
    end

    return panel
end

function PANEL:CreateEmptiness(parent, tall)
    local panel = parent:Add("DPanel")
    panel:SetTall(tall)
    panel:Dock(TOP)
    panel.Paint = P

    return panel
end

local font = "arb.Font_FuturaPTBook_7"
local heightFont = draw.GetFontHeight(font)
function PANEL:CreateProgressPanel(parent, data, maxAngles, colorsList, bReverse)
    local panel = parent:Add("DPanel")
    panel:SetAlpha(0)
    panel:SetTall(heightFont * 2)
    panel:Dock(BOTTOM)
    panel:DockMargin(0, 10, 0, 0)
    panel.Paint = P

    local fCol = colorsList[1]
    local color = Color(fCol.r, fCol.g, fCol.b)
    local angles = 0
    local r, x, y = 20, panel:GetTall() / 2, panel:GetTall() / 2

    local background = asterionlib.Circles.New(CIRCLE_FILLED, r, x, y, 5)
    background:SetMaterial(true)
    background:SetColor(Color(0, 0, 0, 180))

    local outlined = asterionlib.Circles.New(CIRCLE_OUTLINED, r, x, y, 5)
    outlined:SetMaterial(true)
    outlined:SetColor(fCol)
    outlined:SetEndAngle(0)

    local progressPanel = panel:Add("Panel")
    progressPanel:Dock(bReverse and RIGHT or LEFT)
    progressPanel:SetWide(panel:GetTall())

    self.countProgressPanel = self.countProgressPanel + 1
    timer.Simple(self.countProgressPanel * 0.1, function()
        if !IsValid(panel) then return end
        if !IsValid(progressPanel) then return end

        panel:AlphaTo(255, 0.5)

        progressPanel.Paint = function()
            background()

            local selectColor = 2
            if maxAngles < 50 then
                selectColor = 1
            elseif maxAngles > 85 then
                selectColor = 3
            end

            color = LerpColor(FrameTime() * 2, color, colorsList[selectColor])
            angles = Lerp(FrameTime() * 2, angles, maxAngles * 36 / 10)

            outlined:SetEndAngle(angles)
            outlined:SetColor(color)

            outlined()
        end

        local wideLabel = 0
        local labelPanel = panel:Add("DPanel")
        labelPanel:Dock(FILL)
        labelPanel:DockMargin(bReverse and 0 or 10, 0, bReverse and 10 or 0, 0)
        labelPanel.Paint = function(this, w, h)
            wideLabel = Lerp(FrameTime() * 0.45, wideLabel, w)

            asterionlib.DrawRender(function()
                surface.SetDrawColor(255, 255, 255)
                if bReverse then
                    surface.DrawRect(w - wideLabel, 0, w, h)
                else
                    surface.DrawRect(0, 0, wideLabel, h)
                end
            end, function()
                draw.SimpleText(data, font, bReverse and w or 0, h / 2, color_white, bReverse and TEXT_ALIGN_RIGHT or TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end)
        end
    end)
end

function PANEL:CreateMiddlePanel()
    local panel = self:Add("DPanel")
    panel:Dock(FILL)
    panel:DockMargin(0, 50, 0, 50)
    panel.Paint = P

    local gamePanel = panel:Add("DPanel")
    gamePanel:SetTall(H(80))
    gamePanel:Dock(TOP)
    gamePanel.Paint = P
    gamePanel.Paint = function(this, w, h)
        draw.SimpleText(("%s | %s"):format(Arbitrage.GetTime(), Arbitrage.GetChapter()), "arb.Font_FuturaPTBook_11", w / 2, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end

    self:CreatePlayersPanel(panel)
end

function PANEL:CreatePlayersPanel(parent)
    if Arbitrage.OffShowFactions() then
        local errorPanel = parent:Add("DPanel")
        errorPanel:SetTall(self:GetTall())
        errorPanel:Dock(TOP)
        errorPanel:DockMargin(0, 0, 0, H(30))
        errorPanel.Paint = function(this, w, h)
            draw.DrawText("Администратор сервера скрыл основной список игроков!\n:(", "arb.Font_FuturaPTBook_10", w / 2, h * 0.35, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        if !LocalPlayer():IsAdmin() then -- даем админу использовать ТАБ
            return
        end

        errorPanel:SetTall(H(100))
    end

    local scrollPanel = parent:Add("DScrollPanel")
    scrollPanel:Dock(FILL)

    local bar = scrollPanel:GetVBar()
    bar:SetWide(10)
    bar:DockMargin(0, 0, 0, 0)

    bar.Paint = function(_, w, h)
        surface.SetDrawColor(255, 255, 255, 3)
        surface.DrawRect(7, 10, w, h - 20)
    end
    bar.btnUp.Paint = function() end
    bar.btnDown.Paint = function() end
    bar.btnGrip.Paint = function(_, w, h)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawRect(7, 10, w, h - 20)
    end

    for k, v in ipairs(player.GetAll()) do
        local panel = scrollPanel:Add("Panel")
        panel:SetTall(H(35))
        panel:Dock(TOP)
        panel:DockMargin(0, 0, 0, 5)

        -- local statusPanel = panel:Add("DPanel")
        -- statusPanel:Dock(LEFT)
        -- statusPanel:SetWide(panel:GetTall())
        -- statusPanel:DockMargin(0, 0, 5, 0)

        local playerPanel = panel:Add("Panel")
        playerPanel:Dock(FILL)

        local avatar = playerPanel:Add("AvatarImage")
        avatar:Dock(LEFT)
        avatar:SetWide(panel:GetTall())
        avatar:SetPlayer(v, 64)

        local name = v:GetName()
        local steamid = v:SteamID()
        local faction = v:Team()
        local character = Character.team:GetByID(faction)
        local steamName = v:SteamName()
        local ping = v:Ping()
        local matPing = getMatPing(ping)
        local userGroup = v:GetUserGroup()
        local groupName = userGroup != "user" and userGroup
        if groupName then
            groupName = getGroupName(groupName)
        end

        local infoPanel = playerPanel:Add("DPanel")
        infoPanel:Dock(FILL)
        infoPanel.Paint = function(this, w, h)
            surface.SetDrawColor(15, 6, 7, 255 * 0.9)
            surface.DrawRect(0, 0, w, h)

            draw.SimpleText(steamName, "arb.Font_FuturaPTBook_9", 10, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(matPing)
            surface.DrawTexturedRect(w - h, 0, h, h)

            draw.SimpleText(ping, "arb.Font_FuturaPTBook_7", w - h, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

            if groupName then
                draw.SimpleText(groupName, "arb.Font_FuturaPTBook_8", w / 2, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end

        local buttonPanel = playerPanel:Add("DButton")
        buttonPanel:SetText("")
        buttonPanel:SetPos(0, 0)
        buttonPanel:SetSize(self:GetWide(), self:GetTall())
        buttonPanel.TooltipInfo = function(this, tooltip)
            local tooltipTitle = tooltip:AddPanel("DPanel")
            tooltipTitle:SetTall(H(35))
            tooltipTitle:Dock(TOP)
            tooltipTitle.Paint = function(_, w, h)
                local width, height = draw.SimpleText(steamName, "arb.Font_FuturaPTBook_7", h + 5, 0, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)

                draw.SimpleText(steamid, "arb.Font_FuturaPTBook_5", h + 5, height, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)

                tooltip:UpdateWide(width)
            end

            local tooltipAvatar = tooltipTitle:Add("AvatarImage")
            tooltipAvatar:Dock(LEFT)
            tooltipAvatar:SetWide(tooltipTitle:GetTall())
            tooltipAvatar:SetPlayer(v, 64)

            local tooltipLine = tooltip:AddPanel("DPanel")
            tooltipLine:SetTall(1)
            tooltipLine:Dock(TOP)
            tooltipLine:DockMargin(0, 5, 0, 5)
            tooltipLine.Paint = function(_, w, h)
                surface.SetDrawColor(color_white)
                surface.DrawRect(0, 0, tooltip:GetAlpha() / 255 * w, h)
            end

            local pixel = character:GetAssets().pixel
            local pixelMat = pixel and Material(pixel)

            local tootipFaction = tooltip:AddPanel("DPanel")
            tootipFaction:SetTall(H(30))
            tootipFaction:Dock(TOP)
            tootipFaction.Paint = function(_, w, h)
                surface.SetDrawColor(color_white)

                local tall = 0
                if pixelMat then
                    surface.SetMaterial(pixelMat)
                    surface.DrawTexturedRect(0, 0, h, h)

                    tall = tall + h
                end

                draw.SimpleText(name, "arb.Font_FuturaPTBook_6", tall + 5, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            local rankMat = Arbitrage.chat:GetIcon(v)

            local tootipRank = tooltip:AddPanel("DPanel")
            tootipRank:SetTall(H(30))
            tootipRank:Dock(TOP)
            tootipRank.Paint = function(_, w, h)
                surface.SetDrawColor(color_white)

                local tall = 0
                if rankMat then
                    local size = 0.55
                    surface.SetMaterial(rankMat)
                    surface.DrawTexturedRect(h * 0.25, h * 0.25, h * size, h * size)

                    tall = tall + h
                end

                draw.SimpleText(userGroup, "arb.Font_FuturaPTBook_6", tall + 5, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end

            local timeMat = Material("icon16/clock.png")

            local tootipTime = tooltip:AddPanel("DPanel")
            tootipTime:SetTall(H(30))
            tootipTime:Dock(TOP)
            tootipTime.Paint = function(_, w, h)
                local size = 0.55

                surface.SetDrawColor(color_white)
                surface.SetMaterial(timeMat)
                surface.DrawTexturedRect(h * 0.25, h * 0.25, h * size, h * size)

                local curtime = CurTime()
                local a_isvalid = IsValid(v)
                local time = string.FormattedTime(curtime - (a_isvalid and v:GetNetVar("connectedTime", curtime) or curtime))
                local m_time = string.format("%s:%s:%s", time.h, time.m, time.s)

                draw.SimpleText(m_time, "arb.Font_FuturaPTBook_6", h + 5, h / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
        end

        -- hide button!
        buttonPanel.Paint = nil
        buttonPanel.DoClick = function()
            local menu = DermaMenu(false, self)
            menu:AddOption("Скопировать SteamID", function() SetClipboardText(steamid) end)
            menu:AddOption("Перейти на профиль", function() gui.OpenURL(Format("https://steamcommunity.com/profiles/%s", util.SteamIDTo64(steamid))) end)
            menu:AddOption("Написать личное сообщение", function()
                local chatbox = Arbitrage.gui.chat
                if !IsValid(chatbox) then return end

                self:Remove()
                chatbox.entry:SetValue("")

                timer.Simple(0.3, function()
                    local text = ("/pm %s "):format(steamid)

                    chatbox:SetActive(true)
                    chatbox.entry:SetValue(text)
                    chatbox.entry:RequestFocus()
                    chatbox.entry:SetCaretPos(utf8.len(text))
                end)
            end)

            menu:SetPos(gui.MouseX(), gui.MouseY())
        end
    end
end

function PANEL:CreateRightPanel()
    local mainPanel = self:Add("DPanel")
    mainPanel:SetWide(W(500))
    mainPanel:Dock(RIGHT)
    mainPanel:DockMargin(0, 50, 50, 50)
    mainPanel.Paint = P

    local topPanel = mainPanel:Add("DPanel")
    topPanel:SetTall(ScrH() * 0.3)
    topPanel:Dock(TOP)
    topPanel.Paint = P

    local time = os.time()
    self:CreateText(topPanel, os.date("%H:%M", time), "arb.Font_FuturaPTBook_13", true)
    self:CreateText(topPanel, os.date("%d/%m/%Y", time), "arb.Font_FuturaPTBook_8", true)

    local bottomPanel = mainPanel:Add("DPanel")
    bottomPanel:Dock(FILL)
    bottomPanel.Paint = P

    local mp_c = asterionlib.modelprecache:GetCount()
    local mp_mc = asterionlib.modelprecache:GetMaxCount()
    local mp_interest = math.floor(100 / (mp_mc / mp_c))
    local edict_c = asterionlib.GetEdictCount()
    local edict_mc = asterionlib.GetMaxEdictCount()
    local edict_interest = math.floor(100 / (edict_mc / edict_c))
    -- local fps_c = asterionlib.GetServerFPS()
    -- local fps_mc = asterionlib.GetMaxServerFPS()
    -- local fps_interest = math.floor(100 / (fps_mc / fps_c))

    self:CreateProgressPanel(bottomPanel, "Precached Models: " .. mp_interest .. "% (" .. mp_c .. "/" .. mp_mc .. ")", mp_interest, {Color(106, 230, 106), Color(255, 187, 0), Color(255, 57, 57)}, true)
    self:CreateProgressPanel(bottomPanel, "Entity Limit: " .. edict_interest .. "% (" .. edict_c .. "/" .. edict_mc .. ")", edict_interest, {Color(106, 230, 106), Color(255, 187, 0), Color(255, 57, 57)}, true)
    -- self:CreateProgressPanel(bottomPanel, "Server FPS: " .. fps_interest .. "% (" .. fps_c .. "/" .. fps_mc .. ")", fps_interest, {Color(255, 57, 57), Color(255, 187, 0), Color(106, 230, 106)}, true)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(15, 6, 7, 255 * 0.9)
    surface.DrawRect(0, 0, w, h)

    asterionlib.DrawBlurAt(0, 0, w, h, 5, nil, 255)
end

vgui.Register("arb.ScoreBoard", PANEL, "EditablePanel")