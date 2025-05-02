DevMode = PLUGIN


function DevMode:IsDev()
    return GetConVar("developer"):GetInt() > 0
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