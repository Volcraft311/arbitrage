Trigger.instances = {}
Trigger.lastID = #Trigger.instances


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

    function Trigger:SyncByID(id, clients)
        Trigger:GetByID(id):Sync(clients)
    end

    function Trigger:SyncLast(clients)
        Trigger.GetLast():Sync(clients)
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

    netstream.Hook("Trigger:SetPos",function(client,data)
        local id = data.id
        local vector = data.vector
        local point = data.point
        Trigger:GetByID(id):SetPoint(point, vector)

        Trigger:SyncAll()
    end)


    timer.Create("Trigger:SyncAll",5,0,function()
        Trigger:SyncAll()
    end)
end