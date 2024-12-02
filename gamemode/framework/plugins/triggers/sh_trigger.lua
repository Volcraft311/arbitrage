Trigger.instances = {}
Trigger.lastID = #Trigger.instances


function Trigger:New(data, id)
    if self.instances[id] then
        return self.instances[id]
    end
    local _points = {data.point,data.point + Vector(5,5,5)} or {Vector(0,0,0),Vector(5,5,5)}

    local trigger = {id = id, points = _points }

    setmetatable(trigger, Trigger.meta)

    self.instances[id] = trigger
    return trigger
end


function Trigger:Create(data, id)
    if !id then
        self.lastID = self.lastID + 1

        id = self.lastID
    end
    local trigger = self:New(data, id)

    PrintTable(trigger)
    return trigger
end

function Trigger:GetByID(id)
    return Trigger.instances[id]
end

function Trigger:GetLast()
    return Trigger.instances[Trigger.lastID]
end


if SERVER then

    function Trigger:SyncAll(clients)
        for k, v in pairs(Trigger.instances) do
            v:Sync(clients)
        end
    end

    local function _check_client(client,id)
        local trigger = Trigger:GetByID(id)
        return trigger:IsPlayerInside(client)
    end

    netstream.Hook("Trigger:PlayerEntered",function(client,id)
        _check_client(client,id)
    end)

    netstream.Hook("Trigger:PlayerExited",function(client,id)
        _check_client(client,id)
    end)
end