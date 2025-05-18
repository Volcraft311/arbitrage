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

local PLUGIN = PLUGIN

local RADIAL_CONFIG = {
	SOUNDS = {
		OPEN = {"academy/radialmenu/whoosh%d.wav", 1, 6},
		CLOSE = {"academy/radialmenu/whoosh%d.wav", 1, 6},
		SELECT = "academy/radialmenu/press.wav",
		HOVER = "academy/radialmenu/rollover.wav"
	},

	MATERIALS = {
		CIRCLE_BLUR = "asterion/academy/ui/radial/circle_blur.png",
		SCREEN = "asterion/academy/ui/radial/screen.png",
		ARROW = "asterion/academy/ui/radial/arrow.png",
		GRADIENT = "asterion/academy/ui/radial/gradient_select.png",
		FILL_BLUR = "asterion/academy/ui/radial/fill_blur.png",
		MOUSE = {
			AMB = "asterion/academy/ui/radial/m_mouse.png",
			LMB = "asterion/academy/ui/radial/l_mouse.png",
			RMB = "asterion/academy/ui/radial/r_mouse.png"
		},
		STAR = "asterion/academy/ui/radial/favorite.png"
	},

	COLORS = {
		BLACK = Color(0, 0, 0),
		WHITE = Color(255, 255, 255)
	},

	DEFAULTS = {
		RADIAL_SIZE_MULTIPLIER = 0.28,
		INITIAL_SIZE = 80,
		FADE_TIME = 0.5,
		CAMERA = {
			POSITION = Vector(80, 0, 35),
			ANGLE = Angle(0, 180, 0),
			FOV = 30
		}
	}
}

local Lerp = Lerp
local LerpAngle = function(a, b, t)
	local delta = (b - a) % 360

	if delta > 180 then
		delta = delta - 360
	end

	return a + delta * t
end
local IsValid = IsValid
local RealTime = RealTime
local FrameTime = FrameTime
local math = math
local surface = surface
local render = render
local cam = cam
local input = input
local draw = draw
local vgui = vgui
local ipairs = ipairs
local pairs = pairs
local table = table

local math_floor = math.floor
local math_random = math.random
local math_rad = math.rad
local math_deg = math.deg
local math_cos = math.cos
local math_sin = math.sin
local math_atan2 = math.atan2

local ColorAlpha = ColorAlpha
local ScrW = ScrW
local ScrH = ScrH
local Angle = Angle
local Vector = Vector
local Material = Material

local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_DrawTexturedRectRotated = surface.DrawTexturedRectRotated

local render_SuppressEngineLighting = render.SuppressEngineLighting
local render_SetLightingOrigin = render.SetLightingOrigin
local render_SetModelLighting = render.SetModelLighting
local render_ResetModelLighting = render.ResetModelLighting
local render_SetColorModulation = render.SetColorModulation

local cam_Start3D = cam.Start3D
local cam_End3D = cam.End3D

local input_GetCursorPos = input.GetCursorPos
local input_SetCursorPos = input.SetCursorPos
local input_IsMouseDown = input.IsMouseDown
local input_IsKeyDown = input.IsKeyDown

local draw_SimpleText = draw.SimpleText
local draw_GetFontHeight = draw.GetFontHeight

local table_remove = table.remove

local vgui_Register = vgui.Register

local circles = asterionlib.Circles
local CIRCLE_FILLED = CIRCLE_FILLED

local circle_blurMat = Material(RADIAL_CONFIG.MATERIALS.CIRCLE_BLUR)
local screenMat = Material(RADIAL_CONFIG.MATERIALS.SCREEN)
local arrowMat = Material(RADIAL_CONFIG.MATERIALS.ARROW)
local gradient_selectMat = Material(RADIAL_CONFIG.MATERIALS.GRADIENT)
local fill_blurMat = Material(RADIAL_CONFIG.MATERIALS.FILL_BLUR)
local ambMat = Material(RADIAL_CONFIG.MATERIALS.MOUSE.AMB)
local lmbMat = Material(RADIAL_CONFIG.MATERIALS.MOUSE.LMB)
local rmbMat = Material(RADIAL_CONFIG.MATERIALS.MOUSE.RMB)
local starMat = Material(RADIAL_CONFIG.MATERIALS.STAR)

