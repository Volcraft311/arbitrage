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

local entities = {}
local ent = nil
timer.Create("ItemBase:UpdateDraw", 1, 0, function()
	entities = {}
	ent = nil

	local client = LocalPlayer()
	if !IsValid(client) then return end

	local traceline = {}
	traceline.start = client:GetShootPos()
	traceline.endpos = traceline.start + client:GetAimVector() * 180
	traceline.filter = client
	local tr = util.TraceLine(traceline)

	for k, v in ipairs(ents.FindInSphere(EyePos(), 500)) do
		if v:GetClass() == "arb_item" and !v:IsDormant() and v.GetUniqueID and v.GetItemID then
			local uniqueID = v:GetUniqueID()
			local id = v:GetItemID()

			local item = (PLUGIN.instances[id] or PLUGIN.list[uniqueID]) or Arbitrage.meta.item
			if !item then continue end

			local name = item:GetName()
			local desc = item:GetDescription()
			local category = item:GetCategory()
			local icon = item:GetIcon()

			v.panelAlpha = v.panelAlpha or 0

			entities[#entities + 1] = {v, name, desc, category, icon}

			if tr.Entity == v then
				ent = v
			end
		end
	end
end)

function PLUGIN:HUDPaint()
	self.actionMenu:Paint()

	for k, v in ipairs(entities) do
		local entity = v[1]
		if !IsValid(entity) then continue end
		if self.actionMenu.stored[entity] then continue end

		local name, desc, category, icon = v[2], v[3], v[4], v[5]

		if ent != entity and entity.panelAlpha <= 0.1 then continue end

		entity.panelAlpha = Lerp(FrameTime() * 3, entity.panelAlpha, ent == entity and 256 or 0)

		self.infoMenu:Paint(entity, name, desc, category, icon, entity.panelAlpha)
	end
end

netstream.Hook("ItemBase:SyncItem", function(uniqueID, itemID, data)
    ItemBase:New(uniqueID, itemID)
    ItemBase.data[itemID] = data
end)

netstream.Hook("ItemBase:SetData", function(id, key, value)
    ItemBase.data[id] = ItemBase.data[id] or {}
    ItemBase.data[id][key] = value
end)

netstream.Hook("ItemBase:OpenActions", function(uniqueID, data, entity)
	local sendOptions = {}
	for _, name in SortedPairsByValue(data) do
	    local action = ItemBase.list[uniqueID].functions[name]
	    if !action then continue end

	    sendOptions[#sendOptions + 1] = name
	end

	local info = {
	    entity = entity,
	    options = sendOptions,
	    alpha = -150
	}

	if !PLUGIN.actionMenu.stored[entity] and #sendOptions > 0 and (!PLUGIN.actionMenu.cd or CurTime() >= PLUGIN.actionMenu.cd) then
	    PLUGIN.actionMenu:New(info)

	    PLUGIN.actionMenu.cd = CurTime() + 0.6
	end
end)

netstream.Hook("ItemBase:CreationRegisterItem", function(baseID, uniqueID, info)
	ItemBase.CreationRegisterItem(baseID, uniqueID, info)
end)

netstream.Hook("ItemBase:CreationEditItem", function(uniqueID, info)
	ItemBase.CreationEditItem(uniqueID, info)
end)

netstream.Hook("ItemBase:CreationRemoveItem", function(uniqueID)
	ItemBase.CreationRemoveItem(uniqueID)
end)

netstream.Hook("ItemBase:CreationProtectItem", function(uniqueID, protect)
	ItemBase.CreationProtectItem(uniqueID, protect)
end)

netstream.Hook("ItemBase:CreationSync", function(baseID, stored)
	for uniqueID, info in pairs(stored) do
		ItemBase.CreationRegisterItem(baseID, uniqueID, info)
	end
end)