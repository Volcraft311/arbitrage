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

include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

function ENT:Initialize()
	self:SetModel("models/props_wasteland/kitchen_fridge001a.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetUseType( SIMPLE_USE )
end

function ENT:Use(client, caller)
	for k, v in pairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.5)) do
	    TypingDraw:SetTypingText(v, client, "Обыскивает 'Холодильник'", Color(255, 170, 23))
	end

	client:PlayAnimation(GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_ITEM_PLACE, true)
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