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

include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

function ENT:Initialize()
	self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:DrawShadow(false)
	self:SetUseType(SIMPLE_USE)
	self:SetNoDraw(true)

	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
end

-- function ENT:Use(client, caller)
-- 	local data = self.id

-- 	if data and !client.evidenceCD or CurTime() >= client.evidenceCD then
-- 		local evidence = Arbitrage.evidence.repository[data]
-- 		if !evidence then return end

-- 		client.evidence = client.evidence or {}
-- 		evidence.num = data

-- 		client.evidenceCD = CurTime() + 2
-- 		if client.evidence[evidence.num] then netstream.Start(client, "arb.Notify", "Вы уже нашли эту улику!", true) return end

-- 		Arbitrage.action.ActionRun(client, "Собираем улику", 1, function()
-- 			if client:GetEyeTrace().Entity != self then return true end
-- 			if client:GetPos():Distance(self:GetPos()) >= 80 then return true end

-- 			return false
-- 		end, function(activator)
-- 			netstream.Start(client, "arb.Notify", "Ваш журнал улик обновлён.", false)

-- 			Arbitrage.player.AddEvidence(client, {
-- 				[1] = evidence
-- 			})
-- 		end)
-- 	end
-- end

-- function ENT:OnRemove()
-- 	local data = self.id

-- 	if data then
-- 		local evidence = Arbitrage.evidence.repository[data]
-- 		if !evidence then return end

-- 		for k, v in pairs(player.GetAll()) do
-- 			v.evidence = v.evidence or {}
-- 			v.evidence[evidence.num] = nil

-- 			if Arbitrage.evidence.repository[data] then
-- 				Arbitrage.evidence.repository[data] = nil
-- 			end

-- 			Arbitrage.evidence.SendInfo(v)
-- 			v:SetNetVar("evidence", v.evidence, v)
-- 		end
-- 	end
-- end