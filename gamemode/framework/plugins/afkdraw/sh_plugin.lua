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
PLUGIN.name = "Afk Draw"

local PLAYER = FindMetaTable("Player")

function PLAYER:IsAFK()
	return self:GetNetVar("afk", false)
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")