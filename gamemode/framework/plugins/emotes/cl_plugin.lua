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

local keyBlacklist = IN_ATTACK + IN_ATTACK2 + IN_JUMP + IN_DUCK
function Emotes:StartCommand(client, command)
	if select(3, GetAction(client)) then
		RemoveKey(command, keyBlacklist)
		ClearMovement(command)
	end
end