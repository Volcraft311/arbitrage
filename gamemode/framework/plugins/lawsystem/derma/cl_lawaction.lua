--[[
        © Asterion Project 2021.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local PLUGIN = PLUGIN

local categoryData = {
    {
        name = "Эмоции",
        icon = "icon16/emoticon_grin.png",
        data = function(client, panel)
            local faction = client:Team()
            local factionData = Arbitrage.teams.Get(faction)
            if !factionData then return end

            local emotes = factionData.emodjiListMin
            if !emotes then return end

            local List = panel:Add("DIconLayout")
            List:Dock(FILL)
            List:SetSpaceY(5)
            List:SetSpaceX(5)

            client.selectedEmoji = client.selectedEmoji or 1

            for k, v in pairs(emotes) do
                local mat = Arbitrage.GetMaterial(v)

                local ListItem = List:Add("DButton")
                ListItem:SetText("")
                ListItem:SetSize(Arbitrage.ResolutionW(100), Arbitrage.ResolutionH(140))
                ListItem.alpha = 0
                ListItem.Paint = function(_, w, h)
                    local isSelect = client.selectedEmoji == k and true or false

                    _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() or isSelect) and 20 or 0)

                    surface.SetDrawColor(255, 61, 96, _.alpha)
                    surface.DrawRect(0, 0, w, h)

                    surface.SetDrawColor(255, 255, 255)
                    surface.SetMaterial(mat)
                    surface.DrawTexturedRect(0, 0, w, h)

                    surface.SetDrawColor(255, 61, 96, 50)
                    surface.DrawOutlinedRect(0, 0, w, h, 1)
                end

                ListItem.DoClick = function()
                    client.selectedEmoji = k
                    netstream.Start("arb.ChangeEmoji", k)
                end
            end
        end
    },
    {
        name = "Улики",
        icon = "icon16/image.png",
        data = function(client, panel)
            for k, v in pairs(LocalPlayer():GetEvidences()) do
                local data = Evidence:GetEvidence(k)
                if !data then continue end

                local d = Evidence.icons
                local mat = Arbitrage.GetMaterial(d[data.image] and d[data.image] or d[1])

                local description = data.name
                if utf8.len(description) > 30 then
                    description = description:utf8sub(1, 27) .. "..."
                end

                local button = panel:Add("DButton")
                button:SetText("")
                button:SetTall(Arbitrage.ResolutionH(50))
                button:Dock(TOP)
                button:DockMargin(0, 0, 0, 5)
                button.alpha = 0
                button.Paint = function(_, w, h)
                    _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 20 or 0)

                    surface.SetDrawColor(27, 10, 13, 150)
                    surface.DrawRect(0, 0, w, h)

                    surface.SetDrawColor(255, 61, 96, _.alpha)
                    surface.DrawRect(0, 0, w, h)

                    surface.SetDrawColor(255, 255, 255)
                    surface.SetMaterial(mat)
                    surface.DrawTexturedRect(3, 3, h - 6, h - 6)

                    surface.SetDrawColor(255, 61, 96, 50)
                    surface.DrawOutlinedRect(0, 0, w, h, 1)

                    draw.DrawText(description, "arb.Font_FuturaPTBook_8", h + 5, Arbitrage.ResolutionH(2), Color(255, 255, 255), TEXT_ALIGN_LEFT)
                    draw.DrawText("Предъявил: " .. (Arbitrage.gui.lawaction.evidences[k] and Arbitrage.gui.lawaction.evidences[k] or "Никто"), "arb.Font_FuturaPTBook_6", h + 5, Arbitrage.ResolutionH(22), Color(225, 225, 225, 150), TEXT_ALIGN_LEFT)
                end
                button.DoClick = function()
                    local x = 0
                    local y = ScrH() * 0.25
                    local wide = Arbitrage.ResolutionW(620)

                    local evidence = vgui.Create("arb.EvidenceMenuSub")
                    evidence:SetEvidence(data)
                    evidence:SetPos(x + wide * 1.05, y)
                end

                local present = button:Add("DButton")
                present:SetText("")
                present:Dock(RIGHT)
                present:DockMargin(0, Arbitrage.ResolutionH(10), Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(10))
                present:SetWide(Arbitrage.ResolutionH(30))
                present.DoClick = function()
                    netstream.Start("arb.ShowEvidence", k)
                end
            end
        end
    }
}

local PANEL = {}

