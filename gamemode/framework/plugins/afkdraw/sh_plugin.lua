local PLUGIN = PLUGIN
PLUGIN.name = "Afk Draw"

local meta = FindMetaTable("Player")

function meta:IsAFK()
	return self:GetNetVar("afk", false)
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")