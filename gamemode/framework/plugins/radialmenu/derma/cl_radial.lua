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

-- Localize Global Calls
local Angle = Angle
local ClientsideModel = ClientsideModel
local render_SuppressEngineLighting = render.SuppressEngineLighting
local render_SetLightingOrigin = render.SetLightingOrigin
local render_SetModelLighting = render.SetModelLighting
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local cam_Start3D = cam.Start3D
local cam_End3D = cam.End3D
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local input_GetCursorPos = input.GetCursorPos
local math_atan2 = math.atan2
local math_deg = math.deg
local surface_DrawTexturedRectRotated = surface.DrawTexturedRectRotated
local IsValid = IsValid
local math_random = math.random
local ScrW = ScrW
local ScrH = ScrH
local Color = Color
local Vector = Vector
local math_floor = math.floor
local RealTime = RealTime
local math_rad = math.rad
local math_cos = math.cos
local math_sin = math.sin
local isfunction = isfunction
local istable = istable
local ipairs = ipairs
local table_remove = table.remove
local table_insert = table.insert
local input_IsMouseDown = input.IsMouseDown
local input_IsKeyDown = input.IsKeyDown
local input_SetCursorPos = input.SetCursorPos
local Material = Material
local FrameTime = FrameTime
local Lerp = Lerp
local draw_SimpleText = draw.SimpleText
local ColorAlpha = ColorAlpha
local draw_GetFontHeight = draw.GetFontHeight
local vgui_Register = vgui.Register

local circles = asterionlib.Circles
local color_black = Color(0, 0, 0)
local color_red = Color(255, 41, 76)
local color_blur = Color(218, 19, 40)
local circle_blurMat = Material("asterion/academy/ui/radial/circle_blur.png")
local screenMat = Material("asterion/academy/ui/radial/screen.png")
local arrowMat = Material("asterion/academy/ui/radial/arrow.png")
local gradient_selectMat = Material("asterion/academy/ui/radial/gradient_select.png")
local fill_blurMat = Material("asterion/academy/ui/radial/fill_blur.png")

local PANEL = {}

function PANEL:Init()
	if IsValid(Arbitrage.gui.radialmenu) then
		Arbitrage.gui.radialmenu:Remove()
	end

	Arbitrage.gui.radialmenu = self

	asterionlib.EmitSound("academy/radialmenu/whoosh" .. math_random(1, 6) .. ".wav")

	self:SetPos(0, 0)
	self:SetSize(ScrW(), ScrH())
	self:MakePopup()
	self:SetAlpha(0)
	self:AlphaTo(255, 0.5)
	self:SetKeyboardInputEnabled(false)

	local client = LocalPlayer()

	self.options = {}
	self.clampKeys = {}

	self.panelWide = self:GetWide()
	self.panelTall = self:GetTall()

	self.centerX = self.panelWide / 2
	self.centerY = self.panelTall / 2
	self.radialSize = self.panelTall * 0.28

	self.size = 80
	self.angleDegrees = 0
	self.angleGradient = 0
	self.selSize = 2
	self.textAlpha = 0

	self.cameraPosition = Vector(80, 0, 35)
	self.cameraAngle = Angle(0, 180, 0)
	self.cameraFov = 30

	self.ambMatAlpha = 0
	self.rmbMatAlpha = 0

	self.activeCharacter = ClientsideModel(client:GetModel())
	self.activeCharacter:SetSkin(client:GetSkin())
	self.activeCharacter:SetRenderMode(client:GetRenderMode())
	self.activeCharacter:SetColor(client:GetColor())
	self.activeCharacter:SetMaterial(client:GetMaterial())
	self.activeCharacter:SetNoDraw(true)
	self.activeCharacter:SetAngles(Angle(0, -20, 0))
	self.activeCharacter.upPosition = 0
	self.activeCharacter.childrens = {}

	for k, v in ipairs(client:GetBodyGroups() or {}) do
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

	for k, v in ipairs(CompositeEntities and CompositeEntities.GetArrayEntitites(client) or {}) do
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
					local s = t.s
					local a = t.a
					local p = t.p

					if s then
						composite:ManipulateBoneScale(i, s)
					end

					if a then
						composite:ManipulateBoneAngles(i, a)
					end

					if p then
						composite:ManipulateBonePosition(i, p)
					end
				end
			end
		end

		if v.mode == 0 or v.mode == nil then
			if composite:IsEffectActive(EF_BONEMERGE) then
				return composite:Remove()
			end

			composite:SetParent(self.activeCharacter)

			composite:RemoveEffects(EF_FOLLOWBONE)
			composite:RemoveEffects(EF_PARENT_ANIMATES)

			composite:AddEffects(EF_BONEMERGE)
		else
			if v.boneName then
				local boneID = self.activeCharacter:LookupBone(v.boneName)
				if !boneID then
					return composite:Remove()
				end

				if !composite:IsEffectActive(EF_BONEMERGE) and composite:GetParentAttachment() == boneID then
					return composite:Remove()
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

	self.boneCharacter = ClientsideModel(client:GetModel())
	self.boneCharacter:SetNoDraw(true)

	self.background_blur = circles.New(CIRCLE_FILLED, self.panelWide + self.size, self.centerX, self.centerY, self.size * 2)
	self.background_blur:SetMaterial(circle_blurMat)
	self.background_blur:SetColor(color_white)

	self.mask = BMASKS.CreateMask("character_mask", "asterion/academy/ui/radial/gradient_character.png")
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

	asterionlib.EmitSound("academy/radialmenu/whoosh" .. math_random(1, 6) .. ".wav")

	if IsValid(self.activeCharacter) then
		for k, v in ipairs(self.activeCharacter.childrens) do
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
		asterionlib.EmitSound("academy/radialmenu/press.wav")
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
			asterionlib.EmitSound("academy/radialmenu/press.wav")
		end
	else
		self:NewClose()
	end
