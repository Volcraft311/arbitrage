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

include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

function ENT:Initialize()
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	local phys = self:GetPhysicsObject()

	if (IsValid(phys)) then
		phys:Sleep()
		phys:Wake()
	end
end

function ENT:SetType(data)
	if !data then return end

	self.type = data
end

function ENT:GetType()
	return self.type
end

function ENT:SetClassARB(data)
	if !data then return end

	self.classarb = data
end

function ENT:GetClassARB()
	return self.classarb
end

function ENT:SetBloody(data)
	if !data then return end

	self.bloody = data
end

function ENT:GetBloody()
	return self.bloody
end

function ENT:OnRemove()

end

function ENT:Use(client, caller)
	if !Arbitrage.library.Get("weapon") then return end
	if !client:Alive() then return end

	if !client.dropCD or CurTime() >= client.dropCD then
		for k, v in pairs(client:GetWeapons()) do
			local class = v:GetClass()

			if class == self:GetClassARB() then
				netstream.Start(client, "arb.Notify", "Вы не можете подобрать данное оружие!", true)
				client.dropCD = CurTime() + 2
				return
			end
		end

		local _type = Arbitrage.weapon.views[self:GetClassARB()]

		client.weapons = client.weapons or {}
		if client.weapons[_type] then
			netstream.Start(client, "arb.Notify", "Вы не можете подобрать данное оружие!", true)
			client.dropCD = CurTime() + 2
			return
		end

		local class = self:GetClassARB()
		local bloody = self:GetBloody()

		client.weapons[_type] = {true, bloody}
		self:Remove()

		client:Give(class, true)
		netstream.Start(nil, "arb.PlayerSetAnim", client, GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_ITEM_PLACE, true)

		timer.Simple(0.1, function()
			client:SelectWeapon(class)
		end)

		client.dropCD = CurTime() + 2
	end
end