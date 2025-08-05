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

-- Localize Global Calls
local PLAYER = FindMetaTable("Player")
local ENTITY = FindMetaTable("Entity")
local CUSERCMD = FindMetaTable("CUserCmd")
local VECTOR = FindMetaTable("Vector")

local select = select
local RunConsoleCommand = RunConsoleCommand
local Vector = Vector
local util_TraceHull = util.TraceHull
local util_TraceLine = util.TraceLine
local Lerp = Lerp
local FrameTime = FrameTime
local timer_Simple = timer.Simple
local CurTime = CurTime
local IsValid = IsValid

local GetAction = PLAYER.GetAction
local InVehicle = PLAYER.InVehicle
local Crouching = PLAYER.Crouching
local GetActiveWeapon = PLAYER.GetActiveWeapon

local GetBoneCount = ENTITY.GetBoneCount
local GetBoneName = ENTITY.GetBoneName
local LookupSequence = ENTITY.LookupSequence
local GetSequence = ENTITY.GetSequence
local SetCycle = ENTITY.SetCycle
local SetPlaybackRate = ENTITY.SetPlaybackRate
local GetNetVar = ENTITY.GetNetVar
local OnGround = ENTITY.OnGround
local GetClass = ENTITY.GetClass

local RemoveKey = CUSERCMD.RemoveKey
local ClearMovement = CUSERCMD.ClearMovement

local Length2D = VECTOR.Length2D


function Emotes:PlayerBindPress(client, bind, bPressed)
	local bThirdPerson = select(3, GetAction(client))
	if !bThirdPerson then return end

	if bind:find("+jump") and bPressed then
		RunConsoleCommand("say", "/exitaction")

		return true
	end
end

function Emotes:ShouldDrawLocalPlayer(client)
	local bThirdPerson = select(3, GetAction(client))

	if bThirdPerson then
		return true
	end
end

local function GetHeadBone(client)
	for i = 1, GetBoneCount(client) do
		local name = GetBoneName(client, i)

		if name:lower():find("head") then
			return i
		end
	end
end

local endPosShift = 0
local cameraShift = 80
local lerpCameraShift = 80
local offset = 16
local height = Vector(0, 0, 20)
local forwardOffset = 16
local GROUND_PADDING = Vector(0, 0, 8)
local PLAYER_OFFSET = Vector(0, 0, 72 - 20)
local nCameraType = 1
local bKeyDown = false
function Emotes:CalcView(client, origin)
	if Arbitrage.lawEnable then return end
	if client:IsSpectating() then return end
	if Arbitrage.IsThirdPerson() then return end

	local bThirdPerson = select(3, GetAction(client))
	if bThirdPerson then
		Hints:AddKeyDraw("#hintsdraw_exit_action", "+jump")

		local ang = client:EyeAngles()

		local startPos = client:GetPos() + PLAYER_OFFSET
		local endPos = startPos - ang:Forward() * lerpCameraShift
		local endPosMax = startPos - ang:Forward() * cameraShift

		local data = {}
		data.start = startPos
		data.endpos = endPos
		data.filter = client

		local traceData3 = {}
		traceData3.start = startPos
		traceData3.endpos = endPosMax
		traceData3.filter = client
		traceData3.ignoreworld = bNoclip
		traceData3.mins = traceMin
		traceData3.maxs = traceMax

		local traceHull3 = util_TraceHull(traceData3)
		local traceHitPos3 = traceHull3.HitPos

		local traceLine = util_TraceLine(data)
		local hitPos = traceLine.HitPos
		local pos = hitPos + GROUND_PADDING + ang:Forward() * 4

		local dist = endPosMax:Distance(traceHitPos3)
		endPosShift = Lerp(FrameTime() * 2, endPosShift, dist)

		lerpCameraShift = cameraShift - endPosShift

		local view = {}
		view.origin = pos
		view.angles = ang
		view.filter = client

		return view
	else
		endPosShift = 70
	end

	if client.GetSitting and client:GetSitting() then
		Hints:AddKeyDraw("#hintsdraw_camera_pos", "+duck")
		Hints:AddKeyDraw("#hintsdraw_back_feet", "+use")

		if client:GetPos():DistToSqr(Vector(0, 0, 0)) <= 150 then
			RunConsoleCommand("+use")
			timer_Simple(0.2, function()
				RunConsoleCommand("-use")
			end)

			return
		end

		local x, y, z = 0, 0, 0

		local bKeyPress = client:KeyDown(IN_DUCK)
		if bKeyPress then
			if !bKeyDown then
				nCameraType = nCameraType + 1

				if nCameraType > 3 then
					nCameraType = 1
				end
			end

			bKeyDown = true
		else
			bKeyDown = false
		end

		local sitID = GetNetVar(client, "sitting")
		if sitID then
			local data = Emotes.SittingList[sitID]
			local campos = data and data[2] or Vector(0, 0, 0)

			x, y, z = -campos.x, -campos.y, -campos.z
		end

		local pos, ang = origin, client:EyeAngles()

		pos = pos + client:GetAngles():Forward() * x + client:GetAngles():Right() * y + client:GetAngles():Up() * z

		local view = {}
		view.drawviewer = true
		if nCameraType == 1 then
			local data = {}
			data.start = pos
			data.endpos = data.start - ang:Forward() * 72
			data.filter = client

			view.origin = util_TraceLine(data).HitPos + GROUND_PADDING
		elseif nCameraType == 2 then
			local enterAngle = client:GetAngles()
			local forward = enterAngle:Forward()
			local head = GetHeadBone(client)
			if head then
				local position = client:GetBonePosition(head) + client:GetAngles():Forward() * 7
				local data = {
					start = (client:GetBonePosition(head) or Vector(0, 0, 64)) + forward * 8,
					endpos = position + forward * offset,
					mins = traceMin,
					maxs = traceMax,
					filter = client
				}

				data = util_TraceHull(data)

				if data.Hit then
					view.origin = data.HitPos
				else
					view.origin = position
				end
			else
				view.origin = origin + forward * forwardOffset + height
			end
		elseif nCameraType == 3 then
			view.origin = pos
			view.drawviewer = false
		end

		view.angles = ang
		view.filter = client
		return view
	end
