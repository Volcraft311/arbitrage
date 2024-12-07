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
local file_CreateDir = file.CreateDir
local surface_DrawRect = surface.DrawRect
local asterionlib = asterionlib
local surface_DrawLine = surface.DrawLine
local surface_DrawOutlinedRect = surface.DrawOutlinedRect
local draw_NoTexture = draw.NoTexture
local ipairs = ipairs
local surface_SetDrawColor = surface.SetDrawColor
local timer_Create = timer.Create
local IsValid = IsValid
local ents_FindInSphere = ents.FindInSphere
local Vector = Vector
local cam_Start3D2D = cam.Start3D2D
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local cam_End3D2D = cam.End3D2D
local netstream = netstream
local vgui_Create = vgui.Create
local math_floor = math.floor
local RealTime = RealTime
local GetRenderTarget = GetRenderTarget
local render_PushRenderTarget = render.PushRenderTarget
local render_OverrideAlphaWriteEnable = render.OverrideAlphaWriteEnable
local render_ClearDepth = render.ClearDepth
local render_Clear = render.Clear
local cam_Start2D = cam.Start2D
local cam_End2D = cam.End2D
local render_PopRenderTarget = render.PopRenderTarget
local CreateMaterial = CreateMaterial

file_CreateDir("academy_epaint_configs")

EPaint.circlesCache = EPaint.circlesCache or {}
EPaint.materialsCache = EPaint.materialsCache or {}

EPaint.DrawingTypes = {
	[1] = {
		name = "Квадрат",
		cursor = "crosshair",
		data = function(x, y, size)
			surface_DrawRect(x - size, y - size, size * 2, size * 2)
		end
	},
	[2] = {
		name = "Круг",
		cursor = "crosshair",
		data = function(x, y, size)
			local uniqueID = x .. "_" .. y .. "_" .. size
			local cirlce = EPaint.circlesCache[uniqueID]
			if !cirlce then
				cirlce = asterionlib.Circles.New(CIRCLE_FILLED, size, x, y)
			end

			cirlce()
		end
	},
	[3] = {
		name = "Линия",
		cursor = "crosshair",
		saveBefore = true,
		data = function(x, y, size, beforeX, beforeY)
			if beforeX and beforeY then
				surface_DrawLine(x, y, beforeX, beforeY)
			end
		end
	},
	[4] = {
		name = "Прямоугольник",
		cursor = "crosshair",
		saveBefore = true,
		data = function(x, y, size, beforeX, beforeY)
			if beforeX and beforeY then
				local w, h = x - beforeX, y - beforeY

				surface_DrawRect(beforeX, beforeY, w, h)
			end
		end
	},
	[5] = {
		name = "Прямоугольник не залитый",
		cursor = "crosshair",
		saveBefore = true,
		data = function(x, y, size, beforeX, beforeY)
			if beforeX and beforeY then
				local w, h = x - beforeX, y - beforeY

				surface_DrawOutlinedRect(beforeX, beforeY, w, h, size)
			end
		end
	},
}

function EPaint:Drawing(array)
	draw_NoTexture()

	for k, v in ipairs(array) do
		local type = v[1]
		local color = v[2]
		surface_SetDrawColor(color)

		local a, b, c, d, e, f = v[3], v[4], v[5], v[6], v[7], v[8]
		self.DrawingTypes[type].data(a, b, c, d, e, f)
	end
end

asterionlib.entscollector:AddTrack("epaint", {
	delay_apply = 3,
	onCanTrack = function(entity)
		return EPaint:AllowEntity(entity)
	end,
	onCanApply = function(entity)
		local distance = entity:GetPos():DistToSqr(EyePos())
		if distance > EPaint.Distance * EPaint.Distance then return false end

		return true
	end
})

local shift_pos = Vector(0.7, 118.35, 91.9)
function EPaint:PostDrawOpaqueRenderables()
	local data = asterionlib.entscollector:GetApply("epaint")
	if #data <= 0 then return end

	local w, h = self.Width, self.Height
	for k, v in ipairs(data) do
		if !IsValid(v) then continue end

		local pos, ang = v:GetPos(), v:GetAngles()
		pos = pos + ang:Forward() * shift_pos.x + ang:Right() * shift_pos.y + ang:Up() * shift_pos.z

		ang:RotateAroundAxis(ang:Forward(), 90)
	    ang:RotateAroundAxis(ang:Right(), -90)

		cam_Start3D2D(pos, ang, 0.164)
			local idx = v:EntIndex()
			local image = self.materialsCache[idx]
			if image then
				asterionlib.DrawRender(function()
					surface_SetDrawColor(255, 255, 255)
					surface_DrawRect(0, 0, w, h)
				end, function()
					surface_SetDrawColor(255, 255, 255, 255)
					surface_SetMaterial(image)
					surface_DrawTexturedRect(0, 0, w, h)
				end)
			end

			-- surface.SetDrawColor(0, 0, 0)
			-- surface.DrawOutlinedRect(0, 0, w, h, 4)

			-- surface.SetDrawColor(255, 255, 255)
			-- surface.DrawRect(0, 0, w, h)
		cam_End3D2D()
	end
end


netstream.Hook("EPaint:OpenEditor", function(idx, array)
	local panel = vgui_Create("EPaint:Editor")
	panel:SetData(idx, array)
end)

netstream.Hook("EPaint:Load", function(idx, array)
	LocalPlayer().EPaint_Sending = false
	local w, h = EPaint.Width, EPaint.Height

	local uniqueID = "EPaint_" .. math_floor(RealTime()) .. "_" .. idx
	local EPaintRT = GetRenderTarget(uniqueID, w, h)
	render_PushRenderTarget(EPaintRT)
		render_OverrideAlphaWriteEnable(true, true)
			render_ClearDepth()
			render_Clear(0, 0, 0, 0)

			cam_Start2D()
				EPaint:Drawing(array)
			cam_End2D()
		render_OverrideAlphaWriteEnable(false)
	render_PopRenderTarget()

	local material = CreateMaterial(uniqueID .. "_mat", "UnlitGeneric", {
		["$basetexture"] = EPaintRT:GetName(),
		["$translucent"] = 1,
		["$vertexcolor"] = 1
	})

	EPaint.materialsCache[idx] = material
end)
