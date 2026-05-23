local PANEL = {}

function PANEL:Init()
    if IsValid(Arbitrage.menu) then
        Arbitrage.menu:Remove()
    end

    Arbitrage.menu = self

    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.5)
end

function PANEL:Paint(w, h)
    asterionlib.DrawBlur(self, 15, nil, self:GetAlpha())

    surface.SetDrawColor(0, 0, 0, 240)
    surface.DrawRect(0, 0, w, h)
end

vgui.Register("arb.mainmenu:Secondary", PANEL, "Panel")


local gameUIcd = RealTime()
local bKeyDown = false
hook.Add("Think", "arb.OpenMainMenu", function()
    if gui.IsGameUIVisible() then gameUIcd = RealTime() + 0.25 end
    if gameUIcd >= RealTime() then return end

    local bKeyPress = input.IsKeyDown(KEY_ESCAPE)
    if bKeyPress then
        if !bKeyDown then
            if IsValid(Arbitrage.menu) then
                if IsValid(Arbitrage.menu.content) then return end
                if IsValid(Arbitrage.menu.characters) then return end
                if IsValid(Arbitrage.menu.settings) then return end
                if IsValid(Arbitrage.menu.customization) then return end
                if IsValid(Arbitrage.menu.lang) then return end

                Arbitrage.menu:AlphaTo(0, 0.25, 0, function()
                    Arbitrage.menu:Remove()
                end)
            else
                if vgui.CursorVisible() then return end
                if Arbitrage.gui.chat:GetActive() then return end
                if RealTime() < (Arbitrage.gui.chat.closeCD or 0) then return end

                local secondary = vgui.Create("arb.mainmenu:Secondary")
                local secondaryMenu = secondary:Add("arb.mainmenu:MenuSecondary")
                secondaryMenu:Dock(FILL)
            end
        end

        bKeyDown = true
    else
        bKeyDown = false
    end
end)

hook.Add("OnPauseMenuShow", "arb.OpenMainMenu", function()
    return false
end)