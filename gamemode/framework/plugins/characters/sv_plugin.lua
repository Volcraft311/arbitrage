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


function Character.CreationSync(client)
	local characterslist = asterionlib.data:Get("characterslist", {}, true)

	for key, stored in pairs(characterslist) do
		if client != nil then
			netstream.Heavy(client, "Character:CreationSync", key, stored)
		else
			stored = Character.FixArray(stored)

			for uniqueID, info in SortedPairs(stored) do
				Character.CreationRegisterKeys(key, uniqueID, info)
			end
		end
	end
end


hook("PlayerInitialSpawnForRealz", function(client)
	Character.CreationSync(client)
end)

hook("InitPostEntity", function()
	Character.CreationSync()
end)


local function getInfoTeam(data)
	local info = {
		name = tostring(data.name),
	    title = tostring(data.title),
	    category = tostring(data.category),
	    model = tostring(data.model),
	    uniqueID = tostring(data.uniqueID),
	    evidence_visibility = tonumber(data.evidence_visibility),
	    stamina = {
	    	run_consumption = tonumber(data.run_consumption)
	    },
	    speed = {
	    	walk = tonumber(data.speed_walk),
	    	run = tonumber(data.speed_run)
	    },
	    color = data.color,
	    needs = {
	    	hunger = tonumber(data.needs_hunger),
	    	thirst = tonumber(data.needs_thirst),
	    	fatique = tonumber(data.needs_fatique)
	    },
	    scale = tonumber(data.scale)
	}

	return info.uniqueID, info
end

netstream.Hook("Character:CreationRegisterTeam", function(client, data)
	if !client:IsAdmin() then return end

	local uniqueID, info = getInfoTeam(data)

	local characterslist = asterionlib.data:Get("characterslist", {}, true)
	characterslist.team = characterslist.team or {}

	if characterslist.team[uniqueID] or Character.team:GetByUniqueID(uniqueID) then
		return client:ChatNotify("#char_team_id '" .. uniqueID .. "' #char_team_exist")
	end

	characterslist.team[uniqueID] = info

	asterionlib.data:Set("characterslist", characterslist)
	Character.CreationRegisterKeys("team", uniqueID, info)

	client:ChatNotify("#char_team_cmd '" .. uniqueID .. "' #char_team_created")
end)

netstream.Hook("Character:CreationEditTeam", function(client, data)
	if !client:IsAdmin() then return end

	local uniqueID, info = getInfoTeam(data)

	local characterslist = asterionlib.data:Get("characterslist", {}, true)
	characterslist.team = characterslist.team or {}

	if !characterslist.team[uniqueID] then
		return client:ChatNotify("#char_team_id '" .. uniqueID .. "' #char_team_nonexistent")
	end

	characterslist.team[uniqueID] = info

	asterionlib.data:Set("characterslist", characterslist)
	Character.CreationEditKeys("team", uniqueID, info)

	client:ChatNotify("#char_team_cmd '" .. uniqueID .. "' #char_team_updated")
end)

netstream.Hook("Character:CreationRemoveTeam", function(client, uniqueID)
	if !client:IsAdmin() then return end

	uniqueID = tostring(uniqueID)

	local characterslist = asterionlib.data:Get("characterslist", {}, true)
	characterslist.team = characterslist.team or {}

	if !characterslist.team[uniqueID] then
		return client:ChatNotify("#char_team_id '" .. uniqueID .. "' #char_team_nonexistent")
	end

	characterslist.team[uniqueID] = nil

	asterionlib.data:Set("characterslist", characterslist)
	Character.CreationRemoveKeys("team", uniqueID)

	client:ChatNotify("#char_team_cmd '" .. uniqueID .. "' #char_team_deleted")
end)


netstream.Hook("Character:CreationRegisterEmoji", function(client, uniqueID, data)
	if !client:IsAdmin() then return end

	uniqueID = tostring(uniqueID)
	print("id", uniqueID)
	print("data")
	Print(data)

	local characterslist = asterionlib.data:Get("characterslist", {}, true)
	characterslist.emoji = characterslist.emoji or {}

	if characterslist.emoji[uniqueID] or Character.emoji:GetByUniqueID(uniqueID) then
		return client:ChatNotify("#char_sprites_id '" .. uniqueID .. "' #char_sprites_exist")
	end

	characterslist.emoji[uniqueID] = data

	asterionlib.data:Set("characterslist", characterslist)
	Character.CreationRegisterKeys("emoji", uniqueID, data)

	client:ChatNotify("#char_sprites_cmd '" .. uniqueID .. "' #char_sprites_created")
end)

