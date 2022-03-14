SWEP.Base = "tfa_nmrimelee_base"
SWEP.Category = "Asterion: Arbitrage"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.DamageType = "Удар тупым предметом"

SWEP.PrintName = "Монтировка"

SWEP.ViewModel			= "models/weapons/tfa_nmrih/v_me_crowbar.mdl" --Viewmodel path
SWEP.ViewModelFOV = 50

SWEP.WorldModel			= "models/weapons/tfa_nmrih/w_me_crowbar.mdl" --Viewmodel path
SWEP.HoldType = "melee"
SWEP.DefaultHoldType = "melee"
SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = -6,
        Right = 1.5,
        Forward = 3.5,
        },
        Ang = {
        Up = -1,
        Right = 5,
        Forward = 178
        },
		Scale = 1.0
}

SWEP.AnimSequences = {
	attack_quick = "",
	--attack_quick2 = "Attack_Quick2",
	charge_begin = "Attack_Charge_Begin",
	charge_loop = "Attack_Charge_Idle",
	charge_end = "Attack_Charge_End",
	turn_on = "TurnOn",
	turn_off = "TurnOff",
	idle_on = "IdleOn",
	attack_enter = "Idle_To_Attack",
	attack_loop = "Attack_On",
	attack_exit = "Attack_To_Idle"
}

SWEP.Primary.Sound = Sound("Weapon_Melee.CrowbarLight")
SWEP.Secondary.Sound = Sound("Weapon_Melee.CrowbarHeavy")

SWEP.MoveSpeed = 0.8
SWEP.IronSightsMoveSpeed  = SWEP.MoveSpeed

SWEP.InspectPos = Vector(-3.086, -6.5, 7.236)
SWEP.InspectAng = Vector(-8.443, 11.651, 12.725)

SWEP.Primary.Blunt = true
SWEP.Primary.Damage = 0
SWEP.Primary.Reach = 0
SWEP.Primary.RPM = 60
SWEP.Primary.SoundDelay = 0.15
SWEP.Primary.Delay = 0.3
SWEP.Primary.Window = 0.2

SWEP.Secondary.Blunt = true
SWEP.Secondary.RPM = 60 -- Delay = 60/RPM, this is only AFTER you release your heavy attack
SWEP.Secondary.Damage = 75
SWEP.Secondary.Reach = 50	
SWEP.Secondary.SoundDelay = 0.1
SWEP.Secondary.Delay = 0.3

SWEP.Secondary.BashDamage = 0
SWEP.Secondary.BashDelay = 0.35
SWEP.Secondary.BashLength = 50