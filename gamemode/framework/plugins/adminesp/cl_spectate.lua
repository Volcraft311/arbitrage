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

local PLUGIN = PLUGIN

-- Localize Global Calls
local Vector = Vector
local Angle = Angle
local EyeAngles = EyeAngles
local LocalPlayer = LocalPlayer
local IsValid = IsValid
local util_QuickTrace = util.QuickTrace
local EyePos = EyePos
local util_TraceLine = util.TraceLine
local RealTime = RealTime
local netstream = netstream
local timer_Create = timer.Create
local FrameTime = FrameTime
local input_IsKeyDown = input.IsKeyDown
local Arbitrage = Arbitrage
local outline = outline
local Color = Color
local CurTime = CurTime
local RunConsoleCommand = RunConsoleCommand
local math_max = math.max
local ipairs = ipairs
local GetConVar = GetConVar
local math_Clamp = math.Clamp

local cameraEntity = nil
local cameraTraceEntity = nil
local cameraPosition = Vector(0, 0, 0)
local cameraAngles = Vector(0, 0, 0)
local eyeAng = Angle(0, 0, 0)
local cameraThirdPerson = true
local thirdPersonDistance = 100


local function fixCameraRoll(bFixEye)
	cameraAngles.r = 0
end

local function fixEyeRoll()
	local ang = EyeAngles()
	LocalPlayer():SetEyeAngles(Angle(ang.p, ang.y, 0))
end

local function setSelectEntityDraw(bNoDraw)
	local entity = cameraEntity

	if IsValid(entity) then
		cameraEntity:SetNoDraw(bNoDraw)
	end

	fixCameraRoll()
end

local function returnEntity()
	if IsValid(cameraEntity) then return end

	local trace = util_QuickTrace(EyePos(), EyeAngles():Forward() * 5000)
	local entity = trace.Entity

	return entity
end

local function getEntityPosition(entity)
	local position = entity:IsPlayer() and entity:GetShootPos() or entity:LocalToWorld(entity:OBBCenter())

	return position
end

local function getThirdPersonPos(entity)
	local startpos = getEntityPosition(entity)
	local endpos = startpos - cameraAngles:Forward() * thirdPersonDistance

	local trace = util_TraceLine({
	    start = startpos,
	    endpos = endpos,
	    filter = entity
	})

	return trace.HitPos + trace.HitNormal * 10
end

local positionUpdateCD = 0
local function syncCameraPosition()
	if (!positionUpdateCD or RealTime() >= positionUpdateCD) then
		netstream.Start("AdminESP:CameraUpdatePosition", cameraPosition)

		positionUpdateCD = RealTime() + 0.2
	end
end

local isSpectating = false
timer_Create("AdminESP:UpdateAllow", 0.1, 0, function()
	local client = LocalPlayer()
	if !IsValid(client) then return end

	isSpectating = client:IsSpectating()

	if !isSpectating then
		setSelectEntityDraw(false)

		cameraPosition = EyePos()
		cameraAngles = EyeAngles()
		eyeAng = EyeAngles()

		cameraEntity = nil
		cameraTraceEntity = nil
	end
end)

local cameraSpeed = 1250
function PLUGIN:CalcView(client, pos, angles, fov)
	if Arbitrage.lawEnable then return end
	if !isSpectating then return end

	client:SetEyeAngles(eyeAng)

	local speed = FrameTime() * cameraSpeed
	if client:KeyDown(IN_SPEED) then
		speed = speed * 3
	elseif input_IsKeyDown(KEY_LCONTROL) or input_IsKeyDown(KEY_RCONTROL) then
		speed = speed * 0.2
	end

	if input_IsKeyDown(KEY_SPACE) then
		cameraPosition = cameraPosition + cameraAngles:Up() * (speed * 0.6)
	end

	if client:KeyDown(IN_FORWARD) then
		cameraPosition = cameraPosition + cameraAngles:Forward() * speed
	elseif client:KeyDown(IN_BACK) then
		cameraPosition = cameraPosition - cameraAngles:Forward() * speed
	end

	if client:KeyDown(IN_MOVELEFT) then
		local a = cameraAngles:Right() * speed
		a = Arbitrage.OnMapReversion() and -a or a

		cameraPosition = cameraPosition - a
	elseif client:KeyDown(IN_MOVERIGHT) then
		local a = cameraAngles:Right() * speed
		a = Arbitrage.OnMapReversion() and -a or a

		cameraPosition = cameraPosition + a
	end

	local entity = cameraEntity
	if IsValid(entity) then
		if cameraThirdPerson then
			cameraPosition = getThirdPersonPos(entity)
		    cameraAngles = cameraAngles
		else
			cameraPosition = getEntityPosition(entity)
		    cameraAngles = entity:IsPlayer() and entity:EyeAngles() or entity:GetAngles()
		end
	end

	syncCameraPosition()

	local view = {
		origin = cameraPosition,
		angles = cameraAngles,
		fov = fov,
		drawviewer = true
	}

	return view
