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

function Medical:OnCommandTry(client, rand)
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
end

function Medical:OnCommandRoll(client, rand, maxRand)
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
end

function Medical:ScalePlayerDamage(client, hitgroup, dmginfo)
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


do
	local playerMeta = FindMetaTable("Player")

	function playerMeta:ClearTemporaryStatusEffects()
		local t_status_effects = self:GetTemporaryStatusEffects()
		for _, array in ipairs(t_status_effects) do
			local uniqueID = array.uniqueID
			local info = Medical.t_status_effects[uniqueID]

			local onRemove = info.onRemove
			if onRemove then
				onRemove(self)
			end
		end

		self:SetNetVar("t_status_effects", {})

		return ("Вы успешно удалили все статус эффекты с игрока '%s'!"):format(self:FullName())
	end

	function playerMeta:AddTemporaryStatusEffect(uniqueID, delay)
		local info = Medical.t_status_effects[uniqueID]
		if !info then return "Неизвестный статус эффект" end

		local disable = GetNetVar("medical:statuseffects_disable", {})
		if disable[uniqueID] then return "Данный эффект отключен" end

		local _delay = delay
		delay = delay > 0 and CurTime() + delay or delay
		local data = self:GetNetVar("t_status_effects", {})

		local oldDelay = data[uniqueID]
		if oldDelay then
			if oldDelay <= 0 then return "Старое время бесконечное" end
			if delay > 0 and oldDelay >= delay then return "Старое время больше установленного" end
		end

		local onCanAdd = info.onCanAdd
		if onCanAdd then
			local allow, message = onCanAdd(self, _delay)

			if allow == false then
				return message or "Невозможно выдать данный статус эффект"
			end
		end

		return self:SetTemporaryStatusEffect(uniqueID, _delay)
	end

	function playerMeta:SetTemporaryStatusEffect(uniqueID, delay)
		local info = Medical.t_status_effects[uniqueID]
		if !info then return "Неизвестный статус эффект" end

		local disable = GetNetVar("medical:statuseffects_disable", {})
		if disable[uniqueID] then return "Данный эффект отключен" end

		local _delay = delay
		delay = delay > 0 and CurTime() + delay or delay

		local data = self:GetNetVar("t_status_effects", {})
		local index = self:EntIndex()
		info.stored[index] = {}

		data[uniqueID] = delay
		self:SetNetVar("t_status_effects", data)
		netstream.Start(self, "Medical:AddTemporaryStatusEffect", uniqueID, delay)

		local onAdd = info.onAdd
		if onAdd then
			onAdd(self, delay)
		end

		return ("Вы успешно установили игроку '%s' статус '%s' %s!"):format(self:FullName(), info.name, delay <= 0 and "навсегда" or "на " .. _delay .. " секунд")
	end

	function playerMeta:RemoveTemporaryStatusEffect(uniqueID)
		local info = Medical.t_status_effects[uniqueID]
		if !info then return "Неизвестный статус эффект" end

		local data = self:GetNetVar("t_status_effects", {})
		if !data[uniqueID] then return "Игрок не имеет данный эффект" end

		local index = self:EntIndex()
		info.stored[index] = nil

		data[uniqueID] = nil
		self:SetNetVar("t_status_effects", data)
		netstream.Start(self, "Medical:RemoveTemporaryStatusEffect", uniqueID)

		local onRemove = info.onRemove
		if onRemove then
			onRemove(self)
		end

		return ("Вы успешно удалили игроку '%s' статус '%s'!"):format(self:FullName(), info.name)
	end
end