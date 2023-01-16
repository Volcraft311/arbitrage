local PANEL = {}

function PANEL:Init()
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

	self.evidencePanel = self:CreateButton("Найденные улики", "Все найденные вами улики заносятся в данную\nкатегорию. Распределяйте их по активным делам\nдля правильного выявления виновного", Material("danganronpa/monopad/evidence.png"))
	self.evidencePanel:SetPos(80, 70)
	self.evidencePanel.DoClick = function()
		if self.isOpen then return end

		self.evidencePanel:AlphaTo(0, 0.3, 0, function()
			local evidence = self:Add("MonoPad:Evidence")
			evidence:Dock(FILL)
		end)

		self.closeButton:AlphaTo(0, 0.3)
		self.secretsPanel:AlphaTo(0, 0.3)
		self.isOpen = true

		ui:EditHistory(ui:GetActiveHistoryID(), {
			"special",
			"Список улик",
			MonoPad.icons.special,
			{1}
		})

		LocalPlayer():EmitSound(MonoPad.sounds.planshet_beep)
	end

	self.secretsPanel = self:CreateButton("Тайны Академии", "Особые материалы и файлы, помогающие\nраскрывать общую тайну. Используйте их для\nполного успешного прохождения Академии.", Material("danganronpa/monopad/secrets.png"))
	self.secretsPanel:SetPos(470, 70)
	self.secretsPanel.disable = true
	self.secretsPanel:SetAlpha(30)

	local monopad = MonoPad:GetObject()
	monopad.specialNotify = nil
end

function PANEL:CreateButton(title, description, mat)
	local panel = self:Add("DButton")
	panel:SetSize(380, 416)
	panel:SetText("")
	panel.black = 0
	panel.Paint = function(_, w, h)
		if !_.disable then
			_.black = Lerp(FrameTime() * 10, _.black, _:IsHovered() and 0 or 0.8)
		end

		surface.SetDrawColor(0, 0, 0, 240)
	    surface.DrawRect(0, 0, w, h)

	    surface.SetDrawColor(255, 255, 255, 255)
	    surface.SetMaterial(mat)
	    surface.DrawTexturedRect(20, 0, 340, 280)

	    draw.SimpleText(title, MonoPad:GetFont("special_title"), w / 2, 292, color_white, TEXT_ALIGN_CENTER)
	    draw.DrawText(description, MonoPad:GetFont("special_description"), w / 2, 330, color_white, TEXT_ALIGN_CENTER)

	    surface.SetDrawColor(0, 0, 0, 255 * _.black)
	    surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(255, 255, 255, 3)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	return panel
end

vgui.Register("MonoPad:Special", PANEL, "Panel")

local PANEL = {}

function PANEL:Init()
	MonoPad:StartRegisterMeta(self)

	local ui = MonoPad:GetUI()
	if !IsValid(ui) then return self:Remove() end

	self.closeButton = ui:BackButton(self, function()
		if self.isOpen then return end

		self:AlphaTo(0, 0.3, 0, function()
			local parent = self:GetParent()

			parent.closeButton:AlphaTo(255, 0.3)
			parent.evidencePanel:AlphaTo(255, 0.3)
			parent.secretsPanel:AlphaTo(30, 0.3)
			parent.isOpen = nil

			ui:EditHistory(ui:GetActiveHistoryID(), {
				"special",
				"Спец. материалы",
				MonoPad.icons.special,
				{}
			})

			self:Remove()
		end)

		LocalPlayer():EmitSound(MonoPad.sounds.planshet_beep)
	end)

	self:SetAlpha(0)
	self:AlphaTo(255, 0.3)

	self.leftPanel = self:Add("DPanel")
	self.leftPanel:SetPos(50, 18)
	self.leftPanel:SetSize(390, 518)
	self.leftPanel.Paint = function(_, w, h)
		surface.SetDrawColor(0, 0, 0, 230)
		surface.DrawRect(0, 0, w, h)
	end
	MonoPad:StartRegisterMeta(self.leftPanel)

	local leftTitle = self.leftPanel:Add("DLabel")
	leftTitle:Dock(TOP)
	leftTitle:DockMargin(20, 14, 20, 18)
	leftTitle:SetText("Найденные материалы")
	leftTitle:SetFont(MonoPad:GetFont("special_title"))

	self.scrollPanel = self.leftPanel:Add("DScrollPanel")
	self.scrollPanel:Dock(FILL)
	self.scrollPanel:DockMargin(20, 0, 0, 0)

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

	self:Rebuild()
