--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR

        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]] --

local encoded_emoji_data = ""

if SERVER then
	function Character.ReadSprites()
		if ! Arbitrage.file.Read("emoji_config.json") then
			print("[Emoji] emoji_config.json не найден в arbitrage/")
			return
		end

		local raw = Arbitrage.file.Read("emoji_config.json")
		local config = util.JSONToTable(raw)

		for id, sprites in pairs(config) do
			Character.emoji:Register(id, {
				["#classtrial_sprite_category_main"] = sprites
			})
		end
		encoded_emoji_data = asterionlib.encode(Character.emoji.instances)
		print("[Emoji] Зарегистрировано " .. table.Count(config) .. " персонажей")
	end

	timer.Simple(1, function()
		Character.ReadSprites()
	end)

	hook.Add("PlayerInitialSpawn", "Character:Emoji:PlayerInitialSpawn", function(ply)
		if ply:IsBot() then return end
		Print("Sync emoji list to " .. ply:Nick())
		netstream.RawHeavy(ply, "Character:Emoji:Sync", encoded_emoji_data)
	end)
else
	netstream.Hook("Character:Emoji:Sync", function(data)
	-- Print(data)
    for uniqueID, info in pairs(data) do
        local obj = Character.emoji:New(uniqueID)
        obj.data = info.data
    end
end)
end
