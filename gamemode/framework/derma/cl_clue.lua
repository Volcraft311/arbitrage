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

local categoryData = {
    {
        name = "Список улик",
        func = function(panel)
            local List = panel:Add("DIconLayout")
            List:Dock(FILL)
            List:SetSpaceY(5)
            List:SetSpaceX(5)

            for k, v in pairs(LocalPlayer():GetEvidences()) do
                local data = Evidence:GetEvidence(k)
                if !data then continue end

                local d = Evidence.icons
                local mat = Material(d[data.image] and d[data.image] or d[1])

                local ListItem = List:Add("DButton")
                ListItem:SetText("")
                ListItem:SetSize(W(140), H(190))
                ListItem.alpha = 0
                ListItem.Paint = function(_, w, h)
                    _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 20 or 0)

                    surface.SetDrawColor(27, 10, 13, 150)
                    surface.DrawRect(0, 0, w, h)

                    surface.SetDrawColor(255, 61, 96, _.alpha)
                    surface.DrawRect(0, 0, w, h)

                    surface.SetDrawColor(255, 255, 255)
                    surface.SetMaterial(mat)
                    surface.DrawTexturedRect(10, 10, w - 20, w - 20)

                    surface.SetDrawColor(255, 61, 96, 50)
                    surface.DrawOutlinedRect(0, 0, w, h, 1)

                    local descHeight = draw.GetFontHeight("arb.Font_FuturaPTBook_7")
                    local descriptionText = asterionlib.WrapText(data.name, W(140), "arb.Font_FuturaPTBook_7")

                    for i, _ in pairs(descriptionText) do
                        local y2 = descHeight * i - descHeight
                        draw.DrawText(descriptionText[i], "arb.Font_FuturaPTBook_7", w / 2, w * 0.95 + y2, color_white, TEXT_ALIGN_CENTER)
                    end
                end

                ListItem.DoClick = function()
                    --v.index = k

                    local mainPanel = Arbitrage.gui.logmenu

                    local x = IsValid(mainPanel) and mainPanel:GetX() or 0
                    local y = IsValid(mainPanel) and mainPanel:GetY() or 0
                    local wide = IsValid(mainPanel) and mainPanel:GetWide() or W(620)

                    local evidence = vgui.Create("arb.EvidenceMenuSub")
                    evidence:SetEvidence(data)
                    evidence:SetPos(x + wide * 1.05, y)
                end
            end

            panel:AddItem(List)
        end,
    },
    {
        name = "Свидетельства о смерти",
        func = function(panel)
            local List = panel:Add("Panel")
            List:Dock(FILL)
            List.Paint = function(_, w, h)
                draw.DrawText("В разработке...", "arb.Font_FuturaPTBook_15", w / 2, 30, color_white, TEXT_ALIGN_CENTER)
            end
        end,
    },
    {
        name = "Список заметок",
        func = function(panel)
            local List = panel:Add("Panel")
            List:Dock(FILL)
            List.Paint = function(_, w, h)
                draw.DrawText("В разработке...", "arb.Font_FuturaPTBook_15", w / 2, 30, color_white, TEXT_ALIGN_CENTER)
            end
        end,
    }
}