local PANEL = {}

function PANEL:Init()
	if IsValid(Arbitrage.gui.radialmenu) then
		Arbitrage.gui.radialmenu:Remove()
	end

	Arbitrage.gui.radialmenu = self

	self:PlaySound(RADIAL_CONFIG.SOUNDS.OPEN)

	self:SetPos(0, 0)
	self:SetSize(ScrW(), ScrH())
	self:MakePopup()
	self:SetAlpha(0)
	self:AlphaTo(255, RADIAL_CONFIG.DEFAULTS.FADE_TIME)
	self:SetKeyboardInputEnabled(false)

	self.options = {}
	self.clampKeys = {}

	self:InitializeDimensions()
	self:InitializeCharacterModel()
	self:InitializeBackground()
end

function PANEL:InitializeDimensions()
	self.panelWide = self:GetWide()
	self.panelTall = self:GetTall()

	self.centerX = self.panelWide / 2
	self.centerY = self.panelTall / 2
	self.radialSize = self.panelTall * RADIAL_CONFIG.DEFAULTS.RADIAL_SIZE_MULTIPLIER

	self.size = RADIAL_CONFIG.DEFAULTS.INITIAL_SIZE
	self.angleDegrees = 0
	self.angleGradient = 0
	self.selSize = 2
	self.textAlpha = 0

	self.cameraPosition = RADIAL_CONFIG.DEFAULTS.CAMERA.POSITION
	self.cameraAngle = RADIAL_CONFIG.DEFAULTS.CAMERA.ANGLE
	self.cameraFov = RADIAL_CONFIG.DEFAULTS.CAMERA.FOV

	self.ambMatAlpha = 0
	self.rmbMatAlpha = 0
end

function PANEL:InitializeCharacterModel()
	local client = LocalPlayer()

	self.activeCharacter = ClientsideModel(client:GetModel())
	self.activeCharacter:SetSkin(client:GetSkin())
	self.activeCharacter:SetRenderMode(client:GetRenderMode())
	self.activeCharacter:SetColor(client:GetColor())
	self.activeCharacter:SetMaterial(client:GetMaterial())
	self.activeCharacter:SetNoDraw(true)
	self.activeCharacter:SetAngles(Angle(0, -20, 0))
	self.activeCharacter:SetFlexScale(client:GetFlexScale())
	self.activeCharacter.upPosition = 0
	self.activeCharacter.childrens = {}

	for _, v in ipairs(client:GetBodyGroups() or {}) do
		local bodygroup = client:GetBodygroup(v.id)

		if bodygroup > 0 then
			self.activeCharacter:SetBodygroup(v.id, bodygroup)
		end
	end

	for k, v in ipairs(client:GetMaterials() or {}) do
		local mat = client:GetSubMaterial(k - 1)

		if mat and mat != "" then
			self.activeCharacter:SetSubMaterial(k - 1, mat)
		end
	end

	self:InitializeCompositeEntities(client)

	self.boneCharacter = ClientsideModel(client:GetModel())
	self.boneCharacter:SetNoDraw(true)
end

