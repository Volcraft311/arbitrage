local PLUGIN = PLUGIN

local font = "arb.Font_FuturaPTBook_6"
local fontHeight = draw.GetFontHeight(font)

local cache = {}
timer.Create("DescriptiveText:UpdateDraw", 1, 0, function()
	cache = {}

	local eyePos = EyePos()
	for k, v in ipairs(ents.FindInSphere(eyePos, 700)) do
		local text = v:GetNetVar("DescriptiveText")

		if text then
			local data = asterionlib.WrapText(text, ScrW() * 0.3, font, true)

			cache[#cache + 1] = {v, data}
		end
	end
end)

function PLUGIN:HUDPaint()
	local client = LocalPlayer()
	local eyePos = EyePos()

	for k, v in ipairs(cache) do
		local entity, data = v[1], v[2]
		if !IsValid(entity) then continue end

		local pos = entity:LocalToWorld(entity:OBBCenter())

		local data2D = pos:ToScreen()
		if !data2D.visible then return end

		local bNotVisible = Arbitrage.hud.VectorObstructed(eyePos, pos, {client, entity})
		if bNotVisible then continue end

		local x, y = data2D.x, data2D.y
		local distance = eyePos:Distance(pos)
		local alpha = 255 - distance * 0.7

		for k2, v2 in ipairs(data) do
			draw.SimpleText(v2, font, x, y + fontHeight * k2 - (fontHeight * #data) / 2, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)
		end
	end
end