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

local meta = FindMetaTable("Entity")

function meta:SetCorpse(bSteamID)
    self:SetNetVar("sCorpseAttacker", bSteamID)
end

function Persistent:EntityRemoved(entity)
    if entity:IsCorpse() then
        entity:SetCorpse(false)
    end
end

function Persistent:CreateRagdoll(client)
    local entity = ents.Create("prop_ragdoll")
    entity:SetPos(client:GetPos())
    entity:SetAngles(client:GetAngles())
    entity:SetModel(client:GetModel())
    entity:SetModelScale(client:GetModelScale())
    entity:Spawn()

    entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    entity:Activate()

    local saver = client:GetSaverInfo()
    entity._saver = saver -- нужно для получения полного экземпляра сейвера в будущем

    entity:LoadSaverInfo(saver)

    return entity
end

function Persistent:ClearCompositeEntities(client)
    client:DrawHide()

    local entities = client.getCompositeEntities and client:getCompositeEntities() or {}
    for _, entity in ipairs(entities) do
        if IsValid(entity) then
            entity:DrawHide()

            entity:Remove()
        end
    end
end

function Persistent:SetPersistent(entity, client, attacker)
    entity:SetNetVar("sIsPersistent", client:SteamID())
    entity.name = client:Name()

    do
        local inventory = client:GetInventory()
        if !inventory then return end

        entity._containerTime = 1
        entity._containerName = client:Name()
        entity._containerInventory = InventoryBase.CreateInventory(inventory.w, inventory.h)

        for x = 1, inventory.w do
            for y = 1, inventory.h do
                local item = inventory:GetItemAt(x, y)

                if item and !item:GetData("equip") then
                    item:Transfer(entity._containerInventory:GetID(), x, y)
                end
            end
        end
    end

    local corpseInfo = (attacker and attacker:IsPlayer()) and attacker:SteamID() or true
    entity:SetCorpse(corpseInfo)
end

function Persistent:ReDoPlayerDeath(client, attacker)
    self:ClearCompositeEntities(client)

    if Arbitrage.OffSpawnPersistent() then return end
    if !client:InGame() then return end

    local ragdoll = client:GetRagdoll()
    if IsValid(ragdoll) then return end

    local entity = self:CreateRagdoll(client)
    self:SetPersistent(entity, client, attacker)
end

netstream.Hook("fb:ChangeFOV", function(client)
    if Arbitrage.OffCorpseEffect() then return end

    local oldFOV = client:GetFOV()
    client:SetFOV(oldFOV - 15, Persistent.turnoff_time * 0.65)

    timer.Simple(Persistent.turnoff_time, function()
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
        if Persistent:AllowLogFindCorpse(v) then
            Arbitrage.commands.Notify(v, Format("%s(%s) обнаружил труп! (%s)", client:Name(), client:SteamName(), tostring(entity)))
        end
    end

    if Arbitrage.OffSoundMassFindCorpse() then return end

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