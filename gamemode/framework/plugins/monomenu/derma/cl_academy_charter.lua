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
    self:SetTitle("")
    self:SetPos(0, 0)
    self:SetSize(W(960 * 1.3), H(540 * 1.3))
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self:Center()
    self:ShowCloseButton(false)

    local close = self:Add("DButton")
    close:SetPos(self:GetWide() - H(70), 0)
    close:SetSize(H(70), H(30))
    close:SetText("")
    close.alpha = 40
    close.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 40)
        draw.DrawText("X", "arb.Font_FuturaPTBook_7", w / 2, H(4), Color(255, 255, 255, _.alpha), TEXT_ALIGN_LEFT)
    end
    close.DoClick = function()
        self:AlphaTo(0, 0.2, 0, function()
            self:Remove()
        end)
    end

    self:SetData()
end

local deleteMat = Material("danganronpa/ui/delete.png")
local editMat = Material("danganronpa/ui/settings.png")
function PANEL:SetData()
    if IsValid(self.mainPanel) then self.mainPanel:Remove() end
    if IsValid(self.addButton) then self.addButton:Remove() end
    if IsValid(self.defaultButton) then self.defaultButton:Remove() end

    self.mainPanel = self:Add("Panel")
    self.mainPanel:SetWide(W(250))
    self.mainPanel:Dock(FILL)
    self.mainPanel:DockMargin(W(5), H(45), W(5), H(5))
    self.mainPanel.Paint = function(_, w, h)
        surface.SetDrawColor(27, 10, 13, 150)
        surface.DrawRect(0, 0, w, h)
    end

    self.defaultButton = self:Add("DButton")
    self.defaultButton:DockMargin(0, H(5), 0, H(5))
    self.defaultButton:SetText("")
    self.defaultButton:SetTall(H(25))
    self.defaultButton:Dock(BOTTOM)
    self.defaultButton.alpha = 0
    self.defaultButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText(L("#monomenu_charter_revert"), "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    self.defaultButton.DoClick = function()
        netstream.Start("arb.MonoDefaultRules")

        timer.Simple(0.5, function()
            self:SetData()
        end)
    end

    self.addButton = self:Add("DButton")
    self.addButton:DockMargin(0, H(5), 0, H(5))
    self.addButton:SetText("")
    self.addButton:SetTall(H(25))
    self.addButton:Dock(BOTTOM)
    self.addButton.alpha = 0
    self.addButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText(L("#monomenu_charter_addrule"), "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end
    self.addButton.DoClick = function()
        local subMenu = vgui.Create("arb.MonoAcademyCharterSub")
        subMenu:SetData(nil, nil, nil, function()
            self:SetData()
        end)
    end

    self.rulesPanel = self.mainPanel:Add("DScrollPanel")
    self.rulesPanel:Dock(FILL)
    self.rulesPanel:DockMargin(W(5), H(5), W(5), H(5))

    for k, v in ipairs(Arbitrage.GetAcademyRules()) do
        local title = L(v[2])

        local panel = self.rulesPanel:Add("DPanel")
        panel:SetTall(H(30))
        panel:Dock(TOP)
        panel:DockMargin(0, 0, 0, 0)
        panel.Paint = function(_, w, h)
            if k % 2 == 0 then
                surface.SetDrawColor(255, 61, 96, 1)
                surface.DrawRect(0, 0, w, h)
            end

            draw.DrawText(k, "arb.Font_FuturaPTBook_7", W(15), H(4), color_white, TEXT_ALIGN_LEFT)
            draw.DrawText(title, "arb.Font_FuturaPTBook_7", W(187), H(4), color_white, TEXT_ALIGN_LEFT)
        end

        local remove = panel:Add("DButton")
        remove:SetText("")
        remove:Dock(RIGHT)
        remove:DockMargin(0, 0, W(10), 0)
        remove:SetWide(panel:GetTall())
        remove.alpha = 0
        remove.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)

            surface.SetDrawColor(255, 255, 255, _.alpha)
            surface.SetMaterial(deleteMat)
            surface.DrawTexturedRect(6, 6, w - 12, h - 12)
        end
        remove.DoClick = function()
            netstream.Start("arb.MonoRemoveRules", k)

            timer.Simple(0.5, function()
                self:SetData()
            end)
        end

        local edit = panel:Add("DButton")
        edit:SetText("")
        edit:Dock(RIGHT)
        edit:DockMargin(0, 0, W(10), 0)
        edit:SetWide(panel:GetTall())
        edit.alpha = 0
        edit.Paint = function(_, w, h)
            _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)

            surface.SetDrawColor(255, 255, 255, _.alpha)
            surface.SetMaterial(editMat)
            surface.DrawTexturedRect(6, 6, w - 12, h - 12)
        end
        edit.DoClick = function()
            local subMenu = vgui.Create("arb.MonoAcademyCharterSub")
            subMenu:SetData(L(v[2]), L(v[3]), v[1], function()
                self:SetData()
            end, k)
        end
    end
end


function PANEL:Paint(w, h)
    surface.SetDrawColor(41, 22, 25)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(255, 61, 96, 165.75)
    surface.DrawOutlinedRect(0, 0, w, h, 2)

    surface.SetDrawColor(255, 61, 96, 165.75)
    surface.DrawOutlinedRect(0, 0, w, H(30), 2)

    surface.SetDrawColor(255, 61, 96, 20)
    surface.DrawRect(0, 0, w, H(30))

    draw.DrawText(L("#monomenu_charter_editor"), "arb.Font_FuturaPTDemi_8", W(10), H(3), color_white, TEXT_ALIGN_LEFT)

    draw.DrawText(L("#monomenu_charter_number"), "arb.Font_FuturaPTBook_7", W(30), H(45), color_white, TEXT_ALIGN_LEFT)
    draw.DrawText(L("#monomenu_charter_title"), "arb.Font_FuturaPTBook_7", W(200), H(45), color_white, TEXT_ALIGN_LEFT)
