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


local PLUGIN = PLUGIN

function ItemBase.CreateItemInWorld(uniqueID, pos, ang)
    local item = ItemBase.CreateItem(uniqueID)
    item:Spawn(pos, ang)
    item:Sync()
end

function ItemBase:PlayerInitialSpawn(client)
    -- Синхранизируем предметы
    for id, item in pairs(self.instances) do
        item:Sync(client)
    end
end

netstream.Hook("ItemBase:SendAction", function(client, itemID, action)
    local item = ItemBase.instances[itemID]
    if !item then return end

    local entity = item:GetEntity()
    if IsValid(entity) then
        if entity:GetClass() != "arb_item" then return end
        if entity:GetPos():DistToSqr(client:GetPos()) >= 25000 then return end
    else
        local inventory = item:GetInventory()
        if !inventory then return end
        if !inventory:IsReceiver(client) then return end
    end

    item.player = client
    item.entity = entity

    local actionList = item:GetValidActions()
    local actionInfo = actionList[action]
    if actionInfo then
        local actionRun = actionInfo.OnRun

        if actionRun then
            local data = actionRun(item)

            if data != false then
                item:Remove()
            end
        end
    end

    item.player = nil
    item.entity = nil
end)

netstream.Hook("ItemBase:SpawnItem", function(client, uniqueID)
    if !uniqueID then return end
    if !client:IsAdmin() then return end

    local vStart = client:GetShootPos()
    local vForward = client:GetAimVector()
    local trace = {}
    trace.start = vStart
    trace.endpos = vStart + (vForward * 2048)
    trace.filter = client

    local tr = util.TraceLine(trace)
    local ang = client:EyeAngles()
    ang.yaw = ang.yaw + 180
    ang.roll = 0
    ang.pitch = 0

    ItemBase.CreateItemInWorld(uniqueID, tr.HitPos + Vector(0, 0, 10), ang)
end)

netstream.Hook("ItemBase:GiveItem", function(client, target, uniqueID)
    if !uniqueID then return end
    if !client:IsAdmin() then return end

    if !IsValid(target) and !target:IsPlayer() then return end

    local inventory = target:GetInventory()
    if !inventory then return end

    local item = ItemBase.CreateItem(uniqueID)
    if !item then return end

    local errNotify = item:Transfer(inventory:GetID())

    if errNotify then
        return Arbitrage.commands.Notify(client, errNotify)
    end

    Arbitrage.commands.Notify(client, "Вы успешно выдали \"" .. item:GetName() .. "\" игроку \"" .. target:Name() .. "\"!")

    if client != target then
        Arbitrage.commands.Notify(target, "Администратор выдал вам предмет \"" .. item:GetName() .. "\"!")
    end
end)