function PANEL:Init()
    self:SetTitle("")
    self:ShowCloseButton(false)
    self:SetPos(5, 5)
    self:SetSize(Arbitrage.ResolutionW(350), Arbitrage.ResolutionH(500))
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self:MakePopup()
    self.select = 0

    self.focusSizeMax = 0
    self.focusSize = RealTime()
    self.interruptionSizeMax = 0
    self.interruptionSize = RealTime()

    Arbitrage.gui.lawaction = self

    self:SetKeyboardInputEnabled(false)

    self.topPanel = self:Add("Panel")
    self.topPanel:SetTall(Arbitrage.ResolutionH(27))
    self.topPanel:Dock(TOP)
    self.topPanel:DockMargin(0, 5, 0, 0)

    self.mainPanel = self:Add("Panel")
    self.mainPanel:Dock(FILL)
    self.mainPanel:DockMargin(Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(2), Arbitrage.ResolutionW(5), Arbitrage.ResolutionH(5))
    self.mainPanel.Paint = function(_, w, h)
        surface.SetDrawColor(27, 10, 13, 150)
        surface.DrawRect(0, 0, w, h)
    end

    local interruptionButton = self:Add("DButton")
    interruptionButton:SetText("")
    interruptionButton:SetTall(H(25))
    interruptionButton:Dock(BOTTOM)
    interruptionButton:DockMargin(0, 2, 0, 0)
    interruptionButton.alpha = 0.1
    interruptionButton.Paint = function(panel, w, h)
        panel.alpha = Lerp(FrameTime() * 10, panel.alpha, (panel:IsHovered() and panel:IsEnabled()) and 1 or 0.1)

        surface.SetDrawColor(15, 5, 6, 204)
        surface.DrawRect(0, 0, w, h)

        local t = (self.interruptionSize or 0) - RealTime()
        surface.SetDrawColor(99, 17, 32, 255 / 2)
        surface.DrawRect(0, 0, t * (w / self.interruptionSizeMax), h)

        surface.SetDrawColor(155, 35, 57, 255 * panel.alpha)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        draw.DrawText("Перебить", "arb.Font_FuturaPTBook_7", w / 2, H(1), Color(255, 234, 238, 255 * panel.alpha), TEXT_ALIGN_CENTER)
    end
    interruptionButton.DoClick = function()
        netstream.Start("arb.LawInterruption")
    end

    local focusButton = self:Add("DButton")
    focusButton:SetText("")
    focusButton:SetTall(H(25))
    focusButton:Dock(BOTTOM)
    focusButton.alpha = 0.1
    focusButton.Paint = function(panel, w, h)
        panel.alpha = Lerp(FrameTime() * 10, panel.alpha, (panel:IsHovered() and panel:IsEnabled()) and 1 or 0.1)

        surface.SetDrawColor(15, 5, 6, 204)
        surface.DrawRect(0, 0, w, h)

        local t = (self.focusSize or 0) - RealTime()
        surface.SetDrawColor(99, 17, 32, 255 / 2)
        surface.DrawRect(0, 0, t * (w / self.focusSizeMax), h)

        surface.SetDrawColor(155, 35, 57, 255 * panel.alpha)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        draw.DrawText("Сфокусировать камеру на себя", "arb.Font_FuturaPTBook_7", w / 2, H(1), Color(255, 234, 238, 255 * panel.alpha), TEXT_ALIGN_CENTER)
    end
    focusButton.DoClick = function()
        netstream.Start("arb.LawFocus")
    end

    self.topPanel.PerformLayout = function(_, w, h)
        self.topPanel.PerformLayout = nil

        self:InitCategory()
    end

    self.evidences = {}
end

function PANEL:InitCategory()
    self.panels = {}

    for k, v in pairs(categoryData) do
        local s = self.topPanel:GetTall()

        local parsed = Arbitrage.markup.Parse("<font=arb.Font_FuturaPTBook_6><colour=255,255,255><img=materials/" .. v.icon .. ", " .. s / 2 .. "x" .. s / 2 .. ", 255, 255, 255> " .. v.name .. "</colour></font>")

        local category = self.topPanel:Add("DButton")
        category:SetText("")
        category:Dock(LEFT)
        category:SetWide(self.topPanel:GetWide() / #categoryData)
        category.alpha = 0
        category.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 20 or 0)

            surface.SetDrawColor(255, 61, 96, _.alpha)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(255, 255, 255, 100)
            surface.DrawRect(w * 0.1, h - 6, w - w * 0.2, 2)

            if self.select == k then
                surface.SetDrawColor(255, 61, 96, 50)
                surface.DrawOutlinedRect(0, 0, w, h, 1)
            end

            parsed:draw(w / 2, h / 2 - Arbitrage.ResolutionH(10), TEXT_ALIGN_CENTER)
        end

        category.DoClick = function()
            self.select = k

            if IsValid(self.inPanel) then self.inPanel:Remove() end

            self.inPanel = self.mainPanel:Add("DScrollPanel")
            self.inPanel:Dock(FILL)
            self.inPanel:SetAlpha(0)
            self.inPanel:AlphaTo(255, 0.3)

            local bar = self.inPanel:GetVBar()
            bar.Paint = function(_, w, h)
                surface.SetDrawColor(0, 0, 0, 100)
                surface.DrawRect(w * 0.2, bar.btnUp:GetTall(), w - w * 0.4, h - bar.btnUp:GetTall() * 2)
            end

            bar.btnUp.Paint = function() end
            bar.btnDown.Paint = function() end

            bar.btnGrip.Paint = function(_, w, h)
                surface.SetDrawColor(255, 255, 255, 100)
                surface.DrawRect(w * 0.2, 0, w - w * 0.4, h)
            end

            v.data(LocalPlayer(), self.inPanel)
        end

        self.panels[k] = category
    end
end

-- function PANEL:Think()
--     gui.EnableScreenClicker(true)
-- end


function PANEL:Paint(w, h)
    surface.SetDrawColor(41, 22, 25)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(255, 61, 96, 165.75)
    surface.DrawOutlinedRect(0, 0, w, h, 2)

    draw.DrawText("Меню классного суда", "arb.Font_FuturaPTBook_9", 10, 0, Color(255, 255, 255), TEXT_ALIGN_LEFT)
end

vgui.Register("arb.LawAction", PANEL, "DFrame")


concommand.Add("arb_close_lawaction", function(client, cmd, args)
    if IsValid(Arbitrage.gui.lawaction) then
        Arbitrage.gui.lawaction:Remove()
    end
end)