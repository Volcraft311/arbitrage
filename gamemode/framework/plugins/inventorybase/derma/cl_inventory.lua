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


local crossMat = Material("danganronpa/inventory/cross.png")

local PANEL = {}

function PANEL:Init()
	self:SetPos(0, 0)
	self:SetSize(0, 0)

	self.item = nil
	self.inventory = nil
	self.slots = {}

	-- self:CreateHook()
end

function PANEL:SetInventory(inventory)
    if !inventory then return end

	InventoryBase.invpanels[inventory:GetID()] = self

	self.inventory = inventory
	self:InitInventory()
end

function PANEL:InitInventory()
    for k, v in ipairs(self:GetChildren()) do
        v:Remove()
    end

    local sizeW, sizeH, indentW, indentH = W(90), H(90), W(20), H(16)
    local w, h = sizeW * self.inventory.w + indentW * self.inventory.w - indentW, sizeH * self.inventory.h + indentH * self.inventory.h - indentH

    self:SetSize(w, h)

    for x = 1, self.inventory.w do
        self.slots[x] = self.slots[x] or {}

        for y = 1, self.inventory.h do
            local slot = self:Add("DPanel")
            slot:SetPos(sizeW * (x - 1) + indentW * (x - 1), sizeH * (y - 1) + indentH * (y - 1))
            slot:SetSize(sizeW, sizeH)
            slot.slotX = x
            slot.slotY = y
            slot.invID = self.inventory.id

            self:InitSlot(slot)
            self.slots[x][y] = slot
        end
    end
end

