local PLUGIN = PLUGIN

local meta = FindMetaTable("Entity")

function meta:SetCorpse(bState)
    self:SetNetVar("iscorpse", bState)
end

function PLUGIN:EntityRemoved(entity)
    if entity:IsCorpse() then
        entity:SetCorpse(false)
    end
end

netstream.Hook("fb:ChangeFOV", function(client)
    if Arbitrage.OffCorpseEffect() then return end

    local oldFOV = client:GetFOV()
    client:SetFOV(oldFOV - 15, PLUGIN.turnoff_time * 0.65)

    timer.Simple(PLUGIN.turnoff_time, function()
        if !IsValid(client) then return end

        client:SetFOV(0, 1)
    end)
end)

netstream.Hook("fb:TraceBody", function(client, entity)
    if Arbitrage.OffCorpseEffect() then return end
    if !entity:IsCorpse() then return end

    entity.findClients = entity.findClients or {}
    entity.findClients[client:SteamID()] = true

    for k, v in ipairs(player.GetAll()) do
        if PLUGIN:AllowLogFindCorpse(v) then
            Arbitrage.commands.Notify(v, Format("%s(%s) обнаружил труп! (%s)", client:Name(), client:SteamName(), tostring(entity)))
        end
    end

    local count = table.Count(entity.findClients)
    if count == 3 then
        for k, v in ipairs(player.GetAll()) do
            v:SendLua([[
                sound.PlayFile("sound/discoveryannounce.wav", "", function(station)
                    if IsValid(station) then
                        station:SetVolume(0.5)
                    end
                end)
            ]])
        end
    end
end)