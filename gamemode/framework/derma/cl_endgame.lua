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

surface.CreateFont("arb.EndGameFont", {
	font = "Pixel Times",
	extended = true,
	size = ScreenScale(19),
	weight = 500,
	antialias = true
})

surface.CreateFont("arb.EndGameFontTitle", {
	font = "Pixel Times",
	extended = true,
	size = ScreenScale(65),
	weight = 500,
	antialias = true
})

local endgame_sound = "academy/endgame/song.mp3"
util.PrecacheSound(endgame_sound)

local standMat = Material("danganronpa/endgame/stand.png")

local PANEL = {}

function PANEL:Init()
	self:SetPos(0, 0)
	self:SetSize(ScrW(), ScrH())
	self:MakePopup()
	self:SetAlpha(0)
	self:AlphaTo(255, 1, 0, function()
		self:Menu()
	end)
end

local count_up = 5
local count_right = 120
function PANEL:Menu()
	asterionlib.EmitSound(endgame_sound)

	timer.Simple(6.6, function()
		if !IsValid(self) then return end

		self:Blur()
	end)

	local center = self:GetTall() / 2 + 100

	self.panel = self:Add("Panel")
	self.panel:SetAlpha(0)
	self.panel:AlphaTo(255, 1)
	self.panel:Dock(FILL)
	self.panel.Paint = function(_, w, h)
		self.w = self.w or w
		self.h = self.h or h

		local size = w / count_right
		local line_size = size / 2
		local stand_size = w * 0.4

		surface.SetDrawColor(200, 35, 57)

		surface.DrawRect(0, 0, w, line_size)
		surface.DrawRect(0, center, w, line_size)

		surface.SetDrawColor(255, 0, 0)
		surface.SetMaterial(standMat)
		surface.DrawTexturedRect(w / 2 - stand_size / 2, center - stand_size / 2, stand_size, stand_size / 2)

		for i = 0, count_up do
			local a = i % 2 == 0
			local alpha = 255 - (i * 50)

			for i2 = 0, count_right do
				local x, y = size * i2 * 2 + (a and size or 0), h - size - (size * i)

				surface.SetDrawColor(200, 35, 57, alpha)
				surface.DrawRect(x, y, size, size)
			end
		end

		for i = 0, count_up do
			local a = i % 2 == 0
			local alpha = 255 - (i * 50)

			for i2 = 0, count_right do
				local x, y = size * i2 * 2 + (a and size or 0), size * i + line_size

				surface.SetDrawColor(200, 35, 57, alpha)
				surface.DrawRect(x, y, size, size)
			end
		end

		self:DrawEscape(w, h, center)
	end

	if self.targetName then
		self:AddMessage(self.targetName)
	end

	self:AddTitle()
end

local speedAttacker = 500
local speedTarget = 450
function PANEL:DrawEscape(w, h, center)
	local a = math.floor(RealTime() * 10) % 2 == 0

	local size = h * 0.2

	surface.SetDrawColor(255, 35, 57)

	if self.attackerMat then
		local b = a and self.attackerMat[1] or self.attackerMat[2]

		surface.SetMaterial(b)
		surface.DrawTexturedRect(self.attackerPos - size * 9, center - size, size, size)
	end

	if self.targetMat then
		local b = a and self.targetMat[1] or self.targetMat[2]

		surface.SetMaterial(b)
		surface.DrawTexturedRect(self.targetPos - size, center - size, size, size)
	end

	local frametime = FrameTime()

	self.attackerPos = self.attackerPos + frametime * speedAttacker
	self.targetPos = self.targetPos + frametime * speedTarget
end

function PANEL:Blur()
	local alpha = 0

	local blur = self:Add("DPanel")
	blur:Dock(FILL)
	blur.Paint = function(_, w, h)
		alpha = Lerp(FrameTime() * 3, alpha, 256)

		asterionlib.DrawBlur(blur, alpha * 0.05, 4, alpha)
	end

	local black = self:Add("DPanel")
	black:SetAlpha(0)
	black:AlphaTo(255, 1, 0, function()
		blur:Remove()
		self.panel:Remove()
		self.message:Remove()
		self.title:Remove()

		self:AlphaTo(0, 1, 0, function()
			self:Remove()
		end)
	end)
	black:Dock(FILL)
	black.Paint = function(_, w, h)
		surface.SetDrawColor(0, 0, 0)
		surface.DrawRect(0, 0, w, h)
	end
end

function PANEL:SetData(title, teamAttacker, teamTarget, text1, text2)
	self.title = title

	do
		local factionAttacker = Character.team:GetByID(teamAttacker)

		if factionAttacker then
			self.attackerPos = 0
			self.attackerMat = {
				Material(factionAttacker:GetAssets().path .. "/run_1.png"),
				Material(factionAttacker:GetAssets().path .. "/run_2.png")
			}
		end
	end

	do
		local factionTarget = Character.team:GetByID(teamTarget)

		if factionTarget then
			self.targetPos = 0
			self.targetMat = {
				Material(factionTarget:GetAssets().path .. "/run_1.png"),
				Material(factionTarget:GetAssets().path .. "/run_2.png")
			}
			self.targetName = factionTarget:GetName()
		end
	end

	self.text1 = text1:format(self.targetName)
	self.text2 = text2
