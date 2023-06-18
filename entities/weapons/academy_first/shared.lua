AddCSLuaFile()

if CLIENT then
    SWEP.Slot = 1
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
end

SWEP.PrintName = "Руки"
SWEP.Author = ""
SWEP.Instructions = ""
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.WorldModel = ""
SWEP.ViewModel = Model("models/weapons/c_arms.mdl")

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "Asterion: Arbitrage"

SWEP.Primary.Delay = 0.3
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.Delay = 0.5
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.DrawAmmo = false
SWEP.HitDistance = 48
SWEP.KnockViewPunchAngle = Angle(-1.3, 1.8, 0)

SWEP.holdDistance = 64
SWEP.maxHoldDistance = 150
SWEP.maxHoldStress = 4000

local SoundList = {"knocking.wav", "loud_knocking.wav"}
local SwingSound = Sound("WeaponFrag.Throw")
local HitSound = Sound("Flesh.ImpactHard")

function SWEP:Initialize()
    self:SetHoldType("normal")
    self:SetAttack(false)

    self.lastHand = 0
    self.maxHoldDistanceSquared = self.maxHoldDistance ^ 2
    self.heldObjectAngle = Angle(angle_zero)
end

if CLIENT then
    hook.Add("CreateMove", "HandsCreateMove", function(cmd)
        if (LocalPlayer():GetLocalVar("bIsHoldingObject", false) and cmd:KeyDown(IN_ATTACK2)) then
            cmd:ClearMovement()

            local angle = RenderAngles()
            angle.z = 0
            cmd:SetViewAngles(angle)
        end
    end)
end

function SWEP:SetupDataTables()
    self:NetworkVar("Float", 0, "NextMeleeAttack")
    self:NetworkVar("Float", 1, "NextIdle")
    self:NetworkVar("Int", 2, "Combo")
    self:NetworkVar("Bool", 3, "Attack")
end

function SWEP:UpdateNextIdle()
    local client = self:GetOwner()

    local vm = client:GetViewModel()
    self:SetNextIdle(CurTime() + vm:SequenceDuration() / vm:GetPlaybackRate())
end

function SWEP:PrimaryAttack()
    if !IsFirstTimePredicted() then return end

    local client = self:GetOwner()

    if client:GetLocalVar("bIsHoldingObject", false) then
        self:SetNextPrimaryFire(CurTime() + 0.5)
        self:SetNextSecondaryFire(CurTime() + 0.5)

        return self:DropObject(true)
    end

    if self:GetAttack() then
        local stamina = Stamina:GetStamina(client)
        if stamina <= 4 then return end

        if SERVER then
            local value = math.max(0, stamina - 4)
            Stamina:SetStamina(client, value)
            Stamina:SetStaminaCD(client, value <= 1 and 10 or 2)
        end

        client:ViewPunch(self.KnockViewPunchAngle)
        client:SetAnimation(PLAYER_ATTACK1)

        local anim = "fists_left"
        if math.random(1, 2) == 1 then anim = "fists_right" end
        if self:GetCombo() >= 2 then anim = "fists_uppercut" end

        local vm = client:GetViewModel()
        vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))

        self:EmitSound(SwingSound)

        self:UpdateNextIdle()
        self:SetNextMeleeAttack(CurTime() + 0.2)

        self:SetNextPrimaryFire(CurTime() + 0.4)
        self:SetNextSecondaryFire(CurTime() + 0.4)
    else
        local data = {}
        data.start = client:GetShootPos()
        data.endpos = data.start + client:GetAimVector() * 84
        data.filter = {self, client}

        local trace = util.TraceLine(data)
        local entity = trace.Entity

        if SERVER and IsValid(entity) then
            if entity:IsDoor() then
                if (!client.doorSpam or CurTime() >= client.doorSpam) then
                    client.doorSpam = CurTime() + 2

                    local s, _ = table.Random(SoundList)
                    client:EmitSound(s)
                end
            else
                if self:CanHoldObject(entity) then
                    client:SetLocalVar("bIsHoldingObject", true)
                    self:PickupObject(entity)
                    self:PlayPickupSound(trace.SurfaceProps)
                    self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
                end
            end
        end
    end
end

