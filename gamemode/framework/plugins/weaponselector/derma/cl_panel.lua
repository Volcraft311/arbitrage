--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru (not work)
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local PLUGIN = PLUGIN

local PANEL = {}

function PANEL:Init()
	self:SetPos()
	self:SetSize(ScrW(), ScrH())

	PLUGIN.panel = self

	self.num = 0
	self.panels = {}
	self.weapons = {}
	self.weaponsCategory = {}
	self.select = {
		x = 1,
		y = 1
	}

	self.nextThink = 0
	self.timeFocus = 0
	self.alpha = 0
	self.malpha = 0

	for k, v in ipairs(PLUGIN.category) do
		self:CreateCategory(v.id, v.name)
	end
end

function PANEL:GetStandartPanel()
	for k, v in ipairs(self.panels) do
		if !IsValid(v) then continue end

		if v.id == PLUGIN.standart then
			return v
		end
	end
end

function PANEL:GetWeaponPanel(class)
	local id = PLUGIN.weapons[class]

	if !id then
		return self:GetStandartPanel()
	end

	for k, v in ipairs(self.panels) do
		if !IsValid(v) then continue end

		if v.id == id then
			return v
		end
	end

	return self.panels[1]
end

function PANEL:InitWeapons()
	local data = self.weapons or {}

	for k, v in pairs(self.weaponsCategory) do
		if !data[k] then
			v:Remove()
			self.weaponsCategory[k] = nil
		end
	end

	for k, v in pairs(data) do
		if IsValid(self.weaponsCategory[k]) then self.weaponsCategory[k].weapon = v continue end

		local panel = self:GetWeaponPanel(k)

		local weapon = panel:Add("DPanel")
		weapon:SetTall(ScrH() * 0.04259259259)
		weapon:Dock(TOP)
		weapon:DockMargin(0, 4, 0, 0)
		weapon.weapon = v
		weapon.Paint = function(_, w, h)
			if !IsValid(self.weapons[k]) then return end
			if self.alpha <= 0.1 then return end

			surface.SetDrawColor(25, 25, 25, 240)
			surface.DrawRect(0, 0, w, h)

			local isSelect = self.select.x == _.x and self.select.y == _.y

			if PLUGIN.icons[k] then
				surface.SetDrawColor(isSelect and Color(255, 61, 96) or Color(255, 234, 238))
				surface.SetMaterial(Arbitrage.GetMaterial(PLUGIN.icons[k]))
				surface.DrawTexturedRect(W(12) + 5, 5, h - 10, h - 10)
			end

			if isSelect then
				surface.SetDrawColor(255, 61, 96)
				surface.DrawOutlinedRect(0, 0, w, h, 3)
			end

			local description = self.weapons[k]:GetPrintName()
			if utf8.len(description) > 15 then
				description = description:utf8sub(1, 12) .. "..."
			end

			draw.SimpleText(description, "arb.Font_FuturaPTBook_9", h + W(12 + 5), h / 2 - H(15), isSelect and Color(255, 61, 96) or Color(255, 234, 238), TEXT_ALIGN_LEFT)
		end

		self.weaponsCategory[k] = weapon
	end
end

function PANEL:Think()
	--if self.alpha <= 0.1 then return end

	local time = RealTime()
	if time >= self.nextThink then
		local client = LocalPlayer()
		local weapons = client:GetWeapons()

		local data = {}

		for k, v in ipairs(weapons) do
			local class = v:GetClass()
			data[class] = v
		end

		self.weapons = data
		self:InitWeapons()
		self.nextThink = time + 0.1
	end

	if gui.IsGameUIVisible() then
		self.timeFocus = 0
	end
end

function PANEL:CreateCategory(id, name)
	self.num = self.num + 1

	local wide = ScrW() * 0.125
	local indent = 10
	local num = self.num

	if IsValid(self.panels[self.num]) then
		self.panels[self.num]:Remove()
	end

	self.panels[self.num] = self:Add("Panel")
	self.panels[self.num]:SetX((ScrW() / 2 - wide / 2) + (self.num - 1) * (wide + indent) - (wide * (#PLUGIN.category - 1) / 2))
	self.panels[self.num]:SetTall(0)
	self.panels[self.num]:SetWide(wide)
	self.panels[self.num].id = id
	self.panels[self.num].name = name
	self.panels[self.num].num = num
	self.panels[self.num].tall = 0
	--self.panels[self.num].panels = {}

	local title = self.panels[self.num]:Add("DPanel")
	title:Dock(TOP)
	title:DockMargin(0, ScrH() * 0.03703703703, 0, 0)
	title:SetTall(ScrH() * 0.04259259259)
	title.Paint = function(_, w, h)
		if self.alpha <= 0.1 then return end

		surface.SetDrawColor(25, 25, 25, 240)
		surface.DrawRect(0, 0, w, h)

		draw.SimpleText(name, "arb.Font_FuturaPTDemi_9", w / 2, h / 2 - H(15), Color(255, 234, 238), TEXT_ALIGN_CENTER)
		draw.SimpleText(num, "arb.Font_FuturaPTBook_7", w - 4, h - H(25), Color(255, 234, 238, 50), TEXT_ALIGN_RIGHT)
	end
end

function PANEL:IsFocus()
	local time = RealTime()

	return time <= self.timeFocus
end

function PANEL:Paint(w, h)
	self.alpha = Lerp(FrameTime() * 10, self.alpha, self:IsFocus() and 255 or 0)
	self:SetAlpha(self.alpha)

	if self.alpha <= 0.1 then return end

	local select_x = self.select.x
	local select_y = self.select.y

	local frametime = FrameTime() * 10
	local size = ScrH() * 0.04259259259

	for k, v in ipairs(self.panels) do
		local children = v:GetChildren()
		table.remove(children, 1)

		v.tall = Lerp(frametime, v.tall, v.num == select_x and ((size + 4) * #children) or 0)

		v:SetTall(ScrH() * 0.03703703703 + size + v.tall)

		for k2, v2 in ipairs(children) do
			v2.x = v.num
			v2.y = k2
		end
	end
end

vgui.Register("arb.WeaponSelector", PANEL, "EditablePanel")