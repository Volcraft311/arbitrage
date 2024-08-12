local PLUGIN = PLUGIN

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
local math_floor = math.floor
local math_min = math.min
local Color = Color
local hook_Add = hook.Add

Arbitrage.ThirdPerson = Arbitrage.ThirdPerson or false

function Arbitrage.IsThirdPerson()
	if Arbitrage.lawEnable then return false end
	if !Arbitrage.OnThirdPerson() then return false end

	if Arbitrage.ThirdPerson then
		local client = LocalPlayer()

		if client:IsNocliping() or client:IsSpectating() then return false end

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
local curAng = Angle(0, 0, 0)

local function LerpA(a, b, t)
	local delta = (b - a) % 360

	if delta > 180 then
		delta = delta - 360
	end

	return a + delta * t
end

local saveAlpha = 255
local player_alpha = 255
local function playerAlpha(dist)
	local client = LocalPlayer()
	local ft = FrameTime()

	local value = dist * 7 - 180

	player_alpha = Lerp(ft * 10, player_alpha, value)
	player_alpha = math_floor(player_alpha)

	if value >= 200 and value <= 254 then
		player_alpha = math_min(200, saveAlpha)
	end

	local max = math_min(255, saveAlpha)
	if player_alpha <= 0 then
		player_alpha = 0
	elseif player_alpha >= max then
		player_alpha = max
	end

	local color = client:GetColor()
	if color.a != player_alpha then
		client:SetColor(Color(color.r, color.g, color.b, player_alpha))
	end
end

local bIsThirdPerson = false
local bOldIsThirdPerson = false
function PLUGIN:CalcView(client, pos, angles, fov)
	local alpha_localplayer = SETTINGS.options.Get("alpha_localplayer")
	bIsThirdPerson = Arbitrage.IsThirdPerson()

	if !bIsThirdPerson and alpha_localplayer then
		if bOldIsThirdPerson != bIsThirdPerson then
			local color = client:GetColor()

			if saveAlpha != color.a then
				client:SetColor(Color(color.r, color.g, color.b, saveAlpha))
			end
		end
	else
		if bOldIsThirdPerson != bIsThirdPerson then
			local color = client:GetColor()
			saveAlpha = color.a
		end
	end

	bOldIsThirdPerson = bIsThirdPerson
	if !bIsThirdPerson then return end

	if client:GetViewEntity() == client then
		local ft = FrameTime()
		local bNoclip = client:IsNocliping()

		local camera_smoothness = SETTINGS.options.Get("camera_smoothness")
		if camera_smoothness >= 25 then
			curAng = Angle(camAng.p, camAng.y, camAng.r)
		else
			local t = ft * camera_smoothness

			curAng.p = LerpA(curAng.p, camAng.p, t)
			curAng.y = LerpA(curAng.y, camAng.y, t)
			curAng.r = camAng.r
		end

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

		if alpha_localplayer then
			playerAlpha(traceHitPos:Distance(client:GetPos() + client:OBBCenter()))
		end

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

		value = math_Clamp(value, -8, 8)
		fovShift = Lerp(ft * 3, fovShift, value)

		view.fov = fov - fovShift

		return view
	end
end

local blockedMovementAct = {
	[ACT_GMOD_TAUNT_MUSCLE] = true, -- Стриптиз
	[ACT_GMOD_TAUNT_PERSISTENCE] = true, -- Поза льва
	[ACT_GMOD_TAUNT_ROBOT] = true, -- Робот
	[ACT_GMOD_GESTURE_TAUNT_ZOMBIE] = true, -- Зомби
	[ACT_GMOD_TAUNT_CHEER] = true, -- Приветствие
	[ACT_GMOD_TAUNT_DANCE] = true, -- Танец
	[ACT_GMOD_TAUNT_LAUGH] = true -- Смех
}
function PLUGIN:CreateMove(cmd)
	if !bIsThirdPerson then return end

	local client = LocalPlayer()

	if !client:IsNocliping() and LocalPlayer():GetViewEntity() == LocalPlayer() then
		local fm = cmd:GetForwardMove()
		local sm = cmd:GetSideMove()
		local diff = (client:EyeAngles() - (camAng or Angle(0, 0, 0)))[2] or 0
		diff = diff / 90

		cmd:SetForwardMove(fm + sm * diff)
		cmd:SetSideMove((Arbitrage.OnMapReversion() and -sm or sm) + fm * diff)

		if client:IsPlayingTaunt() then
			local act = client:GetLocalVar("tauntAct")

			if blockedMovementAct[act] then
				cmd:ClearMovement()
			end
		end

		return false
	end
end

function PLUGIN:InputMouseApply(cmd, x, y, ang)
	if !bIsThirdPerson then return end

	camAng.p = math_Clamp(math_NormalizeAngle(camAng.p + y / 50), -85, 85)
	camAng.y = math_NormalizeAngle(camAng.y - (Arbitrage.OnMapReversion() and -x or x) / 50)

	if LocalPlayer():GetViewEntity() == LocalPlayer() then
		return true
	end
end

function PLUGIN:ShouldDrawLocalPlayer()
	if !bIsThirdPerson then return end

	local client = LocalPlayer()
	if client:GetViewEntity() == client and !IsValid(client:GetVehicle()) then
		return true
	end
end


hook_Add("SETTINGS:OnOptionChange", "ThirdPerson:OnOptionChange", function(id, value)
	if id != "alpha_localplayer" then return end
	if value != false then return end

	local client = LocalPlayer()
	local color = client:GetColor()

	if saveAlpha != color.a then
		client:SetColor(Color(color.r, color.g, color.b, saveAlpha))
	end
end)