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
local ScrW = ScrW
local ScrH = ScrH
local Material = Material
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local math_sin = math.sin
local RealTime = RealTime
local asterionlib = asterionlib
local timer_Create = timer.Create
local table_Count = table.Count
local util_TraceLine = util.TraceLine
local EyePos = EyePos
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local Arbitrage = Arbitrage
local Lerp = Lerp
local FrameTime = FrameTime
local draw_SimpleText = draw.SimpleText
local IsValid = IsValid
local Color = Color
local math_Clamp = math.Clamp
local math_Round = math.Round
local Vector = Vector
local surface_DrawCircle = surface.DrawCircle
local math_Approach = math.Approach
local surface_GetTextureID = surface.GetTextureID
local surface_SetTexture = surface.SetTexture
local DrawColorModify = DrawColorModify
local CurTime = CurTime
local render_UpdateScreenEffectTexture = render.UpdateScreenEffectTexture
local render_SetMaterial = render.SetMaterial
local render_DrawScreenQuad = render.DrawScreenQuad
local ipairs = ipairs
local select = select
local math_cos = math.cos

Arbitrage.hud = Arbitrage.library.Add("hud")
Arbitrage.hud.CircleData = {}

function Arbitrage.hud.AddCircle(name, data)
	Arbitrage.hud.CircleData[#Arbitrage.hud.CircleData + 1] = {name, data}
end

function Arbitrage.hud.GeneratePoly(x, y, radius, passes)
	passes = passes or 100

	local info = {}

	for i = 1, passes + 1 do
		local deg_in_rad = i * math.pi / (passes * 0.5)

		info[i] = {
			x = x + math_cos(deg_in_rad) * radius,
			y = y + math_sin(deg_in_rad) * radius
		}
	end

	return info
end

do
	local spectate_l_mat = Material("danganronpa/hud/spectate_l.png")
	local spectate_r_mat = Material("danganronpa/hud/spectate_r.png")

	local function isAllow(client)
		if !IsValid(client) then return false end
		if !client:IsSpectate() then return false end
		if Arbitrage.lawEnable then return false end

		return true
	end

	local allow = false
	timer_Create("SpectateDraw:Update", 1, 0, function()
		local client = LocalPlayer()
		allow = isAllow(client)
	end)

	function Arbitrage.hud.SpectateDraw()
		if !allow then return end

		local client = LocalPlayer()

		local spectate = client:GetNetVar("spectate")
		if spectate and IsValid(spectate) and spectate:IsPlayer() and spectate:IsValid() then
			spectate = "Вы наблюдаете за " .. spectate:Name()
		else
			spectate = "Свободное наблюдение за игрой"
		end

		surface_SetDrawColor(5, 2, 2, 229.5)
		surface_DrawRect(ScrW() / 2 - W(560) / 2, H(40), W(560), H(46))

		draw_SimpleText(spectate, "arb.Font_FuturaPTBook_10", ScrW() / 2, H(46), Color(255, 234, 238, 255), TEXT_ALIGN_CENTER)

		surface_SetDrawColor(255, 255, 255)
		surface_SetMaterial(spectate_l_mat)
		surface_DrawTexturedRect(ScrW() / 2 - W(560) / 2 + W(14), H(40) + H(11), W(62), H(24))

		surface_SetDrawColor(255, 255, 255)
		surface_SetMaterial(spectate_r_mat)
		surface_DrawTexturedRect(ScrW() / 2 + W(560) / 2 - W(62) - W(14), H(40) + H(11), W(62), H(24))
	end
end

do
	local color_red = Color(255, 61, 96)
	local gap = 8
	local curGap = gap
	local weaponData = {
		["weapon_physgun"] = true,
		["gmod_tool"] = true,
		["academy_key"] = true,
		["academy_first"] = true,
		["weapon_broom"] = true
	}

	local disableCrossHair = false
	local function isAllow(client)
		if !IsValid(client) then return false end
		if Arbitrage.lawEnable then return false end
		if !SETTINGS.options.Get("show_crosshair") then return false end
		if disableCrossHair then return false end
		if client:IsSpectate() then return false end
		if client:IsSpectating() then return false end
		if client.GetSitting and client:GetSitting() then return false end
		if select(3, client:GetAction()) then return false end

		return true
	end

	local isNoAnim = false
	local isNocliping = false
	local isUseTool = false
	local isUseFirst = false
	local allow = false
	timer_Create("CrosshairDraw:Update", 1, 0, function()
		isNoAnim, isNocliping, isUseTool, isUseFirst, disableCrossHair = false, false, false, false, false

		local client = LocalPlayer()
		if !IsValid(client) then return end

		isNocliping = client:IsNocliping()

		local weapon = client:GetActiveWeapon()
		if IsValid(weapon) then
			local class = weapon:GetClass()

			isUseFirst = class == "academy_first"
			isUseTool = class and (class == "gmod_tool" or class == "weapon_physgun")
			isNoAnim = !isNocliping and (client:IsPlaying() and !isUseTool)
			disableCrossHair = (class and !weaponData[class])
		end

		if SETTINGS.options.Get("static_crosshair") then
			isNoAnim = false
		end

		allow = isAllow(client)
	end)

	local function getTrace(client)
		local traceline = {}
		traceline.start = client:GetShootPos()
		traceline.endpos = traceline.start + client:GetAimVector() * 3000
		traceline.filter = client

		return util_TraceLine(traceline)
	end

	Arbitrage.hud.lerpX, Arbitrage.hud.lerpY, Arbitrage.hud.lerpZ = 0, 0, 0
	function Arbitrage.hud.CrosshairDraw()
		if !allow then return end
		if table_Count(ItemBase.actionMenu.stored) > 0 then return end

		local client = LocalPlayer()

		local trace = getTrace(client)
		local distance = EyePos():Distance(trace.HitPos)
		local drawColor = color_white
		local realGap = math_Round(gap * math_Clamp(distance / 400, 0.5, 1))

		if isUseFirst and client:GetNetVar("bIsHoldingObject", false) then
			drawColor = color_red

			if client:KeyDown(IN_ATTACK2) then
				realGap = math_Round(gap * 2)
			end
		end

		local tr = trace.Entity
		if IsValid(tr) and (tr:IsPlayer() or tr:IsNPC() or tr:IsDoor() or (tr.Tooltip or tr.TooltipMini)) then
			drawColor = color_red
		end

		local ft = FrameTime()
		local velocity = client:GetVelocity():Length2D() * 0.03
		curGap = Lerp(ft * 6, curGap, realGap + velocity)

		if isNocliping or isUseTool then
			curGap = realGap
		end

		local x, y, z = trace.HitPos.x, trace.HitPos.y, trace.HitPos.z

		Arbitrage.hud.lerpX = isNoAnim and Lerp(ft * 10, Arbitrage.hud.lerpX, x) or x
		Arbitrage.hud.lerpY = isNoAnim and Lerp(ft * 10, Arbitrage.hud.lerpY, y) or y
		Arbitrage.hud.lerpZ = isNoAnim and Lerp(ft * 10, Arbitrage.hud.lerpZ, z) or z

		local trace2D = Vector(Arbitrage.hud.lerpX, Arbitrage.hud.lerpY, Arbitrage.hud.lerpZ):ToScreen()

		surface_DrawCircle(trace2D.x, trace2D.y, curGap, drawColor)
	end
end

Arbitrage.hud.intensity = 0
local hpwait = 0
local hpalpha = 0
Arbitrage.hud.vignitte = surface_GetTextureID("vgui/vignette_w")

Arbitrage.hud.hpcolor = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

function Arbitrage.hud.LowHealthDraw()
	if Arbitrage.lawEnable then return end

	local client = LocalPlayer()
	if !client:IsPlaying() then return end

	local health = client:Health()
	if health <= 0 then return end

	Arbitrage.hud.intensity = math_Approach(Arbitrage.hud.intensity, math_Clamp(1 - math_Clamp(health / 25, 0, 1), 0, 1), FrameTime() * 3)

	if Arbitrage.hud.intensity > 0 then
		surface_SetDrawColor(0, 0, 0, 200 * Arbitrage.hud.intensity)
		surface_SetTexture(Arbitrage.hud.vignitte)
		surface_DrawTexturedRect(-1, -1, ScrW() + 2, ScrH() + 2)

		Arbitrage.hud.hpcolor["$pp_colour_colour"] = 1 - Arbitrage.hud.intensity
		DrawColorModify(Arbitrage.hud.hpcolor)

		if client:Alive() then
			local curtime = CurTime()

			if curtime > hpwait then
				client:EmitSound("lowhp/hbeat.wav", 45 * Arbitrage.hud.intensity, 100 + 20 * Arbitrage.hud.intensity)
				hpwait = curtime + 0.5
			end

			surface_SetDrawColor(255, 0, 0, (50 * Arbitrage.hud.intensity) * hpalpha)
			surface_DrawTexturedRect(0, 0, ScrW(), ScrH())

			if curtime < hpwait - 0.4 then
				hpalpha = math_Approach(hpalpha, 1, FrameTime() * 10)
			else
				hpalpha = math_Approach(hpalpha, 0.33, FrameTime() * 10)
			end
		end
	end
end

local FishEyeTexture = Material("effects/water_warp01")
function Arbitrage.hud.GrayCorrect()
	if LocalPlayer():WaterLevel() > 2 then
	    render_UpdateScreenEffectTexture()
	        FishEyeTexture:SetFloat("$envmap", 0)
	        FishEyeTexture:SetFloat("$envmaptint", 0)
	        FishEyeTexture:SetFloat("$refractamount", 0.15)
	        FishEyeTexture:SetInt("$ignorez", 1)
	    render_SetMaterial(FishEyeTexture)
	    render_DrawScreenQuad()
	end
end

do
	local vignitte_a = 150
	local vignitte = surface_GetTextureID("vgui/vignette")

	local function isAllow(client)
		if !IsValid(client) then return false end
		if Arbitrage.lawEnable then return false end
		if !client:IsPlaying() then return false end

		return true
	end

	local blur = 0
	local hunger = 0
	local thirst = 0
	local sleep = 0
	local allow = false
	timer_Create("VignetteDraw:Update", 1, 0, function()
		blur, hunger, thirst, sleep = 0, 0, 0, 0

		local client = LocalPlayer()
		allow = isAllow(client)

		if !allow then return end

		blur = math_Clamp(50 - (Arbitrage.statistics.Get(client, "Sleep") or 100), 0, 255)
		hunger = 255 - (Arbitrage.statistics.Get(client, "Hunger") or 100) * 2.55
		thirst = 255 - (Arbitrage.statistics.Get(client, "Thirst") or 100) * 2.55
	end)

	function Arbitrage.hud.VignetteDraw()
		if !allow then return end

		local x, y, w, h = -1, -1, ScrW() + 2, ScrH() + 2

		if blur > 1 then
			asterionlib.DrawBlurAt(-1, -1, ScrW() + 2, ScrH() + 2, 10, nil, blur)

			surface_SetDrawColor(0, 0, 0, blur * 2.5)
			surface_DrawRect(x, y, w, h)

			if blur >= 35 then
				sleep = math_sin(RealTime()) * 255
			end

			if sleep > 0 then
				surface_SetDrawColor(0, 0, 0, sleep - 30)
				surface_DrawRect(x, y, w, h)
			end
		end

		surface_SetTexture(vignitte)
		surface_SetDrawColor(255, 255, 255, vignitte_a)
		surface_DrawTexturedRect(x, y, w, h)

		for k, v in ipairs({hunger, thirst}) do
			surface_SetDrawColor(255, 255, 255, v / 2)
			surface_DrawTexturedRect(x, y, w, h)
		end
	end
end