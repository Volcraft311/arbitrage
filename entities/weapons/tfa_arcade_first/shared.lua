AddCSLuaFile()

if CLIENT then
    SWEP.Slot = 1
    SWEP.SlotPos = 1
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
end

SWEP.PrintName = "Руки"
SWEP.Author = "Selenter"
SWEP.Instructions = "Левая клик - Закрыть дверь\nПравый клик - Открыть дверь"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.WorldModel = ""
SWEP.ViewModel = ""

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

function SWEP:PrimaryAttack() hook.Run("ArcadeFistsSecondary", self:GetOwner()) end

function SWEP:SecondaryAttack()
    hook.Run("ArcadeFistsSecondary", self:GetOwner())
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

            local x = pos2:ToScreen().x
            local y = pos2:ToScreen().y

            local traceNew = Vector(Arbitrage.hud.lerpX, Arbitrage.hud.lerpY, Arbitrage.hud.lerpZ):ToScreen()

            surface.SetDrawColor(255, 61, 96)
            surface.DrawLine(x, y, traceNew.x, traceNew.y)
        else
            self.dragentity = nil
        end
    end
end

function SWEP:Initialize()
    self:SetHoldType("normal")
end