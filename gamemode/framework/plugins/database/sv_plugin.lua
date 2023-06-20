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
PLUGIN.deathPlaques = PLUGIN.deathPlaques or {}
PLUGIN.disconnectPlayers = PLUGIN.disconnectPlayers or {}

local lifting = Vector(0, 0, 64)

function PLUGIN:OneSecond()
    if Arbitrage.OffSpawnDeadTablets() then return end

    for k, v in pairs(Arbitrage.players) do
        local client = player.GetBySteamID(k)

        local place = tonumber(v.place)
        if place == -1 then continue end -- Место неуказано

        if IsValid(client) and client:Alive() and client:InGame() then
            -- eh...
        else
            local entity = self.deathPlaques[k]
            if !IsValid(entity) then
            	if !Arbitrage.placesList[place] then continue end

                local stored = Arbitrage.placesList[place]
                local pos = stored[1] - lifting
                local ang = stored[2]

                entity = ents.Create("arb_dead")
                entity:SetPos(pos)
                entity:SetAngles(Angle(0, ang.y, ang.r))
                entity:Spawn()

                entity:SetCharacter({
                    steamid = k,
                    faction = v.faction
                })

                self.deathPlaques[k] = entity
            end
        end
    end
end

function PLUGIN:PlayerDisconnected(client)
    if client:Alive() and client:InGame() then
        local entity = ents.Create("arb_player")
        entity:SetPos(client:GetPos() - Vector(0, 0, 3))
        entity:GetAngles(client:GetAngles())
        entity:SetModel(client:GetModel())
        entity:Spawn()

        hook.Run("OnCreateDisconnectEntity", client)

        local weaponsList = {}
        for k, v in pairs(client:GetWeapons()) do
            weaponsList[#weaponsList + 1] = v:GetClass()
        end

        local hullMin, hullMax = client:GetHull()
        local hullduckMin, hullduckMax = client:GetHullDuck()
        local inventory = client:GetInventory()

        entity.data = {
            health = client:Health(),
            armor = client:Armor(),
            faction = client:Team(),
            weapons = weaponsList,
            activeweapon = client:GetActiveWeapon():GetClass(),
            statistic = {},
            evidence = client:GetEvidences(),
            inventoryID = inventory:GetID(),
            ammo = client:GetAmmo(),
            scale = client:GetModelScale(),
            hullscale = {hullMin, hullMax},
            hullduckscale = {hullduckMin, hullduckMax},
            speed = {[1] = client.arb_walkSpeed, [2] = client.arb_runSpeed},

            saver = client._saver
        }

        local entities = client.getCompositeEntities and client:getCompositeEntities() or {}
        if table.Count(entities) > 0 then
            local array = CompositeEntities.GetArrayEntitites(client)

            entity.data.composite = array

            if #array > 0 then
                timer.Simple(FrameTime(), function()
                    CompositeEntities.LoadingArray(array, entity)
                end)
            end
        end

        for k, v in ipairs({"Hunger", "Thirst", "Sleep"}) do
            entity.data.statistic[v] = Arbitrage.statistics.Get(client, v)
        end

        local saver = entity.data.saver
        if saver then
            timer.Simple(0.4, function()
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
            end)
        end

        entity._containerTime = 15
        entity._containerName = client:Name()
        entity._containerInventory = inventory
        self.disconnectPlayers[client:SteamID()] = entity
    end
end

timer.Create("DataBase:Saver", 1, 0, function()
    for _, entity in ipairs(player.GetAll()) do
        entity._saver = {SubMat = {}, BodyG = {}}

        entity._saver.Skin = entity:GetSkin()
        entity._saver.RenderMode = entity:GetRenderMode()
        entity._saver.Color = entity:GetColor()
        entity._saver.Material = entity:GetMaterial()

        local sm = entity:GetMaterials()
        if sm then
            for k, v in ipairs(sm) do
                local mat = entity:GetSubMaterial(k - 1)

                if mat and mat != "" then
                    entity._saver.SubMat[k - 1] = mat
                end
            end
        end

        local bg = entity:GetBodyGroups()
        if bg then
            for k, v in ipairs(bg) do
                local bodygroup = entity:GetBodygroup(v.id)

                if bodygroup > 0 then
                    entity._saver.BodyG[v.id] = bodygroup
                end
            end
        end
    end
end)

function PLUGIN:PlayerInitial(client)
    local steamid = client:SteamID()

    local leaveEntity = self.disconnectPlayers[steamid]
    if !IsValid(leaveEntity) then return end

    local data = leaveEntity.data
    if !data then return end

    client:SetPos(leaveEntity:GetPos() + Vector(0, 0, 10))
    client:SetEyeAngles(Angle(0, 0, 0))

    Character.team:Join(client, data.faction)

    client:SetModel(leaveEntity:GetModel())
    client:SetHealth(data.health)
    client:SetArmor(data.armor)

    client:SetModelScale(data.scale)
    client:SetHull(data.hullscale[1], data.hullscale[2], true)
    client:SetHullDuck(data.hullduckscale[1], data.hullduckscale[2], true)

    client.arb_walkSpeed = data.speed[1]
    client.arb_runSpeed = data.speed[2]

    timer.Simple(0.1, function()
        if data.composite and #data.composite > 0 then
            CompositeEntities.LoadingArray(data.composite, client)
        end

        timer.Simple(0.5, function()
            local saver = data.saver
            if saver then
                client:SetSkin(saver.Skin)
                client:SetMaterial(saver.Material)
                client:SetRenderMode(saver.RenderMode)
                client:SetColor(saver.Color)

                for k, v in pairs(saver.BodyG) do
                    client:SetBodygroup(k, v)
                end

                for k, v in pairs(saver.SubMat) do
                    client:SetSubMaterial(k, v)
                end
            end
        end)
    end)

    client:StripWeapons()
    for k, v in pairs(data.weapons) do
        client:Give(v)
    end

    client:StripAmmo()
    for k, v in pairs(data.ammo) do
        client:SetAmmo(v, k)
    end

    client.saveData = data

    leaveEntity:Remove()
    self.disconnectPlayers[steamid] = nil
end

function PLUGIN:PlayerInitialSpawnForRealz(client)
    local data = client.saveData
    if !data then return end

    client:SetEyeAngles(Angle(0, 0, 0))
    client:SelectWeapon(data.activeweapon)

    for k, v in pairs(data.statistic) do
        Arbitrage.statistics.Set(client, k, v)
    end

    for id in pairs(data.evidence) do
        client:AddEvidence(id)
    end

    Arbitrage.player.SetupSpeed(client)
    Arbitrage.player.SetupInventory(client)

    local invID = data.inventoryID
    if invID then
        local inventory = InventoryBase.instances[invID]

        if inventory then
            inventory:SetOwner(client)
            inventory:Sync()
        end
    end

    client.saveData = nil
end