--[[
        © AsterionStaff 2025.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local function getCasteCount()
    local casteCount = 0
    for k, v in ipairs(player.GetAll()) do
        if v:Alive() then -- Alive переписанный метод режимом Arbitrage!
            casteCount = casteCount + 1
        end
    end

    return casteCount
end

local function getServerUptime(time)
    local hours = math.floor(time / 3600)
    local minutes = math.floor((time % 3600) / 60)

    return ("%02dч. %02dм."):format(hours, minutes)
end

local color_shadow = Color(0, 0, 0, 150)
local function drawText(text, font, x, y, color, xAlign, yAlign)
    draw.SimpleText(text, font, x + 2, y + 2, color_shadow, xAlign, yAlign)
    draw.SimpleText(text, font, x, y, color, xAlign, yAlign)
end

local cornerRadius = 5
local function paintMenu(panel)
    panel.Paint = function(_, w, h)
        draw.RoundedBox(cornerRadius, 0, 0, w, h, Color(255, 61, 96, 165.75))
        draw.RoundedBox(cornerRadius, 2, 2, w - 4, h - 4, Color(41, 22, 25))
    end
end

local function paintOption(panel)
    panel:SetFont("arb.Font_FuturaPTBook_6")
    panel.Paint = function(_, w, h)
        local alpha = 130

        if _:IsHovered() and _:IsEnabled() then
            surface.SetDrawColor(27, 10, 13, 200)
            surface.DrawRect(2, 2, w - 4, h - 4)

            alpha = 255
        end

        if !_:IsEnabled() then
            surface.SetDrawColor(255, 0, 0, 20)
            surface.DrawRect(2, 0, w - 4, h)

            alpha = 255
        end

        panel:SetTextColor(Color(240, 240, 240, alpha))
    end
end


---@class EditablePanel
local PANEL = {}

function PANEL:Init()
    Arbitrage.gui.scoreboard = self

    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)

    self:SetKeyboardInputEnabled(false)

    self:CreatePanel()
end

local padding = H(310)
function PANEL:CreatePanel()
    local serverstat = asterionlib.serverstat:Get()

    self.panel = self:Add("Panel")
    self.panel:Dock(FILL)
    self.panel:DockMargin(padding, H(225), padding, H(237))

    local scrollPanel = self.panel:Add("DScrollPanel")
    scrollPanel:Dock(FILL)
    ApplySmoothScroll(scrollPanel)

    local bar = scrollPanel:GetVBar()
    bar:SetWide(15)
    bar:DockMargin(0, 0, 0, 0)

    bar.Paint = function(_, w, h)
        surface.SetDrawColor(0, 0, 0, 220)
        surface.DrawRect(w - 3, 0, w, h)
    end

    bar.btnUp.Paint = function(_, w, h) end
    bar.btnDown.Paint = function(_, w, h) end
    bar.btnGrip.Paint = function(_, w, h)
        local informationColor = Arbitrage.theme:GetInformation()

        surface.SetDrawColor(informationColor.r, informationColor.g, informationColor.b)
        surface.DrawRect(w - 3, 0, w, h)
    end

    local user_info = LocalPlayer():GetNetVar("user_info", {})
    local banner_big_url = user_info.banner_big
    local banner_big = nil
    if banner_big_url then
        asterionlib.downloader:Image(banner_big_url, function(mat, path)
            banner_big = mat
        end)
    end

    local banner_mat = Material("asterion/academy/ui/scoreboard/banner_big_mat.png")
    local banner_big_mask = BMASKS.CreateMask("banner_big_mask", "asterion/academy/ui/scoreboard/banner_big_mask.png")
    self.info = self.panel:Add("Panel")
    self.info:SetAlpha(0)
    self.info:AlphaTo(255, 0.5)
    self.info:SetWide((ScrW() - padding * 2) * 0.285)
    self.info:Dock(RIGHT)
    self.info:DockMargin(H(15), 0, 0, 0)
    self.info.Paint = function(this, w, h)
        surface.SetDrawColor(0, 0, 0, 100)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(banner_mat)
        surface.DrawTexturedRect(0, 0, w, h)

        surface.SetDrawColor(0, 0, 0, 125)
        surface.DrawRect(0, 0, w, h)

        if banner_big then
            local mask_h = h
            local mask_w = mask_h * banner_big:Width() / banner_big:Height()

            BMASKS.BeginMask(banner_big_mask)
                surface.SetDrawColor(255, 255, 255)
                surface.SetMaterial(banner_big)
                surface.DrawTexturedRect(w / 2 - mask_w / 2, h / 2 - mask_h / 2, mask_w, mask_h)
            BMASKS.EndMask(banner_big_mask, 0, 0, w, h)

            surface.SetDrawColor(0, 0, 0, 100)
            surface.DrawRect(0, 0, w, h)
        end
    end

    local serverNameLabel = self.info:Add("DLabel")
    serverNameLabel:SetText(GetHostName()) -- "«Эфир» / Официальный × Сессии"
    serverNameLabel:SetFont("arb.Font_FuturaPTDemi_9")
    serverNameLabel:SetTextColor(color_white)
    serverNameLabel:Dock(TOP)
    serverNameLabel:DockMargin(25, 15, 0, 0)
    serverNameLabel:SizeToContents()

    local playersLabel = self.info:Add("DLabel")
    playersLabel:SetText(L("#tab_onserver"):format(player.GetCount(), game.MaxPlayers()))
    playersLabel:SetFont("arb.Font_FuturaPTBook_8")
    playersLabel:SetTextColor(color_white)
    playersLabel:Dock(TOP)
    playersLabel:DockMargin(25, 30, 0, 0)
    playersLabel:SizeToContents()

    local playersCastLabel = self.info:Add("DLabel")
    playersCastLabel:SetText(L("#tab_incast"):format(getCasteCount()))
    playersCastLabel:SetFont("arb.Font_FuturaPTBook_8")
    playersCastLabel:SetTextColor(color_white)
    playersCastLabel:Dock(TOP)
    playersCastLabel:DockMargin(25, 0, 0, 0)
    playersCastLabel:SizeToContents()

    local curTime = CurTime()
    local curTimeLabel = self.info:Add("DLabel")
    curTimeLabel:SetText("Время работы сервера: " .. getServerUptime(curTime))
    curTimeLabel:SetFont("arb.Font_FuturaPTBook_8")
    curTimeLabel:SetTextColor(color_white)
    curTimeLabel:Dock(TOP)
    curTimeLabel:DockMargin(25, 20, 0, 5)
    curTimeLabel:SizeToContents()

    local sessionTime = GetNetVar("arb.StartGameTime", nil)
    local sessionTimeLabel = self.info:Add("DLabel")
    sessionTimeLabel:SetText("Время с начала игры: " .. (sessionTime and getServerUptime(curTime - sessionTime) or "Игра не запущена!"))
    sessionTimeLabel:SetFont("arb.Font_FuturaPTBook_8")
    sessionTimeLabel:SetTextColor(color_white)
    sessionTimeLabel:Dock(TOP)
    sessionTimeLabel:DockMargin(25, 0, 0, 5)
    sessionTimeLabel:SizeToContents()

    local gameTimeLabel = self.info:Add("DLabel")
    gameTimeLabel:SetText("Время вашей сессии: " .. getServerUptime(curTime - LocalPlayer():GetNetVar("connectedTime", curTime)))
    gameTimeLabel:SetFont("arb.Font_FuturaPTBook_8")
    gameTimeLabel:SetTextColor(color_white)
    gameTimeLabel:Dock(TOP)
    gameTimeLabel:DockMargin(25, 0, 0, 0)
    gameTimeLabel:SizeToContents()

    local mp_c = asterionlib.modelprecache:GetCount()
    local mp_mc = asterionlib.modelprecache:GetMaxCount()
    local precachedModelsLabel = self.info:Add("DLabel")
    precachedModelsLabel:SetText("Precached Models: " .. mp_c .. "/" .. mp_mc)
    precachedModelsLabel:SetFont("arb.Font_FuturaPTBook_7")
    precachedModelsLabel:SetTextColor(color_white)
    precachedModelsLabel:Dock(BOTTOM)
    precachedModelsLabel:DockMargin(25, 0, 0, 30)
    precachedModelsLabel:SizeToContents()

    local s_m = math.floor(serverstat.SystemMemoryUsage)
    local s_tm = math.floor(serverstat.SystemTotalMemory)
    local systemMemoryUsageLabel = self.info:Add("DLabel")
    systemMemoryUsageLabel:SetText("System Memory Usage: " .. s_m .. "/" .. s_tm)
    systemMemoryUsageLabel:SetFont("arb.Font_FuturaPTBook_7")
    systemMemoryUsageLabel:SetTextColor(color_white)
    systemMemoryUsageLabel:Dock(BOTTOM)
    systemMemoryUsageLabel:DockMargin(25, 0, 0, 15)
    systemMemoryUsageLabel:SizeToContents()

    local s_cpu = math.Clamp(math.floor(serverstat.SystemCPUUsage) * 2, 0, 100)
    local systemCPUUsageLabel = self.info:Add("DLabel")
    systemCPUUsageLabel:SetText("System CPU Usage: " .. s_cpu .. "%")
    systemCPUUsageLabel:SetFont("arb.Font_FuturaPTBook_7")
    systemCPUUsageLabel:SetTextColor(color_white)
    systemCPUUsageLabel:Dock(BOTTOM)
    systemCPUUsageLabel:DockMargin(25, 0, 0, 15)
    systemCPUUsageLabel:SizeToContents()

    local edict_c = asterionlib.GetEdictCount()
    local edict_mc = asterionlib.GetMaxEdictCount()
    local entityLimitLabel = self.info:Add("DLabel")
    entityLimitLabel:SetText("Entity Limit: " .. edict_c .. "/" .. edict_mc)
    entityLimitLabel:SetFont("arb.Font_FuturaPTBook_7")
    entityLimitLabel:SetTextColor(color_white)
    entityLimitLabel:Dock(BOTTOM)
    entityLimitLabel:DockMargin(25, 0, 0, 15)
    entityLimitLabel:SizeToContents()

    self:CreatePlayers(scrollPanel)
end

local priority = {
    founder = 1,
    curator = 2,
    gamemaster = 3,
    guard = 4,
    developer = 5
}
function PANEL:SortPlayers()
    local players = player.GetAll()

    -- for i = 1, 15 do
    --     players[#players + 1] = players[1]
    -- end

    table.sort(players, function(a, b)
        local aGroup = a:GetUserGroup()
        local bGroup = b:GetUserGroup()

        local aPriority = priority[aGroup] or math.huge
        local bPriority = priority[bGroup] or math.huge

        return aPriority < bPriority
    end)

    return players
end

---@param scrollPanel DScrollPanel
function PANEL:CreatePlayers(scrollPanel)
    local fontLabel = "arb.Font_FuturaPTBook_10"
    local fontHeight = draw.GetFontHeight(fontLabel)

    if Arbitrage.OffShowFactions() then
        local errorPanel = scrollPanel:Add("DPanel")
        errorPanel:SetTall(fontHeight * 10)
        errorPanel:Dock(TOP)
        errorPanel:DockMargin(0, 0, 0, H(30))
        errorPanel.Paint = function(this, w, h)
            draw.DrawText(L("#tab_hidden"), fontLabel, w / 2, h * 0.35, color_white, TEXT_ALIGN_CENTER)
        end

        if !LocalPlayer():IsAdmin() then -- даем админу использовать ТАБ
            return
        end

        errorPanel:SetTall(H(100))
    end

    local role_mat = Material("asterion/academy/ui/scoreboard/role.png")
    local banner_mini_mask = BMASKS.CreateMask("banner_mini_mask", "asterion/academy/ui/scoreboard/banner_mini_mask.png")
    local players = self:SortPlayers()

    ---@param client Player
    Throttle(players, 1, 0.01, function(client)
        if !IsValid(self) then return end
        if !IsValid(client) then return end

        local steamName = client:SteamName()
        local characterName = client:Name()
        local steamID = client:SteamID()
        local ping = client:Ping()
        local rank = client:GetUserGroup()

        local user_info = client:GetNetVar("user_info", {})
        local banner_mini_url = user_info.banner_mini
        local banner_mini = nil
        if banner_mini_url then
            asterionlib.downloader:Image(banner_mini_url, function(mat, path)
                banner_mini = mat
            end)
        end

        local panel = scrollPanel:Add("Panel")
        panel:SetAlpha(0)
        panel:AlphaTo(255, 0.5)
        panel:SetTall(fontHeight + 12)
        panel:Dock(TOP)
        panel:DockMargin(0, 0, 0, 5)
        panel.Paint = function(this, w, h)
            surface.SetDrawColor(0, 0, 0, 220)
            surface.DrawRect(0, 0, w, h)

            if banner_mini then
                local mask_w = w
                local mask_h = mask_w * banner_mini:Height() / banner_mini:Width()

                BMASKS.BeginMask(banner_mini_mask)
                    surface.SetDrawColor(255, 255, 255)
                    surface.SetMaterial(banner_mini)
                    surface.DrawTexturedRect(h + w / 2 - mask_w / 2, h / 2 - mask_h / 2, mask_w, mask_h)
                BMASKS.EndMask(banner_mini_mask, h, 0, w, h)

                surface.SetDrawColor(0, 0, 0, 50)
                surface.DrawRect(0, 0, w, h)
            end
        end

        local avatar = panel:Add("AvatarImage")
        avatar:Dock(LEFT)
        avatar:SetWide(panel:GetTall())
        avatar:SetPlayer(client, 64)

        local button = panel:Add("DButton")
        button:SetText("")
        button:SetPos(0, 0)
        button:SetSize(ScrW() - padding * 2 - self.info:GetWide() - 15, panel:GetTall())
        button.alpha = 0
        button.Paint = function(this, w, h)
            this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 0.7 or 0)
            w = panel:GetWide()

            surface.SetDrawColor(0, 0, 0, this.alpha * 255)
            surface.DrawRect(h, 0, w - h, h)

            drawText(steamName, fontLabel, panel:GetTall() + 15, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            drawText(characterName, fontLabel, w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            drawText(ping, fontLabel, w - 20, h / 2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

            if priority[rank] then
                local rank_color = Moderation.instances[rank].color

                if rank_color then
                    surface.SetDrawColor(rank_color.r, rank_color.g, rank_color.b)
                    surface.SetMaterial(role_mat)
                    surface.DrawTexturedRect(w - h, 0, h, h)
                end
            end
        end
        button.Click = function()
            local menu = DermaMenu(false, self)
            menu:SetAlpha(0)
            menu:AlphaTo(255, 0.25)
            paintMenu(menu)

            local tabCopyID = menu:AddOption(L("#tab_copyid"), function()
                SetClipboardText(steamID)
            end)
            tabCopyID:SetIcon("icon16/book_link.png")
            paintOption(tabCopyID)

            local tabCheckProfile = menu:AddOption(L("#tab_checkprofile"), function()
                gui.OpenURL(Format("https://steamcommunity.com/profiles/%s", util.SteamIDTo64(steamID)))
            end)
            tabCheckProfile:SetIcon("icon16/page_green.png")
            paintOption(tabCheckProfile)

            local tabPM = menu:AddOption(L("#tab_pm"), function()
                local chatbox = Arbitrage.gui.chat
                if !IsValid(chatbox) then return end

                self:Remove()
                chatbox.entry:SetValue("")

                timer.Simple(0.3, function()
                    local text = ("/pm %s "):format(steamID)

                    chatbox:SetActive(true)
                    chatbox.entry:SetValue(text)
                    chatbox.entry:RequestFocus()
                    chatbox.entry:SetCaretPos(utf8.len(text))
                end)
            end)
            tabPM:SetIcon("icon16/layout_add.png")
            paintOption(tabPM)

            menu:SetPos(gui.MouseX(), gui.MouseY())
        end
        button.DoClick = button.Click
        button.DoRightClick = button.Click
    end)
end

local screenMat = Material("asterion/academy/ui/radial/screen.png")

---@param w number
---@param h number
function PANEL:Paint(w, h)
    asterionlib.DrawBlur(self, 1)

    surface.SetDrawColor(0, 0, 0, 50)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(screenMat)
    surface.DrawTexturedRect(0, 0, w, h)

    draw.SimpleText(("%s | %s"):format(Time:GetFormated(), L(Arbitrage.GetChapter())), "arb.Font_FuturaPTBook_10", w / 2, 50, Color(255, 255, 255), TEXT_ALIGN_CENTER)
end

vgui.Register("arb.ScoreBoard", PANEL, "EditablePanel")