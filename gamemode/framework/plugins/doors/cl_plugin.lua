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

local PLUGIN = PLUGIN

local function CreatePanels(data, parent)
	for k, v in ipairs(data or {}) do
		local panel, subMenu = nil, nil

		if isfunction(v.data) then
			panel = parent:AddOption(v.name, v.data)
		else
			subMenu, panel = parent:AddSubMenu(v.name)

			CreatePanels(v.data, subMenu)
		end

		panel:SetImage(v.icon)

		for k2, v2 in ipairs(panel:GetChildren()) do
			if v2:GetName() == "DImage" and !string.find(v2:GetImage(), "icon16/") then
				local size = parent:GetTall() * 1.5

				v2:SetSize(size, size)
			end
		end
	end
end

local function gRequestAddDoorFaction()
	local data = {}

	for k, v in pairs(Arbitrage.teams.data) do
		data[#data + 1] = {
			name = v.name,
			icon = v.pixel,
			data = function()
				Derma_Query("Вы точно хотите дать этому персонажу доступ к данной двери?",  "[DoorSaver] Добавление доступа", "Да", function()
					netstream.Start("arb.DoorAddOwner", k)
				end, "Нет")
			end
		}
	end

	return data
end

local function gRequestSetIcon()
	local data = {}

	for k, v in pairs(Arbitrage.teams.data) do
		data[#data + 1] = {
			name = v.name,
			icon = v.pixel,
			data = function()
				Derma_Query("Вы точно хотите изменить иконку двери?",  "[DoorSaver] Изменение иконки", "Да", function()
					netstream.Start("arb.DoorSetIcon", k)
				end, "Нет")
			end
		}
	end

	return data
end

local function gRequestAddDoorPlayer()
	local data = {}

	for k, v in ipairs(player.GetAll()) do
		local id = v:Team()

		local info = v:SteamID() or "NULL"
		local faction = Arbitrage.teams.Get(id)
		local icon = "icon16/user_add.png"

		if faction and faction.pixel then
			icon = faction.pixel
		end

		data[#data + 1] = {
			name = faction.name .. " (" .. info .. ")",
			icon = icon,
			data = function()
				Derma_Query("Вы точно хотите дать этому персонажу доступ к данной двери?",  "[DoorSaver] Добавление доступа", "Да", function()
					netstream.Start("arb.DoorAddOwner", id)
				end, "Нет")
			end
		}
	end

	return data
end

local function gRequestRemoveDoorPlayer(doorData)
	if !doorData then return end

	local data = {}

	for k, v in pairs(doorData.list or {}) do
		local faction = Arbitrage.teams.Get(k)

		data[#data + 1] = {
			name = faction.name,
			icon = faction.pixel,
			data = function()
				Derma_Query("Вы точно хотите удалить данного игрока из двери?",  "[DoorSaver] Удаление из базы", "Да", function()
					netstream.Start("arb.DoorRemoveOwner", k)
				end, "Нет")
			end
		}
	end

	return data
end

