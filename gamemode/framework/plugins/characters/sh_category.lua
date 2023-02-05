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

Character.category = Character.category or {}
Character.category.instances = {}
Character.category.lastID = 0

function Character.category:New(id)
    if self.instances[id] then
        return self.instances[id]
    end

    local meta = table.Copy(FindMetaTable("Character:Category"))
    local category = setmetatable({id = id}, meta)

    self.instances[id] = category
    return category
end

function Character.category:Register(uniqueID, data)
    self.lastID = self.lastID + 1
    local id = self.lastID

    local info = self:New(id)
    info.uniqueID = uniqueID

    for k, v in pairs(data) do
        info[k] = v
    end

    return id
end

function Character.category:GetByID(id)
    return self.instances[id]
end

local cache_uniqueid = {}
function Character.category:GetByUniqueID(uniqueID)
    local storedID = cache_uniqueid[uniqueID]
    if storedID then
        local value = self:GetByID(storedID)

        if value then
            return value
        else
            cache_uniqueid[uniqueID] = nil
        end
    end

    for k, v in pairs(self.instances) do
        local id = v:GetUniqueID()
        if !id then continue end

        if string.lower(id) == string.lower(uniqueID) then
            cache_uniqueid[uniqueID] = v:GetID()

            return v
        end
    end
end

local cache_name = {}
function Character.category:GetByName(name)
    local storedID = cache_name[name]
    if storedID then
        local value = self:GetByID(storedID)

        if value then
            return value
        else
            cache_uniqueid[name] = nil
        end
    end

    for k, v in ipairs(self.instances) do
        local nameID = v:GetName()
        if !nameID then continue end

        if string.lower(nameID) == string.lower(name) then
            cache_name[name] = v:GetID()

            return v
        end
    end
end

function Character.category:Fetch(callback)
    local req = SERVER and asterionlib.Fetch or http.Fetch

    req(Character.APIRequest .. "/categories", function(body)
        body = util.JSONToTable(body)

        if callback then
            callback(body)
        end
    end)
end

function Character.category:Init(callback)
    local function c()
        for uniqueID, info in pairs(Character.creation.category) do
            Character.CreationRegisterKeys("category", uniqueID, info)
        end

        if callback then
            callback()
        end
    end

    if Character.sendRequest then
        self:Fetch(function(array)
            for _, info in ipairs(array) do
                self:Register(info)
            end

            c()
        end)
    else
        Arbitrage.base.Include("sh_category_list.lua")
        c()
    end
end