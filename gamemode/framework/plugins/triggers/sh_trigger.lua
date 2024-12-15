Trigger.instances = Trigger.instances or {}
Trigger.lastID = #Trigger.instances
Trigger.typeList = {}
Trigger.actionList = {}




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
    trigger.EnterActionList = data.EnterActionList or {}
    trigger.ExitActionList = data.ExitActionList or {}
    if CLIENT then
        Trigger.UpdateActionList()
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

function Trigger:GetSelected()
    return Trigger:GetByID(Trigger.selectedID)
end

function Trigger:ActionByID(actionID)
    return Trigger.actionList[actionID] or nil
end


if SERVER then

    function PLUGIN:PlayerInitialSpawnForRealz(client)
        Trigger:SyncAll(client)
    end

    function Trigger:SyncAll(clients)
        for k, v in pairs(Trigger.instances) do
            timer.Simple(k * 0.1, function()
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

    function Trigger:SyncRemove(id,clients)
        netstream.Start(clients,"Trigger:Remove",{id = id})
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
        if !client:IsAdmin() then return false end
        local id = data.id
        local vector = data.vector
        local point = data.point
        Trigger:GetByID(id):SetPoint(point, vector)

        Trigger:SyncByID(id,player.GetAll())
    end)

    netstream.Hook("Trigger:Remove",function(client,data)
        if !client:IsAdmin() then return false end
        local id = data.id
        Arbitrage.adminnotify:SendNotify("triggerremoved", client:FullName(), Trigger:GetByID(id).name)
        Trigger:Remove(id)
        Trigger:SyncRemove(id,player.GetAll())
    end)
    netstream.Hook("Trigger:ChangeName",function(client,data)
        if !client:IsAdmin() then return false end
        local id = data.id
        local name = data.name
        Trigger:GetByID(id).name = name
        Trigger:SyncByID(id,player.GetAll())
    end)

    netstream.Hook("Trigger:AddEnterAction",function(client,data)
        if !client:IsAdmin() then return false end
        local id = data.id
        local actionid = data.actionid
        local args = data.args
        Trigger:GetByID(id):AddEnterAction(actionid, args)
        Arbitrage.adminnotify:SendNotify("triggerchanged", client:FullName(), Trigger:GetByID(id).name)

        Trigger:SyncByID(id,player.GetAll())
    end)

    netstream.Hook("Trigger:RemoveEnterAction",function(client,data)
        if !client:IsAdmin() then return false end
        local id = data.id
        local number = data.number
        Trigger:GetByID(id):RemoveEnterAction(number)

        Trigger:SyncByID(id,player.GetAll())
    end)

    netstream.Hook("Trigger:EditEnterAction",function(client,data)
        if !client:IsAdmin() then return false end
        local id = data.id
        local args = data.args
        local number = data.number
        Print(data)
        Trigger:GetByID(id):EditEnterAction(number, args)
        Arbitrage.commands.Notify(client, "Вы изменили аргументы триггера")
        Arbitrage.adminnotify:SendNotify("triggerchanged", client:FullName(), Trigger:GetByID(id).name)
        Trigger:SyncByID(id,player.GetAll())
    end)
end


