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

Arbitrage.chat = Arbitrage.library.Add("chat")

netstream.Hook("arb.chatCommandCreate", function(client, name, data)
    local info = Arbitrage.chat.List[name]
    if info then
        if info.UseAvatar then
            table.insert(data, 1, client:Avatar())
        end

        if info.UseIcon then
            local mat = Arbitrage.chat:GetIcon(client)

            if mat then
                table.insert(data, 1, mat)
            end
        end
    end

    for k, v in ipairs(data) do
        if isstring(v) then
            data[k] = F(v)
        end
    end

    chat.AddText(unpack(data))
end)