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

-- Localize Global Calls
local draw_GetFontHeight = draw.GetFontHeight
local draw_SimpleText = draw.SimpleText
local ColorAlpha = ColorAlpha
local Color = Color
local util_TraceLine = util.TraceLine
local timer_Create = timer.Create
local IsValid = IsValid
local ipairs = ipairs
local EyePos = EyePos
local Lerp = Lerp
local FrameTime = FrameTime
local ents_FindInSphere = ents.FindInSphere

local font = "arb.Font_FuturaPTBook_8"
local genericHeight = draw_GetFontHeight(font)
local function createTextContainer(entity, name)
    local position = entity:LocalToWorld(entity:OBBCenter())

    local data2D = position:ToScreen()
    if !data2D.visible then return end

    local x, y = data2D.x, data2D.y
    
    local alpha = entity.textalpha
    if alpha <= 0 then return end

    draw_SimpleText(name, font, x, y - (genericHeight / 2) - 10, Color(255, 61, 96, alpha), TEXT_ALIGN_CENTER)
end

asterionlib.entscollector:AddTrack("container", {
	delay_apply = 1,
	onCanTrack = function(entity)
		local class = entity:GetClass()
		if class == "arb_container" then
		    local name = entity.GetContainerName and entity:GetContainerName() or ""
		    
		    if name != "" and name != " " then
		        return true
		    end
		end
	end, 
	onCanApply = function(entity)
	    local eyePos = EyePos()
	    local entityPos = entity:GetPos()

		local distance = entityPos:DistToSqr(eyePos)
	    if distance > 200000 then return false end
	    
	    local bNotVisible = util.VectorObstructed(eyePos, entityPos, {LocalPlayer(), entity})
        if bNotVisible then return false end

	    return true
	end
})

function Container:HUDPaint()
    local ent = LocalTraceEntity()

    local data = asterionlib.entscollector:GetApply("container")
    for k, entity in ipairs(data) do
        if !IsValid(entity) then continue end
        if ent != entity and entity.textalpha <= 0.1 then continue end

        entity.textalpha = Lerp(FrameTime() * 5, entity.textalpha, ent == entity and 256 or 0)

        local name = entity.GetContainerName and entity:GetContainerName() or "" -- attempt to call method 'GetContainerName' (a nil value) / wtf
        createTextContainer(entity, name)
    end
end