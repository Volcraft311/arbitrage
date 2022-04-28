--[[
        © Asterion Project 2021.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local PLUGIN = PLUGIN

PLUGIN.isAllow = false

local Arbitrage = Arbitrage
local IsValid = IsValid
local RealFrameTime = RealFrameTime
local LerpAngle = LerpAngle
local Angle = Angle
local math_Approach = math.Approach
local LocalPlayer = LocalPlayer
local Lerp = Lerp
local math_Clamp = math.Clamp
local Vector = Vector
local util_TraceLine = util.TraceLine

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

local function allow()
	local client = LocalPlayer()

	if Arbitrage.lawEnable then return false end
	if client:IsNocliping() then return false end
	if client:GetNetVar("inbed") then return false end

	if !IsValid(client) then return true end
	if !client:oldAlive() then return false end
	if !client:IsPlaying() then return false end

	local weapon = client:GetActiveWeapon()
	if !IsValid(weapon) then return true end

	local class = weapon:GetClass()
	if !class then return true end

	if class == "academy_first" then
		if weapon:GetAttack() then
			return false
		end
	end

	local weaponData = Arbitrage.weapon.views
	if !weaponData then return true end

	if d_weapon[class] then return false end

	return !weaponData[class]
end

function PLUGIN:ShouldDrawLocalPlayer()
	if !self.isAllow then return end

	if traceHit and !LocalPlayer():InVehicle() then
		return false
	else
		return true
	end
end

function PLUGIN:CalcView(ply, pos, angles, fov)
	if !self.isAllow then return end

	eyeAtt = ply:GetAttachment(ply:LookupAttachment("eyes"))
	local forwardVec = ply:GetAimVector()
	local FT = RealFrameTime()
	local eyeAngles = ply:EyeAngles()

	if (traceHit and !ply:InVehicle()) or !eyeAtt then
		return
	end

	local camera_smoothness = SETTINGS.options.Get("camera_smoothnessNEW")

	if !CurView then
		CurView = angles
	else
		CurView = LerpAngle(FT * camera_smoothness, CurView, angles + Angle(0, 0, eyeAtt.Ang.r * RollDependency))
	end

	if camera_smoothness == 25 then
		CurView = angles + Angle(0, 0, eyeAtt.Ang.r * RollDependency)
	end

	ViewOffsetLeftRight = math_Approach(ViewOffsetLeftRight, 0, 0.5)

	local m = LocalPlayer():Team() == TEAM_MONDO and 5 or 0

	local view = {}
	if ply:WaterLevel() >= 3 then
		ViewOffsetUp = math_Approach(ViewOffsetUp, 0, 0.5)
		ViewOffsetForward = math_Approach(ViewOffsetForward, 8, 0.5)
		RollDependency = Lerp(FT * 15, RollDependency, 0.5)
	else
		ViewOffsetUp = math_Approach(ViewOffsetUp, math_Clamp(eyeAngles.p * -0.1 - m, 0 - m, 10), 0.5)
		ViewOffsetForward = math_Approach(ViewOffsetForward, 5 + math_Clamp(eyeAngles.p * 0.1, 0, 5), 0.5)
		RollDependency = Lerp(FT * 15, RollDependency, 0.05)
	end

	if eyeAtt then
		view.origin = eyeAtt.Pos + (Vector(forwardVec.x * (ViewOffsetForward + ViewOffsetForward2), forwardVec.y * (ViewOffsetForward + ViewOffsetForward2 - 0.3), 0)) + Vector(0, 0, ViewOffsetUp) + ply:GetRight() * ViewOffsetLeftRight
		view.angles = CurView
		view.fov = fov

		return GAMEMODE:CalcView(ply, view.origin, view.angles, view.fov, view.znear)
	end
end

function PLUGIN:Think()
	self.isAllow = allow()
	if !self.isAllow then return end

	local ply = LocalPlayer()
	ply.BuildBonePositions = function(ply, numbon, numphysbon)
		local bone = ply:LookupBone("ValveBiped.Bip01_Head1")
		local matrix = ply:GetBoneMatrix(bone)

		if matrix then
			matrix:Scale(Vector(0.001, 0.001, 0.001))
			matrix:Translate(Vector(0, 0, 0))
			ply:SetBoneMatrix(bone, matrix)
		end
	end

	if eyeAtt then
		local forwardVec = ply:GetAimVector()

		local tr = {}
		tr.start = eyeAtt.Pos
		tr.endpos = tr.start + Vector(forwardVec.x, forwardVec.y, 0) * 20
		tr.filter = ply

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

	local m = LocalPlayer():Team() == TEAM_HIFUMI and 55 or 75
	local s = LocalPlayer():Team() == TEAM_MONDO and 32 or 90

	local eyeAng = ucmd:GetViewAngles()
	ucmd:SetViewAngles(Angle(math_Clamp(eyeAng.p, -s, m), eyeAng.y, eyeAng.r))
end