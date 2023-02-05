file.CreateDir("academy_epaint_configs")

EPaint.circlesCache = EPaint.circlesCache or {}
EPaint.materialsCache = EPaint.materialsCache or {}

EPaint.DrawingTypes = {
	[1] = {
		name = "Квадрат",
		cursor = "crosshair",
		data = function(x, y, size)
			surface.DrawRect(x - size, y - size, size * 2, size * 2)
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
				surface.DrawLine(x, y, beforeX, beforeY)
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

				surface.DrawRect(beforeX, beforeY, w, h)
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

				surface.DrawOutlinedRect(beforeX, beforeY, w, h, size)
			end
		end
	},
}

function EPaint:Drawing(array)
	draw.NoTexture()

	for k, v in ipairs(array) do
		local type = v[1]
		local color = v[2]
		surface.SetDrawColor(color)

		local a, b, c, d, e, f = v[3], v[4], v[5], v[6], v[7], v[8]
		self.DrawingTypes[type].data(a, b, c, d, e, f)
	end
end

local cache = {}
timer.Create("EPaint:Update", 1, 0, function()
	cache = {}

	local client = LocalPlayer()
	if !IsValid(client) then return end

	local pos = client:GetPos()
	local dist = EPaint.Distance

	for k, v in ipairs(ents.FindInSphere(pos, dist)) do
		if EPaint:AllowEntity(v) then
			cache[#cache + 1] = v
		end
	end
end)

local shift_pos = Vector(0.7, 118.35, 91.9)
function EPaint:PostDrawOpaqueRenderables()
	local w, h = self.Width, self.Height

	for k, v in ipairs(cache) do
		if !IsValid(v) then continue end

		local pos, ang = v:GetPos(), v:GetAngles()
		pos = pos + ang:Forward() * shift_pos.x + ang:Right() * shift_pos.y + ang:Up() * shift_pos.z

		ang:RotateAroundAxis(ang:Forward(), 90)
	    ang:RotateAroundAxis(ang:Right(), -90)

		cam.Start3D2D(pos, ang, 0.164)
			local idx = v:EntIndex()
			local image = self.materialsCache[idx]
			if image then
				asterionlib.DrawRender(function()
					surface.SetDrawColor(255, 255, 255)
					surface.DrawRect(0, 0, w, h)
				end, function()
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial(image)
					surface.DrawTexturedRect(0, 0, w, h)
				end)
			end

			-- surface.SetDrawColor(0, 0, 0)
			-- surface.DrawOutlinedRect(0, 0, w, h, 4)

			-- surface.SetDrawColor(255, 255, 255)
			-- surface.DrawRect(0, 0, w, h)
		cam.End3D2D()
	end
end


netstream.Hook("EPaint:OpenEditor", function(idx, array)
	local panel = vgui.Create("EPaint:Editor")
	panel:SetData(idx, array)
end)

netstream.Hook("EPaint:Load", function(idx, array)
	LocalPlayer().EPaint_Sending = false
	local w, h = EPaint.Width, EPaint.Height

	local uniqueID = "EPaint_" .. math.floor(RealTime()) .. "_" .. idx
	local EPaintRT = GetRenderTarget(uniqueID, w, h)
	render.PushRenderTarget(EPaintRT)
		render.OverrideAlphaWriteEnable(true, true)
			render.ClearDepth()
			render.Clear(0, 0, 0, 0)

			cam.Start2D()
				EPaint:Drawing(array)
			cam.End2D()
		render.OverrideAlphaWriteEnable(false)
	render.PopRenderTarget()

	local material = CreateMaterial(uniqueID .. "_mat", "UnlitGeneric", {
		["$basetexture"] = EPaintRT:GetName(),
		["$translucent"] = 1,
		["$vertexcolor"] = 1
	})

	EPaint.materialsCache[idx] = material
end)