function SWEP:SecondaryAttack()
    if !IsFirstTimePredicted() then return end

    local client = self:GetOwner()

    local data = {}
    data.start = client:GetShootPos()
    data.endpos = data.start + client:GetAimVector() * 84
    data.filter = {self, client}

    local trace = util.TraceLine(data)
    local entity = trace.Entity

    if SERVER and IsValid(entity) and self:CanHoldObject(entity) then
        client:SetLocalVar("bIsHoldingObject", true)
        self:PickupObject(entity)
        self:PlayPickupSound(trace.SurfaceProps)
        self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
    end
end

function SWEP:PlayPickupSound(surfaceProperty)
    local client = self:GetOwner()
    local result = "Flesh.ImpactSoft"

    if surfaceProperty != nil then
        local surfaceName = util.GetSurfacePropName(surfaceProperty)
        local soundName = surfaceName:gsub("^metal$", "SolidMetal") .. ".ImpactSoft"

        if (sound.GetProperties(soundName)) then
            result = soundName
        end
    end

    client:SendLua([[asterionlib.EmitSound("]] .. result .. [[", 75, 100, 40)]])
end

function SWEP:PickupObject(entity)
    if self:IsHoldingObject() or !IsValid(entity) or !IsValid(entity:GetPhysicsObject()) then return end

    local client = self:GetOwner()

    local physics = entity:GetPhysicsObject()
    physics:EnableGravity(false)
    physics:AddGameFlag(FVPHYSICS_PLAYER_HELD)

    entity._HeldOwner = client
    entity._CollisionGroup = entity:GetCollisionGroup()
    entity:StartMotionController()
    entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)

    self.heldObjectAngle = entity:GetAngles()
    self.heldEntity = entity

    self.holdEntity = ents.Create("prop_physics")
    self.holdEntity:SetPos(self.heldEntity:LocalToWorld(self.heldEntity:OBBCenter()))
    self.holdEntity:SetAngles(self.heldEntity:GetAngles())
    self.holdEntity:SetModel("models/weapons/w_bugbait.mdl")
    self.holdEntity:SetOwner(client)

    self.holdEntity:SetNoDraw(true)
    self.holdEntity:SetNotSolid(true)
    self.holdEntity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
    self.holdEntity:DrawShadow(false)
    self.holdEntity:Spawn()

    local trace = client:GetEyeTrace()
    local physicsObject = self.holdEntity:GetPhysicsObject()

    if IsValid(physicsObject) then
        physicsObject:SetMass(2048)
        physicsObject:SetDamping(0, 1000)
        physicsObject:EnableGravity(false)
        physicsObject:EnableCollisions(false)
        physicsObject:EnableMotion(false)
    end

    if trace.Entity:IsRagdoll() then
        local tracedEnt = trace.Entity

        self.holdEntity:SetPos(tracedEnt:GetBonePosition(tracedEnt:TranslatePhysBoneToBone(trace.PhysicsBone)))
    end

    self.constraint = constraint.Weld(self.holdEntity, self.heldEntity, 0, trace.Entity:IsRagdoll() and trace.PhysicsBone or 0, 0, true, true)
end

function SWEP:DropObject(bThrow)
    local client = self:GetOwner()
    if !IsValid(self.heldEntity) or self.heldEntity._HeldOwner != client then return end

    self.lastPlayerAngles = nil
    client:SetLocalVar("bIsHoldingObject", false)

    self.constraint:Remove()
    self.holdEntity:Remove()

    self.heldEntity:StopMotionController()
    self.heldEntity:SetCollisionGroup(self.heldEntity._CollisionGroup or COLLISION_GROUP_NONE)

    local physics = self:GetHeldPhysicsObject()
    physics:EnableGravity(true)
    physics:Wake()
    physics:ClearGameFlag(FVPHYSICS_PLAYER_HELD)

    if bThrow then
        timer.Simple(0, function()
            if IsValid(physics) and IsValid(client) then
                physics:AddGameFlag(FVPHYSICS_WAS_THROWN)
                physics:ApplyForceCenter(client:GetAimVector() * 4500)

                client:ViewPunch(self.KnockViewPunchAngle)
                client:PlayAnimation(GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND, true)
            end
        end)
    end

    self.heldEntity._HeldOwner = nil
    self.heldEntity._CollisionGroup = nil
    self.heldEntity = nil
end

