local PLUGIN = PLUGIN
RagdollSystem = PLUGIN

local meta = FindMetaTable("Player")

function meta:IsRagdolling()
    local entity = self:GetRagdoll()
    if entity == nil then return false end

    return IsValid(entity)
end

function meta:GetRagdoll()
    local idx = self:GetNetVar("ragdoll")
    if idx == nil then return end

    local entity = Entity(idx)
    if !IsValid(entity) then return end

    return entity
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_hooks.lua")
Arbitrage.base.Include("sv_plugin.lua")