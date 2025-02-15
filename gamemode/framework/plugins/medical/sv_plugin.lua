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

		return ("#status_effects_clear_effects '%s'!"):format(self:FullName())
	end

	function playerMeta:AddTemporaryStatusEffect(uniqueID, delay)
		local info = Medical.t_status_effects[uniqueID]
		if !info then return "#status_effects_not_found" end

		local disable = GetNetVar("medical:statuseffects_disable", {})
		if disable[uniqueID] then return "#status_effects_effect_disable" end

		local _delay = delay
		delay = delay > 0 and CurTime() + delay or delay
		local data = self:GetNetVar("t_status_effects", {})

		local oldDelay = data[uniqueID]
		if oldDelay then
			if oldDelay <= 0 then return "#old_time_endless" end
			if delay > 0 and oldDelay >= delay then return "#old_time_longer_than_time" end
		end

		local onCanAdd = info.onCanAdd
		if onCanAdd then
			local allow, message = onCanAdd(self, _delay)

			if allow == false then
				return message or "#status_effects_unable"
			end
		end

		return self:SetTemporaryStatusEffect(uniqueID, _delay)
	end

	function playerMeta:SetTemporaryStatusEffect(uniqueID, delay)
		local info = Medical.t_status_effects[uniqueID]
		if !info then return "#status_effects_not_found" end

		local disable = GetNetVar("medical:statuseffects_disable", {})
		if disable[uniqueID] then return "#status_effects_effect_disable" end

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

		return ("#status_effects_set_effects '%s' #status '%s' %s!"):format(self:FullName(), info.name, delay <= 0 and "#forever" or "#on " .. _delay .. " #seconds")
	end

	function playerMeta:RemoveTemporaryStatusEffect(uniqueID)
		local info = Medical.t_status_effects[uniqueID]
		if !info then return "#status_effects_not_found" end

		local data = self:GetNetVar("t_status_effects", {})
		if !data[uniqueID] then return "#status_effects_doesnt_have" end

		local index = self:EntIndex()
		info.stored[index] = nil

		data[uniqueID] = nil
		self:SetNetVar("t_status_effects", data)
		netstream.Start(self, "Medical:RemoveTemporaryStatusEffect", uniqueID)

		local onRemove = info.onRemove
		if onRemove then
			onRemove(self)
		end

		return ("#status_effects_remove_effect '%s' #status '%s'!"):format(self:FullName(), info.name)
	end
end