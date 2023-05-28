local PLUGIN = PLUGIN
PLUGIN.name = "Thirdperson"

if !CLIENT then return end

local select = select
local Vector = Vector
local Angle = Angle
local FrameTime = FrameTime
local Lerp = Lerp
local util_TraceHull = util.TraceHull
local bit_bor = bit.bor
local util_TraceLine = util.TraceLine
local math_Clamp = math.Clamp
local math_NormalizeAngle = math.NormalizeAngle
local IsValid = IsValid

Arbitrage.ThirdPerson = Arbitrage.ThirdPerson or false

function Arbitrage.IsThirdPerson()
	if Arbitrage.lawEnable then return end
	if !Arbitrage.OnThirdPerson() then return end

	local client = LocalPlayer()

	if Arbitrage.ThirdPerson then
		if (client.GetSitting and client:GetSitting()) or select(3, client:GetAction()) then
			return false
		end

		return true
	end
end

local traceMin = Vector(-10, -10, -10)
local traceMax = Vector(10, 10, 10)
local camAng = Angle(0, 0, 0)
local crouchFactor = 0

local fovShift = 0
local endPosShift = 0
local cameraShift = 75
local lerpCameraShift = 75

function PLUGIN:CalcView(client, pos, angles, fov)
	if !Arbitrage.IsThirdPerson() then return end

	if client:GetViewEntity() == client then
		local ft = FrameTime()
		local bNoclip = client:IsNocliping()
		local curAng = camAng or angle_zero

		crouchFactor = Lerp(ft * 5, crouchFactor, client:KeyDown(IN_DUCK) and 1 or 0)

		local startPos = client:GetPos() + client:GetViewOffset() + curAng:Up() * 7 + curAng:Right() * 0 - client:GetViewOffsetDucked() * 0.5 * crouchFactor
		local endPos = startPos - curAng:Forward() * lerpCameraShift
		local endPosMax = startPos - curAng:Forward() * cameraShift

		local traceData = {}
		traceData.start = startPos
		traceData.endpos = endPos
		traceData.filter = client
		traceData.ignoreworld = bNoclip
		traceData.mins = traceMin
		traceData.maxs = traceMax

		local traceHull = util_TraceHull(traceData)
		local traceHitPos = traceHull.HitPos

		local traceData3 = {}
		traceData3.start = startPos
		traceData3.endpos = endPosMax
		traceData3.filter = client
		traceData3.ignoreworld = bNoclip
		traceData3.mins = traceMin
		traceData3.maxs = traceMax

		local traceHull3 = util_TraceHull(traceData3)
		local traceHitPos3 = traceHull3.HitPos

		local dist = endPosMax:Distance(traceHitPos3)
		endPosShift = Lerp(ft * 1, endPosShift, dist)

		lerpCameraShift = cameraShift - endPosShift

		local view = {}
		view.origin = traceHitPos
		view.angles = curAng + client:GetViewPunchAngles()

		local aimOrigin = view.origin

		local traceData2 = {}
		traceData2.start = 	aimOrigin
		traceData2.endpos = aimOrigin + curAng:Forward() * 65535
		traceData2.filter = client
		traceData2.ignoreworld = bNoclip

		local classic = (client:KeyDown(bit_bor(IN_FORWARD, IN_BACK, IN_MOVELEFT, IN_MOVERIGHT)) and client:GetVelocity():Length() >= 10) or client:KeyDown(bit_bor(IN_ATTACK, IN_ATTACK2))
		if !classic then
			local class, wep = client:GetActiveWeaponClass()
			local bFirst = class == "academy_first"

			if class != "academy_key" and !bFirst then
				classic = true
			else
				if bFirst and wep:GetAttack() then
					classic = true
				end
			end
		end

		if classic then
			client:SetEyeAngles((util_TraceLine(traceData2).HitPos - client:GetShootPos()):Angle())
		else
			local currentAngles = client:EyeAngles()
			currentAngles.pitch = (util_TraceLine(traceData2).HitPos - client:GetShootPos()):Angle().pitch

			client:SetEyeAngles(currentAngles)
		end

		local value = client:GetVelocity():Length2D() * 0.02
		if client:KeyDown(IN_BACK) then
			value = -value
		end

		value = math.Clamp(value, -8, 8)
		fovShift = Lerp(ft * 3, fovShift, value)

		view.fov = fov - fovShift

		return view
	end
end

function PLUGIN:CreateMove(cmd)
	if !Arbitrage.IsThirdPerson() then return end

	local client = LocalPlayer()

	if !client:IsNocliping() and LocalPlayer():GetViewEntity() == LocalPlayer() then
		local fm = cmd:GetForwardMove()
		local sm = cmd:GetSideMove()
		local diff = (client:EyeAngles() - (camAng or Angle(0, 0, 0)))[2] or 0
		diff = diff / 90

		cmd:SetForwardMove(fm + sm * diff)
		cmd:SetSideMove(sm + fm * diff)

		return false
	end
end

function PLUGIN:InputMouseApply(cmd, x, y, ang)
	if !Arbitrage.IsThirdPerson() then return end

	camAng.p = math_Clamp(math_NormalizeAngle(camAng.p + y / 50), -85, 85)
	camAng.y = math_NormalizeAngle(camAng.y - x / 50)

	if LocalPlayer():GetViewEntity() == LocalPlayer() then
		return true
	end
end

function PLUGIN:ShouldDrawLocalPlayer()
	if !Arbitrage.IsThirdPerson() then return end

	local client = LocalPlayer()
	if client:GetViewEntity() == client and !IsValid(client:GetVehicle()) then
		return true
	end
end