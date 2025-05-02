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
    if IsValid(Arbitrage.gui.inventory) then
        Arbitrage.gui.inventory:Remove()
    end

    Arbitrage.gui.inventory = self

    local client = LocalPlayer()

    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self:MakePopup()

    self:SetAlpha(0)
    self:AlphaTo(255, 0.3)
    self:SetKeyboardInputEnabled(false)

    self.item = nil
    self.inventory = client:GetInventory()
    if !self.inventory then return end

    self:Add("InventoryBase:FastSlots")

    local inventoryPanel = self:Add("InventoryBase:Inventory")
    inventoryPanel:SetInventory(self.inventory)

    local w, h = inventoryPanel:GetWide(), inventoryPanel:GetTall(), H(90)
    inventoryPanel:SetPos(ScrW() - w - W(278), ScrH() / 2 - h / 2)
    inventoryPanel.HoveredItem = function(_, item)
        if self.item == item then return end

        self.item = item

        self.infoPanel:SetAlpha(0)
        self.infoPanel:AlphaTo(255, 0.3)
        self.line:SetAlpha(255)

        self.itemName:SetText(F(item:GetName()))
        self.itemCategory:SetText(F(item:GetCategory()))
    end

    InventoryBase:CreateInfoPanel(self, inventoryPanel:GetX(), inventoryPanel:GetY() + h + H(40), math.max(w, W(420)))

    netstream.Start("Inventory:OpenMenu")
    self:Receiver("transferItem", function(this, panels, bDoDrop)
        local panel = panels[1]
        if !panel then return end

        local item = panel.item

        if bDoDrop and item then
            panel.selectPanel = nil

            netstream.Start("ItemBase:SendAction", item:GetID(), "#item_action_drop")
        end
    end)
end

function PANEL:Paint()
    local client = LocalPlayer()
    local alpha = self:GetAlpha()

    surface.SetDrawColor(15, 6, 7, alpha * 0.9)
    surface.DrawRect(0, 0, ScrW(), ScrH())

    asterionlib.DrawBlurAt(0, 0, ScrW(), ScrH(), 5, nil, alpha)

    draw.SimpleText(Format("%s | %s", Time:GetFormated(), L(Arbitrage.GetChapter())), "arb.Font_FuturaPTBook_10", ScrW() / 2, 50, Color( 255, 255, 255), TEXT_ALIGN_CENTER)

    local faction = Character.team:GetByID(client:Team())

    if faction then
        local icon = faction:GetAssets().hud
        if !icon then return end

        local mat = Material(icon)
        local size = 0.6
        local sizeW, sizeH = W(mat:Width() * size), H(mat:Height() * size)

        local w, h = W(70), ScrH() / 2 - sizeH / 2 - H(100)

        surface.SetDrawColor(255, 255, 255, 255 * 0.6)
        surface.SetMaterial(mat)
        surface.DrawTexturedRect(w, h, sizeW, sizeH)

        surface.SetDrawColor(255, 255, 255, 12)
        surface.DrawRect(w + sizeW - sizeW / 2 - W(120) * 1.5, h + sizeH - sizeH * 0.25 + H(60), W(120) * 3, 2)

        draw.SimpleText(client:Name(), "arb.Font_OpenSansLight_15", w + sizeW - sizeW / 2, h + sizeH - sizeH * 0.25, Color( 255, 255, 255), TEXT_ALIGN_CENTER)
        draw.SimpleText(L(faction:GetTitle()), "arb.Font_OpenSansLight_8", w + sizeW - sizeW / 2, h + sizeH - sizeH * 0.25 + H(80), Color( 255, 255, 255), TEXT_ALIGN_CENTER)
    end
end

vgui.Register("InventoryBase:Menu", PANEL, "EditablePanel")