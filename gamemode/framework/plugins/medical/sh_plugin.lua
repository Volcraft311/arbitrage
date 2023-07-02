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
PLUGIN.name = "Medical"

Medical = PLUGIN

Medical.types = {}
Medical.types.number = 1
Medical.types.string = 2
Medical.types.boolean = 3

Medical.t_status_effects = {}
function Medical:TemporaryStatusEffects(uniqueID, data)
	data.stored = {} -- тут храним разные данные нужные для эффекта
	data.hooks = data.hooks or {}

	self.t_status_effects[uniqueID] = data
end

function Medical:TemporaryStatusEffectsStored(client, uniqueID)
	local index = client:EntIndex()
	local info = self.t_status_effects[uniqueID]

	return info.stored[index]
end

function Medical:TemporaryStatusEffectsValues(uniqueID)
	local data = {}
	local info = self.t_status_effects[uniqueID]
	if info.values then
		for k, v in ipairs(info.values) do
			data[k] = v.default
		end

		local edits = GetNetVar("medical:statuseffects_edits", {})
		if edits[uniqueID] then
			for k, v in pairs(edits[uniqueID]) do
				data[k] = v
			end
		end
	end

	return data
end

function Medical:GetRecivers(client)
	local data = player.GetAdmins()
	table.insert(data, client)

	return data
end

function Medical:GetTemporaryStatusEffectsByName(name)
	for uniqueID, info in pairs(self.t_status_effects) do
		if info.name:utf8lower() == name:utf8lower() then
			return uniqueID
		end
	end
end

function Medical:FormatTemporaryDescription(uniqueID, text)
	local values = self:TemporaryStatusEffectsValues(uniqueID)
	text = tostring(text)

	local pattern = "{(%d+)}"
	local result = text:gsub(pattern, function(num)
		return values[tonumber(num)] or "{" .. num .. "}"
	end)

	return result
end

function Medical:StringToTable(str)
	local result = {}

	for word in string.gmatch(str, "[^;]+") do
		table.insert(result, word)
	end

	return result
end

function Medical:StringToObject(str)
	local array = {}

	local explode = string.Explode(";", str)
	for _, v in ipairs(explode) do
		local name, delay = string.match(v, "(.-)=(.-)$")
		delay = tonumber(delay)

		if name and delay then
			array[name] = delay
		end
	end

	return array
end

do
	local playerMeta = FindMetaTable("Player")

	function playerMeta:HasTemporaryStatusEffect(uniqueID)
		local data = self:GetNetVar("t_status_effects", {})

		local oldDelay = data[uniqueID]
		if oldDelay and (oldDelay <= 0 or CurTime() <= oldDelay) then
			return true
		end

		return false
	end

	function playerMeta:GetTemporaryStatusEffects()
		local info = {}
		local curTime = CurTime()

		local data = self:GetNetVar("t_status_effects", {})
		for uniqueID, delay in pairs(data) do
			if delay <= 0 or curTime <= delay then
				info[#info + 1] = {
					uniqueID = uniqueID,
					delay = delay
				}
			else
				if SERVER then
					self:RemoveTemporaryStatusEffect(uniqueID)
				end
			end
		end

		return info
	end

	function playerMeta:GetTemporaryStatusEffectDelay(uniqueID)
		return self:GetNetVar("t_status_effects", {})[uniqueID]
	end
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("cl_hooks.lua")
Arbitrage.base.Include("sh_temporary_effects.lua")
Arbitrage.base.Include("sv_plugin.lua")
Arbitrage.base.Include("sv_hooks.lua")