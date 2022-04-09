local PLUGIN = PLUGIN

PLUGIN.name = "Finding Body"
PLUGIN.turnoff_time = 7

function PLUGIN:AllowDetectCorpse(client)
    if client:IsNocliping() then return false end
    if !client:Alive() then return false end
    if client:IsMonoKum() then return false end

    return true
end

function PLUGIN:AllowLogFindCorpse(client)
    if !client:IsAdmin() then return false end
    if !client:IsMonoKum() and client:IsPlaying() then return false end

    return true
end

local meta = FindMetaTable("Entity")

function meta:IsCorpse()
    return self:GetNetVar("iscorpse", false)
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")