end

function PANEL:AddTitle()
	local font = "arb.EndGameFontTitle"
	surface.SetFont(font)

	local text = self.title
	local wide, tall = surface.GetTextSize(text)

	local text_data = {}
	for i = 1, utf8.len(text) do
		local a = utf8.sub(text, i, i)

		text_data[i] = a
	end

	self.title = self:Add("DPanel")
	self.title:SetAlpha(0)
	self.title:AlphaTo(255, 1)
	self.title:SetPos(self:GetWide() / 2 - wide / 2, 170)
	self.title:SetSize(wide, tall)
	self.title.Paint = function(_, w, h)
		self.wide3T = self.wide3T or asterionlib.Tween(0, w, 1, "linear", function()
			self.message:AlphaTo(255, 1)
			self.message:StartThink()

			self.wide1T = self.wide1T or asterionlib.Tween(0, self.message:GetWide(), 2, "linear", function()
				self.wide2T = asterionlib.Tween(0, self.message:GetWide(), 2, "linear")
			end)
		end)

		local _wide = self.wide3T:Render()

		surface.SetFont(font)

		local _w = 0
		local index = 1

		asterionlib.DrawRender(function()
	        surface.SetDrawColor(255, 255, 255)
		    surface.DrawRect(0, 0, _wide, h)
	    end, function()
	        for k, v in ipairs(text_data) do
				local __w, _ = surface.GetTextSize(v)

				local a = math.floor(RealTime() * 4 + index) % 2 == 0
				local b = a and Color(255, 35, 57) or color_white

				draw.DrawText(v, font, _w, 0, b, TEXT_ALIGN_LEFT)
				_w = _w + __w

				if v != " " then
					index = index + 1
				end
			end
	    end)
	end
end

function PANEL:AddMessage(name)
	local center = self:GetTall() * 0.65

	local wide = self:GetWide() * 0.5

	local height = draw.GetFontHeight("arb.EndGameFont")

	tallT = asterionlib.Tween(0, height * 3, 1, "outQuint")

	self.message = self:Add("DPanel")
	self.message:SetAlpha(0)
	self.message:SetPos(self:GetWide() / 2 - wide / 2, center)
	self.message:SetSize(wide, 0)
	self.message.tall = 0
	self.message.Paint = function(_, w, h)
		surface.SetDrawColor(255, 35, 57)

		surface.DrawRect(15, 0, w - 15 * 2, 5)
		surface.DrawRect(15, h - 5, w - 15 * 2, 5)
		surface.DrawRect(0, 15, 5, h - 15 * 2)
		surface.DrawRect(w - 5, 15, 5, h - 15 * 2)

		surface.DrawRect(5, 10, 5, 5)
		surface.DrawRect(10, 5, 5, 5)

		surface.DrawRect(5, h - 15, 5, 5)
		surface.DrawRect(10, h - 10, 5, 5)

		surface.DrawRect(w - 15, 5, 5, 5)
		surface.DrawRect(w - 10, 10, 5, 5)

		surface.DrawRect(w - 10, h - 15, 5, 5)
		surface.DrawRect(w - 15, h - 10, 5, 5)

		self:DrawArrow(w - 45, h - 40)

		do
			local wide = self.wide1T and self.wide1T:Render() or 0

			asterionlib.DrawRender(function()
		        surface.SetDrawColor(255, 255, 255)
			    surface.DrawRect(0, 0, wide, h)
		    end, function()
		        draw.SimpleText(self.text1, "arb.EndGameFont", w / 2, height / 2, Color(255, 35, 57), TEXT_ALIGN_CENTER)
		    end)
		end

		do
			local wide = self.wide2T and self.wide2T:Render() or 0

		 	asterionlib.DrawRender(function()
		        surface.SetDrawColor(255, 255, 255)
			    surface.DrawRect(0, 0, wide, h)
		    end, function()
		        draw.SimpleText(self.text2, "arb.EndGameFont", w / 2, height + height / 2, Color(255, 35, 57), TEXT_ALIGN_CENTER)
		    end)
		end
	end

	self.message.StartThink = function(_)
		self.message.Think = function(this, w, h)
			local tall = tallT:Render()

			this:SetTall(tall)
		end
	end
end

function PANEL:DrawArrow(x, y)
	local a = math.floor(RealTime() * 4) % 2 == 0
	local b = a and 10 or 0

	surface.SetDrawColor(a and color_white or Color(255, 35, 57))

	surface.DrawRect(x, y + b, 30, 5)
	surface.DrawRect(x + 5, y + 5 + b, 20, 5)
	surface.DrawRect(x + 10, y + 10 + b, 10, 5)
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(0, 0, 0)
	surface.DrawRect(0, 0, w, h)
end

vgui.Register("arb.MonoEndGame", PANEL, "EditablePanel")