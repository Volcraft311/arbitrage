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


local PANEL = {}

local optionData = {
	lobbyList = function(key, value)
		return Format("ID: %s / Vector(%s, %s, %s)", key, value.x, value.y, value.z)
	end,
	spawnList = function(key, value)
		return Format("ID: %s / Vector(%s, %s, %s)", key, value.x, value.y, value.z)
	end,
	placesList = function(key, value)
		local pos, ang = value[1], value[2]

		return Format("ID: %s / Vector(%s, %s, %s), Angle(%s, %s, %s)", key, pos.x, pos.y, pos.z, ang[1], ang[2], ang[3])
	end,
	camPos = function(key, value)
		local pos, ang = value[1], value[2]

		return Format("Vector(%s, %s, %s), Angle(%s, %s, %s)", pos.x, pos.y, pos.z, ang[1], ang[2], ang[3])
	end,
	camPosPlaces = function(key, value)
		return Format("ID: %s / Vector(%s, %s, %s)", key, value.x, value.y, value.z)
	end,
}

local actionData = {
	lobbyList = {
		remove = function(key, value)
			return {key, nil}
		end,
		add = function(key, data)
			return {key, data[1]}
		end
	},
	spawnList = {
		remove = function(key, value)
			return {key, nil}
		end,
		add = function(key, data)
			return {key, data[1]}
		end
	},
	placesList = {
		remove = function(key, value)
			return {key, nil}
		end,
		add = function(key, data)
			return {key, data[1], data[2]}
		end
	},
	camPosEnd = {
		remove = function(key, value)
			return nil
		end,
		add = function(key, data)
			return {data[1]}
		end,
		noReqeust = true
	},
	camPos = {
		remove = function(key, value)
			return nil
		end,
		add = function(key, data)
			return {data[1], data[2]}
		end,
		noReqeust = true
	},
	camPosPlaces = {
		remove = function(key, value)
			return {key, nil}
		end,
		add = function(key, data)
			return {key, data[1], data[2]}
		end
	},
}

local titleData = {
	lobbyList = "Расположение мест в лобби:",
	spawnList = "Расположение мест при запуске игры:",
	placesList = "Расположение мест на суде:",
	camPosEnd = "Расположение основной камеры:",
	camPos = "Расположение начальной камеры:",
	camPosPlaces = "Расположение камеру у мест:"
}

local textData = {
	lobbyList = "Установить новое место в лобби",
	spawnList = "Установить новое место при запуске игры",
	placesList = "Установить место на суде",
	camPosEnd = "Установить основную камеру",
	camPos = "Установить начальную камеру",
	camPosPlaces = "Установить камеру у места"
}

local function ReturnOptionName(id, key, value)
	if !optionData[id] then return tostring(value) end

	return optionData[id](key, value)
end

local function ReturnTitleName(id)
	if !titleData[id] then return tostring(id) end

	return titleData[id]
end

local function ReturnTextName(id)
	if !textData[id] then return tostring(id) end

	return textData[id]
end

local function ReturnActionClear(id, key, value)
	if actionData[id] and actionData[id].remove then
		return actionData[id].remove(tonumber(key), value)
	end

	return {}
end

local function ReturnActionAdd(id, key, value)
	if actionData[id] and actionData[id].add then
		return actionData[id].add(tonumber(key), value)
	end

	return {}
end


