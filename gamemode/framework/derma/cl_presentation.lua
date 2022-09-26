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

function PANEL:Init()
    self:SetZPos(20001)
    self.t = {W(1000), H(200)}
    self.alpha = 0

    timer.Simple(1, function()
        self.Think = nil
    end)

    timer.Simple(1.6, function()
        self.Think = nil

        self:SizeTo(self:GetWide(), self:GetTall() + H(50), 0.5, 0, -1, function()
            self.Think = function()
                self.alpha = Lerp(FrameTime(), self.alpha, 255)
            end
        end)

        local icon = self:Add("Panel")
        icon:SetAlpha(0)
        icon:AlphaTo(255, 1, 0)
        icon.Paint = function(_, w, h)
            surface.SetDrawColor(27, 10, 13, 150)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(255, 61, 96, 20)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(self.mat)
            surface.DrawTexturedRect(10, 10, w - 20, w - 20)

            surface.SetDrawColor(255, 61, 96, 50)
            surface.DrawOutlinedRect(0, 0, w, h, 1)
        end

        local tall = self:GetTall()
        icon.Think = function()
            local t = tall * 0.8

            icon:SetPos(self:GetWide() / 2 - t / 2, tall / 2 - t / 2)
            icon:SetSize(t, t)
        end

        timer.Simple(3.5, function()
            self.t = {0, 0}

            self.Think = function()
                self.alpha = Lerp(FrameTime() * 20, self.alpha, 0)

                local wide = Lerp(FrameTime() * 1, self:GetWide(), self.t[1])
                local tall = Lerp(FrameTime() * 1, self:GetTall(), self.t[2])

                self:SetPos(ScrW() / 2 - wide / 2, ScrH() / 2 - tall / 2)
                self:SetSize(wide, tall)
            end

            self:AlphaTo(0, 0.5, 0, function()
                self:Remove()
            end)
        end)
    end)
end

function PANEL:Think()
    local wide = Lerp(FrameTime() * 7, self:GetWide(), self.t[1])
    local tall = Lerp(FrameTime() * 7, self:GetTall(), self.t[2])

    self:SetPos(ScrW() / 2 - wide / 2, ScrH() / 2 - tall / 2)
    self:SetSize(wide, tall)
end

function PANEL:AddMaterial(data, name)
    self.mat = data
    self.name = name or ""
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(0, 6, w, h - 12)

    surface.SetDrawColor(255, 255, 255, 76)
    surface.DrawRect(0, 0, w, 2)
    surface.DrawRect(0, h - 2, w, 2)

    draw.SimpleText("Предъявил: " .. self.name, "arb.Font_FuturaPTBook_10", w / 2, h - H(50), Color(255, 255, 255, self.alpha), TEXT_ALIGN_CENTER)
end

vgui.Register("arb.Prestation", PANEL, "EditablePanel")