end

vgui.Register("arb.MonoAcademyCharter", PANEL, "DFrame")


local PANEL = {}

function PANEL:Init()
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()
    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self.startTime = SysTime()

    local t = H(330)
    self.main = self:Add("Panel")
    self.main:SetPos(ScrW() / 2 - (W(600)) / 2, ScrH() / 2 - (t / 2))
    self.main:SetSize(W(600), 0)

    self.main.Think = function(panel)
        panel:SetTall(Lerp(FrameTime() * 10, panel:GetTall(), t))
    end

    self.main.Paint = function(panel, w, h)
        surface.SetDrawColor(41, 22, 25)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(255, 61, 96, 165.75)
        surface.DrawOutlinedRect(0, 0, w, h, 2)

        surface.SetDrawColor(255, 61, 96, 165.75)
        surface.DrawOutlinedRect(0, 0, w, H(23), 2)

        surface.SetDrawColor(255, 61, 96, 20)
        surface.DrawRect(0, 0, w, H(23))

        draw.DrawText(L("#monomenu_charter_addrule"), "arb.Font_FuturaPTBook_5", W(10), H(3), color_white, TEXT_ALIGN_LEFT)

        draw.DrawText(L("#monomenu_charter_entertitle"), "arb.Font_FuturaPTBook_7", W(10), H(28), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText(L("#monomenu_charter_titleexample"), "arb.Font_FuturaPTBook_7", W(10), H(50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText(L("#monomenu_charter_enterdesc"), "arb.Font_FuturaPTBook_7", W(10), H(80 + 28), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText(L("#monomenu_charter_descexample"), "arb.Font_FuturaPTBook_7", W(10), H(80 + 50), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)

        draw.DrawText(L("#monomenu_charter_enterurl"), "arb.Font_FuturaPTBook_7", W(10), H(80 + 28 + 80), color_white, TEXT_ALIGN_LEFT)
        draw.DrawText(L("#monomenu_charter_urlexample"), "arb.Font_FuturaPTBook_7", W(10), H(80 + 50 + 80), Color(150, 150, 150, 255), TEXT_ALIGN_LEFT)
    end

    local close = self.main:Add("DButton")
    close:SetPos(self.main:GetWide() - H(70 / 2), 0)
    close:SetSize(H(70 / 2), H(23))
    close:SetText("")
    close.alpha = 40
    close.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 40)
        draw.DrawText("X", "arb.Font_FuturaPTBook_5", w / 2, H(4), Color(255, 255, 255, _.alpha), TEXT_ALIGN_LEFT)
    end
    close.DoClick = function()
        self:AlphaTo(0, 0.2, 0, function()
            self:Remove()
        end)
    end

    self.titleEntry = self.main:Add("DTextEntry")
    self.titleEntry:SetPos(W(5), H(75))
    self.titleEntry:SetSize(self.main:GetWide() - W(10), H(25))
    self.titleEntry:SetPlaceholderText(L("#monomenu_charter_title"))
    self.titleEntry:SetFont("arb.Font_FuturaPTBook_8")

    self.descriptionEntry = self.main:Add("DTextEntry")
    self.descriptionEntry:SetPos(W(5), H(155))
    self.descriptionEntry:SetSize(self.main:GetWide() - W(10), H(25))
    self.descriptionEntry:SetPlaceholderText(L("#monomenu_charter_desc"))
    self.descriptionEntry:SetFont("arb.Font_FuturaPTBook_8")

    self.imageEntry = self.main:Add("DTextEntry")
    self.imageEntry:SetPos(W(5), H(235))
    self.imageEntry:SetSize(self.main:GetWide() - W(10), H(25))
    self.imageEntry:SetPlaceholderText(L("#monomenu_charter_url"))
    self.imageEntry:SetFont("arb.Font_FuturaPTBook_8")

    local submitButton = self.main:Add("DButton")
    submitButton:DockMargin(0, H(5), 0, H(5))
    submitButton:SetText("")
    submitButton:SetTall(H(25))
    submitButton:Dock(BOTTOM)
    submitButton.alpha = 0
    submitButton.Paint = function(_, w, h)
        _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
        draw.DrawText(self.id and L("#monomenu_charter_edit") or L("#monomenu_charter_add"), "arb.Font_FuturaPTBook_8", w / 2, H(0), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

        surface.SetDrawColor(255, 61, 96, 30)
        surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
    end

    submitButton.DoClick = function()
        local a, b, c, d = self.titleEntry:GetValue(), self.descriptionEntry:GetValue(), self.imageEntry:GetValue(), self.id

        netstream.Start(d and "arb.MonoEditRules" or "arb.MonoAddRules", a, b, c, d)

        local cb = self.callback
        timer.Simple(0.5, function()
            if cb then
                cb()
            end
        end)

        self:AlphaTo(0, 0.3, 0, function()
            self:Remove()
        end)
    end
end

function PANEL:SetData(title, description, image, callback, id)
    if title then
        self.titleEntry:SetValue(title)
    end

    if description then
        self.descriptionEntry:SetValue(description)
    end

    if image then
        self.imageEntry:SetValue(image)
    end

    self.callback = callback
    self.id = id
end

function PANEL:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.startTime)
end

vgui.Register("arb.MonoAcademyCharterSub", PANEL, "EditablePanel")