netstream.Hook("Character:CreationEditEmoji", function(client, uniqueID, data)
	if !client:IsAdmin() then return end

	uniqueID = tostring(uniqueID)

	local characterslist = asterionlib.data:Get("characterslist", {}, true)
	characterslist.emoji = characterslist.emoji or {}

	if !characterslist.emoji[uniqueID] then
		return client:ChatNotify("#char_sprites_id '" .. uniqueID .. "' #char_sprites_nonexistent")
	end

	characterslist.emoji[uniqueID] = data

	asterionlib.data:Set("characterslist", characterslist)
	Character.CreationRegisterKeys("emoji", uniqueID, data)

	client:ChatNotify("#char_sprites_cmd '" .. uniqueID .. "' #char_sprites_created")
end)

netstream.Hook("Character:CreationRemoveEmoji", function(client, uniqueID)
	if !client:IsAdmin() then return end

	uniqueID = tostring(uniqueID)

	local characterslist = asterionlib.data:Get("characterslist", {}, true)
	characterslist.emoji = characterslist.emoji or {}

	if !characterslist.emoji[uniqueID] then
		return client:ChatNotify("#char_sprites_id '" .. uniqueID .. "' #char_sprites_nonexistent")
	end

	characterslist.emoji[uniqueID] = nil

	asterionlib.data:Set("characterslist", characterslist)
	Character.CreationRemoveKeys("emoji", uniqueID)

	client:ChatNotify("#char_sprites_cmd '" .. uniqueID .. "' #char_sprites_deleted")
end)


local function getInfoCategory(data)
	local info = {
		name = tostring(data.name),
	    icon = tostring(data.icon),
	    uniqueID = tostring(data.uniqueID)
	}

	return info.uniqueID, info
end

netstream.Hook("Character:CreationRegisterCategory", function(client, data)
	if !client:IsAdmin() then return end

	local uniqueID, info = getInfoCategory(data)

	local characterslist = asterionlib.data:Get("characterslist", {}, true)
	characterslist.category = characterslist.category or {}

	if characterslist.category[uniqueID] or Character.category:GetByUniqueID(uniqueID) then
		return client:ChatNotify("#char_category_id '" .. uniqueID .. "' #char_team_exist")
	end

	characterslist.category[uniqueID] = info

	asterionlib.data:Set("characterslist", characterslist)
	Character.CreationRegisterKeys("category", uniqueID, info)

	client:ChatNotify("#char_category_cmd '" .. uniqueID .. "' #char_team_created")
end)

netstream.Hook("Character:CreationEditCategory", function(client, data)
	if !client:IsAdmin() then return end

	local uniqueID, info = getInfoCategory(data)

	local characterslist = asterionlib.data:Get("characterslist", {}, true)
	characterslist.category = characterslist.category or {}

	if !characterslist.category[uniqueID] then
		return client:ChatNotify("#char_category_id '" .. uniqueID .. "' #char_team_nonexistent")
	end

	characterslist.category[uniqueID] = info

	asterionlib.data:Set("characterslist", characterslist)
	Character.CreationEditKeys("category", uniqueID, info)

	client:ChatNotify("#char_category_cmd '" .. uniqueID .. "' #char_team_updated")
end)

netstream.Hook("Character:CreationRemoveCategory", function(client, uniqueID)
	if !client:IsAdmin() then return end

	uniqueID = tostring(uniqueID)

	local characterslist = asterionlib.data:Get("characterslist", {}, true)
	characterslist.category = characterslist.category or {}

	if !characterslist.category[uniqueID] then
		return client:ChatNotify("#char_category_id '" .. uniqueID .. "' #char_team_nonexistent")
	end

	characterslist.category[uniqueID] = nil

	asterionlib.data:Set("characterslist", characterslist)
	Character.CreationRemoveKeys("category", uniqueID)

	client:ChatNotify("#char_category_cmd '" .. uniqueID .. "' #char_team_deleted")
end)
