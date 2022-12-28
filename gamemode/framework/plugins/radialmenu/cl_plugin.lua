--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru (not work)
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local PLUGIN = PLUGIN

PLUGIN.isClose = false
PLUGIN.clampingTime = RealTime()

timer.Simple(1, function()
	hook.Remove("PlayerButtonDown", "PlayerButtonDown_FacialEmote")
end)

function PLUGIN:KeyPressID(client, id)
	if id != "radialmenu" then return end

	if !IsValid(Arbitrage.gui.radialmenu) and !self.isClose and (!vgui.CursorVisible() or (Arbitrage.lawEnable and !Arbitrage.gui.chat:GetActive())) then
		self.clampingTime = RealTime() + 0.5
		return vgui.Create("Radial:Menu")
	end

	local panel = Arbitrage.gui.radialmenu
	if IsValid(panel) and !panel.bClose then
		panel:NewClose()
	end

	self.isClose = false
end

function PLUGIN:KeyReleaseID(client, id)
	if id != "radialmenu" then return end

	if RealTime() > self.clampingTime then
		local panel = Arbitrage.gui.radialmenu
		if IsValid(panel) and !panel.bClose then
			panel:NewClose()
		end

		self.isClose = false
	end
end