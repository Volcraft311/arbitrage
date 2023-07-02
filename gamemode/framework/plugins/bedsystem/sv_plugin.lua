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

function PLUGIN:LayDownBed(client, entity)
    if !IsValid(client) then return end

    local pos = self.allowBed[entity:GetModel()].pos or Vector(0, 0, 0)
    local ang = self.allowBed[entity:GetModel()].ang or Angle(0, 0, 0)

    client:SetMoveType(MOVETYPE_OBSERVER)
    client:SetEyeAngles(entity:GetAngles() + ang)

    timer.Simple(0.2, function()
        client:SetPos(entity:GetPos() + pos - Vector(0, 0, 3))
        client:SetEyeAngles(entity:GetAngles() + ang + Angle(0, 180, 0))
        client:Freeze(true)
    end)

    client:AddTemporaryStatusEffect("sleep", 0)
    client:AddTemporaryStatusEffect("health_bed", 0)
    client:SetNetVar("inbed", entity)

    client.bedentity = entity
end

function PLUGIN:GetUpBed(client, entity)
    if !IsValid(client) then return end

    client:Freeze(false)
    client:SetMoveType(MOVETYPE_WALK)
    client:SetNetVar("inbed", nil)
    client:SetPos(client:GetPos() + Vector(0, 0, 10))
    client:SetEyeAngles(Angle(0, 0, 0))
    client:RemoveTemporaryStatusEffect("sleep")
    client:RemoveTemporaryStatusEffect("health_bed")
end

function PLUGIN:PlayerUse(client, entity)
    local allow = self.allowBed[string.lower(tostring(entity:GetModel() or ""))]

    if allow and client:oldAlive() and (!client.BedCD or CurTime() >= client.BedCD) then
        for k, v in pairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.5)) do
            TypingDraw:SetTypingText(v, client, "Ложится на кровать", Color(255, 170, 23))
        end

        Arbitrage.action.ActionRun(client, "Ложимся на кровать", 5, function()
            if client:GetEyeTrace().Entity != entity then return true end
            if client:GetPos():Distance(entity:GetPos()) >= 180 then return true end

            return false
        end, function(activator)
            self:LayDownBed(client, entity)
        end)

        client.BedCD = CurTime() + 1
    end
end

netstream.Hook("arb.GetUpBed", function(client)
    if !client:GetNetVar("inbed") then return end

    Arbitrage.action.ActionRun(client, "Вы просыпаетесь", 5, function()
        return false
    end, function(activator)
        PLUGIN:GetUpBed(activator, activator.bedentity)
    end)
end)