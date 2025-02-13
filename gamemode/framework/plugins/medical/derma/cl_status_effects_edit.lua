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


local PANEL = {}

function PANEL:Init()
	self:SetSize(ScrW() / 2, ScrH() / 2)
	self:Center()
	self:MakePopup()
	self:SetAlpha(0)
	self:AlphaTo(255, 0.3)
	self:SetTitle("")

	self:Title()
	self:Main()
end

function PANEL:Title()
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
end

local normalSize = H(30)
local font = "arb.Font_FuturaPTBook_6"
local function updateHeight(uniqueID, panel)
	local info = Medical.t_status_effects[uniqueID]
	if !info then return end

	local description = L(info.description)
	local formatDescription = Medical:FormatTemporaryDescription(uniqueID, description)

	local size = 0
	local data = asterionlib.WrapText(formatDescription, ScrW() / 2 - 10, font, true)
	for k, v in ipairs(data) do
		local _w, _h = draw.SimpleText(v, font, 5, size, color_white, TEXT_ALIGN_LEFT)

		size = size + _h
	end

	local size2 = 5
	for k, v in pairs(panel.panels) do
		for k2, v2 in ipairs(v) do
			size2 = size2 + v2:GetTall()
		end

		local valueLabel = v[1]
		valueLabel:SetText(Medical:FormatTemporaryDescription(uniqueID, L(info.values[k].description)))

		local value = Medical:FormatTemporaryDescription(uniqueID, Medical:TemporaryStatusEffectsValues(uniqueID)[k])
		local valueTextEntry = v[3]
		valueTextEntry:SetValue(L(value))
	end

	local descriptionPanel = panel.descriptionPanel
	descriptionPanel.data = data

	descriptionPanel:SetTall(size)
	panel.openSize = normalSize + size + size2
end

