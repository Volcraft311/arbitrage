local PANEL = {}

function PANEL:Init()
	MonoPad:StartRegisterMeta(self)

	local ui = MonoPad:GetUI()
	if !IsValid(ui) then return self:Remove() end

	self.notify = {}

	self.closeButton = ui:BackButton(self, function()
		if self.isOpen then return end

		ui:Rebuild()
		LocalPlayer():EmitSound(MonoPad.sounds.planshet_beep)
	end)

	self.scrollPanel = self:Add("DScrollPanel")
	self.scrollPanel:SetPos(50, 18)
	self.scrollPanel:SetSize(230, 518)
	self.scrollPanel.Paint = function(_, w, h)
		surface.SetDrawColor(0, 0, 0, 230)
		surface.DrawRect(0, 0, w, h)
	end

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
	MonoPad:StartRegisterMeta(self.scrollPanel)

	self.rightPanel = self:Add("Panel")
	self.rightPanel:SetPos(290, 18)
	self.rightPanel:SetSize(590, 518)
	MonoPad:StartRegisterMeta(self.rightPanel)

	self.messagerPanel = self.rightPanel:Add("DPanel")
	self.messagerPanel:Dock(FILL)
	self.messagerPanel.Paint = function(_, w, h)
		surface.SetDrawColor(0, 0, 0, 230)
		surface.DrawRect(0, 0, w, h)
	end
	MonoPad:StartRegisterMeta(self.messagerPanel)

	self.title = self.messagerPanel:Add("DPanel")
	self.title:SetAlpha(0)
	self.title.data = nil
	self.title:Dock(TOP)
	self.title:SetTall(60)
	self.title.Paint = function(_, w, h)
		surface.SetDrawColor(255, 255, 255, 10)
		surface.DrawRect(16, h - 1, w - 32, 1)

		if _.text then
			local size = 42
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(_.icon)
			surface.DrawTexturedRect(16, h / 2 - size / 2, size, size)

			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(_.icon2)
			surface.DrawTexturedRect(16 + size, h / 2 - size / 2, size, size)

			draw.SimpleText(_.text, MonoPad:GetFont("notes_title2"), w / 2, 11, color_white, TEXT_ALIGN_CENTER)
		end
	end

	self.messagesScroll = self.messagerPanel:Add("DScrollPanel")
	self.messagesScroll:Dock(FILL)
	self.messagesScroll.ScrollBottom = function(this)
		local bar = this:GetVBar()
		bar:SetScroll(9999999)
	end

	self.messagesScroll.VBar.OSetScroll = self.messagesScroll.VBar.SetScroll
	self.messagesScroll.VBar.SetScroll = function(this, scroll)
		if IsValid(self.attachmentPanel) and self.attachmentPanel:IsHovered() then return end

		this:OSetScroll(scroll)
	end

	do
	    local bar = self.messagesScroll:GetVBar()
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

	self:Rebuild()

	hook.Add("SyncMonoPad", "MonoPad:SyncMonoPad", function()
		if !IsValid(self) then return hook.Remove("SyncMonoPad", "MonoPad:SyncMonoPad") end

		if !self.noRebuild then
			self:InitMessages(self.selectID)
		else
			self.noRebuild = nil
		end

		if !self.isSent then
			LocalPlayer():EmitSound(MonoPad.sounds.message_came)
			self.isSent = nil
		end
	end)
end

