--[[
        © AsterionStaff 2025.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local PLUGIN = PLUGIN

DevMode = PLUGIN
DevMode.name = "Dev"

Arbitrage.base.Include("cl_plugin.lua")

function DevMode:IsDev()
    return Arbitrage.IsDeveloper 
end

if SERVER then
    hook.Add("PlayerInitialSpawnForRealz", "DevMode:Check", function(client)
        if (DevMode:IsDev()) then
            client:SetNetVar("moderation_dynamicusergroup", "guard")
            client:Give("weapon_physgun")
            client:Give("gmod_tool")
        end
    end)
else 
    hook.Add("InitPostEntity", "DevMode:Check", function()
        timer.Simple(1, function()
            if (DevMode:IsDev()) then
                Arbitrage.menu:Remove()
            end
        end)
    end)

    hook.Add("asterionlib.workshop:OnDownload", "DevMode:DisableWorshop",function(id)
        return !DevMode:IsDev()
    end)
end