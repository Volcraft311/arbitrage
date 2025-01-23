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

function ENT:Initialize()
	self:SetModel("models/props_wasteland/kitchen_fridge001a.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local physObj = self:GetPhysicsObject()

	if IsValid(physObj) then
		physObj:EnableMotion(false)
		physObj:Wake()
	end
end

function ENT:Use(client, caller)
	TypingDraw:SendSphere(0.5, client, "Обыскивает 'Холодильник'", Color(255, 170, 23))

	client:PlayGesture(ACT_GMOD_GESTURE_ITEM_PLACE)

	Arbitrage.action.ActionRun(client, "Берем еду", 10, function()
		if client:GetEyeTrace().Entity != self then return true end
		if client:GetPos():Distance(self:GetPos()) >= 110 then return true end

		return false
	end, function()
		client:AddTemporaryStatusEffect("hunger", 100)
		client:AddTemporaryStatusEffect("hunger_a", 400)

		client:AddTemporaryStatusEffect("thirst", 100)
		client:AddTemporaryStatusEffect("thirst_a", 400)
	end)
end