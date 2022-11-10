AddCSLuaFile()

if CLIENT then
    SWEP.Slot = 1
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
end

SWEP.PrintName = "Монопад"
SWEP.Author = "Selenter"
SWEP.Instructions = ""
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.WorldModel = "models/props_junk/shovel01a.mdl"
SWEP.ViewModel = Model( "models/asterion/v_monopad.mdl" )

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

SWEP.UseHands = true

SWEP.Spawnable = false
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

SWEP.Edit = false
SWEP.m_forward = 10
SWEP.m_up = 0.6
SWEP.m_right = 0.5

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:SecondaryAttack()
    if SERVER then return end
    if !IsFirstTimePredicted() then return end

    self.Edit = !self.Edit
end

function SWEP:PrimaryAttack()
end

function SWEP:OnDrop()
    self:Remove()
end

function SWEP:Deploy()
    self.Edit = false
    local client = self:GetOwner()

    if SERVER then
        self:CreateTablet()

        local vm = client:GetViewModel()
        vm:SendViewModelMatchingSequence(vm:LookupSequence("deploy"))
        vm:SetPlaybackRate(1)

        local isEnabled = client.MonoPadEnable

        local id = "TabletTimer_" .. client:EntIndex()

        timer.Remove(id)
        timer.Create(id, 0.8, 1, function()
            if !self then return end

            if !isEnabled then
                vm:SendViewModelMatchingSequence(vm:LookupSequence("upgrade_drone"))
                vm:SetPlaybackRate(0.7)
            end

            timer.Remove(id)
            timer.Create(id, isEnabled and 0 or 4, 1, function()
                if !self then return end

                vm:SendViewModelMatchingSequence(vm:LookupSequence("idle"))
                self:EnableTablet(isEnabled)

                client.MonoPadEnable = true
            end)
        end)
    else
        self.WModel = nil
    end

    return true
end

function SWEP:Holster()
    self.Edit = false

    if SERVER then
        local client = self:GetOwner()

        local id = "TabletTimer_" .. client:EntIndex()
        timer.Remove(id)

        self:DisableTablet()
    end

    return true
end

