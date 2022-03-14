--[[
        © Asterion Project 2021.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

Arbitrage.player = Arbitrage.library.Add("player")

function Arbitrage.player.SetStats(client, data, amount)
    if !IsValid(client) then return end

    Arbitrage.statistics.Set(client, data, amount)
end

function Arbitrage.player.SetTeam(client, data, bRespawn)
    if !IsValid(client) then return end
    if !data then return end

    local team = Arbitrage.teams.data[tonumber(data)]
    if !team then return end

    if bRespawn then
        Arbitrage.player.Respawn(client)
    end

    client:SetTeam(tonumber(data))
    client:SetModel(team.model or ARBITRAGE_STANDART_MODEL)
    client:SetNoCollideWithTeammates(false)

    if team.OnChange then
        team.OnChange(client)
    end

    for k, v in pairs(team.weapons or {}) do
        client:Give(v)
    end

    Arbitrage.player.SetupSpeed(client)

    hook.Run("SelectCharacter", client, data)
end

function Arbitrage.player.SetupSpeed(client)
    if !IsValid(client) then return end

    local faction = Arbitrage.teams.Get(client:Team())
    if !faction then return end

    local walkSpeed = 1
    local runSpeed = 1

    if faction.walkSpeed then
        walkSpeed = faction.walkSpeed
    end

    if faction.runSpeed then
        runSpeed = faction.runSpeed
    end

    client:SetWalkSpeed(ARBITRAGE_WALK_SPEED * walkSpeed)
    client:SetRunSpeed(ARBITRAGE_RUN_SPEED * runSpeed)
end

function Arbitrage.player.SetupStatistics(client)
    if !IsValid(client) then return end

    for k, v in pairs(Arbitrage.statistics.list) do
        Arbitrage.statistics.Set(client, v.data, 100)
    end
end

function Arbitrage.player.SetupHealth(client)
    client:SetHealth(ARBITRAGE_HEALTH)
    client:SetArmor(ARBITRAGE_ARMOR)
end

function Arbitrage.player.SetupWeapons(client)
    if !IsValid(client) then return end

    client:Give("tfa_arcade_first")
    client:Give("tfa_arcade_key")

    client:SelectWeapon("tfa_arcade_key")
end

function Arbitrage.player.Respawn(client)
    if !IsValid(client) then return end

    client:Spawn()
    client:Respawn()
    client:StripAmmo()
    client:StripWeapons()
    client:Freeze(false)
    client:GodDisable()

    client:SetHealth(ARBITRAGE_HEALTH * 10)
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

    local vector, _ = ARBITRAGE_LOBBY[game.GetMap()] and table.Random(ARBITRAGE_LOBBY[game.GetMap()]) or Vector(0, 0, 0)
    client:SetPos(vector)
    client:SetEyeAngles(Angle(0, 0, 0))

    Arbitrage.player.SetupStatistics(client)

    client.weapons = {}
end