local PLUGIN = PLUGIN

PLUGIN.chat = PLUGIN.chat or {}
PLUGIN.gui = PLUGIN.gui or {}

PLUGIN.typesData = {
    "me",
    "try",
    "it",
    "roll",
    "looc",
    "ooc"
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