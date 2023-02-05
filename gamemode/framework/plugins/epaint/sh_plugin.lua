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
Arbitrage.base.Include("sv_plugin.lua")