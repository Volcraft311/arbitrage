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

function BedSystem:LayDownBed(client, entity)
    if !IsValid(client) then return end

    local pos = self.allowBed[entity:GetModel()].pos or Vector(0, 0, 0)
    local ang = self.allowBed[entity:GetModel()].ang or Angle(0, 0, 0)

    local eyePos = client:EyePos()
    local eyeAng = client:EyeAngles()

    client:SetMoveType(MOVETYPE_OBSERVER)

    timer.Simple(0.2, function()
        client:SetPos(entity:GetPos() + pos - Vector(0, 0, 3))
        client:SetEyeAngles(entity:GetAngles() + ang + Angle(0, 180, 0))
        client:Freeze(true)
    end)

    client:AddTemporaryStatusEffect("sleep", 0)
    client:AddTemporaryStatusEffect("health_bed", 0)

    netstream.Start(client, "BedSystem:LayDownBed", entity, eyePos, eyeAng)
    hook.Run("OnBedEnter", client, entity)

    client.inBed = true
end

function BedSystem:GetUpBed(client)
    if !IsValid(client) then return end

    client:Freeze(false)
    client:SetMoveType(MOVETYPE_WALK)
    client:SetPos(client:GetPos() + Vector(0, 0, 10))
    client:SetEyeAngles(Angle(0, 0, 0))

    client:RemoveTemporaryStatusEffect("sleep")
    client:RemoveTemporaryStatusEffect("health_bed")

    netstream.Start(client, "BedSystem:GetUpBed")
    hook.Run("OnBedExit", client)

    client.inBed = nil
end

function BedSystem:PlayerUse(client, entity)
    local allow = self.allowBed[string.lower(tostring(entity:GetModel() or ""))]

    if allow and client:oldAlive() and (!client.BedCD or CurTime() >= client.BedCD) then
        TypingDraw:SendSphere(0.5, client, "Ложится на кровать", Color(255, 170, 23))

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

local bedActionList = {
    arrestidle = true,
    d1_town05_winston_down = true,
    d1_town05_wounded_idle_2 = true,
    injured1 = true,
    injured2 = true,
    injured3 = true,
    sniper_victim_pre = true,
    d2_coast11_tobias = true,
    lying_down = true,
    d1_town05_wounded_idle_1 = true,
}

function BedSystem:ActionStart(client, name)
    if !name then return end

    name = name:lower()

    if !bedActionList[name] then return end
    if client.inBed then return end

    client:AddTemporaryStatusEffect("sleep_action", 0)
end

function BedSystem:ActionEnd(client, name)
    if !isstring(name) then return end -- exitaction /lookaround

    name = name:lower()

    if !bedActionList[name] then return end

    client:RemoveTemporaryStatusEffect("sleep_action")
end

netstream.Hook("BedSystem:GetUpBed", function(client)
    if !client.inBed then return end

    Arbitrage.action.ActionRun(client, "Вы просыпаетесь", 5, function()
        return false
    end, function(activator)
        BedSystem:GetUpBed(client)
    end)
end)