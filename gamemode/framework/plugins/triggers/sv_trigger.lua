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


function Trigger:SyncAll(receivers)
    local info = {}
    for id, trigger in pairs(Trigger.instances) do
        info[id] = trigger:GetSyncData()
    end

    netstream.Heavy(receivers, "Trigger:SyncAll", info)
end


function Trigger:PlayerInitialSpawnForRealz(client)
    self:SyncAll(client)
end


netstream.Hook("Trigger:PlayerEntered", function(client, id)
    local trigger = Trigger:GetByID(id)
    if !trigger then return end

    if trigger:IsPlayerInside(client) then
        trigger:PlayerEntered(client)
    end
end)

netstream.Hook("Trigger:PlayerExited", function(client, id)
    local trigger = Trigger:GetByID(id)
    if !trigger then return end

    if !trigger:IsPlayerInside(client) then
        trigger:PlayerExited(client)
    end
end)

netstream.Hook("Trigger:SetPos", function(client, id, point, vector)
    if !client:IsAdmin() then return end

    local trigger = Trigger:GetByID(id)
    if !trigger then return end

    trigger:SetPoint(point, vector)
    trigger:Sync()
end)

netstream.Hook("Trigger:Remove", function(client, id)
    if !client:IsAdmin() then return end

    local trigger = Trigger:GetByID(id)
    if !trigger then return end

    trigger:Remove()

    Arbitrage.adminnotify:SendNotify("triggerremoved", client:FullName(), trigger.name)
end)

netstream.Hook("Trigger:ChangeName", function(client, id, name)
    if !client:IsAdmin() then return end

    name = tostring(name)
    if !name then return end

    local trigger = Trigger:GetByID(id)
    if !trigger then return end

    trigger:SetName(name)
    trigger:Sync()

    Arbitrage.adminnotify:SendNotify("triggerchanged", client:FullName(), trigger.name)
end)

netstream.Hook("Trigger:SetActive", function(client, id)
    if !client:IsAdmin() then return end

    local trigger = Trigger:GetByID(id)
    if !trigger then return end

    local bIsActive = !trigger:GetActive()

    trigger:SetActive(bIsActive)
    trigger:Sync()

    Arbitrage.adminnotify:SendNotify("triggerchanged", client:FullName(), trigger.name)
end)

netstream.Hook("Trigger:AddAction", function(client, id, data)
    if !client:IsAdmin() then return end

    local trigger = Trigger:GetByID(id)
    if !trigger then return end

    trigger:AddAction(data.type, data.actionid, data.args)
    trigger:Sync()

    Arbitrage.adminnotify:SendNotify("triggerchanged", client:FullName(), trigger.name)
end)

netstream.Hook("Trigger:EditAction", function(client, id, data)
    if !client:IsAdmin() then return end

    local trigger = Trigger:GetByID(id)
    if !trigger then return end

    trigger:EditAction(data.type, data.number, data.args)
    trigger:Sync()

    Arbitrage.adminnotify:SendNotify("triggerchanged", client:FullName(), trigger.name)
end)

netstream.Hook("Trigger:RemoveAction", function(client, id, data)
    if !client:IsAdmin() then return end

    local trigger = Trigger:GetByID(id)
    if !trigger then return end

    trigger:RemoveAction(data.type, data.number)
    trigger:Sync()

    Arbitrage.adminnotify:SendNotify("triggerchanged", client:FullName(), trigger.name)
end)

netstream.Hook("Trigger:RemoveAll", function(client)
    if !client:IsAdmin() then return end

    Trigger:RemoveAll()

    Arbitrage.adminnotify:SendNotify("triggerremoveall", client:FullName())
end)

netstream.Hook("Trigger:LoadConfig", function(client, info)
    if !client:IsAdmin() then return end

    for _, data in ipairs(info) do
        local trigger = Trigger:Create({
            name = data[1],
            points = data[2],
            ActionList = data[3],
        })

        trigger:Sync()
    end

    Arbitrage.adminnotify:SendNotify("triggerloadconfig", client:FullName())
end)