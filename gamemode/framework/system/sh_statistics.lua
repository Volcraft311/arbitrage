--[[
		© Asterion Project 2021.
		https://asterion.project.ru/

		Chop your own wood and it will warm you twice.
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
    if !IsValid(client) then return end

    if Arbitrage.statistics.list[string.lower(data)] then
        return client[string.lower(data)] and client[string.lower(data)] or client:GetNetVar(string.lower(data))
    else
        Arbitrage.util.WriteMessage(Color(255, 132, 0), "STATISTICS — ", Color(255, 0, 0), "No query was found \"" .. data .. "\"")
    end
end