SWEP.Base = "tfa_nmrimelee_base"
SWEP.Category = "Asterion: Arbitrage"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.DamageType = "Удар холодным оружием"

SWEP.PrintName = "Тесак"

SWEP.ViewModel			= "models/weapons/tfa_nmrih/v_me_cleaver.mdl" --Viewmodel path
SWEP.ViewModelFOV = 50

SWEP.WorldModel			= "models/weapons/tfa_nmrih/w_me_cleaver.mdl" --Viewmodel path
SWEP.HoldType = "melee"
SWEP.DefaultHoldType = "melee"
SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = 0,
        Right = 0.5,
        Forward = -0.5,
        },
        Ang = {
        Up = -1,
        Right = 5,
        Forward = 178
        },
		Scale = 1.2
}

SWEP.Primary.Sound = Sound("Weapon_Melee.HatchetLight")
SWEP.Secondary.Sound = Sound("Weapon_Melee.HatchetHeavy")

SWEP.MoveSpeed = 0.975
SWEP.IronSightsMoveSpeed  = SWEP.MoveSpeed

SWEP.InspectPos = Vector(3.874, -13.436, 3.969)
SWEP.InspectAng = Vector(-7.27, 41.632, 4.92)

SWEP.Primary.Blunt = false
SWEP.Primary.Damage = 35
SWEP.Primary.Reach = 40
SWEP.Primary.RPM = 100
SWEP.Primary.SoundDelay = 0.15
SWEP.Primary.Delay = 0.3
SWEP.Primary.Window = 0.2

SWEP.Secondary.Blunt = false
SWEP.Secondary.RPM = 80 -- Delay = 60/RPM, this is only AFTER you release your heavy attack
SWEP.Secondary.Damage = 70
SWEP.Secondary.Reach = 45	
SWEP.Secondary.SoundDelay = 0.1
SWEP.Secondary.Delay = 0.3

function SWEP:SecondaryAttack( docharge, release ) end
function SWEP:AltAttack()
	hook.Run("TFA_Bash", self)

	if self:GetOwner().Vox and IsFirstTimePredicted() then
		self:GetOwner():Vox("bash", 0)
	end
end

SWEP.Secondary.BashDamage = 0
SWEP.Secondary.BashDelay = 0.2
SWEP.Secondary.BashLength = 50