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


netstream.Hook("AfkDraw:HideGame", function(client)
	if client:IsAFK() then return end

	client:SetNetVar("afk", true)
end)

netstream.Hook("AfkDraw:UnHideGame", function(client)
	if !client:IsAFK() then return end

	client:SetNetVar("afk", nil)
end)