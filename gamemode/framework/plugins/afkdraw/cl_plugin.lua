-- Localize Global Calls
local Vector = Vector
local Color = Color
local EyePos = EyePos
local ipairs = ipairs
local player_GetAll = player.GetAll
local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize
local IsValid = IsValid
local EyeAngles = EyeAngles
local FrameTime = FrameTime
local RealTime = RealTime
local Lerp = Lerp
local math_min = math.min
local math_sin = math.sin
local Angle = Angle
local cam_Start3D2D = cam.Start3D2D
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local ColorAlpha = ColorAlpha
local cam_End3D2D = cam.End3D2D
local timer_Create = timer.Create
local system_HasFocus = system.HasFocus
local hook_Run = hook.Run

local PLUGIN = PLUGIN

local standingOffset = Vector(0, 0, 72)
local crouchingOffset = Vector(0, 0, 38)
local boneOffset = Vector(0, 0, 15)
local textColor = Color(250, 250, 250)
local shadowColor = Color(66, 66, 66)

function PLUGIN:GetTypingIndicatorPosition(client)
	local head

	for i = 1, client:GetBoneCount() do
	    local name = client:GetBoneName(i)

	    if name:lower():find("head") then
	        head = i
	        break
	    end
	end

	local position = head and client:GetBonePosition(head) or ((client:Crouching() and crouchingOffset or standingOffset) + client:GetPos())
	return position + boneOffset
end

local d = 50000
local cache = {}
timer_Create("AfkDraw:Update", 1, 0, function()
	cache = {}

	local client = LocalPlayer()
	local eyePos = EyePos()
	for k, v in ipairs(player_GetAll()) do
		if v == client then continue end
	    if v:IsNocliping() then continue end
	    if v:IsSpectate() then continue end

	    local distance = v:GetPos():DistToSqr(eyePos)
	    if distance > d * 2 then continue end

	    v.arbAfkTextAlpha = v.arbAfkTextAlpha or 0
	    cache[#cache + 1] = v
	end
end)

local font = "arb.Font_FuturaPTBook_38"
local text = "AFK"
surface_SetFont(font)
local textWidth, textHeight = surface_GetTextSize("A")
function PLUGIN:PostDrawTranslucentRenderables()
	if Arbitrage.lawEnable then return end
	if #cache <= 0 then return end

	local players = {}
	for k, v in ipairs(cache) do
		if IsValid(v) then
			players[#players + 1] = v
		end
	end

	if #players <= 0 then return end

	local angle = EyeAngles()
	angle:RotateAroundAxis(angle:Forward(), 90)
	angle:RotateAroundAxis(angle:Right(), 90)

	local frametime = FrameTime() * 3
	local realtime = RealTime()

	for _, v in ipairs(players) do
		v.arbAfkTextAlpha = Lerp(frametime, v.arbAfkTextAlpha, v:IsAFK() and 1 or 0)

		local fraction = v.arbAfkTextAlpha
		if fraction <= 0.01 then continue end

		local distance = v:GetPos():DistToSqr(EyePos())
		local alpha = (1 - math_min(distance, d) / d) * 255 * fraction

		local pos = PLUGIN:GetTypingIndicatorPosition(v)
		for i = -1, 1 do
			local time = math_sin(realtime) * ((i + 2) * 3)
			local rot = (i == -1 or i == 1) and time or - time

			local ang = Angle(rot, angle.y, 90)

			local sizeF = (textWidth * 0.07) * i
			local sizeR = (textHeight * 0.015) * i

			cam_Start3D2D(pos + ang:Forward() * sizeF + ang:Right() * -sizeR + ang:Right() * math_sin((realtime * (i + 2)) * 0.5) * 1, ang, 0.05)
				draw_SimpleTextOutlined(text[i + 2], font, 0, -fraction * 150 + 50, ColorAlpha(textColor, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 4, ColorAlpha(shadowColor, alpha))
			cam_End3D2D()
		end
	end
end

local bFocus = true
timer_Create("UpdateFocusGame", 1, 0, function()
	if system_HasFocus() then
		if !bFocus then
			hook_Run("UnHideGame")

			bFocus = true
		end
	else
		if bFocus then
			hook_Run("HideGame")

			bFocus = false
		end
	end
end)

hook("HideGame", function()
	netstream.Start("AfkDraw:HideGame")
end)

hook("UnHideGame", function()
	netstream.Start("AfkDraw:UnHideGame")
end)