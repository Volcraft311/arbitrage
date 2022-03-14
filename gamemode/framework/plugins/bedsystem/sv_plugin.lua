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

local PLUGIN = PLUGIN

function PLUGIN:LayDownBed(client, entity)
    if !IsValid(client) then return end

    local pos = self.allowBed[entity:GetModel()].pos or Vector(0, 0, 0)
    local ang = self.allowBed[entity:GetModel()].ang or Angle(0, 0, 0)

    client:SetMoveType(MOVETYPE_OBSERVER)

    timer.Simple(0.1, function()
        client:SetPos(entity:GetPos() + pos)
        client:SetEyeAngles(entity:GetAngles() + ang)
        client:Freeze(true)
    end)

    client:SetNetVar("inbed", entity)

    client.bedentity = entity
end

function PLUGIN:GetUpBed(client, entity)
    if !IsValid(client) then return end

    client:Freeze(false)
    client:SetMoveType(MOVETYPE_WALK)
    client:SetNetVar("inbed", nil)
end

function PLUGIN:PlayerUse(client, entity)
    local allow = self.allowBed[entity:GetModel()]

    if allow and client:oldAlive() and (!client.BedCD or CurTime() >= client.BedCD) then
        Arbitrage.action.ActionRun(client, "Ложимся на кровать", 5, function()
            if client:GetEyeTrace().Entity != entity then return true end
            if client:GetPos():Distance(entity:GetPos()) >= 80 then return true end

            return false
        end, function(activator)
            self:LayDownBed(client, entity)
        end)

        client.BedCD = CurTime() + 1
    end
end

function PLUGIN:PlayerPostThink(client)
    if !client:oldAlive() then return end
    if !client:GetNetVar("inbed") then return end

    if (!client.BedRegen or CurTime() >= client.BedRegen) then
        local amount = Arbitrage.statistics.Get(client, "Sleep")
        Arbitrage.statistics.Set(client, "Sleep", math.Clamp(amount + 1, 0, 100))

        client.BedRegen = CurTime() + 2
    end
end

netstream.Hook("arb.GetUpBed", function(client)
    Arbitrage.action.ActionRun(client, "Вы просыпаетесь", 10, function()
        return false
    end, function(activator)
        PLUGIN:GetUpBed(activator, activator.bedentity)
    end)
end)