end

function PANEL:Rebuild()
	if IsValid(self.rightPanel) then
		self.rightPanel:Remove()
	end

	if IsValid(self.List) then
		self.List:Remove()
	end

	self.scrollPanel:Clear()

	self.List = self.scrollPanel:Add("DIconLayout")
	self.List:Dock(FILL)
	self.List:SetSpaceX(10)
	self.List:SetSpaceY(10)
	MonoPad:StartRegisterMeta(self.List)

	local client = LocalPlayer()
	local evidences = client:GetEvidences()

	for id in pairs(evidences) do
		self:AddEvidence(id, self.List, self.scrollPanel)
	end

	self.rightPanel = self:Add("DScrollPanel")
	self.rightPanel:SetPos(450, 18)
	self.rightPanel:SetSize(410, 518)

	do
	    local bar = self.rightPanel:GetVBar()
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

	for k, v in ipairs(Arbitrage.GetGameLogs()) do
		if v[3] == 1 then continue end

		local inflictorID = v[1]

		local monopad = MonoPad:GetObject()
		local caseStored = monopad.caseStored[k] or {}
		local m_inflictor = caseStored[1] or nil

		if !inflictorID then
			inflictorID = m_inflictor
		end

		local inflictorFaction = Character.team:GetByID(inflictorID)

		local panel = self.rightPanel:Add("Panel")
		panel:Dock(TOP)
		panel:DockMargin(0, 0, 10, 10)
		panel:SetTall(56)
		panel.alpha = 0
		panel.Paint = function(this, w, h)
			local selected = self.selectID == k
			this.alpha = Lerp(FrameTime() * 10, this.alpha, selected and 1 or -0.1)

	    	local _, y = self.rightPanel:GetChildPosition(this)
			local padding = math.max(-y, 0)
			local tall = math.min(h - padding, self.rightPanel:GetTall() - y)

			asterionlib.DrawRender(function()
		        surface.SetDrawColor(255, 255, 255)
		        surface.DrawRect(0, padding, w, tall)
		    end, function()
			    surface.SetDrawColor(0, 0, 0, 230)
				surface.DrawRect(0, 0, w, h)

				surface.SetDrawColor(255, 255, 255, 3)
		    	surface.DrawOutlinedRect(0, 0, w, h)
		    end)

		    Arbitrage.DrawOutlinedRectBlur(0, 0, w, h, Color(255, 238, 177, 255 * this.alpha), 2, 4)
		end

		local title = panel:Add("Panel")
		title:Dock(TOP)
		title:DockMargin(0, 0, 0, 5)
		title:SetTall(60)
		title.Paint = function(this, w, h)
			local _, y = self.rightPanel:GetChildPosition(this)
			local padding = math.max(-y, 0)
			local tall = math.min(h - padding, self.rightPanel:GetTall() - y)

			asterionlib.DrawRender(function()
		        surface.SetDrawColor(255, 255, 255)
		        surface.DrawRect(0, padding, w, tall)
		    end, function()
		    	local name = inflictorFaction and inflictorFaction:GetName() or "Неизвестно"
			    draw.SimpleText("Дело №" .. k .. ", " .. name, MonoPad:GetFont("gamelog_title"), 20, 14, color_white, TEXT_ALIGN_LEFT)
		    end)
		end
		MonoPad:StartRegisterMeta(title)

		local editButton = title:Add("DButton")
		editButton:SetText("")
		editButton:SetPos(302, 20)
		editButton:SetSize(20, 20)
		editButton.alpha = 0.05
		editButton.Paint = function(_, w, h)
			_.alpha = Lerp(FrameTime() * 10, _.alpha, (_:IsHovered() or self.selectID == k) and 1 or 0.05)

			surface.SetDrawColor(255, 255, 255, 255 * _.alpha)
			surface.SetMaterial(Material("danganronpa/monopad/edit.png"))
			surface.DrawTexturedRect(0, 0, h, h)
		end
		editButton.DoClick = function()
			if self.isOpen then return end

			if self.selectID == k then
				self.selectID = nil
			else
				self.selectID = k
			end

			LocalPlayer():EmitSound(MonoPad.sounds.message_came)
		end

		local clearButton = title:Add("DButton")
		clearButton:SetText("")
		clearButton:SetPos(342, 20)
		clearButton:SetSize(20, 20)
		clearButton.alpha = 0.05
		clearButton.Paint = function(_, w, h)
			_.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 1 or 0.05)

			surface.SetDrawColor(255, 255, 255, 255 * _.alpha)
			surface.SetMaterial(Material("danganronpa/monopad/clear.png"))
			surface.DrawTexturedRect(0, 0, h, h)
		end
		clearButton.DoClick = function()
			if self.isOpen then return end

			netstream.Start("MonoPad:ClearCaseEvidence", k)

			timer.Simple(0.5, function()
				self:Rebuild()
			end)

			LocalPlayer():EmitSound(MonoPad.sounds.message_sent)
		end

		local List = panel:Add("DIconLayout")
		List:Dock(TOP)
		List:DockMargin(20, 0, 20, 0)
		List:SetTall(170)
		List:SetSpaceX(10)
		List:SetSpaceY(10)
		MonoPad:StartRegisterMeta(List)

		local monopad = MonoPad:GetObject()
		local caseStored = monopad.caseStored
		local case = caseStored[k] or {}

		local count = -1
		for id in pairs(case[6] or {}) do
			if Evidence:GetEvidence(id) then
				self:AddEvidence(id, List, self.rightPanel, true)

				count = count + 1
			end
		end

		local storey = math.floor(count / 4) + 1
		if count <= -1 then continue end

		panel:SetTall(76 + storey * 80 + storey * 10)
	end
