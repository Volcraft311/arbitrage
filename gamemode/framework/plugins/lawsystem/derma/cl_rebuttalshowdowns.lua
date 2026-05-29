local PLUGIN = PLUGIN

local PANEL = {}

function PANEL:Init()
	if IsValid(Arbitrage.gui.RebuttalShowdowns) then Arbitrage.gui.RebuttalShowdowns:Remove() end

	Arbitrage.gui.RebuttalShowdowns = self

	self:SetPos(0, 0)
	self:SetSize(ScrW(), ScrH())
	self:SetZPos(20000)
	self.size = 0

	do
		local mat_ColorMod = Material("pp/colour")
		mat_ColorMod:SetTexture("$fbtexture", render.GetScreenEffectTexture())

		self.redColorMod = mat_ColorMod
		self.redScreenEffect = render.GetScreenEffectTexture()
	end

	do
		local mat_ColorMod = Material("pp/colour")
		mat_ColorMod:SetTexture("$fbtexture", render.GetScreenEffectTexture())

		self.blueColorMod = mat_ColorMod
		self.blueScreenEffect = render.GetScreenEffectTexture()
	end
end

local RedColorModify = {
	["$pp_colour_addr"] = 0.05,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = -0.2,
	["$pp_colour_contrast"] = 1.2,
	["$pp_colour_colour"] = 0.7,
	["$pp_colour_mulr"] = 0.5,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local BlueColorModify = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0.15,
	["$pp_colour_brightness"] = -0.2,
	["$pp_colour_contrast"] = 1.3,
	["$pp_colour_colour"] = 0.4,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 1.5
}

local rs_notify_border_size = 100
local rs_notify_red_alpha = 0
local rs_notify_blue_alpha = 0
local rs_notify_mat = Material("danganronpa/law/rs/advantage_triple.png")
local function renderRSNotify(w, h, borderW, size)
	local sizeW, sizeH = ScrH(), ScrH() * 0.06
	local alpha = math.Clamp(255 * math.abs(math.sin(RealTime() * 1.5)) + 60, 0, 255)
	local speed = FrameTime() * 3

	rs_notify_red_alpha = Lerp(speed, rs_notify_red_alpha, size < -0.25 and 0 or 256)
	rs_notify_blue_alpha = Lerp(speed, rs_notify_blue_alpha, size > 0.25 and 0 or 256)

	surface.SetDrawColor(100, 100, 255, alpha - rs_notify_red_alpha)
	surface.SetMaterial(rs_notify_mat)
	surface.DrawTexturedRectRotated(borderW + sizeH, sizeW / 2, sizeW, sizeH, 90)

	surface.SetDrawColor(255, 100, 100, alpha - rs_notify_blue_alpha)
	surface.SetMaterial(rs_notify_mat)
	surface.DrawTexturedRectRotated(borderW - sizeH, sizeW / 2, sizeW, sizeH, -90)

	Arbitrage.DrawGradient(GRADIENT_RIGHT, borderW - rs_notify_border_size, 0, rs_notify_border_size, h, Color(255, 0, 0, 255 * 0.6 - rs_notify_blue_alpha * 0.6))
	Arbitrage.DrawGradient(GRADIENT_LEFT, borderW, 0, rs_notify_border_size, h, Color(0, 0, 255, 255 * 0.6 - rs_notify_red_alpha * 0.6))
end

local function renderRSGradient(w, h, borderW)
	local size = 100 - math.abs(math.sin(RealTime())) * 60
	local alpha = math.abs(math.sin(RealTime() * 3)) * 30

	Arbitrage.DrawGradient(GRADIENT_RIGHT, borderW - size, 0, size, h, Color(255, 0, 0, 10 + alpha))
	Arbitrage.DrawGradient(GRADIENT_LEFT, borderW, 0, size, h, Color(0, 0, 255, 10 + alpha))
end

local rs_divider_count = 15
local rs_divider_rightMat = Material("danganronpa/law/rs/divider_right.png")
local rs_divider_leftMat = Material("danganronpa/law/rs/divider_left.png")
local function renderRSDivider(w, h, borderW)
	surface.SetDrawColor(255, 237, 171)
	surface.DrawRect(borderW - 2, 0, 4, h)

	local rs_divider_speed = RealTime() * 100
	local rs_divider_size = h / rs_divider_count

	for i = 0, rs_divider_count do
		local position = rs_divider_size * i + rs_divider_speed % h - rs_divider_size
		if position > h then
			position = position - h - rs_divider_size
		end

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(rs_divider_rightMat)
		surface.DrawTexturedRect(borderW - rs_divider_size - 2, position, rs_divider_size, rs_divider_size)
	end

	for i = 0, rs_divider_count do
		local position = rs_divider_size * i - rs_divider_speed % h - rs_divider_size
		if position < -rs_divider_size then
			position = position + h + rs_divider_size
		end

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(rs_divider_leftMat)
		surface.DrawTexturedRect(borderW + 2, position, rs_divider_size, rs_divider_size)
	end
