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

Arbitrage.statistics = Arbitrage.library.Add("statistics")

function Arbitrage.statistics.Add(name, data)
    name = name:lower()

    Arbitrage.statistics.list = Arbitrage.statistics.list or {}

    Arbitrage.statistics.list[name] = data
end

function Arbitrage.statistics.Remove(name)
    name = name:lower()

    Arbitrage.statistics.list = Arbitrage.statistics.list or {}

    Arbitrage.statistics.list[name] = nil
end

function Arbitrage.statistics.Get(client, name)
    name = name:lower()

    if Arbitrage.statistics.list[name] then
        return client[name] and client[name] or client:GetNetVar(name)
    else
        Arbitrage.util.WriteMessage(Color(255, 132, 0), "STATISTICS — ", Color(255, 0, 0), "No query was found '" .. name .. "'")
    end
end