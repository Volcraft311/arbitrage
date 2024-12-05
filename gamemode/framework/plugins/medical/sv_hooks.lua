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
		target:AddTemporaryStatusEffect("pain", 30)
		target:AddTemporaryStatusEffect("blackout", 25)

		target:ViewPunch(Angle(3.7, -3.5, 3.3))
	elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
		target:AddTemporaryStatusEffect("broken_leg", 20)
		target:AddTemporaryStatusEffect("pain", 2)
	else
		target:AddTemporaryStatusEffect("pain", 5)
	end
end

function Medical:EntityTakeDamage(client, dmginfo)
	if !client:IsPlayer() then return end

	if dmginfo:IsFallDamage() then
		client:AddTemporaryStatusEffect("broken_leg", 20)
	end
end

function Medical:OnMedicalHandler(client)
	-- health effect
	do
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
	end

	-- armor effect
	do
		if client:Armor() > 0 then
			if !client.armorHandler then
				client:AddTemporaryStatusEffect("armor", 0)
				client.armorHandler = true
			end
		else
			if client.armorHandler then
				client:RemoveTemporaryStatusEffect("armor")
				client.armorHandler = nil
			end
		end
	end

	-- hunger effect
	do
		local hunger = Arbitrage.statistics.Get(client, "Hunger") or 100
		if hunger <= 15 then
			if !client.starvationHandler then
				client:AddTemporaryStatusEffect("starvation", 0)
				client.starvationHandler = true
			end
		else
			if client.starvationHandler then
				client:RemoveTemporaryStatusEffect("starvation")
				client.starvationHandler = nil
			end
		end
	end

	-- thirst effect
	do
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

	-- sleep effect
	do
		local sleep = Arbitrage.statistics.Get(client, "Sleep") or 100
		if sleep > 10 and sleep <= 30 then
			if !client.exhaustionHandler then
				client:RemoveTemporaryStatusEffect("severe_exhaustion")
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
	end
end