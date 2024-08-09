--[[
        © AsterionStaff 2023.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

-- Localize Global Calls
local CurTime = CurTime
local math_Clamp = math.Clamp
local math_abs = math.abs
local math_sin = math.sin
local RealTime = RealTime
local Angle = Angle
local tonumber = tonumber
local Lerp = Lerp
local math_max = math.max
local math_Round = math.Round
local math_Approach = math.Approach
local timer_Simple = timer.Simple
local IsValid = IsValid
local timer_Create = timer.Create
local timer_Remove = timer.Remove
local FrameTime = FrameTime

function Stamina:IsRunning(client, isProne)
	if isProne then
		return false
	end

	return client:GetVelocity():Length() > self:GetMaxWalkSpeed(client) and client:KeyDown(IN_SPEED)
end

function Stamina:IsWalking(client)
	return client:GetVelocity():Length() > 10
end

function Stamina:SetStamina(client, value)
	if self:GetStamina(client) != value then
		client:SetLocalVar("stamina", value)
	end
end

function Stamina:GetStaminaCD(client)
	return client.StaminaCD or CurTime()
end

function Stamina:SetStaminaCD(client, time)
	local oldTime = client.StaminaCD
	if oldTime and oldTime > CurTime() + time then
		return
	end

	client.StaminaCD = CurTime() + time
end

function Stamina:GetMaxWalkSpeed(client)
	local speed = ARBITRAGE_WALK_SPEED + 1

	local arbWalkSpeed = client.arb_walkSpeed
	if arbWalkSpeed then
		speed = speed * arbWalkSpeed
	end

	if client:HasTemporaryStatusEffect("exhaustion") then
		local sleep = Arbitrage.statistics.Get(client, "Sleep") or 100

		if sleep <= 40 then
			speed = speed - (40 - sleep)
		end
	end

	if client:HasTemporaryStatusEffect("berserk") then
		local increase = 1 + (Medical:TemporaryStatusEffectsValues("berserk")[1] / 100)

		speed = speed * increase
	end

	if client:HasTemporaryStatusEffect("broken_leg") and !client:HasTemporaryStatusEffect("painkillers") then
		local value = math_Clamp(math_abs(math_sin(RealTime() * 2.5)), 0.3, 1)

		if (!client.StaminaShakeTime or CurTime() >= client.StaminaShakeTime) and value <= 0.35 and client:GetVelocity():LengthSqr() >= 1000 then
			client:ViewPunch(Angle(0.7, -0.5, 0.3))

			client.StaminaShakeTime = CurTime() + 0.6
		end

		local decrease = 1 - (Medical:TemporaryStatusEffectsValues("broken_leg")[1] / 100)
		speed = speed * (value * decrease)
	end

	return speed
end

function Stamina:GetMaxRunSpeed(client)
	local speed = ARBITRAGE_RUN_SPEED + 1

	local arbRunSpeed = client.arb_runSpeed
	if arbRunSpeed then
		speed = speed * arbRunSpeed
	end

	local faction = Character.team:GetByID(client:Team())
	if faction then
		speed = speed * (tonumber(faction:GetRunSpeed()) or 1)
	end

	local stamina = self:GetStamina(client)
	if stamina <= 50 then
		speed = speed - (50 - stamina) * 1.25
	end

	if client:HasTemporaryStatusEffect("exhaustion") then
		local sleep = Arbitrage.statistics.Get(client, "Sleep") or 100

		if sleep <= 40 then
			speed = speed - (40 - sleep)
		end
	end

	if client:HasTemporaryStatusEffect("adrenalin") then
		local increase = 1 + (Medical:TemporaryStatusEffectsValues("adrenalin")[1] / 100)

		speed = speed * increase
	end

	if client:HasTemporaryStatusEffect("berserk") then
		local increase = 1 + (Medical:TemporaryStatusEffectsValues("berserk")[1] / 100)

		speed = speed * increase
	end

	return speed
end

function Stamina:SpeedHandler(client, info)
	local length = info.length
	if length <= 10 then return end

	local runSpeed = info.runSpeed
	local isRunning = info.isRunning
	local maxWalkSpeed = info.maxWalkSpeed
	local maxRunSpeed = info.maxRunSpeed
	local stamina = info.stamina
	local isWalking = info.isWalking
	local isShifting = (isWalking and client:KeyDown(IN_SPEED))

	if (!isRunning and runSpeed > maxWalkSpeed + 0.1) or (stamina < 100 or stamina > 100) or (runSpeed < maxWalkSpeed) or (runSpeed > maxRunSpeed) or isShifting then
		local ftSpeed = info.ft * 12
		runSpeed = Lerp(ftSpeed, runSpeed, (isRunning and stamina > 5) and maxRunSpeed or maxWalkSpeed + 0.03)
		runSpeed = math_max(maxWalkSpeed, runSpeed)

		if math_Round(info.runSpeed, 2) != math_Round(runSpeed, 2) then
			client:SetRunSpeed(runSpeed)
			client:SetWalkSpeed(runSpeed)
			client:SetSlowWalkSpeed(runSpeed)
		end
	end
end

function Stamina:CalcRegeneration(client, info)
	local isRunning = info.isRunning
	local regeneration = 1

	if isRunning then
		regeneration = regeneration * 0.5

		local faction = Character.team:GetByID(client:Team())
		local staminaSpending = faction and faction:GetRunConsumption() or 1

		regeneration = regeneration * staminaSpending
	else
		if self:GetStaminaCD(client) > CurTime() then return 0 end

		regeneration = regeneration * 3 -- восстанавливаем стамину быстрее, чем тратим

		if client:HasTemporaryStatusEffect("dehydration") then return 0 end

		local length = info.length
		if length <= 0 then
			regeneration = regeneration * 2
		end
	end

	return regeneration
end

function Stamina:StaminaHandler(client, info)
	local stamina = info.stamina
	local isRunning = info.isRunning
	local isWalking = info.isWalking
	local isProne = info.isProne
	local isShifting = isWalking and client:KeyDown(IN_SPEED)

	if isProne then
		isShifting = false
	end

	if stamina < 100 or isShifting then
		local regeneration = self:CalcRegeneration(client, info)
		local ftSpeed = info.ft * 20
		local value = math_Approach(stamina, isShifting and 0 or 100, ftSpeed * regeneration)

		if isRunning then
			self:SetStaminaCD(client, 1.5)
		end

		self:SetStamina(client, value)
	elseif stamina > 100 then
		self:SetStamina(client, stamina - 0.1)
	end
end

function Stamina:JumpHandler(client, info)
	local stamina = info.stamina

	if stamina < 100 and client:OnGround() then
		timer_Simple(0.2, function()
			if !IsValid(client) then return end

			local jumppower = math_Clamp(stamina * 4, 50, ARBITRAGE_JUMP_POWER)
			if jumppower != client:GetJumpPower() then
				client:SetJumpPower(jumppower)
			end
		end)
	end
end

function Stamina:ReturnSpeed(client)
	local walkSpeed = self:GetMaxWalkSpeed(client)
	local runSpeed = self:GetMaxRunSpeed(client)

	if walkSpeed != client:GetWalkSpeed() or runSpeed != client:GetRunSpeed() then
		client:SetRunSpeed(runSpeed)
		client:SetWalkSpeed(walkSpeed)
		client:SetSlowWalkSpeed(walkSpeed)
	end
end

function Stamina:CreateTimer(client)
	local id = "Stamina:Think_" .. client:EntIndex()
	timer_Create(id, 0.1, 0, function()
		if !IsValid(client) then return timer_Remove(id) end

	    if !client:IsPlaying() or !client:oldAlive() then
	    	return self:ReturnSpeed(client)
	    end

	    if client:IsNocliping() then return end

		local isProne = client.IsProne and client:IsProne()

		local info = {}
		info.runSpeed = client:GetRunSpeed()
		info.isRunning = self:IsRunning(client, isProne)
		info.isWalking = self:IsWalking(client)
		info.isProne = isProne
		info.maxWalkSpeed = self:GetMaxWalkSpeed(client)
		info.maxRunSpeed = self:GetMaxRunSpeed(client)
		info.stamina = self:GetStamina(client)
		info.length = client:GetVelocity():LengthSqr()
		info.ft = FrameTime()

		self:SpeedHandler(client, info)
		self:StaminaHandler(client, info)
		self:JumpHandler(client, info)
	end)
end


function Stamina:KeyPress(client, key)
	if !client:IsPlaying() or !client:oldAlive() then return end

	if key == IN_JUMP and client:OnGround() and !client:InVehicle() then
		if client.IsProne and client:IsProne() then return end

		local stamina = self:GetStamina(client)

		self:SetStamina(client, math_max(0, stamina - 10))
		self:SetStaminaCD(client, 3)
	end
end

function Stamina:PlayerInitialSpawn(client)
	self:CreateTimer(client)
end

function Stamina:ScalePlayerDamage(target, hitgroup, dmginfo)
	if !target:IsPlayer() then return end

	local stamina = self:GetStamina(target)

	if stamina < 300 then
		local damage = dmginfo:GetDamage()

		local attacker = dmginfo:GetAttacker()
		if IsValid(attacker) and attacker:IsPlayer() then
			local class = attacker:GetActiveWeaponClass()

			if class == "academy_first" then return end
		end

		if target:HasTemporaryStatusEffect("broken_leg") and !target:HasTemporaryStatusEffect("painkillers") then
			-- eh...
		else
			self:SetStamina(target, self:GetStamina(target) + damage * 2)

			target:AddTemporaryStatusEffect("adrenalin", 10)
		end
	end
end

local convar = asterionlib and asterionlib.RunConsoleCommand or RunConsoleCommand
convar("sv_tfa_weapon_weight", 0)