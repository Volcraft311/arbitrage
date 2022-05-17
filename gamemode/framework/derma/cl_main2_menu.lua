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

local ds_link = "https://discord.gg/WCT65T4uzR"
local vk_link = "https://vk.com/asterionacademy"
local wiki_link = "https://discord.gg/WCT65T4uzR"

function PANEL:Init()
    local parent = self:GetParent()

    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self:SetSize(ScrW(), ScrH())

    self.panels = {}

    self.characterButton = self:AddButton("Выбрать персонажа", nil, ScrW() / 2 - W(276) / 2, H(433), W(276), H(52), function()
        parent:Bluring(true)
        parent:ShowLogo(false)
        self:Show(false)
        parent:Characters()
    end)

    self.characterButton:SetDisabled(Arbitrage.IsStartGame())

    local isSpectate = LocalPlayer():IsSpectate()
    self.spectateButton = self:AddButton(isSpectate and "Выйти из наблюдения" or "Стать наблюдателем", nil, ScrW() / 2 - W(276) / 2, H(505), W(276), H(52), function()
        if isSpectate then
            RunConsoleCommand("arb_join_notcharacter")
        else
            netstream.Start("arb.SelectCharacter", TEAM_SPECTATE)
        end

        parent:ClosePanel()
    end)

    self.spectateButton:SetDisabled(false)

    if !isSpectate then
        if !Arbitrage.IsStartGame() then
            self.spectateButton:SetDisabled(true)
        else
            if LocalPlayer():Alive() then
                self.spectateButton:SetDisabled(true)
            end
        end
    end

    self.discordButton = self:AddButton(nil, Material("danganronpa/ui/discord_mini.png"), ScrW() / 2 - W(276) / 2, H(577), W(52), H(52), function()
        gui.OpenURL(ds_link)
    end)

    self.vkButton = self:AddButton(nil, Material("danganronpa/ui/vk_mini.png"), ScrW() / 2 - W(276) / 2 + (W(23) + W(52)) * 1, H(577), W(52), H(52), function()
        gui.OpenURL(vk_link)
    end)

    self.wikiButton = self:AddButton(nil, Material("danganronpa/ui/wiki_mini.png"), ScrW() / 2 - W(276) / 2 + (W(23) + W(52)) * 2, H(577), W(52), H(52), function()
        gui.OpenURL(wiki_link)
    end)

    self.settingsButton = self:AddButton(nil, Material("danganronpa/ui/settings_mini.png"), ScrW() / 2 - W(276) / 2 + (W(23) + W(52)) * 3, H(577), W(52), H(52), function()
        parent:Bluring(true)
        parent:ShowLogo(false)
        self:Show(false)
        parent:Settings()
    end)

    self.closeButton = self:AddButton("Закрыть меню", nil, ScrW() / 2 - W(276) / 2, H(709), W(276), H(52), function()
        parent:ClosePanel()
    end)
end

function PANEL:AddButton(text, icon, x, y, w, h, func)
    local parent = self:GetParent()

    local panel = self:Add("DButton")
    panel:SetText("")
    panel:SetAlpha(0)
    panel:AlphaTo(255, 0.5)
    panel:SetPos(x, y)
    panel:SetSize(w, h)
    panel.Paint = function(_, w, h)
        parent:DesignButton(_, text, w, h, icon)
    end

    if func and isfunction(func) then
        panel.DoClick = function()
            func()
        end
    end

    self.panels[#self.panels + 1] = panel

    return panel
end

function PANEL:Show(bState)
    self:AlphaTo(bState and 255 or 0, 0.5)
end

function PANEL:Paint(w, h)
    draw.SimpleText("Добро пожаловать, " .. LocalPlayer():SteamName(), "arb.Font_FuturaPTBook_12", w / 2, H(310), Color(255, 234, 238), TEXT_ALIGN_CENTER)

    surface.SetDrawColor(255, 234, 238, 3)
    surface.DrawRect(w / 2 - W(460) / 2, H(391), W(460), H(2))
end

vgui.Register("arb.MainRemake:Menu", PANEL, "EditablePanel")