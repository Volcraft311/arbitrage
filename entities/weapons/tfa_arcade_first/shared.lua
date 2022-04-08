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
SWEP.ViewModel = Model( "models/weapons/c_arms.mdl" )

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

local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )

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
    local vm = self.Owner:GetViewModel()
    self:SetNextIdle( CurTime() + vm:SequenceDuration() / vm:GetPlaybackRate() )
end

function SWEP:PrimaryAttack()
    local right = math.random(1, 2) == 1 and true or false

    if self:GetAttack() then
        local client = self:GetOwner()

        local stamina = client:GetNetVar("stm", 100)
        if stamina <= 4 then return end

        if SERVER then
            client:SetNetVar("stm", math.Clamp(stamina - 4, 0, 100), client)
            client.StaminaCD = CurTime() + 2
        end

        self.Owner:SetAnimation(PLAYER_ATTACK1)

        local anim = "fists_left"
        if ( right ) then anim = "fists_right" end
        if ( self:GetCombo() >= 2 ) then
            anim = "fists_uppercut"
        end

        local vm = self.Owner:GetViewModel()
        vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))

        self:EmitSound(SwingSound)

        self:UpdateNextIdle()
        self:SetNextMeleeAttack(CurTime() + 0.2)

        self:SetNextPrimaryFire(CurTime() + 0.4)
        self:SetNextSecondaryFire(CurTime() + 0.4)
    else
        hook.Run("ArcadeFistsSecondary", self:GetOwner())
    end
end

function SWEP:Reload()
    local client = self:GetOwner()
    if !client:KeyPressed(IN_RELOAD) then return end

    self:SetAttack(!self:GetAttack())
    self:ChangeType()
end

function SWEP:ChangeType()
    local data = self:GetAttack()

    self:SetHoldType(data and "fist" or "normal")

    local speed = 1

    if data then
        local vm = self.Owner:GetViewModel()
        vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"))
        vm:SetPlaybackRate(speed)
    end
end

function SWEP:ShouldDrawViewModel()
    return self:GetAttack()
end

function SWEP:SecondaryAttack()
    hook.Run("ArcadeFistsSecondary", self:GetOwner())
end

local phys_pushscale = GetConVar( "phys_pushscale" )

function SWEP:DealDamage()
    local anim = self:GetSequenceName(self.Owner:GetViewModel():GetSequence())

    self.Owner:LagCompensation(true)

    local tr = util.TraceLine( {
        start = self.Owner:GetShootPos(),
        endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
        filter = self.Owner,
        mask = MASK_SHOT_HULL
    } )

    if ( !IsValid( tr.Entity ) ) then
        tr = util.TraceHull( {
            start = self.Owner:GetShootPos(),
            endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
            filter = self.Owner,
            mins = Vector( -10, -10, -8 ),
            maxs = Vector( 10, 10, 8 ),
            mask = MASK_SHOT_HULL
        } )
    end

    if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
        self:EmitSound( HitSound )
    end

    local hit = false
    local scale = phys_pushscale:GetFloat()

    if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) ) then
        local dmginfo = DamageInfo()

        local attacker = self.Owner
        if ( !IsValid( attacker ) ) then attacker = self end
        dmginfo:SetAttacker( attacker )

        dmginfo:SetInflictor( self )
        dmginfo:SetDamage( math.random( 8, 12 ) )

        if ( anim == "fists_left" ) then
            dmginfo:SetDamageForce( self.Owner:GetRight() * 4912 * scale + self.Owner:GetForward() * 9998 * scale )
        elseif ( anim == "fists_right" ) then
            dmginfo:SetDamageForce( self.Owner:GetRight() * -4912 * scale + self.Owner:GetForward() * 9989 * scale )
        elseif ( anim == "fists_uppercut" ) then
            dmginfo:SetDamageForce( self.Owner:GetUp() * 5158 * scale + self.Owner:GetForward() * 10012 * scale )
            dmginfo:SetDamage( math.random( 12, 24 ) )
        end

        SuppressHostEvents(NULL)
        tr.Entity:TakeDamageInfo(dmginfo)
        SuppressHostEvents(self.Owner)

        hit = true
    end

    if ( IsValid( tr.Entity ) ) then
        local phys = tr.Entity:GetPhysicsObject()
        if ( IsValid( phys ) ) then
            phys:ApplyForceOffset( self.Owner:GetAimVector() * 80 * phys:GetMass() * scale, tr.HitPos )
        end
    end

    if ( SERVER ) then
        if ( hit && anim != "fists_uppercut" ) then
            self:SetCombo( self:GetCombo() + 1 )
        else
            self:SetCombo( 0 )
        end
    end

    self.Owner:LagCompensation( false )
end

function SWEP:OnDrop()
    self:Remove()
end

function SWEP:Deploy()
    local speed = 4

    local vm = self.Owner:GetViewModel()
    vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_draw" ) )
    vm:SetPlaybackRate( speed )

    self:SetNextPrimaryFire( CurTime() + vm:SequenceDuration() / speed )
    self:SetNextSecondaryFire( CurTime() + vm:SequenceDuration() / speed )
    self:UpdateNextIdle()

    if ( SERVER ) then
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
    local vm = self.Owner:GetViewModel()
    local idletime = self:GetNextIdle()

    if ( idletime > 0 && CurTime() > idletime ) then
        vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_idle_0" .. math.random( 1, 2 ) ) )
        self:UpdateNextIdle()
    end

    local meleetime = self:GetNextMeleeAttack()

    if ( meleetime > 0 && CurTime() > meleetime ) then
        self:DealDamage()
        self:SetNextMeleeAttack(0)
    end

    if ( SERVER && CurTime() > self:GetNextPrimaryFire() + 0.1 ) then
        self:SetCombo(0)
    end
end

if CLIENT then
    function SWEP:DrawHUD()
        if IsValid( self:GetOwner():GetVehicle() ) then return end

        local client = self:GetOwner()

        local data = client:GetNetVar("owner")
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