function PANEL:CreateAttachments()
	self.attachmentPanel = self.messagerPanel:Add("DPanel")
	self.attachmentPanel:SetPos(0, 346)
	self.attachmentPanel:SetSize(590, 130)
	self.attachmentPanel.Paint = function(_, w, h)
		surface.SetDrawColor(0, 0, 0, 250)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(255, 255, 255, 10)
		surface.DrawRect(16, h - 1, w - 32, 1)
	end
	MonoPad:StartRegisterMeta(self.attachmentPanel)

	self.attachmentPanel:SetAlpha(0)
	self.attachmentPanel:AlphaTo(255, 0.3)

	local Scroll = self.attachmentPanel:Add("DScrollPanel")
	Scroll:Dock(FILL)
	Scroll:DockMargin(16, 12, 16, 12)

	do
	    local bar = Scroll:GetVBar()
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

	local List = Scroll:Add("DIconLayout")
	List:Dock(FILL)
	List:SetSpaceX(10)
	List:SetSpaceY(10)
	MonoPad:StartRegisterMeta(List)

	for id in pairs(LocalPlayer():GetEvidences()) do
		local data = Evidence:GetEvidence(id)
		if !data then return end

		local dEvidence = Evidence.icons
		local evidenceMat = Material(dEvidence[data.image])

		local dRibbon = Evidence.ribbons
		local ribbonMat = Material(dRibbon[data.ribbon][1])
		local time = LocalPlayer():HasEvidence(id)

		local button = List:Add("DButton")
		button:SetText("")
		button:SetSize(65, 65)
		button.black = 0.6
		button.Paint = function(this, w, h)
			this.black = Lerp(FrameTime() * 10, this.black, this:IsHovered() and 0 or 0.6)

			local _, y = Scroll:GetChildPosition(this)
			local padding = math.max(-y, 0)
			local tall = math.min(h - padding, Scroll:GetTall() - y)

			asterionlib.DrawRender(function()
		        surface.SetDrawColor(255, 255, 255)
		        surface.DrawRect(0, padding, w, tall)
		    end, function()
			    surface.SetDrawColor(0, 0, 0)
				surface.DrawRect(0, 0, w, h)

				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(evidenceMat)
				surface.DrawTexturedRect(0, 0, h, h)

			    surface.SetDrawColor(255, 255, 255)
			    surface.SetMaterial(ribbonMat)
			    surface.DrawTexturedRect(0, 0, h, h)

			    surface.SetDrawColor(0, 0, 0, 255 * this.black)
			    surface.DrawRect(0, 0, w, h)

				surface.SetDrawColor(255, 255, 255, 3)
				surface.DrawOutlinedRect(0, 0, w, h)
		    end)
		end

		button.DoClick = function(this)
			if self.isOpen then return end

			local _, y = Scroll:GetChildPosition(this)
			if y < -this:GetTall() or y > Scroll:GetTall() then return end
			if IsValid(self.inputPanel) and self.inputPanel:IsHovered() then return end

			self.attachmentPanel:AlphaTo(0, 0.2, 0, function()
				self.attachmentPanel:Remove()
			end)

			local monopad = MonoPad:GetObject()

			self.isSent = true
			netstream.Start("MonoPad:SendEvidence", self.selectID, id)
			LocalPlayer():EmitSound(MonoPad.sounds.message_sent)
		end

		local ui = MonoPad:GetUI()
		ui:AddTooltip(button, data.name, dRibbon[data.ribbon][2], dRibbon[data.ribbon][3], time, function()
			return !self.isOpen
		end)
	end
end