local yesMat = Material("danganronpa/ui/info_7.png")
local noMat = Material("danganronpa/ui/info_5.png")
local sizeMat = 1.1
function PANEL:Main()
	local scrollPanel = self:Add("DScrollPanel")
	scrollPanel:Dock(FILL)
	scrollPanel:DockMargin(W(5), H(5), W(5), 0)

	do
	    local bar = scrollPanel:GetVBar()
	    bar:SetWide(10)
	    bar:DockMargin(0, 0, 0, 0)

	    bar.Paint = function(_, w, h)
	        surface.SetDrawColor(255, 255, 255, 3)
	        surface.DrawRect(10 - 3, 0, 3, h)
	    end
	    bar.btnUp.Paint = function(_, w, h) end
	    bar.btnDown.Paint = function(_, w, h) end
	    bar.btnGrip.Paint = function(_, w, h)
	        surface.SetDrawColor(255, 255, 255)
	        surface.DrawRect(10 - 3, 0, 3, h)
	    end
	end

	local client = LocalPlayer()
	local disable = GetNetVar("medical:statuseffects_disable", {})

	for k, v in pairs(Medical.t_status_effects) do
		local bIsOpen = false
		local bIsAnimation = false
		local alpha = 0
		local material = isfunction(v.icon) and v.icon(client) or v.icon
		material = Material(material)

		local panel = scrollPanel:Add("Panel")
		panel:Dock(TOP)
		panel:SetTall(normalSize)
		panel:DockMargin(0, 0, 0, H(5))
		panel.openSize = normalSize
		panel.panels = {}
		panel.Paint = function(_, w, h)
			surface.SetDrawColor(255, 61, 96, 165.75)
			surface.DrawOutlinedRect(0, 0, w, h, 1)
		end

		local name = L(v.name)

		local title = panel:Add("DButton")
		title:SetText("")
		title:Dock(TOP)
		title:SetTall(normalSize)
		title.Paint = function(_, w, h)
			alpha = Lerp(FrameTime() * 10, alpha, (_:IsHovered() or bIsOpen) and 20 or 0)

			surface.SetDrawColor(255, 61, 96, alpha)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(material)
			surface.DrawTexturedRect(2, 2, normalSize - 4, normalSize - 4)

			draw.SimpleText(name, "arb.Font_FuturaPTBook_8", normalSize + 5, 3, color_white, TEXT_ALIGN_LEFT)

			surface.SetDrawColor(255, 61, 96, 165.75)
			surface.DrawOutlinedRect(0, 0, w, h, 1)
		end
		title.DoClick = function(_)
			if bIsAnimation then return end

			bIsOpen = !bIsOpen
			bIsAnimation = true

			panel:SizeTo(-1, bIsOpen and panel.openSize or normalSize, 0.2, 0, -1, function()
				bIsAnimation = false
			end)
		end

		local checkbox = title:Add("DButton")
		checkbox:SetText("")
		checkbox:Dock(RIGHT)
		checkbox:DockMargin(0, 0, W(5), 0)
		checkbox:SetWide(normalSize)
		checkbox.bValue = disable[k] == nil and true or false
		checkbox.alpha = 100
		checkbox.DoClick = function(this)
			this.bValue = !this.bValue

			netstream.Start("Medical:DisableStatusEffect", k, this.bValue)
			asterionlib.EmitSound("garrysmod/balloon_pop_cute.wav")
		end

		checkbox.Paint = function(this, w, h)
			this.alpha = Lerp(FrameTime() * 10, this.alpha, this:IsHovered() and 255 or 100)

			surface.SetDrawColor(255, 255, 255, this.alpha)
			surface.SetMaterial(this.bValue and yesMat or noMat)
			surface.DrawTexturedRect(w / 2 - h * sizeMat / 2, h / 2 - h * sizeMat / 2, h * sizeMat, h * sizeMat)
		end

		panel.descriptionPanel = panel:Add("DPanel")
		panel.descriptionPanel:Dock(TOP)
		panel.descriptionPanel.data = {}
		panel.descriptionPanel.Paint = function(this, w, h)
			local size = 0

			for k2, v2 in ipairs(this.data) do
				local _w, _h = draw.SimpleText(v2, font, 5, size, color_white, TEXT_ALIGN_LEFT)

				size = size + _h
			end
		end

		for k2, v2 in pairs(v.values or {}) do
			local valueLabel = panel:Add("DLabel")
			valueLabel:SetText("")
			valueLabel:SetTextColor(Color(255, 255, 255, 200))
			valueLabel:Dock(TOP)
			valueLabel:DockMargin(10, 0, 10, 0)
			valueLabel:SetFont("arb.Font_FuturaPTBook_7")

			local valueDefault = panel:Add("DLabel")
			valueDefault:SetText("Стандартно: " .. v2.default)
			valueDefault:SetTextColor(Color(255, 255, 255, 50))
			valueDefault:Dock(TOP)
			valueDefault:DockMargin(10, 0, 10, 0)
			valueDefault:SetFont("arb.Font_FuturaPTBook_6")

			local valueTextEntry = panel:Add("DTextEntry")
			valueTextEntry:SetValue("")
			valueTextEntry:Dock(TOP)
			valueTextEntry:DockMargin(10, 0, 10, 0)
			valueTextEntry:SetFont("arb.Font_FuturaPTBook_7")
			valueTextEntry.OnEnter = function(this)
				local value = this:GetValue()

				local function returnValue()
					timer.Simple(0.1, function()
						local oldValue = Medical:TemporaryStatusEffectsValues(k)[k2]

						this:SetValue(oldValue)
					end)
				end

				local function saveValue(newValue)
					netstream.Start("Medical:EditStatusEffect", k, k2, newValue)

					timer.Simple(0.5, function()
						updateHeight(k, panel)
					end)

					asterionlib.EmitSound("garrysmod/balloon_pop_cute.wav")
				end

				if v2.type == Medical.types.number then
					local int = tonumber(value)
					if !int then return returnValue() end

					saveValue(int)
				elseif v2.type == Medical.types.string then
					local str = tostring(value)
					if !str then return returnValue() end

					saveValue(str)
				elseif Medical.types.boolean then
					local bool = tobool(value)
					if !bool then return returnValue() end

					saveValue(bool)
				end
			end

			panel.panels[k2] = {valueLabel, valueDefault, valueTextEntry}
		end

		updateHeight(k, panel)
	end
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

	draw.DrawText("Меню статус эффектов", "arb.Font_FuturaPTDemi_8", W(10), H(3), color_white, TEXT_ALIGN_LEFT)
end

vgui.Register("Medical:StatusEffectsEdit", PANEL, "DFrame")