local size = 0.4
function PANEL:Init()
	self:SetTitle("Меню редактирования")
	self:SetSize(ScrW() * size, ScrH() * (size * 2))
	self:Center()
	self:MakePopup()

	self:SetKeyboardInputEnabled(false)

	local configButton = self:Add("DButton")
	configButton:SetText("")
	configButton:Dock(BOTTOM)
	configButton.alpha = 0
	configButton:SetTall(H(30))
	configButton.Paint = function(_, w, h)
		 _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)

		surface.SetDrawColor(15, 5, 6, 150)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(155, 35, 57, _.alpha)
		surface.DrawOutlinedRect(0, 0, w, h, 2)

		draw.DrawText("Конфигурация", "arb.Font_FuturaPTBook_8", w / 2, H(2), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)
	end
	configButton.DoClick = function()
		local Menu = DermaMenu()
			Menu:AddOption("Сохранить конфигурацию", function()
				Derma_StringRequest("Сохранить конфигурацию", "Введите название документа в который сохраниться конфигурация из Editor-а", "", function(text)
					local data = util.TableToJSON(Editor:GetStored())

					file.Write("academy_editor_configs/" .. text .. ".txt", data)
					chat.AddText("Ваш конфиг успешно был сохранен в файл: " .. text .. ".txt")
				end)
			end):SetIcon("icon16/add.png")

			local subMenu, parentMenuOption = Menu:AddSubMenu("Загрузить конфигурацию")
			parentMenuOption:SetIcon("icon16/cd.png")

			local files, _ = file.Find("academy_editor_configs/*.txt", "DATA" )
			for k, v in ipairs(files) do
				subMenu:AddOption(v, function()
					local data = util.JSONToTable(file.Read("academy_editor_configs/" .. v, "DATA"))

					netstream.Start("Editor:LoadConfig", data)
					timer.Simple(0.3, function() self:GetData() end)
				end)
			end
		Menu:Open()
	end

	local _ = self:Add("DPanel")
	_:Dock(FILL)
	_:DockMargin(5, 5, 5, 5)
	_.Paint = function(_, w, h)
		surface.SetDrawColor(27, 10, 13, 150)
	    surface.DrawRect(0, 0, w, h)
	end

	self.infoPanel = _:Add("DScrollPanel")
	self.infoPanel:Dock(FILL)
	self.infoPanel:DockMargin(5, 5, 5, 5)

	local _ = self:Add("DPanel")
	_:SetTall(self:GetTall() * 0.15)
	_:Dock(BOTTOM)
	_:DockMargin(5, 10, 5, 5)
	_.Paint = function(_, w, h)
		surface.SetDrawColor(27, 10, 13, 150)
	    surface.DrawRect(0, 0, w, h)
	end

	self.actionPanel = _:Add("DScrollPanel")
	self.actionPanel:Dock(FILL)
	self.actionPanel:DockMargin(5, 5, 5, 5)

	self:GetData()
	self:InitButtons()
end

function PANEL:InitButtons()
	for k, v in pairs(textData) do
		local name = ReturnTextName(k)

		local button = self.actionPanel:Add("DButton")
		button:SetText("")
		button:Dock(TOP)
		button:DockMargin(0, 0, 0, 5)
		button:SetTall(H(25))
		button.alpha = 0
		button.Paint = function(_, w, h)
			 _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)

			surface.SetDrawColor(15, 5, 6, 150)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(155, 35, 57, _.alpha)
			surface.DrawOutlinedRect(0, 0, w, h, 2)

			draw.DrawText(name, "arb.Font_FuturaPTBook_8", w / 2, 0, Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)
		end

		button.DoClick = function()
			local client = LocalPlayer()
			local pos, ang = client:GetPos() + Vector(0, 0, 64), client:GetAngles()

			if actionData[k].noReqeust then
				local action = ReturnActionAdd(k, nil, {pos, ang})
				netstream.Start("Editor:ChangeProperty", k, action)

				timer.Simple(0.3, function() self:GetData() end)
			else
				Derma_StringRequest("Номер", "Введите номер нужного вам места", "", function(text)
					local action = ReturnActionAdd(k, text, {pos, ang})
					netstream.Start("Editor:ChangeProperty", k, action)

					timer.Simple(0.3, function() self:GetData() end)
				end)
			end
		end
	end
end


