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


local PLUGIN = PLUGIN

--[[
    METHODS
]]--
function PLUGIN:Install(id)
    asterionlib.workshop:Add(id)
end


--[[
    NETSTREAMS
]]--
netstream.Hook("Workshop:List", function(data)
    for k, v in ipairs(data) do
        PLUGIN:Install(v)
    end
end)

netstream.Hook("Workshop:Install", function(id)
    PLUGIN:Install(id)
end)