end

local function getSequenceID(array, id, client)
	local sequence = array[id]
	local sequenceID = sequence and LookupSequence(client, sequence)

	if sequenceID and sequenceID > -1 then
		return sequenceID
	end
end

function Emotes:CalcMainActivity(client, velocity)
	local isProne = client.IsProne and client:IsProne()
	if isProne then return end

	-- Акты
	do
		local seq, seqTime = GetAction(client)
		if seq then
			local seqID = LookupSequence(client, seq)

			if seqID > -1 and (seqTime <= -1 or seqTime > CurTime()) then
				if GetSequence(client) != seqID then
					SetCycle(client, 0)
					SetPlaybackRate(client, 1)
				end

				return -1, seqID
			end
		end
	end

	-- Сидение
	do
		if client.GetSitting and client:GetSitting() then
			local sitID = GetNetVar(client, "sitting")
			if sitID then
				local seq = client:GetSittingSequence()
				local seqID = LookupSequence(client, seq)

				if seqID > -1 then
					return -1, seqID
				end
			end
		end
	end

	local len2D = Length2D(velocity)
	-- Анимации ожидания
	do
		if len2D <= 0 then
			local animationData = GetNetVar(client, "stand_animation")
			if animationData then
				local seq = animationData[1]
				local delay = animationData[2]

				if delay >= CurTime() then
					local seqID = LookupSequence(client, seq)

					if seqID > -1 then
						return -1, seqID
					end
				end
			end
		end
	end

	-- Жест пальца
	do
		local bFinger = GetNetVar(client, "use_finger")

		if bFinger then
			local sequence = nil
			local bCrouch = client:Crouching()
			local bJump = !client:IsOnGround()

			if len2D < 10 then
				local seq = "idle_finger"

				if bCrouch then
					seq = "cidle_finger"
				elseif bJump then
					seq = "jump_finger"
				end

				local sequenceID = LookupSequence(client, seq)

				if sequenceID then
					sequence = sequenceID
				end
			elseif len2D >= 140 then
				local seq = "run_finger"

				if bCrouch then
					seq = "cwalk_finger"
				elseif bJump then
					seq = "jump_finger"
				end

				local sequenceID = LookupSequence(client, seq)
				if sequenceID then
					sequence = sequenceID
				end
			else
				local seq = "walk_finger"

				if bCrouch then
					seq = "cwalk_finger"
				elseif bJump then
					seq = "jump_finger"
				end

				local sequenceID = LookupSequence(client, seq)
				if sequenceID then
					sequence = sequenceID
				end
			end

			if sequence > -1 then
				return ACT_MP_STAND_IDLE, sequence
			end
		end
	end

	-- Настроение
	do
		local mood = client:GetMood()
		if mood and !InVehicle(client) and !Crouching(client) and OnGround(client) then
			local weapon = GetActiveWeapon(client)

			local holdType = "normal"
			local class = nil
			if IsValid(weapon) then
				holdType = weapon.HoldType or weapon:GetHoldType()
				class = GetClass(weapon)
			end

			if (class == "academy_key" or class == "academy_first") and holdType == "normal" then
				local sequence = nil
				local data = mood.sequences or {}

				if len2D < 10 then
					local sequenceID = getSequenceID(data, "idle", client)
					if sequenceID then
						sequence = sequenceID
					end
				elseif len2D >= 140 then
					local sequenceID = getSequenceID(data, "run", client)
					if sequenceID then
						sequence = sequenceID
					end
				else
					local sequenceID = getSequenceID(data, "walk", client)
					if sequenceID then
						sequence = sequenceID
					end
				end

				if sequence then
					return ACT_MP_STAND_IDLE, sequence
				end
			end
		end
	end
end