function PANEL:InitSlot(panel)
    local x, y = panel.slotX, panel.slotY

    panel.alpha = 14
    panel.PaintReceive = function(_, w, h, previewX, previewY, itemPanel)
        if itemPanel.selectPanel == panel then
            local hasItem = panel.item
            local color = hasItem and Color(255, 0, 0) or Color(255, 234, 238)

            surface.SetDrawColor(ColorAlpha(color, 10))
            surface.DrawRect(0, 0, w, h)
        end
    end

    local color = ColorAlpha(Color(99, 17, 32), 20)

    panel.Paint = function(this, w, h)
    	local bSelect = panel.itemPanel and ((panel.itemPanel:IsHovered() or panel.item == self.item) and true) or false

    	this.alpha = Lerp(FrameTime() * 10, this.alpha, bSelect and 255 or 14)

        surface.SetDrawColor(1, 1, 1, 229.5)
        surface.DrawRect(0, 0, w, h)

        if panel.itemPanel and panel.itemPanel.selectPanel then
            surface.SetDrawColor(color)
            surface.DrawRect(0, 0, w, h)
        end

        local panels = dragndrop.GetDroppable() or {}
        local itemPanel = panels[1]

        if IsValid(itemPanel) then
            this:PaintReceive(w, h, this.previewX, this.previewY, itemPanel)
        end

        if !panel.item then
            surface.SetDrawColor(255, 255, 255, 12.75)
            surface.SetMaterial(crossMat)
            surface.DrawTexturedRect(0, 0, w, h)
        end

        surface.SetDrawColor(99, 17, 32, this.alpha)
        surface.DrawOutlinedRect(0, 0, w, h, 2)
    end

    panel:Receiver("transferItem", function(this, panels, bDoDrop)
        local item = panels[1]
        if !item then return end

        if bDoDrop then
            item.selectPanel = nil

            local function transfer()
                if !IsValid(item) then return end

                netstream.Start("InventoryBase:TransferItem", item.item:GetID(), this.invID, this.slotX, this.slotY)
            end

            local function unstack(value)
                if !IsValid(item) then return end

                value = math.Round(value, 0)
                netstream.Start("InventoryBase:ItemUnStack", item.item:GetID(), this.invID, value, this.slotX, this.slotY)
            end

            local function stack()
                if !IsValid(panel) then return end
                if !IsValid(item) then return end

                netstream.Start("InventoryBase:ItemStack", panel.item:GetID(), item.item:GetID())
            end

            local parent = item:GetParent()
            if !parent then return end
            if panel.item then
                return stack()
            end

            if input.IsKeyDown(KEY_LSHIFT) or input.IsKeyDown(KEY_LCONTROL) then
                local func = item.item.UnStackValue
                if !func then return transfer() end

                local maxValue = func(item.item)
                if !maxValue then return transfer() end

                if maxValue > 1 then
                    local DermaPanel = vgui.Create("DFrame")
                    DermaPanel:SetTitle("Разложить предметы")
                    DermaPanel:SetSize(400, 100)
                    DermaPanel:Center()
                    DermaPanel:MakePopup()

                    local DermaNumSlider = DermaPanel:Add("DNumSlider")
                    DermaNumSlider:Dock(FILL)
                    DermaNumSlider:SetText("Количество:")
                    DermaNumSlider:SetMin(1)
                    DermaNumSlider:SetMax(maxValue)
                    DermaNumSlider:SetDecimals(0)
                    DermaNumSlider:SetValue(math.floor(maxValue / 2))

                    local DermaButton = DermaNumSlider:Add("DButton")
                    DermaButton:SetText("Разложить")
                    DermaButton:Dock(BOTTOM)
                    DermaButton.DoClick = function()
                        local value = DermaNumSlider:GetValue()

                        DermaPanel:Remove()
                        unstack(value)
                    end

                    DermaPanel.startTime = SysTime()
                    DermaPanel:SetAlpha(0)
                    DermaPanel:AlphaTo(255, 0.3)

                    DermaPanel.Paint = function(_, w, h)
                        Derma_DrawBackgroundBlur(_, _.startTime)

                        surface.SetDrawColor(41, 22, 25)
                        surface.DrawRect(0, 0, w, h)

                        surface.SetDrawColor(255, 61, 96, 165.75)
                        surface.DrawOutlinedRect(0, 0, w, h, 2)

                        surface.SetDrawColor(255, 61, 96, 165.75)
                        surface.DrawOutlinedRect(0, 0, w, H(23), 2)

                        surface.SetDrawColor(255, 61, 96, 20)
                        surface.DrawRect(0, 0, w, H(23))

                        if !IsValid(Arbitrage.gui.inventory) then
                            _:Remove()
                        end
                    end

                    DermaPanel:GetChildren()[4]:SetTextColor(Color(255, 255, 255))
                    DermaPanel:GetChildren()[5]:GetChildren()[1]:SetTextColor(Color(255, 255, 255))
                elseif maxValue == 1 then
                    unstack(1)
                else
                    transfer()
                end
            else
                transfer()
            end
        else
            item.selectPanel = this
        end
    end)

    local item = self.inventory:GetItemAt(x, y)
    if item then
        local path = item:GetIcon()
        local icon = nil
        if string.isURL(path) then
            asterionlib.DownloadImage(path, function(mat)
                icon = mat
            end)
        else
            icon = Material(path)
        end

        local itemPanel = panel:Add("DButton")
        itemPanel:SetText("")
        itemPanel:Dock(FILL)
        itemPanel:Droppable("transferItem")
        itemPanel.Paint = function(this, w, h)
            if icon then
                surface.SetDrawColor(255, 255, 255)
                surface.SetMaterial(icon)
                surface.DrawTexturedRect(0, 0, w, h)
            end

            if panel.item.Paint then
                panel.item:Paint(panel.item, w, h)
            end

            if this:IsHovered() and self.HoveredItem then
                self:HoveredItem(item)

                if self.item == item then return end
                self.item = item
            end
        end

        itemPanel.DoDoubleClick = function(this)
            local container = Arbitrage.gui.inventory
            if !IsValid(container) then return end

            local localInvID = container.invIDClient
            if !localInvID then return end

            local containerInvID = container.invIDContainer
            if !containerInvID then return end

            local transferInvID = localInvID

            local inv = LocalPlayer():GetInventory()
            local items = inv:GetItems()
            for k, v in ipairs(items) do
                if v:GetID() == item:GetID() then
                    transferInvID = containerInvID
                    break
                end
            end

            netstream.Start("InventoryBase:TransferItem", item:GetID(), transferInvID)
        end

        local oldOnMouseReleased = itemPanel.OnMouseReleased
        itemPanel.OnMouseReleased = function(this, key)
            itemPanel.selectPanel = nil

            oldOnMouseReleased(this, key)
        end

        local oldOnMousePressed = itemPanel.OnMousePressed
        itemPanel.OnMousePressed = function(this, key)
            if key == MOUSE_RIGHT then
                netstream.Start("InventoryBase:GetActions", item:GetID())
            end

            oldOnMousePressed(this, key)
        end

        itemPanel.item = item
        panel.item = item
        panel.itemPanel = itemPanel
    end
end

vgui.Register("InventoryBase:Inventory", PANEL, "EditablePanel")