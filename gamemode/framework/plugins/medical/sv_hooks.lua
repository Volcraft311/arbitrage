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


function Medical:ScalePlayerDamage(client, hitgroup, dmginfo)
	if !client:IsPlayer() then return end

	if hitgroup == HITGROUP_HEAD then
		client:AddTemporaryStatusEffect("stun", 10)
		client:AddTemporaryStatusEffect("pain", 30)
		client:AddTemporaryStatusEffect("blackout", 25)

		client:ScreenFade(SCREENFADE.IN, Color(255, 0, 0, 255), 2, 0)
		client:ViewPunch(Angle(3.7 * 3, -3.5 * 3, 3.3 * 3))
	elseif hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
		client:AddTemporaryStatusEffect("broken_leg", 20)
		client:AddTemporaryStatusEffect("pain", 2)
	else
		client:AddTemporaryStatusEffect("pain", 5)
	end

	local t_status_effects = client:GetTemporaryStatusEffects()
	for _, array in ipairs(t_status_effects) do
		local uniqueID = array.uniqueID
		local info = Medical.t_status_effects[uniqueID]

		local _hook = info.hooks.ScalePlayerDamage
		if !_hook then continue end

		local bSucc = _hook(client, hitgroup, dmginfo)
		-- уведомление
		if bSucc == true then
			netstream.Start(client, "Medical:AddTemporaryStatusEffect", uniqueID, 15)
		end

		-- все действия происходят в самом хуке, не требует возвращения
	end
end

function Medical:EntityTakeDamage(client, dmginfo)
	if !client:IsPlayer() then return end

	if dmginfo:IsFallDamage() then
		client:AddTemporaryStatusEffect("broken_leg", 20)
	end

	client:ScreenFade(SCREENFADE.IN, Color(255, 0, 0, 128 * 0.75), 0.5, 0)

	local amount = dmginfo:GetDamage()
	client:ViewPunch(Angle(math.random(-amount, amount), math.random(-amount, amount), math.random(-amount, amount)))
end

hook("OnCommandTry", function(client, rand)
	local t_status_effects = client:GetTemporaryStatusEffects()
	for _, array in ipairs(t_status_effects) do
		local uniqueID = array.uniqueID
		local info = Medical.t_status_effects[uniqueID]

		local _hook = info.hooks.OnCommandTry
		if !_hook then continue end

		local bSucc, newRand = _hook(client, rand)
		-- уведомление
		if bSucc == true then
			netstream.Start(client, "Medical:AddTemporaryStatusEffect", uniqueID, 15)
		end

		-- обработчик
		if bSucc != nil then
			return bSucc, newRand
		end
	end
end)

hook("OnCommandRoll", function(client, rand, maxRand)
	local t_status_effects = client:GetTemporaryStatusEffects()
	for _, array in ipairs(t_status_effects) do
		local uniqueID = array.uniqueID
		local info = Medical.t_status_effects[uniqueID]

		local _hook = info.hooks.OnCommandRoll
		if !_hook then continue end

		local bSucc, newRand = _hook(client, rand, maxRand)
		-- уведомление
		if bSucc == true then
			netstream.Start(client, "Medical:AddTemporaryStatusEffect", uniqueID, 15)
		end

		-- обработчик
		if bSucc != nil then
			return bSucc, newRand
		end
	end
end)

function Medical:PlayerInitialSpawn(client)
	local handlerID = "Medical:Handler_" .. client:EntIndex()
	timer.Create(handlerID, 1, 0, function()
	    if !IsValid(client) then return timer.Remove(handlerID) end

	    local t_status_effects = client:GetTemporaryStatusEffects()
	    for _, array in ipairs(t_status_effects) do
	    	local uniqueID = array.uniqueID
	    	local info = self.t_status_effects[uniqueID]

	    	local handler = info.handler
	    	if !handler then continue end

	    	local stored = self:TemporaryStatusEffectsStored(client, uniqueID)
	    	local values = self:TemporaryStatusEffectsValues(uniqueID)

	    	handler(client, stored, values)
	    end

	    hook.Run("OnMedicalHandler", client)
	end)
end

hook("OnMedicalHandler", function(client)
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
end)


netstream.Hook("Medical:DisableStatusEffect", function(client, uniqueID, bStatus)
	if !client:IsAdmin() then return end

	local info = Medical.t_status_effects[uniqueID]
	if !info then return end

	local disable = GetNetVar("medical:statuseffects_disable", {})
	disable[uniqueID] = bStatus == false and true or nil

	SetNetVar("medical:statuseffects_disable", disable)
end)

netstream.Hook("Medical:EditStatusEffect", function(client, uniqueID, id, value)
	if !client:IsAdmin() then return end

	local info = Medical.t_status_effects[uniqueID]
	if !info then return end

	local edits = GetNetVar("medical:statuseffects_edits", {})
	edits[uniqueID] = edits[uniqueID] or {}
	edits[uniqueID][id] = value

	SetNetVar("medical:statuseffects_edits", edits)
end)