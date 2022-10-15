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

	    if (string.find(name:lower(), "head")) then
	        head = i
	        break
	    end
	end

	local position = head and client:GetBonePosition(head) or ((client:Crouching() and crouchingOffset or standingOffset) + client:GetPos())
	return position + boneOffset
end

local d = 50000
local cache = {}
timer.Create("AfkDraw:Update", 1, 0, function()
	cache = {}

	local client = LocalPlayer()
	for k, v in ipairs(player.GetAll()) do
		if v == client then continue end
	    if v:IsNocliping() then continue end
	    if v:IsSpectate() then continue end

	    local distance = v:GetPos():DistToSqr(EyePos())
	    if distance > d * 2 then continue end

	    v.arbAfkTextAlpha = v.arbAfkTextAlpha or 0
	    cache[#cache + 1] = v
	end
end)

local font = "arb.Font_FuturaPTBook_38"
local text = "AFK"
function PLUGIN:PostDrawTranslucentRenderables()
	if Arbitrage.lawEnable then return end
	if #cache <= 0 then return end

	local angle = EyeAngles()
	angle:RotateAroundAxis(angle:Forward(), 90)
	angle:RotateAroundAxis(angle:Right(), 90)

	surface.SetFont(font)
	local textWidth, textHeight = surface.GetTextSize("A")

	local frametime = FrameTime() * 3
	local realtime = RealTime()

	for _, v in ipairs(cache) do
		if !IsValid(v) then continue end

		v.arbAfkTextAlpha = Lerp(frametime, v.arbAfkTextAlpha, v:IsAFK() and 1 or 0)

		local fraction = v.arbAfkTextAlpha
	    if fraction <= 0.01 then continue end

	    local distance = v:GetPos():DistToSqr(EyePos())
		local alpha = (1 - math.min(distance, d) / d) * 255 * fraction

		local pos = PLUGIN:GetTypingIndicatorPosition(v)
		for i = -1, 1 do
			local time = math.sin(realtime) * ((i + 2) * 3)
			local rot = (i == -1 or i == 1) and time or - time

			local ang = Angle(rot, angle.y, 90)

			local sizeF = (textWidth * 0.07) * i
			local sizeR = (textHeight * 0.015) * i

			cam.Start3D2D(pos + ang:Forward() * sizeF + ang:Right() * -sizeR + ang:Right() * math.sin((realtime * (i + 2)) * 0.5) * 1, ang, 0.05)
				draw.SimpleTextOutlined(text[i + 2], font, 0, -fraction * 150 + 50, ColorAlpha(textColor, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 4, ColorAlpha(shadowColor, alpha))
			cam.End3D2D()
		end
	end
end

function PLUGIN:HideGame()
	netstream.Start("AfkDraw:HideGame")
end

function PLUGIN:UnHideGame()
	netstream.Start("AfkDraw:UnHideGame")
end