--[[
        © AsterionStaff 2025.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter
            Volcraft - https://steamcommunity.com/id/boobsgunner

        ——— Chop your own wood and it will warm you twice.
]]--


hook("PlayerInitialSpawnForRealz", function(client)
    if Arbitrage.IsDeveloper then
        client:SetNetVar("moderation_dynamicusergroup", "guard")
        client:Give("weapon_physgun")
        client:Give("gmod_tool")
    end
end)