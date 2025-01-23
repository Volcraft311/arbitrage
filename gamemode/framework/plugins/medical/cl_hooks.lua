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

-- Localize Global Calls
local timer_Create = timer.Create
local IsValid = IsValid
local ipairs = ipairs
local table_Count = table.Count
local math_abs = math.abs
local math_sin = math.sin
local RealTime = RealTime
local pairs = pairs
local Material = Material
local surface_SetDrawColor = surface.SetDrawColor
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local Vector = Vector
local FrameTime = FrameTime
local CurTime = CurTime
local Lerp = Lerp
local Matrix = Matrix
local render_PushFilterMag = render.PushFilterMag
local render_PushFilterMin = render.PushFilterMin
local cam_PushModelMatrix = cam.PushModelMatrix
local draw_DrawText = draw.DrawText
local Color = Color
local math_floor = math.floor
local surface_DrawRect = surface.DrawRect
local cam_PopModelMatrix = cam.PopModelMatrix
local render_PopFilterMag = render.PopFilterMag
local render_PopFilterMin = render.PopFilterMin

local cache = {}
timer_Create("Medical:UpdateStatus", 0.1, 0, function()
	local client = LocalPlayer()
	if !IsValid(client) then return end

	local t_status_effects = client:GetTemporaryStatusEffects()
	cache = t_status_effects
end)

local function run(hook_name, ...)
	local client = LocalPlayer()

	for _, array in ipairs(cache) do
		local uniqueID = array.uniqueID
		local info = Medical.t_status_effects[uniqueID]

		local _hook = info.hooks[hook_name]
		if !_hook then continue end

		local stored = Medical:TemporaryStatusEffectsStored(client, uniqueID)
		if !stored then continue end

		local values = Medical:TemporaryStatusEffectsValues(uniqueID)

		_hook(stored, values, ...)
	end
end

function Medical:RenderScreenspaceEffects(...)
	run("RenderScreenspaceEffects", ...)
end

local vector_one = Vector(1, 1, 1)
local x, y, size, padding = 100, 100, H(32), H(8)
function Medical:HUDPaint(...)
	-- run("HUDPaint", ...) -- пока что не использовались хуки HUDPaint, по этому в комментарии

	if table_Count(self.ui_effects) <= 0 then return end
	local client = LocalPlayer()
	local ft = FrameTime()
	local curTime = CurTime()
	local sinAlpha = 0.25 + math_abs(math_sin(RealTime() * 1.5))

	local i = 1
	for uniqueID, storage in pairs(self.ui_effects) do
		if !client:HasTemporaryStatusEffect(uniqueID) then
			self.ui_effects[uniqueID] = nil
			continue
		end

		local info = self.t_status_effects[uniqueID]
		local material = isfunction(info.icon) and info.icon(client) or info.icon
		material = Material(material)

		local scaleTarget = 1.35
		if storage.anim == 0 then
			if storage.scale >= scaleTarget - 0.00005 then
				storage.anim = 1
			end
		elseif storage.anim == 1 then
			scaleTarget = 1

			if storage.time - 0.5 - curTime <= 0 then
				storage.anim = 2
			end
		elseif storage.anim == 2 then
			scaleTarget = 0

			if storage.scale <= 0.1 then
				self.ui_effects[uniqueID] = nil
				continue
			end
		end

		storage.scale = Lerp(ft * 7, storage.scale, scaleTarget)
		storage.alpha = Lerp(ft * 3, storage.alpha, storage.anim == 2 and 0 or 1)

		local m = Matrix()
		m:Scale(vector_one * storage.scale)

		render_PushFilterMag(TEXFILTER.ANISOTROPIC)
		render_PushFilterMin(TEXFILTER.ANISOTROPIC)
			cam_PushModelMatrix(m, true)
				surface_SetDrawColor(255, 255, 255, storage.alpha * 255 * sinAlpha)
				surface_SetMaterial(material)
				surface_DrawTexturedRect(x * i + padding * i - padding - x * 0.4, y, size, size)

				local name = info.name:gsub(" ", "\n")
				draw_DrawText(name, "arb.Font_FuturaPTBook_6", x * i + padding * i - padding - x * 0.4 + size / 2 + 2, y + size + 2, Color(0, 0, 0, storage.alpha * 255 * sinAlpha), TEXT_ALIGN_CENTER)
				draw_DrawText(name, "arb.Font_FuturaPTBook_6", x * i + padding * i - padding - x * 0.4 + size / 2, y + size, Color(255, 255, 255, storage.alpha * 255 * sinAlpha), TEXT_ALIGN_CENTER)

				local s_m = curTime - storage.start
				local s_tm = storage.time - storage.start
				local s_m_interest = math_floor(100 / (s_tm / s_m)) / 100

				surface_SetDrawColor(0, 0, 0, 180)
				surface_DrawRect(x * i + padding * i - padding - x * 0.4, y, size, size * s_m_interest)
			cam_PopModelMatrix()
		render_PopFilterMag()
		render_PopFilterMin()

		i = i + 1
	end
end