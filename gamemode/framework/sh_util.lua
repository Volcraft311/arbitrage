--[[
        © Asterion Project 2021.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

function Arbitrage.util.StripRealmPrefix(name)
	local prefix = name:sub(1, 3)

	return (prefix == "sh_" or prefix == "sv_" or prefix == "cl_") and name:sub(4) or name
end

function Arbitrage.util.WriteMessage(...)
	local data = {...}

	local a = data[#data]
	if a and isstring(a) then
		data[#data] = a .. "\n"
	end

	hook.Run("WriteMessage", ...)
	MsgC(Color(0, 255, 0), "[GM-ARBITRAGE] ", Color(255, 255, 255), unpack(data))
end

function Arbitrage.util.GetSide()
	return CLIENT and "cl" or "sv"
end

function Arbitrage.util.IsClientSide()
	return Arbitrage.util.GetSide() == "cl"
end

function Arbitrage.util.IsServerSide()
	return Arbitrage.util.GetSide() == "sv"
end