function PLUGIN:Think()
	local client = LocalPlayer()

	if input.IsKeyDown(KEY_F2) and client:IsAdmin() and !vgui.CursorVisible() then
		local trace = client:GetEyeTraceNoCursor()
		local entity = trace.Entity

		if !IsValid(entity) then return end
		if !entity:IsDoor() then return end
		if EyePos():Distance(entity:GetPos()) >= 300 then return end

		local doorData
		for k, v in pairs(self.DoorsData) do
			if v.idx == entity:EntIndex() then
				doorData = self.DoorsData[k]
			end
		end

		local RequestAddDoorPlayer = gRequestAddDoorPlayer()
		local RequestAddDoorFaction = gRequestAddDoorFaction()
		local RequestRemoveDoorPlayer = gRequestRemoveDoorPlayer(doorData)
		local RequestSetIcon = gRequestSetIcon()

		local ActionData = {
			{
				name = "Действия с дверью:",
				icon = "icon16/report_disk.png",
				data = {
					{
						name = "Запретить/Разрешить взламывать",
						icon = "icon16/attach.png",
						data = function()

						end
					}
				}
			},
			{
				name = "Добавить доступ к двери:",
				icon = "icon16/pencil_add.png",
				data = {
					{
						name = "Поиск по игрокам:",
						icon = "icon16/user_go.png",
						data = RequestAddDoorPlayer
					},
					{
						name = "Поиск по всем фракциям:",
						icon = "icon16/transmit_go.png",
						data = RequestAddDoorFaction
					}
				}
			},
			{
				name = "Убрать доступ из двери:",
				icon = "icon16/pencil_delete.png",
				data = RequestRemoveDoorPlayer
			},
			{
				name = "Изменить иконку двери:",
				icon = "icon16/camera_go.png",
				data = RequestSetIcon
			}
		}

		local parentMenu = DermaMenu()
		CreatePanels(ActionData, parentMenu)

		parentMenu:Open(ScrW() / 2, ScrH() / 2)
	end
end

function PLUGIN:CalculateDoorPosition(door, reversed)
	local traceData = {}
	local obbCenter = door:OBBCenter()
	local obbMaxs = door:OBBMaxs()
	local obbMins = door:OBBMins()

	traceData.endpos = door:LocalToWorld(obbCenter)
	traceData.filter = ents.FindInSphere(traceData.endpos, 20)

	for k, v in pairs(traceData.filter) do
		if v == door then
			traceData.filter[k] = nil
		end
	end

	local length = 0
	local width = 0
	local size = obbMins - obbMaxs

	size.x = math.abs(size.x)
	size.y = math.abs(size.y)
	size.z = math.abs(size.z)

	if size.z < size.x and size.z < size.y then
		length = size.z
		width = size.y

		if reverse then
			traceData.start = traceData.endpos - (door:GetUp() * length)
		else
			traceData.start = traceData.endpos + (door:GetUp() * length)
		end
	elseif size.x < size.y then
		length = size.x
		width = size.y

		if reverse then
			traceData.start = traceData.endpos - (door:GetForward() * length)
		else
			traceData.start = traceData.endpos + (door:GetForward() * length)
		end
	elseif size.y < size.x then
		length = size.y
		width = size.x

		if reverse then
			traceData.start = traceData.endpos - (door:GetRight() * length)
		else

			traceData.start = traceData.endpos + (door:GetRight() * length)
		end
	end

	local trace = util.TraceLine(traceData)
	local angles = trace.HitNormal:Angle()

	if (trace.HitWorld and !reversed) then
		return self:CalculateDoorPosition(door, true)
	end

	angles:RotateAroundAxis(angles:Forward(), 90)
	angles:RotateAroundAxis(angles:Right(), 90)

	local position = trace.HitPos - (((traceData.endpos - trace.HitPos):Length() * 2) + 2) * trace.HitNormal
	local anglesBack = trace.HitNormal:Angle()
	local positionBack = trace.HitPos + (trace.HitNormal * 2)

	anglesBack:RotateAroundAxis(anglesBack:Forward(), 90)
	anglesBack:RotateAroundAxis(anglesBack:Right(), -90)

	return {
		positionBack = positionBack,
		anglesBack = anglesBack,
		position = position,
		hitWorld = trace.HitWorld,
		angles = angles,
		width = math.abs(width)
	}
end

function PLUGIN:CalculateAlphaFromDistance(maximum, start, finish)
	if type(start) == "Player" then
		start = start:GetShootPos()
	elseif type(start) == "Entity" then
		start = start:GetPos()
	end

	if type(finish) == "Player" then
		finish = finish:GetShootPos()
	elseif type(finish) == "Entity" then
		finish = finish:GetPos()
	end

	return math.Clamp(255 - ((255 / maximum) * (start:Distance(finish))), 0, 255)
