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

SWEP.PrintName = "Камера"
SWEP.Author = ""
SWEP.Instructions = ""
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModel = Model("models/weapons/c_arms_animations.mdl")
SWEP.WorldModel = Model("models/MaxOfS2D/camera.mdl")

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "Asterion: Arbitrage"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

if SERVER then
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
end

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "Zoom")
	self:NetworkVar("Float", 1, "Roll")

	if SERVER then
		self:SetZoom(70)
		self:SetRoll(0)
	end
end

function SWEP:Initialize()
	self:SetHoldType("camera")
end

function SWEP:Reload()
	if !self.Owner:KeyDown(IN_ATTACK2) then
		self:SetZoom(75)
	end

	self:SetRoll(0)
end

function SWEP:PrimaryAttack()
	if SERVER then return end
	if !IsFirstTimePredicted() then return end

	local client = self.Owner

	local cmd = client:GetCurrentCommand()
	if cmd:KeyDown(IN_USE) then
		Arbitrage.notify.NotifyChat("Вы " .. (self.isFlash and "включили" or "выключили") .. " вспышку от фотоаппарата!")
		self.isFlash = !self.isFlash
	else
		netstream.Start("Photos:Request", !self.isFlash)
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Tick()
	local client = self.Owner
	if CLIENT and client != LocalPlayer() then return end

	local cmd = client:GetCurrentCommand()
	if cmd:KeyDown(IN_ATTACK2) then
		self:SetZoom(math.Clamp(self:GetZoom() + cmd:GetMouseY() * FrameTime() * 6.6, 5, 95))
		self:SetRoll(self:GetRoll() + cmd:GetMouseX() * FrameTime() * 1.65)
	end
end

function SWEP:TranslateFOV(fov)
	return self:GetZoom()
end

function SWEP:Deploy()
	return true
end

function SWEP:Equip()
	if self:GetZoom() == 70 and self.Owner:IsPlayer() and !self.Owner:IsBot() then
		self:SetZoom(75)
	end
end

function SWEP:ShouldDropOnDie()
	return false
end

if SERVER then return end

function SWEP:FreezeMovement()
	if self.Owner:KeyDown(IN_ATTACK2) or self.Owner:KeyReleased(IN_ATTACK2) then
		return true
	end

	return false
end

function SWEP:CalcView(client, origin, angles, fov)
	if self:GetRoll() != 0 then
		angles.Roll = self:GetRoll()
	end

	return origin, angles, fov
end

function SWEP:AdjustMouseSensitivity()
	if self.Owner:KeyDown(IN_ATTACK2) then return 1 end

	return self:GetZoom() / 80
end