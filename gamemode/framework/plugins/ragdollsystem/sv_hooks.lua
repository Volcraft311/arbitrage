local function getFallDamage(velocity)
    return math.max((velocity - 464) * 0.225225225, 0) * 1
end

function RagdollSystem:EntityTakeDamage(entity, dmginfo)
    if entity:GetClass() != "prop_ragdoll" then return end

    local client = entity._client
    if !IsValid(client) then return end

    if client:GetNetVar("ragdoll") != entity:EntIndex() then return end

    local physicsObject = entity:GetPhysicsObject()
    if !IsValid(physicsObject) then return end

    if dmginfo:IsDamageType(DMG_CRUSH) then
        if IsValid(entity._HeldOwner) then return end

        local velocity = physicsObject:GetVelocity():Length()
        local curTime = CurTime()

        if entity.nextFallDamage and curTime < entity.nextFallDamage then
            dmginfo:SetDamage(0)

            return true
        end

        entity.nextFallDamage = curTime + 1

        local amount = getFallDamage(velocity)
        client:TakeDamage(amount)
    else
        client:TakeDamage(dmginfo:GetDamage(), dmginfo:GetAttacker(), dmginfo:GetInflictor())
    end
end

function RagdollSystem:DoPlayerDeath(client, attacker)
    Persistent:ReDoPlayerDeath(client, attacker)

    netstream.Start(client, "RagdollSystem:ClosePanel")

    if Arbitrage.OffSpawnPersistent() or !client:InGame() then
        return client:StandUp()
    end

    local entity = client:StandUp(true)
    if IsValid(entity) then
        Persistent:SetPersistent(entity, client, attacker)
        entity:SetNetVar("sIsRagdoll", nil)

        Persistent:SetEntityActiveCharacterInfo(entity, client)
    end
end

function RagdollSystem:PlayerSpawn(client)
    client:StandUp()
end

function RagdollSystem:PlayerDisconnected(client)
    client:StandUp()
end

netstream.Hook("RagdollSystem:StandUp", function(client, entity, time)
    if isnumber(client.fallOverDelay) and client.fallOverDelay <= -1 then return end

    local ragdoll = client:GetRagdoll()
    if !IsValid(ragdoll) then return end
    if entity != ragdoll then return end

    if IsValid(entity._HeldOwner) then return end

    time = isnumber(time) and math.Clamp(time, 1, 60) or 5

    Arbitrage.action.ActionRun(client, "Встаем на ноги", time, function()
        if !IsValid(ragdoll) then return true end

        local length = ragdoll:GetVelocity():Length()
        local bAllowStand = length <= 2
        if !bAllowStand then
            return true
        end

         return false
    end, function(activator)
        client:StandUp()
    end)
end)