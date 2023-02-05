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

local PLUGIN = PLUGIN

netstream.Hook("SETTINGS:KeyPressID", function(client, id, bIsVisibleGUI)
    hook.Run("KeyPressID", client, id, bIsVisibleGUI)
end)

netstream.Hook("SETTINGS:KeyReleaseID", function(client, id, bIsVisibleGUI)
    hook.Run("KeyReleaseID", client, id, bIsVisibleGUI)
end)