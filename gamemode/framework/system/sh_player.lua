--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru (not work)
            Discord - https://discord.gg/Np5evb5ZsR
        
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