end

PLUGIN.Gradients = {
	[GRADIENT_CENTER] = surface.GetTextureID("gui/center_gradient"),
	[GRADIENT_RIGHT] = surface.GetTextureID("gui/gradient"),
	[GRADIENT_DOWN] = surface.GetTextureID("gui/gradient_down"),
	[GRADIENT_UP] = surface.GetTextureID("gui/gradient_up"),
}

function PLUGIN:DrawGradient(gradientType, x, y, width, height, color)
	if !self.Gradients[gradientType] then return end

	surface.SetDrawColor(color.r, color.g, color.b, color.a)
	surface.SetTexture(self.Gradients[gradientType])
	surface.DrawTexturedRect(x, y, width, height)
end

function PLUGIN:DrawDoorText(entity, eyePos, eyeAngles, font, nameColor, textColor)
	local entityColor = entity:GetColor()
	if entityColor.a <= 0 or entity:IsEffectActive(EF_NODRAW) then return end

	local doorData = self:CalculateDoorPosition(entity)
	if doorData.hitWorld then return end

	local alpha = self:CalculateAlphaFromDistance(1000, eyePos, entity:GetPos())
	if (alpha <= 0) then return end

	local faction = Arbitrage.teams.Get(entity:GetNetVar("arb.team", -1))
	if !faction then return end

	local name = "Железная дверь"
	local text = "Данная дверь принадлежит: " .. faction.name

	if name or text then
		surface.SetFont(font)

		local nameWidth, _ = surface.GetTextSize(name)
		local textWidth, _ = surface.GetTextSize(text)
		local longWidth = nameWidth

		if textWidth > longWidth then longWidth = textWidth end

		if faction and faction.pixel then
			local logo = Arbitrage.GetMaterial(faction.pixel)

			cam.Start3D2D(doorData.position + doorData.angles:Right() * -30 + doorData.angles:Forward() * -10, doorData.angles, 0.05)
				surface.SetDrawColor(15, 6, 7, alpha)
				surface.DrawRect(0, 0, 400, 400)

				surface.SetDrawColor(255, 255, 255, alpha)
				surface.SetMaterial(logo)
				surface.DrawTexturedRect(0, 0, 400, 400)
			cam.End3D2D()

			cam.Start3D2D(doorData.positionBack + doorData.anglesBack:Right() * -30 + doorData.anglesBack:Forward() * -10, doorData.anglesBack, 0.05)
				surface.SetDrawColor(15, 6, 7, alpha)
				surface.DrawRect(0, 0, 400, 400)

				surface.SetDrawColor(255, 255, 255, alpha)
				surface.SetMaterial(logo)
				surface.DrawTexturedRect(0, 0, 400, 400)
			cam.End3D2D()
		end
	end
end

local doors = {}
timer.Create("Doors:UpdateDraw", 1, 0, function()
	local eyePos = EyePos()
	doors = ents.FindInSphere(eyePos, 1000)

	for k, v in ipairs(doors) do
		local faction = Arbitrage.teams.Get(v:GetNetVar("arb.team", -1))

		if v:IsDoor() or !faction then
			doors[k] = nil
		end
	end
end)

function PLUGIN:PostDrawTranslucentRenderables()
	if table.Count(doors) <= 0 then return end

	local eyePos, eyeAngle = EyePos(), EyeAngles()

	cam.Start3D(eyePos, eyeAngle)
		for k, v in pairs(doors or {}) do
			if IsValid(v) then
				self:DrawDoorText(v, eyePos, eyeAngles, "arb.Font_FuturaPTBook_20", Color(255, 61, 96), Color(255, 220, 228))
			end
		end
	cam.End3D()
end

netstream.Hook("arb.DoorGetData", function(data)
	if !data then return end

	PLUGIN.DoorsData = data
end)

timer.Simple(1, function()
	netstream.Start("arb.DoorGetData")
end)