function SWEP:GetHeldPhysicsObject()
    return IsValid(self.heldEntity) and self.heldEntity:GetPhysicsObject() or nil
end

function SWEP:CanHoldObject(entity)
    if entity:IsPlayer() then return false end

    local physics = entity:GetPhysicsObject()

    return IsValid(physics) and (physics:GetMass() <= 200 and physics:IsMoveable()) and !self:IsHoldingObject() and !IsValid(entity._HeldOwner)
end

function SWEP:IsHoldingObject()
    return IsValid(self.heldEntity) and IsValid(self.heldEntity._HeldOwner) and self.heldEntity._HeldOwner == self:GetOwner()
end

function SWEP:Reload()
    if !IsFirstTimePredicted() then return end

    local client = self:GetOwner()
    if !client:KeyPressed(IN_RELOAD) then return end

    if client:GetLocalVar("bIsHoldingObject", false) then
        if SERVER then
            self:DropObject()
        end
    else
        self:SetAttack(!self:GetAttack())

        timer.Simple(0, function()
            self:ChangeType()
        end)
    end
end

function SWEP:ChangeType()
    local client = self:GetOwner()
    local data = self:GetAttack()

    self:SetHoldType(data and "fist" or "normal")

    if data then
        local vm = client:GetViewModel()

        vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"))
        vm:SetPlaybackRate(1)
    end
end

function SWEP:ShouldDrawViewModel()
    return self:GetAttack()
end

function SWEP:DealDamage()
    local client = self:GetOwner()
    local anim = self:GetSequenceName(client:GetViewModel():GetSequence())

    client:LagCompensation(true)

    local tr = util.TraceLine({
        start = client:GetShootPos(),
        endpos = client:GetShootPos() + client:GetAimVector() * self.HitDistance,
        filter = client,
        mask = MASK_SHOT_HULL
    })

    if !IsValid(tr.Entity) then
        tr = util.TraceHull({
            start = client:GetShootPos(),
            endpos = client:GetShootPos() + client:GetAimVector() * self.HitDistance,
            filter = client,
            mins = Vector( -10, -10, -8 ),
            maxs = Vector( 10, 10, 8 ),
            mask = MASK_SHOT_HULL
        })
    end

    if tr.Hit and !(game.SinglePlayer() and CLIENT) then
        self:EmitSound(HitSound)
    end

    local hit = false
    local scale = 1

    if SERVER and IsValid(tr.Entity) and (tr.Entity:IsNPC() or tr.Entity:IsPlayer() or tr.Entity:Health() > 0) then
        local attacker = client
        if !IsValid(attacker) then attacker = self end

        local dmginfo = DamageInfo()
        dmginfo:SetAttacker(attacker)
        dmginfo:SetInflictor(self)
        dmginfo:SetDamage(1)

        tr.Entity:TakeDamageInfo(dmginfo)

        local direction = client:GetAimVector() * 100
        direction.z = 0

        tr.Entity:SetVelocity(direction)

        if tr.Entity:IsPlayer() then
            tr.Entity:ViewPunch(self.KnockViewPunchAngle)
        end

        hit = true
    end

    if IsValid(tr.Entity) then
        local phys = tr.Entity:GetPhysicsObject()

        if IsValid(phys) then
            phys:ApplyForceOffset(client:GetAimVector() * 80 * phys:GetMass() * scale, tr.HitPos)
        end
    end

    if SERVER then
        if (hit and anim != "fists_uppercut") then
            self:SetCombo(self:GetCombo() + 1)
        else
            self:SetCombo(0)
        end
    end

    client:LagCompensation(false)
end

function SWEP:OnDrop()
    self:Remove()
end

function SWEP:Deploy()
    local client = self:GetOwner()
    local speed = 4

    local vm = client:GetViewModel()
    vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"))
    vm:SetPlaybackRate(speed)

    self:SetNextPrimaryFire(CurTime() + vm:SequenceDuration() / speed)
    self:SetNextSecondaryFire(CurTime() + vm:SequenceDuration() / speed)
    self:UpdateNextIdle()

    if SERVER then
        self:SetCombo( 0 )
    end

    return true
end

function SWEP:Holster()
    self:SetNextMeleeAttack(0)
    self:SetHoldType("normal")
    self:SetAttack(false)

    return true
end

