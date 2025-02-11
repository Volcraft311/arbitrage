local PLUGIN = PLUGIN
ChatBox = PLUGIN

ChatBox.chat = ChatBox.chat or {}
ChatBox.gui = ChatBox.gui or {}

ChatBox.typesData = {
    "me",
    "mec",
    "mel",

    "try",
    "tryc",
    "tryl",

    "it",
    "itc",
    "itl",

    "looc",
    "ooc",
    "roll",
    "command"
}

function ChatBox.Bind(self, callback)
    return function(_, ...)
        return callback(self, ...)
    end
end

local meta = FindMetaTable("Player")

function meta:IsTyping()
    return self:GetNetVar("IsTyping")
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")