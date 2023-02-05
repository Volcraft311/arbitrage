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

PLUGIN.name = "Editor"
Editor = PLUGIN

Editor.stored = Editor.stored or {}

function Editor:GetStored()
    return self.stored or {}
end

do
    local meta = FindMetaTable("Player")

    function meta:IsEditing()
        return self.editing or false
    end

    function meta:SetEditing(data)
        self.editing = data

        if SERVER then
            netstream.Start(self, "Editor:SetEditor", data)
        end
    end
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")