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

netstream.Hook("ItemBase:SendAction", function(client, entity, action)
    if entity:GetClass() != "arb_item" then return end
    if entity:GetPos():DistToSqr(client:GetPos()) >= 25000 then return end

    local item = ItemBase.instances[entity:GetItemID()]
    if !item then return end

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