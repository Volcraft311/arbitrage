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

local descriptive_all = {}
timer_Create("DescriptiveText:UpdateAll", 5, 0, function()
    descriptive_all = {}
    
    for k, v in ipairs(ents.GetAll()) do
        local text = v:GetNetVar("DescriptiveText")
        if !text then continue end
        
        local data = wraptext_cache[text]
        if !data then
            data = asterionlib.WrapText(text, wraptext_size, font, true)
            
            wraptext_cache[text] = data
        end
        
        descriptive_all[#descriptive_all + 1] = {v, data}
    end
end)

local d = 100000
local descriptive_cache = {}
timer_Create("DescriptiveText:UpdateDraw", 1, 0, function()
	descriptive_cache = {}
	
	if #descriptive_all <= 0 then return end
	
	local eyePos = EyePos()
	for k, v in ipairs(descriptive_all) do
	    local entity = v[1]

	    if !IsValid(entity) then continue end
	    
	    local distance = entity:GetPos():DistToSqr(eyePos)
	    if distance > d * 2 then continue end
	    
	    descriptive_cache[#descriptive_cache + 1] = v
	end
end)

function PLUGIN:HUDPaint()
	local client = LocalPlayer()

	local eyePos = EyePos()
	for k, v in ipairs(descriptive_cache) do
		local entity, data = v[1], v[2]
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

		for k2, v2 in ipairs(data) do
			draw_SimpleText(v2, font, x, y + fontHeight * k2 - (fontHeight * #data) / 2, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER)
		end
	end
end