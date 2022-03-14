-- Returns the address:port of the server.
function Arbitrage.GetAddress()
	local address = tonumber(GetConVarString("hostip"))

	if (!address) then
		return "127.0.0.1"..":"..GetConVarString("hostport")
	end

	local ip = {}
		ip[1] = bit.rshift(bit.band(address, 0xFF000000), 24)
		ip[2] = bit.rshift(bit.band(address, 0x00FF0000), 16)
		ip[3] = bit.rshift(bit.band(address, 0x0000FF00), 8)
		ip[4] = bit.band(address, 0x000000FF)
	return table.concat(ip, ".")..":"..GetConVarString("hostport")
end