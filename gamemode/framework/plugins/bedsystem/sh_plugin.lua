--[[
        © Asterion Project 2021.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local PLUGIN = PLUGIN
PLUGIN.name = "BedSystem"
PLUGIN.author = "a"

PLUGIN.animation = "zombie_slump_idle_01"
PLUGIN.allowBed = {
    ["models/props_downtown/bed_motel01.mdl"] = {
        pos = Vector(0, 0, 25),
        ang = Angle(0, 90, 0),
        eye = {
            pos = function(vec, ang)
                return vec + ang:Right() * -25 + Vector(0, 0, 41) --Vector(vec[1] + ang:Right()[1] * 5, vec[2], vec[3] + 40)
            end,
            ang = Angle(10, 180, 3)
        }
    }
}

function PLUGIN:CalcMainActivity(client, vector)
    if !client:GetNetVar("inbed") then return end

    client.CalcIdeal = ACT_MP_STAND_IDLE
    client.CalcSeqOverride = client:LookupSequence(self.animation)

    return client.CalcIdeal, client.CalcSeqOverride
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sv_plugin.lua")