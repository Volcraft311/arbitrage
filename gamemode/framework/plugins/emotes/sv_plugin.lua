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

local playerMeta = FindMetaTable("Player")

function Emotes:OnPlayerSitting(client, vehicle)
	local sitID = client:GetNetVar("sitting")
	if sitID then
		local parent = vehicle:GetParent()
		vehicle:SetParent(NULL)

		local data = Emotes.SittingList[sitID]
		local origin = data and data[2] or Vector(0, 0, 0)

		local x, y, z = origin.x, origin.y, origin.z
		local pos, ang = vehicle:GetPos(), vehicle:GetAngles()

		pos = pos + ang:Forward() * -y + ang:Right() * -x + ang:Up() * z

		vehicle:SetPos(pos)

		if IsValid(parent) then
			vehicle:SetParent(parent)
		end
	end

	local timerID = "Emotes:FixingJams_" .. client:SteamID()
	timer.Create(timerID, FrameTime(), 0, function()
		if !IsValid(client) then return timer.Remove(timerID) end

		if !client:GetSitting() then
			client:CheckStuck(0.2)
			timer.Remove(timerID)

			client:ReDraw()
		end
	end)
end

local function fixTime(duration, seqTime)
	local time = duration
	if duration == nil then
		time = seqTime
	end

	time = tonumber(time)

	return time
end

function playerMeta:SetAction(name, duration, bThirdPerson, callback, bNoExit, bFreeze)
	local seqID, seqTime = self:LookupSequence(name)
	if seqID <= -1 then return end

	local ang = self:GetAngles()
	local actionAng = select(4, self:GetAction())
	if actionAng then
		ang = actionAng
	end

	local time = fixTime(duration, seqTime)
	if time and time > 0 then
		local timerID = "Emotes:ClearAction_" .. self:SteamID()

		timer.Remove(timerID)
		timer.Create(timerID, time, 1, function()
			if IsValid(self) and !bNoExit then
				self:ExitAction()
			end

			if callback then
				callback()
			end
		end)
	end

	self:SetCycle(0)
	self:SetPlaybackRate(1)

	if bFreeze then
		self:SetMoveType(MOVETYPE_NONE)
	end

	local _time = bNoExit and -1 or (time <= -1 and time or CurTime() + time)

	self:SetNetVar("action", {
		name,
		_time,
		bThirdPerson,
		ang
	})

	hook.Run("ActionStart", self, name, _time, bThirdPerson, ang)
end

local function checking(client, name, time)
	if name then
		local seqID, seqTime = client:LookupSequence(name)
		if seqID <= -1 then
			return false
		end

		time = time or seqTime
		return true, seqID, time
	end

	return true
end

function playerMeta:StartAction(uniqueID)
	uniqueID = (tostring(uniqueID) or ""):lower()

	if self.IsProne and self:IsProne() then return self:ChatNotify("Вы не можете запустить анимацию, когда вы лежите!") end
	if self.GetSitting and self:GetSitting() then return self:ChatNotify("Вы не можете запустить анимацию, когда вы сидите!") end
	if self:IsRagdolling() then return self:ChatNotify("Вы не можете запустить анимацию, когда вы без сознания!") end

	local data = Emotes.action.stored[uniqueID]
	if !data then return self:ChatNotify("Данной анимации не существует!") end

	local startSeq, startTime, normalSeq, normalTime, finishSeq, finishTime
	if data.start then startSeq, startTime = data.start[1], data.start.duration end
	if data.sequence then normalSeq, normalTime = data.sequence[1], data.sequence.duration end
	if data.finish then finishSeq, finishTime = data.finish[1], data.finish.duration end

	local info = {
		{startSeq, startTime},
		{normalSeq, normalTime},
		{finishSeq, finishTime}
	}

	for k, v in ipairs(info) do
		local name, duration = v[1], v[2]

		local bAllow = checking(self, name, duration)
		if !bAllow then
			return self:ChatNotify("Ваша модель не поддерживает данную анимацию!")
		end
	end

	local function startNormalSeq()
		self.EmotesActiveAction = uniqueID

		normalTime = select(3, checking(self, normalSeq, normalTime))
		self:SetAction(normalSeq, normalTime, true, function()
			self:ExitAction(true)
		end)
	end

	if startSeq then
		startTime = select(3, checking(self, startSeq, startTime))
		self:SetAction(startSeq, startTime, true, function()
			startNormalSeq()
		end, true)
	else
		startNormalSeq()
	end
end

function playerMeta:ExitAction(bIsAction)
	local function remove()
		if !IsValid(self) then return end

		local name, time, bThirdPerson, actionAng = self:GetAction()

		local timerID = "Emotes:ClearAction_" .. self:SteamID()
		timer.Remove(timerID)
		self:SetMoveType(MOVETYPE_WALK)
		self:SetNetVar("action", nil)
		self.EmotesActiveAction = nil
		self.EmotesExitAction = nil

		if bThirdPerson and actionAng then
			self:SetEyeAngles(actionAng)
		end

		hook.Run("ActionEnd", self, name, time, bThirdPerson, ang)
	end

	local activeAction = self.EmotesActiveAction
	local data = Emotes.action.stored[activeAction]
	if bIsAction and activeAction and data and data.finish and !self.EmotesExitAction then
		self.EmotesExitAction = true

		self:SetAction(data.finish[1], data.finish.duration, true, function()
			remove()
		end)
	else
		remove()
	end
end


timer.Create("Emotes:StandAnimations", 0.4, 0, function()
	local curTime = CurTime()

	for _, client in ipairs(player.GetAll()) do
		local velocity = client:GetVelocity()
		local len2D = velocity:Length2D()

		local weapon = client:GetActiveWeapon()
		local holdType = "normal"
		local class = nil
		if IsValid(weapon) then
			holdType = weapon.HoldType or weapon:GetHoldType()
			class = weapon:GetClass()
		end

		if len2D <= 0 and (class == "academy_key" or class == "academy_first") and holdType == "normal" and !client:GetAction() and !client:GetSitting() then
			if client.delayStartAnimation == nil then
				client.delayStartAnimation = curTime + 100 + math.random(1, 60)
			else
				if curTime >= client.delayStartAnimation then
					local sequence = Emotes.StandList[math.random(1, #Emotes.StandList)]
					local sequenceID, sequenceDelay = client:LookupSequence(sequence)
					if sequenceID > -1 then
						client:SetNetVar("stand_animation", {sequence, curTime + sequenceDelay})
					end

					client.delayStartAnimation = curTime + 100 + math.random(1, 60) + 30
				end
			end
		else
			if client.delayStartAnimation and client:GetNetVar("stand_animation") then
				client:SetNetVar("stand_animation", nil)
			end

			client.delayStartAnimation = nil
		end
	end
end)

function Emotes:AcceptInput(entity, input, client, caller, value)
	local parent = entity:GetParent()

	if IsValid(parent) then
		if !entity:IsDoor() and !parent:IsDoor() then return end
	else
		if !entity:IsDoor() then return end
	end

	if IsValid(client) and client:IsPlayer() and (!client.doorOpenCD or CurTime() >= client.doorOpenCD) then
		client.doorOpenCD = CurTime() + 1.2

		client:PlaySequence("new_open_door")
	end
end