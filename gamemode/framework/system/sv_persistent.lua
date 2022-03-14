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