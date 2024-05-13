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

local asterionlib = asterionlib
local timer_Create = timer.Create
local ipairs = ipairs
local Arbitrage = Arbitrage
local Color = Color
local Angle = Angle
local pairs = pairs
local ents_FindByClass = ents.FindByClass
local EyePos = EyePos
local math_Clamp = math.Clamp
local math_sin = math.sin
local CurTime = CurTime
local tonumber = tonumber
local isentity = isentity
local IsValid = IsValid
local surface_SetDrawColor = surface.SetDrawColor
local ColorAlpha = ColorAlpha
local draw_NoTexture = draw.NoTexture
local surface_DrawPoly = surface.DrawPoly
local Lerp = Lerp
local FrameTime = FrameTime
local draw_GetFontHeight = draw.GetFontHeight
local draw_SimpleText = draw.SimpleText
local ents_FindInSphere = ents.FindInSphere

Arbitrage.evidence = Arbitrage.library.Add("evidence")

local color = Color(255, 61, 96)
function Arbitrage.evidence.CreateText(data)
    local client = LocalPlayer()
    local pos = data.pos
    local name = data.name
    local desc = data.desc
    local class = data.class
    local dataEvidence = data.data

    if !util.VectorObstructed(EyePos(), pos, {client, dataEvidence}) then
        local data2D = pos:ToScreen()
        if !data2D.visible then return end

        local x = data2D.x
        local y = data2D.y

        local max_alpha = 150
        local curalpha = math_Clamp(math_sin(CurTime() * 2) * max_alpha, 0, max_alpha)

        local alpha = math_Clamp(client:GetPos():Distance(pos) / 3, 0, 150)

        local evData = 0
        if tonumber(dataEvidence) and Arbitrage.evidence.repository[dataEvidence] then
            evData = Arbitrage.evidence.repository[dataEvidence]
        elseif isentity(dataEvidence) and IsValid(dataEvidence) then
            evData = dataEvidence
        else
            Arbitrage.evidence.array[dataEvidence] = Arbitrage.evidence.array[dataEvidence] or {alpha = 0}
            evData = Arbitrage.evidence.array[dataEvidence]
        end

        local faction = Character.team:GetByID(LocalPlayer():Team())

        evData.alpha = evData.alpha or 0

        local aM = curalpha - alpha - evData.alpha
        local circle = Arbitrage.hud.GeneratePoly(x, y, math_Clamp(aM * (20 / 200) * (faction:GetEvidenceVisibility() or 1), 0, 200), math_Clamp(aM, 0, 150))
        surface_SetDrawColor(ColorAlpha(color, math_Clamp(aM, 0, 150)))
        draw_NoTexture()
        surface_DrawPoly(circle)

		local vec = client:GetPos()
		local ang = Angle(client:GetAngles()[1], client:GetAngles()[2], 0)

		local start1 = vec + ang:Right() * 15
		local start2 = vec - ang:Right() * 15
		local endpos1 = vec + ang:Forward() * 150 + ang:Right() * 15 + ang:Up() * 10
		local endpos2 = vec + ang:Forward() * 150 - ang:Right() * 15 + ang:Up() * 10

		local bVisible = Arbitrage.hud.SeeVector({start1, start2, endpos2, endpos1}, pos, false) and client:GetPos():Distance(pos) < 150
		local speed = bVisible and FrameTime() or FrameTime() * 3

		evData.alpha = Lerp(speed, evData.alpha, bVisible and 255 or 0)
        if evData.alpha <= 5 then return end

        local genericHeight = draw_GetFontHeight("arb.Font_FuturaPTDemi_8")
        local descHeight = draw_GetFontHeight("arb.Font_FuturaPTBook_6")

        draw_SimpleText(name, "arb.Font_FuturaPTDemi_8", x, y - (genericHeight / 2), ColorAlpha(color, evData.alpha), TEXT_ALIGN_CENTER)

        local descriptionText = asterionlib.WrapText(desc, 300, "arb.Font_FuturaPTBook_6")

        for i, _ in pairs(descriptionText) do
            local y2 = y + (descHeight * i) - (genericHeight / 2) + 5
            draw_SimpleText(descriptionText[i], "arb.Font_FuturaPTBook_6", x, y2, ColorAlpha(color_white, evData.alpha), TEXT_ALIGN_CENTER)
        end
    end
end

asterionlib.entscollector:AddTrack("tooltip", {
	delay_apply = 3,
	onCanTrack = function(entity)
		return Arbitrage.evidence.entities[entity:GetClass()]
	end, 
	onCanApply = function(entity)
	    if entity:GetPos():DistToSqr(EyePos()) > 200000 then return false end
	    if entity:IsDormant() then return false end
	    
	    return true
	end
})

function Arbitrage.evidence.Draw()
    local data = asterionlib.entscollector:GetApply("tooltip")
	for k, entity in ipairs(data) do
		if !IsValid(entity) then continue end
        
        local class = entity:GetClass()
        local info = Arbitrage.evidence.entities[class]

		local up = info.up or 0
		local right = info.right or 0
		local forward = info.forward or 0

		local newPos = entity:GetPos()
		newPos = newPos + (entity:GetUp() * up)
        newPos = newPos + (entity:GetRight() * right)
		newPos = newPos + (entity:GetForward() * forward)

		Arbitrage.evidence.CreateText({
		    pos = newPos,
            name = info.name,
            desc = info.desc,
            class = class,
		    data = entity
		})
	end
end