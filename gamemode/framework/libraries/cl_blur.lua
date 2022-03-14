local blur = Arbitrage.GetMaterial("pp/blurscreen")
local surface = surface

--- Blurs the content underneath the given panel. This will fall back to a simple darkened rectangle if the player has
-- blurring disabled.
-- @realm client
-- @tparam panel panel Panel to draw the blur for
-- @number[opt=5] amount Intensity of the blur. This should be kept between 0 and 10 for performance reasons
-- @number[opt=0.2] passes Quality of the blur. This should be kept as default
-- @number[opt=255] alpha Opacity of the blur
-- @usage function PANEL:Paint(width, height)
-- 	ix.util.DrawBlur(self)
-- end
function Arbitrage.DrawBlur(panel, amount, passes, alpha)
	amount = amount or 5

	surface.SetMaterial(blur)
	surface.SetDrawColor(255, 255, 255, alpha or 255)

	local x, y = panel:LocalToScreen(0, 0)

	for i = -(passes or 0.2), 1, 0.2 do
		-- Do things to the blur material to make it blurry.
		blur:SetFloat("$blur", i * amount)
		blur:Recompute()

		-- Draw the blur material over the screen.
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
	end
end

--- Draws a blurred rectangle with the given position and bounds. This shouldn't be used for panels, see `Arbitrage.DrawBlur`
-- instead.
-- @realm client
-- @number x X-position of the rectangle
-- @number y Y-position of the rectangle
-- @number width Width of the rectangle
-- @number height Height of the rectangle
-- @number[opt=5] amount Intensity of the blur. This should be kept between 0 and 10 for performance reasons
-- @number[opt=0.2] passes Quality of the blur. This should be kept as default
-- @number[opt=255] alpha Opacity of the blur
-- @usage hook.Add("HUDPaint", "MyHUDPaint", function()
-- 	ix.util.DrawBlurAt(0, 0, ScrW(), ScrH())
-- end)
function Arbitrage.DrawBlurAt(x, y, width, height, amount, passes, alpha)
	amount = amount or 5

	surface.SetMaterial(blur)
	surface.SetDrawColor(255, 255, 255, alpha or 255)

	local scrW, scrH = ScrW(), ScrH()
	local x2, y2 = x / scrW, y / scrH
	local w2, h2 = (x + width) / scrW, (y + height) / scrH

	for i = -(passes or 0.2), 1, 0.2 do
		blur:SetFloat("$blur", i * amount)
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRectUV(x, y, width, height, x2, y2, w2, h2)
	end
end