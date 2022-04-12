local PLUGIN = PLUGIN

local entities = {}
timer.Create("ItemBase:UpdateDraw", 1, 0, function()
    local eyePos = EyePos()
    entities = ents.FindInSphere(eyePos, 500)

    for k, v in ipairs(entities) do
        if v:GetClass() != "arb_item" then
            entities[k] = nil
        end
    end
end)

function PLUGIN:HUDPaint()
    self.actionMenu:Paint()

    for k, v in pairs(entities) do
        if IsValid(v) and !v:IsDormant() and !self.actionMenu.stored[v] then
            local uniqueID = v:GetUniqueID()
            local id = v:GetItemID()

            local item = self.instances[id] or self.list[uniqueID]
            if !item then continue end

            Arbitrage.evidence.CreateText({
                pos = v:GetPos(),
                name = item:GetName(),
                desc = item:GetDescription(),
                class = v:GetClass(),
                data = v
            })
        end
    end
end

netstream.Hook("ItemBase:SyncItem", function(uniqueID, itemID)
    ItemBase:New(uniqueID, itemID)
end)

netstream.Hook("ItemBase:SetData", function(id, key, value)
    ItemBase.data[id] = ItemBase.data[id] or {}
    ItemBase.data[id][key] = value
end)

netstream.Hook("ItemBase:OpenActions", function(uniqueID, data, entity)
    local sendOptions = {}
    for _, name in ipairs(data) do
        local action = ItemBase.list[uniqueID].functions[name]
        if !action then continue end

        sendOptions[#sendOptions + 1] = name
    end

    local info = {
        entity = entity,
        options = sendOptions,
        alpha = -150
    }

    if !PLUGIN.actionMenu.stored[entity] and #sendOptions > 0 and (!PLUGIN.actionMenu.cd or CurTime() >= PLUGIN.actionMenu.cd) then
        PLUGIN.actionMenu:New(info)

        PLUGIN.actionMenu.cd = CurTime() + 0.6
    end
end)