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

local PLUGIN = PLUGIN

PLUGIN.isAllow = false

-- Localize Global Calls
local PLAYER = FindMetaTable("Player")
local ENTITY = FindMetaTable("Entity")
local VECTOR = FindMetaTable("Vector")
local CUSERCMD = FindMetaTable("CUserCmd")

local IsValid = IsValid
local RealFrameTime = RealFrameTime
local LerpAngle = LerpAngle
local Angle = Angle
local math_Approach = math.Approach
local Lerp = Lerp
local math_Clamp = math.Clamp
local Vector = Vector
local util_TraceLine = util.TraceLine
local select = select
local concommand_Add = concommand.Add
local timer_Simple = timer.Simple

local IsNocliping = PLAYER.IsNocliping
local oldAlive = PLAYER.oldAlive
local IsPlaying = PLAYER.IsPlaying
local IsPlayingTaunt = PLAYER.IsPlayingTaunt
local IsSpectating = PLAYER.IsSpectating
local GetActiveWeapon = PLAYER.GetActiveWeapon
local GetAction = PLAYER.GetAction
local InVehicle = PLAYER.InVehicle
local Team = PLAYER.Team
local GetAimVector = PLAYER.GetAimVector
local KeyDown = PLAYER.KeyDown
local HasTemporaryStatusEffect = PLAYER.HasTemporaryStatusEffect
local SetEyeAngles = PLAYER.SetEyeAngles

local GetNetVar = ENTITY.GetNetVar
local GetClass = ENTITY.GetClass
local GetAttachment = ENTITY.GetAttachment
local LookupAttachment = ENTITY.LookupAttachment
local EyeAngles = ENTITY.EyeAngles
local GetVelocity = ENTITY.GetVelocity
local GetRight = ENTITY.GetRight

local Length2D = VECTOR.Length2D

local GetViewAngles = CUSERCMD.GetViewAngles
local SetViewAngles = CUSERCMD.SetViewAngles
timer_Simple(0, function() -- overwrite gamemodes...
	IsNocliping = PLAYER.IsNocliping
	oldAlive = PLAYER.oldAlive
	IsPlaying = PLAYER.IsPlaying
	IsSpectating = PLAYER.IsSpectating
	GetAction = PLAYER.GetAction
	HasTemporaryStatusEffect = PLAYER.HasTemporaryStatusEffect
end)


PLUGIN.name = "First Person"

local ViewOffsetUp = 0
local ViewOffsetForward = 3
local ViewOffsetForward2 = 0
local ViewOffsetLeftRight = 0
local RollDependency = 0.1
local CurView = nil
local traceHit = false
local eyeAtt

local d_weapon = {
	["gmod_tool"] = true,
	["weapon_physgun"] = true
}

local weaponData = {
	["weapon_physgun"] = true,
	["gmod_tool"] = true,
	["academy_key"] = true,
	["academy_first"] = true,
	["weapon_broom"] = true
}

local function allow()
	local client = LocalPlayer()

	if Arbitrage.IsThirdPerson() then return false end
	if Arbitrage.lawEnable then return false end
	if IsNocliping(client) then return false end
	if GetNetVar(client, "inbed") then return false end

	if !IsValid(client) then return true end
	if !oldAlive(client) then return false end
	if !IsPlaying(client) then return false end
	if IsPlayingTaunt(client) then return false end
	if IsSpectating(client) then return false end

	local weapon = GetActiveWeapon(client)
	if !IsValid(weapon) then return true end

	local class = GetClass(weapon)
	if !class then return true end

	if class == "academy_first" and weapon:GetAttack() then
		return false
	end

	local bThirdPerson = select(3, GetAction(client))
	if bThirdPerson then return false end

	if d_weapon[class] then return false end

	return weaponData[class]
end

function PLUGIN:ShouldDrawLocalPlayer()
	if !self.isAllow then return end

	if traceHit and !InVehicle(LocalPlayer()) then
		return false
	else
		return true
	end
end

local fovShift = 0
function PLUGIN:CalcView(client, pos, angles, fov)
	Flashlight:FlashlightDraw(client)

	if !self.isAllow then return end

	local cameraPos = nil
	local character = Character.team.instances[Team(client)]
	if character then
		local characterCameraPos = character.cameraPos
		if characterCameraPos then
			cameraPos = characterCameraPos
		end
	end

	eyeAtt = GetAttachment(client, LookupAttachment(client, "eyes"))
	local forwardVec = GetAimVector(client)
	local FT = RealFrameTime()
	local eyeAngles = EyeAngles(client)

	if (traceHit and !InVehicle(client)) or !eyeAtt then
		return
	end

	local camera_smoothness = SETTINGS.options.Get("camera_smoothness")

	if !CurView then
		CurView = angles
	else
		CurView = LerpAngle(FT * camera_smoothness, CurView, angles + Angle(0, 0, eyeAtt.Ang.r * RollDependency))
	end

	if camera_smoothness >= 25 then
		CurView = angles + Angle(0, 0, eyeAtt.Ang.r * RollDependency)
	end

	ViewOffsetLeftRight = math_Approach(ViewOffsetLeftRight, 0, 0.5)

	local view = {}

	ViewOffsetUp = math_Approach(ViewOffsetUp, math_Clamp(eyeAngles.p * -0.1, 0, 10), 0.5)
	ViewOffsetForward = math_Approach(ViewOffsetForward, 5 + math_Clamp(eyeAngles.p * 0.1, 0, 5), 0.5)
	RollDependency = Lerp(FT * 15, RollDependency, 0.05)

	if eyeAtt then
		view.origin = eyeAtt.Pos + (Vector(forwardVec.x * (ViewOffsetForward + ViewOffsetForward2), forwardVec.y * (ViewOffsetForward + ViewOffsetForward2 - 0.3), 0)) + Vector(0, 0, ViewOffsetUp) + GetRight(client) * ViewOffsetLeftRight
		view.angles = CurView

		local shift = Length2D(GetVelocity(client)) * 0.02
		local value = 0
		if KeyDown(client, IN_FORWARD) then
			value = shift
		elseif KeyDown(client, IN_BACK) then
			value = -shift
		end

		if HasTemporaryStatusEffect(client, "berserk") then
			value = value + 15
		end

		value = math_Clamp(value, -8, 8)
		fovShift = Lerp(FT * 3, fovShift, value)

		if cameraPos then
			view.origin = view.origin + cameraPos
		end

		view.fov = fov + fovShift

		return view
	end
end

function PLUGIN:Think()
	self.isAllow = allow()
	if !self.isAllow then return end

	local client = LocalPlayer()
	if eyeAtt then
		local forwardVec = GetAimVector(client)

		local tr = {}
		tr.start = eyeAtt.Pos
		tr.endpos = tr.start + Vector(forwardVec.x, forwardVec.y, 0) * 20
		tr.filter = client

		local trace = util_TraceLine(tr)
		if trace.Hit then
			traceHit = true
		else
			traceHit = false
		end
	end
end


function PLUGIN:CreateMove(ucmd)
	if !self.isAllow then return end

	local m = 75 -- LocalPlayer():Team() == TEAM_HIFUMI and 55 or 75
	local s = 90 -- LocalPlayer():Team() == TEAM_MONDO and 32 or 90

	local eyeAng = GetViewAngles(ucmd)
	SetViewAngles(ucmd, Angle(math_Clamp(eyeAng.p, -s, m), eyeAng.y, eyeAng.r))
end


concommand_Add("arb_camerafix", function(client, cmd, args)
	local ang = EyeAngles()

	SetEyeAngles(client, Angle(ang.p, ang.y, 0))
end)