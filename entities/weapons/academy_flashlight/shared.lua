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


AddCSLuaFile()

if CLIENT then
    SWEP.Slot = 1
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
end

SWEP.PrintName = "#weapons_flashlight"
SWEP.Author = "Selenter"
SWEP.Instructions = "Левый клик - Включить/Выключить фонарик"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "Asterion: Arbitrage"

SWEP.ViewModel = "models/weapons/c_flashlight_zm.mdl"
SWEP.WorldModel = "models/weapons/w_flashlight_zm.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Damage = 10
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:SetupDataTables()
    self:NetworkVar("Float", 0, "NextIdle")
    self:NetworkVar("Float", 1, "NextPrimaryFire")
end

function SWEP:Initialize()
    self:SetHoldType("slam")
end

function SWEP:OnDrop()
    if CLIENT then return end

    local client = self:GetOwner()
    Flashlight:RemovePlayerFlashlight(client)
end

function SWEP:Holster(wep)
    if SERVER then
        local client = self:GetOwner()
        Flashlight:RemovePlayerFlashlight(client)
    end

    return true
end

function SWEP:PrimaryAttack()
    local client = self:GetOwner()
    local vm = client:GetViewModel()
    vm:SendViewModelMatchingSequence( vm:LookupSequence("trigger"))

    self:SetNextIdle(CurTime() + vm:SequenceDuration() - 0.2)
    self:SetNextPrimaryFire(CurTime() + 1)

    if SERVER then
        Flashlight:Active(client)
    end
end

function SWEP:SecondaryAttack()
    local client = self:GetOwner()
    local vm = client:GetViewModel()
    vm:SendViewModelMatchingSequence( vm:LookupSequence("trigger"))

    self:SetNextIdle(CurTime() + vm:SequenceDuration() - 0.2)
    self:SetNextPrimaryFire(CurTime() + 1)

    if SERVER then
        Flashlight:Active(client)
    end
end

function SWEP:Think()
    local client = self:GetOwner()
    local vm = client:GetViewModel()

    if self:GetNextIdle() != 0 and self:GetNextIdle() < CurTime() then
        vm:SendViewModelMatchingSequence(vm:LookupSequence("idle01"))
        self:SetNextIdle(0)
    end
end

function SWEP:Deploy()
    self:SetNextPrimaryFire(CurTime() + 0.835)

    local client = self:GetOwner()
    local vm = client:GetViewModel()
    vm:SendViewModelMatchingSequence(vm:LookupSequence("draw"))

    self:SetNextIdle(CurTime() + vm:SequenceDuration())

    if SERVER then
        Flashlight:Active(client)
    end

    return true
end

function SWEP:OnRemove()
    if CLIENT then return end

    local client = self:GetOwner()
    Flashlight:RemovePlayerFlashlight(client)
end

function SWEP:DrawHUD()
    local client = LocalPlayer()

    Hints:AddKeyDraw(client:GetLocalVar("sharedflashlight") and "#hintsdraw_flashlight_off" or "#hintsdraw_flashlight_on", MOUSE_LEFT)
end