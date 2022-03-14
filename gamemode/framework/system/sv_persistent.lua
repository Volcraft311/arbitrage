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

Arbitrage.persistent = Arbitrage.library.Add("persistent")

function Arbitrage.persistent.CreateRagdoll(client)
    local entity = ents.Create("prop_ragdoll")
    entity:SetPos(client:GetPos())
    entity:SetAngles(client:GetAngles())
    entity:SetModel(client:GetModel())
    entity:SetSkin(client:GetSkin())
    entity:Spawn()

    entity:SetNetVar("player", client)

    entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    entity:Activate()

    return entity
end

function Arbitrage.persistent.DoPlayerDeath(client, attacker, damageinfo)
    if !client:InGame() then return end

    local entity = Arbitrage.persistent.CreateRagdoll(client)
    entity.client = client
    entity.name = client:Name()
end

--[[
function Arbitrage.persistent.DoPlayerDeath(client, attacker, damageinfo)
    if !client:InGame() then return end

    local entity = Arbitrage.persistent.CreateRagdoll(client)

    local original_time = math.Round(Arbitrage.ReturnTime())
    local random_time1 = 3600 --math.random(min_time, max_time)
    local random_time2 = 3600 --math.random(min_time, max_time)
    local time1 = original_time - random_time1
    local time2 = original_time + random_time2

    if damageinfo:GetDamageType() == 32 then -- Падение
        client.GetAllDamage = client.GetAllDamage or {}

        for k, v in pairs({"head", "chest", "stomach", "left_hand", "right_hand", "left_leg", "right_leg"}) do
            client.GetAllDamage[#client.GetAllDamage + 1] = {
                time = CurTime(),
                type = "Перелом",
                deletetime = CurTime() + 900,
                hitgroup = v,
            }
        end

        client.fracture = true
    end

    Arbitrage.persistent.ragdolls[#Arbitrage.persistent.ragdolls + 1] = {
        entity = entity:EntIndex(),
        pos = entity:GetPos(),
        info = {
            client = client,
            name = client:Name(),
            evidence = {
                client.GetAllDamage
            },
            time = {
                original_time,
                time1,
                time2
            }
        }
    }

    Arbitrage.persistent.ragdolls[#Arbitrage.persistent.ragdolls].info.fracture = client.fracture and true or false

    entity.client = client
    entity.name = client:Name()
    --entity.info = Arbitrage.persistent.ragdolls[#Arbitrage.persistent.ragdolls]

    for k, v in pairs(player.GetAll()) do
        netstream.Start(v, "arb.GetPersistentCorpses", Arbitrage.persistent.ragdolls)
    end

    client.GetAllDamage = {}
    client.fracture = false
    client:SetNetVar("damager", false)
end
]]--