local ShapeKeyEyeData = {
	right = {
		data = {"lookright", "look_right", "eyes_look_right"},
		func = function(headYaw, headPitch)
			return math.Clamp((headYaw - 0.5) * -2, 0, 1) * 0.8
		end
	},
	left = {
		data = {"lookleft", "look_left", "eyes_look_left"},
		func = function(headYaw, headPitch)
			return math.Clamp((headYaw - 0.5) * 2, 0, 1) * 2.5
		end
	},
	up = {
		data = {"lookup", "look_up", "eyes_look_up"},
		func = function(headYaw, headPitch)
			return math.Clamp((headPitch - 0.5) * -2, 0, 1) * 0.8
		end
	},
	down = {
		data = {"lookdown", "look_down", "eyes_look_down"},
		func = function(headYaw, headPitch)
			return math.Clamp((headPitch - 0.5) * 2, 0, 1) * 2.5
		end
	}
}

local lookAtTargets = {}
local lerpAtTargetsYaw = {}
local lerpAtTargetsPitch = {}

hook("ArbitrageVoiceStart", function(speaker)
	for _, client in ipairs(player.GetAll()) do
		if client != speaker then
			local dist = speaker:GetPos():DistToSqr(client:GetPos())

			if dist <= 100000 then
				lookAtTargets[client] = speaker

				hook.Remove("UpdateAnimation", "LookAtPlayerStop_" .. client:EntIndex())
			end
		end
	end
end)

hook("ArbitrageVoiceEnd", function(speaker)
	for client, target in pairs(lookAtTargets) do
		if target == speaker then
			lookAtTargets[client] = nil

			hook.Add("UpdateAnimation", "LookAtPlayerStop_" .. client:EntIndex(), function()
				if !IsValid(client) then return hook.Remove("UpdateAnimation", "LookAtPlayerStop_" .. client:EntIndex()) end

				if (lerpAtTargetsYaw[client] and lerpAtTargetsPitch[client]) and (math.abs(lerpAtTargetsYaw[client]) > 0.05 and math.abs(lerpAtTargetsPitch[client]) > 0.05) then
					local ft = FrameTime()

					lerpAtTargetsYaw[client] = Lerp(ft * 3.5, lerpAtTargetsYaw[client], 0)
					lerpAtTargetsPitch[client] = Lerp(ft * 3.5, lerpAtTargetsPitch[client], 0)

					client:SetPoseParameter("head_yaw", lerpAtTargetsYaw[client])
					client:SetPoseParameter("head_pitch", lerpAtTargetsPitch[client])

					client:InvalidateBoneCache()
				else
					hook.Remove("UpdateAnimation", "LookAtPlayerStop_" .. client:EntIndex())
				end
			end)
		end
	end
end)

hook("UpdateAnimation", function(client)
	-- Глаза (НА БУДУЩИЕ МОДЕЛИ ПОКА ИХ НЕТУ)
	--[[
	do
		local pos = client:GetPos()
		local dist = EyePos():DistToSqr(pos)

		if dist < 50000 then
			local headYaw = client:GetPoseParameter("head_yaw")
			local headPitch = client:GetPoseParameter("head_pitch")

			for _, info in pairs(ShapeKeyEyeData) do
				for _, flexID in ipairs(info.data) do
					local flex = client:GetFlexIDByName(flexID)

					if flex then
						local value = info.func(headYaw, headPitch)
						client:SetFlexWeight(flex, value)

						break
					end
				end
			end
		end
	end
	]]--

	-- Голова
	do
		local speaker = lookAtTargets[client]
		if IsValid(speaker) then
			local targetPos = speaker:EyePos()
			local plyPos = client:EyePos()

			local direction = targetPos - plyPos
			direction:Normalize()

			local angles = direction:Angle()
			local plyAngles = client:EyeAngles()

			local yaw = math.AngleDifference(angles.y, plyAngles.y)
			local pitch = math.AngleDifference(angles.p, plyAngles.p)

			yaw = math.Clamp(yaw, -60, 60)
			pitch = math.Clamp(pitch, -60, 60)

			lerpAtTargetsYaw[client] = lerpAtTargetsYaw[client] or (client:GetPoseParameter("head_yaw") or 0)
			lerpAtTargetsPitch[client] = lerpAtTargetsPitch[client] or (client:GetPoseParameter("head_pitch") or 0)

			local ft = FrameTime()

			lerpAtTargetsYaw[client] = Lerp(ft * 3.5, lerpAtTargetsYaw[client], yaw)
			lerpAtTargetsPitch[client] = Lerp(ft * 3.5, lerpAtTargetsPitch[client], pitch)

			client:SetPoseParameter("head_yaw", lerpAtTargetsYaw[client])
			client:SetPoseParameter("head_pitch", lerpAtTargetsPitch[client])

			client:InvalidateBoneCache()
		end
	end
end)

local keyBlacklist = IN_ATTACK + IN_ATTACK2 + IN_JUMP + IN_DUCK
function Emotes:StartCommand(client, command)
	if select(3, GetAction(client)) then
		RemoveKey(command, keyBlacklist)
		ClearMovement(command)
	end
end