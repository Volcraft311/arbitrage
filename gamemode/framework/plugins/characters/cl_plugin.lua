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


asterionlib.loading:AddType("char_assets", {
	name = "Загружаем ассеты персонажей",
	color = Color(194, 55, 55)
})

function Character.Caching()
	local client = LocalPlayer()
	local i = 0

	local function caching(path, time)
		time = time or 0.2

		if !MaterialIsCached(path) then
			timer.Simple(i, function()
				Material(path)
				asterionlib.loading:Start("char_assets", path)
			end)

			asterionlib.loading:AddAsset("char_assets")
			i = i + time
		end
	end

	for _, target in ipairs(player.GetAll()) do
		local faction = Character.team:GetByID(target:Team())
	    if !faction then continue end

	    local uniqueID = faction:GetUniqueID()

	    local emoji = Character.emoji:GetByUniqueID(uniqueID)
	    if !emoji then continue end

	    if target == client then
	    	for _, stored in pairs(emoji:GetData()) do
	    		for _, emojiType in ipairs({"big", "min"}) do
		    		for _, path in pairs(stored[emojiType]) do
		    			caching(path)
		    		end
		    	end
	    	end
	    else
	    	local var = target:GetNetVar("emoji", 1)
	    	local big = emoji:GetByIndex(var) or emoji:GetByIndex(1)

	    	if big then
	    		caching(big)
	    	end
	    end

	    local assets = faction:GetAssets()
	    if assets then
			if assets.white then
				caching(assets.white)
			end

			if assets.dead then
				caching(assets.dead)
			end

			if assets.argue then
				caching(assets.argue)
			end
	    end
	end
end


timer.Simple(1, Character.Caching)


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
	stored = Character.FixArray(stored)

	for uniqueID, info in SortedPairs(stored) do
		Character.CreationRegisterKeys(key, uniqueID, info)
	end
end)

netstream.Hook("Character:Caching", Character.Caching)