end

local rs_cylinderMat = Material("danganronpa/law/rs/cylinder.png")
local function renderRSCylinder(w, h)
	local rs_cylinder_size = w * 0.104

	local center = Vector(w / 2, h / 1.95)
	local m = Matrix()
	m:Translate(center)
	m:Rotate(Angle( 0, -50, 0 ))
	m:Scale(Vector(0.9, 1.5, 1))
	m:Translate(-center)

	cam.PushModelMatrix(m)
	    surface.SetDrawColor(255, 61, 96, 200)
	    surface.SetMaterial(rs_cylinderMat)
	    surface.DrawTexturedRectRotated(w * 0.052, h * 0.29, rs_cylinder_size, rs_cylinder_size, -CurTime() % 360 * 10)
	cam.PopModelMatrix()
end

local rs_size_mask = ScrH() * 1.4
local rs_sizeW_mask, rs_sizeH_mask = rs_size_mask / 2, rs_size_mask
local function createMask(id, mat)
	local mask = BMASKS.CreateMask(id, mat)
	local stored = {}
	for i = 1, 2 do stored[i] = rs_sizeW_mask * (i - 1) end

	return mask, stored
end

local rs_mask_left, rs_stored_left = createMask("maskLeft", "danganronpa/law/rs/hr_frame_mask_left.png")
local rs_mask_right, rs_stored_right = createMask("maskRight", "danganronpa/law/rs/hr_frame_mask_right.png")
local function drawingMask(x, mask, stored, speed, mat, isRight)
	BMASKS.BeginMask(mask)
		for k, v in ipairs(stored) do
			stored[k] = v - speed

			if stored[k] < -rs_sizeH_mask * 0.33 then
				stored[k] = stored[k] + rs_sizeH_mask
			end

			surface.SetMaterial(mat)
			surface.DrawTexturedRectRotated(stored[k] + (isRight and ScrW() - (rs_sizeW_mask / 2) or 0), ScrH() / 2, rs_sizeW_mask, rs_sizeH_mask, 10)
		end
	BMASKS.EndMask(mask, x, 0, rs_size_mask, ScrH(), 140)
end

local rs_frame_ptn_red = Material("danganronpa/law/rs/hr_frame_ptn_red.png")
local rs_frame_ptn_blue = Material("danganronpa/law/rs/hr_frame_ptn_blue.png")
local function renderRSMask()
	surface.SetDrawColor(255, 255, 255, 255)

	local speed = FrameTime() * 50

	drawingMask(0, rs_mask_left, rs_stored_left, speed, rs_frame_ptn_red)
	drawingMask(-rs_size_mask + ScrW(), rs_mask_right, rs_stored_right, speed, rs_frame_ptn_blue, true)
end


local function viewPlayer(data)
	data.camPos, data.angles, data.fov, data.entity = PLUGIN.CamAnimData[data.animID](
	    data.camPos,
	    data.angles,
	    data.fov,
	    data.entity,
	    data.animID,
	    data.oldanimID
	)

	data.oldanimID = data.animID

	local view = {
		x = 0,
		y = 0,
		w = ScrW(),
		h = ScrH(),
		origin = data.camPos,
		fov = data.fov - 15,
		angles = data.angles
	}

	return view
end

local function createTex(id)
	local tex = GetRenderTarget("RebuttalShowdowns_" .. id .. "_" .. CurTime(), ScrW(), ScrH())
	local mat = CreateMaterial("RebuttalShowdowns_" .. id .. "_" .. CurTime(), "UnlitGeneric", {["$basetexture"] = ""})

	return tex, mat
end

local function createPlayerInfo(client)
	local pos = PLUGIN:GetClientPos(client)
	local WPos = client:LocalToWorld(Vector(0, 0, 0))
	Ang = WPos - pos
	Ang = Ang:Angle()

	local info = {
		fov = 90,
		camPos = pos,
		angles = Angle(0, Ang[2] + 90, 0),
		animID = 1,
		oldanimID = -1,
		rotate = 90,
		entity = client
	}

	return info
end

