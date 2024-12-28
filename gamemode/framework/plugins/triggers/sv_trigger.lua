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
    if !_check_client(client,id) then return false end
    local trigger = Trigger:GetByID(id)
    trigger:PlayerEntered(client)
end)

netstream.Hook("Trigger:PlayerExited",function(client,id)
    if _check_client(client,id) then return false end
    local trigger = Trigger:GetByID(id)
    trigger:PlayerExited(client)
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

netstream.Hook("Trigger:AddAction",function(client,data)
    if !client:IsAdmin() then return false end
    local id = data.id
    local actionid = data.actionid
    local args = data.args
    local acttype = data.type
    Trigger:GetByID(id):AddAction(acttype, actionid, args)
    Arbitrage.adminnotify:SendNotify("triggerchanged", client:FullName(), Trigger:GetByID(id).name)

    Trigger:SyncByID(id,player.GetAll())
end)


netstream.Hook("Trigger:EditAction",function(client,data)
    if !client:IsAdmin() then return false end
    local id = data.id
    local args = data.args
    local number = data.number
    local acttype = data.type
    Trigger:GetByID(id):EditAction(acttype,number, args)
    Arbitrage.commands.Notify(client, "Вы изменили аргументы триггера")
    Arbitrage.adminnotify:SendNotify("triggerchanged", client:FullName(), Trigger:GetByID(id).name)
    Trigger:SyncByID(id,player.GetAll())
end)



netstream.Hook("Trigger:RemoveAction",function(client,data)
    if !client:IsAdmin() then return false end
    local id = data.id
    local number = data.number
    local acttype = data.type
    Trigger:GetByID(id):RemoveAction(acttype,number)

    Trigger:SyncByID(id,player.GetAll())
end)

netstream.Hook("Trigger:RemoveAll",function(client)
    if !client:IsAdmin() then return false end

    Trigger:RemoveAll()

    netstream.Start(player.GetAll(),"Trigger:RemoveAll")
end)

netstream.Hook("Trigger:CreateTrigger",function(client,data)
    if !client:IsAdmin() then return false end

    local ActionList = data.ActionList
    local points = data.points
    local name = data.name
    local trigger = Trigger:Create({ActionList = ActionList, points = points, name = name})
    Trigger:SyncByID(trigger.id,player.GetAll())
end)