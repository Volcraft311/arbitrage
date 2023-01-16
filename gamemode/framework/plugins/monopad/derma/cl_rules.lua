local PANEL = {}

function PANEL:Init()
	self.isOpen = false
	MonoPad:StartRegisterMeta(self)

	local ui = MonoPad:GetUI()
	if !IsValid(ui) then return self:Remove() end

	self.closeButton = ui:BackButton(self, function()
		if self.isOpen then return end

		local historyID = ui:GetActiveHistoryID()
		if historyID then
			local monopad = MonoPad:GetObject()
			table.remove(monopad.history, historyID)
		end

		ui:Rebuild()
		LocalPlayer():EmitSound(MonoPad.sounds.planshet_beep)
	end)

	self.scrollPanel = self:Add("DScrollPanel")
	self.scrollPanel:SetPos(50, 18)
	self.scrollPanel:SetSize(840, 558)

	do
	    local bar = self.scrollPanel:GetVBar()
	    bar:SetWide(3)
	    bar:DockMargin(0, 0, 0, 0)

	    bar.Paint = function(_, w, h)
	        surface.SetDrawColor(255, 255, 255, 3)
	        surface.DrawRect(0, 0, w, h)
	    end
	    bar.btnUp.Paint = function(_, w, h) end
	    bar.btnDown.Paint = function(_, w, h) end
	    bar.btnGrip.Paint = function(_, w, h)
	        surface.SetDrawColor(255, 255, 255)
	        surface.DrawRect(0, 0, w, h)
	    end
	end

	self.listPanel = self.scrollPanel:Add("DIconLayout")
	self.listPanel.list = {}
	self.listPanel:Dock(FILL)
	self.listPanel:SetSpaceX(10)
	self.listPanel:SetSpaceY(10)
	MonoPad:StartRegisterMeta(self.listPanel)

	self:Rebuild()
end

function PANEL:Rebuild()
	for k, v in ipairs(self.listPanel.list) do
		if IsValid(v) then
			v:Remove()
		end
	end

	self.listPanel.list = {}

	for k, v in ipairs(Arbitrage.GetAcademyRules()) do
		self:AddRules(k, v[2], v[3], v[1])
	end
end

