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

function PLUGIN:Set(key, value)
    local data = self:Get()
    if data[key] == nil then return end

    data[key] = value

    SetNetVar("colormodify", data)
end

netstream.Hook("ColorModify:Set", function(client, key, value)
    if !client:IsAdmin() then return end

    PLUGIN:Set(key, value)
    Arbitrage.adminnotify:SendNotify("changecolormodify", client:FullName(), key, tostring(value))
end)

netstream.Hook("ColorModify:AddPlayer", function(client, steamid)
    if !client:IsAdmin() then return end

    local data = PLUGIN:Get()
    if data.playersList[steamid] then
        data.playersList[steamid] = nil
    else
        data.playersList[steamid] = true
    end

    SetNetVar("colormodify", data)
end)

netstream.Hook("ColorModify:LoadConfig", function(client, array)
    local data = PLUGIN:Get()

    for k, v in pairs(array) do
        data[k] = v
    end

    SetNetVar("colormodify", data)
end)

netstream.Hook("ColorModify:Standart", function(client)
    if !client:IsAdmin() then return end

    SetNetVar("colormodify", PLUGIN:Default())
    Arbitrage.adminnotify:SendNotify("standartcolormodify", client:FullName())
end)