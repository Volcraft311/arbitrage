--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru (not work)
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
    for k, v in pairs(Arbitrage.players) do
        local client = player.GetBySteamID(k)

        local place = tonumber(v.place)
        if place == -1 then continue end -- Место неуказано

        if IsValid(client) and client:Alive() and client:InGame() then
            -- eh...
        else
            local entity = self.deathPlaques[k]
            if !IsValid(entity) then
                entity = ents.Create("arb_dead")
                entity:SetPos(Arbitrage.placesList[place][1] - lifting)
                entity:SetAngles(Arbitrage.placesList[place][2])
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

        entity.data = {
            health = client:Health(),
            armor = client:Armor(),
            faction = client:Team(),
            weapons = weaponsList,
            activeweapon = client:GetActiveWeapon():GetClass(),
            statistic = {},
            evidence = client:GetEvidences(),
            inventoryID = client:GetInventory():GetID(),
            ammo = client:GetAmmo()
        }

        for k, v in ipairs({"Hunger", "Thirst", "Sleep"}) do
            entity.data.statistic[v] = Arbitrage.statistics.Get(client, v)
        end

        self.disconnectPlayers[client:SteamID()] = entity
    end
end

function PLUGIN:PlayerInitial(client)
    local steamid = client:SteamID()

    local leaveEntity = self.disconnectPlayers[steamid]
    if !IsValid(leaveEntity) then return end

    local data = leaveEntity.data
    if !data then return end

    client:SetPos(leaveEntity:GetPos() + Vector(0, 0, 10))
    client:SetEyeAngles(leaveEntity:GetAngles())

    Arbitrage.player.SetTeam(client, data.faction)

    client:SetHealth(data.health)
    client:SetArmor(data.armor)

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