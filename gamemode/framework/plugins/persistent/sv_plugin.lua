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

local meta = FindMetaTable("Entity")

function meta:SetCorpse(bSteamID)
    self:SetNetVar("iscorpse", bSteamID)
end

function PLUGIN:EntityRemoved(entity)
    if entity:IsCorpse() then
        entity:SetCorpse(false)
    end
end

function PLUGIN:CreateRagdoll(client)
    local entity = ents.Create("prop_ragdoll")
    entity:SetPos(client:GetPos())
    entity:SetAngles(client:GetAngles())
    entity:SetModel(client:GetModel())
    entity:SetSkin(client:GetSkin())
    entity:Spawn()

    entity:SetNetVar("player", client)

    entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    entity:Activate()

    local saver = client._saver
    if saver then
        entity:SetSkin(saver.Skin)
        entity:SetMaterial(saver.Material)
        entity:SetRenderMode(saver.RenderMode)
        entity:SetColor(saver.Color)

        for k, v in pairs(saver.BodyG) do
            entity:SetBodygroup(k, v)
        end

        for k, v in pairs(saver.SubMat) do
            entity:SetSubMaterial(k, v)
        end
    end

    client.persistent = {}
    client.persistent.model = client:GetModel()
    client.persistent.saver = saver

    local entities = client.getCompositeEntities and client:getCompositeEntities() or {}
    if table.Count(entities) > 0 then
        local array = CompositeEntities.GetArrayEntitites(client)

        client.persistent.composite = array

        if #array > 0 then
            CompositeEntities.LoadingArray(array, entity)
        end
    end

    return entity
end

function PLUGIN:DoPlayerDeath(client, attacker, damageinfo)
    if Arbitrage.OffSpawnPersistent() then return end
    if !client:InGame() then return end

    local entity = self:CreateRagdoll(client)
    entity.client = client
    entity.name = client:Name()

    do
        local inventory = client:GetInventory()
        if !inventory then return end

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
    if count == 3 and !Arbitrage.OffSoundMassFindCorpse() then
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