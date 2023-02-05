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

include("shared.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

local invalidBoundsMin = Vector(-8, -8, -8)
local invalidBoundsMax = Vector(8, 8, 8)

function ENT:Initialize()
	self:SetModel("models/props_lab/box01a.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.health = 50
	self.BoneMods = self.BoneMods or {}
	self.BoneMods.saveData = self.BoneMods.saveData or {}

	local physObj = self:GetPhysicsObject()

	if (IsValid(physObj)) then
		physObj:EnableMotion(true)
		physObj:Wake()
	end
end

function ENT:Use(activator, caller)
	local itemID = self:GetItemID()
	if !itemID then return end

	local item = self:GetItem()
	if !item then return end

	item.player = activator
	item.entity = self

	local data = {}
	local actionList = item:GetValidActions()
	for k, v in pairs(actionList) do
		data[#data + 1] = {k, v.icon}
	end

	if #data >= 1 then
		netstream.Start(activator, "ItemBase:OpenActions", self:GetUniqueID(), data, self)
	end

	item.player = nil
	item.entity = nil
end

local function setItemProperties(item, entity, data)
	local info = ItemBase:GetItemProperties(item)

	for key, value in pairs(data) do
		local prefix = string.Left(key, 2)

		if prefix == "m_" then
			key = key:gsub("m_", "")

			for k2, v2 in ipairs(info) do
				if v2[1] == key and v2[4] then
					v2[4](item, entity, value)
				end
			end
		end
	end
end

function ENT:SetItem(itemID)
	if !itemID then return end

	local item = self:GetItem() or ItemBase.instances[itemID]
	if !item then return end

	self:SetModel(item:GetModel())
	self:SetSkin(item:GetSkin())

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetUniqueID(item.uniqueID)
	self:SetItemID(item:GetID())

	local physObj = self:GetPhysicsObject()

	if (!IsValid(physObj)) then
		self:PhysicsInitBox(invalidBoundsMin, invalidBoundsMax)
		self:SetCollisionBounds(invalidBoundsMin, invalidBoundsMax)
	end

	if (IsValid(physObj)) then
		physObj:EnableMotion(true)
		physObj:Wake()
	end

	local data = ItemBase.data[itemID] or {}
	for k, v in pairs(data) do
		self.BoneMods.saveData[k] = v
	end

	setItemProperties(item, self, data)
end

function ENT:OnTakeDamage(damageInfo)
	local damage = damageInfo:GetDamage()
	self:SetHealth(self:Health() - damage)

	if self:Health() <= 0 then
		local item = self:GetItem()
		if item then
			item:Remove()
		end

		if IsValid(self) then
			self:Remove()
		end

		self.IsDestroying = true
	end
end

function ENT:OnRemove()
	if self.IsDestroying then
		self:EmitSound("physics/cardboard/cardboard_box_break" .. math.random(1, 3) .. ".wav")
		local position = self:LocalToWorld(self:OBBCenter())

		local effect = EffectData()
			effect:SetStart(position)
			effect:SetOrigin(position)
			effect:SetScale(3)
		util.Effect("GlassImpact", effect)
	end
end

function ENT:OnDuplicated(entTable)
	local uniqueID = entTable.DT and entTable.DT.UniqueID
	local pos, ang = self:GetPos(), self:GetAngles()
	local data = self.BoneMods and self.BoneMods.saveData
	self:Remove()

	if !uniqueID then return end

	local item, entity = ItemBase.CreateItemInWorld(uniqueID, pos, ang)
	if !item then return end

	for key, value in pairs(data or {}) do
		item:SetData(key, value)
	end

	setItemProperties(item, entity, data)
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end