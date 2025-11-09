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

local CATEGORY = {}
CATEGORY.__index = CATEGORY

CATEGORY.name = "Название категории"
CATEGORY.description = "Описание категории"
CATEGORY.id = 0
CATEGORY.uniqueID = 0
CATEGORY.icon = "icon16/contrast.png"
CATEGORY.background = nil
CATEGORY.backdrop = nil
CATEGORY.title = nil
CATEGORY.allow_creation = false

function CATEGORY:__tostring()
	return "category[" .. self.name .. "][" .. self.uniqueID .. "]"
end

function CATEGORY:__eq(other)
	return self:GetUniqueID() == other:GetUniqueID()
end

function CATEGORY:GetID()
	return self.id
end

function CATEGORY:GetUniqueID()
	return self.uniqueID
end

function CATEGORY:GetName()
	return self.name
end

function CATEGORY:GetDescription()
	return self.description
end

function CATEGORY:GetIcon()
	return self.icon
end

function CATEGORY:GetBackground()
	return self.background
end

function CATEGORY:GetBackdrop()
	return self.backdrop
end

function CATEGORY:GetTitle()
	return self.title
end


Arbitrage.meta.character_category = CATEGORY