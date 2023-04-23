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
    Arbitrage.statistics.list = Arbitrage.statistics.list or {}

    Arbitrage.statistics.list[name] = data
end

function Arbitrage.statistics.Remove(name)
    Arbitrage.statistics.list = Arbitrage.statistics.list or {}

    Arbitrage.statistics.list[name] = nil
end

function Arbitrage.statistics.Get(client, data)
    if Arbitrage.statistics.list[string.lower(data)] then
        return client[string.lower(data)] and client[string.lower(data)] or client:GetNetVar(string.lower(data))
    else
        Arbitrage.util.WriteMessage(Color(255, 132, 0), "STATISTICS — ", Color(255, 0, 0), "No query was found '" .. data .. "'")
    end
end