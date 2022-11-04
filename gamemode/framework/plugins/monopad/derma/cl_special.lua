local PANEL = {}

function PANEL:Init()
	MonoPad:StartRegisterMeta(self)

	local ui = MonoPad:GetUI()
	if !IsValid(ui) then return self:Remove() end

	self.closeButton = ui:BackButton(self, function()
		if self.isOpen then return end

		ui:Rebuild()
		LocalPlayer():EmitSound(MonoPad.sounds.planshet_beep)
	end)

	self.evidencePanel = self:CreateButton("Найденные улики", "Все найденные вами улики заносятся в данную\nкатегорию. Распределяйте их по активным делам\nдля правильного выявления виновного", Material("aboba.png"))
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

		LocalPlayer():EmitSound(MonoPad.sounds.planshet_beep)
	end

	self.secretsPanel = self:CreateButton("Тайны Академии", "Особые материалы и файлы, помогающие\nраскрывать общую тайну. Используйте их для\nполного успешного прохождения Академии.", Material("aboba.png"))
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

	self.rightPanel = self:Add("DPanel")
	self.rightPanel:SetPos(450, 18)
	self.rightPanel:SetSize(390, 518)
	self.rightPanel.Paint = function() end
end

function PANEL:AddEvidence(id, parent, scroll)
	local data = Evidence:GetEvidence(id)
	if !data then return end

	local dEvidence = Evidence.icons
	local evidenceMat = Material(dEvidence[data.image])

	local dRibbon = Evidence.ribbons
	local ribbonMat = Material(dRibbon[data.ribbon][1])
	local time = LocalPlayer():HasEvidence(id)

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

			surface.SetDrawColor(255, 255, 255, 3)
			surface.DrawOutlinedRect(0, 0, w, h)
	    end)
	end
	button.DoClick = function()
		if self.isOpen then return end

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

	local ui = MonoPad:GetUI()
	ui:AddTooltip(button, data.name, dRibbon[data.ribbon][2], dRibbon[data.ribbon][3], time, function()
		return !self.isOpen
	end)
end

vgui.Register("MonoPad:Evidence", PANEL, "Panel")