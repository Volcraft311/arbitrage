local PANEL = {}

local musicChanel = nil

function PANEL:Init()
    if IsValid(Arbitrage.menu) then
        Arbitrage.menu:Remove()
    end

    Arbitrage.menu = self

    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()

    self.lerpX = 0
    self.lerpY = 0
    self.padding = 0.07
    self.speed = 1
    self.activeAlpha = 0
    self.music = nil

    self.parallaxPrimary = {
        speed = 0.75,
        padding = 0.1,
        lerpX = 0,
        lerpY = 0
    }

    self.parallaxSecondary = {
        speed = 0.25,
        padding = 0.05,
        lerpX = 0,
        lerpY = 0
    }
    if (musicChanel) then
        self:StopMusic()
        musicChanel = nil
    end
    timer.Simple(0.2, function()
        sound.PlayFile("sound/main_music.mp3", "", function(channel, _, _)
            musicChanel = channel
            channel:SetVolume(0.3)
        end)
    end)
end

function PANEL:StopMusic()
    if musicChanel != nil then
        timer.Create("Arb.MenuMusicFade", 0.1, 8, function()
            if ! musicChanel then return end
            musicChanel:SetVolume(math.Clamp(musicChanel:GetVolume() - 0.05, 0, 1))
        end)
        timer.Simple(1, function()
            musicChanel:Stop()
            musicChanel = nil
        end)
    end
end

function PANEL:OnRemove()
    self:StopMusic()
end

function PANEL:Paint(w, h)
    local ft = FrameTime()
    local x, y = math.Clamp(gui.MouseX(), 0, w), math.Clamp(gui.MouseY(), 0, h)
    local Wx, Wy = -((w / 2 - x) * self.padding), -((h / 2 - y) * self.padding)

    self.lerpX = Lerp(ft * self.speed, self.lerpX, Wx)
    self.lerpY = Lerp(ft * self.speed, self.lerpY, Wy)

    local material_bg = Arbitrage.theme:GetPrimaryBackground()
    if material_bg then
        local width = w + (w * self.padding)
        local heigth = width * 0.5625

        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(material_bg)
        surface.DrawTexturedRect(w / 2 - width / 2 - self.lerpX, h / 2 - heigth / 2 - self.lerpY, width, heigth)
    else
        surface.SetDrawColor(0, 0, 0)
        surface.DrawRect(0, 0, w, h)
    end

    self.activeAlpha = Lerp(ft, self.activeAlpha, IsValid(self.content) and 0 or 1)
    local material_active_bg = Arbitrage.theme:GetPrimaryBackgroundActive()
    if material_active_bg and self.activeAlpha > 0.05 then
        local width = w + (w * self.padding)
        local heigth = width * 0.5625

        surface.SetDrawColor(255, 255, 255, 255 * self.activeAlpha)
        surface.SetMaterial(material_active_bg)
        surface.DrawTexturedRect(w / 2 - width / 2 - self.lerpX, h / 2 - heigth / 2 - self.lerpY, width, heigth)
    end

    local material_parallax_p = Arbitrage.theme:GetPrimaryBackgroundParallaxPrimary()
    if material_parallax_p then
        local width = w + (w * self.parallaxPrimary.padding)
        local heigth = width * 0.5625

        self.parallaxPrimary.lerpX = Lerp(ft * self.parallaxPrimary.speed, self.parallaxPrimary.lerpX, Wx)
        self.parallaxPrimary.lerpY = Lerp(ft * self.parallaxPrimary.speed, self.parallaxPrimary.lerpY, Wy)

        surface.SetDrawColor(255, 255, 255, 230)
        surface.SetMaterial(material_parallax_p)
        surface.DrawTexturedRect(w / 2 - width / 2 - self.parallaxPrimary.lerpX * 0.5,
            h / 2 - heigth / 2 - self.parallaxPrimary.lerpY * 0.5, width, heigth)
    end

    local material_parallax_s = Arbitrage.theme:GetPrimaryBackgroundParallaxSecondary()
    if material_parallax_s then
        local width = w + (w * self.parallaxSecondary.padding)
        local heigth = width * 0.5625

        self.parallaxSecondary.lerpX = Lerp(ft * self.parallaxSecondary.speed, self.parallaxSecondary.lerpX, Wx)
        self.parallaxSecondary.lerpY = Lerp(ft * self.parallaxSecondary.speed, self.parallaxSecondary.lerpY, Wy)

        surface.SetDrawColor(255, 255, 255, 230)
        surface.SetMaterial(material_parallax_s)
        surface.DrawTexturedRect(w / 2 - width / 2 - self.parallaxSecondary.lerpX * 0.25,
            h / 2 - heigth / 2 - self.parallaxSecondary.lerpY * 0.25, width, heigth)
    end
end

vgui.Register("arb.mainmenu:Primary", PANEL, "Panel")

concommand.Add("arb_mainmenu_open", function(ply, cmd, args)
    local panel = vgui.Create("arb.mainmenu:Primary")
    local primaryMenu = panel:Add("arb.mainmenu:MenuPrimary")
    primaryMenu:Dock(FILL)
end)

concommand.Add("arb_mainmenu_content_open", function(ply, cmd, args)
    local panel = vgui.Create("arb.mainmenu:Primary")
    panel.content = panel:Add("arb.mainmenu:Content")
    panel.content:Dock(FILL)
end)
