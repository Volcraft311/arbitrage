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

local boneOffset = Vector(0, 0, 15)
local textColor = Color(250, 250, 250)
local shadowColor = Color(66, 66, 66)

local standingOffset = Vector(0, 0, 72)
local crouchingOffset = Vector(0, 0, 38)
local function getTypingIndicatorPosition(client)
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


local font = "arb.Font_FuturaPTBook_38"
local text = "AFK"
surface_SetFont(font)
local textWidth, textHeight = surface_GetTextSize("A")
hook("PostDrawTranslucentRenderables", function()
	if Arbitrage.lawEnable then return end
	if #cache <= 0 then return end

	local players = {}
	for k, v in ipairs(cache) do
		if IsValid(v) then
			players[#players + 1] = v
		end
	end

	if #players <= 0 then return end

	local ft = FrameTime()
	local realtime = RealTime()

	local angle = EyeAngles()
	angle:RotateAroundAxis(angle:Forward(), 90)
	angle:RotateAroundAxis(angle:Right(), 90)

	local eyePos = EyePos()
	for _, v in ipairs(players) do
		local bIsAfk = v:IsAFK()
		if (bIsAfk and v.arbAfkTextAlpha < 0.995) or (!bIsAfk and v.arbAfkTextAlpha > 0.005) then
			v.arbAfkTextAlpha = Lerp(ft * 3, v.arbAfkTextAlpha, bIsAfk and 1 or 0)
		end

		local fraction = v.arbAfkTextAlpha
		if fraction <= 0.05 then continue end

		local distance = v:GetPos():DistToSqr(eyePos)
		local alpha = (1 - math_min(distance, d) / d) * 255 * fraction
		if alpha <= 0.05 then continue end

		local colorText = ColorAlpha(textColor, alpha)
		local colorShadow = ColorAlpha(shadowColor, alpha)

		local pos = getTypingIndicatorPosition(v)
		local sin = math_sin(realtime)
		for i = -1, 1 do
			local time = sin * ((i + 2) * 3)
			local rot = (i == -1 or i == 1) and time or -time
			local sizeF = (textWidth * 0.07) * i
			local sizeR = (textHeight * 0.015) * i

			local ang = Angle(rot, angle.y, 90)
			cam_Start3D2D(pos + ang:Forward() * sizeF + ang:Right() * -sizeR + ang:Right() * math_sin((realtime * (i + 2)) * 0.5) * 1, ang, 0.05)
				draw_SimpleTextOutlined(text[i + 2], font, 0, -fraction * 150 + 50, colorText, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 4, colorShadow)
			cam_End3D2D()
		end
	end
end)

hook("HideGame", function()
	netstream.Start("AfkDraw:HideGame")
end)

hook("UnHideGame", function()
	netstream.Start("AfkDraw:UnHideGame")
end)