local a = false
local b = false

function PANEL:CheckerPlayers(client1, client2)
	if !IsValid(client1) or !IsValid(client2) then
		self:Remove()
	end
end

function PANEL:CreatePlayersPanel(client1, client2)
	self.client1 = client1
	self.client2 = client2

	self:CheckerPlayers(self.client1, self.client2)

	local redTex, redMat = createTex("red")
	local blueTex, blueMat = createTex("blue")

	self.players = {
		[client1] = createPlayerInfo(client1),
		[client2] = createPlayerInfo(client2)
	}

	self.PlayersPanel = self:Add("Panel")
	self.PlayersPanel:SetPos(0, 0)
	self.PlayersPanel:SetSize(ScrW(), ScrH())
	self.PlayersPanel.Paint = function(this, w, h)
		do
			local view = viewPlayer(self.players[client1])
			view.znear = b
			view.zfar = a
			render.SetRenderTarget(redTex)
				render.RenderView(view)

				render.CopyRenderTargetToTexture(self.redScreenEffect)
				for k, v in pairs(RedColorModify) do
					self.redColorMod:SetFloat(k, v)
				end

				surface.SetMaterial(self.redColorMod)
				surface.DrawTexturedRect(0, 0, w, h)
			render.SetRenderTarget()

			redMat:SetTexture("$basetexture", redTex)
		end

		do
			local view = viewPlayer(self.players[client2])

			render.SetRenderTarget(blueTex)
				render.RenderView(view)

				render.CopyRenderTargetToTexture(self.blueScreenEffect)
				for k, v in pairs(BlueColorModify) do
					self.blueColorMod:SetFloat(k, v)
				end

				surface.SetMaterial(self.blueColorMod)
				surface.DrawTexturedRect(0, 0, w, h)
			render.SetRenderTarget()

			blueMat:SetTexture("$basetexture", blueTex)
		end

		local RedBarderX, RedBarderY, RedBorderW, RedBorderH = 0, 0, w / 2 + w * self.size, h
		asterionlib.DrawRender(function()
			surface.SetDrawColor(255, 255, 255)
			surface.DrawRect(RedBarderX, RedBarderY, RedBorderW, RedBorderH)
		end, function()
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(redMat)
			surface.DrawTexturedRect(-w * 0.25 + (w * self.size) / 2, 0, w, h)
		end)

		local BlueBarderX, BlueBarderY, BlueBarderW, BlueBarderH = w / 2 + w * self.size, 0, w / 2 - w * self.size, h
		asterionlib.DrawRender(function()
			surface.SetDrawColor(255, 255, 255)
			surface.DrawRect(BlueBarderX, BlueBarderY, BlueBarderW, BlueBarderH)
		end, function()
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(blueMat)
			surface.DrawTexturedRect(w * 0.25 + (w * self.size) / 2, 0, w, h)
		end)

		renderRSGradient(w, h, RedBorderW)
		renderRSCylinder(w, h)
		renderRSMask()
		renderRSNotify(w, h, RedBorderW, self.size)
		renderRSDivider(w, h, RedBorderW)
	end

	timer.Simple(2, function()
		self:Intro()
	end)
end

local function drawMaterial(mat, matBlur, matOutline, size, alpha, padding, color)
	local sizeW, sizeH = size, size * 0.3
	padding = padding * sizeH

	local x, y, w, h = ScrW() / 2 - size / 2, ScrH() / 2 - sizeH / 2 + padding, sizeW, sizeH

	surface.SetDrawColor(60, 79, 255, alpha * 0.3)
	surface.SetMaterial(matBlur)
	surface.DrawTexturedRect(x, y, w, h)

	surface.SetDrawColor(color.r, color.g, color.b, alpha)
	surface.SetMaterial(mat)
	surface.DrawTexturedRect(x, y, w, h)

	surface.SetDrawColor(255, 255, 255, alpha)
	surface.SetMaterial(matOutline)
	surface.DrawTexturedRect(x, y, w, h)
end

local rs_text1Mat = Material("danganronpa/law/rs/text1.png")
local rs_text1_blurMat = Material("danganronpa/law/rs/text1_blur.png")
local rs_text1_outlineMat = Material("danganronpa/law/rs/text1_outline.png")

