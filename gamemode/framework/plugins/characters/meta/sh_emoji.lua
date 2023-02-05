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

local EMOJI = {}
EMOJI.__index = EMOJI
EMOJI.uniqueID = 0

EMOJI.data = {}

function EMOJI:__tostring()
	return "emoji[" .. self.uniqueID .. "]"
end

function EMOJI:__eq(other)
	return self:GetUniqueID() == other:GetUniqueID()
end

function EMOJI:GetUniqueID()
	return self.uniqueID
end

function EMOJI:GetData()
	return self.data
end

function EMOJI:GetCategoryList()
	local data = self:GetData()
	local info = {}

	for name in pairs(data) do
		info[#info + 1] = name
	end

	return info
end

function EMOJI:GetBigList(category)
	local data = self:GetData()

	return data[category].big
end

function EMOJI:GetMinList(category)
	local data = self:GetData()

	return data[category].min
end

function EMOJI:GetByIndex(index)
	local data = self:GetData()

	for category, stored in pairs(data) do
		if stored.min[index] then
			local info = data[category]

			return info.big[index], info.min[index]
		end
	end
end


debug.getregistry()["Character:Emoji"] = EMOJI