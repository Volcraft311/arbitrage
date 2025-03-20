--[[
        © AsterionStaff 2023.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local PLUGIN = PLUGIN
EPaint = PLUGIN

EPaint.name = "Entity Paint"

EPaint.Width = 1443
EPaint.Height = 540
EPaint.Distance = 800
EPaint.allowModels = {
	["models/asterion/academy/props/classroom/ast_classroom_board.mdl"] = true
}

function EPaint:AllowEntity(entity)
	return self.allowModels[entity:GetModel()]
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("cl_epaintlist.lua")
Arbitrage.base.Include("sv_plugin.lua")