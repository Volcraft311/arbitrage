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

local stamina = 100
local alphastamina = 0
local color = Color(255, 255, 255)
local allow = false
timer.Create("StaminaDraw:Update", 1, 0, function()
	local client = LocalPlayer()
	allow = isAllow(client)
end)

local size = ScrW() * 0.001
local staminaMax = 100 * size
function Stamina:HUDPaint()
	if !allow then return end

	local client = LocalPlayer()
	local frametime = FrameTime()

	stamina = Lerp(frametime * 10, stamina, self:GetStamina(client))

	alphastamina = Lerp(frametime * 10, alphastamina, (stamina < 98 or stamina > 100) and 255 or 0)
	if alphastamina <= 0.1 then return end

	surface.SetDrawColor(ColorAlpha(color, alphastamina * (10 / 255)))
	surface.DrawRect(ScrW() / 2 - staminaMax, ScrH() - 30, staminaMax * 2, 4)

	surface.SetDrawColor(ColorAlpha(color, alphastamina))
	surface.DrawRect(ScrW() / 2 - stamina * size, ScrH() - 30, stamina * size * 2, 4)

	surface.DrawRect(ScrW() / 2 - staminaMax - 4, ScrH() - 30, 4, 4)
	surface.DrawRect(ScrW() / 2 + staminaMax - 1, ScrH() - 30, 4, 4)

	if stamina <= 10 then
		color = LerpColor(frametime * 2, color, Color(255, 0, 0))

		if stamina <= 1 then
			alphastamina = 255 * math.abs(math.sin(RealTime() * 4))
		end
	elseif stamina <= 30 then
		color = LerpColor(frametime * 2, color, Color(255, 154, 0))
	elseif stamina > 100 then
		color = LerpColor(frametime * 2, color, Color(0, 162, 255))
	else
		color = LerpColor(frametime * 2, color, color_white)
	end

	draw.SimpleText(math.floor(stamina) .. "/100", "arb.Font_FuturaPTBook_4", ScrW() / 2, ScrH() - 45, ColorAlpha(color, alphastamina), TEXT_ALIGN_CENTER)
end