function PANEL:InitializeCompositeEntities(client)
	local composites = CompositeEntities and CompositeEntities.GetArrayEntitites(client) or {}

	for _, v in ipairs(composites) do
		local composite = ClientsideModel(v.model)
		composite:SetSkin(v.Skin)
		composite:SetMaterial(v.Material)
		composite:SetRenderMode(v.RenderMode)
		composite:SetColor(v.Color)

		for k2, v2 in pairs(v.BodyG) do
			composite:SetBodygroup(k2, v2)
		end

		for k2, v2 in pairs(v.SubMat) do
			composite:SetSubMaterial(k2, v2)
		end

		if v.BoneManip then
			for i = 0, composite:GetBoneCount() do
				local t = v.BoneManip[i]

				if t then
					if t.s then
						composite:ManipulateBoneScale(i, t.s)
					end

					if t.a then
						composite:ManipulateBoneAngles(i, t.a)
					end

					if t.p then
						composite:ManipulateBonePosition(i, t.p)
					end
				end
			end
		end

		if v.mode == 0 or v.mode == nil then
			if composite:IsEffectActive(EF_BONEMERGE) then
				composite:Remove()
				continue
			end

			composite:SetParent(self.activeCharacter)
			composite:RemoveEffects(EF_FOLLOWBONE)
			composite:RemoveEffects(EF_PARENT_ANIMATES)
			composite:AddEffects(EF_BONEMERGE)
		else
			if v.boneName then
				local boneID = self.activeCharacter:LookupBone(v.boneName)
				if !boneID then
					composite:Remove()
					continue
				end

				if !composite:IsEffectActive(EF_BONEMERGE) and composite:GetParentAttachment() == boneID then
					composite:Remove()
					continue
				end

				composite:SetParent(self.activeCharacter, boneID)
				composite:RemoveEffects(EF_BONEMERGE)
				composite:AddEffects(EF_FOLLOWBONE)
				composite:AddEffects(EF_PARENT_ANIMATES)
			end
		end

		composite:SetLocalPos(v.localPos)
		composite:SetLocalAngles(v.localAng)
		composite:SetModelScale(v.modelScale)
		composite:SetNoDraw(true)

		self.activeCharacter.childrens[#self.activeCharacter.childrens + 1] = composite
	end
end

function PANEL:InitializeBackground()
	self.background_blur = circles.New(CIRCLE_FILLED, self.panelWide + self.size, self.centerX, self.centerY, self.size * 2)

	self.background_blur:SetMaterial(circle_blurMat)
	self.background_blur:SetColor(RADIAL_CONFIG.COLORS.WHITE)
end

function PANEL:PlaySound(soundData)
	if istable(soundData) then
		local pattern, min, max = unpack(soundData)

		asterionlib.EmitSound(pattern:format(math_random(min, max)))
	else
		asterionlib.EmitSound(soundData)
	end
end

function PANEL:FindSelected(segment_size)
	local mouseX, mouseY = input_GetCursorPos()
	local deltaX = mouseX - self.centerX
	local deltaY = mouseY - self.centerY
	local angleRadians = math_atan2(deltaY, deltaX)

	local mouse_ang = angleRadians * 180 / math.pi
	if mouse_ang < 0 then
		mouse_ang = 360 + mouse_ang
	end

	return math_floor(mouse_ang / segment_size)
end

function PANEL:NewClose()
	if self.bClose then return end
	self.bClose = true

	self:PlaySound(RADIAL_CONFIG.SOUNDS.CLOSE)

	if IsValid(self.activeCharacter) then
		for _, v in ipairs(self.activeCharacter.childrens) do
			if IsValid(v) then
				v:Remove()
			end
		end

		self.activeCharacter:Remove()
	end

	if IsValid(self.boneCharacter) then
		self.boneCharacter:Remove()
	end

	self:SetMouseInputEnabled(false)
	self:AlphaTo(0, 0.3, 0, function()
		self:Remove()

		PLUGIN.clampingTime = RealTime()
		PLUGIN.isClose = false
	end)

	PLUGIN.isClose = true
end

function PANEL:SelectOption(id)
	local option = self.options[id]
	if !option then return end

	local segment_size = 360 / #self.options
	local rad = math_rad(segment_size * (id - 1) + segment_size / 2)

	local x = self.centerX + math_cos(rad) * self.panelWide
	local y = self.centerY + math_sin(rad) * self.panelWide

	local action = option.action
	if isfunction(action) then
		self:PlaySound(RADIAL_CONFIG.SOUNDS.SELECT)

		local info, backFunc = action(PLUGIN, self)

		if istable(info) then
			self.options = info
			self.panelWide = self.panelWide + 50
			self.selSize = self.selSize + 20
			self.textAlpha = 0
			self.backFunc = backFunc
		else
			self:NewClose()
		end
	end

	return x, y
end

function PANEL:OnLeftClick()
	if self.bClose then return end
	if !self.selected then return end

	self:SelectOption(self.selected + 1)
end

function PANEL:OnRightClick()
	if self.bClose then return end

	if self.backFunc and isfunction(self.backFunc) then
		local info, backFunc = self.backFunc(PLUGIN, self)

		if istable(info) then
			self.options = info
			self.panelWide = self.panelWide + 50
			self.selSize = self.selSize + 20
			self.textAlpha = 0
			self.backFunc = backFunc

			self:PlaySound(RADIAL_CONFIG.SOUNDS.SELECT)
		end
	else
		self:NewClose()
	end
end

function PANEL:OnMiddleClick()
	if self.bClose then return end
	if !self.selected then return end

	local option = self.options[self.selected + 1]
	if !option or !option.id then return end

	local data = asterionlib.data:Get("radialmenu_favorites", {})
	local find = nil

	for k, v in ipairs(data) do
		if option.id == v then
			find = k

			break
		end
	end

	if find then
		table_remove(data, find)
	else
		data[#data + 1] = option.id
	end

	asterionlib.data:Set("radialmenu_favorites", data)
end

function PANEL:OnRotate()
	self.panelWide = self.panelWide + 8
	self.selSize = self.selSize + 8
	self.textAlpha = 0

	self:PlaySound(RADIAL_CONFIG.SOUNDS.HOVER)
end

function PANEL:Think()
	self:HandleMouseInput()

	self:HandleKeyboardInput()
end

function PANEL:HandleMouseInput()
	local onLeftClick = input_IsMouseDown(MOUSE_LEFT)
	if onLeftClick then
		if !self.bLeftClick then
			self:OnLeftClick()
		end

		self.bLeftClick = true
	else
		self.bLeftClick = nil
	end

	local onRightClick = input_IsMouseDown(MOUSE_RIGHT)
	if onRightClick then
		if !self.bRightClick then
			self:OnRightClick()
		end

		self.bRightClick = true
	else
		self.bRightClick = nil
	end

	local onMiddleClick = input_IsMouseDown(MOUSE_MIDDLE)
	if onMiddleClick then
		if !self.bMiddleClick then
			self:OnMiddleClick()
		end

		self.bMiddleClick = true
	else
		self.bMiddleClick = nil
	end
end

function PANEL:HandleKeyboardInput()
	local data = {}
	for i = 1, 9 do data[#data + 1] = i end -- Numbers 1-9
	for i = 37, 46 do data[#data + 1] = i end -- Numpad 1-9

	for k, i in ipairs(data) do
		local onDown = input_IsKeyDown(i + 1)

		if onDown then
			if !self.clampKeys[i] then
				if self.bClose then return end
				if !self.selected then return end

				local info = k < 10 and i or i - 36
				local x, y = self:SelectOption(info)

				if x and y then
					input_SetCursorPos(x, y)
				end
			end

			self.clampKeys[i] = true
		else
			self.clampKeys[i] = nil
		end
	end
end

function PANEL:EntityLighting()
	render_SuppressEngineLighting(true)
	render_SetLightingOrigin(self.activeCharacter:GetPos())
	render_ResetModelLighting(120 / 255, 120 / 255, 120 / 255)
	render_SetColorModulation(1, 0.855, 0.855)

	render_SetModelLighting(0, 1.5, 1.5, 1.5)

	for i = 1, 4 do
		render_SetModelLighting(i, 0.4, 0.4, 0.4)
	end

	render_SetModelLighting(5, 0.04, 0.04, 0.04)
	render_SetModelLighting(4, 5, 0, 0)
end

function PANEL:EntityDisableIK()
	self.activeCharacter:SetIK(false)
	self.boneCharacter:SetIK(false)
end

function PANEL:OnEntityDraw()
	local ft = FrameTime()

	if self.facial then
		for i = 0, self.activeCharacter:GetFlexNum() - 1 do
			self.activeCharacter:SetFlexWeight(i, self.facial[i] or 0)
		end
	else
		for i = 0, self.activeCharacter:GetFlexNum() - 1 do
			self.activeCharacter:SetFlexWeight(i, LocalPlayer():GetFlexWeight(i))
		end
	end

	local boneIdx = self.boneCharacter:LookupBone(self.cameraBone or "ValveBiped.Bip01_Spine")
	local bonePos = self.boneCharacter:GetBonePosition(boneIdx)

	if bonePos then
		local targetPos = 32 - bonePos.z - (self.cameraBone and 0 or 10)

		self.activeCharacter.upPosition = Lerp(ft * 15, self.activeCharacter.upPosition, targetPos)
	end

	self.activeCharacter:FrameAdvance()
	self.activeCharacter:SetPos(Vector(0, 1.25, self.activeCharacter.upPosition))
	self.activeCharacter:DrawModel()

	for _, v in ipairs(self.activeCharacter.childrens) do
		if IsValid(v) then
			v:DrawModel()
		end
	end
end

function PANEL:OnChangeSequence(sequence)
	self.activeCharacter:ResetSequence(sequence)
	self.boneCharacter:ResetSequence(sequence)

	self.activeCharacter:SetAngles(Angle(0, -20, 0))
	self.activeCharacter:SetCycle(0)
	self.activeCharacter:SetPlaybackRate(1)
end

function PANEL:Paint(w, h)
	local ft = FrameTime()

	self.panelWide = Lerp(ft * (self.bClose and 2 or 15), self.panelWide, self.bClose and self:GetWide() / 2 or self.radialSize)
	self.selSize = Lerp(ft * 10, self.selSize, 2)
	self.textAlpha = Lerp(ft * 7, self.textAlpha, 256)

	local segment_size = 360 / #self.options
	self.selected = self.selected or nil

	if !self.bClose then
		self.selected = self:FindSelected(segment_size)
	end

	if !self.selected then return end

	self.rotate = self.rotate or self.selected * segment_size
	self.rotate = LerpAngle(self.rotate, self.selected * segment_size, ft * 20)
	self.oldselected = self.oldselected or self.selected

	self:DrawBackground(w, h)

	cam_Start3D(self.cameraPosition, self.cameraAngle, self.cameraFov, 0, 0, w, h)
		if IsValid(self.activeCharacter) and IsValid(self.boneCharacter) then
			self:EntityLighting()
			self:EntityDisableIK()

			if self.sequence then
				self.cameraFov = Lerp(ft * 15, self.cameraFov, self.cameraBone and 25 or 45)

				local idx = self.activeCharacter:LookupSequence(self.sequence)
				if self.activeCharacter:GetSequence() != idx then
					self:OnChangeSequence(idx)
				end

				self:OnEntityDraw()
			end

			render_SuppressEngineLighting(false)
		end
	cam_End3D()

	self:DrawRadialElements(w, h)

	if self.selected != self.oldselected then
		self:OnRotate()
	end

	self.oldselected = self.selected
end

function PANEL:DrawBackground(w, h)
	asterionlib.DrawBlur(self, 3)

	surface_SetDrawColor(0, 0, 0, 160)
	surface_DrawRect(0, 0, w, h)

	surface_SetDrawColor(255, 255, 255, 255)
	surface_SetMaterial(screenMat)
	surface_DrawTexturedRect(0, 0, w, h)

	self.background_blur:SetRadius(self.panelWide + self.size + 75)
	self.background_blur()
end

function PANEL:DrawRadialElements(w, h)
	local ft = FrameTime()

	self:CalculateCursorAngle()
	self:DrawSelectionGradient(w, h)
	self:DrawCursorArrow(w, h)
	self:DrawMenuOptions(w, h, ft)
	self:DrawSelectedOptionInfo(w, h, ft)
	self:DrawControlHints(w, h, ft)
end

function PANEL:CalculateCursorAngle()
	local mouseX, mouseY = input_GetCursorPos()
	local deltaX = mouseX - self.centerX
	local deltaY = mouseY - self.centerY
	local angleRadians = math_atan2(deltaY, deltaX)
	local angleDegrees = math_deg(angleRadians)

	self.angleDegrees = LerpAngle(self.angleDegrees, angleDegrees, FrameTime() * 10)
end

function PANEL:DrawSelectionGradient(w, h)
	local option = self.options[self.selected + 1]
	if !option then return end

	local segment_size = 360 / #self.options
	local a = math_rad(segment_size * self.selected + segment_size / 2)
	local x = self.centerX + math_cos(a) * self.panelWide
	local y = self.centerY + math_sin(a) * self.panelWide

	local deltaX = x - self.centerX
	local deltaY = y - self.centerY
	local angleRadians = math_atan2(deltaY, deltaX)
	local angleDegrees = math_deg(angleRadians)

	self.angleGradient = angleDegrees

	local informationColor = Arbitrage.theme:GetInformation()

	local size_gradient = (self.panelWide + self.size) * 2 + 5
	surface_SetDrawColor(informationColor.r, informationColor.g, informationColor.b)
	surface_SetMaterial(gradient_selectMat)
	surface_DrawTexturedRectRotated(w / 2, h / 2, size_gradient, size_gradient, -self.angleGradient)
end

function PANEL:DrawCursorArrow(w, h)
	local size_arrow = self:GetTall() * 0.45

	surface_SetDrawColor(255, 255, 255)
	surface_SetMaterial(arrowMat)
	surface_DrawTexturedRectRotated(w / 2, h / 2, size_arrow, size_arrow, -self.angleDegrees)
end

function PANEL:DrawMenuOptions(w, h, ft)
	local segment_size = 360 / #self.options
	local data = asterionlib.data:Get("radialmenu_favorites", {})

	for i = 0, #self.options - 1 do
		local option = self.options[i + 1]
		local a = math_rad(segment_size * i + segment_size / 2)
		local x = self.centerX + math_cos(a) * self.panelWide
		local y = self.centerY + math_sin(a) * self.panelWide
		local color = Arbitrage.theme:GetInformation()

		option.fill_alpha = option.fill_alpha or 0
		option.fill_alpha = Lerp(ft * 20, option.fill_alpha, self.selected == i and 257 or -2)

		local size_fill = self:GetTall() * 0.055
		surface_SetDrawColor(255, 255, 255, option.fill_alpha)
		surface_SetMaterial(fill_blurMat)
		surface_DrawTexturedRect(x - size_fill, y - size_fill, size_fill * 2, size_fill * 2)

		if self.selected == i then
			color = RADIAL_CONFIG.COLORS.BLACK

			self.sequence = option.sequence
			self.weightedSequence = option.weightedSequence
			self.facial = option.facial
			self.cameraBone = option.cameraBone
		end

		if option.id then
			for _, v in ipairs(data) do
				if v == option.id then
					local size = self:GetTall() * 0.035
					surface_SetDrawColor(255, 255, 255)
					surface_SetMaterial(starMat)
					surface_DrawTexturedRect(x - size, y - size, size * 2, size * 2)

					break
				end
			end
		end

		if option.icon then
			option.iconNoColor = option.iconNoColor or option.icon:GetName():find("emojis/")

			local size = self:GetTall() * 0.03
			local iconColor = option.iconNoColor and RADIAL_CONFIG.COLORS.WHITE or color

			surface_SetDrawColor(iconColor)
			surface_SetMaterial(option.icon)
			surface_DrawTexturedRect(x - size, y - size, size * 2, size * 2)
		else
			draw_SimpleText(F(option.name), "arb.Font_FuturaPTBook_10", x, y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local informationColor = Arbitrage.theme:GetInformation()

		local b = self.panelWide * 0.8
		draw_SimpleText(i + 1, "arb.Font_FuturaPTDemi_5", self.centerX + math_cos(a) * b, self.centerY + math_sin(a) * b, informationColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function PANEL:DrawSelectedOptionInfo(w, h, ft)
	local option = self.options[self.selected + 1]
	if !option then return end

	local name = F(option.name)
	local description = F(option.description)
	local icon = option.icon

	local informationColor = Arbitrage.theme:GetInformation()

	if icon and !option.sequence then
		local size = self:GetTall() * 0.1

		surface_SetDrawColor(informationColor.r, informationColor.g, informationColor.b, self.textAlpha)
		surface_SetMaterial(icon)
		surface_DrawTexturedRect(w / 2 - size / 2, h / 2 - size / 2 - size * 0.7, size, size)
	end

	draw_SimpleText(name, "arb.Font_FuturaPTDemi_13", w / 2, h / 2, Color(informationColor.r, informationColor.g, informationColor.b, self.textAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	if description then
		local descFont = "arb.Font_FuturaPTBook_8"
		local fontHeight = draw_GetFontHeight(descFont)

		option.wrap = option.wrap or asterionlib.WrapText(description, self.radialSize, descFont)
		for k, v in ipairs(option.wrap) do
			draw_SimpleText(v, descFont, w / 2, h / 2 + k * fontHeight, ColorAlpha(RADIAL_CONFIG.COLORS.WHITE, self.textAlpha * 0.9), TEXT_ALIGN_CENTER)
		end
	end
end

function PANEL:DrawControlHints(w, h, ft)
	self:DrawLeftMouseHint(w, h)

	self.rmbMatAlpha = Lerp(ft * 10, self.rmbMatAlpha, isfunction(self.backFunc) and 1 or 0)
	if self.rmbMatAlpha > 0.025 then
		self:DrawRightMouseHint(w, h)
	end

	self.ambMatAlpha = Lerp(ft * 10, self.ambMatAlpha, (self.options[self.selected + 1] and self.options[self.selected + 1].id) and 1 or 0)
	if self.ambMatAlpha > 0.025 then
		self:DrawMiddleMouseHint(w, h)
	end
end

function PANEL:DrawLeftMouseHint(w, h)
	local _, height = draw_SimpleText(L("#radial_button_option"), "arb.Font_FuturaPTBook_8", w / 2 + (self.radialSize + self.size), h / 2 + (self.radialSize + self.size), RADIAL_CONFIG.COLORS.WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

	local iconW = height * 3.5
	local iconH = iconW * 0.3827
	surface_SetDrawColor(255, 255, 255)
	surface_SetMaterial(lmbMat)
	surface_DrawTexturedRect(w / 2 + (self.radialSize + self.size) - iconW / 2, h / 2 + (self.radialSize + self.size) - height - iconH, iconW, iconH)
end

function PANEL:DrawRightMouseHint(w, h)
	local _, height = draw_SimpleText(L("#radial_button_back"), "arb.Font_FuturaPTBook_8", w / 2 - (self.radialSize + self.size), h / 2 + (self.radialSize + self.size), ColorAlpha(RADIAL_CONFIG.COLORS.WHITE, self.rmbMatAlpha * 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

	local iconW = height * 3.5
	local iconH = iconW * 0.3827
	surface_SetDrawColor(255, 255, 255, self.rmbMatAlpha * 255)
	surface_SetMaterial(rmbMat)
	surface_DrawTexturedRect(w / 2 - (self.radialSize + self.size) - iconW / 2, h / 2 + (self.radialSize + self.size) - height - iconH, iconW, iconH)
end

function PANEL:DrawMiddleMouseHint(w, h)
	local _, height = draw_SimpleText(L("#radial_button_favorites"), "arb.Font_FuturaPTBook_8", w / 2, h / 2 - (self.radialSize + self.size) - 50, ColorAlpha(RADIAL_CONFIG.COLORS.WHITE, self.ambMatAlpha * 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

	local iconW = height * 3.5
	local iconH = iconW * 0.3827
	surface_SetDrawColor(255, 255, 255, self.ambMatAlpha * 255)
	surface_SetMaterial(ambMat)
	surface_DrawTexturedRect(w / 2 - iconW / 2, h / 2 - (self.radialSize + self.size) - 50 - height - iconH, iconW, iconH)
end

function PANEL:OnRemove()
	if IsValid(self.activeCharacter) then
		self.activeCharacter:Remove()
	end

	if IsValid(self.boneCharacter) then
		self.boneCharacter:Remove()
	end
end

vgui_Register("Radial:Menu", PANEL, "Panel")