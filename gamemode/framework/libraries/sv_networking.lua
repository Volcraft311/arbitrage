-- @module Arbitrage.net

local entityMeta = FindMetaTable("Entity")
local playerMeta = FindMetaTable("Player")

Arbitrage.net = Arbitrage.net or {}
Arbitrage.net.list = Arbitrage.net.list or {}
Arbitrage.net.locals = Arbitrage.net.locals or {}
Arbitrage.net.globals = Arbitrage.net.globals or {}

util.AddNetworkString("ArbitrageGlobalVarSet")
util.AddNetworkString("ArbitrageLocalVarSet")
util.AddNetworkString("ArbitrageNetVarSet")
util.AddNetworkString("ArbitrageNetVarDelete")

-- Check if there is an attempt to send a function. Can't send those.
local function CheckBadType(name, object)
	if (isfunction(object)) then
		ErrorNoHalt("Net var '" .. name .. "' contains a bad object type!")

		return true
	elseif (istable(object)) then
		for k, v in pairs(object) do
			-- Check both the key and the value for tables, and has recursion.
			if (CheckBadType(name, k) or CheckBadType(name, v)) then
				return true
			end
		end
	end
end

function GetNetVar(key, default) -- luacheck: globals GetNetVar
	local value = Arbitrage.net.globals[key]

	return value != nil and value or default
end

function SetNetVar(key, value, receiver) -- luacheck: globals SetNetVar
	if (CheckBadType(key, value)) then return end
	if (GetNetVar(key) == value) then return end

	Arbitrage.net.globals[key] = value

	net.Start("ArbitrageGlobalVarSet")
	net.WriteString(key)
	net.WriteType(value)

	if (receiver == nil) then
		net.Broadcast()
	else
		net.Send(receiver)
	end
end

--- Player networked variable functions
-- @classmod Player

--- Synchronizes networked variables to the client.
-- @realm server
-- @internal
function playerMeta:SyncVars()
	for k, v in pairs(Arbitrage.net.globals) do
		net.Start("ArbitrageGlobalVarSet")
			net.WriteString(k)
			net.WriteType(v)
		net.Send(self)
	end

	for k, v in pairs(Arbitrage.net.locals[self] or {}) do
		net.Start("ArbitrageLocalVarSet")
			net.WriteString(k)
			net.WriteType(v)
		net.Send(self)
	end

	for entity, data in pairs(Arbitrage.net.list) do
		if (IsValid(entity)) then
			local index = entity:EntIndex()

			for k, v in pairs(data) do
				net.Start("ArbitrageNetVarSet")
					net.WriteUInt(index, 16)
					net.WriteString(k)
					net.WriteType(v)
				net.Send(self)
			end
		end
	end
end

--- Retrieves a local networked variable. If it is not set, it'll return the default that you've specified.
-- Locally networked variables can only be retrieved from the owning player when used from the client.
-- @realm shared
-- @string key Identifier of the local variable
-- @param default Default value to return if the local variable is not set
-- @return Value associated with the key, or the default that was given if it doesn't exist
-- @usage print(client:GetLocalVar("secret"))
-- > 12345678
-- @see SetLocalVar
function playerMeta:GetLocalVar(key, default)
	if (Arbitrage.net.locals[self] and Arbitrage.net.locals[self][key] != nil) then
		return Arbitrage.net.locals[self][key]
	end

	return default
end

--- Sets the value of a local networked variable.
-- @realm server
-- @string key Identifier of the local variable
-- @param value New value to assign to the local variable
-- @usage client:SetLocalVar("secret", 12345678)
-- @see GetLocalVar
function playerMeta:SetLocalVar(key, value)
	if (CheckBadType(key, value)) then return end

	Arbitrage.net.locals[self] = Arbitrage.net.locals[self] or {}
	Arbitrage.net.locals[self][key] = value

	net.Start("ArbitrageLocalVarSet")
		net.WriteString(key)
		net.WriteType(value)
	net.Send(self)
end

--- Entity networked variable functions
-- @classmod Entity

--- Retrieves a networked variable. If it is not set, it'll return the default that you've specified.
-- @realm shared
-- @string key Identifier of the networked variable
-- @param default Default value to return if the networked variable is not set
-- @return Value associated with the key, or the default that was given if it doesn't exist
-- @usage print(client:GetNetVar("example"))
-- > Hello World!
-- @see SetNetVar
function entityMeta:GetNetVar(key, default)
	if (Arbitrage.net.list[self] and Arbitrage.net.list[self][key] != nil) then
		return Arbitrage.net.list[self][key]
	end

	return default
end

--- Sets the value of a networked variable.
-- @realm server
-- @string key Identifier of the networked variable
-- @param value New value to assign to the networked variable
-- @tab[opt=nil] receiver The players to send the networked variable to
-- @usage client:SetNetVar("example", "Hello World!")
-- @see GetNetVar
function entityMeta:SetNetVar(key, value, receiver)
	if (CheckBadType(key, value)) then return end

	Arbitrage.net.list[self] = Arbitrage.net.list[self] or {}

	if (Arbitrage.net.list[self][key] != value) then
		Arbitrage.net.list[self][key] = value
	end

	self:SendNetVar(key, receiver)
end

--- Sends a networked variable.
-- @realm server
-- @internal
-- @string key Identifier of the networked variable
-- @tab[opt=nil] receiver The players to send the networked variable to
function entityMeta:SendNetVar(key, receiver)
	net.Start("ArbitrageNetVarSet")
	net.WriteUInt(self:EntIndex(), 16)
	net.WriteString(key)
	net.WriteType(Arbitrage.net.list[self] and Arbitrage.net.list[self][key])

	if (receiver == nil) then
		net.Broadcast()
	else
		net.Send(receiver)
	end
end

--- Clears all of the networked variables.
-- @realm server
-- @internal
-- @tab[opt=nil] receiver The players to clear the networked variable for
function entityMeta:ClearNetVars(receiver)
	Arbitrage.net.list[self] = nil
	Arbitrage.net.locals[self] = nil

	net.Start("ArbitrageNetVarDelete")
	net.WriteUInt(self:EntIndex(), 16)

	if (receiver == nil) then
		net.Broadcast()
	else
		net.Send(receiver)
	end
end