end

function PANEL:OnMiddleClick()
	if self.bClose then return end
	if !self.selected then return end

	local option = self.options[self.selected + 1]
	if !option then return end

	local id = option.id
	if !id then return end

	local data = asterionlib.data:Get("radialmenu_favorites", {})

	local find = nil
	for k, v in ipairs(data) do
		if id == v then
			find = k
		end
	end

	if find then
		table_remove(data, find)
	else
		table_insert(data, id)
	end

	asterionlib.data:Set("radialmenu_favorites", data)
end

function PANEL:OnRotate()
	self.panelWide = self.panelWide + 8
	self.selSize = self.selSize + 8
	self.textAlpha = 0

	asterionlib.EmitSound("academy/radialmenu/rollover.wav")
end

function PANEL:Think()
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

	local data = {}
	for i = 1, 9 do data[#data + 1] = i end
	for i = 37, 46 do data[#data + 1] = i end

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

	for i = 0, self.activeCharacter:GetFlexNum() - 1 do
		self.activeCharacter:SetFlexWeight(i, self.facial and self.facial[i] or 0)
	end

	local boneIdx = self.boneCharacter:LookupBone(self.cameraBone or "ValveBiped.Bip01_Spine")
	local bonePos = self.boneCharacter:GetBonePosition(boneIdx)
	if bonePos then
		self.activeCharacter.upPosition = Lerp(ft * 15, self.activeCharacter.upPosition, 32 - bonePos.z - (self.cameraBone and 0 or 10))
	end

	self.activeCharacter:FrameAdvance()
	self.activeCharacter:SetPos(Vector(0, 1.25, self.activeCharacter.upPosition))
	self.activeCharacter:DrawModel()

	for k, v in ipairs(self.activeCharacter.childrens) do
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

local function LerpA(a, b, t)
	local delta = (b - a) % 360

	if delta > 180 then
		delta = delta - 360
	end

	return a + delta * t
end

local ambMat = Material("asterion/academy/ui/radial/m_mouse.png")
local lmbMat = Material("asterion/academy/ui/radial/l_mouse.png")
local rmbMat = Material("asterion/academy/ui/radial/r_mouse.png")
local starMat = Material("icon16/star.png")

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
	self.rotate = LerpA(self.rotate, self.selected * segment_size, ft * 20)
	self.oldselected = self.oldselected or self.selected

	asterionlib.DrawBlur(self, 2)

	surface_SetDrawColor(0, 0, 0, 50)
	surface_DrawRect(0, 0, w, h)

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

	-- self.background_circle_blur:SetRadius(self.panelWide + self.size + 5)
	-- self.background_circle_blur()

	surface_SetDrawColor(0, 0, 0, 100)
	surface_DrawRect(0, 0, w, h)

	surface_SetDrawColor(255, 255, 255, 255)
	surface_SetMaterial(screenMat)
	surface_DrawTexturedRect(0, 0, w, h)

	self.background_blur:SetRadius(self.panelWide + self.size + 75)
	self.background_blur()

	do
		local mouseX, mouseY = input_GetCursorPos()
		local deltaX = mouseX - self.centerX
		local deltaY = mouseY - self.centerY
		local angleRadians = math_atan2(deltaY, deltaX)
		local angleDegrees = math_deg(angleRadians)
		self.angleDegrees = LerpA(self.angleDegrees, angleDegrees, ft * 10)
	end

	do
		local option = self.options[self.selected + 1]
		if option then
			local size = 360 / #self.options
			local a = math_rad(size * self.selected + size / 2)
			local x = self.centerX + math_cos(a) * self.panelWide
			local y = self.centerY + math_sin(a) * self.panelWide

			local deltaX = x - self.centerX
			local deltaY = y - self.centerY
			local angleRadians = math_atan2(deltaY, deltaX)
			local angleDegrees = math_deg(angleRadians)

			self.angleGradient = angleDegrees
		end
	end

	local size_arrow = self:GetTall() * 0.45
	surface_SetDrawColor(255, 255, 255)
	surface_SetMaterial(arrowMat)
	surface_DrawTexturedRectRotated(w / 2, h / 2, size_arrow, size_arrow, -self.angleDegrees)

	local size_gradient = (self.panelWide + self.size) * 2 + 5
	surface_SetDrawColor(color_blur)
	surface_SetMaterial(gradient_selectMat)
	surface_DrawTexturedRectRotated(w / 2, h / 2, size_gradient, size_gradient, -self.angleGradient)

	local data = asterionlib.data:Get("radialmenu_favorites", {})

	for i = 0, #self.options - 1 do
		local option = self.options[i + 1]

		local a = math_rad(segment_size * i + segment_size / 2)
		local x = self.centerX + math_cos(a) * self.panelWide
		local y = self.centerY + math_sin(a) * self.panelWide
		local color = color_blur

		option.fill_alpha = option.fill_alpha or 0
		option.fill_alpha = Lerp(ft * 20, option.fill_alpha, self.selected == i and 257 or -2)

		local size_fill = self:GetTall() * 0.055
		surface_SetDrawColor(255, 255, 255, option.fill_alpha)
		surface_SetMaterial(fill_blurMat)
		surface_DrawTexturedRect(x - size_fill, y - size_fill, size_fill * 2, size_fill * 2)

		if self.selected == i then
			color = color_black

			self.sequence = option.sequence
			self.weightedSequence = option.weightedSequence
			self.facial = option.facial
			self.cameraBone = option.cameraBone
		end

		if option.id then
			for k, v in ipairs(data) do
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
			local iconColor = option.iconNoColor and color_white or color

			surface_SetDrawColor(iconColor)
			surface_SetMaterial(option.icon)
			surface_DrawTexturedRect(x - size, y - size, size * 2, size * 2)
		else
			draw_SimpleText(option.name, "arb.Font_FuturaPTBook_10", x, y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		local b = self.panelWide * 0.8
		draw_SimpleText(i + 1, "arb.Font_FuturaPTDemi_5", self.centerX + math_cos(a) * b, self.centerY + math_sin(a) * b, color_red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local option = self.options[self.selected + 1]
	if option then
		local name = option.name
		local description = option.description
		local icon = option.icon

		if icon and !option.sequence then
			local size = self:GetTall() * 0.1

			surface_SetDrawColor(ColorAlpha(color_red, self.textAlpha))
			surface_SetMaterial(icon)
			surface_DrawTexturedRect(w / 2 - size / 2, h / 2 - size / 2 - size * 0.7, size, size)
		end

		draw_SimpleText(name, "arb.Font_FuturaPTDemi_13", w / 2, h / 2, ColorAlpha(color_blur, self.textAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if description then
			local descFont = "arb.Font_FuturaPTBook_8"
			local fontHeight = draw_GetFontHeight(descFont)
			option.wrap = option.wrap or asterionlib.WrapText(description, self.radialSize, descFont)

			for k, v in ipairs(option.wrap) do
				draw_SimpleText(v, descFont, w / 2, h / 2 + k * fontHeight, ColorAlpha(color_white, self.textAlpha * 0.9), TEXT_ALIGN_CENTER)
			end
		end
	end

	do
		local _, height = draw_SimpleText("Выбрать опцию", "arb.Font_FuturaPTBook_8", w / 2 + (self.radialSize + self.size), h / 2 + (self.radialSize + self.size), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

		local iconW = height * 3.5
		local iconH = iconW * 0.3827
		surface_SetDrawColor(255, 255, 255)
		surface_SetMaterial(lmbMat)
		surface_DrawTexturedRect(w / 2 + (self.radialSize + self.size) - iconW / 2, h / 2 + (self.radialSize + self.size) - height - iconH, iconW, iconH)
	end

	self.rmbMatAlpha = Lerp(ft * 10, self.rmbMatAlpha, isfunction(self.backFunc) and 1 or 0)
	if self.rmbMatAlpha > 0.025 then
		local _, height = draw_SimpleText("Вернуться назад", "arb.Font_FuturaPTBook_8", w / 2 - (self.radialSize + self.size), h / 2 + (self.radialSize + self.size), ColorAlpha(color_white, self.rmbMatAlpha * 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

		local iconW = height * 3.5
		local iconH = iconW * 0.3827
		surface_SetDrawColor(255, 255, 255, self.rmbMatAlpha * 255)
		surface_SetMaterial(rmbMat)
		surface_DrawTexturedRect(w / 2 - (self.radialSize + self.size) - iconW / 2, h / 2 + (self.radialSize + self.size) - height - iconH, iconW, iconH)
	end

	self.ambMatAlpha = Lerp(ft * 10, self.ambMatAlpha, (option and option.id) and 1 or 0)
	if self.ambMatAlpha > 0.025 then
		local _, height = draw_SimpleText("Добавить в избранное", "arb.Font_FuturaPTBook_8", w / 2, h / 2 - (self.radialSize + self.size) - 50, ColorAlpha(color_white, self.ambMatAlpha * 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

		local iconW = height * 3.5
		local iconH = iconW * 0.3827
		surface_SetDrawColor(255, 255, 255, self.ambMatAlpha * 255)
		surface_SetMaterial(ambMat)
		surface_DrawTexturedRect(w / 2 - iconW / 2, h / 2 - (self.radialSize + self.size) - 50 - height - iconH, iconW, iconH)
	end

	if self.selected != self.oldselected then
		self:OnRotate()
	end

	self.oldselected = self.selected
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