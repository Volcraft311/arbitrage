function Stamina:SetStamina(client, value)
	if self:GetStamina(client) != value then
		client:SetLocalVar("stamina", value)
	end
end

function Stamina:GetStaminaCD(client)
	return client.StaminaCD or CurTime()
end

function Stamina:SetStaminaCD(client, time)
	client.StaminaCD = CurTime() + time
end

function Stamina:GetMaxWalkSpeed(client)
	local speed = ARBITRAGE_WALK_SPEED + 1

	local sleep = Arbitrage.statistics.Get(client, "Sleep") or 100
	if sleep <= 40 then
		local value = math.abs(sleep - 40)

		speed = speed - value
	end

	local stamina = self:GetStamina(client)
	if stamina <= 5 then
		speed = speed * 0.5
	end

	return speed
end

function Stamina:GetMaxRunSpeed(client)
	local speed = ARBITRAGE_RUN_SPEED + 1

	local faction = Character.team:GetByID(client:Team())
	if faction then
		speed = speed * (tonumber(faction:GetRunSpeed()) or 1)
	end

	local stamina = self:GetStamina(client)
	if stamina <= 50 then
		local value = math.abs(stamina - 50)

		speed = speed - value * 1.25
	end

	local sleep = Arbitrage.statistics.Get(client, "Sleep") or 100
	if sleep <= 40 then
		local value = math.abs(sleep - 40)

		speed = speed - value
	end

	if (client.StaminaDamageTime or CurTime()) > CurTime() then
		speed = speed * 1.1
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

	if (!isRunning and runSpeed > maxWalkSpeed + 0.05) or (stamina < 100 or stamina > 100) or (runSpeed < maxWalkSpeed) then
		local ftSpeed = info.ft * 12
		runSpeed = Lerp(ftSpeed, runSpeed, (isRunning and stamina > 5) and maxRunSpeed or maxWalkSpeed + 0.03)
		runSpeed = math.max(maxWalkSpeed, runSpeed)

		if math.Round(info.runSpeed, 2) != math.Round(runSpeed, 2) then
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
		local faction = Character.team:GetByID(client:Team())
		local staminaSpending = faction and faction:GetRunConsumption() or 1

		regeneration = regeneration * staminaSpending
	else
		if self:GetStaminaCD(client) > CurTime() then return 0 end

		local thirst = Arbitrage.statistics.Get(client, "Thirst") or 100
		if thirst < 10 then return 0 end

		local length = info.length
		if length <= 0 then
			regeneration = regeneration * 2
		end

		local isCrouching = client:Crouching()
		if isCrouching then
			regeneration = regeneration * 2
		end
	end

	return regeneration
end

function Stamina:StaminaHandler(client, info)
	local stamina = info.stamina
	local isRunning = info.isRunning
	local isWalking = info.isWalking
	local isShifting = (isWalking and client:KeyDown(IN_SPEED))

	if stamina < 100 or isShifting then
		local regeneration = self:CalcRegeneration(client, info)
		local ftSpeed = info.ft * 20
		local value = math.Approach(stamina, isShifting and 0 or 100, ftSpeed * regeneration)

		if value <= 1 and isShifting then
			self:SetStaminaCD(client, 10)
		elseif isRunning then
			self:SetStaminaCD(client, 1.5)
		end

		self:SetStamina(client, value)
	elseif stamina > 100 then
		self:SetStamina(client, self:GetStamina(client) - 0.1)
	end
end

function Stamina:JumpHandler(client, info)
	local stamina = info.stamina

	if stamina < 100 and client:OnGround() then
		timer.Simple(0.2, function()
			if !IsValid(client) then return end

			local jumppower = math.Clamp(stamina * 4, 50, ARBITRAGE_JUMP_POWER)
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
	timer.Create(id, 0.1, 0, function()
		if !IsValid(client) then return timer.Remove(id) end

        if !client:IsPlaying() or !client:oldAlive() then
        	return self:ReturnSpeed(client)
        end

        if client:IsNocliping() then return end

		local info = {}
		info.runSpeed = client:GetRunSpeed()
		info.isRunning = self:IsRunning(client)
		info.isWalking = self:IsWalking(client)
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
	if key == IN_JUMP and client:OnGround() then
		local stamina = self:GetStamina(client)

		self:SetStamina(client, math.max(0, stamina - 10))
		self:SetStaminaCD(client, 3)
	end
end

function Stamina:PlayerInitialSpawn(client)
	self:CreateTimer(client)
end

function Stamina:EntityTakeDamage(target, dmginfo)
	if !target:IsPlayer() then return end

	local stamina = self:GetStamina(target)

	if stamina < 300 then
		local damage = dmginfo:GetDamage()
		self:SetStamina(target, self:GetStamina(target) + damage * 2)
		target.StaminaDamageTime = CurTime() + 10
	end
end

local convar = asterionlib and asterionlib.RunConsoleCommand or RunConsoleCommand
convar("sv_tfa_weapon_weight", 0)