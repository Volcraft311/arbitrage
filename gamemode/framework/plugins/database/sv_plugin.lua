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


DataBase.deathPlaques = DataBase.deathPlaques or {}
DataBase.disconnectPlayers = DataBase.disconnectPlayers or {}
DataBase.MapCreationEntities = DataBase.MapCreationEntities or {}

function DataBase:UpdateMapCreationEntities()
    local entities = {}

    for _, entity in ipairs(ents.GetAll()) do
        if IsValid(entity) then
            local creationID = entity:MapCreationID()
            local model = entity:GetModel()

            if creationID > 0 and model then
                entities[creationID] = entity
            end
        end
    end

    self.MapCreationEntities = entities
end

---@param state_name string
---@param save table
function DataBase:SaveServerState(state_name, save)
    local state = {
        props = {},
        removed_creation_entities = {},
        net_globals = {},
        net_players_globals = {},
        net_players_locals = {},
        items_world = {},
        inventories = {}
    }

    if save.props then
        for _, entity in ipairs(ents.GetAll()) do
            local class = entity:GetClass()
            local idx = entity:EntIndex()

            if IsValid(entity) and entity:GetModel() and (entity.CreatedBy or class:find("arb_")) then
                local Tab = AdvDupe2.duplicator.Copy(nil, entity, {}, {}, Vector(0, 0, 0))

                if Tab and Tab[idx] then
                    Tab[idx].Nets = asterionlib.net.list[idx] or {}

                    state.props[#state.props + 1] = Tab[idx]
                end
            end
        end
    end

    if save.removedCreationEntities then
        for creationID, entity in pairs(self.MapCreationEntities) do
            if !IsValid(entity) then
                state.removed_creation_entities[#state.removed_creation_entities + 1] = creationID
            end
        end
    end

    if save.netGlobals then
        local nets = table.Copy(asterionlib.net.globals)

        nets.serverstat = nil

        state.net_globals = nets
    end

    if save.netPlayers then
        for idx, data in pairs(asterionlib.net.list) do
            local entity = Entity(idx)

            if IsValid(entity) and entity:IsPlayer() then
                local nets = table.Copy(data)

                nets.moderation_staticusergroup = nil
                nets.moderation_dynamicusergroup = nil
                nets.user_info = nil
                nets.connectedTime = nil
                nets["esp.position"] = nil

                state.net_players_globals[entity:SteamID()] = nets
            end
        end

        for idx, data in pairs(asterionlib.net.locals) do
            local entity = Entity(idx)

            if IsValid(entity) and entity:IsPlayer() then
                local nets = table.Copy(data)

                state.net_players_locals[entity:SteamID()] = nets
            end
        end
    end

    return state
end

function DataBase:LoadServerState(client, state)
    for _, tab in ipairs(state.props or {}) do
        local entities = AdvDupe2.duplicator.Paste(nil, {tab}, {}, nil, nil, Vector(0, 0, 0), true)
        local entity = entities[1]

        if IsValid(entity) then
            local idx = entity:EntIndex()

            entity.CreatedBy = client:SteamID()

            for key, value in pairs(tab.Nets) do
                asterionlib.net.list[idx] = asterionlib.net.list[idx] or {}
                asterionlib.net.list[idx][key] = value
            end
        end
    end

    for _, creationID in ipairs(state.removed_creation_entities or {}) do
        local entity = self.MapCreationEntities[creationID]

        if IsValid(entity) then
            entity:Remove()
        end
    end

    for key, value in pairs(state.net_globals or {}) do
        asterionlib.net.globals[key] = value
    end

    for steamID, data in pairs(state.net_players_globals or {}) do
        local entity = player.GetBySteamID(steamID)

        if IsValid(entity) then
            local idx = entity:EntIndex()

            for key, value in pairs(data or {}) do
                asterionlib.net.list[idx] = asterionlib.net.list[idx] or {}
                asterionlib.net.list[idx][key] = value
            end
        end
    end

    for steamID, data in pairs(state.net_players_locals or {}) do
        local entity = player.GetBySteamID(steamID)

        if IsValid(entity) then
            local idx = entity:EntIndex()

            for key, value in pairs(data or {}) do
                asterionlib.net.list[idx] = asterionlib.net.list[idx] or {}
                asterionlib.net.list[idx][key] = value
            end
        end
    end
end


local lifting = Vector(0, 0, 64)
timer.Create("Arbitrage:DeadTablets", 5, 0, function()
    if Arbitrage.OffSpawnDeadTablets() then return end

    if !Arbitrage.placesList then return end

    for k, v in pairs(Arbitrage.players) do
        local client = player.GetBySteamID(k)
        if IsValid(client) and client:Alive() and client:InGame() then
            local entity = DataBase.deathPlaques[k]
            if IsValid(entity) then
                entity:Remove()
            end

            continue
        end

        local place = tonumber(v.place)
        if place == -1 then continue end -- Место неуказано

        local placeList = Arbitrage.placesList[place]
        if !placeList then continue end

        local entity = DataBase.deathPlaques[k]
        if IsValid(entity) then continue end

        local stored = placeList
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

        DataBase.deathPlaques[k] = entity
    end
end)

timer.Create("DataBase:Saver", 60, 0, function()
    for _, client in ipairs(player.GetAll()) do
        client:SaveSaverInfo()
    end
end)


---@param client Player
hook("PlayerSpawnedEffect", function(client, model, entity)
    entity.CreatedBy = client:SteamID()
end)

---@param client Player
hook("PlayerSpawnedNPC", function(client, entity)
    entity.CreatedBy = client:SteamID()
end)

---@param client Player
hook("PlayerSpawnedProp", function(client, model, entity)
    entity.CreatedBy = client:SteamID()
end)

---@param client Player
hook("PlayerSpawnedRagdoll", function(client, model, entity)
    entity.CreatedBy = client:SteamID()
end)

---@param client Player
hook("PlayerSpawnedSENT", function(client, entity)
    entity.CreatedBy = client:SteamID()
end)

---@param client Player
hook("PlayerSpawnedSWEP", function(client, entity)
    entity.CreatedBy = client:SteamID()
end)

---@param client Player
hook("PlayerSpawnedVehicle", function(client, entity)
    entity.CreatedBy = client:SteamID()
end)

hook("InitPostEntity", function()
    DataBase:UpdateMapCreationEntities()
end)

hook("PostCleanupMap", function()
    DataBase:UpdateMapCreationEntities()
end)

---@param client Player
hook("PlayerDisconnected", function(client)
    if client:Alive() and client:InGame() then
        local entity = ents.Create("arb_player")
        entity:SetPos(client:GetPos() - Vector(0, 0, 3))
        entity:GetAngles(client:GetAngles())
        entity:SetModel(client:GetModel())
        entity:SetModelScale(client:GetModelScale())
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
            scale = client.oldScale or client:GetModelScale(),
            hullscale = {hullMin, hullMax},
            hullduckscale = {hullduckMin, hullduckMax},
            speed = {[1] = client.arb_walkSpeed, [2] = client.arb_runSpeed},
            description = client:GetNetVar("description"),
            forced_description = client:GetNetVar("forced_description"),
            fake_name = client:GetNetVar("fakename"),
            recognize_name = client:GetNetVar("recognizeName"),
            recognize_disclosed = client:GetNetVar("recognizeDisclosed"),
            recognize_knowledge_all = client:GetNetVar("recognizeKnowledgeAll"),
            recognize_data = client:GetNetVar("recognizeData"),
            t_status_effects = {},
            t_remove_status_effects = {},

            saver = client:GetSaverInfo()
        }

        for k, v in ipairs({"Hunger", "Thirst", "Sleep"}) do
            entity.data.statistic[v] = Arbitrage.statistics.Get(client, v)
        end

        for k, v in ipairs(client:GetTemporaryStatusEffects()) do
            local uniqueID = v.uniqueID
            local delay = v.delay

            local info = Medical.t_status_effects[uniqueID]
            if info.noSave then continue end

            entity.data.t_status_effects[uniqueID] = delay <= 0 and 0 or delay - CurTime()
        end

        local character = Character.team:GetByID(entity.data.faction)
        if character then
            local t_remove_status_effects = {}

            for _, effect in ipairs(character.status_effects or {}) do
                if !entity.data.t_status_effects[effect] then
                    t_remove_status_effects[#t_remove_status_effects + 1] = effect
                end
            end

            entity.data.t_remove_status_effects = t_remove_status_effects
        end

        entity:LoadSaverInfo(entity.data.saver)

        entity._containerTime = 15
        entity._containerName = client:Name()
        entity._containerInventory = inventory

        DataBase.disconnectPlayers[client:SteamID()] = entity
    end
end)

---@param client Player
hook("OnPlayerInitialize", function(client)
    local steamid = client:SteamID()

    local leaveEntity = DataBase.disconnectPlayers[steamid]
    if !IsValid(leaveEntity) then return end

    local data = leaveEntity.data
    if !data then return end

    client:SetPos(leaveEntity:GetPos() + Vector(0, 0, 10))
    client:SetEyeAngles(Angle(0, 0, 0))

    Character.team:Join(client, data.faction)

    client:SetModel(leaveEntity:GetModel())
    client:SetModelScale(data.scale)
    client:SetHull(data.hullscale[1], data.hullscale[2], true)
    client:SetHullDuck(data.hullduckscale[1], data.hullduckscale[2], true)

    client.arb_walkSpeed = data.speed[1]
    client.arb_runSpeed = data.speed[2]


    timer.Simple(0, function()
        if data.description then
            client:SetNetVar("description", data.description)
        end

        if data.forced_description then
            client:SetNetVar("forced_description", data.forced_description)
        end

        if data.fake_name then
            client:SetNetVar("fakename", data.fake_name)
        end

        if data.recognize_name then
            client:SetNetVar("recognizeName", data.recognize_name)
        end

        if data.recognize_disclosed then
            client:SetNetVar("recognizeDisclosed", data.recognize_disclosed)
        end

        if data.recognize_knowledge_all then
            client:SetNetVar("recognizeKnowledgeAll", data.recognize_knowledge_all)
        end

        if data.recognize_data then
            client:SetNetVar("recognizeData", data.recognize_data)
        end
    end)

    client:LoadSaverInfo(data.saver, true)

    client:StripWeapons()
    for k, v in pairs(data.weapons) do
        client:Give(v, true)
    end

    client:RemoveAllAmmo()

    for k, v in pairs(data.ammo) do
        client:SetAmmo(v, k)
    end

    client.saveData = data

    leaveEntity:Remove()
    DataBase.disconnectPlayers[steamid] = nil
end)

---@param client Player
hook("PlayerInitialSpawnForRealz", function(client)
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

            -- Сихнронизируем повторно, ибо клиент не всегда получает запрос при заходе
            timer.Simple(10, function()
                inventory:Sync()
            end)
        end
    end

    timer.Simple(1, function()
        client:SetHealth(data.health)
        client:SetArmor(data.armor)

        for k, v in pairs(data.t_status_effects) do
            client:SetTemporaryStatusEffect(k, v)
        end

        for _, effect in ipairs(data.t_remove_status_effects) do
            client:RemoveTemporaryStatusEffect(effect)
        end
    end)

    client.saveData = nil
end)


local meta = FindMetaTable("Entity") ---@class Entity

function meta:GetSaverInfo()
    return table.Copy(self._saver or {})
end

function meta:SaveSaverInfo(bDelay)
    timer.Simple(bDelay and 0.6 or 0, function() -- Если мы сохраняем сразу после загрузки, то нужно КД чтобы все объекты успели прогрузиться
        if !IsValid(self) then return end

        self._saver = {}

        self._saver.Model = self:GetModel()
        self._saver.Scale = self.oldScale or self:GetModelScale()
        self._saver.Skin = self:GetSkin()
        self._saver.RenderMode = self:GetRenderMode()
        self._saver.Color = self:GetColor()
        self._saver.Material = self:GetMaterial()

        self._saver.SubMat = {}
        local sm = self:GetMaterials()
        if sm then
            for k, v in ipairs(sm) do
                local mat = self:GetSubMaterial(k - 1)

                if mat and mat != "" then
                    self._saver.SubMat[k - 1] = mat
                end
            end
        end

        self._saver.BodyG = {}
        local bg = self:GetBodyGroups()
        if bg then
            for k, v in ipairs(bg) do
                local bodygroup = self:GetBodygroup(v.id)

                if bodygroup > 0 then
                    self._saver.BodyG[v.id] = bodygroup
                end
            end
        end

        self._saver.CompositeEntities = CompositeEntities and CompositeEntities.GetArrayEntitites(self) or {}
    end)
end

function meta:LoadSaverInfo(saver, bDelay)
    saver = saver or {}

    timer.Simple(bDelay and 0.4 or 0, function()
        if !IsValid(self) then return end

        if saver.Model then
            self:SetModel(saver.Model)
        end

        if saver.Scale then
            self:SetModelScale(saver.Scale)
        end

        if saver.Skin then
            self:SetSkin(saver.Skin)
        end

        if saver.Material then
            self:SetMaterial(saver.Material)
        end

        if saver.RenderMode then
            self:SetRenderMode(saver.RenderMode)
        end

        if saver.Color then
            self:SetColor(saver.Color)
        end

        if saver.BodyG then
            for k, v in pairs(saver.BodyG) do
                self:SetBodygroup(k, v)
            end
        end

        if saver.SubMat then
            for k, v in pairs(saver.SubMat) do
                self:SetSubMaterial(k, v)
            end
        end

        if CompositeEntities and saver.CompositeEntities then
            CompositeEntities.LoadingArray(saver.CompositeEntities, self)
        end

        self:SaveSaverInfo(true)
    end)
end