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
local function createTextContainer(entity, name, alpha)
    local pos = entity:LocalToWorld(entity:OBBCenter())

    local data2D = pos:ToScreen()
    if !data2D.visible then return end
    
    local bNotVisible = util.VectorObstructed(EyePos(), pos, {LocalPlayer(), entity})
    if bNotVisible then return false end

    local x, y = data2D.x, data2D.y

    draw_SimpleText(name, font, x, y - (genericHeight / 2) - 10, Color(255, 61, 96, alpha), TEXT_ALIGN_CENTER)
end

local containers_info = {}
asterionlib.entscollector:AddTrack("container", {
	delay_apply = 1,
	onCanTrack = function(entity)
		local class = entity:GetClass()
		if class == "arb_container" then
		    local name = entity.GetContainerName and entity:GetContainerName() or ""
		    
		    if name != "" and name != " " then
                containers_info[entity] = containers_info[entity] or {alpha = 0}

		        return true
		    end
		end
	end, 
	onCanApply = function(entity)
	    if entity:GetPos():DistToSqr(EyePos()) >= 200000 then return false end
	    
        local name = entity.GetContainerName and entity:GetContainerName() or ""
	    containers_info[entity].name = name
	    
	    return true
	end
})


function Container:HUDPaint()
    local ft = FrameTime()
    local ent = LocalTraceEntity()
    local data = asterionlib.entscollector:GetApply("container")
    for k, entity in ipairs(data) do
        if !IsValid(entity) then continue end
        
        local isTraceEntity = ent == entity
        local info = containers_info[entity]
        
        if !isTraceEntity and info.alpha <= 0.1 then continue end
        info.alpha = Lerp(ft * 5, info.alpha, isTraceEntity and 256 or 0)
        
        if info.alpha <= 0.1 then continue end

        createTextContainer(entity, info.name, info.alpha)
    end
end