if CLIENT then
    SWEP.Pos = Vector(-7, 0, 40)
    SWEP.Ang = Angle(90, 0, 0)

    function SWEP:CreateWorldModel()
        self.WorldModel = "models/monopad/monopad.mdl"

        if !self.WModel then
            self.WModel = ClientsideModel(self.WorldModel, RENDERGROUP_OPAQUE)
            self.WModel:SetNoDraw(true)
        end

        return self.WModel
    end

    function SWEP:UpdateLight(point)
        point = point + Vector(0, 0, 10)
        local light = DynamicLight(self:EntIndex())

        if light then
            light.pos = point
            light.outerangle = 0
            light.innerangle = 2
            light.r = 180
            light.g = 187
            light.b = 190
            light.size = 40
            light.brightness = 2
            light.style = 0
            light.dietime = CurTime() + 1
            light.decay = 40
        end
    end

    function SWEP:DrawWorldModel()
        local owner = self:GetOwner()

        if IsValid(owner) then
            local wm = self:CreateWorldModel()
            local bone = owner:LookupBone("ValveBiped.Bip01_R_Hand")
            local bone_f = owner:LookupBone("ValveBiped.Bip01_R_Hand")
            local _, ang = owner:GetBonePosition(bone)

            if bone then
                ang:RotateAroundAxis(ang:Right(), self.Ang.p)
                ang:RotateAroundAxis(ang:Forward(), self.Ang.y + 60 - 180 + 30)
                ang:RotateAroundAxis(ang:Up(), self.Ang.r)

                wm:SetRenderOrigin(owner:GetBonePosition(bone_f) + ang:Right() * self.Pos.x * 0.8 + ang:Forward() * self.Pos.y * -0.3 + ang:Up() * self.Pos.z * .3)
                wm:SetRenderAngles(ang)
                wm:DrawModel()
                wm:SetModelScale(0.8, 0)

                self:UpdateLight(owner:GetPos())
            end
        else
            self:DrawModel()
        end
    end

    function SWEP:Think()
        if CLIENT and self.Owner != LocalPlayer() then return end

        self:UpdateLight(LocalPlayer():GetPos())
    end

    function SWEP:GetViewModelPosition(pos, ang)
        local time = FrameTime() * 1.5

        local bApproximately = self.Edit

        if IsValid(self.panel) and !self.panel.isEnable then
            bApproximately = false
        end

        self.m_forward = Lerp(time, self.m_forward, bApproximately and 0 or 10)
        self.m_up = Lerp(time, self.m_up, bApproximately and -1.5 or -6)
        self.m_right = Lerp(time, self.m_right, bApproximately and 0 or 0.5)

        pos = pos + ang:Forward() * self.m_forward + ang:Up() * self.m_up + ang:Right() * self.m_right

        return pos, ang
    end

    local function FormatViewModelAttachment(nFOV, vOrigin, bFrom)
        local vEyePos = EyePos()
        local aEyesRot = EyeAngles()
        local vOffset = vOrigin - vEyePos
        local vForward = aEyesRot:Forward()

        local nViewX = math.tan(nFOV * math.pi / 360)

        if nViewX == 0 then
            vForward:Mul(vForward:Dot(vOffset))
            vEyePos:Add(vForward)

            return vEyePos
        end

        local nWorldX = math.tan(LocalPlayer():GetFOV() * math.pi / 360)

        if nWorldX == 0 then
            vForward:Mul(vForward:Dot(vOffset))
            vEyePos:Add(vForward)

            return vEyePos
        end

        local vRight = aEyesRot:Right()
        local vUp = aEyesRot:Up()

        if bFrom then
            local nFactor = nWorldX / nViewX

            vRight:Mul(vRight:Dot(vOffset) * nFactor)
            vUp:Mul(vUp:Dot(vOffset) * nFactor)
        else
            local nFactor = nViewX / nWorldX

            vRight:Mul(vRight:Dot(vOffset) * nFactor)
            vUp:Mul(vUp:Dot(vOffset) * nFactor)
        end

        vForward:Mul(vForward:Dot(vOffset))

        vEyePos:Add(vRight)
        vEyePos:Add(vUp)
        vEyePos:Add(vForward)

        return vEyePos
    end

    function SWEP:PostDrawViewModel()
        local ui = MonoPad:GetUI()
        if !IsValid(ui) then return end

        local client = self:GetOwner()
        if !client:IsValid() then return end

        local vm = client:GetViewModel()
        if !vm:IsValid() then return end

        local obj = vm:LookupAttachment("screen_ul")
        if obj < 1 then return end

        local attach = vm:GetAttachment(obj)
        if !attach then return end

        local nFOV = self.ViewModelFOV
        if !isnumber(nFOV) then nFOV = 62 end

        local pos = FormatViewModelAttachment(nFOV, attach.Pos, false)
        local ang = attach.Ang

        ang:RotateAroundAxis(ang:Up(), 180)
        ang:RotateAroundAxis(ang:Forward(), 90)
        ang:RotateAroundAxis(ang:Right(), 0)

        pos = pos + ang:Up() * 0.42 + ang:Forward() * -0.9 + ang:Right() * -0.2

        cam.Start3D2D(pos, ang, 0.01)
            MonoPad.clip:Scissor2D(ui:GetWide(), ui:GetTall())
                ui:PaintManual()
            MonoPad.clip()
        cam.End3D2D()
    end
else
    function SWEP:CreateTablet()
        netstream.Start(self:GetOwner(), "MonoPad:CreateTablet", self)
    end

    function SWEP:EnableTablet(bEnable)
        netstream.Start(self:GetOwner(), "MonoPad:EnableTablet", self, bEnable)
    end

    function SWEP:DisableTablet()
        netstream.Start(self:GetOwner(), "MonoPad:DisableTablet", self)
    end
end