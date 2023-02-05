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

local PLUGIN = PLUGIN

local circles = asterionlib.Circles
local PANEL = {}

function PANEL:Init()
	if IsValid(Arbitrage.gui.radialmenu) then
		Arbitrage.gui.radialmenu:Remove()
	end

	Arbitrage.gui.radialmenu = self

	LocalPlayer():EmitSound("academy/radialmenu/whoosh" .. math.random(1, 6) .. ".wav")

	self:SetPos(0, 0)
	self:SetSize(ScrW(), ScrH())
	self:MakePopup()
	self:SetAlpha(0)
	self:AlphaTo(255, 0.5)
	self:SetKeyboardInputEnabled(false)

	self.radialSize = self:GetTall() * 0.3

	self.options = {}
	self.clampKeys = {}

	self.m_r = self:GetWide()
	self.m_x = self:GetWide() / 2
	self.m_y = self:GetTall() / 2
	self.size = 80

	self.selSize = 2
	self.textAlpha = 0

	self.background = circles.New(CIRCLE_OUTLINED, self.m_r + self.size, self.m_x, self.m_y, self.size * 2)
	self.background:SetMaterial(true)
	self.background:SetColor(color_black)

	self.filled = circles.New(CIRCLE_FILLED, 150, self.m_x, self.m_y)
	self.filled:SetColor(Color(60, 60, 60, 120))

	self.options = PLUGIN:MainOption()
end

function PANEL:FindSelected(segment_size)
	local mouse_pos = Vector(input.GetCursorPos())
	mouse_pos:Sub(Vector(self.m_x, self.m_y, 0))

	local mouse_ang = math.atan2(mouse_pos[2], mouse_pos[1]) * 180 / math.pi

	if mouse_ang < 0 then
		mouse_ang = 360 + mouse_ang
	end

	return math.floor(mouse_ang / segment_size)
end

function PANEL:NewClose()
	if self.bClose then return end
	self.bClose = true

	LocalPlayer():EmitSound("academy/radialmenu/whoosh" .. math.random(1, 6) .. ".wav")

	self:SetMouseInputEnabled(false)
	self:AlphaTo(0, 0.3, 0, function()
		self:Remove()

		PLUGIN.clampingTime = RealTime()
		PLUGIN.isClose = false
	end)

	PLUGIN.isClose = true
end

function PANEL:SelectOption(id)
	local option = self.options[id]
	if !option then return end

	local segment_size = 360 / #self.options
	local a = math.rad(segment_size * (id - 1) + segment_size / 2)
	local x = self.m_x + math.cos(a) * self.m_r
	local y = self.m_y + math.sin(a) * self.m_r

	local action = option.action
	if isfunction(action) then
		LocalPlayer():EmitSound("academy/radialmenu/press.wav")
		local info, backFunc = action(PLUGIN, self)

		if istable(info) then
			self.options = info
			self.m_r = self.m_r + 50
			self.selSize = self.selSize + 20
			self.textAlpha = 0

			self.backFunc = backFunc
		else
			self:NewClose()
		end
	end

	return x, y
end

function PANEL:OnLeftClick()
	if self.bClose then return end
	if !self.selected then return end

	self:SelectOption(self.selected + 1)
end

function PANEL:OnRightClick()
	if self.bClose then return end

	if self.backFunc and isfunction(self.backFunc) then
		local info, backFunc = self.backFunc(PLUGIN, self)

		if istable(info) then
			self.options = info
			self.m_r = self.m_r + 50
			self.selSize = self.selSize + 20
			self.textAlpha = 0

			self.backFunc = backFunc
			LocalPlayer():EmitSound("academy/radialmenu/press.wav")
		end
	else
		self:NewClose()
	end
end

function PANEL:OnMiddleClick()
	local option = self.options[self.selected + 1]
	if !option then return end

	local id = option.id
	if !id then return end

	local data = asterionlib.data:Get("radialmenu_favorites", {})

	local find = nil
	for k, v in ipairs(data) do
		if id == v then
			find = k
		end
	end

	if find then
		table.remove(data, find)
	else
		table.insert(data, id)
	end

	asterionlib.data:Set("radialmenu_favorites", data)
end

function PANEL:OnRotate()
	self.m_r = self.m_r + 8
	self.selSize = self.selSize + 8
	self.textAlpha = 0

	LocalPlayer():EmitSound("academy/radialmenu/rollover.wav")
end