function SWEP:Think()
    local client = self:GetOwner()

    local idletime = self:GetNextIdle()
    if idletime > 0 and CurTime() > idletime then
        local vm = client:GetViewModel()

        vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_idle_0" .. math.random(1, 2)))
        self:UpdateNextIdle()
    end

    local meleetime = self:GetNextMeleeAttack()
    if meleetime > 0 and CurTime() > meleetime then
        self:DealDamage()
        self:SetNextMeleeAttack(0)
    end

    if SERVER and CurTime() > self:GetNextPrimaryFire() + 0.1 then
        self:SetCombo(0)
    end

    if !IsValid(client) then return end
    if SERVER then
        if self:IsHoldingObject() then
            local physics = self:GetHeldPhysicsObject()
            local bIsRagdoll = self.heldEntity:IsRagdoll()
            local holdDistance = bIsRagdoll and self.holdDistance * 0.5 or self.holdDistance
            local targetLocation = client:GetShootPos() + client:GetForward() * holdDistance

            if bIsRagdoll then
                targetLocation.z = math.min(targetLocation.z, client:GetShootPos().z - 32)
            end

            if !IsValid(physics) then return self:DropObject() end

            if (physics:GetPos():DistToSqr(targetLocation) > self.maxHoldDistanceSquared) then
                self:DropObject()
            else
                local physicsObject = self.holdEntity:GetPhysicsObject()
                local currentPlayerAngles = client:EyeAngles()

                if client:KeyDown(IN_ATTACK2) then
                    local cmd = client:GetCurrentCommand()

                    self.heldObjectAngle:RotateAroundAxis(currentPlayerAngles:Forward(), cmd:GetMouseX() / 15)
                    self.heldObjectAngle:RotateAroundAxis(currentPlayerAngles:Right(), cmd:GetMouseY() / 15)
                end

                self.lastPlayerAngles = self.lastPlayerAngles or currentPlayerAngles
                self.heldObjectAngle.y = self.heldObjectAngle.y - math.AngleDifference(self.lastPlayerAngles.y, currentPlayerAngles.y)
                self.lastPlayerAngles = currentPlayerAngles

                physicsObject:Wake()
                physicsObject:ComputeShadowControl({
                    secondstoarrive = 0.01,
                    pos = targetLocation,
                    angle = self.heldObjectAngle,
                    maxangular = 256,
                    maxangulardamp = 10000,
                    maxspeed = 256,
                    maxspeeddamp = 10000,
                    dampfactor = 0.8,
                    teleportdistance = self.maxHoldDistance * 0.75,
                    deltatime = FrameTime()
                })

                if (physics:GetStress() > self.maxHoldStress) then
                    self:DropObject()
                end
            end

            if !IsValid(self.heldEntity) and client:GetLocalVar("bIsHoldingObject", true) then
                client:SetLocalVar("bIsHoldingObject", false)
            end
        end
    end
end

if CLIENT then
    local allowedHoldableClasses = {
        ["arb_item"] = true,
        ["prop_physics"] = true,
        ["prop_physics_override"] = true,
        ["prop_physics_multiplayer"] = true,
        ["prop_ragdoll"] = true
    }

    function SWEP:DrawHUD()
        local client = LocalPlayer()
        if client.GetSitting and client:GetSitting() then return end
        if client:IsSpectating() then return end

        if client:GetLocalVar("bIsHoldingObject", false) then
            Hints:AddKeyDraw("Отпустить объект", "+reload")
            Hints:AddKeyDraw("Кинуть объект", MOUSE_LEFT)
            Hints:AddKeyDraw("Крутить объект вокруг оси", MOUSE_RIGHT)
        else
            local isAttack = self:GetAttack()
            Hints:AddKeyDraw((isAttack and "Опустить" or "Поднять") .. " руки", "+reload")

            local data = {}
            data.start = client:GetShootPos()
            data.endpos = data.start + client:GetAimVector() * 84
            data.filter = {self, client}

            local trace = util.TraceLine(data)
            local entity = trace.Entity

            if IsValid(entity) then
                if allowedHoldableClasses[entity:GetClass()] then
                    Hints:AddKeyDraw("Поднять объект", MOUSE_RIGHT)
                elseif entity:IsDoor() and !isAttack then
                    Hints:AddKeyDraw("Постучать в дверь", MOUSE_LEFT)
                end
            end
        end
    end
end