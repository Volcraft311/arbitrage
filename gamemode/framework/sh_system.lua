--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

Arbitrage.library = {}
Arbitrage.library.LibraryLoaded = {}

function Arbitrage.library.Add(data)
	if !Arbitrage.library.LibraryLoaded[data] then
		Arbitrage.util.WriteMessage(Color(255, 132, 0), "{" .. string.upper(Arbitrage.util.GetSide()) .. "} ", Color(255, 174, 0), "Libraries '" .. data .. "' was created.")
		Arbitrage.library.LibraryLoaded[data] = true
	end

	return Arbitrage[data] or {}
end

function Arbitrage.library.Get(data)
	return Arbitrage[data]
end