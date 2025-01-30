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

function PLUGIN:Think()
    for value in pairs(SETTINGS:GetStored().binds) do
        self.binds.IsPressedID(value, true)
    end
end

hook("KeyPressID", function(client, id, bIsVisibleGUI)
    netstream.Start("SETTINGS:KeyPressID", id, bIsVisibleGUI)
end)

hook("KeyReleaseID", function(client, id, bIsVisibleGUI)
    netstream.Start("SETTINGS:KeyReleaseID", id, bIsVisibleGUI)
end)

-- hook("KeyClampID", function(client, id)
    -- print(tostring(client) .. " зажал " .. id)
-- end)