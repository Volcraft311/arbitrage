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
local wraptext_size = ScrW() * 0.3
local wraptext_cache = {}

asterionlib.entscollector:AddTrack("descriptivetext", {
	delay_apply = 3,
	onCanTrack = function(entity)
		local text = entity:GetNetVar("DescriptiveText")
		if text then 
			local data = wraptext_cache[text]
			if not data then
				wraptext_cache[text] = asterionlib.WrapText(text, wraptext_size, font, true)
			end

			return true
		end
	end, 
	onCanApply = function(entity)
	    return entity:GetPos():DistToSqr(EyePos()) <= 200000
	end
})

function PLUGIN:HUDPaint()
	local client = LocalPlayer()

	local eyePos = EyePos()
	local data = asterionlib.entscollector:GetApply("descriptivetext")
	for k, entity in ipairs(data) do
		if !IsValid(entity) then continue end

		local pos = entity:LocalToWorld(entity:OBBCenter())

		local data2D = pos:ToScreen()
		if !data2D.visible then continue end

		local bNotVisible = util.VectorObstructed(eyePos, pos, {client, entity})
		if bNotVisible then continue end

		local x, y = data2D.x, data2D.y
		local distance = eyePos:Distance(pos)

		local alpha = 255 - distance
		if alpha <= 0 then continue end

		local text = entity:GetNetVar("DescriptiveText")
		local wraptext = wraptext_cache[text]
		if !wraptext then continue end

		for k2, v2 in ipairs(wraptext) do
			draw_SimpleText(v2, font, x, y + fontHeight * k2 - (fontHeight * #data) / 2, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)
		end
	end
end