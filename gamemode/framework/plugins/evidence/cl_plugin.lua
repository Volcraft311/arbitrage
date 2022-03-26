--[[
        © Asterion Project 2022.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local PLUGIN = PLUGIN

local LocalPlayer = LocalPlayer
local render_DrawLine = render.DrawLine
local Color = Color
local ipairs = ipairs
local ents_FindInSphere = ents.FindInSphere
local math_Clamp = math.Clamp
local math_abs = math.abs
local math_sin = math.sin
local CurTime = CurTime
local Arbitrage = Arbitrage
local pairs = pairs
local ents_FindByClass = ents.FindByClass
local EyePos = EyePos
local surface_SetDrawColor = surface.SetDrawColor
local ColorAlpha = ColorAlpha
local draw_NoTexture = draw.NoTexture
local surface_DrawPoly = surface.DrawPoly
local draw_SimpleText = draw.SimpleText
local netstream = netstream

function PLUGIN:PostDrawOpaqueRenderables()
    local client = LocalPlayer()

    local data = self:GetToolData(client)
    if !data then return end

    local trace = LocalPlayer():GetEyeTrace()
    local angle = trace.HitNormal:Angle()

    render_DrawLine(trace.HitPos, trace.HitPos + 8 * angle:Forward(), Color(255, 0, 0), true)
    render_DrawLine(trace.HitPos, trace.HitPos + 8 * -angle:Right(), Color(0, 255, 0), true)
    render_DrawLine(trace.HitPos, trace.HitPos + 8 * angle:Up(), Color(0, 0, 255), true)
end

local evidences = {}
timer.Create("Evidence:UpdateDraw", 1, 0, function()
	local eyePos = EyePos()
	evidences = ents_FindInSphere(eyePos, 1000)

	for k, v in ipairs(evidences) do
		local idx = v:GetEvidence()

		if !idx then
			evidences[k] = nil
		else
			local data = PLUGIN:GetEvidence(idx)

			if !data then
				evidences[k] = nil
			end
		end
	end
end)

function PLUGIN:HUDPaint()
    local client = LocalPlayer()

    for k, v in pairs(evidences) do
    	if IsValid(v) then
	        local idx = v:GetEvidence()
	        local data = self:GetEvidence(idx)
	        if !data then continue end

	        local pos = v:GetPos()
	        local name, description, color, alphaA = data.name, data.description, data.color, data.alpha

	        local data2D = pos:ToScreen()
	        if !data2D.visible then continue end

	        local x, y = data2D.x, data2D.y

	        local max_alpha = 150
	        local curalpha = math_Clamp(math_abs(math_sin(CurTime() * 3)) * max_alpha, 0, max_alpha)
	        local alpha = math_Clamp(client:GetPos():Distance(pos) / 3, 0, 150)

	        local faction = Arbitrage.teams.Get(client:Team())

	        local ignore_list = {}
	        ignore_list[#ignore_list + 1] = client
	        ignore_list[#ignore_list + 1] = v

	        for k2, v2 in pairs(ents_FindByClass("arb_evidence")) do ignore_list[#ignore_list + 1] = v2 end

	        v.evData = v.evData or 0

	        if !Arbitrage.hud.VectorObstructed(EyePos(), pos, ignore_list) then
	            local circle = Arbitrage.hud.GeneratePoly(x, y, math_Clamp((curalpha - alpha - v.evData) * (20 / 200) * (faction.evidenceVisibility or 1), 0, 200), math_Clamp(curalpha - alpha - v.evData, 0, 150))

	            surface_SetDrawColor(ColorAlpha(color, math_Clamp(curalpha - alpha - v.evData - (255 * 0.5 - alphaA), 0, 150)))
	            draw_NoTexture()
	            surface_DrawPoly(circle)
	        end

	        if Arbitrage:IsDeveloping() or client:IsNocliping() then
	            if !client:IsAdmin() then return end
	            if client.GetSitting and client:GetSitting() then return end
	            if !SETTINGS.options.Get("show_admin_esp") then return end

	            draw_SimpleText("ID: " .. idx .. "\n" .. name .. "\n" .. description, "Default", x, y, color, TEXT_ALIGN_CENTER)
	        end
    	end
    end
end

netstream.Hook("evidence.Register", function(idx, data)
    PLUGIN.list[idx] = data
end)

netstream.Hook("evidence.Clear", function()
    PLUGIN.list = {}
end)