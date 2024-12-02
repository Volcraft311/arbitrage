
local PLUGIN = PLUGIN

PLUGIN.name = "Trigger"
Trigger = PLUGIN

Trigger.meta = Trigger.meta or {}


Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")

Arbitrage.base.Include("meta/sh_meta_trigger.lua")

Arbitrage.base.Include("sh_trigger.lua")
Arbitrage.base.Include("cl_trigger.lua")

