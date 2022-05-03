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

Arbitrage.chat = Arbitrage.library.Add("chat")

netstream.Hook("arb.chatCommandCreate", function(client, name, data)
    if !data then return end

    if Arbitrage.chat.List[name] and Arbitrage.chat.List[name].UseIcon then
        local mat = Arbitrage.chat:GetIcon(client)

        if mat then
            table.insert(data, 1, mat)
        end
    end

    chat.AddText(unpack(data))
end)