function PANEL:InitInput()
	if IsValid(self.inputPanel) then self.inputPanel:Remove() end

	self.inputPanel = self.rightPanel:Add("DPanel")
	self.inputPanel:Dock(BOTTOM)
	self.inputPanel:DockMargin(0, 10, 0, 0)
	self.inputPanel:SetTall(42)
	self.inputPanel.Paint = function(_, w, h)
		surface.SetDrawColor(0, 0, 0, 230)
		surface.DrawRect(0, 0, w, h)
	end

	local monopad = MonoPad:GetObject()
	local isDead = false
	for k, v in ipairs(Arbitrage.GetGameLogs()) do
		if v[1] == self.selectID or v[4] == self.selectID or v[1] == monopad.team or v[4] == monopad.team then
			isDead = true
			break
		end
	end

	if isDead then
		self.inputPanel:DockMargin(0, 0, 0, 0)
		self.inputPanel.Paint = function(_, w, h)
			surface.SetDrawColor(0, 0, 0, 230)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(255, 255, 255, 10)
			surface.DrawRect(16, 0, w - 32, 1)

			draw.SimpleText("Данный пользователь недоступен", MonoPad:GetFont("notes_title"), w / 2, 10, Color(255, 255, 255, 10), TEXT_ALIGN_CENTER)
		end

		return
	end

	MonoPad:StartRegisterMeta(self.inputPanel)

	local attachmentButton = self.inputPanel:Add("DButton")
	attachmentButton:SetText("")
	attachmentButton:SetWide(55)
	attachmentButton:Dock(LEFT)
	attachmentButton.alpha = 0.05
	attachmentButton.Paint = function(_, w, h)
		_.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() or IsValid(self.attachmentPanel)) and 1 or 0.05)

		local size = 19
		surface.SetDrawColor(255, 255, 255, 255 * _.alpha)
		surface.SetMaterial(Material("danganronpa/monopad/attachment.png"))
		surface.DrawTexturedRect(w / 2 - size / 2,  h / 2 - size / 2, size, size)

		surface.SetDrawColor(255, 255, 255, 10)
		surface.DrawRect(w - 1, 11, 1, h - 22)
	end
	attachmentButton.DoClick = function()
		if self.isOpen then return end
		if !self.selectID then return end

		if IsValid(self.attachmentPanel) then
			self.attachmentPanel:AlphaTo(0, 0.3, 0, function()
				self.attachmentPanel:Remove()
			end)

			return
		end

		self:CreateAttachments()
	end

	local inputButton = self.inputPanel:Add("DButton")
	inputButton:SetText("")
	inputButton:Dock(FILL)
	inputButton.alpha = 0.05
	inputButton.Paint = function(_, w, h)
		_.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 1 or 0.05)

		draw.SimpleText("Напишите сообщение...", MonoPad:GetFont("notes_title"), 15, 9, Color(255, 255, 255, 255 * _.alpha), TEXT_ALIGN_LEFT)
	end
	inputButton.DoClick = function()
		if self.isOpen then return end
		if !self.selectID then return end

		Derma_StringRequest("Отправить сообщение", "Введите текст который вы хотите отправить", "", function(text)
			if text == "" or text == " " or text == "  " then return end

			self.isSent = true
			netstream.Start("MonoPad:SendMessage", self.selectID, text)
			LocalPlayer():EmitSound(MonoPad.sounds.message_sent)
		end, nil, "Отправить", "Отменить")
	end
end

