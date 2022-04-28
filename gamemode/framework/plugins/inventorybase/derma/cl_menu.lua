local PANEL = {}

function PANEL:Init()
    Arbitrage.gui.inventory = self

    local client = LocalPlayer()

    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()

    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self:SetKeyboardInputEnabled(false)

    self.item = nil
    self.slots = {}
    self.inventory = LocalPlayer():GetInventory()
    if !self.inventory then return end

    self:Add("InventoryBase:FastSlots")

    local inventoryPanel = self:Add("InventoryBase:Inventory")
    inventoryPanel:SetInventory(client:GetInventory())

    local w, h, sizeH = inventoryPanel:GetWide(), inventoryPanel:GetTall(), H(90)
    inventoryPanel:SetPos(ScrW() - w - W(278), ScrH() / 2 - h + sizeH / 2)
    inventoryPanel.HoveredItem = function(_, item)
        if self.item == item then return end

        self.item = item

        self.infoPanel:SetAlpha(0)
        self.infoPanel:AlphaTo(255, 0.3)
        self.line:SetAlpha(255)

        self.itemName:SetText(item:GetName())
        self.itemCategory:SetText(item:GetCategory())
    end

    InventoryBase:CreateInfoPanel(self, inventoryPanel:GetX(), inventoryPanel:GetY() + h + H(40), math.max(w, W(420)))
end

function PANEL:Paint()
    local client = LocalPlayer()
    local alpha = self:GetAlpha()

    surface.SetDrawColor(15, 6, 7, alpha * 0.9)
    surface.DrawRect(0, 0, ScrW(), ScrH())

    Arbitrage.DrawBlurAt(0, 0, ScrW(), ScrH(), 5, nil, alpha)

    draw.SimpleText(Format("%s | %s", Arbitrage.GetTime(), Arbitrage.GetChapter()), "arb.Font_FuturaPTBook_10", ScrW() / 2, 50, Color( 255, 255, 255), TEXT_ALIGN_CENTER)

    local faction = Arbitrage.teams.Get(client:Team())

    if faction then
        local icon = faction.hud
        if !icon then return end

        local mat = Arbitrage.GetMaterial(Arbitrage.teams.Get(client:Team()).hud or "err.png")
        local size = 0.6
        local sizeW, sizeH = W(mat:Width() * size), H(mat:Height() * size)

        local w, h = W(70), ScrH() / 2 - sizeH / 2 - H(100)

        surface.SetDrawColor(255, 255, 255, 255 * 0.6)
        surface.SetMaterial(Arbitrage.GetMaterial(Arbitrage.teams.Get(client:Team()).hud))
        surface.DrawTexturedRect(w, h, sizeW, sizeH)
        -- surface.DrawOutlinedRect(w, h, sizeW, sizeH)

        surface.SetDrawColor(255, 255, 255, 12)
        surface.DrawRect(w + sizeW - sizeW / 2 - W(120) * 1.5, h + sizeH - sizeH * 0.25 + H(60), W(120) * 3, 2)

        draw.SimpleText(Arbitrage.teams.Get(client:Team()).name, "arb.Font_OpenSansLight_15", w + sizeW - sizeW / 2, h + sizeH - sizeH * 0.25, Color( 255, 255, 255), TEXT_ALIGN_CENTER)
        draw.SimpleText(Arbitrage.teams.Get(client:Team()).description, "arb.Font_OpenSansLight_8", w + sizeW - sizeW / 2, h + sizeH - sizeH * 0.25 + H(80), Color( 255, 255, 255), TEXT_ALIGN_CENTER)
    end
end

vgui.Register("InventoryBase:Menu", PANEL, "EditablePanel")