function PANEL:AddRules(id, title, description, url)
	local monopad = MonoPad:GetObject()
	local rulesList = monopad.rulesNotify

	local image = nil
	asterionlib.DownloadImage(url, function(mat)
		image = mat
	end)

	local font = MonoPad:GetFont("rules_title")
	local fontHeight = draw.GetFontHeight(font)
	fontHeight = fontHeight - 5 -- делаем отступ не таким большим

	local button = self.listPanel:Add("DPanel")
	button:SetSize(270, 160)
	button.alpha = 0.2
	button.size = 1
	local data = asterionlib.WrapText(title, button:GetWide() - 20, font)
	button.Paint = function(this, w, h)
		this.alpha = Lerp(FrameTime() * 8, this.alpha, this:IsHovered() and 1 or 0.4)
		this.size = Lerp(FrameTime() * 8, this.size, this:IsHovered() and 1.1 or 1)

		local _, y = self.scrollPanel:GetChildPosition(this)
		local padding = math.max(-y, 0)
		local tall = math.min(h - padding, self.scrollPanel:GetTall() - y)

	    asterionlib.DrawRender(function()
	        surface.SetDrawColor(255, 255, 255)
	        surface.DrawRect(0, padding, w, tall)
	    end, function()
	    	surface.SetDrawColor(0, 0, 0, 240)
		    surface.DrawRect(0, 0, w, h)

		    if image then
		    	local maxW = w * this.size
		        local maxH = h * this.size

		        local _w = image:Width()
		        local _h = image:Height()

		        local a = _h < _w and maxW / _w or maxH / _h
		        local a2 = _w * a
		        local b2 = _h * a

		    	surface.SetDrawColor(255, 255, 255)
		    	surface.SetMaterial(image)
		    	surface.DrawTexturedRect(w / 2 - a2 / 2, h / 2 - b2 / 2, a2, b2)
		    end

		    local alpha = 255 - 255 * this.alpha
		    surface.SetDrawColor(0, 0, 0, alpha)
	        surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(15, 15, 15)
		    surface.DrawOutlinedRect(0, 0, w, h, 2)

		    draw.SimpleText("№" .. id, MonoPad:GetFont("rules_id"), w - 9, 9, Color(255, 255, 255, 255 * this.alpha), TEXT_ALIGN_RIGHT)

		    local textPadding = 0
		    local textLifting = 0

		    for i = 1, #data do
		    	textLifting = textLifting + fontHeight
		    end

		    for k, v in ipairs(data) do
		    	draw.SimpleText(v, font, 16, 120 + textPadding - textLifting + fontHeight, Color(255, 255, 255, 255 * this.alpha), TEXT_ALIGN_LEFT)

		    	textPadding = textPadding + fontHeight
		    end

		    if rulesList[id] then
			    surface.SetDrawColor(14, 9, 3, 170)
			    surface.DrawRect(8, 8, 127, 23)

			    MonoPad:DrawTextBlur("Новое изменение", MonoPad:GetFont("rules_notify"), 14, 9, Color(255, 176, 56), TEXT_ALIGN_LEFT, Color(255, 176, 56, 150))
			end
	    end)
	end
	button.DoClick = function(_, w, h)
		if self.isOpen then return end

		local ui = MonoPad:GetUI()
		ui:EditHistory(ui:GetActiveHistoryID(), {
			"rules",
			"Правило №" .. id,
			MonoPad.icons.rules,
			{id}
		})

		self.scrollPanel:AlphaTo(0, 0.5)
		self.closeButton:AlphaTo(0, 0.5, 0, function()
			local subMenu = self:Add("MonoPad:RulesSub")
			subMenu:SetPos(0, 0)
			subMenu:SetSize(self:GetSize())
			subMenu:SetData(id)
		end)

		LocalPlayer():EmitSound(MonoPad.sounds.planshet_beep)

		self.isOpen = true
	end

	self.listPanel.list[#self.listPanel.list + 1] = button
end

vgui.Register("MonoPad:Rules", PANEL, "Panel")


local arrowUpMat = Material("danganronpa/monopad/arrow_up.png")
local arrowDownMat = Material("danganronpa/monopad/arrow_down.png")
local PANEL = {}

function PANEL:Init()
	MonoPad:StartRegisterMeta(self)

	local ui = MonoPad:GetUI()
	if !IsValid(ui) then return self:Remove() end

	ui:BackButton(self, function()
		local parent = self:GetParent()

		self:AlphaTo(0, 0.3, 0, function()
			parent.isOpen = false
			parent.scrollPanel:AlphaTo(255, 0.3)
			parent.closeButton:AlphaTo(255, 0.3)

			self:Remove()
		end)

		ui:EditHistory(ui:GetActiveHistoryID(), {
			"rules",
			"Устав Академии",
			MonoPad.icons.rules,
			{}
		})

		LocalPlayer():EmitSound(MonoPad.sounds.planshet_beep)
	end)

	self:SetAlpha(0)

	self.image = nil
	self.description = nil


	local imagePanel = self:Add("Panel")
	imagePanel:SetPos(205, 68)
	imagePanel:SetSize(520, 300)
	imagePanel.Paint = function(_, w, h)
		if self.image then
			asterionlib.DrawRender(function()
				surface.SetDrawColor(255, 255, 255)
				surface.DrawRect(0, 0, w, h)
			end, function()
				local maxW = w * 1
		        local maxH = h * 1

		        local _w = self.image:Width()
		        local _h = self.image:Height()

		        local a = _h < _w and maxW / _w or maxH / _h
		        local a2 = _w * a
		        local b2 = _h * a

		        surface.SetDrawColor(255, 255, 255)
		    	surface.SetMaterial(self.image)
		    	surface.DrawTexturedRect(w / 2 - a2 / 2, h / 2 - b2 / 2, a2, b2)
			end)
		end
	end

	if #Arbitrage.GetAcademyRules() > 1 then
		local upButton = self:Add("DButton")
		upButton:SetText("")
		upButton:SetPos(886, 230)
		upButton:SetSize(24, 24)
		upButton.alpha = 0.1
		upButton.Paint = function(_, w, h)
			_.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 1 or 0.1)

			surface.SetDrawColor(0, 0, 0, 220)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(255, 255, 255, 10 * _.alpha)
			surface.DrawOutlinedRect(0, 0, w, h, 2)

			surface.SetDrawColor(255, 255, 255, 255 * _.alpha)
			surface.SetMaterial(arrowUpMat)
			surface.DrawTexturedRect(0, 0, h, h)
		end
		upButton.DoClick = function()
			local rulesList = Arbitrage.GetAcademyRules()
			local id = self.id - 1

			if id <= 0 then
				id = #rulesList
			end

			self:SetPage(id)
			ui:EditHistory(ui:GetActiveHistoryID(), {
				"rules",
				"Правило №" .. id,
				MonoPad.icons.rules,
				{id}
			})

			LocalPlayer():EmitSound(MonoPad.sounds.planshet_beep)
		end

		local downButton = self:Add("DButton")
		downButton:SetText("")
		downButton:SetPos(886, 280)
		downButton:SetSize(24, 24)
		downButton.alpha = 0.1
		downButton.Paint = function(_, w, h)
			_.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 1 or 0.1)

			surface.SetDrawColor(0, 0, 0, 220)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(255, 255, 255, 10 * _.alpha)
			surface.DrawOutlinedRect(0, 0, w, h, 2)

			surface.SetDrawColor(255, 255, 255, 255 * _.alpha)
			surface.SetMaterial(arrowDownMat)
			surface.DrawTexturedRect(0, 0, h, h)
		end
		downButton.DoClick = function()
			local rulesList = Arbitrage.GetAcademyRules()
			local id = self.id + 1

			if id > #rulesList then
				id = 1
			end

			self:SetPage(id)

			ui:EditHistory(ui:GetActiveHistoryID(), {
				"rules",
				"Правило №" .. id,
				MonoPad.icons.rules,
				{id}
			})

			LocalPlayer():EmitSound(MonoPad.sounds.planshet_beep)
		end
	end
