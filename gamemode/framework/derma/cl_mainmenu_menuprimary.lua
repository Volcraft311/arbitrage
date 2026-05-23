local PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 1)

    self.paddingLeft = 150
    self.paddingTop = 135
    self.lerpX = 0
    self.lerpY = 0
    self.speed = 0.2
    self.padding = 0.07
    self._height = 0

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

    self.buttonsPanel = self:Add("Panel")
    self.buttonsPanel:SetTall(0)
    self.buttonsPanel:Dock(BOTTOM)
    self.buttonsPanel:DockMargin(0, 70, 0, ScrH() * 0.3)

    self.descriptionPanel = self:Add("DLabel")
    self.descriptionPanel:SetText("")
    self.descriptionPanel:SetFont("arb.Font_FuturaPTBook_9")
    self.descriptionPanel:SetTextColor(Color(255, 255, 255))
    self.descriptionPanel:SetContentAlignment(1)
    self.descriptionPanel:Dock(FILL)
    self.descriptionPanel:DockMargin(self.paddingLeft, 0, 0, 0)
    self.descriptionPanel.alpha = 0
    self.descriptionPanel.Think = function(this)
        local panel = vgui.GetHoveredPanel()

        if IsValid(panel) and panel.description then
            if this:GetText() != panel.description then
                this.alpha = 0
                this:SetText(panel.description)
            end
        else
            this:SetText("")
        end

        this.alpha = Lerp(FrameTime() * 2.5, this.alpha, 255)
        this:SetAlpha(this.alpha)
    end

    self:AddButton("ВЫЙТИ С СЕРВЕРА", "Отключиться от сервера", function()
        RunConsoleCommand("disconnect")
    end)

    self:AddButton("НАСТРОЙКИ", "Перейти в раздел изменения ваших\nигровых параметров", function()
        local parent = self:GetParent()

        self:HideUI()

        parent.settings = self:Add("arb.mainmenu:Settings")
        parent.settings:SetPos(0, 0)
        parent.settings:SetSize(self:GetWide(), self:GetTall())
    end)

    self:AddButton("ПЕРСОНАЛИЗАЦИЯ", "Перейти в раздел изменения ваших\nигровых параметров", function()
        local parent = self:GetParent()

        self:HideUI()

        parent.customization = self:Add("arb.mainmenu:Customization")
        parent.customization:SetPos(0, 0)
        parent.customization:SetSize(self:GetWide(), self:GetTall())
    end)

    self.manual = self:AddButton("РУКОВОДСТВО", "", function()
    end)
    self.manual:SetDisabled(true)

    local isSpectate = LocalPlayer():IsSpectate()
    self.buttonSpectate = self:AddButton(isSpectate and "ВЫЙТИ ИЗ НАБЛЮДЕНИЯ" or "НАБЛЮДАТЬ ЗА ИГРОЙ", "Войти в режим наблюдения за игровым\nпроцессом", function()
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

    self.buttonCharacter = self:AddButton("ВЫБРАТЬ ПЕРСОНАЖА", "Перейти в раздел выбора персонажа\nиз разных частей Danganronpa", function()
        local parent = self:GetParent()

        self:HideUI()

        parent.characters = self:Add("arb.mainmenu:Characters")
        parent.characters:SetPos(0, 0)
        parent.characters:SetSize(self:GetWide(), self:GetTall())
    end):SetDisabled(Arbitrage.IsStartGame())

    local wide = self:GetWide()
    local tall = self:GetTall()

    self.character = self:Add("DPanel")
    self.character:SetPos(wide - 1, 0)
    self.character:SetSize(1, tall)
    self.character.lerpX = 0
    self.character.lerpY = 0
    self.character.padding = 0.07
    self.character.speed = 1
    self.activeAlpha = 0
    self.character.Paint = function(this, w, h)
        w = ScrW()
        h = ScrH()

        local ft = FrameTime()
        local x, y = math.Clamp(gui.MouseX(), 0, w), math.Clamp(gui.MouseY(), 0, h)
        local Wx, Wy = -((w / 2 - x) * self.padding), -((h / 2 - y) * self.padding)

        self.lerpX = Lerp(ft * self.speed, self.lerpX, Wx)
        self.lerpY = Lerp(ft * self.speed, self.lerpY, Wy)

        local width = w + (w * self.padding)
        local heigth = width * 0.5625

        local characterMat = Arbitrage.theme:GetPrimaryBackgroundCharacter()
        if characterMat then
            local old = DisableClipping(true)
                surface.SetDrawColor(255, 255, 255)
                surface.SetMaterial(characterMat)
                surface.DrawTexturedRect(-w + w / 2 - width / 2 + self.lerpX, h / 2 - heigth / 2 + self.lerpY, width, heigth)
            DisableClipping(old)
        end
    end

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

    local panel = asterionlib.ui.aid
    if IsValid(panel) then
        panel:SetAlpha(0)
    end
end

function PANEL:OnRemove()
    local panel = asterionlib.ui.aid
    if IsValid(panel) then
        panel:SetAlpha(200)
    end
end

function PANEL:HideUI()
    self:AlphaTo(0, 0.5)
end

function PANEL:UnHideUI()
    self:AlphaTo(255, 0.5)
end

function PANEL:AddButton(name, description, callback)
    local buttonFont = "arb.Font_FuturaPTBook_11"
    local buttonFontHeight = draw.GetFontHeight(buttonFont) * 1.21212121212

    local button = self.buttonsPanel:Add("DButton")
    button:SetText("")
    button.description = description
    button:SetTall(buttonFontHeight)
    button:Dock(BOTTOM)
    button.alpha = 0
    button.color = Arbitrage.theme:GetTextButton()
    button.Paint = function(this, w, h)
        this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 1 or 0)
        this.color = LerpColor(FrameTime() * 10, this.color, this:IsHovered() and Arbitrage.theme:GetTextHover() or Arbitrage.theme:GetTextButton())

        if this:GetDisabled() then
            this.color = Arbitrage.theme:GetTextLocked()
        end

        local matLine = Arbitrage.theme:GetPrimaryBackgroundSelectLine()
        if matLine then
            asterionlib.DrawRender(function()
                surface.SetDrawColor(255, 255, 255)
                surface.DrawRect(0, 0, w * this.alpha, h)
            end, function()
                surface.SetDrawColor(255, 255, 255)
                surface.SetMaterial(matLine)
                surface.DrawTexturedRect(0, 0, w, h)
            end)
        else
            local lineColor = Arbitrage.theme:GetVisSelectionLine()
            surface.SetDrawColor(lineColor.r, lineColor.g, lineColor.b, 255 * this.alpha)
            surface.DrawRect(0, 0, w * this.alpha, h)
        end

        draw.SimpleText(name, buttonFont, self.paddingLeft, h / 2, this.color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    button.DoClick = function()
        callback()
    end

    self.buttonsPanel:SetTall(self.buttonsPanel:GetTall() + buttonFontHeight)

    return button
end

function PANEL:Paint(w, h)
    local ft = FrameTime()
    local x, y = math.Clamp(gui.MouseX(), 0, w), math.Clamp(gui.MouseY(), 0, h)
    local Wx, Wy = -((w / 2 - x) * self.padding), -((h / 2 - y) * self.padding)

    self.lerpX = Lerp(ft * self.speed, self.lerpX, Wx)
    self.lerpY = Lerp(ft * self.speed, self.lerpY, Wy)

    local mountColor = Arbitrage.theme:GetVisMount()
    surface.SetDrawColor(mountColor.r, mountColor.g, mountColor.b, mountColor.a)
    surface.DrawRect(0, h - self._height, w, self._height + 2)

    local _, height = draw.SimpleText(("Arbitrage Framework %s | AsterionLib %s"):format(Arbitrage.version, asterionlib.version), "arb.Font_FuturaPTBook_6", 25, h - self._height + self._height / 2, Arbitrage.theme:GetTextTertriary(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

    self._height = height * 2.11111111111
end

vgui.Register("arb.mainmenu:MenuPrimary", PANEL, "Panel")