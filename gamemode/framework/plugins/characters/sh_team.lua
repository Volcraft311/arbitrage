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

Character.team = Character.team or {}
Character.team.instances = {}
Character.team.lastID = 0

function Character.team:New(id)
    if self.instances[id] then
        return self.instances[id]
    end

    local meta = table.Copy(FindMetaTable("Character:Team"))
    local team = setmetatable({id = id}, meta)

    self.instances[id] = team
    return team
end

local assetsPath = "danganronpa/characters/"
function Character.team:Create(data)
    self.lastID = self.lastID + 1
    local id = self.lastID

    local info = self:New(id)

    for k, v in pairs(data) do
        info[k] = v
    end

    local categoryID = info.category or "other"
    local categoryData = Character.category:GetByUniqueID(categoryID)
    if categoryData then
        info.category = categoryData.name
    else
        Character.category:Register(categoryID, {
            name = categoryID,
            icon = "icon16/contrast.png"
        })
    end

    if info.uniqueID and !info.assets.path then
        local path = assetsPath .. info.uniqueID
        local assetPath = path .. "/%s.png"

        info.assets.path = path
        info.assets.logo = Format(assetPath, "logo")
        info.assets.hud = Format(assetPath, "hud")
        info.assets.pixel = Format(assetPath, "pixel")
        info.assets.select = Format(assetPath, "select")
        info.assets.dead = Format(assetPath, "dead")
        info.assets.white = Format(assetPath, "white")
        info.assets.splash = Format(assetPath, "splash")
        info.assets.argue = Format(assetPath, "argue")
    end

    team.SetUp(id, info:GetName(), info:GetColor())

    return id
end

function Character.team:GetByID(id)
    return self.instances[id]
end

local cache_uniqueid = {}
function Character.team:GetByUniqueID(uniqueID)
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

function Character.team:Join(client, data, bRespawn)
    local info = self:GetByID(tonumber(data)) or self:GetByUniqueID(tostring(data))
    if !info then return ErrorNoHalt("[characters] Error when trying to find team with argument: \"" .. data .. "\"\n") end

    if bRespawn then
        Arbitrage.player.Respawn(client)
    end

    local hullMin, hullMax, hullduckMin, hullduckMax = Vector(-16, -16, 0), Vector(16, 16, 72), Vector(-16, -16, 0), Vector(16, 16, 36)

    local id = info:GetID()
    client:SetTeam(id)
    client:SetModel(info:GetModel())
    client:SetNoCollideWithTeammates(false)

    client:SetModelScale(1)
    client:SetHull(hullMin, hullMax)
    client:SetHullDuck(hullduckMin, hullduckMax)

    timer.Simple(0.3, function()
        do
            local scale = info:GetScale()

            client:SetModelScale(scale)
        end

        do
            local scale = info:GetHullScale()
            local min, max = hullMin, hullMax
            local size = Vector(max.x, max.y, max.z * scale)

            client:SetHull(min, size, true)
        end

        do
            local scale = info:GetHullDuckScale()
            local min, max = hullduckMin, hullduckMax
            local size = Vector(max.x, max.y, max.z * scale)

            client:SetHullDuck(min, size, true)
        end

        Arbitrage.player.SetupViewOffset(client)
    end)

    if info.OnChange then
        info.OnChange(client)
    end

    timer.Simple(2, function()
        client:SetupHands()
    end)

    Arbitrage.player.SetupWeapons(client)
    Arbitrage.player.SetupSpeed(client)
    Arbitrage.player.SetupInventory(client)

    hook.Run("SelectCharacter", client, id)
end

function Character.team:Fetch(callback)
    local req = SERVER and asterionlib.Fetch or http.Fetch

    req(Character.APIRequest .. "/characters", function(body)
        body = util.JSONToTable(body)

        if callback then
            callback(body)
        end
    end)
end

function Character.team:Init(callback)
    local function c()
        for uniqueID, info in pairs(Character.creation.team) do
            Character.CreationRegisterKeys("team", uniqueID, info)
        end

        if callback then
            callback()
        end
    end

    if Character.sendRequest then
        self:Fetch(function(array)
            for _, info in ipairs(array) do
                self:Create(info)
            end

            c()
        end)
    else
        Arbitrage.base.Include("sh_team_list.lua")
        c()
    end
end