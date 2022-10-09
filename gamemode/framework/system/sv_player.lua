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

Arbitrage.player = Arbitrage.library.Add("player")

function Arbitrage.player.SetStats(client, data, amount)
    Arbitrage.statistics.Set(client, data, amount)
end

function Arbitrage.player.SetupSpeed(client)
    local faction = Character.team:GetByID(client:Team())
    if !faction then return end

    local walkSpeed = faction:GetWalkSpeed() or 1
    local runSpeed = faction:GetRunSpeed() or 1

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
    client:SetHealth(ARBITRAGE_HEALTH)
    client:SetArmor(ARBITRAGE_ARMOR)
end

function Arbitrage.player.SetupWeapons(client)
    client:Give("academy_first")
    client:Give("academy_key")

    client:SelectWeapon("academy_key")

    local faction = Character.team:GetByID(client:Team())
    if !faction then return end

    if !Arbitrage.OffGiveWeapons() then
        for k, v in ipairs(faction:GetWeapons() or {}) do
            client:Give(v)
        end
    end
end

function Arbitrage.player.SetupInventory(client)
    local inventory = client:GetInventory() or InventoryBase.CreateInventory()
    inventory:SetOwner(client)

    local faction = Character.team:GetByID(client:Team())
    if !faction then return end

    local w = faction.inventory.w or 4
    local h = faction.inventory.h or 2

    inventory:SetSize(w, h)
    inventory:Sync()
end

local offset = Vector(0, 0, 64)
local offsetDuck = Vector(0, 0, 28)
function Arbitrage.player.SetupViewOffset(client)
    timer.Simple(1, function()
        local vec, vecDuck = offset, offsetDuck

        local eyeAtt = client:GetAttachment(client:LookupAttachment("eyes"))
        if eyeAtt then
            local eyePosZ = eyeAtt.Pos.z
            local getPosZ = client:GetPos().z

            vec = Vector(0, 0, eyePosZ - getPosZ)
            vecDuck = Vector(0, 0, vec.z - (offset.z - offsetDuck.z) / 2)
        end

        client:SetViewOffset(vec)
        client:SetViewOffsetDucked(vecDuck)
    end)
end

function Arbitrage.player.Respawn(client)
    client:Spawn()
    client:Respawn()
    client:StripAmmo()
    client:StripWeapons()
    client:Freeze(false)
    client:GodDisable()

    local health = ARBITRAGE_HEALTH
    if !Arbitrage.IsStartGame() then
        health = 999999999
    end

    client:SetHealth(health)
    client:SetArmor(ARBITRAGE_ARMOR)

    Arbitrage.player.SetupSpeed(client)

    client:SetNoCollideWithTeammates(false)

    timer.Simple(0.2, function()
        if !client:IsNotCharacter() and !client:IsSpectate() then
            Arbitrage.player.SetupWeapons(client)
        end
    end)

    client:SetNoDraw(false)
    client:SetNotSolid(false)
    client:DrawWorldModel(true)
    client:DrawShadow(true)
    client:GodDisable()
    client:SetNoTarget(false)
    client:SetCollisionGroup(COLLISION_GROUP_PLAYER)
    client:CheckStuck(0.2)

    local vector, _ = Arbitrage.lobbyList and table.Random(Arbitrage.lobbyList) or Vector(0, 0, 0)
    client:SetPos(vector)
    client:SetEyeAngles(Angle(0, 0, 0))

    Arbitrage.player.SetupStatistics(client)

    timer.Simple(2, function()
        client:SetupHands()
    end)

    client.weapons = {}
end