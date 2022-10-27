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


local crossMat = Material("danganronpa/inventory/cross.png")

local PANEL = {}

function PANEL:Init()
	Arbitrage.gui.fastSlots = self

	local parent = self:GetParent()
	local size = W(300)

	self.slots = {}
	self:SetPos(parent:GetWide() / 2 - size / 2, H(258))
	self:SetSize(size, size)

	self:InitSlots()
end

function PANEL:InitSlots()
	for k, v in ipairs(self:GetChildren()) do
		v:Remove()
	end

	for i = 1, 4 do
		local a = i % 2 == 0
		local b = a and W(105) or -W(105)
		local c = 0

		if i > 2 then
			b = 0
			c = a and H(105) or -H(105)
		end

		local slot = self:Add("DPanel")
		slot:SetSize(W(90), H(90))
		slot:SetPos(self:GetWide() / 2 - slot:GetWide() / 2 - b, self:GetTall() / 2 - slot:GetTall() / 2 - c)
		slot.id = i
		self:InitSlot(slot)

		self.slots[i] = slot
	end
end

local function isURL(url)
	return string.Left(url, 8) == "https://" or string.Left(url, 7) == "http://"
end

function PANEL:InitSlot(panel)
	panel.alpha = 14
	panel.Paint = function(this, w, h)
		local bSelect = false
		this.alpha = Lerp(FrameTime() * 10, this.alpha, bSelect and 255 or 14)

		surface.SetDrawColor(1, 1, 1, 229.5)
	    surface.DrawRect(0, 0, w, h)

		if !panel.item then
	        surface.SetDrawColor(255, 255, 255, 12.75)
	        surface.SetMaterial(crossMat)
	        surface.DrawTexturedRect(0, 0, w, h)
        end

		surface.SetDrawColor(99, 17, 32, this.alpha)
	    surface.DrawOutlinedRect(0, 0, w, h, 2)

	    draw.SimpleText(this.id, "arb.Font_FuturaPTBook_6", w - W(4), h - H(20), Color(255, 255, 255, 100), TEXT_ALIGN_RIGHT)
	end

	panel:Receiver("transferItem", function(this, panels, bDoDrop)
		local item = panels[1]
        if !item then return end

        if bDoDrop then
        	local parent = item:GetParent()
            if !parent then return end
            if panel.item then return end

            netstream.Start("InventoryBase:EquipItem", this.id, item.item:GetID())
        end
	end)

	local data = LocalPlayer():GetLocalVar("fast_slot_" .. panel.id)

	if data then
		local itemID = data[2] or -1
		local item = ItemBase.instances[itemID]
		if !item then return end

		local path = item:GetIcon()
	    local icon = nil
	    if isURL(path) then
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

function PANEL:Think()
	for k, v in ipairs(self.slots) do
		local data = LocalPlayer():GetLocalVar("fast_slot_" .. v.id)

		if data and !v.item then
			local itemID = data[2] or -1
			local item = ItemBase.instances[itemID]
			if !item then continue end

			InventoryBase:UpdateInventory()
		elseif !data and v.item then
			InventoryBase:UpdateInventory()
		end
	end

	local hoveredPanel = vgui.GetHoveredPanel()
	if !hoveredPanel or !hoveredPanel.item then return end

	local id = hoveredPanel.item:GetID()
	if !id then return end

	if (!self.keyCD or CurTime() >= self.keyCD) then
		for i = 2, 5 do
			if input.IsKeyDown(i) then
				local key = tonumber(input.GetKeyName(i))

				netstream.Start("InventoryBase:EquipItem", key, id)

				self.keyCD = CurTime() + 0.3
			end
		end
	end
end

vgui.Register("InventoryBase:FastSlots", PANEL, "EditablePanel")