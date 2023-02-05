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


local actionSize = 200
local padding = 15
local PANEL = {}
function PANEL:Init()
	self:SetTitle("")
	self:SetPos(0, 0)
	self:SetSize(EPaint.Width + actionSize + padding + 10, EPaint.Height + 40)
	self:MakePopup()
	self:Center()
	self:SetAlpha(0)
	self:AlphaTo(255, 0.5)
	self:ShowCloseButton(false)

	local close = self:Add("DButton")
	close:SetPos(self:GetWide() - H(70), 0)
	close:SetSize(H(70), H(30))
	close:SetText("")
	close.alpha = 40
	close.Paint = function(_, w, h)
	    _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 40)
	    draw.DrawText("X", "arb.Font_FuturaPTBook_7", w / 2, H(4), Color(255, 255, 255, _.alpha), TEXT_ALIGN_LEFT)
	end
	close.DoClick = function()
	    self:AlphaTo(0, 0.2, 0, function()
	        self:Remove()
	    end)
	end

	local actionPanel = self:Add("Panel")
	actionPanel:Dock(LEFT)
	actionPanel:SetWide(actionSize)
	actionPanel:DockMargin(0, H(5), padding, 0)
	actionPanel.Paint = function(_, w, h)
		surface.SetDrawColor(27, 10, 13, 150)
	    surface.DrawRect(0, 0, w, h)
	end

	self.sizeSlider = actionPanel:Add("DNumSlider")
	self.sizeSlider:SetText("Размер кисти:")
	self.sizeSlider:Dock(TOP)
	self.sizeSlider:SetMin(2)
	self.sizeSlider:SetMax(200)
	self.sizeSlider:SetValue(5)
	self.sizeSlider:SetDecimals(0)

	self.sizeSlider:GetChildren()[3]:SetFont("arb.Font_FuturaPTBook_5")

	local colorsPanel = actionPanel:Add("DPanel")
	colorsPanel:Dock(TOP)
	colorsPanel:SetTall(190)

	local function UpdateColors(col)
		self.color = col
	end

	self.color_picker = colorsPanel:Add("DRGBPicker")
	self.color_picker:Dock(LEFT)
	self.color_picker.OnChange = function(this, col)
		local h = ColorToHSV(col)
		local _, s, v = ColorToHSV(self.color_cube:GetRGB())

		col = HSVToColor(h, s, v)
		self.color_cube:SetColor(col)

		UpdateColors(col)
	end

	self.color_cube = colorsPanel:Add("DColorCube")
	self.color_cube:SetColor(Color(255, 255, 255))
	self.color_cube:Dock(FILL)
	self.color_cube.OnUserChanged = function(this, col)
		UpdateColors(col)
	end

	local cancel = actionPanel:Add("DButton")
	cancel:SetText("")
	cancel:SetTall(H(25))
	cancel:Dock(TOP)
	cancel.DoClick = function()
		local id = #self.array
		if id > 0 then
			table.remove(self.array, id)
		end
	end
	cancel.alpha = 0
	cancel.Paint = function(_, w, h)
	    _.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 255 or 30)
	    draw.DrawText("Отменить прошлое действие", "arb.Font_FuturaPTBook_6", w / 2, H(2), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

	    surface.SetDrawColor(255, 61, 96, 30)
	    surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
	end

	local label = actionPanel:Add("DLabel")
	label:SetText("Типы кисточек:")
	label:SetFont("arb.Font_FuturaPTBook_7")
	label:Dock(TOP)
	label:SizeToContents()

	for k, v in ipairs(EPaint.DrawingTypes) do
		local button = actionPanel:Add("DButton")
		button:SetText("")
		button:SetTall(H(25))
		button:Dock(TOP)
		button.DoClick = function()
			self.type = k
		end
		button.alpha = 0
		button.Paint = function(_, w, h)
		    _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() or self.type == k) and 255 or 30)
		    draw.DrawText(v.name, "arb.Font_FuturaPTBook_6", w / 2, H(2), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

		    surface.SetDrawColor(255, 61, 96, 30)
		    surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
		end
	end

	local saveButton = actionPanel:Add("DButton")
	saveButton:SetText("")
	saveButton:SetTall(H(25))
	saveButton:Dock(BOTTOM)
	saveButton:SetTall(H(40))
	saveButton.DoClick = function()
		if LocalPlayer().EPaint_Sending then return end
		Arbitrage.notify.Add("Передаем данные...")

		LocalPlayer().EPaint_Sending = true
		netstream.Heavy("EPaint:Save", self.idx, self.array)
	end
	saveButton.alpha = 0
	saveButton.Paint = function(_, w, h)
	    _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() or self.type == k) and 255 or 30)
	    draw.DrawText("Сохранить", "arb.Font_FuturaPTBook_6", w / 2, H(10), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

	    surface.SetDrawColor(255, 61, 96, 30)
	    surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
	end

	local resetButton = actionPanel:Add("DButton")
	resetButton:SetText("")
	resetButton:SetTall(H(25))
	resetButton:Dock(BOTTOM)
	resetButton.DoClick = function()
		self.array = {}
	end
	resetButton.alpha = 0
	resetButton.Paint = function(_, w, h)
	    _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() or self.type == k) and 255 or 30)
	    draw.DrawText("Сбросить", "arb.Font_FuturaPTBook_6", w / 2, H(2), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

	    surface.SetDrawColor(255, 61, 96, 30)
	    surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
	end

	local configButton = actionPanel:Add("DButton")
	configButton:SetText("")
	configButton:SetTall(H(25))
	configButton:Dock(BOTTOM)
	configButton:DockMargin(0, 0, 0, 5)
	configButton.DoClick = function()
		local Menu = DermaMenu()
		Menu:AddOption("Сохранить рисунок", function()
			Derma_StringRequest("Сохранение рисунка", "Введите название документа в который вы хотите сохранить данный рисунок", "", function(text)
				file.Write("academy_epaint_configs/" .. text .. ".txt", util.TableToJSON(self.array))
			end, nil, "Сохранить", "Отменить")
		end):SetIcon("icon16/add.png")

		local Child, Parent = Menu:AddSubMenu("Загрузить рисунок")
		Parent:SetIcon("icon16/arrow_down.png")

		local files = file.Find("academy_epaint_configs/*", "DATA")
		for k, v in ipairs(files) do
			Child:AddOption(v, function()
				local data = util.JSONToTable(file.Read("academy_epaint_configs/" .. v, "DATA"))
				table.Add(self.array, data)
			end)
		end

		Menu:Open()
	end
	configButton.alpha = 0
	configButton.Paint = function(_, w, h)
	    _.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() or self.type == k) and 255 or 30)
	    draw.DrawText("Сохранения", "arb.Font_FuturaPTBook_6", w / 2, H(2), Color(255, 220, 228, _.alpha), TEXT_ALIGN_CENTER)

	    surface.SetDrawColor(255, 61, 96, 30)
	    surface.DrawRect(w * 0.2, h - 2, w - (w * 0.2) * 2, 2)
	end

	local drawPanel = self:Add("Panel")
	drawPanel:SetTall(EPaint.Height)
	drawPanel:Dock(TOP)
	drawPanel:DockMargin(0, H(5), 0, 0)
	drawPanel.PaintOver = function(this, w, h)
		surface.SetDrawColor(27, 10, 13, 150)
	    surface.DrawRect(0, 0, w, h)

		asterionlib.DrawRender(function()
			surface.SetDrawColor(255, 255, 255)
			surface.DrawRect(0, 0, EPaint.Width, EPaint.Height)
		end, function()
			EPaint:Drawing(self.array)
		end)

		if this:IsHovered() then
			local x, y = this:LocalCursorPos()
			local size = self.sizeSlider:GetValue()

			draw.NoTexture()
			surface.SetDrawColor(ColorAlpha(self.color, 100))

			local drawing = EPaint.DrawingTypes[self.type]
			this:SetCursor(drawing.cursor or "blank")
			drawing.data(x, y, size, self.beforeX, self.beforeY)

			local onLeftClick = input.IsMouseDown(MOUSE_LEFT)
			if onLeftClick then
				if !self.bLeftClick then
					self.beforeX = x
					self.beforeY = y
				end

				self.bLeftClick = true

				local allow = true
				local lastArray = self.array[#self.array]
				if lastArray then
					local lastX, lastY, lastSize = lastArray[3], lastArray[4], lastArray[5]

					if lastX == x and lastY == y and lastSize == size then
						allow = false
					end
				end

				if (x <= 0 or x >= EPaint.Width) or (y <= 0 or y >= EPaint.Height) then
					allow = false
				end

				if allow and !drawing.saveBefore then
					table.insert(self.array, {
						self.type,
						self.color,
						x,
						y,
						size
					})

					--print("save 1 " .. RealTime())
				end
			else
				self.bLeftClick = nil
				if drawing.saveBefore and !self.bLeftClick and self.beforeX and self.beforeY then
					table.insert(self.array, {
						self.type,
						self.color,
						x,
						y,
						size,
						self.beforeX,
						self.beforeY
					})

					--print("save 2 " .. RealTime())
				end

				self.beforeX = nil
				self.beforeY = nil
			end

			if input.IsMouseDown(MOUSE_RIGHT) then
				local id = #self.array
				if id > 0 then
					table.remove(self.array, id)
				end
			end
		end

		surface.SetDrawColor(255, 61, 96, 165.75)
		surface.DrawOutlinedRect(0, 0, EPaint.Width, EPaint.Height)
	end
	drawPanel.OnMouseWheeled = function(this, value)
		self.sizeSlider:SetValue(self.sizeSlider:GetValue() + value * 2)
	end

	self.idx = nil
	self.array = {}
	self.color = Color(255, 255, 255)
	self.type = 1
end

function PANEL:SetData(idx, array)
	self.idx = idx
	self.array = array
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(41, 22, 25)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(255, 61, 96, 165.75)
	surface.DrawOutlinedRect(0, 0, w, h, 2)

	surface.SetDrawColor(255, 61, 96, 165.75)
	surface.DrawOutlinedRect(0, 0, w, H(30), 2)

	surface.SetDrawColor(255, 61, 96, 20)
	surface.DrawRect(0, 0, w, H(30))

	draw.DrawText("Доска", "arb.Font_FuturaPTDemi_8", W(10), H(3), color_white, TEXT_ALIGN_LEFT)
end

vgui.Register("EPaint:Editor", PANEL, "DFrame")