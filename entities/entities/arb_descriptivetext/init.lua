--[[
        © AsterionStaff 2024.
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

function ENT:Initialize()
	self:SetModel("models/hunter/plates/plate.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetNoDraw(true)
	self:DrawShadow(false)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	self.BoneMods = self.BoneMods or {}

	local physObj = self:GetPhysicsObject()
	if IsValid(physObj) then
		physObj:EnableMotion(false)
		physObj:Wake()
	end
end

function ENT:SetDescriptiveText(data)
	self:SetNetVar("DescriptiveText", data)
end

function ENT:OnDuplicated(entTable)
	local pos, ang = self:GetPos(), self:GetAngles()
	local data = self.BoneMods and self.BoneMods.descriptiveData
	self:Remove()

	local entity = ents.Create("arb_descriptivetext")
	entity:SetPos(pos)
	entity:SetAngles(ang)
	entity:Spawn()

	entity:SetDescriptiveText(data.text)
end

function ENT:PreEntityCopy()
	self.BoneMods = self.BoneMods or {}
	self.BoneMods.descriptiveData = self.BoneMods.descriptiveData or {}

	self.BoneMods.descriptiveData.text = self:GetNetVar("DescriptiveText")
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end