function PANEL:Init()
    self:SetTitle("")
    self:SetSize(W(620), H(700))
    self:Center()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self:MakePopup()
    self:ShowCloseButton(false)

    self:SetKeyboardInputEnabled(false)

    Arbitrage.gui.logmenu = self

    self.select = -1

    local close = self:Add("DButton")
    close:SetText("")
    close:SetPos(self:GetWide() - H(40))
    close:SetSize(H(32), H(32))
    close.alpha = 50
    close.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 50)

        draw.DrawText("x", "arb.Font_FuturaPTBook_11", w / 2, -5, Color(255, 255, 255, _.alpha), TEXT_ALIGN_CENTER)
    end
    close.DoClick = function()
        self:AlphaTo(0, 0.3, 0, function()
            self:Remove()
        end)
    end

    self.main = self:Add("Panel")
    self.main:SetPos(W(123), H(40))
    self.main:SetSize(W(490), H(650))

    local categoryPanel = self:Add("Panel")
    categoryPanel:SetPos(W(10), H(5))
    categoryPanel:SetSize(W(25), H(270))

    for k, v in pairs(categoryData) do
        local panel = categoryPanel:Add("DButton")
        panel:SetText("")
        panel:Dock(TOP)
        panel:SetTall(H(270) / #categoryData)
        panel.alpha = 100
        panel.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() or self.select == k) and 255 or 100)
            surface.SetDrawColor(255, 61, 96, _.alpha)
            surface.DrawRect(0, 0, w, h - 5)
        end

        panel.DoClick = function()
            if self.select == k then return end

            if IsValid(self.scrollPanel) then self.scrollPanel:Remove() end
            if IsValid(self.scrollTitle) then self.scrollTitle:Remove() end

            self.select = k

            self.scrollTitle = self.main:Add("Panel")
            self.scrollTitle:Dock(TOP)
            self.scrollTitle:SetTall(H(30))
            self.scrollTitle:SetAlpha(0)
            self.scrollTitle:AlphaTo(255, 0.5)
            self.scrollTitle.Paint = function(_, w, h)
                draw.DrawText(v.name, "arb.Font_FuturaPTBook_10", w / 2, -5, Color(255, 255, 255, _.alpha), TEXT_ALIGN_CENTER)
            end

            self.scrollPanel = self.main:Add("DPanelList")
            self.scrollPanel:Dock(FILL)
            self.scrollPanel:DockMargin(0, 5, 0, 0)
            self.scrollPanel:SetAlpha(0)
            self.scrollPanel:AlphaTo(255, 0.5)
            self.scrollPanel:EnableVerticalScrollbar()

            local bar = self.scrollPanel:GetChildren()[2]
            bar.Paint = function(_, w, h)
                surface.SetDrawColor(0, 0, 0, 100)
                surface.DrawRect(w * 0.2, bar.btnUp:GetTall(), w - w * 0.4, h - bar.btnUp:GetTall() * 2)
            end

            bar.btnUp.Paint = zero
            bar.btnDown.Paint = zero

            bar.btnGrip.Paint = function(_, w, h)
                surface.SetDrawColor(255, 255, 255, 100)
                surface.DrawRect(w * 0.2, 0, w - w * 0.4, h)
            end

            v.func(self.scrollPanel)
        end

        if k == 1 then
            panel.DoClick()
        end
    end
end

local mat = Material("danganronpa/ui/evidence.png")
function PANEL:Paint(w, h)
    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(mat)
    surface.DrawTexturedRect(0, 0, w, h)

    surface.SetDrawColor(255, 255, 255, 76)
    surface.DrawRect(W(150), H(32) - 2, w - W(200), 2)
end

vgui.Register("arb.EvidenceMenu", PANEL, "DFrame")


local PANEL = {}

function PANEL:Init()
    self:SetTitle("")
    self:SetSize(W(400), H(600))
    self:Center()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self:MakePopup()
    self:ShowCloseButton(false)

    self:SetKeyboardInputEnabled(false)

    local close = self:Add("DButton")
    close:SetText("")
    close:SetPos(self:GetWide() - H(40))
    close:SetSize(H(32), H(32))
    close.alpha = 50
    close.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 50)

        draw.DrawText("x", "arb.Font_FuturaPTBook_11", w / 2, -5, Color(255, 255, 255, _.alpha), TEXT_ALIGN_CENTER)
    end
    close.DoClick = function()
        self:AlphaTo(0, 0.3, 0, function()
            self:Remove()
        end)
    end

    self.textPanel = self:Add("DTextEntry")
    self.textPanel:SetFont("arb.Font_FuturaPTBook_8")
    self.textPanel:SetMultiline(true)
    self.textPanel:SetTextColor(color_white)
    self.textPanel:SetVerticalScrollbarEnabled(true)
    self.textPanel:SetDisabled(truewa)
    self.textPanel:Dock(FILL)
    self.textPanel:SetDrawBackground(false)
    self.textPanel:DockMargin(5, H(50), 5, 5)

end

function PANEL:SetEvidence(data)
    self.data = data

    self.textPanel:SetValue(self.data.description)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, 200)
    surface.DrawRect(6, 0, w - 12, h)

    surface.SetDrawColor(255, 255, 255, 76)
    surface.DrawRect(W(50), H(32) - 2, w - W(50) * 2, 2)
    surface.DrawRect(0, 0, 2, h)
    surface.DrawRect(w - 2, 0, 2, h)

    draw.DrawText(self.data.name or "", "arb.Font_FuturaPTBook_9", w / 2, H(40), color_white, TEXT_ALIGN_CENTER)
end

vgui.Register("arb.EvidenceMenuSub", PANEL, "DFrame")