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

function PLUGIN:Think()
	local client = Arbitrage.Client()

	if input.IsKeyDown(KEY_F2) and client:IsAdmin() then
		local trace = client:GetEyeTraceNoCursor()
		local entity = trace.Entity

		if !IsValid(entity) then return end
		if entity:GetClass() != "prop_door_rotating" and entity:GetClass() != "func_door_rotating" then return end
		if EyePos():Distance(entity:GetPos()) >= 300 then return end

		local doorData
		for k, v in pairs(self.DoorsData) do
			if v.indexDoor == entity:EntIndex() then
				doorData = self.DoorsData[k]
			end
		end

		-- Ебать ну и хуйня, надо бы переписать под таблицы когда нить
		local parentMenu = DermaMenu()

		local subMenu5, _ = parentMenu:AddSubMenu("Действия с дверью:") _:SetIcon("icon16/report_disk.png")
		local subMenu, _ = parentMenu:AddSubMenu("Добавить игрока в дверь:") _:SetIcon("icon16/pencil_add.png")
		local subMenu3, _ = parentMenu:AddSubMenu("Удалить из двери игрока:") _:SetIcon("icon16/pencil_delete.png")
		local subMenu4, _ = parentMenu:AddSubMenu("Изменить иконку двери:") _:SetIcon("icon16/camera_go.png")
		local subMenu2, _ = subMenu:AddSubMenu("Игроки на сервере:") _:SetIcon("icon16/user_go.png")

		local _ = subMenu:AddOption("По SteamID", function()
			Derma_StringRequest("[DoorSaver] Добавление по SteamID", "Введите SteamID игрока которого вы хотите добавить в дверь", "", function(data)
				netstream.Start("arb.DoorAddOwner", {
					data,
					"НЕИЗВЕСТНО"
				})

				chat.AddText("[DoorSaver] Вы успешно дали игроку НЕИЗВЕСТНО (" .. data .. ") доступ к двери.")
			end)
		end)
		_:SetIcon("icon16/transmit_go.png")

		for k, v in pairs(player.GetAll()) do
			local data = v:SteamID() or "NULL"

			local _ = subMenu2:AddOption(data .. " (".. v:Name() .. ")", function()
				Derma_Query("Вы точно хотите дать этому игроку доступ к данной двери?",  "[DoorSaver] Добавление игрока", "Да", function()
					if v and IsValid(v) then
						netstream.Start("arb.DoorAddOwner", {
							data,
							v:Name()
						})
						chat.AddText("[DoorSaver] Вы успешно дали игроку " .. v:Name() .. "(" .. v:SteamID() .. ") доступ к двери.")
					end
				end, "Нет")
			end)
			_:SetIcon("icon16/user_add.png")
		end

		if doorData then
			for k, v in pairs(doorData.arbOwnerID or {}) do
				local _ = subMenu3:AddOption(k .. " (" .. v .. ")", function()
					Derma_Query("Вы точно хотите удалить данного игрока из двери?",  "[DoorSaver] Удаление из базы", "Да", function()
					netstream.Start("arb.DoorRemoveOwner", k)

					chat.AddText("[DoorSaver] Вы успешно удалили игрока " .. v .. "(" .. k .. ") из двери.")
				end, "Нет")
				end)
				_:SetIcon("icon16/user_delete.png")
			end
		end

		local _ = subMenu4:AddOption("Убрать иконку", function()
			Derma_Query("Вы точно хотите изменить иконку двери?",  "[DoorSaver] Изменение иконки", "Да", function()
				netstream.Start("arb.DoorSetIcon", 0)
			end, "Нет")
		end)
		_:SetIcon("icon16/user_add.png")

		for k, v in pairs(Arbitrage.teams.data) do
			local _ = subMenu4:AddOption(v.name, function()
				Derma_Query("Вы точно хотите изменить иконку двери?",  "[DoorSaver] Изменение иконки", "Да", function()
					netstream.Start("arb.DoorSetIcon", k)
				end, "Нет")
			end)
			_:SetIcon("icon16/user_add.png")
		end


		parentMenu:Open(ScrW() / 2, ScrH() / 2)
	end
end

function PLUGIN:CalculateDoorTextPosition(door, reversed)
	local traceData = {}
	local obbCenter = door:OBBCenter()
	local obbMaxs = door:OBBMaxs()
	local obbMins = door:OBBMins()

	traceData.endpos = door:LocalToWorld(obbCenter)
	traceData.filter = ents.FindInSphere(traceData.endpos, 20)

	for k, v in pairs(traceData.filter) do
		if (v == door) then
			traceData.filter[k] = nil
		end
	end

	local length = 0
	local width = 0
	local size = obbMins - obbMaxs

	size.x = math.abs(size.x)
	size.y = math.abs(size.y)
	size.z = math.abs(size.z)

	if (size.z < size.x and size.z < size.y) then
		length = size.z
		width = size.y

		if (reverse) then
			traceData.start = traceData.endpos - (door:GetUp() * length)
		else
			traceData.start = traceData.endpos + (door:GetUp() * length)
		end
	elseif (size.x < size.y) then
		length = size.x
		width = size.y

		if (reverse) then
			traceData.start = traceData.endpos - (door:GetForward() * length)
		else
			traceData.start = traceData.endpos + (door:GetForward() * length)
		end
	elseif (size.y < size.x) then
		length = size.y
		width = size.x

		if (reverse) then
			traceData.start = traceData.endpos - (door:GetRight() * length)
		else

			traceData.start = traceData.endpos + (door:GetRight() * length)
		end
	end

	local trace = util.TraceLine(traceData)
	local angles = trace.HitNormal:Angle()

	if (trace.HitWorld and !reversed) then
		return self:CalculateDoorTextPosition(door, true)
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
	if (type(start) == "Player") then
		start = start:GetShootPos()
	elseif (type(start) == "Entity") then
		start = start:GetPos()
	end

	if (type(finish) == "Player") then
		finish = finish:GetShootPos()
	elseif (type(finish) == "Entity") then
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
	if (!self.Gradients[gradientType]) then return end

	surface.SetDrawColor(color.r, color.g, color.b, color.a)
	surface.SetTexture(self.Gradients[gradientType])
	surface.DrawTexturedRect(x, y, width, height)
end

function PLUGIN:DrawDoorText(entity, eyePos, eyeAngles, font, nameColor, textColor)
	local entityColor = entity:GetColor()
	if entityColor.a <= 0 or entity:IsEffectActive(EF_NODRAW) then return end

	local doorData = self:CalculateDoorTextPosition(entity)
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

		if (textWidth > longWidth) then longWidth = textWidth end


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

		if v:GetClass() != "func_door_rotating" or !faction then
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