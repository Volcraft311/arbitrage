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


local PLUGIN = PLUGIN

local items_info = {}
asterionlib.entscollector:AddTrack("items", {
	delay_apply = 1,
	onCanTrack = function(entity)
		return entity:GetClass() == "arb_item"
	end,
	onCanApply = function(entity)
		if entity:GetPos():DistToSqr(EyePos()) > 200000 then return false end
		if entity:IsDormant() then return false end

		local uniqueID = entity.GetUniqueID and entity:GetUniqueID()
		if !uniqueID then return false end

		local id = entity.GetItemID and entity:GetItemID()
		if !id then return false end

		local item = (PLUGIN.instances[id] or PLUGIN.list[uniqueID]) or Arbitrage.meta.item
		if !item then return false end

		local name = item:GetName()
		local desc = item:GetDescription()
		local category = item:GetCategory()

		local path = item:GetIcon()
		local icon = nil
		if string.isURL(path) then
			asterionlib.downloader:Image(path, function(mat)
				icon = mat
			end)
		else
			icon = Material(path)
		end

		items_info[entity] = items_info[entity] or {alpha = 0}
		items_info[entity].name = name
		items_info[entity].desc = desc
		items_info[entity].category = category
		items_info[entity].icon = icon

		return true
	end
})

function PLUGIN:HUDPaint()
	local ft = FrameTime()
	local ent = LocalTraceEntity()
	local data = asterionlib.entscollector:GetApply("items")
	for k, entity in ipairs(data) do
		if !IsValid(entity) then continue end

		local isTraceEntity = ent == entity
		local info = items_info[entity]

		if !isTraceEntity and info.alpha <= 0.1 then continue end
		info.alpha = Lerp(ft * 3, info.alpha, isTraceEntity and 256 or 0)

		if info.alpha <= 0.1 then continue end

		self.infoMenu:Paint(entity, info.name, info.desc, info.category, info.icon, info.alpha)
	end

	self.actionMenu:Paint()
end

