local arrow = Material("danganronpa/monopad/arrow.png")

local PANEL = {}

function PANEL:Init()
	self.selectCategory = 1
	self.data = MonoPad.miniMapList[game.GetMap()]

	MonoPad:StartRegisterMeta(self)

	local ui = MonoPad:GetUI()
	if !IsValid(ui) then return self:Remove() end

	ui:BackButton(self, function()
		local historyID = ui:GetActiveHistoryID()
		if historyID then
			local monopad = MonoPad:GetObject()
			table.remove(monopad.history, historyID)
		end

		ui:Rebuild()
		LocalPlayer():EmitSound(MonoPad.sounds.planshet_beep)
	end)

	local bottomPanel = self:Add("Panel")
	bottomPanel:SetTall(42)
	bottomPanel:Dock(BOTTOM)
	bottomPanel.Paint = function(_, w, h)
		surface.SetDrawColor(0, 0, 0, 250)
		surface.DrawRect(0, 0, w, h)
	end

	local leftPanel = bottomPanel:Add("DPanel")
	leftPanel:SetWide(200)
	leftPanel:Dock(LEFT)
	leftPanel.Paint = function(_, w, h)
		draw.SimpleText("Уровень просмотра:", MonoPad:GetFont("minimap_button"), 20, 10, color_white, TEXT_ALIGN_LEFT)
	end

	local rightPanel = bottomPanel:Add("Panel")
	rightPanel:Dock(FILL)
	MonoPad:StartRegisterMeta(rightPanel)

	if self.data then
		for k, v in ipairs(self.data.stored or {}) do
			local button = rightPanel:Add("DButton")
			button:SetText(v[1])
			button:SetFont(MonoPad:GetFont("minimap_button2"))
			button:Dock(LEFT)
			button:SizeToContents()

			button.alpha = 0.1
	        button.alpha2 = 0

			button:SetText("")
			button:SetWide(button:GetWide() + 14)

			button.DoClick = function()
				self.selectCategory = k

				local selectCategory = self.selectCategory or 1
				ui:EditHistory(ui:GetActiveHistoryID(), {
					"navigation",
					self.data.stored[selectCategory][1],
					MonoPad.icons.navigation,
					{selectCategory}
				})

				LocalPlayer():EmitSound(MonoPad.sounds.planshet_beep)
			end

			button.Paint = function(_, w, h)
				local selected = self.selectCategory == k

				_.alpha = Lerp(FrameTime() * 10, _.alpha, _:IsHovered() and 1 or 0.1)
				_.alpha2 = Lerp(FrameTime() * 10, _.alpha2, selected and 1 or -0.1)

				MonoPad:DrawTextBlur(v[1], MonoPad:GetFont("minimap_button2"), w / 2, 10, Color(255, 238, 177, 255 * _.alpha2), TEXT_ALIGN_CENTER)

				if !selected then
					draw.SimpleText(v[1], MonoPad:GetFont("minimap_button2"), w / 2, 10, Color(255, 255, 255, 255 * _.alpha), TEXT_ALIGN_CENTER)
				end

				surface.SetDrawColor(255, 255, 255, 30)
				surface.DrawRect(w - 2, 11, 2, 20)
			end
		end
	end
end

function PANEL:PerformLayout(w, h)
	if !self.init then
		local selectCategory = self.selectCategory or 1

		local ui = MonoPad:GetUI()
		ui:EditHistory(ui:GetActiveHistoryID(), {
			"navigation",
			self.data.stored[selectCategory][1],
			MonoPad.icons.navigation,
			{selectCategory}
		})

		self.init = true
	end
end

local sizeX, sizeY = 0.135, 0.24
local function CalculatePos(pos, data)
	local x, y = data.x, data.y

	x = x + pos.y * sizeY
	y = y + pos.x * sizeX

	return x, y
end

local sizeTexture = 20
function PANEL:Paint(w, h)
	if !self.data then return end

	local client = LocalPlayer()
	local pos = client:GetPos()

	local stored = self.data.stored[self.selectCategory]
	if !stored then return end

	local texture = Material(stored[2])

	surface.SetDrawColor(0, 0, 0)
	surface.DrawRect(0, 0, w, h)

	asterionlib.DrawRender(function()
	    surface.SetDrawColor(255, 255, 255)
		surface.DrawRect(0, 0, w, h)
	end, function()
	    local x, y = CalculatePos(pos, self.data)

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(texture)
		surface.DrawTexturedRect(x, y, texture:Width(), texture:Height())
	end)

	local angles = EyeAngles()
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(arrow)
	surface.DrawTexturedRectRotated(w / 2, h / 2, sizeTexture, sizeTexture, angles.y)
end

vgui.Register("MonoPad:MiniMap", PANEL, "DPanel")