function PANEL:Think()
	local onLeftClick = input.IsMouseDown(MOUSE_LEFT)
	if onLeftClick then
		if !self.bLeftClick then
			self:OnLeftClick()
		end

		self.bLeftClick = true
	else
		self.bLeftClick = nil
	end

	local onRightClick = input.IsMouseDown(MOUSE_RIGHT)
	if onRightClick then
		if !self.bRightClick then
			self:OnRightClick()
		end

		self.bRightClick = true
	else
		self.bRightClick = nil
	end

	local onMiddleClick = input.IsMouseDown(MOUSE_MIDDLE)
	if onMiddleClick then
		if !self.bMiddleClick then
			self:OnMiddleClick()
		end

		self.bMiddleClick = true
	else
		self.bMiddleClick = nil
	end

	local data = {}
	for i = 1, 9 do data[#data + 1] = i end
	for i = 37, 46 do data[#data + 1] = i end

	for k, i in ipairs(data) do
		local onDown = input.IsKeyDown(i + 1)

		if onDown then
			if !self.clampKeys[i] then
				if self.bClose then return end
				if !self.selected then return end

				local info = k < 10 and i or i - 36
				local x, y = self:SelectOption(info)

				if x and y then
					input.SetCursorPos(x, y)
				end
			end

			self.clampKeys[i] = true
		else
			self.clampKeys[i] = nil
		end
	end
end

local lmbMat = Material("gui/lmb.png")
local rmbMat = Material("gui/rmb.png")
local starMat = Material("icon16/star.png")

function PANEL:Paint(w, h)
	local ft = FrameTime()

	self.m_r = Lerp(ft * (self.bClose and 2 or 15), self.m_r, self.bClose and self:GetWide() / 2 or self.radialSize)
	self.selSize = Lerp(ft * 10, self.selSize, 2)
	self.textAlpha = Lerp(ft * 7, self.textAlpha, 256)

	local segment_size = 360 / #self.options
	self.selected = self.selected or nil
	if !self.bClose then
		self.selected = self:FindSelected(segment_size)
	end

	if !self.selected then return end

	self.oldselected = self.oldselected or self.selected

	asterionlib.DrawBlur(self, 6)

	self.filled:SetRadius(self.m_r - self.size - 20)
	self.background:SetRadius(self.m_r + self.size)

	self.background:SetOutlineWidth(self.size * 2)
	self.background()

	self.rotate = self.rotate or self.selected * segment_size
	self.rotate = Lerp(FrameTime() * 20, self.rotate, self.selected * segment_size)

	local outline1 = circles.New(CIRCLE_OUTLINED, self.m_r + self.size + self.selSize, self.m_x, self.m_y, self.size * 2 + self.selSize * 2)
	outline1:SetColor(Color(255, 41, 76))
	outline1:SetRotation(self.rotate)
	outline1:SetEndAngle(360 / #self.options)
	outline1()

	local outline2 = circles.New(CIRCLE_OUTLINED, self.m_r + self.size, self.m_x, self.m_y, self.size * 2)
	outline2:SetColor(color_black)
	outline2:SetRotation(self.rotate)
	outline2:SetEndAngle(360 / #self.options)
	outline2()

	self.filled()

	local data = asterionlib.data:Get("radialmenu_favorites", {})

	for i = 0, #self.options - 1 do
		local option = self.options[i + 1]

		local a = math.rad(segment_size * i + segment_size / 2)
		local x = self.m_x + math.cos(a) * self.m_r
		local y = self.m_y + math.sin(a) * self.m_r

		local color = self.selected == i and Color(255, 41, 76) or color_white

		if option.id then
			for k, v in ipairs(data) do
				if v == option.id then
					local size = self:GetTall() * 0.035

					surface.SetDrawColor(255, 255, 255)
					surface.SetMaterial(starMat)
					surface.DrawTexturedRect(x - size, y - size, size * 2, size * 2)
					break
				end
			end
		end

		if option.icon then
			local size = self:GetTall() * 0.03

			surface.SetDrawColor(color)
			surface.SetMaterial(option.icon)
			surface.DrawTexturedRect(x - size, y - size, size * 2, size * 2)
		else
			draw.SimpleText(option.name, "arb.Font_FuturaPTBook_10", x, y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local b = self.m_r * 0.8
		draw.SimpleText(i + 1, "arb.Font_FuturaPTDemi_5", self.m_x + math.cos(a) * b, self.m_y + math.sin(a) * b, Color(255, 255, 255, 50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local option = self.options[self.selected + 1]
	if option then
		local name = option.name
		local description = option.description
		local icon = option.icon

		if icon then
			local size = self:GetTall() * 0.1

			surface.SetDrawColor(ColorAlpha(color_white, self.textAlpha))
			surface.SetMaterial(icon)
			surface.DrawTexturedRect(w / 2 - size / 2, h / 2 - size / 2 - size * 0.7, size, size)
		end

		draw.SimpleText(name, "arb.Font_FuturaPTDemi_13", w / 2, h / 2, ColorAlpha(color_white, self.textAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if description then
			local descFont = "arb.Font_FuturaPTBook_8"
			local fontHeight = draw.GetFontHeight(descFont)
			option.wrap = option.wrap or asterionlib.WrapText(description, self.radialSize, descFont)

			for k, v in ipairs(option.wrap) do
				draw.SimpleText(v, descFont, w / 2, h / 2 + k * fontHeight, ColorAlpha(Color(220, 220, 220), self.textAlpha), TEXT_ALIGN_CENTER)
			end
		end
	end

	local size = H(30)
	if option and option.id then
		local tall = H(105)
		local width, height = draw.SimpleText("Добавить в избранное", "arb.Font_FuturaPTBook_8", w / 2, h - tall, color_white, TEXT_ALIGN_CENTER)
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(Material("err.png"))
		surface.DrawTexturedRect(w / 2 - size / 2 - width / 2 - size / 2, h - tall - height * 0.25, size, size)
	end

	do
		local tall = H(70)
		local width, height = draw.SimpleText("Выбрать опцию", "arb.Font_FuturaPTBook_8", w / 2, h - tall, color_white, TEXT_ALIGN_CENTER)
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(lmbMat)
		surface.DrawTexturedRect(w / 2 - size / 2 - width / 2 - size / 2, h - tall - height * 0.25, size, size)
	end

	if isfunction(self.backFunc) then
		local tall = H(35)
		local width, height = draw.SimpleText("Вернуться назад", "arb.Font_FuturaPTBook_8", w / 2, h - tall, color_white, TEXT_ALIGN_CENTER)
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(rmbMat)
		surface.DrawTexturedRect(w / 2 - size / 2 - width / 2 - size / 2, h - tall - height * 0.25, size, size)
	end

	if self.selected != self.oldselected then
		self:OnRotate()
	end

	self.oldselected = self.selected
end

vgui.Register("Radial:Menu", PANEL, "Panel")