--[[
        © AsterionStaff 2025.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://asterion.games/chancery
        
        developer(s):
            Volcraft - https://steamcommunity.com/id/boobsgunner
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local PLUGIN = PLUGIN
Trigger = PLUGIN

Trigger.name = "Trigger"
Trigger.prefix = "[Asterion Triggers]"
Trigger.prefixColor = Color(136,255,15)

Trigger.meta = Trigger.meta or {}
Trigger.instances = Trigger.instances or {}
Trigger.lastID = Trigger.lastID or 0

Trigger.InteractDistance = 128
Trigger.Precision = 10

Arbitrage.base.Include("meta/sh_meta_trigger.lua")
Arbitrage.base.Include("cl_trigger.lua")
Arbitrage.base.Include("sh_trigger.lua")
Arbitrage.base.Include("sh_trigger_types.lua")
Arbitrage.base.Include("sv_trigger.lua")