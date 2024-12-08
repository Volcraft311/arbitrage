
local PLUGIN = PLUGIN

PLUGIN.name = "Trigger"
Trigger = PLUGIN


Trigger.meta = Trigger.meta or {}


Arbitrage.base.Include("meta/sh_meta_trigger.lua")

Arbitrage.base.Include("sh_trigger.lua")
Arbitrage.base.Include("cl_trigger.lua")

Arbitrage.base.Include("sh_trigger_types.lua")



