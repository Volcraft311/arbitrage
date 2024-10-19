local function SetEntityVelocity(entity, client)
    local headIndex = entity:LookupBone("ValveBiped.Bip01_Head1")

    for i = 0, entity:GetPhysicsObjectCount() - 1 do
        local physicsObject = entity:GetPhysicsObjectNum(i)
        if !IsValid(physicsObject) then continue end

        local boneIndex = entity:TranslatePhysBoneToBone(i)
        -- плохо работает из-за кривых рук разрабов моделек для ронпы
        --[[
        local position, angle = client:GetBonePosition(boneIndex)
        physicsObject:SetPos(position)
        physicsObject:SetAngles(angle)
        ]] --

        physicsObject:SetMass(1)

        local velocity = client:GetVelocity() + client:GetAimVector() * 64
        local power = boneIndex == headIndex and 1.5 or 1

        physicsObject:SetVelocity(velocity * power)
    end
end

function RagdollSystem:CreateRagdoll(client)
    local entity = ents.Create("prop_ragdoll")
    entity:SetModel(client:GetModel())
    entity:SetModelScale(client:GetModelScale())
    entity:SetPos(client:GetPos())
    entity:SetAngles(client:GetAngles())
    entity:Spawn()

    entity._client = client
    entity:SetNetVar("sIsRagdoll", client:SteamID())

    entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    entity:Activate()

    entity:LoadSaverInfo(client:GetSaverInfo())

    SetEntityVelocity(entity, client)

    return entity
end

function RagdollSystem:CreateSyncTime(client)
    local id = "RagdollSystem:Sync_" .. client:SteamID()
    timer.Create(id, 0.33, 0, function()
        if !IsValid(client) then return timer.Remove(id) end

        local entity = client:GetRagdoll()
        if !IsValid(entity) then
            client:StandUp()

            return timer.Remove(id)
        end

        client:SetPos(entity:GetPos() + entity:OBBCenter() + Vector(0, 0, -25))
    end)
end

local meta = FindMetaTable("Player")

function meta:FallOver(delay)
    if !self:Alive() then return end
    if self:IsNocliping() then return end
    if self:IsRagdolling() then return end
    if Arbitrage.lawEnable then return end
    if self:InVehicle() then return end
    if self.IsHandcuffed and self:IsHandcuffed() then return end

    local entity = RagdollSystem:CreateRagdoll(self)

    -- convent delay number
    if delay != nil then
        delay = tonumber(delay)

        -- 0 == nil
        if delay == 0 then
            delay = nil
        end
    end

    self.fallOverDelay = delay
    self:SetNetVar("ragdoll", entity:EntIndex())
    self:Freeze(true)
    self:SetMoveType(MOVETYPE_OBSERVER)

    self:DrawHide()
    self:SetNoTarget(true)

    self:SetVelocity(-self:GetVelocity())
    self:SelectWeapon("academy_key")

    self:AddTemporaryStatusEffect("stun", 0)
    RagdollSystem:CreateSyncTime(self)

    self.isTalking = nil

    netstream.Start(self, "RagdollSystem:FallOver", entity:EntIndex(), delay)
end

function meta:StandUp(bNoRemove)
    local idx = self:GetNetVar("ragdoll")
    if idx == nil then return end

    self.fallOverDelay = nil
    self:SetNetVar("ragdoll", nil)
    self:Freeze(false)
    self:SetMoveType(MOVETYPE_WALK)

    self:SetNoTarget(false)

    self:SetVelocity(-self:GetVelocity())
    self:SelectWeapon("academy_key")
    self:CheckStuck(0.1)

    local entity = Entity(idx)
    if !bNoRemove and IsValid(entity) then
        self:SetPos(entity:GetPos() + Vector(0, 0, 20))
        entity:Remove()
    end

    self:ReDraw()

    if self:Health() > 10 then
        self:RemoveTemporaryStatusEffect("stun")
    end

    netstream.Start(self, "RagdollSystem:ClosePanel")

    return entity
end