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


surface.CreateFont( "arb.SplashScreenFont", {
	font = "Futura PT Book",
	extended = true,
	size = ScreenScale(32),
	weight = 400,
	antialias = true
})

surface.CreateFont( "arb.SplashScreenBlurFont", {
	font = "Futura PT Book",
	extended = true,
	size = ScreenScale(32),
	weight = 400,
	antialias = true,
    blursize = 11
})

surface.CreateFont( "arb.SplashScreenFont2", {
	font = "Futura PT Book",
	extended = true,
	size = ScreenScale(20),
	weight = 400,
	antialias = true
})

surface.CreateFont( "arb.SplashScreenBlurFont2", {
	font = "Futura PT Book",
	extended = true,
	size = ScreenScale(20),
	weight = 400,
	antialias = true,
    blursize = 11
})

local PANEL = {}


function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:SetAlpha(0)
    self:AlphaTo(255, 2)
    self:MakePopup()

    Arbitrage.gui.splashscreen = self

    self.th = CurTime() + 4

    timer.Simple(3, function()
        if !IsValid(self) then return end

        local bA = 0

        self.matScreen = self:Add("Panel")
        self.matScreen:Dock(FILL)
        self.matScreen.alpha = 0
        self.matScreen.black = 0
        self.matScreen.alpha2 = 0
        self.matScreen.malpha2 = 0
        self.matScreen.Paint = function(_, w, h)
            bA = Lerp(FrameTime() * 5, bA, _.black)
            _.alpha = Lerp(FrameTime(), _.alpha, 235)
            _.alpha2 = Lerp(FrameTime() * 3, _.alpha2, _.malpha2)

            surface.SetDrawColor(255, 255, 255, _.alpha)
            surface.SetMaterial(Material("danganronpa/splashscreen/bg.png"))
            surface.DrawTexturedRect(0, 0, w, h)

            local scrollMod1 = (CurTime() * 2000) % (h + 3000)
            local scrollMod2 = ((CurTime() * 2500) + 400) % (h + 3000)
            local scrollMod3 = (CurTime() * 1000) % (h + 3000)
            local scrollMod4 = (CurTime() * 1500) % (h + 3000)
            local scrollMod5 = (CurTime() * 1400) % (h + 3000)
            local scrollMod6 = (CurTime() * 1800) % (h + 3000)

            surface.SetDrawColor(0, 0, 0, 75)
            surface.DrawRect(0, h - scrollMod1, w, 30)
            surface.DrawRect(0, scrollMod2, w, 50)
            surface.SetDrawColor(255, 255, 255, 50)
            surface.DrawRect(0, scrollMod3, w, 65)
            surface.DrawRect(0, h - scrollMod4, w, 40)

            surface.SetDrawColor(0, 0, 0, _.alpha2)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(0, 0, 0, bA)
            surface.DrawRect(0, 0, w, h)

            asterionlib.DrawBlurAt(0, scrollMod5, ScrW(), 25, 5, nil, 255)
            asterionlib.DrawBlurAt(0, h - scrollMod6, ScrW(), 10, 5, nil, 255)

            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(Material("danganronpa/splashscreen/vignette.png"))
            surface.DrawTexturedRect(0, 0, w, h)
        end
        self.matScreen.Think = function(_)
            if (!self.th or CurTime() >= self.th) then
                _.black = 260

                -- хуево выглядит, надо бы как нить переделать, но это уже в другой жизни)
                timer.Simple(0.3, function()
                    if !IsValid(self) or !IsValid(_) then return end
                    _.black = 0
                    timer.Simple(0.15, function()
                        if !IsValid(self) or !IsValid(_) then return end
                        _.black = 260
                        timer.Simple(0.15, function()
                            if !IsValid(self) or !IsValid(_) then return end
                            _.black = 0
                        end)
                    end)
                end)

                self.th = CurTime() + math.random(3, 5)
            end
        end

        timer.Simple(0.2, function()
            self:ShowTitle()
        end)
    end)
end

