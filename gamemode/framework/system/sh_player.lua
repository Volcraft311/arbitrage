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

Arbitrage.player = Arbitrage.library.Add("player")

function Arbitrage.player.GetStats(client, data)
    if !IsValid(client) then return end

    return Arbitrage.statistics.Get(client, data)
end

function Arbitrage.player.GetEvidence(client)
    if !IsValid(client) then return end

    client.evidence = client.evidence or {}
    return client.evidence and client.evidence or client:GetNetVar("evidence")
end