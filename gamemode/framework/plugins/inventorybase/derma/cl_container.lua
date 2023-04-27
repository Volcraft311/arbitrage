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

    self.item = nil
    self.inventory = client:GetInventory()

    if !self.inventory then return end

    local inventoryPanel = self:Add("InventoryBase:Inventory")
    inventoryPanel:SetInventory(self.inventory)
    self.invIDClient = self.inventory:GetID()

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

function PANEL:SetContainerInv(inventory, name)
    if !inventory then return end

    local inventoryPanel = self:Add("InventoryBase:Inventory")
    inventoryPanel:SetInventory(inventory)
    self.invIDContainer = inventory:GetID()

    local w, h = inventoryPanel:GetWide(), inventoryPanel:GetTall()
    inventoryPanel:SetPos(W(278), ScrH() / 2 - h / 2)
    inventoryPanel.HoveredItem = function(_, item)
        if self.item == item then return end

        self.item = item

        self.infoPanel:SetAlpha(0)
        self.infoPanel:AlphaTo(255, 0.3)
        self.line:SetAlpha(255)

        self.itemName:SetText(item:GetName())
        self.itemCategory:SetText(item:GetCategory())
    end

    self.containerID = inventory:GetID()

    if name then
        local size = H(52)

        local namePanel = self:Add("DPanel")
        namePanel:SetPos(inventoryPanel:GetX(), inventoryPanel:GetY() - size - H(20))
        namePanel:SetSize(inventoryPanel:GetWide(), size)
        namePanel.Paint = function(_, w, h)
            draw.SimpleText(name, "arb.Font_FuturaPTBook_12", 0, 0, color_white, TEXT_ALIGN_LEFT)

            surface.SetDrawColor(255, 255, 255, 100)
            surface.DrawRect(0, h - 2, w, 2)
        end
    end
end

function PANEL:OnRemove()
    if self.containerID then
        netstream.Start("InventoryBase:StopReceiving", self.containerID)
    end
end

function PANEL:Paint()
    local alpha = self:GetAlpha()

    surface.SetDrawColor(15, 6, 7, alpha * 0.9)
    surface.DrawRect(0, 0, ScrW(), ScrH())

    asterionlib.DrawBlurAt(0, 0, ScrW(), ScrH(), 5, nil, alpha)

    draw.SimpleText(Format("%s | %s", Arbitrage.GetTime(), Arbitrage.GetChapter()), "arb.Font_FuturaPTBook_10", ScrW() / 2, 50, Color( 255, 255, 255), TEXT_ALIGN_CENTER)
end

vgui.Register("InventoryBase:Container", PANEL, "EditablePanel")