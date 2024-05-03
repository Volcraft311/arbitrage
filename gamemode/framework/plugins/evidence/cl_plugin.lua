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

local evidences_all = {}
timer.Create("Evidence:UpdateAll", 3, 0, function()
    evidences_all = {}
    
    for k, v in ipairs(ents.GetAll()) do
        local idx = v:GetEvidence()
        if !idx then return end
        
        local data = PLUGIN:GetEvidence(idx)
        if !data then return end
        
        evidences_all[#evidences_all] = v
    end
end)

local d = 100000
local evidences_cache = {}
timer.Create("Evidence:UpdateDraw", 1, 0, function()
	evidences_cache = {}
	
	if #evidences_all <= 0 then return end
	
	local eyePos = EyePos()
	for k, v in ipairs(evidences_all) do
	    if !IsValid(v) then return end
	    
	    local distance = v:GetPos():DistToSqr(eyePos)
	    if distance > d * 2 then continue end
	    
	    evidences_cache[#evidences_cache + 1] = v
	end
end)

local function get_ignore_list()
    local array = {LocalPlayer()}
    
    for k, v in ipairs(evidences_all) do
        array[#array + 1] = v
    end
    
    return array
end

local function draw_admin_evidences(client)
    if #evidences_all <= 0 then return end

    if !client:IsAdmin() then return end
    if !client:IsNocliping() then return end
    if client.GetSitting and client:GetSitting() then return end
	if !SETTINGS.options.Get("show_admin_esp") then return end
    
    for k, v in ipairs(evidences_all) do
        if !IsValid(v) then continue end

        local idx = v:GetEvidence()
        if !idx then continue end

        local data = PLUGIN:GetEvidence(idx)
        if !data then continue end

		local pos = v:GetPos()
		
		local data2D = pos:ToScreen()
		if !data2D.visible then continue end

		local x, y = data2D.x, data2D.y
		local name, description, color = data.name, data.description, data.color

        draw_DrawText("ID: " .. idx .. "\n" .. name .. "\n" .. description, "Default", x, y, color, TEXT_ALIGN_CENTER)
    end
end

local max_alpha = 150
local starIcon = Material("icon16/star.png")
local function draw_player_evidences(client)
    if #evidences_cache <= 0 then return end
    
	local offPickEvidence = Arbitrage.OffPickingEvidence()
	if offPickEvidence then return end

    local curTime = CurTime()
    local eyePos = EyePos()
    local ignore_list = get_ignore_list()
    
	local factionID = client:Team()
	local faction = Character.team:GetByID(factionID)
	local evidenceVisibility = faction and faction:GetEvidenceVisibility() or 1
	
    for k, v in ipairs(evidences_cache) do
        if !IsValid(v) then continue end

        local idx = v:GetEvidence()
        if !idx then continue end

        local data = PLUGIN:GetEvidence(idx)
        if !data then continue end
        
        local pos = v:GetPos()
        		
        local data2D = pos:ToScreen()
        if !data2D.visible then continue end
        
        local x, y = data2D.x, data2D.y
        local name, description, color, alphaA = data.name, data.description, data.color, data.alpha
        
        local bAllow = false
       	local bUnique = false
        if data.factiondata then
        	local allow = data.factiondata[factionID]
        
        	if allow then
        		bAllow = true
        		bUnique = true
        	end
       	else
        	bAllow = true
        end
        
        if !bAllow then return end
        if Arbitrage.hud.VectorObstructed(eyePos, pos, ignore_list) then return end
        
        local curalpha = math_Clamp(math_abs(math_sin(CurTime() * 3)) * max_alpha, 0, max_alpha)
		local alpha = math_Clamp(client:GetPos():Distance(pos) / 3, 0, max_alpha)
		local b = math_Clamp((curalpha - alpha) * 0.2 * evidenceVisibility, 0, 255)
		local a = alphaA - (client:GetPos():Distance(pos) - (evidenceVisibility * 255)) * 0.7
	    a = a - (255 - (Arbitrage.statistics.Get(client, "Sleep") or 100) * 2.55)
		a = math_Clamp(a, 0, 255)

        if bUnique then
            local size = b * 0.7

			surface_SetDrawColor(255, 255, 255, a)
			surface.SetMaterial(starIcon)
			surface.DrawTexturedRect(x - size, y - size, size * 2, size * 2)
        else
            local circle = Arbitrage.hud.GeneratePoly(x, y, b * 0.5, math_Clamp(curalpha - alpha, 0, max_alpha))

            surface_SetDrawColor(ColorAlpha(color, a))
            draw_NoTexture()
            surface_DrawPoly(circle)
        end
    end
end

function PLUGIN:HUDPaint()
    local client = LocalPlayers()

    draw_admin_evidences(client)
    draw_player_evidences(client)
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