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

local TEAM = {}
TEAM.__index = TEAM

TEAM.name = "Название команды"
TEAM.title = "Описание таланта"
TEAM.description = ""
TEAM.id = 0
TEAM.uniqueID = nil
TEAM.category = "#category_button_other"
TEAM.model = "models/maxpump/maxpump.mdl"
TEAM.color = Color(240, 201, 73)
TEAM.evidence_visibility = 1
TEAM.scale = 0.85
TEAM.hullscale = 1
TEAM.hullduckscale = 1

TEAM.inventory = {
    w = 4,
    h = 2
}

TEAM.assets = {
    path = nil,

    gradient = nil,
    logo = nil,
    hud = nil,
    pixel = nil,
    dead = nil,
    white = nil,
    splash = nil,
    argue = nil,
}

TEAM.speed = {
    walk = 1,
    run = 1
}

TEAM.stamina = {
    run_consumption = 1
}

TEAM.needs = {
    hunger = 40,
    thirst = 40,
    fatique = 40
}

TEAM.weapons = {}
TEAM.items = {}

function TEAM:__tostring()
    return "team[" .. self.name .. "][" .. self.id .. "]"
end

function TEAM:__eq(other)
    return self:GetID() == other:GetID()
end

function TEAM:GetID()
    return self.id
end

function TEAM:GetUniqueID()
    return self.uniqueID
end

function TEAM:GetHealth()
    return self.health or 100
end

function TEAM:GetArmor()
    return self.armor or 0
end

function TEAM:GetName()
    return self.name
end

function TEAM:GetTitle()
    return self.title
end

function TEAM:GetDescription()
    return self.description
end

function TEAM:GetCategory()
    return self.category
end

function TEAM:GetModel()
    return tostring(self.model) or "models/maxpump/maxpump.mdl"
end

function TEAM:GetColor()
    return self.color
end

function TEAM:GetEvidenceVisibility()
    return tonumber(self.evidence_visibility) or 1
end

function TEAM:GetScale()
    return tonumber(self.scale) or 1
end

function TEAM:GetHullScale()
    return tonumber(self.hullscale) or 1
end

function TEAM:GetHullDuckScale()
    return tonumber(self.hullduckscale) or 1
end

function TEAM:GetAssets()
    return self.assets
end

function TEAM:GetRunSpeed()
    return tonumber(self.speed.run) or 1
end

function TEAM:GetWalkSpeed()
    return tonumber(self.speed.walk) or 1
end

function TEAM:GetRunConsumption()
    return tonumber(self.stamina.run_consumption) or 1
end

function TEAM:GetHunger()
    return tonumber(self.needs.hunger) or 40
end

function TEAM:GetThirst()
    return tonumber(self.needs.thirst) or 40
end

function TEAM:GetFatique()
    return tonumber(self.needs.fatique) or 40
end

function TEAM:GetWeapons()
    return self.weapons
end

function TEAM:GetItems()
    return self.items
end


Arbitrage.meta.character_team = TEAM