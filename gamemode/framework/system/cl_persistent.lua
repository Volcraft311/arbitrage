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

Arbitrage.persistent = Arbitrage.library.Add("persistent")


--[[
function Arbitrage.persistent.KeyPress(client, key)
    if key == IN_USE and client:oldAlive() then
        local entity = Arbitrage.persistent.ReturnRagdoll(client)
        if !entity or !IsValid(entity) then return end

        if !entity.info then
            for k2, v2 in pairs(Arbitrage.persistent.ragdolls or {}) do
                if Entity(v2.entity) == entity then
                    entity.info = v2
                end
            end
        end

        local data = Arbitrage.persistent.ReturnRagdollInfo(entity)
        if !data then return end

        client.corpsesList = client.corpsesList or {}
        if !client.corpsesList[data.name] then
            Arbitrage.notify.Add("Информация о теле занесена в ваш журнал!")
            --client:ChatPrint("Информация о теле занесена в ваш журнал!")
        end

        client.corpsesList[data.name] = data
    end
end
]]--

netstream.Hook("arb.GetPersistentCorpses", function(data)
    if !data then return end

    Arbitrage.persistent.ragdolls = data
end)