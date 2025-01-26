--[[
        © AsterionStaff 2025.
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

function ENT:OnRemove()
	if self.bOnNetSend then return end

	local trigger = self.trigger
	if !trigger then return end

	trigger:Remove()
end

function ENT:OnDuplicated(entTable)
	local data = self.BoneMods and self.BoneMods.triggerData
	self:Remove()

	local trigger = Trigger:Create(data)
	trigger:Sync()
end

function ENT:PreEntityCopy()
	self.BoneMods = self.BoneMods or {}
	self.BoneMods.triggerData = self.BoneMods.triggerData or {}

	local trigger = self.trigger
	if !trigger then return end

	self.BoneMods.triggerData = trigger:GetSyncData()
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end