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

local PANEL = {}

local cubeMatList = {
	"danganronpa/changestyle/1.png",
	"danganronpa/changestyle/2.png",
	"danganronpa/changestyle/3.png",
	"danganronpa/changestyle/4.png",
	"danganronpa/changestyle/5.png",
	"danganronpa/changestyle/6.png"
}

function PANEL:Init()
	self:SetPos(0, 0)
	self:SetSize(ScrW(), ScrH())
	self:SetAlpha(0)
	self:AlphaTo(255, 0.3)

	self.size = asterionlib.Tween(0, 100, 1.5, "outQuart")
	self.font = "arb.Font_FuturaPTDemi_30"
	self.moving = 0
	self.moveSpeed = 50
	self.charList = {}

	asterionlib.EmitSound("academy/changestyle/song.wav")
end

function PANEL:Closing()
	self:AlphaTo(0, 0.5, 0, function()
		self:Remove()
	end)

	self.moveSpeed = 3000
	self.size = self.size:TargetTo(0, 0.3, nil, "linear")

	for k, v in ipairs(self.charList) do
		v.reSize = v.reSize:TargetTo(0, 0.1, nil, "inCirc")
	end

	for k, v in ipairs(self.cubeList) do
		v.reSize = v.reSize:TargetTo(0, 0.4, nil, "linear")
	end
end

function PANEL:GenerateChars()
	surface.SetFont(self.font)
	self.sizeAll, _ = surface.GetTextSize(self.text)

	local _w = 0
	for i = 1, utf8.len(self.text) do
		local char = utf8.sub(self.text, i, i)
		local width, height = surface.GetTextSize(char)

		self.charList[i] = {
			char = char,
			alpha = 0,
			x = _w,
			rotate = math.random(-2, 2)
		}

		timer.Simple(i * 0.03, function()
			local info = self.charList[i]

			info.reAlpha = asterionlib.Tween(0, 255, 0.5, "outInQuart")
			info.reSize = asterionlib.Tween(5, 0.3, 0.15, "linear", function()
				info.reSize = info.reSize:TargetTo(1, 0.3, nil, "inCirc")
			end)
		end)

		_w = _w + width
	end
end

function PANEL:GenerateCubes()
	local i = 1
	local sizeCubeAll = 0
	self.cubeList = {}
	while true do
		local ranSize = math.random(80, 180)
		local ranRot = math.random(-20, 20)
		local ranMat = cubeMatList[math.random(#cubeMatList)]

		sizeCubeAll = sizeCubeAll + ranSize

		self.cubeList[i] = {
			mat = ranMat,
			size = ranSize,
			rotate = ranRot
		}

		i = i + 1
		if sizeCubeAll >= self.sizeAll then break end
	end

	for k, v in ipairs(self.cubeList) do
		timer.Simple(k * 0.03, function()
			v.reAlpha = asterionlib.Tween(0, 255, 1, "outCubic")
			v.reSize = asterionlib.Tween(0, v.size * 1.15, 0.2, "linear", function()
				v.reSize = v.reSize:TargetTo(v.size, 0.3, nil, "linear")
			end)
		end)
	end

	self.sizeAllCube = sizeCubeAll
end

function PANEL:SetData(text, r, g, b)
	self.text = text
	self.color = Color(r, g, b, 100)

	self:GenerateChars()
	self:GenerateCubes()

	self:SetCloseTimer()
end

function PANEL:SetCloseTimer()
	timer.Simple(utf8.len(self.text) * 0.16, function()
		if !IsValid(self) then return end

		self:Closing()
	end)
end

function PANEL:RotatedText(text, x, y, ang, scale, alpha)
	local font_name = string.match(self.font, "%a+.%a+_%a+")
    local font_size = string.match(self.font, "%d+")

    local font_normal = font_name .. "BlurN_" .. font_size
    local font_blur = font_name .. "Blur_" .. font_size

	render.PushFilterMag(TEXFILTER.ANISOTROPIC)
	render.PushFilterMin(TEXFILTER.ANISOTROPIC)

	local m = Matrix()
	m:Translate(Vector(x, y, 0))
	m:Rotate(Angle(0, ang, 0))
	m:Scale(scale)

	surface.SetFont(self.font)
	local w, h = surface.GetTextSize( text )

	m:Translate(-Vector(w / 2, h / 2, 0))

	cam.PushModelMatrix( m )
		for i = 1, 2 do
	        draw.SimpleText(text, font_blur, 0, 0, ColorAlpha(color_white, alpha), TEXT_ALIGN_LEFT)
	    end

	    for i1 = -2, 2 do
	    	for i2 = -2, 2 do
				draw.SimpleText(text, font_normal, i1, i2, ColorAlpha(self.color, alpha), TEXT_ALIGN_LEFT)
			end
		end

		draw.SimpleText(text, font_normal, 0, 0, ColorAlpha(color_white, alpha), TEXT_ALIGN_LEFT)
	cam.PopModelMatrix()

	render.PopFilterMag()
	render.PopFilterMin()
end

function PANEL:DrawGradient(w, h)
	local tall = self.size:Render()

	Arbitrage.DrawGradient(GRADIENT_RIGHT, 0, h / 2 - (tall / 2), w / 2, tall + 2, self.color)
	Arbitrage.DrawGradient(GRADIENT_LEFT, w / 2, h / 2 - (tall / 2), w / 2, tall + 2, self.color)

	surface.SetDrawColor(0, 0, 0)

	surface.DrawRect(0, h / 2 - (tall / 2), w, 2)
	surface.DrawRect(0, h / 2 + (tall / 2), w, 2)
end

function PANEL:DrawCubes(w, h)
	local move = 0
	for k, v in ipairs(self.cubeList) do
		local reAlpha = v.reAlpha
		if !reAlpha then continue end

		local alpha = reAlpha:Render()
		local size = v.reSize:Render()

		local mat = Material(v.mat)
		local rotate = v.rotate

		local x, y = (w / 2 + move) - self.sizeAllCube / 2 + (size / 2), h / 2

		surface.SetDrawColor(255, 255, 255, alpha)
		surface.SetMaterial(mat)
		surface.DrawTexturedRectRotated(x + self.moving, y, size, size, 45 + rotate)

		move = move + size
	end
end

function PANEL:DrawChars(w, h)
	for k, v in ipairs(self.charList) do
		local reAlpha = v.reAlpha
		if !reAlpha then continue end

		local alpha = reAlpha:Render()
		local size = v.reSize:Render()

		local x, y = w / 2 + v.x - self.sizeAll / 2, h / 2
		local sizeVec = Vector(size, size, 1)

		self:RotatedText(v.char, x + self.moving, y, v.rotate * 8, sizeVec, alpha)
	end
end

function PANEL:Paint(w, h)
	local speed = FrameTime() * self.moveSpeed
	self.moving = self.moving + speed

	self:DrawGradient(w, h)
	self:DrawCubes(w, h)
	self:DrawChars(w, h)
end

vgui.Register("arb.ChangeStyle", PANEL, "EditablePanel")