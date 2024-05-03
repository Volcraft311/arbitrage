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


local PLUGIN = PLUGIN

-- Localize Global Calls
local draw_GetFontHeight = draw.GetFontHeight
local timer_Create = timer.Create
local EyePos = EyePos
local ipairs = ipairs
local ents_FindInSphere = ents.FindInSphere
local ScrW = ScrW
local IsValid = IsValid
local draw_SimpleText = draw.SimpleText
local Color = Color

local font = "arb.Font_FuturaPTBook_6"
local fontHeight = draw_GetFontHeight(font)

local cache = {}
timer_Create("DescriptiveText:UpdateDraw", 1, 0, function()
	cache = {}

	local eyePos = EyePos()
	for k, v in ipairs(ents_FindInSphere(eyePos, 700)) do
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
		if !data2D.visible then continue end

		local bNotVisible = Arbitrage.hud.VectorObstructed(eyePos, pos, {client, entity})
		if bNotVisible then continue end

		local x, y = data2D.x, data2D.y
		local distance = eyePos:Distance(pos)
		local alpha = 255 - distance

		for k2, v2 in ipairs(data) do
			draw_SimpleText(v2, font, x, y + fontHeight * k2 - (fontHeight * #data) / 2, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)
		end
	end
end