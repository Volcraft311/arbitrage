local PLUGIN = PLUGIN

PLUGIN.chat = PLUGIN.chat or {}
PLUGIN.gui = PLUGIN.gui or {}

PLUGIN.typesData = {
    "me",
    "mec",
    "try",
    "tryc",
    "it",
    "itc",
    "roll",
    "looc",
    "ooc",
    "command"
}

function PLUGIN.Bind(self, callback)
    return function(_, ...)
        return callback(self, ...)
    end
end

local meta = FindMetaTable("Player")

function meta:IsTyping()
    return self:GetNWBool("IsTyping")
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")