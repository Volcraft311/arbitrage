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


local PLUGIN = PLUGIN

local PANEL = {}

function PANEL:Init()
    self:SetTitle("")
    self:SetPos(0, 0)
    self:SetSize(Arbitrage.ResolutionW(960 * 1.3), Arbitrage.ResolutionH(540 * 1.3))
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self:Center()
    self:ShowCloseButton(false)

    local close = self:Add("DButton")
    close:SetPos(self:GetWide() - Arbitrage.ResolutionH(70), 0)
    close:SetSize(Arbitrage.ResolutionH(70), Arbitrage.ResolutionH(30))
    close:SetText("")
    close.alpha = 40
    close.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 40)
        draw.DrawText("X", "arb.Font_FuturaPTBook_7", w / 2, Arbitrage.ResolutionH(4), Color(255, 255, 255, _.alpha), TEXT_ALIGN_LEFT)
    end
    close.DoClick = function()
        self:AlphaTo(0, 0.2, 0, function()
            self:Remove()
        end)
    end

    self:InitColorModify()
end

function PANEL:InitColorModify()
    self.mainPanel = self:Add("Panel")
    self.mainPanel:SetWide(Arbitrage.ResolutionW(250))
    self.mainPanel:Dock(FILL)
    self.mainPanel:DockMargin(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(45), Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(5))
    self.mainPanel.Paint = function(_, w, h)
        surface.SetDrawColor(27, 10, 13, 150)
        surface.DrawRect(0, 0, w, h)
    end

    local data = PLUGIN:Get()

    for k, v in pairs(data) do
        local info = PLUGIN:GetInfo(k)
        if !info then continue end

        local panel = self.mainPanel:Add("Panel")
        panel:SetTall(H(30))
        panel:Dock(TOP)
        panel:DockMargin(0, H(3), 0, 0)

        local slider = panel:Add("DNumSlider")
        slider:Dock(FILL)
        slider:SetText(info.name)
        slider:SetMin(info.minimum)
        slider:SetMax(info.maximum)
        slider:SetDecimals(info.decimals)
        slider:SetValue(v)
        slider.OnValueChanged = function(_, value)
            if value != data[k] then
                local timerName = "ColorModifySet: " .. k
                timer.Create(timerName, FrameTime(), 0, function()
                    if !input.IsMouseDown(MOUSE_LEFT) then
                        timer.Remove(timerName)

                        value = math.Round(value, info.decimals)
                        netstream.Start("ColorModify:Set", k, value)
                    end
                end)
            end
        end

        local label = slider:GetChildren()[3]
        label:SetFont("arb.Font_FuturaPTBook_8")
        label:SetTextColor(Color(255, 255, 255))
        label:DockMargin(W(25), 0, 0, 0)
    end

    local returnButton = self:Add("DButton")
    returnButton:SetText("")
    returnButton:SetTall(Arbitrage.ResolutionH(25))
    returnButton:Dock(BOTTOM)
    returnButton.alpha = 0
    returnButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText("Вернуть стандартную цветокоррекцию", "arb.Font_FuturaPTBook_8", w / 2, Arbitrage.ResolutionH(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    returnButton.DoClick = function()
        netstream.Start("ColorModify:Standart")

        timer.Simple(0.5, function()
            self:Remove()
            vgui.Create("ColorModify:Menu")
        end)
    end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(41, 22, 25)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(255, 61, 96, 165.75)
    surface.DrawOutlinedRect(0, 0, w, h, 2)

    surface.SetDrawColor(255, 61, 96, 165.75)
    surface.DrawOutlinedRect(0, 0, w, Arbitrage.ResolutionH(30), 2)

    surface.SetDrawColor(255, 61, 96, 20)
    surface.DrawRect(0, 0, w, Arbitrage.ResolutionH(30))

    draw.DrawText("Цветокоррекция", "arb.Font_FuturaPTDemi_8", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(3), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)

    draw.DrawText("Название", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(30), Arbitrage.ResolutionH(45), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    draw.DrawText("Значение", "arb.Font_FuturaPTBook_7", Arbitrage.ResolutionW(550), Arbitrage.ResolutionH(45), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
    -- draw.DrawText("SteamID64", "arb.Font_FuturaPTBook_7", w - Arbitrage.ResolutionW(115), Arbitrage.ResolutionH(45), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
end

vgui.Register("ColorModify:Menu", PANEL, "DFrame")