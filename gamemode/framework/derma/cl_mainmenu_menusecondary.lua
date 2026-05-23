local PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:SetAlpha(0)
    self:AlphaTo(255, 0.5)

    self.paddingLeft = 150
    self.paddingTop = 90

    local material_logo = Material("asterion/academy/ui/bg_logo.png", "smooth")
    local wide_logo = ScrH() * 0.27777777777
    self.logo = self:Add("DPanel")
    self.logo:Dock(TOP)
    self.logo:DockMargin(self.paddingLeft, self.paddingTop, 0, 0)
    self.logo:SetTall(ScrH() * 0.0787037037)
    self.logo.Paint = function(_, w, h)
        local color = Arbitrage.theme:GetVisLogos()

        surface.SetDrawColor(color.r, color.g, color.b, 255)
        surface.SetMaterial(material_logo)
        surface.DrawTexturedRect(0, 0, wide_logo, h)
    end

    self.buttonsPanel = self:Add("DPanel")
    self.buttonsPanel:SetTall(0)
    self.buttonsPanel:Dock(TOP)
    self.buttonsPanel:DockMargin(self.paddingLeft, self.paddingTop, 0, 0)
    self.buttonsPanel.Paint = function(_, w, h)
        local informationColor = Arbitrage.theme:GetInformation()

        surface.SetDrawColor(informationColor.r, informationColor.g, informationColor.b)

        for i = 1, 50 do
            surface.DrawRect(0, (i - 1) * 7 + 4 * (i - 1), 2, 7)
        end
    end

    self.buttonCharacter = self:AddButton("СМЕНИТЬ ПЕРСОНАЖА", function()
        local parent = self:GetParent()

        self:HideUI()

        parent.characters = self:Add("arb.mainmenu:Characters")
        parent.characters:SetPos(0, 0)
        parent.characters:SetSize(self:GetWide(), self:GetTall())
    end):SetDisabled(Arbitrage.IsStartGame())

    local isSpectate = LocalPlayer():IsSpectate()
    self.buttonSpectate = self:AddButton(isSpectate and "ВЫЙТИ ИЗ НАБЛЮДЕНИЯ" or "НАБЛЮДАТЬ", function()
        if isSpectate then
            RunConsoleCommand("arb_join_notcharacter")
        else
            netstream.Start("arb.SelectCharacter", TEAM_SPECTATE)
        end

        local mainMenu = Arbitrage.menu
        mainMenu:AlphaTo(0, 0.25, 0, function()
            mainMenu:Remove()
        end)
    end)

    if !isSpectate then
        if !Arbitrage.IsStartGame() then
            self.buttonSpectate:SetDisabled(true)
        else
            if LocalPlayer():Alive() then
                self.buttonSpectate:SetDisabled(true)
            end
        end
    end

    self:AddButton("НАСТРОЙКИ", function()
        local parent = self:GetParent()

        self:HideUI()

        parent.settings = self:Add("arb.mainmenu:Settings")
        parent.settings:SetPos(0, 0)
        parent.settings:SetSize(self:GetWide(), self:GetTall())
    end)

    self:AddButton("КАСТОМИЗАЦИЯ", function()
        local parent = self:GetParent()

        self:HideUI()

        parent.customization = self:Add("arb.mainmenu:Customization")
        parent.customization:SetPos(0, 0)
        parent.customization:SetSize(self:GetWide(), self:GetTall())
    end)

    self:AddButton("ГЛАВНОЕ МЕНЮ", function()
        local parent = self:GetParent()

        parent:AlphaTo(0, 0.25, 0, function()
            parent:Remove()
        end)

        gui.ActivateGameUI()
    end)

    local newPanel = self:Add("arb.mainmenu:News")
    newPanel:SetSize(S(410), S(133))
    newPanel:SetPos(ScrW() - newPanel:GetWide() - self.paddingLeft, ScrH() - newPanel:GetTall() - self.paddingTop)

    local infoFont = "arb.Font_FuturaPTMedium_9"
    local infoFontHeight = draw.GetFontHeight(infoFont)

    local infoPanel = self:Add("Panel")
    infoPanel:SetSize(infoFontHeight * 12.5925925926, infoFontHeight * 1.85185185185)
    infoPanel:SetPos(ScrW() - self.paddingLeft - infoPanel:GetWide(), self.paddingTop)

    local languageButton = infoPanel:Add("DButton")
    languageButton:SetText("")
    languageButton:Dock(RIGHT)
    languageButton:DockMargin(10, 0, 0, 0)
    languageButton:SetWide(infoPanel:GetTall())
    languageButton.alpha = 0
    languageButton.Paint = function(this, w, h)
        this.alpha = Lerp(FrameTime() * 5, this.alpha, this:IsHovered() and 1 or 0)

        local color_white = Arbitrage.theme:GetVisLogoSelect()
        surface.SetDrawColor(color_white.r, color_white.g, color_white.b, 255 * this.alpha)
        surface.DrawRect(0, 0, w, h)

        local color = Arbitrage.theme:GetVisLogos()
        surface.SetDrawColor(color.r, color.g, color.b)
        surface.SetMaterial(Material("asterion/academy/ui/icons/lang.png", "smooth"))
        surface.DrawTexturedRect(0, 0, w, h)
    end
    languageButton.DoClick = function()
        local parent = self:GetParent()

        self:HideUI()

        parent.lang = self:Add("arb.mainmenu:Lang")
        parent.lang:SetPos(0, 0)
        parent.lang:SetSize(self:GetWide(), self:GetTall())
    end

    local avatar = infoPanel:Add("AvatarImage")
    avatar:Dock(LEFT)
    avatar:SetPlayer(LocalPlayer(), 64)
    avatar:SetWide(infoPanel:GetTall())

    local banner_bg_mini_mask = BMASKS.CreateMask("banner_bg_mini_mask", "asterion/academy/ui/scoreboard/banner_mini_mask.png")
    local user_info = LocalPlayer():GetNetVar("user_info", {})
    local banner_mini_url = user_info.banner_mini
    local banner_mini = nil
    if banner_mini_url then
        asterionlib.downloader:Image(banner_mini_url, function(mat, path)
            banner_mini = mat
        end)
    end

    local name = infoPanel:Add("DPanel")
    name:Dock(FILL)
    name.Paint = function(this, w, h)
        surface.SetDrawColor(0, 0, 0, 220)
        surface.DrawRect(0, 0, w, h)

        if banner_mini then
            local mask_w = w
            local mask_h = mask_w * banner_mini:Height() / banner_mini:Width()
            local mat_w = w * (h / mask_h)
            local mat_h = mask_h * (h / mask_h)

            BMASKS.BeginMask(banner_bg_mini_mask)
                surface.SetDrawColor(255, 255, 255)
                surface.SetMaterial(banner_mini)
                surface.DrawTexturedRect(-(banner_mini:Width() / 2), -(banner_mini:Height() / 2 - banner_mini:Height() / 2), mat_w, mat_h)
            BMASKS.EndMask(banner_bg_mini_mask, 0, 0, w, h)

            surface.SetDrawColor(0, 0, 0, 50)
            surface.DrawRect(0, 0, w, h)
        end

        draw.SimpleText(LocalPlayer():SteamName(), "arb.Font_FuturaPTMedium_9", 15, h / 2, Arbitrage.theme:GetPlayerTitle(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end

function PANEL:HideUI()
    self:AlphaTo(0, 0.5)
end

function PANEL:UnHideUI()
    self:AlphaTo(255, 0.5)
end

function PANEL:AddButton(name, callback)
    local buttonFont = "arb.Font_FuturaPTMedium_14"
    local buttonFontHeight = draw.GetFontHeight(buttonFont)

    local button = self.buttonsPanel:Add("DButton")
    button:SetText("")
    button:SetTall(buttonFontHeight)
    button:Dock(TOP)
    button:DockMargin(0, 5, ScrW() - buttonFontHeight * 13.5, 5)
    button.alpha = 0
    button.color = Arbitrage.theme:GetInformation()
    button.Paint = function(this, w, h)
        local informationColor = Arbitrage.theme:GetInformation()

        local ft = FrameTime()

        this.alpha = Lerp(ft * 5, this.alpha, this:IsHovered() and 1 or 0)
        this.color = LerpColor(ft * 10, this.color, this:IsHovered() and Color(255, 255, 255, this:GetDisabled() and 50 or 255) or Color(informationColor.r, informationColor.g, informationColor.b, this:GetDisabled() and 50 or 255))

        surface.SetDrawColor(informationColor.r, informationColor.g, informationColor.b, 255 * this.alpha)
        surface.DrawRect(0, 0, w * this.alpha, h)

        draw.SimpleText(name, buttonFont, 20, h / 2, this.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    button.DoClick = function()
        callback()
    end

    self.buttonsPanel:SetTall(self.buttonsPanel:GetTall() + buttonFontHeight + 10)

    return button
end

vgui.Register("arb.mainmenu:MenuSecondary", PANEL, "Panel")