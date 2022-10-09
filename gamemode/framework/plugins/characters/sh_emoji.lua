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

Character.emoji = Character.emoji or {}
Character.emoji.instances = {}

function Character.emoji:New(uniqueID)
	if self.instances[uniqueID] then
	    return self.instances[uniqueID]
	end

	local meta = table.Copy(FindMetaTable("Character:Emoji"))
	local emoji = setmetatable({uniqueID = uniqueID}, meta)

	self.instances[uniqueID] = emoji
	return emoji
end

function Character.emoji:Register(uniqueID, array)
	local data = {}

	local index = 1
	for category, stored in pairs(array) do
		data[category] = data[category] or {big = {}, min = {}}

		for _, path in ipairs(stored) do
			path = "danganronpa/characters/" .. uniqueID .. "/emoji/" .. path

			data[category].big[index] = path

			local clear = string.utf8sub(path, 0, string.utf8len(path) - 4)
			local min = clear .. "_m.png"

			data[category].min[index] = min
			index = index + 1
		end
	end

	local info = self:New(uniqueID)
	info.data = data

	return uniqueID
end

function Character.emoji:GetByUniqueID(uniqueID)
	return self.instances[uniqueID]
end

Arbitrage.base.Include("sh_emoji_list.lua")