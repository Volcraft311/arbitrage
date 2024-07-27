local PLUGIN = PLUGIN
RagdollSystem = PLUGIN

local meta = FindMetaTable("Player")

function meta:IsRagdolling()
    return IsValid(self:GetRagdoll())
end

function meta:GetRagdoll()
    local idx = self:GetNetVar("ragdoll")
    local entity = idx and Entity(idx) or nil

    return (idx and (IsValid(entity) and entity:GetClass() == "prop_ragdoll")) and entity or nil
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_hooks.lua")
Arbitrage.base.Include("sv_plugin.lua")