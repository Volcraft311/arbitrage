local PLUGIN = PLUGIN
Stamina = PLUGIN

PLUGIN.name = "Stamina"

function Stamina:GetStamina(client)
	return client:GetLocalVar("stamina", 100)
end

function Stamina:StartCommand(client, ucmd)
	if !client:IsPlaying() or client:IsNocliping() then return end

	local stamina = self:GetStamina(client)

	local jump = ucmd:KeyDown(IN_JUMP)
	local speed = ucmd:KeyDown(IN_SPEED)

	if jump and stamina <= 5 then
		if SERVER and stamina <= 1 then
			self:SetStaminaCD(client, 10)
		end

		ucmd:RemoveKey(IN_JUMP)
	end

	local sleep = Arbitrage.statistics.Get(client, "Sleep") or 100
	if speed and sleep <= 10 then
		ucmd:RemoveKey(IN_SPEED)
	end
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")