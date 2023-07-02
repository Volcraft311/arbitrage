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

	if speed and client:HasTemporaryStatusEffect("severe_exhaustion") then
		ucmd:RemoveKey(IN_SPEED)
	end
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")