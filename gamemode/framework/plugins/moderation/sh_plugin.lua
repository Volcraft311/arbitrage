--[[
        © AsterionStaff 2024.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local PLUGIN = PLUGIN

PLUGIN.name = "Moderation"
Moderation = PLUGIN

Moderation.instances = Moderation.instances or {}
Moderation.logs = Moderation.logs or {}

function Moderation:PhysgunPickup(client, entity)
    if !client:IsAdmin() then return false end

    if entity:IsPlayer() then
        client.physgunPlayer = entity
        entity.playerPhysgunned = true

        entity:SetLocalVelocity(Vector(0, 0, 0))
        entity:SetMoveType(MOVETYPE_NONE)
        entity:SetCollisionGroup(COLLISION_GROUP_WORLD)
    end

    return true
end

function Moderation:PhysgunDrop(client, entity)
    if !client:IsAdmin() then return end

    if entity:IsPlayer() and entity.playerPhysgunned then
        client.physgunPlayer = nil
        entity.playerPhysgunned = nil

        entity:SetMoveType(MOVETYPE_WALK)
        entity:SetCollisionGroup(COLLISION_GROUP_PLAYER)

        if client:KeyPressed(IN_ATTACK2) then
            entity:SetLocalVelocity(Vector(0, 0, 0))
            entity:SetMoveType(MOVETYPE_NONE)
        end
    end
end

function Moderation:CanTool(client, tr, toolname, tool, button)
    return client:IsAdmin()
end

function Moderation:CanEditVariable(entity, client, key, val, editor)
    return client:IsAdmin()
end

function Moderation:RegisterRank(usergroup, data)
    self.instances[usergroup] = data
end

local meta = FindMetaTable("Player")
function meta:IsAdmin()
    local usergroup = self:GetDynamicUserGroup()
    local rank = Moderation.instances[usergroup]

    if rank and (rank.permision_admin or rank.permission_superadmin) then
        return true
    end

    return false
end

function meta:IsSuperAdmin()
    local usergroup = self:GetDynamicUserGroup()
    local rank = Moderation.instances[usergroup]

    if rank and rank.permission_superadmin then
        return true
    end

    return false
end

function meta:GetIcon()
    local usergroup = self:GetDynamicUserGroup()
    local rank = Moderation.instances[usergroup]

    if rank and rank.icon then
        return rank.icon
    end
end

function meta:GetStaticUserGroup()
    return self:GetNetVar("moderation_staticusergroup", "user")
end

function meta:GetDynamicUserGroup()
    return self:GetNetVar("moderation_dynamicusergroup", "user")
end

function meta:GetUserGroup()
    return self:GetDynamicUserGroup()
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sh_ranks.lua")
Arbitrage.base.Include("sh_mute_toolgun.lua")
Arbitrage.base.Include("sv_commands.lua")
Arbitrage.base.Include("sv_plugin.lua")
Arbitrage.base.Include("sv_hooks.lua")