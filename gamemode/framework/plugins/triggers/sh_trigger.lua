Trigger.instances = Trigger.instances or {}
Trigger.lastID = #Trigger.instances
Trigger.typeList = {}




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
    trigger.type = data.type
    return trigger
end

function Trigger:GetByID(id)
    return Trigger.instances[id]
end

function Trigger:GetLast()
    return Trigger.instances[Trigger.lastID]
end

function Trigger:GetSelected()
    return Trigger:GetByID(Trigger.selectedID)
end



function Trigger:CreateType(data)
    local triggertype = {name = data.name, OnEnter = data.OnEnter or zero, OnExit = data.OnExit or zero}
    table.insert(Trigger.typeList,triggertype)
    return triggertype
end




if SERVER then

    function PLUGIN:PlayerInitialSpawnForRealz(client)
        Trigger:SyncAll(client)
    end

    function Trigger:SyncAll(clients)
        for k, v in pairs(Trigger.instances) do
            timer.Simple(k * 0.3, function()
                v:Sync(clients)
            end)
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

        local trigger = Trigger:GetByID(id)
        Trigger.typeList[trigger.type].OnEnter(client)
    end)

    netstream.Hook("Trigger:PlayerExited",function(client,id)
        _check_client(client,id)

        local trigger = Trigger:GetByID(id)
        Trigger.typeList[trigger.type].OnExit(client)
    end)

    netstream.Hook("Trigger:SetPos",function(client,data)
        local id = data.id
        local vector = data.vector
        local point = data.point
        Trigger:GetByID(id):SetPoint(point, vector)

        Trigger:SyncByID(id,player.GetAll())
    end)
end


