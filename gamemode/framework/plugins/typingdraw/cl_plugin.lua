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

local standingOffset = Vector(0, 0, 72)
local crouchingOffset = Vector(0, 0, 38)
local boneOffset = Vector(0, 0, 15)
local font = "arb.Font_FuturaPTBook_7"

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

function PLUGIN:GetTypingText(entity)
	return entity.tDrawText
end

function PLUGIN:GetTypingAlpha(entity)
	return entity.tDrawAlpha or 0
end

function PLUGIN:GetTypingTime(entity)
	return entity.tDrawTime or 0
end

function PLUGIN:GetTypingColor(entity)
	return entity.tDrawColor or Color(255, 255, 255)
end

local d = 150000

PLUGIN.infoList = {}
timer.Create("TypingDraw:Update", 1, 0, function()
	PLUGIN.infoList = {}

	local client = LocalPlayer()
	if !IsValid(client) then return end
	if !SETTINGS.options.Get("show_typingdraw") then return end
	if Arbitrage.lawEnable then return end

	for k, v in ipairs(player.GetAll()) do
		if v == client then continue end
		if v:IsSpectate() then continue end
		if v:IsNocliping() then continue end
		if v:IsDormant() then continue end

		local distance = v:GetPos():DistToSqr(EyePos())
		if distance > d then continue end

		PLUGIN.infoList[#PLUGIN.infoList + 1] = {
			client = v,
		}
	end
end)

function PLUGIN:HUDPaint()
	local realtime = RealTime()
	local time = FrameTime() * 10

	for k, v in ipairs(self.infoList) do
		local client = v.client
		if !IsValid(client) then continue end

		local data = self:GetTypingText(client)
		if !data then continue end

		local bShow = realtime <= self:GetTypingTime(client)
		client.tDrawAlpha = client.tDrawAlpha or 0
		client.tDrawAlpha = Lerp(time, client.tDrawAlpha, bShow and 255 or 0)

		local alpha = self:GetTypingAlpha(client)
		if alpha <= 2 then continue end

		local color = self:GetTypingColor(client)

		self:DrawText(client, data, color, alpha)
	end
end

function PLUGIN:DrawText(client, text, color, alpha)
	local size = ScrW() * 0.2
	local eyepos = EyePos()
	local players = player.GetAll()
	local pos = self:GetTypingIndicatorPosition(client)
	local distance = eyepos:Distance(pos)

	alpha = alpha - distance

	local fraction = client.arbTextAlphaChat or 0

	local data2D = (pos + Vector(0, 0, fraction * 5)):ToScreen()
	if !data2D.visible then return end

	local bNotVisible = Arbitrage.hud.VectorObstructed(eyepos, pos, players)
	if bNotVisible then return end

	local a = ColorAlpha(color, alpha)
	local x, y = data2D.x, data2D.y

	local genericHeight = draw.GetFontHeight(font)
	local drawText = asterionlib.WrapText(text, size, font)
	for k, v in ipairs(drawText) do
		local y2 = genericHeight * (k - 1)

		draw.SimpleText(v, font, x, y + y2, a, TEXT_ALIGN_CENTER)
	end
end

function PLUGIN:SetTypingText(client, data, color)
	local len = utf8.len(data)
	local time = math.Clamp(len * 0.2, 2, 15)

	client.tDrawText = data
	client.tDrawTime = RealTime() + time + 5
	client.tDrawAlpha = 0
	client.tDrawColor = color
end


netstream.Hook("TypingDraw:SetTypingText", function(client, data, color)
	PLUGIN:SetTypingText(client, data, color)
end)