--[[
        © AsterionStaff 2023.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

include("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

local invalidBoundsMin = Vector(-8, -8, -8)
local invalidBoundsMax = Vector(8, 8, 8)

function ENT:Initialize()
	self:SetUseType(SIMPLE_USE)

	self.BoneMods = self.BoneMods or {}

	local physObj = self:GetPhysicsObject()
	if IsValid(physObj) then
		physObj:EnableMotion(false)
		physObj:Wake()
	end
end

function ENT:Use(client, caller)
	client:PlayAnimation(GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_ITEM_PLACE, true)

	local name = self.GetContainerName and self:GetContainerName() or ""

	if name != "" and name != " " then
		for k, v in ipairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.5)) do
		    TypingDraw:SetTypingText(v, client, "Осматривает '" .. name .. "'", Color(255, 170, 23))
		end
	end

	Arbitrage.action.ActionRun(client, "Обыскиваем", 1, function()
	    if client:GetEyeTrace().Entity != self then return true end
	    if client:GetPos():Distance(self:GetPos()) >= 200 then return true end

	    return false
	end, function(activator)
	    InventoryBase.Open(client, self.Inventory:GetID(), self:GetContainerName())
	end)
end

function ENT:SetContainer(model, name, w, h)
	self:SetModel(model)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:Spawn()

	self.Inventory = InventoryBase.CreateInventory(w, h)
	self.Inventory:SetOwner(self)

	self:SetContainerName(name)
	self:SetInventoryID(self.Inventory:GetID())

	local physObj = self:GetPhysicsObject()

	if (!IsValid(physObj)) then
		self:PhysicsInitBox(invalidBoundsMin, invalidBoundsMax)
		self:SetCollisionBounds(invalidBoundsMin, invalidBoundsMax)
	end

	if IsValid(physObj) then
		physObj:EnableMotion(false)
		physObj:Wake()
	end
end

function ENT:OnDuplicated(entTable)
	local pos, ang, model = self:GetPos(), self:GetAngles(), self:GetModel()
	local data = self.BoneMods and self.BoneMods.saveData
	self:Remove()

	local container = ents.Create("arb_container")
	container:SetPos(pos)
	container:SetAngles(ang)
	container:SetContainer(model, data.name, data.w, data.h)

	local inventory = container.Inventory
	for _, v in ipairs(data.items) do
		local uniqueID, x, y, saveData, customData = v[1], v[2], v[3], v[4], v[5]

		local item = ItemBase.CreateItem(uniqueID)
		if item then
			for key, value in pairs(saveData or {}) do
				item:SetData(key, value)
			end

			if customData then
				item.data = customData
			end

			item:Transfer(inventory:GetID(), x, y)
		end
	end
end

function ENT:PreEntityCopy()
	self.BoneMods = self.BoneMods or {}

	local inventory = self.Inventory
	local items = {}
	for x = 1, inventory.w do
		for y = 1, inventory.h do
			local item = inventory:GetItemAt(x, y)

			if item then
				items[#items + 1] = {item:GetUniqueID(), x, y, ItemBase.data[item:GetID()], item.data}
			end
		end
	end

	self.BoneMods.saveData = {
		name = self:GetContainerName(),
		w = inventory.w,
		h = inventory.h,
		items = items
	}
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end