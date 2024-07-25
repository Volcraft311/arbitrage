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
                if !Arbitrage.placesList then continue end
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
            t_status_effects = {},

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

        entity:LoadSaverInfo(entity.data.saver)

        entity._containerTime = 15
        entity._containerName = client:Name()
        entity._containerInventory = inventory
        self.disconnectPlayers[client:SteamID()] = entity
    end
end

timer.Create("DataBase:Saver", 60, 0, function()
    for _, client in ipairs(player.GetAll()) do
        client:SaveSaverInfo()
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

    client:LoadSaverInfo(data.saver, true)

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

    timer.Simple(0.1, function()
        for k, v in pairs(data.t_status_effects) do
            client:SetTemporaryStatusEffect(k, v)
        end
    end)

    client.saveData = nil
end

local meta = FindMetaTable("Entity")

function meta:GetSaverInfo()
    return self._saver and table.Copy(self._saver) or {}
end

function meta:SaveSaverInfo(bDelay)
    timer.Simple(bDelay and 0.6 or 0, function() -- Если мы сохраняем сразу после загрузки, то нужно КД чтобы все объекты успели прогрузиться
        self._saver = {}

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
    timer.Simple(bDelay and 0.4 or 0, function()
        self:SetSkin(saver.Skin)
        self:SetMaterial(saver.Material)
        self:SetRenderMode(saver.RenderMode)
        self:SetColor(saver.Color)

        for k, v in pairs(saver.BodyG) do
            self:SetBodygroup(k, v)
        end

        for k, v in pairs(saver.SubMat) do
            self:SetSubMaterial(k, v)
        end

        if CompositeEntities then
            CompositeEntities.LoadingArray(saver.CompositeEntities, self)
        end

        self:SaveSaverInfo(true)
    end)
end