function PANEL:GetData()
	self.panels = self.panels or {}

	for k, v in ipairs(self.panels) do
		if IsValid(v) then
			v:Remove()
		end
	end

	local data = Editor:GetStored()

	for k, v in pairs(data) do
		local panel = self:AddInfo(self.infoPanel, k, v)

		self.panels[#self.panels + 1] = panel
	end
end

function PANEL:AddInfo(dp, id, data)
	local panel = dp:Add("Panel")
	panel:Dock(TOP)

	local name = ReturnTitleName(id)

	local title = panel:Add("DLabel")
	title:Dock(TOP)
	title:SetText(name)
	title:SizeToContents()

	local _ = panel:Add("DPanel")
	_:SetTall(105)
	_:Dock(TOP)
	_:DockMargin(5, 5, 5, 5)
	_.Paint = function(_, w, h)
		surface.SetDrawColor(255, 61, 96, 165.75)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	local info = _:Add("DScrollPanel")
	info:Dock(FILL)

	data = istable(data) and data or {data}

	-- у меня нет идей как это можно красиво реализовать, так что пока что так
	if id == "monokumPlace" or id == "camPos" then
		data = {data}
	end

	for k, v in pairs(data) do
		local text = ReturnOptionName(id, k, v)

		local checkBox = info:Add("DCheckBoxLabel")
		checkBox:SetText(text)
		checkBox:SetChecked(true)
		checkBox:Dock(TOP)
		checkBox:DockMargin(5, 5, 0, 0)
		checkBox:SizeToContents()

		checkBox.OnChange = function(_, value)
			checkBox:SetChecked(true)

			local Menu = DermaMenu()
				Menu:AddOption("Да, я хочу удалить это!", function()
					local action = ReturnActionClear(id, k, v)
					netstream.Start("Editor:ChangeProperty", id, action)

					timer.Simple(0.5, function()
						self:GetData()
					end)
				end)
			Menu:Open()
		end
	end

	panel:InvalidateLayout(true)
	panel:SizeToChildren(false, true)

	return panel
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(41, 22, 25)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(255, 61, 96, 165.75)
	surface.DrawOutlinedRect(0, 0, w, h, 2)
end

vgui.Register("Editor:MenuAdd", PANEL, "DFrame")



local deleteData = {
	lobbyList = "Удалить места в лобби",
	spawnList = "Удалить места при запуске игры",
	placesList = "Удалить места на суде",
	camPosEnd = "Удалить расположение основной камеры",
	camPos = "Удалить расположение начальной камеры",
	camPosPlaces = "Удалить расположение камер у всех мест"
}

local PANEL = {}

local size = 0.3
function PANEL:Init()
	self:SetTitle("Меню редактирования")
	self:SetSize(ScrW() * size, ScrH() * size)
	self:Center()
	self:MakePopup()

	self:SetKeyboardInputEnabled(false)

	local scrollBar = self:Add("DScrollPanel")
	scrollBar:Dock(FILL)
	scrollBar:DockMargin(5, 5, 5, 5)

	for k, v in pairs(deleteData) do
		local name = deleteData[k]

		local button = scrollBar:Add("DButton")
		button:SetText("")
		button:Dock(TOP)
		button:DockMargin(0, 0, 0, 5)
		button:SetTall(H(25))
		button.alpha = 0
		button.Paint = function(_, w, h)
			 _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)

			surface.SetDrawColor(15, 5, 6, 150)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(155, 35, 57, _.alpha)
			surface.DrawOutlinedRect(0, 0, w, h, 2)

			draw.DrawText(name, "arb.Font_FuturaPTBook_8", w / 2, 0, Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)
		end

		button.DoClick = function()
			netstream.Start("Editor:ChangeProperty", k, nil)
		end
	end
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(41, 22, 25)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(255, 61, 96, 165.75)
	surface.DrawOutlinedRect(0, 0, w, h, 2)
end

vgui.Register("Editor:MenuDelete", PANEL, "DFrame")