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
    if IsValid(Arbitrage.gui.photos) then
        Arbitrage.gui.photos:Remove()
    end

    Arbitrage.gui.photos = self

    local sizeX, sizeY, sizeT = W(1920) * 0.7, H(1080) * 0.7, H(46)

    self:SetPos(ScrW() / 2 - sizeX / 2, ScrH() / 2 - sizeY / 2)
    self:SetSize(0, sizeT)
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.5)

    self:SizeTo(sizeX, sizeT, 0.3, 0, -1, function()
        self:SizeTo(self:GetWide(), sizeY + sizeT, 0.3)
    end)

    local titlePanel = self:Add("DPanel")
    titlePanel:SetTall(sizeT)
    titlePanel:Dock(TOP)
    titlePanel.Paint = function(_, w, h)
        local tW = draw.SimpleText("Фотография", "arb.Font_FuturaPTDemi_13", 71, H(5), Color(255, 234, 238), TEXT_ALIGN_LEFT)
        draw.SimpleText("Изображение фотографии которую вы открыли", "arb.Font_FuturaPTBook_7", tW + 71 + W(22), H(19), Color(255, 234, 238, 30), TEXT_ALIGN_LEFT)
    end

    local closeButton = titlePanel:Add("DButton")
    closeButton:SetText("")
    closeButton:SetWide(sizeT)
    closeButton:Dock(RIGHT)
    closeButton.alpha = 0.1
    closeButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 5, _.alpha, _:IsHovered() and 1 or 0.1)

        draw.SimpleText("X", "arb.Font_FuturaPTDemi_10", w / 2, H(10), Color(255, 234, 238, 255 * _.alpha), TEXT_ALIGN_CENTER)
    end
    closeButton.DoClick = function()
        self:AlphaTo(0, 0.3, 0, function()
            self:Remove()
        end)
    end

    self.image = nil

    self.ImagePanel = self:Add("DPanel")
    self.ImagePanel:Dock(FILL)
    self.ImagePanel.Paint = function(_, w, h)
        if type(self.image) == "IMaterial" and !self.image:IsError() then
            local maxW = w * 1
            local maxH = h * 1

            local _w = self.image:Width()
            local _h = self.image:Height()

            local a = _h < _w and maxW / _w or  maxH / _h

            local a2 = _w * a
            local b2 = _h * a

            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(self.image)
            surface.DrawTexturedRect(w / 2 - a2 / 2, h / 2 - b2 / 2, a2, b2)
        else
            local curtime = CurTime()
            local alpha = math.sin(curtime * 2) * 255
            local dotA = math.sin(curtime * 1) * 255
            local dot = math.floor(math.abs(dotA) * 0.015)
            local dotStr = ("."):rep(dot + 1)

            local sizeW, sizeH = w / 2, h / 2

            surface.SetDrawColor(255, alpha, 255)
            surface.DrawRect(w / 2 - sizeW / 2, h / 2 - sizeH / 2, sizeW, sizeH)
            draw.DrawText("Loading" .. dotStr, "Default", sizeW, sizeH, Color(alpha, 0, 0), TEXT_ALIGN_CENTER)
        end
    end
end

function PANEL:OpenData(imageURL)
    asterionlib.downloader:Image(imageURL, function(matPath, path)
        if !IsValid(self) then return end

        self.image = matPath
    end)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(4, 2, 2)
    surface.DrawRect(0, 0, w, h)
end

vgui.Register("Photos:Menu", PANEL, "EditablePanel")