--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru (not work)
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


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