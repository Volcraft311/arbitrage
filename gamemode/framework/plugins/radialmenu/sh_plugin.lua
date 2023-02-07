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
RadialMenu = PLUGIN

PLUGIN.name = "RadialMenu"

function PLUGIN:ReturnTracePlayer(client)
    client = client or LocalPlayer()

    local data = {}
    data.start = client:GetShootPos()
    data.endpos = data.start + client:GetAimVector() * 84
    data.filter = {client}

    local trace = util.TraceLine(data)
    local entity = trace.Entity

    if IsValid(entity) and entity:IsPlayer() then
        return entity
    end
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")