function PLUGIN:EditProperties(itemID)
	local save = {}

	local item = self.instances[itemID]
	local info = self:GetItemProperties(item)

	local f = vgui.Create("DFrame")
	f:SetTitle("Изменение свойств предмета")
	f:SetSize(800, 250)
	f:Center()
	f:MakePopup()

	local Properties = f:Add("DProperties")
	Properties:Dock(FILL)

	for k, v in ipairs(info) do
		local row = Properties:CreateRow("Свойства", v[2])
		row:Setup("Generic")
		row.value = ""
		row:SetValue(row.value)
		row.DataChanged = function(this, data)
			this.value = data
			save[v[1]] = data
		end

		if item then
			local name = v[3](item)
			row.value = name
			row:SetValue(name)

			save[v[1]] = name
		end
	end

	local Save = f:Add("DButton")
	Save:SetText("Сохранить")
	Save:Dock(BOTTOM)
	Save.DoClick = function()
		f:Remove()

		netstream.Start("ItemBase:EditItemProperties", itemID, save)
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
	for _, name in SortedPairsByMemberValue(data, 1) do
	    local action = ItemBase.list[uniqueID].functions[name[1]]
	    if !action then continue end

	    sendOptions[#sendOptions + 1] = {name[1], name[2]}
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

netstream.Hook("ItemBase.AnimTakeItem", function(target, pos, ang, model)
	if !IsValid(target) then return end
	if target:IsDormant() then return end

	local alpha = 255
	local scale = 1

	local csEnt = ClientsideModel(model)
	csEnt:SetPos(pos)
	csEnt:SetAngles(ang)
	csEnt:SetRenderMode(RENDERMODE_TRANSCOLOR)
	csEnt:SetColor(Color(255, 255, 255, 255))
	csEnt:ManipulateBoneScale(0, Vector(scale, scale, scale))

	local n = 9999999
	local hook_id = "ItemBase.AnimItem_" .. math.random(1, n) .. math.random(1, n) .. math.random(1, n)
	local function remove()
		if IsValid(csEnt) then
			csEnt:Remove()
		end

		hook.Remove("Think", hook_id)
	end

	hook.Add("Think", hook_id, function()
		if !IsValid(target) then return remove() end

		local ft = FrameTime()

		local endPos = target:GetPos() + target:OBBCenter()
		local endAng = target:EyeAngles()

		pos = Lerp(ft * 4, pos, endPos)
		ang = Lerp(ft * 3, ang, endAng)
		alpha = Lerp(ft * 4, alpha, -2)
		scale = Lerp(ft * 4, scale, 0.1)

		csEnt:SetPos(pos)
		csEnt:SetAngles(ang)
		csEnt:SetColor(Color(255, 255, 255, alpha))
		csEnt:ManipulateBoneScale(0, Vector(scale, scale, scale))

		if alpha <= 0 then
			remove()
		end
	end)
end)

local hides_hooks = {
	"HUDPaint",
	"RenderScreenspaceEffects",
	"RenderScene",
	"PostDrawTranslucentRenderables",
	"PreDrawOpaqueRenderables",
	"PreDrawTranslucentRenderables"
}

local function awaitSyncEntity(idx, class, callback)
	local request = 0
	local hook_id = "awaitSyncEntity_" .. idx .. class
	hook.Add("Think", hook_id, function()
		local entity = Entity(idx)

		request = request + 1
		if request >= 1000 then
			for k, v in ipairs(hides_hooks) do
				hook.Remove(v, hook_id)
			end

			return hook.Remove("Think", hook_id)
		end

		if IsValid(entity) and entity:GetClass() == class then
			hook.Remove("Think", hook_id)
			callback(entity)
		end
	end)
end

netstream.Hook("ItemBase.AnimDropItem", function(target, idx, class)
	if !IsValid(target) then return end
	if target:IsDormant() then return end

	local function hide()
		local entity = Entity(idx)

		if IsValid(entity) and entity:GetClass() == class then
			entity:SetNoDraw(true)
			entity:SetNotSolid(true)
			entity:DrawShadow(false)
		end
	end

	local hook_id = "ItemBase.AnimItem_" .. idx
	for k, v in ipairs(hides_hooks) do
		hook.Add(v, hook_id, function()
			hide()
		end)
	end

	awaitSyncEntity(idx, class, function(entity)
		local pos = target:EyePos()
		local ang = Angle(0, entity:GetAngles().y + math.random(-180, 180), 0)
		local alpha = 0
		local scale = 0.5

		local csEnt = ClientsideModel(entity:GetModel())
		csEnt:SetPos(pos)
		csEnt:SetAngles(ang)
		csEnt:SetRenderMode(RENDERMODE_TRANSCOLOR)
		csEnt:SetColor(Color(255, 255, 255, 0))
		csEnt:ManipulateBoneScale(0, Vector(scale, scale, scale))

		entity:SetNoDraw(true)
		entity:SetNotSolid(true)
		entity:DrawShadow(false)

		local function remove()
			if IsValid(entity) then
				entity:SetNoDraw(false)
				entity:SetNotSolid(false)
				entity:DrawShadow(true)

				timer.Simple(0.1, function()
					if !IsValid(entity) then return end

					entity:SetNoDraw(false)
					entity:SetNotSolid(false)
					entity:DrawShadow(true)
				end)
			end

			if IsValid(csEnt) then
				csEnt:Remove()
				csEnt = nil
			end

			hook.Remove("Think", hook_id)
			for k, v in ipairs(hides_hooks) do
				hook.Remove(v, hook_id)
			end
		end

		hook.Add("Think", hook_id, function()
			if !IsValid(entity) then
				return remove()
			end

			hide()

			local ft = FrameTime()

			local endPos = entity:GetPos()
			local endAng = entity:GetAngles()

			pos = Lerp(ft * 6, pos, endPos)
			ang = Lerp(ft * 4, ang, endAng)
			alpha = Lerp(ft * 8, alpha, 257)
			scale = Lerp(ft * 4, scale, 1)

			csEnt:SetPos(pos)
			csEnt:SetAngles(ang)
			csEnt:SetColor(Color(255, 255, 255, alpha))
			csEnt:ManipulateBoneScale(0, Vector(scale, scale, scale))

			if pos:Distance(entity:GetPos()) <= 0.1 then
				remove()
			end
		end)
	end)
end)