local rs_text2Mat = Material("danganronpa/law/rs/text2.png")
local rs_text2_blurMat = Material("danganronpa/law/rs/text2_blur.png")
local rs_text2_outlineMat = Material("danganronpa/law/rs/text2_outline.png")
function PANEL:Intro()
	local rs_textSize = ScrH() * 0.9

	local rs_text1Alpha, rs_text1Size = nil, nil
	timer.Simple(0.8, function()
		rs_text1Alpha = asterionlib.Tween(0, 255, 1, "inOutQuart")
		rs_text1Size = asterionlib.Tween(rs_textSize * 10, rs_textSize, 0.6, "outBack")
	end)

	local rs_text2Alpha, rs_text2Size = nil, nil
	timer.Simple(1.5, function()
		rs_text2Alpha = asterionlib.Tween(0, 255, 1, "inOutQuart")
		rs_text2Size = asterionlib.Tween(rs_textSize * 10, rs_textSize, 0.6, "outBack")
	end)

	local rs_text_r, rs_text_g, rs_text_b, rs_text_padding = nil, nil, nil, nil
	timer.Simple(3, function()
		local time = 0.3

		rs_text_r = asterionlib.Tween(0, 149, time, "inOutQuart")
		rs_text_g = asterionlib.Tween(0, 255, time, "inOutQuart")
		rs_text_b = asterionlib.Tween(0, 251, time, "inOutQuart")

		rs_text_padding = asterionlib.Tween(0, 0.05, time * 0.23, "inQuad", function()
			rs_text_padding = asterionlib.Tween(0.05, 0, time * 0.23, "outQuad", function()
				rs_text1Alpha = asterionlib.Tween(255, 0, 1, "inOutQuart")
				rs_text2Alpha = asterionlib.Tween(255, 0, 1, "inOutQuart")

				timer.Simple(0.5, function()
					if IsValid(self.intro) then
						self.intro:AlphaTo(0, 0.8, 0, function()
							self.intro:Remove()
						end)
					end
				end)
			end)
		end)
	end)


	self.intro = self:Add("DPanel")
	self.intro:SetPos(0, 0)
	self.intro:SetSize(ScrW(), ScrH())
	self.intro.Paint = function(_, w, h)
		local _rs_text_r = rs_text_r and rs_text_r:Render() or 0
		local _rs_text_g = rs_text_g and rs_text_g:Render() or 0
		local _rs_text_b = rs_text_b and rs_text_b:Render() or 0
		local _rs_text_padding = rs_text_padding and rs_text_padding:Render() or 0

		local _rs_text1Alpha = rs_text1Alpha and rs_text1Alpha:Render()
		local _rs_text1Size = rs_text1Size and rs_text1Size:Render()

		local _rs_text2Alpha = rs_text2Alpha and rs_text2Alpha:Render()
		local _rs_text2Size = rs_text2Size and rs_text2Size:Render()

		local cylinder_size = h * 0.9
		local rotate_speed = RealTime() * 50

		surface.SetDrawColor(0, 0, 0, 220)
		surface.DrawRect(0, 0, w, h)

		surface.SetDrawColor(255, 118, 82, 150)
		surface.SetMaterial(rs_cylinderMat)
		surface.DrawTexturedRectRotated(cylinder_size * 0.1, -cylinder_size * 0.1, cylinder_size, cylinder_size, rotate_speed)

		surface.SetDrawColor(7, 59, 200, 150)
		surface.SetMaterial(rs_cylinderMat)
		surface.DrawTexturedRectRotated(w - cylinder_size * 0.1, h + cylinder_size * 0.1, cylinder_size, cylinder_size, rotate_speed)

		local _rs_color = Color(_rs_text_r, _rs_text_g, _rs_text_b)

		if _rs_text1Size and _rs_text1Alpha then
			drawMaterial(rs_text1Mat, rs_text1_blurMat, rs_text1_outlineMat, _rs_text1Size, _rs_text1Alpha, -0.4 - _rs_text_padding, _rs_color)
		end

		if _rs_text2Size and _rs_text2Alpha then
			drawMaterial(rs_text2Mat, rs_text2_blurMat, rs_text2_outlineMat, _rs_text2Size, _rs_text2Alpha, 0.4 - _rs_text_padding, _rs_color)
		end
	end

	self.intro:SetAlpha(0)
	self.intro:AlphaTo(255, 0.5)
end

function PANEL:Paint(w, h)
	--self.size = math.sin(CurTime()) * 0.4
	self.size = Lerp(FrameTime(), self.size, GetNetVar("rc_size", 0) * 0.5)

	surface.SetDrawColor(0, 0, 0)
	surface.DrawRect(0, 0, w, h)

	self:CheckerPlayers(self.client1, self.client2)
end

vgui.Register("arb.RebuttalShowdowns", PANEL, "EditablePanel")