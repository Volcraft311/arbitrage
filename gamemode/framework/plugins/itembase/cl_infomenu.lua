local PLUGIN = PLUGIN
PLUGIN.infoMenu = PLUGIN.infoMenu or {}

local sizeW, sizeH = 400, 120
function PLUGIN.infoMenu:Paint(entity, name, desc, category, icon, alphaMenu)
	local client = LocalPlayer()
	local pos = entity:GetPos()
	local data2D = pos:ToScreen()
	local distance = client:GetPos():Distance(pos)

	local alpha = math.min(alphaMenu - distance * 1.2, 255)
	if data2D.visible and alpha > 0 then
		local x, y = data2D.x - sizeW / 2, data2D.y - sizeH / 2
		local color = Color(255, 255, 255, alpha)

		asterionlib.DrawBlurAt(x, y, sizeW, sizeH, 5, nil, alpha)

		surface.SetDrawColor(0, 0, 0, alpha * 0.8)
		surface.DrawRect(x, y, sizeW, sizeH)

		if icon then
			surface.SetDrawColor(255, 255, 255, alpha * 1.2)
			surface.SetMaterial(icon)
			surface.DrawTexturedRect(x, y, sizeH, sizeH)
		end

		local font, h, _x = "", 0, sizeH + x

		do
			font = "arb.Font_FuturaPTDemi_8"
			draw.SimpleText(name, font, _x, y, color, TEXT_ALIGN_LEFT)
			local height = draw.GetFontHeight(font)
			h = h + height
		end

		do
			font = "arb.Font_FuturaPTBook_7"
			draw.SimpleText(category, font, _x, y + h, color, TEXT_ALIGN_LEFT)
			local height = draw.GetFontHeight(font)
			h = h + height
		end

		do
			local padding = 3
			local height = 1
			surface.SetDrawColor(color)
			surface.DrawRect(_x, y + h + padding, sizeW * 0.5, height)
			h = h + height + padding
		end

		do
			font = "arb.Font_FuturaPTBook_5"
			local height = draw.GetFontHeight(font)
			local descriptionText = asterionlib.WrapText(desc, sizeW - sizeH - 10, font)
			for k, v in ipairs(descriptionText) do
				draw.SimpleText(v, font, _x, y + h + (k - 1) * height, color, TEXT_ALIGN_LEFT)
			end
		end
	end
end