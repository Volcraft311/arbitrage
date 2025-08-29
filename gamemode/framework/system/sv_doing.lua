--[[
        © AsterionStaff 2025.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


Arbitrage.doing = Arbitrage.library.Add("doing")

function Arbitrage.doing.Send(client, data)
    client._doingEntity = data.entity
    client._doingActions = table.Copy(data.actions)

    for name, action in pairs(data.actions) do
        action.func = nil
    end

    netstream.Start(client, "Doing:Send", data)
end

netstream.Hook("Doing:Action", function(client, name)
    local action = client._doingActions[name]
    if !action then return end

    if action.func then
        action.func(client, client._doingEntity)
    end

    client._doingEntity = nil
    client._doingActions = nil
end)