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
local LerpColor = LerpColor
local util_TraceLine = util.TraceLine
local ents_FindInSphere = ents.FindInSphere
local EyePos = EyePos
local math_cos = math.cos
local math_floor = math.floor
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local Format = Format
local Arbitrage = Arbitrage
local draw_NoTexture = draw.NoTexture
local surface_DrawPoly = surface.DrawPoly
local Lerp = Lerp
local FrameTime = FrameTime
local ColorAlpha = ColorAlpha
local draw_SimpleText = draw.SimpleText
local tostring = tostring
local IsValid = IsValid
local Color = Color
local SortedPairs = SortedPairs
local math_Clamp = math.Clamp
local pairs = pairs
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
local surface_DrawLine = surface.DrawLine
local chat_AddText = chat.AddText
local draw_GetFontHeight = draw.GetFontHeight
local select = select
local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize



Arbitrage.hud = Arbitrage.library.Add("hud")
Arbitrage.hud.alpha = 0
Arbitrage.hud.HUDElement = {}
Arbitrage.hud.update = false
Arbitrage.hud.path = "arcadehud/"
Arbitrage.hud.y = 0

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


function Arbitrage.hud.CreateCircle(index, x, status, color, png)
	Arbitrage.hud.HUDElement[index] = Arbitrage.hud.HUDElement[index] or {
		progress = 0
	}

	local element = Arbitrage.hud.HUDElement[index]

	local position = ScrW() / 2 + x
	local circle = Arbitrage.hud.GeneratePoly(position, ScrH() - 70, 36, 36)

	surface_SetDrawColor( 22, 22, 22, Arbitrage.hud.alpha )
	draw_NoTexture()
	surface_DrawPoly(circle)

	element.progress = Lerp(FrameTime() * 2, element.progress, status)

	asterionlib.CircleCustom(position, ScrH() - 70, 5, 5, element.progress - 1, ColorAlpha(color, Arbitrage.hud.alpha / 2), 0, -35)

	local size = 25

	surface_SetDrawColor(255, 255, 255, Arbitrage.hud.alpha)
	surface_SetMaterial(png)
	surface_DrawTexturedRect(position - size / 2, ScrH() - 70 - size / 2, size, size )
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

