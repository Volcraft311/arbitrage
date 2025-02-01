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
ScriptMusic = PLUGIN

PLUGIN.name = "ScriptMusic"

PLUGIN.events = PLUGIN.events or {}
PLUGIN.sound = PLUGIN.sound or nil -- наш глобальный звук будет тут
PLUGIN.volume = 100

function PLUGIN:AddEvent(event, name)
    self.events[event] = name
end

function PLUGIN:GetEvents()
    return self.events
end

function PLUGIN:GetNormalTime(time)
    local thisTime = time

    local minutes = math.floor(math.fmod(thisTime, 3600) / 60)
    local seconds = math.floor(math.fmod(thisTime, 60))

    local _m = ("%d"):format(minutes)
    local _s = ("%d"):format(seconds)

    if tonumber(_m) < 10 then _m = _m end
    if tonumber(_s) < 10 then _s = "0" .. _s end

    local timeString = Format("%s:%s", _m, _s)
    if thisTime <= 0 then timeString = "00:00" end

    return timeString
end

function PLUGIN:GetTheme()
    return GetNetVar("arb.theme", "none")
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sh_config.lua")
Arbitrage.base.Include("sv_plugin.lua")