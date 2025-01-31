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
AdminNotify = PLUGIN

AdminNotify.name = "AdminNotify"
AdminNotify.notifyList = {}
AdminNotify.guiTime = 30

function AdminNotify:AddNewNotify(name, data)
    self.notifyList[name] = data
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sh_config.lua")
Arbitrage.base.Include("sv_plugin.lua")