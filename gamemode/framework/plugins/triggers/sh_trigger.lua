Trigger.instances = Trigger.instances or {}
Trigger.lastID = #Trigger.instances
Trigger.ActionTypes = {}


function Trigger:New(id)
    if self.instances[id] then
        return self.instances[id]
    end

    local trigger = {id = id}

    setmetatable(trigger, Trigger.meta)

    self.instances[id] = trigger
    return trigger
end


function Trigger:Create(data, id)
    if !id then
        self.lastID = self.lastID + 1

        id = self.lastID
    end
    local trigger = self:New(id)

    trigger.points = data.points or {Vector(0,0,0),Vector(5,5,5)}
    trigger.name = data.name or "Unnamed_" .. tostring(id)
    trigger.isLocalPlayerInside = false
    trigger.ActionList = data.ActionList or {
        Enter = {},
        Exit = {}
    }
    if CLIENT then
        Trigger.UpdateActionLists()
    end
    return trigger
end

function Trigger:Remove(id)
    for k, v in pairs(Trigger.instances) do
        if v.id == id then
            Trigger.instances[k] = nil
        end
    end
end

function Trigger:GetByID(id)
    --return Trigger.instances[id]
    if Trigger.instances[id] != nil then return Trigger.instances[id] end
    for k, v in pairs(Trigger.instances) do
        if v.id == id then
            return v
        end
    end
    return nil
end

function Trigger:GetLast()
    return Trigger.instances[Trigger.lastID]
end

function Trigger:RemoveAll()
    Trigger.instances = {}
    Trigger.lastID = 0
end

function Trigger:GetSelected()
    return Trigger:GetByID(Trigger.selectedID)
end

function Trigger:ActionByID(actionID)
    return Trigger.ActionTypes[actionID] or nil
end



