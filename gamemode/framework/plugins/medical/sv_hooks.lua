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


function Medical:ScalePlayerDamage(target, hitgroup, dmginfo)
	if !target:IsPlayer() then return end

	if hitgroup == HITGROUP_HEAD then
		target:AddTemporaryStatusEffect("stun", 10)
		target:AddTemporaryStatusEffect("pain", 20)

		target:ViewPunch(Angle(3.7, -3.5, 3.3))
	elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
		target:AddTemporaryStatusEffect("broken_leg", 20)
		target:AddTemporaryStatusEffect("pain", 2)
	else
		target:AddTemporaryStatusEffect("pain", 5)
	end
end

function Medical:EntityTakeDamage(client, dmginfo)
	if dmginfo:IsFallDamage() then
		client:AddTemporaryStatusEffect("broken_leg", 20)
	end
end

function Medical:OnMedicalHandler(client)
	if client:Health() <= 10 then
		if !client.healthHandler then
			client:AddTemporaryStatusEffect("stun", 0)
			client.healthHandler = true
		end
	else
		if client.healthHandler then
			client:RemoveTemporaryStatusEffect("stun")
			client.healthHandler = nil
		end
	end

	local sleep = Arbitrage.statistics.Get(client, "Sleep") or 100
	if sleep <= 40 then
		if !client.exhaustionHandler then
			client:AddTemporaryStatusEffect("exhaustion", 0)
			client.exhaustionHandler = true
		end
	else
		if client.exhaustionHandler then
			client:RemoveTemporaryStatusEffect("exhaustion")
			client.exhaustionHandler = nil
		end
	end

	if sleep <= 10 then
		if !client.severeexhaustionHandler then
			client:AddTemporaryStatusEffect("severe_exhaustion", 0)
			client.severeexhaustionHandler = true
		end
	else
		if client.severeexhaustionHandler then
			client:RemoveTemporaryStatusEffect("severe_exhaustion")
			client.severeexhaustionHandler = nil
		end
	end

	local thirst = Arbitrage.statistics.Get(client, "Thirst") or 100
	if thirst <= 15 then
		if !client.dehydrationHandler then
			client:AddTemporaryStatusEffect("dehydration", 0)
			client.dehydrationHandler = true
		end
	else
		if client.dehydrationHandler then
			client:RemoveTemporaryStatusEffect("dehydration")
			client.dehydrationHandler = nil
		end
	end
end