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
local FrameTime = FrameTime
local concommand_Add = concommand.Add
local EyeAngles = EyeAngles

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
	if client:IsNocliping() then return false end
	if client:GetNetVar("inbed") then return false end

	if !IsValid(client) then return true end
	if !client:oldAlive() then return false end
	if !client:IsPlaying() then return false end
	if client:IsPlayingTaunt() then return false end
	if client:IsSpectating() then return false end

	local weapon = client:GetActiveWeapon()
	if !IsValid(weapon) then return true end

	local class = weapon:GetClass()
	if !class then return true end

	if class == "academy_first" and weapon:GetAttack() then
		return false
	end

	local bThirdPerson = select(3, client:GetAction())
	if bThirdPerson then return false end

	if d_weapon[class] then return false end

	return weaponData[class]
end

function PLUGIN:ShouldDrawLocalPlayer()
	if !self.isAllow then return end

	if traceHit and !LocalPlayer():InVehicle() then
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
	local character = Character.team.instances[client:Team()]
	if character then
		local characterCameraPos = character.cameraPos
		if characterCameraPos then
			cameraPos = characterCameraPos
		end
	end

	eyeAtt = client:GetAttachment(client:LookupAttachment("eyes"))
	local forwardVec = client:GetAimVector()
	local FT = RealFrameTime()
	local eyeAngles = client:EyeAngles()

	if (traceHit and !client:InVehicle()) or !eyeAtt then
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
	if client:WaterLevel() >= 3 then
		ViewOffsetUp = math_Approach(ViewOffsetUp, 0, 0.5)
		ViewOffsetForward = math_Approach(ViewOffsetForward, 8, 0.5)
		RollDependency = Lerp(FT * 15, RollDependency, 0.5)
	else
		ViewOffsetUp = math_Approach(ViewOffsetUp, math_Clamp(eyeAngles.p * -0.1, 0, 10), 0.5)
		ViewOffsetForward = math_Approach(ViewOffsetForward, 5 + math_Clamp(eyeAngles.p * 0.1, 0, 5), 0.5)
		RollDependency = Lerp(FT * 15, RollDependency, 0.05)
	end

	if eyeAtt then
		view.origin = eyeAtt.Pos + (Vector(forwardVec.x * (ViewOffsetForward + ViewOffsetForward2), forwardVec.y * (ViewOffsetForward + ViewOffsetForward2 - 0.3), 0)) + Vector(0, 0, ViewOffsetUp) + client:GetRight() * ViewOffsetLeftRight
		view.angles = CurView

		local shift = client:GetVelocity():Length2D() * 0.02
		local value = 0
		if client:KeyDown(IN_FORWARD) then
			value = shift
		elseif client:KeyDown(IN_BACK) then
			value = -shift
		end

		if client:HasTemporaryStatusEffect("berserk") then
			value = value + 15
		end

		value = math_Clamp(value, -8, 8)
		fovShift = Lerp(FrameTime() * 3, fovShift, value)

		if cameraPos then
			view.origin = view.origin + cameraPos
		end

		view.fov = fov + fovShift

		return GAMEMODE:CalcView(client, view.origin, view.angles, view.fov, view.znear)
	end
end

function PLUGIN:Think()
	self.isAllow = allow()
	if !self.isAllow then return end

	local client = LocalPlayer()
	if eyeAtt then
		local forwardVec = client:GetAimVector()

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

	local eyeAng = ucmd:GetViewAngles()
	ucmd:SetViewAngles(Angle(math_Clamp(eyeAng.p, -s, m), eyeAng.y, eyeAng.r))
end


concommand_Add("arb_camerafix", function(client, cmd, args)
	local ang = EyeAngles()

	client:SetEyeAngles(Angle(ang.p, ang.y, 0))
end)