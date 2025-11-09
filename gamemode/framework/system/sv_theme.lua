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


Arbitrage.theme = Arbitrage.library.Add("theme")
Arbitrage.theme.custom = Arbitrage.theme.custom or {}


hook("PlayerInitialSpawnForRealz", function(client)
    for theme_id, data in pairs(Arbitrage.theme.custom) do
        netstream.Start(client, "Theme:LoadParamsTheme", theme_id, data)
    end
end)


netstream.Hook("Theme:EditParamTheme", function(client, theme_id, key, value)
    local theme = Arbitrage.theme:Get(theme_id)
    if !theme then return end

    local onCanEdit = theme.onCanEdit
    if onCanEdit then
        local bAllow = onCanEdit(theme, client)

        if !bAllow then
            return
        end
    end

    local onEdit = theme.onEdit
    if onEdit then
        onEdit(theme, key, value)
    end
end)