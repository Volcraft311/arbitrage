local PANEL = {}

function PANEL:Init()
    self.t = {Arbitrage.ResolutionW(1000), Arbitrage.ResolutionH(200)}

    timer.Simple(1, function()
        self.Think = nil
    end)

    timer.Simple(1.6, function()
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

        icon.Think = function()
            local t = self:GetTall() * 0.8

            icon:SetPos(self:GetWide() / 2 - t / 2, self:GetTall() / 2 - t / 2)
            icon:SetSize(t, t)
        end

        timer.Simple(3.5, function()
            self.t = {0, 0}

            self.Think = function()
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

function PANEL:AddMaterial(data)
    self.mat = data
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(0, 6, w, h - 12)

    surface.SetDrawColor(255, 255, 255, 76)
    surface.DrawRect(0, 0, w, 2)
    surface.DrawRect(0, h - 2, w, 2)
end

vgui.Register("arb.Prestation", PANEL, "EditablePanel")