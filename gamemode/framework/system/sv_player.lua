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

Arbitrage.player = Arbitrage.library.Add("player")

function Arbitrage.player.SetStats(client, data, amount)
    Arbitrage.statistics.Set(client, data, amount)
end

function Arbitrage.player.SetupSpeed(client)
    local faction = Character.team:GetByID(client:Team())

    local walkSpeed = faction and faction:GetWalkSpeed() or 1
    local runSpeed = faction and faction:GetRunSpeed() or 1

    client:SetWalkSpeed(ARBITRAGE_WALK_SPEED * walkSpeed)
    client:SetRunSpeed(ARBITRAGE_RUN_SPEED * runSpeed)
    client:SetSlowWalkSpeed(ARBITRAGE_WALK_SPEED * walkSpeed)
end

function Arbitrage.player.SetupStatistics(client)
    for k, v in pairs(Arbitrage.statistics.list) do
        Arbitrage.statistics.Set(client, v.data, 100)
    end
end

function Arbitrage.player.SetupHealth(client)
    local health, armor = ARBITRAGE_HEALTH, ARBITRAGE_ARMOR

    local id = client:Team()
    local character = Character.team:GetByID(id)
    if character then
        health = character:GetHealth()
        armor = character:GetArmor()
    end

    client:SetHealth(health)
    client:SetArmor(armor)
end

function Arbitrage.player.SetupWeapons(client)
    client:Give("academy_first")
    client:Give("academy_key")

    client:SelectWeapon("academy_key")

    local faction = Character.team:GetByID(client:Team())
    if !faction then return end

    if !Arbitrage.OffGiveWeapons() then
        for k, v in ipairs(faction:GetWeapons() or {}) do
            client:Give(v, true)
        end
    end
end

function Arbitrage.player.SetupInventory(client)
    local w, h = 4, 2

    local items = {}
    local inventory = client:GetInventory()
    if inventory then
        items = inventory:GetItems()
    end

    local faction = Character.team:GetByID(client:Team())
    if faction then
        w = faction.inventory.w or 4
        h = faction.inventory.h or 2
    end

    inventory = InventoryBase.CreateInventory(w, h)
    inventory:SetOwner(client)

    for _, item in ipairs(items) do
        item:Transfer(inventory:GetID())
    end

    inventory:Sync()
end

function Arbitrage.player.GetEyesPos(client)
    local eyePosZ = 64

    local entity = ents.Create("base_anim")
    entity:SetModelScale(client:GetModelScale())
    entity:SetModel(client:GetModel())
    entity:ResetSequence(entity:LookupSequence("idle_all_01"))

    local bone = entity:LookupBone("ValveBiped.Bip01_Neck1")
    if bone then
        local pos = entity:GetBonePosition(bone)

        if pos then
            eyePosZ = pos.z + 5
        end
    end

    entity:Remove()

    local eyePosDuckZ = eyePosZ - (64 - 28) * 0.6
    return eyePosZ, eyePosDuckZ
end

function Arbitrage.player.SetupViewOffset(client)
    timer.Simple(2, function()
        if !IsValid(client) then return end

        local eyePosZ, eyePosDuckZ = Arbitrage.player.GetEyesPos(client)
        client:SetViewOffset(Vector(0, 0, eyePosZ))
        client:SetViewOffsetDucked(Vector(0, 0, eyePosDuckZ))
    end)
end

function Arbitrage.player.Respawn(client)
    client:Spawn()
    client:Respawn()
    client:StripAmmo()
    client:StripWeapons()
    client:Freeze(false)
    client:GodDisable()

    local health, armor = ARBITRAGE_HEALTH, ARBITRAGE_ARMOR

    local id = client:Team()
    local character = Character.team:GetByID(id)
    if character then
        health = character:GetHealth()
        armor = character:GetArmor()
    end

    Arbitrage.player.SetupSpeed(client)

    client:SetNoCollideWithTeammates(false)

    client:ReDraw()

    client:GodDisable()
    client:SetNoTarget(false)
    client:SetCollisionGroup(COLLISION_GROUP_PLAYER)
    client:CheckStuck(0.2)

    local vector, _ = Arbitrage.lobbyList and table.Random(Arbitrage.lobbyList) or Vector(0, 0, 0)
    client:SetPos(vector)
    client:SetEyeAngles(Angle(0, 0, 0))

    Arbitrage.player.SetupStatistics(client)
    Arbitrage.player.SetupWeapons(client)

    timer.Simple(1, function()
        if !IsValid(client) then return end

        client:SetHealth(Arbitrage.IsStartGame() and health or 999999)
        client:SetArmor(armor)
        client:SetupHands()
    end)
end