local descriptionFont = "arb.Font_FuturaPTBook_8"
local descriptionHeight = draw_GetFontHeight(descriptionFont)
function Arbitrage.hud.ALTMenuDraw()
	if Arbitrage.lawEnable then return end

	local client = LocalPlayer()
	if !client:IsPlaying() then return end

	Arbitrage.hud.alpha = Lerp(FrameTime() * 7, Arbitrage.hud.alpha, (IsValid(Arbitrage.gui.context)) and 255 or 0)
	Arbitrage.hud.y = 0

	if SETTINGS.options.Get("interface_open_button") then
		draw_SimpleText("Зажмите клавишу \"C\", чтобы открыть интерфейс", "arb.Font_FuturaPTBook_8", ScrW() - 100, ScrH() - 50, Color( 255, 255, 255, 255 / 2 - Arbitrage.hud.alpha ), TEXT_ALIGN_RIGHT)
	end

	if Arbitrage.hud.alpha > 0.01 then
		surface_SetDrawColor(15, 6, 7, Arbitrage.hud.alpha * 0.9)
		surface_DrawRect(0, 0, ScrW(), ScrH())

		asterionlib.DrawBlurAt(0, 0, ScrW(), ScrH(), 5, nil, Arbitrage.hud.alpha)

		-- Arbitrage.hud.moved = 0

		local faction = Character.team:GetByID(client:Team())
		local icon = faction:GetAssets().hud

		if icon then
			local mat = Material(icon)
			local size = 0.5
			local sizeW, sizeH = W(mat:Width() * size), H(mat:Height() * size)

			surface_SetDrawColor(255, 255, 255, Arbitrage.hud.alpha * 0.6)
			surface_SetMaterial(mat)
			surface_DrawTexturedRect(ScrW() / 2 - sizeW / 2, ScrH() - sizeH, sizeW, sizeH)
		end

		local info = {}
		for k, v in ipairs(Arbitrage.hud.CircleData or {}) do
			local name = v[1]
			local dataTable = v[2]

			local statistics = Arbitrage.statistics.list[name]
			if statistics then
				if statistics.OnCanRun then
					local allow = statistics.OnCanRun(client, statistics)
					if allow == false then
						continue
					end
				end

				local vtime = statistics.time
				local time = isfunction(vtime) and (tonumber(vtime(client)) or 40) or tonumber(vtime)
	            if time <= -1 then
	               continue
	            end
			end

			info[#info + 1] = {
				name,
				math_Clamp(dataTable.value() * 3.6, 0, 360),
				dataTable.color,
				dataTable.image
			}
		end

		Arbitrage.hud.moved = (-#info * 120 + 120) / 2

		for k, v in ipairs(info) do
			Arbitrage.hud.CreateCircle(v[1], Arbitrage.hud.moved, v[2], v[3], v[4])
			Arbitrage.hud.moved = Arbitrage.hud.moved + 120
		end


		surface_SetDrawColor(255, 255, 255, Arbitrage.hud.alpha)
		surface_DrawRect(ScrW() / 2 - 120 * 1.5, ScrH() - 200, 120 * 3, 2)

		draw_SimpleText(client:Name(), "arb.Font_OpenSansLight_15", ScrW() / 2, ScrH() - 200 - 60, Color(255, 255, 255, Arbitrage.hud.alpha), TEXT_ALIGN_CENTER)
		draw_SimpleText(faction:GetTitle(), "arb.Font_OpenSansLight_8", ScrW() / 2, ScrH() - 200 + 20, Color(255, 255, 255, Arbitrage.hud.alpha), TEXT_ALIGN_CENTER)

		local description = client:GetNetVar("description")
		if description then
			local data = asterionlib.WrapText(description, ScrW() * 0.3, descriptionFont, true)

			for k, v in ipairs(data) do
				local padding = #data * descriptionHeight

				draw_SimpleText(v, descriptionFont, ScrW() / 2, ScrH() - 200 - 80 - padding + (k - 1) * descriptionHeight, Color(255, 255, 255, Arbitrage.hud.alpha), TEXT_ALIGN_CENTER)
			end
		end

		draw_SimpleText(Format("%s | %s", Arbitrage.GetTime(), Arbitrage.GetChapter()), "arb.Font_FuturaPTBook_10", ScrW() / 2, 50, Color( 255, 255, 255, Arbitrage.hud.alpha), TEXT_ALIGN_CENTER)
	end

	Arbitrage.hud.update = Arbitrage.hud.alpha > 0.01

	if !Arbitrage.hud.update then
		for k, v in pairs(Arbitrage.hud.HUDElement or {}) do
			v.progress = 0
		end
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

		if isUseFirst and (client:KeyDown(IN_ATTACK) or client:KeyDown(IN_ATTACK2)) then
			realGap = math_Round(gap * 2)
			drawColor = color_red
		else
			local tr = trace.Entity

			if IsValid(tr) and (tr:IsPlayer() or tr:IsNPC() or tr:IsDoor() or Arbitrage.evidence.entities[tr:GetClass()] or tr:GetClass() == "arb_item") then
				drawColor = color_red
			end
		end

		local velocity = client:GetVelocity():Length2D() * 0.03
		curGap = Lerp(FrameTime() * 6, curGap, realGap + velocity)

		if isNocliping or isUseTool then
			curGap = realGap
		end

		local frametime = FrameTime() * 10
		local x, y, z = trace.HitPos.x, trace.HitPos.y, trace.HitPos.z

		Arbitrage.hud.lerpX = isNoAnim and Lerp(frametime, Arbitrage.hud.lerpX, x) or x
		Arbitrage.hud.lerpY = isNoAnim and Lerp(frametime, Arbitrage.hud.lerpY, y) or y
		Arbitrage.hud.lerpZ = isNoAnim and Lerp(frametime, Arbitrage.hud.lerpZ, z) or z

		local trace2D = Vector(Arbitrage.hud.lerpX, Arbitrage.hud.lerpY, Arbitrage.hud.lerpZ):ToScreen()

		surface_DrawCircle(trace2D.x, trace2D.y, curGap, ColorAlpha(drawColor, 255 - Arbitrage.hud.alpha))
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

	if client:Health() <= 10 then
		if !client.lastDSP then
			client:SetDSP(14)
			client.lastDSP = 14
		end
	else
		if client.lastDSP then
			client:SetDSP(0)
			client.lastDSP = nil
		end
	end

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

local FishEyeTexture = Material("models/props_c17/fisheyelens")
function Arbitrage.hud.GrayCorrect()
	if LocalPlayer():WaterLevel() > 2 then
	    render_UpdateScreenEffectTexture()
	        FishEyeTexture:SetFloat("$envmap", 0)
	        FishEyeTexture:SetFloat("$envmaptint", 0)
	        FishEyeTexture:SetFloat("$refractamount", 0.1)
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

function Arbitrage.hud.VectorObstructed(vec1, vec2, filter)
	local trace = util_TraceLine({
		start = vec1,
		endpos = vec2,
		filter = filter
	})

	return trace.Hit
end

function Arbitrage.hud.SeeVector(a, b, _debug)
	local client = LocalPlayer()
	local zPos = client:GetPos()[3]

	for i = 1, 4 do a[i] = Vector(a[i][1], a[i][2], zPos) end
	b = Vector(b[1], b[2], zPos)

	local r = {
		A = {x = a[1]:ToScreen().x, y = a[1]:ToScreen().y},
		B = {x = a[2]:ToScreen().x, y = a[2]:ToScreen().y},
		C = {x = a[3]:ToScreen().x, y = a[3]:ToScreen().y},
		D = {x = a[4]:ToScreen().x, y = a[4]:ToScreen().y}
	}

	local m = {x = b:ToScreen().x, y = b:ToScreen().y}

	local conclusion = r.C.x <= m.x and r.D.x >= m.x and r.C.y <= m.y and r.A.y >= m.y

	if _debug then
		local seeRect = {
			{x = a[4]:ToScreen().x, y = a[1]:ToScreen().y},
			{x = a[3]:ToScreen().x, y = a[2]:ToScreen().y},
			{x = a[3]:ToScreen().x, y = a[3]:ToScreen().y},
			{x = a[4]:ToScreen().x, y = a[4]:ToScreen().y}
		}

		local linesRect = {
			{x = a[1]:ToScreen().x, y = a[1]:ToScreen().y},
			{x = a[2]:ToScreen().x, y = a[2]:ToScreen().y},
			{x = a[3]:ToScreen().x, y = a[3]:ToScreen().y},
			{x = a[4]:ToScreen().x, y = a[4]:ToScreen().y}
		}

		for k, v in ipairs(linesRect) do
			local nextLine = k + 1

			if nextLine > #linesRect then nextLine = 1 end

			surface_SetDrawColor(0, 255, 0)
			surface_DrawLine(v.x, v.y, linesRect[nextLine].x, linesRect[nextLine].y)

			if k == 1 or k == 2 then
				draw_SimpleText("Точка: " .. k, "DermaDefault", v.x, v.y - 15, Color(0, 255, 0, 255), TEXT_ALIGN_CENTER)
				draw_SimpleText("x: " .. math_Round(v.x), "DermaDefault", v.x, v.y, Color(0, 255, 0, 255), TEXT_ALIGN_CENTER)
				draw_SimpleText("y: " .. math_Round(v.y), "DermaDefault", v.x, v.y + 15, Color(0, 255, 0, 255), TEXT_ALIGN_CENTER)
			end
		end

		for k, v in ipairs(seeRect) do
			local nextLine = k + 1

			if nextLine > #seeRect then nextLine = 1 end

			surface_SetDrawColor(199, 194, 194)
			surface_DrawLine(v.x, v.y, seeRect[nextLine].x, seeRect[nextLine].y)

			draw_SimpleText("Точка: " .. k, "DermaDefault", v.x, v.y - 15, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
			draw_SimpleText("x: " .. math_Round(v.x), "DermaDefault", v.x, v.y, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
			draw_SimpleText("y: " .. math_Round(v.y), "DermaDefault", v.x, v.y + 15, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
		end

		local circle = Arbitrage.hud.GeneratePoly(b:ToScreen().x, b:ToScreen().y, 5, 5)
		surface_SetDrawColor(255, 255, 0, 255)
		draw_NoTexture()
		surface_DrawPoly(circle)

		draw_SimpleText("x: " .. math_Round(m.x), "DermaDefault", b:ToScreen().x, b:ToScreen().y, Color(255, 255, 0, 255), TEXT_ALIGN_CENTER)
		draw_SimpleText("y: " .. math_Round(m.y), "DermaDefault", b:ToScreen().x, b:ToScreen().y + 15, Color(255, 255, 0, 255), TEXT_ALIGN_CENTER)

		local pref = tostring(conclusion)
		local st = conclusion and "Точка в прямоугольнике." or "Точка не в прямоугольнике."
		chat_AddText("[" .. pref .. "] " .. st)
	end

	return conclusion
end

do
	local genericFont = "arb.Font_FuturaPTBook_8"
	local genericHeight = draw_GetFontHeight(genericFont)

	local statusFont = "arb.Font_FuturaPTBook_5"
	local statusHeight = draw_GetFontHeight(statusFont)

	local descriptionFont = "arb.Font_FuturaPTBook_6"
	local descriptionHeight = draw_GetFontHeight(descriptionFont)
	local function createTextPlayer(client, textAlpha)
		local position = select(1, client:GetBonePosition(client:LookupBone("ValveBiped.Bip01_Spine4") or -1)) or client:LocalToWorld(client:OBBCenter())

		local data2D = position:ToScreen()
		if !data2D.visible then return end
		local x, y = data2D.x, data2D.y

		draw_SimpleText(client:Name(), genericFont, x, y - (genericHeight / 2) - 10, ColorAlpha(Color(255, 61, 96), textAlpha), TEXT_ALIGN_CENTER)

		surface_SetFont(genericFont)
		local width = surface_GetTextSize(client:Name()) * textAlpha / 255

		surface_SetDrawColor(ColorAlpha(Color(255, 61, 96), textAlpha))
		surface_DrawRect(x - (width * 2 / 2) / 2, y + 2, width * 2 / 2, 1)

		local newY = y + 4
		if !client:GetNetVar("hideStatus") then
			local color = Color(61, 210, 101)
			local stText = "На вид в порядке"
			local health = client:Health()

			if health <= 40 then
				color = Color(218, 52, 52)
				stText = "Выглядит неважно"
			elseif health <= 80 then
				color = Color(218, 162, 52)
				stText = "Слегка потрепанный"
			end

			draw_SimpleText(stText, statusFont, x, newY, ColorAlpha(color, textAlpha), TEXT_ALIGN_CENTER)
			newY = newY + statusHeight
		end

		local description = client:GetNetVar("description")
		if description then
			local data = asterionlib.WrapText(description, ScrW() * 0.15, descriptionFont, true)

			for k, v in ipairs(data) do
				draw_SimpleText(v, descriptionFont, x, newY + (k - 1) * descriptionHeight, ColorAlpha(color_white, textAlpha), TEXT_ALIGN_CENTER)
			end
		end
	end

	local function getTrace(client)
		local traceline = {}
		traceline.start = client:GetShootPos()
		traceline.endpos = traceline.start + client:GetAimVector() * 150
		traceline.filter = client

		return util_TraceLine(traceline)
	end

	local entities = {}
	local ent = nil
	timer_Create("PlayerInfoDraw:Update", 1, 0, function()
		entities = {}
		ent = nil

		if Arbitrage.lawEnable then return end

		local client = LocalPlayer()
		if !IsValid(client) then return end
		if client:IsSpectate() then return end

		local tr = getTrace(client)

		for k, v in ipairs(ents_FindInSphere(EyePos(), 500)) do
			if v:IsPlayer() then
				if v == client then continue end
				if v:IsSpectate() then continue end
				if v:IsNocliping() then continue end

				v.textalpha = v.textalpha or 0

				entities[#entities + 1] = v

				if tr.Entity == v then
					ent = v
				end
			end
		end
	end)

	function Arbitrage.hud.PlayerInfoDraw()
		for k, v in ipairs(entities) do
			if !IsValid(v) then continue end
			if ent != v and v.textalpha <= 0.1 then continue end

			v.textalpha = Lerp(FrameTime() * 5, v.textalpha, ent == v and 256 or 0)

			createTextPlayer(v, v.textalpha)
		end
	end
end