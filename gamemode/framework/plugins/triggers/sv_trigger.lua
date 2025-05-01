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


function Trigger:SyncAllTriggers(receivers)
    local info = {}
    for id, trigger in pairs(self.instances) do
        info[id] = trigger:GetSyncData()
    end

    netstream.Heavy(receivers, "Trigger:SyncAllTriggers", info)
end


function Trigger:PlayerInitialSpawnForRealz(client)
    self:SyncAllTriggers(client)
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

netstream.Hook("Trigger:PlayerInteracted", function(client, id)
    local trigger = Trigger:GetByID(id)
    if !trigger then return end

    local traceTrigger = Trigger:FindInTraceLine(client)
    if traceTrigger != trigger then return end

    trigger:PlayerInteracted(client)
end)

netstream.Hook("Trigger:SetPoint", function(client, id, point, vector)
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

    AdminNotify:SendNotify("triggerremoved", client:FullName(), trigger.name)
end)

netstream.Hook("Trigger:ChangeName", function(client, id, name)
    if !client:IsAdmin() then return end

    name = tostring(name)
    if !name then return end

    local trigger = Trigger:GetByID(id)
    if !trigger then return end

    trigger:SetName(name)
    trigger:Sync()

    AdminNotify:SendNotify("triggerchanged", client:FullName(), trigger.name)
end)

netstream.Hook("Trigger:SetActive", function(client, id)
    if !client:IsAdmin() then return end

    local trigger = Trigger:GetByID(id)
    if !trigger then return end

    local bIsActive = !trigger:GetActive()
    trigger:SetActive(bIsActive)
    trigger:Sync()

    AdminNotify:SendNotify("triggerchanged", client:FullName(), trigger.name)
end)

netstream.Hook("Trigger:AddAction", function(client, id, data)
    if !client:IsAdmin() then return end

    local trigger = Trigger:GetByID(id)
    if !trigger then return end

    trigger:AddAction(data.type, data.actionid, data.args, data.name)
    trigger:Sync()

    AdminNotify:SendNotify("triggerchanged", client:FullName(), trigger.name)
end)

netstream.Hook("Trigger:EditAction", function(client, id, data)
    if !client:IsAdmin() then return end

    local trigger = Trigger:GetByID(id)
    if !trigger then return end

    trigger:EditAction(data.type, data.number, data.args, data.name)
    trigger:Sync()

    AdminNotify:SendNotify("triggerchanged", client:FullName(), trigger.name)
end)

netstream.Hook("Trigger:RemoveAction", function(client, id, data)
    if !client:IsAdmin() then return end

    local trigger = Trigger:GetByID(id)
    if !trigger then return end

    trigger:RemoveAction(data.type, data.number)
    trigger:Sync()

    AdminNotify:SendNotify("triggerchanged", client:FullName(), trigger.name)
end)

netstream.Hook("Trigger:RemoveAll", function(client)
    if !client:IsAdmin() then return end

    Trigger:RemoveAll()

    AdminNotify:SendNotify("triggerremoveall", client:FullName())
end)

netstream.Hook("Trigger:SetOneShot", function(client, id, bool)
    if !client:IsAdmin() then return end

    local trigger = Trigger:GetByID(id)
    if !trigger then return end

    trigger:SetOneShot(bool)
    trigger:Sync()

    AdminNotify:SendNotify("triggerchanged", client:FullName(), trigger.name)
end)

netstream.Hook("Trigger:ReloadOneShot", function(client, id)
    if !client:IsAdmin() then return end

    local trigger = Trigger:GetByID(id)
    if !trigger then return end

    trigger:ResetExitedList()
    trigger:ResetEnteredList()
    trigger:ResetInteractedList()
    trigger:Sync()

    AdminNotify:SendNotify("triggerlistsreset", client:FullName(), trigger.name)
end)

netstream.Hook("Trigger:MoveAction", function(client, id, data)
    if !client:IsAdmin() then return end

    local trigger = Trigger:GetByID(id)
    if !trigger then return end

    trigger:MoveAction(data.type, data.number, data.direction)
    trigger:Sync()

    AdminNotify:SendNotify("triggerchanged", client:FullName(), trigger.name)
end)

netstream.Hook("Trigger:LoadConfig", function(client, info)
    if !client:IsAdmin() then return end
    for _, data in ipairs(info) do
        local base = Trigger:Sample()
        for k in pairs(base) do
            base[k] = data[k]
        end

        Trigger:Create(base)
    end

    Trigger:SyncAllTriggers()

    AdminNotify:SendNotify("triggerloadconfig", client:FullName())
end)