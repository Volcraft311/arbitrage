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

Arbitrage.evidence = Arbitrage.library.Add("evidence")
Arbitrage.evidence.array = Arbitrage.evidence.array or {}
Arbitrage.evidence.repository = Arbitrage.evidence.repository or {}
Arbitrage.evidence.entities = Arbitrage.evidence.entities or {}

function Arbitrage.evidence.AddEnt(name, data)
    if !name then return end
    if !data then return end

    Arbitrage.evidence.entities[name] = data
end