function PANEL:ShowTitle()
    local tSizeX = ScrW() * 0.62
    local tSizeY = ScrH() * 0.28

    local timeAnim = RealTime() + 0.4

    self.Line1, self.Line2, self.Line3, self.Line4, self.Text, self.Block1, self.Block2 = 0, 0, 0, 0, -40, 0, 0
    self.mLine1, self.mLine2, self.mLine3, self.mLine4, self.mText, self.mBlock1, self.mBlock2 =
        tSizeX / 2 + ScrW() / 2,
        ScrH() / 2 - tSizeY / 2 + tSizeY,
        0, 0, 0, 0, 0

    local alpha = 0
    local textAlpha = 0

    self.TitlePanel = self.matScreen:Add("Panel")
    self.TitlePanel:SetPos(0, 0)
    self.TitlePanel:SetSize(ScrW(), ScrH())
    self.TitlePanel.Paint = function(_, w, h)
        for i = 1, 4 do
            local data = "Line" .. i
            self[data] = Lerp(FrameTime() * 3, self[data], self["m" .. data])
        end

        self.Text = Lerp(FrameTime(), self.Text, self.mText)
        self.Block1 = Lerp(FrameTime() * 4, self.Block1, self.mBlock1)
        self.Block2 = Lerp(FrameTime(), self.Block2, self.mBlock2)

        alpha = Lerp(FrameTime() * 1.8, math.Clamp((RealTime() - timeAnim) * 125, 0, 255), 255)
        surface.SetDrawColor(0, 0, 0, alpha)
        surface.DrawRect(ScrW() / 2 - tSizeX / 2, ScrH() / 2 - tSizeY / 2 - self.Block1 * 1.5, tSizeX, tSizeY + self.Block1 * 0.5)

        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawRect(self.Line3, ScrH() / 2 - tSizeY / 2, self.Line1, 2)
        surface.DrawRect(ScrW() - self.Line1 - self.Line3, ScrH() / 2 + tSizeY / 2 - 2, self.Line1, 2)
        surface.DrawRect(ScrW() / 2 + tSizeX / 2 - 2, self.Line4, 2, self.Line2)
        surface.DrawRect(ScrW() / 2 - tSizeX / 2, ScrH() - self.Line2 - self.Line4, 2, self.Line2)

        draw.DrawText(self.data[3], "arb.SplashScreenBlurFont", ScrW() / 2, ScrH() / 2 - ScrH() * 0.045 - self.Block1 * 0.65, Color(233, 74, 74, alpha * 0.6), TEXT_ALIGN_CENTER)
        draw.DrawText(self.data[3], "arb.SplashScreenFont", ScrW() / 2, ScrH() / 2 - ScrH() * 0.045 - self.Block1 * 0.65, Color(233, 74, 74, alpha), TEXT_ALIGN_CENTER)

        textAlpha = Lerp(FrameTime() * 2, textAlpha, 255)
        draw.DrawText("C\nh\na\np\nt\ne\nr\n" .. self.data[4], "arb.Font_FuturaPTBook_20", 40 + ScrW() / 2 + tSizeX / 2, self.Text + ScrH() / 2 - tSizeY / 2 - self.Block1, Color(0, 0, 0, textAlpha), TEXT_ALIGN_CENTER)
    end

    timer.Simple(5, function()
        self.mLine3 = ScrW() + 10
        self.mLine4 = ScrH() + 10

        timer.Simple(1.5, function()
            self.mBlock1 = ScrH() * 0.25
            self.mBlock2 = ScrH() * 0.618

            self:ShowSurvival()
        end)

        timer.Simple(5, function()
            self:ShowSurvivalText()
        end)
    end)
end

function PANEL:ShowSurvival()
    local size = ScrH() * 0.11

    local surv = self.data[1]
    local dead = self.data[2]

    self.survival = self:Add("Panel")
    self.survival:SetPos(0, ScrH() * 0.5)
    self.survival:SetSize(ScrW(), ScrH() - ScrH() * 0.5)
    self.survival.List = {}
    self.survival.Paint = function(_, w, h)
        local num = 0

        for k, v in pairs(_.List) do
            v.alpha = Lerp(FrameTime() * 3, v.alpha, v.malpha)

            for k2, v2 in pairs({"r", "g", "b"}) do
                v.color[v2] = Lerp(FrameTime() * 3, v.color[v2], v.mcolor[v2])
            end

            local shift = (size * num) - (30 * num)

            surface.SetDrawColor(ColorAlpha(v.color, v.alpha))
            surface.SetMaterial(v.material)
            surface.DrawTexturedRect(ScrW() / 2 + shift - ((table.Count(surv) * size) / 2), ScrH() - self.Block2 - size * 1.7 + 10, size, size * 1.7)
            num = num + 1
        end

        surface.SetDrawColor(0, 0, 0)
        surface.DrawRect(0, ScrH() - self.Block2, ScrW(), self.Block2)
    end

    local num = 1
    for k, v in pairs(surv) do
        local steamid = v[1]
        local faction = v[2]

        local factionData = Character.team:GetByID(faction)
        if !factionData then continue end

        local mat = Material(factionData:GetAssets().white or "error.png")

        self.survival.List[steamid] = {
            material = mat,
            color = Color(0, 0, 0),
            mcolor = Color(0, 0, 0),
            alpha = 255,
            malpha = 255
        }

        num = num + 1
    end

    timer.Simple(4.5, function()
        for k, v in pairs(dead) do
            local data = self.survival.List[v]
            if !data then continue end

            timer.Simple(k * 1, function()
                if self.survival.List[v] then
                    self.survival.List[v].mcolor = color_white

                    timer.Simple(0.5, function()
                        self.survival.List[v].mcolor = Color(233, 74, 74)
                    end)
                end

                self:TakeSurv()
            end)
        end

        timer.Simple(table.Count(dead) + 1, function()
            if IsValid(self.matScreen) then -- attempt to index field 'matScreen' (a nil value)
                self.matScreen.malpha2 = 260
            end

            timer.Simple(1, function()
                for k, v in pairs(self.survival.List) do
                    if !self.survival.List[k] then continue end

                    self.survival.List[k].mcolor = color_white
                end

                for k, v in pairs(self.data[2]) do
                    if !self.survival.List[v] then continue end

                    self.survival.List[v].mcolor = Color(233, 74, 74)
                end

                self.TextPanel.mmove = 255 * 2
                self.TextPanel.malpha = 0

                timer.Simple(0.2, function()
                    self.TextPanel.malpha2 = 255
                    self.TextPanel.mmove2 = 255

                    self:BlackScreen()
                end)
            end)
        end)
    end)
