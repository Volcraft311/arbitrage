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

local padding = 0.1
local margin = 2.3

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

function PANEL:Init()
    Arbitrage.gui.scoreboard = self

    self.isShow = !Arbitrage.OffShowFactions()

    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)

    self:SetKeyboardInputEnabled(false)

    local scrollBar = self:Add("DScrollPanel")
    scrollBar:SetPos(ScrW() / 2 - W(1000) / 2, H(131))
    scrollBar:SetSize(W(1000), H(668))

    local bar = scrollBar:GetVBar()
    bar:SetWide(10)
    bar:DockMargin(0, 0, 0, 0)

    bar.Paint = function(_, w, h)
        surface.SetDrawColor(255, 255, 255, 3)
        surface.DrawRect(7, 10, w, h - 20)
    end
    bar.btnUp.Paint = function(_, w, h) end
    bar.btnDown.Paint = function(_, w, h) end
    bar.btnGrip.Paint = function(_, w, h)
        surface.SetDrawColor(255, 255, 255)
        surface.DrawRect(7, 10, w, h - 20)
    end

    if !self.isShow then return end
    for k, v in ipairs(player.GetAll()) do
        local steamid = v:SteamID()
        local faction = v:Team()
        local factionData = Character.team:GetByID(faction)
        if !factionData then continue end

        local matPing = Format(path, "connect_1")
        for k2, v2 in ipairs(pingData) do
            if v:Ping() >= v2.min and v:Ping() <= v2.max then
                matPing = v2.data
                break
            end
        end

        matPing = Material(matPing)

        local factionName = factionData.name
        local clientName = v:SteamName()
        local groupName = v:GetUserGroup() ~= "user" and v:GetUserGroup() or ""

        local fakename = v:FakeName()
        if fakename then
            factionName = fakename
        end

        local panel = scrollBar:Add("DPanel")
        panel:SetTall(H(44))
        panel:Dock(TOP)
        panel:DockMargin(0, 0, 0, H(8))
        panel.Paint = function(_, w, h)
            local ping = (IsValid(v) and v:Ping() ~= 0) and v:Ping() or "!"

            surface.SetDrawColor(5, 2, 2, 204)
            surface.DrawRect(0, 0, w, h)

            draw.DrawText(clientName, "arb.Font_FuturaPTBook_9", h + 5, H(6), Color(255, 234, 238), TEXT_ALIGN_LEFT)
            draw.DrawText(factionName, "arb.Font_FuturaPTBook_9", w / 2, H(6), Color(255, 234, 238), TEXT_ALIGN_CENTER)
            draw.DrawText(groupName, "arb.Font_FuturaPTBook_9", w * 0.76, H(6), Color(255, 234, 238), TEXT_ALIGN_CENTER)
            draw.DrawText(ping, "arb.Font_FuturaPTBook_9", w - h, H(6), Color(255, 234, 238), TEXT_ALIGN_LEFT)

            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(matPing)
            surface.DrawTexturedRect(w - h * 2, 0, h, h)
        end

        local panelImage = panel:Add("AvatarImage")
        panelImage:Dock(LEFT)
        panelImage:SetPlayer(v, 64)
        panelImage:SetWide(panel:GetTall())

        local imageButton = panelImage:Add("DButton")
        imageButton:SetText("")
        imageButton:Dock(FILL)
        imageButton.Paint = nil
        imageButton.DoClick = function()
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

function PANEL:Paint(w, h)
    surface.SetDrawColor(15, 6, 7, 255 * 0.9)
    surface.DrawRect(0, 0, ScrW(), ScrH())

    asterionlib.DrawBlurAt(0, 0, ScrW(), ScrH(), 5, nil, 255)

    draw.DrawText(Format("%s | %s", Arbitrage.GetTime(), Arbitrage.GetChapter()), "arb.Font_FuturaPTBook_10", ScrW() / 2, 50, Color( 255, 255, 255, 255), TEXT_ALIGN_CENTER)

    if !self.isShow then
        draw.DrawText("Администрация скрыла список игроков.", "arb.Font_FuturaPTBook_10", ScrW() / 2, ScrH() / 2 - 50, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
    end
end

vgui.Register("arb.ScoreBoard", PANEL, "EditablePanel")