function PANEL:InitMessages(id)
	self:InitInput(id)
	self:ReadingMessages(id)

	local monopad = MonoPad:GetObject()

	netstream.Request("MonoPad:GetMessage", id, function(data)
		self.messagesScroll:Clear()

		local initTime = RealTime()
		local function allowScroll()
			return (RealTime() - initTime) < 1
		end

		local oldUser = nil
		local oldTime = nil

		self.messagesScroll:SetAlpha(0)

		for k, v in ipairs(data) do
			oldUser = oldUser or v.faction
			oldTime = oldTime or v.time

			local faction = Character.team:GetByID(v.faction)

			local docker = self.messagesScroll:Add("Panel")
			docker:SetAlpha(0)
			docker.oldUser = oldUser
			docker.oldTime = oldTime
			docker:Dock(TOP)
			docker:DockMargin(0, v.faction == oldUser and 2 or 10, 0, 0)
			MonoPad:StartRegisterMeta(docker)

			local font = MonoPad:GetFont("messenger_text")
			local fontHeight = draw.GetFontHeight(font)

			local titleText = faction:GetName() .. ", " .. Arbitrage.FormatTime(v.time)
			local textData = {}

			local panel = docker:Add("DButton")
			panel:SetText("")
			panel:Dock(monopad.team == v.faction and RIGHT or LEFT)
			panel.alpha = 1
			panel.Paint = function(this, w, h)
				local _, y = self.messagesScroll:GetChildPosition(this)
				local padding = math.max(-y, 0)
				local tall = math.min(h - padding, self.messagesScroll:GetTall() - y)

				local size = 10

				asterionlib.DrawRender(function()
			        surface.SetDrawColor(255, 255, 255)
			        surface.DrawRect(0, padding, w, tall)
			    end, function()
				    surface.SetDrawColor(0, 0, 0)
					surface.DrawRect(0, 0, w, h)

					if v.time - docker.oldTime >= 600 or k == 1 or docker.oldUser != v.faction then
						local _, titleH = draw.SimpleText(titleText, MonoPad:GetFont("messenger_author"), 15, 10, color_white, TEXT_ALIGN_LEFT)
						size = size + titleH
						size = size + 2
					end

					if v.type == 1 then -- обычные сообщения
						for k2, v2 in ipairs(textData) do
							draw.SimpleText(v2, font, 15, size, color_white, TEXT_ALIGN_LEFT)

							size = size + fontHeight
						end
					else
						this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 1 or 0.2)

						if v.type == 2 then -- улики
							surface.SetDrawColor(255, 255, 255, 255 * this.alpha)
							surface.SetMaterial(Material("danganronpa/monopad/icons/file_blur.png"))
							surface.DrawTexturedRect(15, size - 5, 30, 30)

							MonoPad:DrawTextBlur("Улика №" .. v.data, font, 15 + 24 + 6, size, Color(255, 16, 59, 255 * this.alpha), TEXT_ALIGN_LEFT, Color(255, 16, 59, 190))
						end

						size = size + fontHeight
					end

					size = size + 10
			    end)

				if docker:GetTall() != size then
					docker:SetTall(size)

					if allowScroll() then
						timer.Simple(0.2, function()
							self.messagesScroll:ScrollBottom()
							self.messagesScroll:AlphaTo(255, 0.3)
						end)
					end
				end
			end
			if v.type != 1 then
				panel.DoClick = function(this)
					if self.isOpen then return end

					local _, y = self.messagesScroll:GetChildPosition(this)
					if y < -this:GetTall() or y > self.messagesScroll:GetTall() then return end

					if IsValid(self.attachmentPanel) and self.attachmentPanel:IsHovered() then return end
					if !Evidence:GetEvidence(v.data) then return end

					self.isSent = true
					self.noRebuild = true
					netstream.Start("MonoPad:ReadMessageEvidence", self.selectID, k)

					self.isOpen = true
					self.scrollPanel:AlphaTo(0, 0.3)
					self.messagerPanel:AlphaTo(0, 0.3)
					self.inputPanel:AlphaTo(0, 0.3)
					self.closeButton:AlphaTo(0, 0.3, 0, function()
						local evidence = self:Add("MonoPad:EvidenceSub")
						evidence:Dock(FILL)
						evidence:SetData(v.data, function()
							self.isOpen = false
							self.scrollPanel:AlphaTo(255, 0.3)
							self.messagerPanel:AlphaTo(255, 0.3)
							self.inputPanel:AlphaTo(255, 0.3)
							self.closeButton:AlphaTo(255, 0.3)
						end)
					end)

					LocalPlayer():EmitSound(MonoPad.sounds.planshet_beep)
				end
			end

			docker.PerformLayout = function(_, w, h)
			    if !docker.c then
			    	panel:SetWide(w / 2)
			    	docker:AlphaTo(255, 1)
			    	textData = isstring(v.data) and asterionlib.WrapText(v.data, panel:GetWide() - 30, font)

			        docker.c = true
			    end
			end

			oldUser = v.faction
			oldTime = v.time
		end

		timer.Simple(0.1, function()
			if allowScroll() then
				self.messagesScroll:ScrollBottom()
			end
		end)
	end)
end