end

function PANEL:SetPage(id)
	self:SetAlpha(0)
	self:AlphaTo(255, 0.2)

	self.id = id

	local rulesList = Arbitrage.GetAcademyRules()
	local rules = rulesList[id]

	local url = rules[1]
	local description = "Правило №" .. self.id .. "." .. rules[3]

	local image = nil
	asterionlib.DownloadImage(url, function(mat)
		image = mat
	end)

	self.image = image
	self.data = asterionlib.WrapText(description, 520, self.font)

	local monopad = MonoPad:GetObject()
	monopad.rulesNotify[id] = nil
end

function PANEL:SetData(id)
	self.font = MonoPad:GetFont("rules_description")
	self.fontHeight = draw.GetFontHeight(self.font)

	self:SetPage(id)
end

function PANEL:Paint()
	surface.SetDrawColor(255, 255, 255, 10)
	surface.DrawRect(205, 395, 520, 1)

	local y = 0
	for k, v in ipairs(self.data or {}) do
		draw.SimpleText(v, self.font, 205 + 520 / 2, 420 + y, color_white, TEXT_ALIGN_CENTER)

		y = y + self.fontHeight
	end

	if self.id then
		draw.SimpleText("№" .. self.id, MonoPad:GetFont("rules_id_draw"), 899, 257, color_white, TEXT_ALIGN_CENTER)
	end
end

vgui.Register("MonoPad:RulesSub", PANEL, "Panel")