end

function PANEL:AddEvidence(id, parent, scroll, noFind)
	local data = Evidence:GetEvidence(id)
	if !data then return end

	local dEvidence = Evidence.icons
	local evidenceMat = Material(dEvidence[data.image])

	local dRibbon = Evidence.ribbons
	local ribbonMat = Material(dRibbon[data.ribbon][1])
	local time = LocalPlayer():HasEvidence(id)

	local caseActive = nil
	if !noFind then
		local monopad = MonoPad:GetObject()
		local caseStored = monopad.caseStored
		for k, v in pairs(caseStored) do
			for k2 in pairs(v[6] or {}) do
				if k2 == id then
					caseActive = k
					break
				end
			end
		end
	end

	local button = parent:Add("DButton")
	button:SetText("")
	button:SetSize(80, 80)
	button.black = 0.6
	button.Paint = function(this, w, h)
		this.black = Lerp(FrameTime() * 10, this.black, this:IsHovered() and 0 or 0.6)

		local _, y = scroll:GetChildPosition(this)
		local padding = math.max(-y, 0)
		local tall = math.min(h - padding, scroll:GetTall() - y)

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

		    if caseActive then
		    	draw.SimpleText("№" .. caseActive, MonoPad:GetFont("gamelog_title"), 40, 50, color_white, TEXT_ALIGN_LEFT)
		    end

			surface.SetDrawColor(255, 255, 255, 3)
			surface.DrawOutlinedRect(0, 0, w, h)
	    end)
	end
	button.DoClick = function()
		if self.isOpen then return end

		if self.selectID then
			netstream.Start("MonoPad:AddCaseEvidence", self.selectID, id)

			timer.Simple(0.5, function()
				self:Rebuild()
			end)

			LocalPlayer():EmitSound(MonoPad.sounds.message_sent)
		else
			self.isOpen = true
			self.leftPanel:AlphaTo(0, 0.3)
			self.rightPanel:AlphaTo(0, 0.3)
			self.closeButton:AlphaTo(0, 0.3, 0, function()
				local evidence = self:Add("MonoPad:EvidenceSub")
				evidence:Dock(FILL)
				evidence:SetData(id, function()
					self.isOpen = false
					self.leftPanel:AlphaTo(255, 0.3)
					self.rightPanel:AlphaTo(255, 0.3)
					self.closeButton:AlphaTo(255, 0.3)
				end)
			end)

			LocalPlayer():EmitSound(MonoPad.sounds.planshet_beep)
		end
	end

	local ui = MonoPad:GetUI()
	ui:AddTooltip(button, data.name, dRibbon[data.ribbon][2], dRibbon[data.ribbon][3], time, function()
		return !self.isOpen
	end)
end

vgui.Register("MonoPad:Evidence", PANEL, "Panel")