function PANEL:Rebuild()
	self.scrollPanel:Clear()

	self.notify = {}

	netstream.Request("MonoPad:GetMessages", nil, function(data)
		local stored = {}

		for id, notify in pairs(data or {}) do
			local faction = Character.team:GetByID(id)
			if !faction then continue end

			stored[id] = faction
			self.notify[id] = notify
		end

		for id, info in SortedPairsByMemberValue(stored, "name") do
			self:AddPlayerButton(info)
		end
	end)
end

function PANEL:ReadingMessages(id)
	if !id then return end

	netstream.Start("MonoPad:ReadMessages", id)
	self.notify[id] = 0
end

local crossMat = Material("danganronpa/monopad/cross.png")
function PANEL:AddPlayerButton(faction)
	local monopad = MonoPad:GetObject()
	local localFaction = Character.team:GetByID(monopad.team)
	if !localFaction then return end

	local localAssets = localFaction:GetAssets()
	local localPixel = localAssets.pixel
	if !localPixel then return end

	local name = faction:GetName()
	local id = faction:GetID()
	local assets = faction:GetAssets()

	local pixel = assets.pixel
	if !pixel then return end

	local pixelMat = Material(pixel)
	local localPixelMat = Material(localPixel)

	local isDead = false
	for k, v in ipairs(Arbitrage.GetGameLogs()) do
		if v[1] == id or v[4] == id then
			isDead = true
			break
		end
	end

	local button = self.scrollPanel:Add("DButton")
	button:SetText("")
	button:Dock(TOP)
	button:SetTall(45)
	button.alpha = 0.1
	button.alpha2 = 0
	button.Paint = function(this, w, h)
		local count = self.notify[id] or 0

		local selected = self.selectID == id
		this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 1 or 0.1)
		this.alpha2 = Lerp(FrameTime() * 10, this.alpha2, selected and 1 or -0.1)

		local _, y = self.scrollPanel:GetChildPosition(this)
		local padding = math.max(-y, 0)
		local tall = math.min(h - padding, self.scrollPanel:GetTall() - y)

		asterionlib.DrawRender(function()
	        surface.SetDrawColor(255, 255, 255)
	        surface.DrawRect(0, padding, w, tall)
	    end, function()
		    surface.SetDrawColor(255, 255, 255, 10)
			surface.DrawRect(14, h - 1, w - 28, 1)

			local size = h * 0.8
			surface.SetDrawColor(255, 255, 255, 255 * math.max(this.alpha2, this.alpha))
			surface.SetMaterial(pixelMat)
			surface.DrawTexturedRect(15, h / 2 - size / 2, size, size)

			if isDead then
				local size2 = h * 0.4

				surface.SetDrawColor(255, 255, 255, 700 * math.max(this.alpha2, this.alpha))
				surface.SetMaterial(crossMat)
				surface.DrawTexturedRect(24, h / 2 - size2 / 2, size2, size2)
			end

			local c = isDead and Color(238, 32, 32, 255 * this.alpha2) or Color(255, 238, 177, 255 * this.alpha2)
			MonoPad:DrawTextBlur(name, MonoPad:GetFont("messenger_title"), size + 15, 11, c, TEXT_ALIGN_LEFT, isDead and ColorAlpha(c, c.a * 0.5) or nil)

			if count > 0 then
				MonoPad:DrawTextBlur(count, MonoPad:GetFont("messenger_title"), w - 15, 11, Color(255, 238, 177, 255 * math.max(this.alpha2, this.alpha)), TEXT_ALIGN_RIGHT)
			end

			if !selected then
				draw.SimpleText(name, MonoPad:GetFont("messenger_title"), size + 15, 11, isDead and Color(238, 32, 32, 255 * this.alpha) or Color(255, 255, 255, 255 * this.alpha), TEXT_ALIGN_LEFT)
			end
	    end)
	end
	button.DoClick = function(this)
		if self.isOpen then return end

		local _, y = self.scrollPanel:GetChildPosition(this)
		if y < -this:GetTall() or y > self.scrollPanel:GetTall() then return end

		self.selectID = id

		self.title:SetAlpha(0)
		self.title:AlphaTo(255, 0.2)
		self.title.icon = pixelMat
		self.title.icon2 = localPixelMat
		self.title.text = "Диалог с " .. faction:GetName()

		self:InitMessages(self.selectID)
		LocalPlayer():EmitSound(MonoPad.sounds.planshet_beep)
	end
