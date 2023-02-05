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

function TypingDraw:SetTypingText(client, target, data, color)
	if !IsValid(client) then return end
	if !client:IsPlayer() then return end

	if !IsValid(target) then return end
	if !target:IsPlayer() then return end

	netstream.Start(client, "TypingDraw:SetTypingText", target, data, color)
end