--[[
        © AsterionStaff 2023.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local function isAllow(client)
	if !IsValid(client) then return false end

	if Arbitrage.lawEnable then return false end
	if !SETTINGS.options.Get("show_stamina") then return false end
	if !client:IsPlaying() then return false end
	if !client:Alive() then return false end

	return true
end

local allow = false
timer.Create("StaminaDraw:Update", 1, 0, function()
	local client = LocalPlayer()

	allow = isAllow(client)
end)

local color = Color(255, 255, 255)
local color_red = Color(255, 0, 0)
local color_yellow = Color(255, 154, 0)
local color_blue = Color(0, 162, 255)

local scrW = ScrW()
local scrH = ScrH()
local size = scrW * 0.001
local staminaMax = 100 * size
local stamina = 100
local alphastamina = 0
function Stamina:HUDPaint()
	if !allow then return end

	local client = LocalPlayer()
	local frametime = FrameTime()

	stamina = Lerp(frametime * 10, stamina, self:GetStamina(client))

	alphastamina = Lerp(frametime * 10, alphastamina, (stamina < 98 or stamina > 100) and 255 or 0)
	if alphastamina <= 0.1 then return end

	surface.SetDrawColor(ColorAlpha(color, alphastamina * (10 / 255)))
	surface.DrawRect(scrW / 2 - staminaMax, scrH - 30, staminaMax * 2, 4)

	surface.SetDrawColor(ColorAlpha(color, alphastamina))
	surface.DrawRect(scrW / 2 - stamina * size, scrH - 30, stamina * size * 2, 4)
	surface.DrawRect(scrW / 2 - staminaMax - 4, scrH - 30, 4, 4)
	surface.DrawRect(scrW / 2 + staminaMax - 1, scrH - 30, 4, 4)

	if stamina <= 10 then
		color = LerpColor(frametime * 2, color, color_red)

		if stamina <= 1 then
			alphastamina = 255 * math.abs(math.sin(RealTime() * 4))
		end
	elseif stamina <= 30 then
		color = LerpColor(frametime * 2, color, color_yellow)
	elseif stamina > 100 then
		color = LerpColor(frametime * 2, color, color_blue)
	else
		color = LerpColor(frametime * 2, color, color_white)
	end

	draw.SimpleText(math.floor(stamina) .. "/100", "arb.Font_FuturaPTBook_4", scrW / 2, scrH - 45, ColorAlpha(color, alphastamina), TEXT_ALIGN_CENTER)
end