--[[
        © Asterion Project 2021.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
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

	local physObj = self:GetPhysicsObject()

	if (IsValid(physObj)) then
		physObj:EnableMotion(true)
		physObj:Wake()
	end
end

function ENT:Use(activator, caller)
	local itemID = self:GetItemID()
	if !itemID then return end

	local item = ItemBase.instances[itemID]
	if !item then return end

	item.player = activator
	item.entity = self

	local data = {}
	local actionList = item:GetValidActions()
	for k, v in pairs(actionList) do
		data[#data + 1] = k
	end

	if #data >= 1 then
		netstream.Start(activator, "ItemBase:OpenActions", self:GetUniqueID(), data, self)
	end

	item.player = nil
	item.entity = nil
end

function ENT:SetItem(itemID)
	if !itemID then return end

	local item = ItemBase.instances[itemID]
	if !item then return end

	self:SetModel(item:Model())
	self:SetSkin(item:Skin())

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
end

function ENT:OnTakeDamage(damageInfo)
	local damage = damageInfo:GetDamage()
	self:SetHealth(self:Health() - damage)

	if self:Health() <= 0 then
		local item = ItemBase.instances[self:GetItemID()]
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

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end