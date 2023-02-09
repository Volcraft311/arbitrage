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


local PLUGIN = PLUGIN

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
local draw_DrawText = draw.DrawText
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
	local offPickEvidence = Arbitrage.OffPickingEvidence()
	local client = LocalPlayer()

	local faction = Character.team:GetByID(client:Team())

	local ignore_list = {}
	ignore_list[#ignore_list + 1] = client
	for k2, v2 in pairs(ents_FindByClass("arb_evidence")) do ignore_list[#ignore_list + 1] = v2 end

	for k, v in pairs(evidences) do
		if IsValid(v) then
			ignore_list[#ignore_list + 1] = v

			local idx = v:GetEvidence()
			local data = self:GetEvidence(idx)
			if !data then continue end

			local allow = false
			local bUnique = false
			if data.factiondata then
				local bAllow = data.factiondata[client:Team()]

				if bAllow then
					allow = true
					bUnique = true
				end
			else
				allow = true
			end

			local pos = v:GetPos()
			local name, description, color, alphaA = data.name, data.description, data.color, data.alpha

			local data2D = pos:ToScreen()
			if !data2D.visible then continue end

			local x, y = data2D.x, data2D.y
			if allow and !Arbitrage.hud.VectorObstructed(EyePos(), pos, ignore_list) and !offPickEvidence then
				local max_alpha = 150
				local curalpha = math_Clamp(math_abs(math_sin(CurTime() * 3)) * max_alpha, 0, max_alpha)
				local alpha = math_Clamp(client:GetPos():Distance(pos) / 3, 0, max_alpha)

				local evidenceVisibility = faction and faction:GetEvidenceVisibility() or 1
				local b = math_Clamp((curalpha - alpha) * 0.2 * evidenceVisibility, 0, 255)
			    local circle = Arbitrage.hud.GeneratePoly(x, y, b * 0.5, math_Clamp(curalpha - alpha, 0, max_alpha))
			    local a = alphaA - (client:GetPos():Distance(pos) - (evidenceVisibility * 255)) * 0.7
			    a = a - (255 - (Arbitrage.statistics.Get(client, "Sleep") or 100) * 2.55)
				a = math.Clamp(a, 0, 255)

			    surface_SetDrawColor(ColorAlpha(color, a))

			    if bUnique then
			    	local size = b * 0.7

			    	surface_SetDrawColor(255, 255, 255, a)
			    	surface.SetMaterial(Material("icon16/star.png"))
			    	surface.DrawTexturedRect(x - size, y - size, size * 2, size * 2)
			    else
			    	surface_SetDrawColor(ColorAlpha(color, a))
			    	draw_NoTexture()
			    	surface_DrawPoly(circle)
				end
			end

			if !client:IsNocliping() then continue end
			if !client:IsAdmin() then continue end
			if client.GetSitting and client:GetSitting() then continue end
			if !SETTINGS.options.Get("show_admin_esp") then continue end

			draw_DrawText("ID: " .. idx .. "\n" .. name .. "\n" .. description, "Default", x, y, color, TEXT_ALIGN_CENTER)
		end
	end
end

function PLUGIN:StartAnimation(entity, mat)
	local anim, anim2 = 0, 0

	local random = tostring(math.random(16383, 2147483647))
	local uniqueID = "Evidence:Anim_" .. random

	hook.Add("Think", uniqueID, function()
		anim = Lerp(FrameTime() * 10, anim, 1)
	end)

	hook.Add("HUDPaint", uniqueID, function()
		if !IsValid(entity) then return end

		local alpha = anim * 255
		local size = anim * 80 - anim2 * 80
		local move = anim * 80

		local pos = entity:GetPos()
		local data2D = pos:ToScreen()
		if !data2D.visible then return end

		local x, y = data2D.x + move, data2D.y - move

		surface.SetDrawColor(255, 255, 255, alpha)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(x - size / 2, y - size / 2, size, size)
	end)

	timer.Simple(3, function()
		hook.Add("Think", uniqueID, function()
			anim2 = Lerp(FrameTime() * 10, anim2, 1)
		end)
	end)

	timer.Simple(8, function()
		hook.Remove("HUDPaint", uniqueID)
		hook.Remove("Think", uniqueID)
	end)
end

netstream.Hook("evidence.Register", function(idx, data)
    PLUGIN.list[idx] = data
end)

netstream.Hook("evidence.Clear", function()
    PLUGIN.list = {}
end)

netstream.Hook("Evidence:Draw", function(entity, data)
	local d = Evidence.icons
	local mat = Material(d[data.image] and d[data.image] or d[1])

	PLUGIN:StartAnimation(entity, mat)
end)

netstream.Hook("Evidence:ChatNotify", function(title, description, image)
	local dEvidence = Evidence.icons
	local evidenceMat = Material(dEvidence[image])

	chat.AddText(unpack({evidenceMat, title, ". ", description}))
end)