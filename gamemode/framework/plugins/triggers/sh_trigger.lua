--[[
        © AsterionStaff 2025.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://asterion.games/chancery
        
        developer(s):
            Volcraft - https://steamcommunity.com/id/boobsgunner
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


Trigger.ActionTypes = {}

function Trigger:New(id)
    if self.instances[id] then
        return self.instances[id]
    end

    local trigger = {
        name = "undefined_" .. id,
        id = id,
        points = {Vector(0, 0, 0), Vector(5, 5, 5)},
        ActionList = {Enter = {}, Exit = {}}
    }

    setmetatable(trigger, self.meta)

    self.instances[id] = trigger
    return trigger
end

function Trigger:Create(data, id)
    if !id then
        self.lastID = self.lastID + 1

        id = self.lastID
    end

    local trigger = self:New(id)

    for k, v in pairs(data or {}) do
        trigger[k] = v
    end

    -- save AdvDupe2
    if SERVER then
        local entity = ents.Create("arb_trigger")
        entity:SetPos(trigger.points[1])
        entity:Spawn()

        trigger:SetEntity(entity)
    end

    return trigger
end

function Trigger:GetByID(id)
    return self.instances[id]
end

function Trigger:GetLast()
    local id = self.lastID

    return self.instances[id]
end

function Trigger:RemoveAll()
    self.instances = {}
    self.lastID = 0

    if SERVER then
        for k, v in ipairs(ents.FindByClass("arb_trigger")) do
            v:Remove()
        end

        netstream.Start(nil, "Trigger:RemoveAll")
    end
end

function Trigger:GetSelected()
    local trigger = self:GetByID(self.selectedID)

    return trigger
end

function Trigger:ActionByID(actionID)
    local action = self.ActionTypes[actionID]

    return action
end