end

function PANEL:OnRemove()
	hook.Remove("SyncMonoPad", "MonoPad:SyncMonoPad")
end

vgui.Register("MonoPad:Messenger", PANEL, "Panel")


local PANEL = {}

function PANEL:Init()
	MonoPad:StartRegisterMeta(self)

	local ui = MonoPad:GetUI()
	if !IsValid(ui) then return self:Remove() end

	ui:BackButton(self, function()
		self:AlphaTo(0, 0.3, 0, function()
			if self.onClose then
				self.onClose()
			end

			self:Remove()
		end)

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
end

function PANEL:SetEvidence(id)
	self:SetAlpha(0)
	self:AlphaTo(255, 0.2)

	self.id = id

	local evidence = Evidence:GetEvidence(id)
	self.time = "Найдено в " .. Arbitrage.FormatTime(LocalPlayer():HasEvidence(id))

	local description = "Улика №" .. id .. ". " .. evidence.description

	self.title = evidence.name
	self.data = asterionlib.WrapText(description, 520, self.font)

	local dEvidence = Evidence.icons
	local evidenceMat = Material(dEvidence[evidence.image])

	local dRibbon = Evidence.ribbons

	self.typeText = dRibbon[evidence.ribbon][2]
	self.typeColor = dRibbon[evidence.ribbon][3]
	self.image = evidenceMat
end

function PANEL:SetData(id, onClose)
	self.onClose = onClose

	self.font = MonoPad:GetFont("rules_description")
	self.fontHeight = draw.GetFontHeight(self.font)

	self:SetEvidence(id)
end

function PANEL:Paint()
	surface.SetDrawColor(255, 255, 255, 10)
	surface.DrawRect(205, 395, 520, 1)

	local y = 0
	if self.title then
		local font = MonoPad:GetFont("rules_title")

		local w1, _ = draw.SimpleText(self.title, font, 0, 0, Color(0, 0, 0, 0), TEXT_ALIGN_LEFT)
		local w2, _ = draw.SimpleText(self.typeText, MonoPad:GetFont("rules_description"), 0, 0, Color(0, 0, 0, 0), TEXT_ALIGN_LEFT)
		local size = w1 + w2 + 30

		local _w, _h = draw.SimpleText(self.title, MonoPad:GetFont("rules_title"), 205 + 520 / 2 - size / 2, 420, color_white, TEXT_ALIGN_LEFT)
		surface.SetDrawColor(255, 255, 255, 5)
		surface.DrawRect(205 + 520 / 2 - size / 2 + _w + 15, 420, 1, _h)

		MonoPad:DrawTextBlur(self.typeText, MonoPad:GetFont("rules_description"), 205 + 520 / 2 + _w + 30 - size / 2, 420 + 6, self.typeColor, TEXT_ALIGN_LEFT, ColorAlpha(self.typeColor, self.typeColor.a * 0.4))

		y = _h * 1.5
	end

	for k, v in ipairs(self.data or {}) do
		draw.SimpleText(v, self.font, 205 + 520 / 2, 420 + y, color_white, TEXT_ALIGN_CENTER)

		y = y + self.fontHeight
	end

	draw.SimpleText(self.time, self.font, 205 + 520 / 2, 420 + y + 15, Color(255, 255, 255, 30), TEXT_ALIGN_CENTER)
end

vgui.Register("MonoPad:EvidenceSub", PANEL, "Panel")