end

function PLUGIN:SpectatePaint()
	if Arbitrage.lawEnable then return end

	local entity = returnEntity()

	if IsValid(entity) then
		outline.Add({entity}, Color(0, 255, 0), 0)

		Hints:AddKeyDraw("Прикрепиться к объекту", {MOUSE_LEFT})
	end

	cameraTraceEntity = entity

	Hints:AddKeyDraw("Выйти из наблюдения", SETTINGS.binds.Get("spectating"))
	Hints:AddKeyDraw("Телепортироваться на место камеры", {"+reload"})

	if IsValid(cameraEntity) then
		Hints:AddKeyDraw("Открепиться от объекта", {MOUSE_LEFT})
	end

	Hints:AddKeyDraw(IsValid(cameraEntity) and "Изменить положение камеры" or "Переместиться вперед", {MOUSE_RIGHT})

	if IsValid(cameraEntity) and cameraEntity:IsPlayer() then
		Hints:AddKeyDraw("Получить изображение экрана", {"+use"})
	end

	if IsValid(entity) and ((entity:IsPlayer() and entity != LocalPlayer()) or entity:IsDoor()) then
		Hints:AddKeyDraw("Меню свойств объекта", {KEY_F2})
	end
end

function PLUGIN:PlayerBindPress(client, bind, pressed)
	if Arbitrage.lawEnable then return end
	if !isSpectating then return end

	if !vgui.CursorVisible() then
		if bind == "+reload" and pressed then
			setSelectEntityDraw(false)

			isSpectating = false
			netstream.Start("AdminESP:CameraTeleportToPosition", cameraPosition, cameraAngles)

			return true
		end

		if bind == "+use" and pressed and IsValid(cameraEntity) and cameraEntity:IsPlayer() then
			if (!client.screengrabCD or CurTime() >= client.screengrabCD) then
				RunConsoleCommand("say", "/sg " .. cameraEntity:SteamID())

				client.screengrabCD = CurTime() + 2
			end

			return true
		end

		if bind == "+attack" and pressed then
			local entity = nil

			fixCameraRoll()
			fixEyeRoll()

			setSelectEntityDraw(false)
				if IsValid(cameraTraceEntity) then
					entity = cameraTraceEntity
				end

				if IsValid(entity) and cameraThirdPerson then
					thirdPersonDistance = cameraPosition:Distance(getEntityPosition(entity))
				end

				netstream.Start("AdminESP:CameraSetEntity", entity)
				cameraEntity = entity
			setSelectEntityDraw(false)

			if !cameraThirdPerson then
				setSelectEntityDraw(true)
			end

			return true
		end

		if bind == "+attack2" and pressed then
			if !IsValid(cameraEntity) then
				cameraPosition = cameraPosition + cameraAngles:Forward() * 1200
			else
				cameraThirdPerson = !cameraThirdPerson
				setSelectEntityDraw(!cameraThirdPerson)

				if cameraThirdPerson then
					fixCameraRoll()
					fixEyeRoll()
				end
			end

			return true
		end

		local invNext = bind == "invnext"
		local invPrev = bind == "invprev"
		if invNext or invPrev then
			local amount = invNext and 1 or -1

			if IsValid(cameraEntity) then
				thirdPersonDistance = math_max(20, thirdPersonDistance + amount * 10)
			else
				cameraSpeed = math_max(50, cameraSpeed + amount * -150)
			end

			return true
		end
	end

	for k, v in ipairs({"+duck", "+jump", "slot1", "slot2", "slot3", "slot4", "slot5", "slot6", "slot7", "slot8", "slot9"}) do
		if bind == v and pressed then
			return true
		end
	end
end

function PLUGIN:CreateMove(cmd)
	if Arbitrage.lawEnable then return end
	if !isSpectating then return end

	cmd:SetForwardMove(0)
	cmd:SetSideMove(0)

	return false
end

function PLUGIN:InputMouseApply(cmd, x, y, ang)
	if Arbitrage.lawEnable then return end
	if !isSpectating then return end

	local pitch = y * GetConVar("m_pitch"):GetFloat()
	local yaw = x * GetConVar("m_yaw"):GetFloat()

	cameraAngles.p = math_Clamp(cameraAngles.p + pitch, -90, 90)
	cameraAngles.y = cameraAngles.y - (Arbitrage.OnMapReversion() and -yaw or yaw)
end

function PLUGIN:KeyPressID(client, id, bIsVisibleGUI)
	if Arbitrage.lawEnable then return end
	if bIsVisibleGUI then return end

	if id == "spectating" then
		RunConsoleCommand("spectate")

		fixCameraRoll()
		fixEyeRoll()
	end
end


netstream.Hook("AdminESP:CameraSetEntity", function(target)
	isSpectating = true
	cameraEntity = target

	fixCameraRoll()
	fixEyeRoll()
end)