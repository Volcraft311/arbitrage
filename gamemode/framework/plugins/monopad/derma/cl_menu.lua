surface.CreateFont("MonoPad:TimeFont", {
	font = "Futura PT Demi",
	extended = true,
	size = 20,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

local logo = Material("danganronpa/monopad/logo.png")
local cursor = Material("icon16/cursor.png")

local PANEL = {}

function PANEL:Init()
	local ui = MonoPad:GetUI()
	if IsValid(ui) then ui:Remove() end

	Arbitrage.gui.tabletUI = self

	self:SetPos(0, 0)
	self:SetSize(930, 618)

	self.cursorX = self:GetWide() / 2
	self.cursorY = self:GetTall() / 2
	self.editing = false
	self.selectcategory = nil

	LocalPlayer().metaPanels = {}
end

function PANEL:AddTooltip(panel, title, description, color, time, callback)
	panel.OThink = panel.OThink or panel.Think

	panel.hoverTime = nil
	panel.Think = function(this)
		if this:IsHovered() and (callback and callback()) then
			if !this.hoverTime then
				this.hoverTime = RealTime() + 0.5
			end
		else
			this.hoverTime = nil
		end

		if this.hoverTime and RealTime() > this.hoverTime then
			self.tooltip:Show(panel, title, description, color, time)
		end
	end
end

function PANEL:SetObject(monopad)
	self.monopad = monopad
end

function PANEL:FindMonoPad()
	local client = LocalPlayer()
	local inventory = client:GetInventory()
	if inventory then
	    local items = inventory:GetItems()

	    for _, item in ipairs(items) do
	        if item.uniqueID == "monopad" and item:GetData("equip") then
	            return item.stored
	        end
	    end
	end
end

function PANEL:PerformLayout(w, h)
	if !self.chooks then
		self:CreateHooks()

		self.chooks = true
	end
end

function PANEL:DrawScanLine()
	if IsValid(self.scanline) then return end

	local gradientLeft = surface.GetTextureID("vgui/gradient-l")
	local gradientRight = surface.GetTextureID("vgui/gradient-r")
	local size = 100

	self.scanline = self:Add("DPanel")
	self.scanline:SetSize(self:GetWide(), self:GetTall())
	self.scanline:SetZPos(30001)
	self.scanline.Paint = function(_, w, h)
		surface.SetDrawColor(color_white)

		surface.SetDrawColor(Color(0, 0, 0, 170))
		surface.SetTexture(gradientLeft)
		surface.DrawTexturedRect(0, 0, size, h)

		surface.SetTexture(gradientRight)
		surface.DrawTexturedRect(w - size, 0, size, h)
	end
end

function PANEL:CreateHooks()
	timer.Create("MonoPad:Update", 0.5, 0, function()
		local class = LocalPlayer():GetActiveWeaponClass()

		if class != "academy_monopad" or !IsValid(self) then
			self:RemoveHooks()
		end
	end)

	hook.Add("SetupMove", "MonoPad:SetupMove", function(client, mv, cmd)
		if !IsValid(self) then
			return self:RemoveHooks()
		end

		if !self.editing then return end

		local monopad_smoothness = SETTINGS.options.Get("monopad_smoothness")
		local speed = monopad_smoothness * 0.033

		local x, y = cmd:GetMouseX() * speed, cmd:GetMouseY() * speed

		self.cursorX = math.Clamp(self.cursorX + x, 0, self:GetWide())
		self.cursorY = math.Clamp(self.cursorY + y, 0, self:GetTall())
	end)

	hook.Add("InputMouseApply", "MonoPad:InputMouseApply", function(cmd, x, y, angle)
		if !IsValid(self) then
			return self:RemoveHooks()
		end

		if !self.editing then return end

		return true
	end)

	local function findpanels()
		local panels = {}
		for k, v in ipairs(LocalPlayer().metaPanels or {}) do
			if v:IsHovered() then
				panels[#panels + 1] = v
			end
		end

		return panels
	end

	local function click()
		local panels = findpanels()

		for k, v in ipairs(panels) do
			if v.DoClick then
				v:DoClick()
			end
		end
	end

	local function scroll(inNext)
		local panels = findpanels()
		local amount = self.noWeapon and 40 or 20
		local value = inNext and amount or -amount

		for k, v in ipairs(panels) do
			if v:GetName() == "DScrollPanel" then
				local bar = v.VBar
				bar:SetScroll(bar:GetScroll() + value)
			else
				if v.SetScroll then
					v:SetScroll(v:GetScroll() + value)
				end
			end
		end
	end

	hook.Add("PlayerBindPress", "MonoPad:PlayerBindPress", function(client, bind, pressed, code)
		if !IsValid(self) then
			return self:RemoveHooks()
		end

		if !pressed then return end

		if bind == "+attack" then
			click()

			return true
		elseif bind == "+jump" and IsValid(self.cursor) then
			self.editing = !self.editing

			return true
		elseif bind == "+reload" then
			self.hidehands = !self.hidehands
		end
	end)

	hook.Add("PlayerBindScroll", "MonoPad:PlayerBindScroll", function(client, pressed, inNext)
		if !pressed then return end

		if !IsValid(self) then
			return self:RemoveHooks()
		end

		scroll(inNext)
	end)

	hook.Add("PreDrawPlayerHands", "MonoPad:PreDrawPlayerHands", function(hands, vm, client, weapon)
		if !IsValid(self) then
			return self:RemoveHooks()
		end

		return self.hidehands
	end)

	if !self.noWeapon then return end

	local isDown = false
	hook.Add("Think", "MonoPad:Think", function()
		if !IsValid(self) then
			return self:RemoveHooks()
		end

		local isPress = input.IsMouseDown(MOUSE_LEFT)

		if isPress then
			if !isDown then
				click()
			end

			isDown = true
		else
			isDown = false
		end
	end)

	hook.Add("PlayerButtonDown", "MonoPad:PlayerButtonDown", function(client, button)
		if !IsValid(self) then
			return self:RemoveHooks()
		end

		local isScroll = button == 112 or button == 113
		if isScroll then
			scroll(button == 113)
		end
	end)
end

function PANEL:RemoveHooks()
	hook.Remove("SetupMove", "MonoPad:SetupMove")
	hook.Remove("InputMouseApply", "MonoPad:InputMouseApply")
	hook.Remove("PlayerBindScroll", "MonoPad:PlayerBindScroll")
	hook.Remove("PreDrawPlayerHands", "MonoPad:PreDrawPlayerHands")
	hook.Remove("PlayerBindPress", "MonoPad:PlayerBindPress")
	hook.Remove("Think", "MonoPad:Think")
	hook.Remove("PlayerButtonDown", "MonoPad:PlayerButtonDown")

	timer.Remove("MonoPad:Update")

	self:Remove()
end

function PANEL:OnRemove()
	self:RemoveHooks()
end

function PANEL:Intro()
	self:DrawScanLine()

	local logoSize = 300

	self.intro = self:Add("Panel")
	self.intro:Dock(FILL)
	self.intro:SetAlpha(0)
	self.intro:AlphaTo(255, 1, 0)
	self.intro.Paint = function(_, w, h)
		draw.RoundedBox(10, 0, 0, w, h, Color(34, 34, 34))

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(logo)
		surface.DrawTexturedRect(w / 2 - logoSize / 2, h / 2 - logoSize / 2 - 30, logoSize, logoSize)

		draw.SimpleText("Asterion OS", "arb.Font_FuturaPTDemi_10", w / 2 + 160, h - 148, color_black, TEXT_ALIGN_RIGHT)
	end

	local loading = self.intro:Add("Panel")
	loading:SetTall(26)
	loading:Dock(BOTTOM)
	loading:DockMargin(301, 0, 301, 150)
	loading.Paint = function(_, w, h)
		surface.SetDrawColor(0, 0, 0)
		surface.DrawOutlinedRect(0, 0, w, h, 3)
	end

	local data = {}
	for i = 1, 18 do
		data[#data + 1] = math.random() * 4
	end

	for k, v in ipairs(data) do
		timer.Simple(v, function()
			if !IsValid(self) then return end

			local p = loading:Add("Panel")
			p:SetWide(15)
			p:Dock(LEFT)
			p:DockMargin(3, 3, 0, 3)
			p.Paint = function(_, w, h)
				surface.SetDrawColor(68, 68, 68)
				surface.DrawRect(0, 0, w, h)
			end
		end)
	end

	local time = math.max(unpack(data)) + 1

	timer.Simple(time, function()
		if !IsValid(self) then return end

		self:Menu()
	end)
end

function PANEL:DrawCursor()
	self.cursor = self:Add("DPanel")
	self.cursor:SetSize(20, 20)
	self.cursor:SetZPos(30000)
	self.cursor.Paint = function(_, w, h)
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(cursor)
		surface.DrawTexturedRect(-4, 0, w, h)
	end
	self.cursor.Think = function(this)
		local cursorX, cursorY = self.cursorX, self.cursorY

		if self.noWeapon then
			cursorX, cursorY = gui.MouseX() - self:GetX(), gui.MouseY() - self:GetY()
		end

		this:SetPos(cursorX, cursorY)
	end

	if self.noWeapon then
		self.cursor:SetAlpha(0)
	end

	self.tooltip = self:Add("DPanel")
	self.tooltip:SetAlpha(0)
	self.tooltip:SetSize(0, 80)
	self.tooltip:SetZPos(30001)
	self.tooltip.isHide = false
	self.tooltip.Think = function(this)
		local x, y = self.cursor:GetPos()
		x = x + self.cursor:GetWide()

		this:SetPos(x, y)

		if (!this.UpdateCD or RealTime() >= this.UpdateCD) then
			if this.selected then
				if IsValid(this.selected) and this.selected.hoverTime then
					-- eh...
				else
					this:Hide()
				end
			end

			this.UpdateCD = RealTime() + 0.5
		end
	end

	self.tooltip.Show = function(this, panel, title, description, color, time)
		if this.selected != panel then
			this.isHide = false
			this:AlphaTo(255, 0.3)

			time = "Найдено в " .. Arbitrage.FormatTime(time)

			local w1, _ = draw.SimpleText(title, MonoPad:GetFont("tooltip_text"), 0, 0, color_white, TEXT_ALIGN_LEFT)
			local w2, _ = draw.SimpleText(description, MonoPad:GetFont("tooltip_text"), 0, 0, color_white, TEXT_ALIGN_LEFT)
			local w3, _ = draw.SimpleText(time, MonoPad:GetFont("tooltip_text"), 0, 0, color_white, TEXT_ALIGN_LEFT)

			this:SetWide(math.max(w1 + 24, w2 + 24, w3 + 24))
			this.data = {title, description, color, time}
		end

		this.selected = panel
	end

	self.tooltip.Hide = function(this)
		if !this.isHide then
			this.selected = nil
			this.isHide = true
			this:AlphaTo(0, 0.3)
		end
	end

	self.tooltip.Paint = function(this, w, h)
		surface.SetDrawColor(0, 0, 0)
		surface.DrawRect(0, 0, w, h)

		local data = this.data
		if data then
			local font = MonoPad:GetFont("tooltip_text")

			draw.SimpleText(data[1], font, 12, 7, color_white, TEXT_ALIGN_LEFT)
			MonoPad:DrawTextBlur(data[2], font, 12, 35, data[3], TEXT_ALIGN_LEFT, ColorAlpha(data[3], data[3].a * 0.4))
			draw.SimpleText(data[4], font, 12, 53, Color(255, 255, 255, 50), TEXT_ALIGN_LEFT)
		end

		surface.SetDrawColor(255, 255, 255, 3)
		surface.DrawOutlinedRect(0, 0, w, h)
		surface.DrawRect(12, 30, w - 24, 1)
	end
end

local size_mat = 16
function PANEL:AddButton(uniqueID, name, image, func)
	local mat = Material(image)
	local button = self.taskbar:Add("DButton")
	button:SetText("")
	button:Dock(LEFT)
	button:SetWide(130)
	button:DockMargin(22, 0, 10, 0)
	button.alpha = 0.1
	button.Paint = function(_, w, h)
		local isSelect = false
		if !self.selectcategory and uniqueID == "home" or self.selectcategory == uniqueID then
			isSelect = true
		end

		_.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() or isSelect) and 1 or 0.1)

		surface.SetDrawColor(255, 255, 255, 255 * _.alpha)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(0, h / 2 - size_mat / 2, size_mat, size_mat)

		draw.SimpleText(name, MonoPad:GetFont("task"), size_mat + 7, h / 2 - 10, Color(255, 255, 255, 255 * _.alpha), TEXT_ALIGN_LEFT)
	end
	button.DoClick = function()
		if self.isLoading then return end

		if func then
			self.selectcategory = uniqueID

			if IsValid(self.selectPanel) then
				self.selectPanel:Remove()
			end

			func()
		end
	end

	local line = self.taskbar:Add("DPanel")
	line:Dock(LEFT)
	line:SetWide(1)
	line:DockMargin(0, 11, 10, 11)
	line.Paint = function(_, w, h)
		surface.SetDrawColor(255, 242, 245, 7.65)
		surface.DrawRect(0, 0, w, h)
	end

	return button
end

function PANEL:TaskBar()
	self.taskbar = self.menu:Add("DPanel")
	MonoPad:StartRegisterMeta(self.taskbar)

	self.taskbar:Dock(TOP)
	self.taskbar:SetTall(40)
	self.taskbar:SetZPos(30000)
	self.taskbar.Paint = function(_, w, h)
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(0, 0, w, h)

		draw.SimpleText(Arbitrage.GetChapter() .. ", " .. Arbitrage.GetTime(), MonoPad:GetFont("task"), w - 50, 10, color_white, TEXT_ALIGN_RIGHT)
	end

	self:AddButton("home", "", "danganronpa/monopad/icons/home.png", function()
		self:Rebuild()
	end):SetWide(30)
end

function PANEL:MainMenu()
	if IsValid(self.mainmenu) then
		self.mainmenu:Remove()
	end

	self.mainmenu = self.menu:Add("MonoPad:MainMenu")
	self.mainmenu:Dock(FILL)
	self.mainmenu:SetAlpha(0)
	self.mainmenu:AlphaTo(255, 1)
end

local material_bg = Material("danganronpa/monopad/bg.png")
local lerpX, lerpY = 0, 0

local padding = 0.07
local speed = 1
function PANEL:InitMenu()
	if IsValid(self.menu) then
		self.menu:Remove()
	end

	self.menu = self:Add("Panel")
	MonoPad:StartRegisterMeta(self.menu)
	self.menu:SetSize(self:GetWide(), self:GetTall())
	self.menu:SetAlpha(0)
	self.menu.Paint = function(_, w, h)
		local x, y = math.Clamp(self.cursorX, 0, w), math.Clamp(self.cursorY, 0, h)
	    local Wx, Wy = -((w / 2 - x) * padding), -((h / 2 - y) * padding)

	    local sizeX = w / 2 * padding
	    local sizeY = h / 2 * padding

	    local ft = FrameTime()

	    lerpX = Lerp(ft * speed, lerpX, Wx)
	    lerpY = Lerp(ft * speed, lerpY, Wy)

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(material_bg)
		surface.DrawTexturedRect(0 - lerpX - sizeX, 0 - lerpY - sizeY, w + sizeX * 2, h + sizeY * 2)
	end

	self.menu:AlphaTo(255, 0.5, 0, function()
		if IsValid(self.intro) then
			self.intro:Remove()
		end
	end)

	self.menu.DrawLoading = function(this, callback)
		if IsValid(self.loading) then return end

		self.loading = this:Add("MonoPad:Loading")
		self.loading:SetPos(0, 40)
		self.loading:SetZPos(30002)
		self.loading:SetSize(this:GetWide(), this:GetTall())
		self.loading:Start(callback)
	end
end

local backMat = Material("danganronpa/ui/back.png")
function PANEL:BackButton(parent, func)
	local button = parent:Add("DButton")
	button:SetText("")
	button:SetPos(20, 20)
	button:SetSize(24, 24)
	button.alpha = 0.1
	button.Paint = function(_, w, h)
		_.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 1 or 0.1)

		surface.SetDrawColor(0, 0, 0, 220)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(255, 255, 255, 10 * _.alpha)
		surface.DrawOutlinedRect(0, 0, w, h, 2)

		local size = h * 0.55

		surface.SetDrawColor(255, 255, 255, 255 * _.alpha)
		surface.SetMaterial(backMat)
		surface.DrawTexturedRect(w / 2 - size / 2, h / 2 - size / 2, size, size)
	end
	button.DoClick = function()
		if func then
			func()
		end
	end

	return button
end

function PANEL:Rebuild()
	self.selectcategory = nil

	self:InitMenu()
	self:TaskBar()
	self:MainMenu()
end

function PANEL:Menu()
	self:DrawScanLine()
	self:DrawCursor()
	MonoPad:StartRegisterMeta(self)

	self:Rebuild()
end

function PANEL:Paint(w, h)
	draw.RoundedBox(10, 0, 0, w, h, color_black)
end

vgui.Register("MonoPad:Menu", PANEL, "EditablePanel")