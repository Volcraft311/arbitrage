--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru (not work)
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
		local pos, ang = vehicle:GetPos(), client:GetAngles()

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

	self:SetNetVar("action", {
		name,
		bNoExit and -1 or (time <= -1 and time or CurTime() + time),
		bThirdPerson,
		ang
	})
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
	uniqueID = tostring(uniqueID) or ""
	uniqueID = string.lower(uniqueID)

	local data = Emotes.action.stored[uniqueID]
	if !data then return Arbitrage.commands.Notify(self, "Данной анимации не существует!") end

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
			return Arbitrage.commands.Notify(self, "Ваша модель не поддерживает данную анимацию!")
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

		local _, _, bThirdPerson, actionAng = self:GetAction()

		local timerID = "Emotes:ClearAction_" .. self:SteamID()
		timer.Remove(timerID)
		self:SetMoveType(MOVETYPE_WALK)
		self:SetNetVar("action", nil)
		self.EmotesActiveAction = nil
		self.EmotesExitAction = nil

		if bThirdPerson and actionAng then
			self:SetEyeAngles(actionAng)
		end
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