end

function PANEL:BlackScreen()
    timer.Simple(1, function()
        local panel = self:Add("Panel")
        panel:SetPos(0, 0)
        panel:SetSize(ScrW(), ScrH())
        panel:SetAlpha(0)
        panel:AlphaTo(255, 4, 0, function()
            timer.Simple(1, function()
                self.TextPanel:Remove()
                self.survival:Remove()
                self.matScreen:Remove()
                self.TitlePanel:Remove()

                self:AlphaTo(0, 2, 0, function()
                    self:Remove()
                end)
            end)
        end)
        panel.Paint = function(_, w, h)
            surface.SetDrawColor(0, 0, 0, 255)
            surface.DrawRect(0, 0, w, h)
        end
    end)
end

function PANEL:ShowSurvivalText()
    local size = ScrH() * 0.11

    self.allSurv_color = Color(233, 74, 74)
    self.allSurv_mcolor = self.allSurv_color
    self.allSurv = table.Count(self.data[1])

    self.TextPanel = self:Add("Panel")
    self.TextPanel:SetPos(0, ScrH() - size)
    self.TextPanel:SetSize(ScrW(), size)
    self.TextPanel:SetAlpha(0)
    self.TextPanel:AlphaTo(255, 0.7)

    self.TextPanel.alpha = 0
    self.TextPanel.malpha = 255
    self.TextPanel.move = 0
    self.TextPanel.mmove = 255

    self.TextPanel.alpha2 = 0
    self.TextPanel.malpha2 = 0
    self.TextPanel.move2 = 0
    self.TextPanel.mmove2 = 0

    self.TextPanel.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _.malpha)
        _.move = Lerp(FrameTime() * 2, _.move, _.mmove)

        _.alpha2 = Lerp(FrameTime() * 10, _.alpha2, _.malpha2)
        _.move2 = Lerp(FrameTime() * 2, _.move2, _.mmove2)

        for k, v in pairs({"r", "g", "b"}) do
            self.allSurv_color[v] = Lerp(FrameTime() * 7, self.allSurv_color[v], self.allSurv_mcolor[v])
        end

        draw.DrawText("Выжившие претенденты:", "arb.Font_FuturaPTBook_20", ScrW() * 0.13 + _.move * 0.1, 10, Color(255, 255, 255, _.alpha), TEXT_ALIGN_LEFT)

        draw.DrawText(self.allSurv, "arb.SplashScreenBlurFont2", ScrW() * 0.4 + _.move * 0.1, 10, ColorAlpha(self.allSurv_color, _.alpha), TEXT_ALIGN_LEFT)
        draw.DrawText(self.allSurv, "arb.SplashScreenFont2", ScrW() * 0.4 + _.move * 0.1, 10, ColorAlpha(self.allSurv_color, _.alpha), TEXT_ALIGN_LEFT)

        draw.DrawText(self.data[5], "arb.SplashScreenBlurFont2", ScrW() - _.move2, 10, ColorAlpha(self.allSurv_color, _.alpha2), TEXT_ALIGN_RIGHT)
        draw.DrawText(self.data[5], "arb.SplashScreenFont2", ScrW() -_.move2, 10, ColorAlpha(self.allSurv_color, _.alpha2), TEXT_ALIGN_RIGHT)
    end
end

function PANEL:TakeSurv()
    self.allSurv = self.allSurv - 1
    self.allSurv_color = color(255, 255, 255)
end

function PANEL:SetData(data)
    self.data = data
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0)
    surface.DrawRect(0, 0, w, h)
end

vgui.Register("arb.SplashScreen", PANEL, "EditablePanel")


concommand.Add("arb_close_splashscreen", function(client, command, arguments)
    if IsValid(Arbitrage.gui.splashscreen) then
        Arbitrage.gui.splashscreen:Remove()
    end
end)