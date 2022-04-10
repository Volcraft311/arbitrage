--[[
        © Asterion Project 2021.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

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
local LocalPlayer = LocalPlayer
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
    if !data then return end

    local client = LocalPlayer()
    local pos = data.pos
    local name = data.name
    local desc = data.desc
    local class = data.class
    local dataEvidence = data.data

    local ignore_list = {}
    ignore_list[#ignore_list + 1] = client

    for k, v in pairs(ents_FindByClass("arb_evidence")) do ignore_list[#ignore_list + 1] = v end

    if class then
        for k, v in pairs(ents_FindByClass(class)) do
            ignore_list[#ignore_list + 1] = v
        end
    end

    if !Arbitrage.hud.VectorObstructed(EyePos(), pos, ignore_list) then
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

        local faction = Arbitrage.teams.Get(LocalPlayer():Team())

        evData.alpha = evData.alpha or 0

        local aM = curalpha - alpha - evData.alpha
        local circle = Arbitrage.hud.GeneratePoly(x, y, math_Clamp(aM * (20 / 200) * (faction.evidenceVisibility or 1), 0, 200), math_Clamp(aM, 0, 150))
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

        local genericHeight = draw_GetFontHeight("arb.Font_FuturaPTDemi_8")
        local descHeight = draw_GetFontHeight("arb.Font_FuturaPTBook_6")

        draw_SimpleText(name, "arb.Font_FuturaPTDemi_8", x, y - (genericHeight / 2), ColorAlpha(color, evData.alpha), TEXT_ALIGN_CENTER)

        local descriptionText = Arbitrage.WrapText(desc, 300, "arb.Font_FuturaPTBook_6")

        for i, _ in pairs(descriptionText) do
            local y2 = y + (descHeight * i) - (genericHeight / 2) + 5
            draw_SimpleText(descriptionText[i], "arb.Font_FuturaPTBook_6", x, y2, ColorAlpha(Color(255, 255, 255), evData.alpha), TEXT_ALIGN_CENTER)
        end
    end
end

local entities = {}
timer.Create("Entities:UpdateDraw", 1, 0, function()
	local eyePos = EyePos()
	entities = ents_FindInSphere(eyePos, 500)

	for k, v in ipairs(entities) do
		local entity = Arbitrage.evidence.entities[v:GetClass()]

		if !entity then
			entities[k] = nil
		end
	end
end)

function Arbitrage.evidence.Draw()
	for k, v in pairs(entities) do
		if IsValid(v) and !v:IsDormant() then
			local entity = Arbitrage.evidence.entities[v:GetClass()]

			local up = entity.up or 0
		    local right = entity.right or 0
		    local forward = entity.forward or 0

		    local newPos = v:GetPos()
		    newPos = newPos + (v:GetUp() * up)
		    newPos = newPos + (v:GetRight() * right)
		    newPos = newPos + (v:GetForward() * forward)

			Arbitrage.evidence.CreateText({
		        pos = newPos,
		        name = entity.name,
		        desc = entity.desc,
		        class = v:GetClass(),
		        data = v
		    })
		end
	end
end