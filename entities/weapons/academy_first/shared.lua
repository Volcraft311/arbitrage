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


AddCSLuaFile()

if CLIENT then
    SWEP.Slot = 1
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
end

SWEP.PrintName = "Руки"
SWEP.Author = ""
SWEP.Instructions = "Левая клик - Закрыть дверь\nПравый клик - Открыть дверь\nR - Поднять руки"
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

SWEP.Secondary.Delay = 0.3
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.DrawAmmo = false
SWEP.HitDistance = 48
SWEP.KnockViewPunchAngle = Angle(-1.3, 1.8, 0)

local SoundList = {"knocking.wav", "loud_knocking.wav"}
local SwingSound = Sound("WeaponFrag.Throw")
local HitSound = Sound("Flesh.ImpactHard")

function SWEP:Initialize()
    self:SetHoldType("normal")
    self:SetAttack(false)
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
    local client = self:GetOwner()
    local right = math.random(1, 2) == 1 and true or false

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
        if right then anim = "fists_right" end
        if self:GetCombo() >= 2 then anim = "fists_uppercut" end

        local vm = client:GetViewModel()
        vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))

        self:EmitSound(SwingSound)

        self:UpdateNextIdle()
        self:SetNextMeleeAttack(CurTime() + 0.2)

        self:SetNextPrimaryFire(CurTime() + 0.4)
        self:SetNextSecondaryFire(CurTime() + 0.4)
    else
        local trace = client:GetEyeTraceNoCursor()
        local entity = trace.Entity

        if SERVER and entity:GetPos():Distance(client:GetPos()) <= 100 and entity:IsDoor() then
            if (!client.doorSpam or CurTime() >= client.doorSpam) then
                client.doorSpam = CurTime() + 2

                local s, _ = table.Random(SoundList)
                client:EmitSound(s)
            end
        else
            hook.Run("ArcadeFistsSecondary", self:GetOwner())
        end
    end
end

function SWEP:SecondaryAttack()
    hook.Run("ArcadeFistsSecondary", self:GetOwner())
end

function SWEP:Reload()
    local client = self:GetOwner()
    if !client:KeyPressed(IN_RELOAD) then return end

    self:SetAttack(!self:GetAttack())
    self:ChangeType()
end

function SWEP:ChangeType()
    local client = self:GetOwner()
    local data = self:GetAttack()

    self:SetHoldType(data and "fist" or "normal")

    local speed = 1

    if data then
        local vm = client:GetViewModel()
        vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"))
        vm:SetPlaybackRate(speed)
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

        vm:SendViewModelMatchingSequence(vm:LookupSequence( "fists_idle_0" .. math.random(1, 2)))
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
end

if CLIENT then
    function SWEP:DrawHUD()
        local client = LocalPlayer()
        if client.GetSitting and client:GetSitting() then return end

        local isAttack = self:GetAttack()
        Hints:AddKeyDraw((isAttack and "Опустить" or "Поднять") .. " руки", "+reload")

        local t_entity = client:GetEyeTrace().Entity
        if (IsValid(t_entity) and t_entity:GetClass() == "prop_physics" and t_entity:GetPos():DistToSqr(EyePos()) < 15000) or client:KeyDown(IN_ATTACK2) then
            Hints:AddKeyDraw("Тянуть", MOUSE_RIGHT)
        end

        if !isAttack then
            if IsValid(t_entity) and t_entity:IsDoor() and t_entity:GetPos():DistToSqr(EyePos()) < 6000 then
                Hints:AddKeyDraw("Постучать в дверь", MOUSE_LEFT)
            end
        end

        if IsValid(client:GetVehicle()) then return end

        local data = client:GetLocalVar("owner")
        if !data then return end

        local pos = data[1]
        local entity = data[2]

        if entity and IsValid(entity) and (client:KeyDown(IN_ATTACK) or client:KeyDown(IN_ATTACK2)) then
            self.dragentity = entity

            local pos2 = entity:LocalToWorld(pos)

            local data2D = pos2:ToScreen()
            if !data2D.visible then return end

            local x = data2D.x
            local y = data2D.y

            local traceNew = Vector(Arbitrage.hud.lerpX, Arbitrage.hud.lerpY, Arbitrage.hud.lerpZ):ToScreen()

            surface.SetDrawColor(255, 61, 96)
            surface.DrawLine(x, y, traceNew.x, traceNew.y)
        else
            self.dragentity = nil
        end
    end
end