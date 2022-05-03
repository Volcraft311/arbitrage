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
    self:SetSize(Arbitrage.ResolutionW(960 / 2), Arbitrage.ResolutionH(540))
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self:ShowCloseButton(false)

    local close = self:Add("DButton")
    close:SetPos(self:GetWide() - Arbitrage.ResolutionH(70 / 2), 0)
    close:SetSize(Arbitrage.ResolutionH(70 / 2), Arbitrage.ResolutionH(23))
    close:SetText("")
    close.alpha = 40
    close.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 40)
        draw.DrawText("X", "arb.Font_FuturaPTBook_5", w / 2, Arbitrage.ResolutionH(4), Color(255, 255, 255, _.alpha), TEXT_ALIGN_LEFT)
    end
    close.DoClick = function()
        self:AlphaTo(0, 0.2, 0, function()
            self:Remove()
        end)
    end

    self.categoryPanel = self:Add("DPanelList")
    self.categoryPanel:EnableVerticalScrollbar()
    self.categoryPanel:SetPadding(Arbitrage.ResolutionH(5))
    self.categoryPanel:Dock(FILL)
    self.categoryPanel:DockMargin(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(2), Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(5))
end

function PANEL:SetPlayer(data)
    self:InitCategory(data)
end

function PANEL:InitCategory(client)
    local count = -1

    for k, v in ipairs(PLUGIN.ActionData) do
        count = count + 1

        timer.Simple(count * 0.07, function()
            if !IsValid(self) then return end

            local category = self.categoryPanel:Add("Panel")
            category:SetTall(0)
            category:Dock(TOP)
            category:DockMargin(0, Arbitrage.ResolutionH(5), 0, 0)
            category.Paint = function(_, w, h)
                surface.SetDrawColor(255, 255, 255, 100)
                surface.DrawRect(0, h - 2, w, 2)
            end

            for k2, v2 in pairs(v) do
                local allow = true
                if v2.onCreate then
                    local bState = v2.onCreate(client)

                    if !bState then
                        allow = false
                    end
                end

                local h = Arbitrage.ResolutionH(30)
                local text = isfunction(v2.data) and v2.data(client) or tostring(v2.data)

                local alpha = v2.onRun and 255 or 150
                local parsed = Arbitrage.markup.Parse("<font=arb.Font_FuturaPTBook_7><colour=" .. alpha .. ", " .. alpha .. ", " .. alpha .. "><img=materials/" .. v2.icon .. ", " .. h / 2 .. "x" .. h / 2 .. ", 255, 255, 255>  - " .. text .. "</colour></font>")

                local button = category:Add((v2.onRun and allow) and "DButton" or "DPanel")
                if v2.onRun then
                    button:SetText("")
                end

                button:SetTall(h)
                button:Dock(TOP)
                button.alpha = 0
                button.Paint = function(_, w, h)
                    _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() and v2.onRun and allow) and 200 or 0)

                    surface.SetDrawColor(27, 10, 13, _.alpha)
                    surface.DrawRect(0, 0, w, h)

                    parsed:draw(Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(4), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)

                    if !allow then
                        surface.SetDrawColor(255, 0, 0, 20)
                        surface.DrawRect(0, 0, w, h)
                    end
                end
                button.DoClick = function()
                    if v2.onRun and allow then
                        LocalPlayer():EmitSound(PLUGIN.ClickSound)
                        v2.onRun(client)

                        netstream.Start("arb.MonoRunCommand", client, k, k2)
                    end
                end

                category:SetTall(category:GetTall() + button:GetTall() + 2)
            end

            self.categoryPanel:AddItem(category)
        end)
    end
end

function PANEL:PerformLayout(w, h)
    self:SetX(self:GetX() - (w / 2) / 2)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(41, 22, 25)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(255, 61, 96, 165.75)
    surface.DrawOutlinedRect(0, 0, w, h, 2)

    surface.SetDrawColor(255, 61, 96, 165.75)
    surface.DrawOutlinedRect(0, 0, w, Arbitrage.ResolutionH(23), 2)

    surface.SetDrawColor(255, 61, 96, 20)
    surface.DrawRect(0, 0, w, Arbitrage.ResolutionH(23))

    draw.DrawText("Выберите нужное вам действие", "arb.Font_FuturaPTBook_5", Arbitrage.ResolutionW(10), Arbitrage.ResolutionH(3), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT)
end

vgui.Register("arb.MonoMenuList", PANEL, "DFrame")