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

function Character.Caching()
	local i = 0

	for k, v in ipairs(player.GetAll()) do
		local faction = Character.team:GetByID(v:Team())
	    if !faction then continue end

	    local uniqueID = faction:GetUniqueID()
	    local emoji = Character.emoji:GetByUniqueID(uniqueID)
	    if !emoji then continue end

	    local var = v:GetNetVar("emoji", 1)
	    local big, _ = emoji:GetByIndex(var)

	    if !big then
	        big, _ = emoji:GetByIndex(1)
	    end

	    if big then
	    	timer.Simple(i, function()
	    		Material(big)
	    	end)

	    	i = i + 0.2
	    end
	end
end

timer.Simple(FrameTime(), Character.Caching)


netstream.Hook("Character:CreationRegisterKeys", function(key, uniqueID, info)
	Character.CreationRegisterKeys(key, uniqueID, info)
end)

netstream.Hook("Character:CreationEditKeys", function(key, uniqueID, info)
	Character.CreationEditKeys(key, uniqueID, info)
end)

netstream.Hook("Character:CreationRemoveKeys", function(key, uniqueID)
	Character.CreationRemoveKeys(key, uniqueID)
end)

netstream.Hook("Character:CreationSync", function(key, stored)
	for uniqueID, info in SortedPairs(stored) do
		Character.CreationRegisterKeys(key, uniqueID, info)
	end
end)

netstream.Hook("Character:Caching", Character.Caching)