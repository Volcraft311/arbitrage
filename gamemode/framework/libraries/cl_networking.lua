local entityMeta = FindMetaTable("Entity")
local playerMeta = FindMetaTable("Player")

Arbitrage.net = Arbitrage.net or {}
Arbitrage.net.globals = Arbitrage.net.globals or {}

net.Receive("ArbitrageGlobalVarSet", function()
	Arbitrage.net.globals[net.ReadString()] = net.ReadType()
end)

net.Receive("ArbitrageNetVarSet", function()
	local index = net.ReadUInt(16)

	Arbitrage.net[index] = Arbitrage.net[index] or {}
	Arbitrage.net[index][net.ReadString()] = net.ReadType()
end)

net.Receive("ArbitrageNetVarDelete", function()
	Arbitrage.net[net.ReadUInt(16)] = nil
end)

net.Receive("ArbitrageLocalVarSet", function()
	local key = net.ReadString()
	local var = net.ReadType()

	Arbitrage.net[LocalPlayer():EntIndex()] = Arbitrage.net[LocalPlayer():EntIndex()] or {}
	Arbitrage.net[LocalPlayer():EntIndex()][key] = var

	hook.Run("OnLocalVarSet", key, var)
end)

function GetNetVar(key, default) -- luacheck: globals GetNetVar
	local value = Arbitrage.net.globals[key]

	return value != nil and value or default
end

function entityMeta:GetNetVar(key, default)
	local index = self:EntIndex()

	if (Arbitrage.net[index] and Arbitrage.net[index][key] != nil) then
		return Arbitrage.net[index][key]
	end

	return default
end

playerMeta.GetLocalVar = entityMeta.GetNetVar