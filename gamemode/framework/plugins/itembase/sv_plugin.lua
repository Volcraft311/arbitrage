--[[
        © AsterionStaff 2022.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local PLUGIN = PLUGIN

function ItemBase.CreateItemInWorld(uniqueID, pos, ang)
    local item = ItemBase.CreateItem(uniqueID)
    if !item then return end

    local entity = item:Spawn(pos, ang)
    item:Sync()

    return item, entity
end

local function getPlayersRecivers(pos)
    local players = {}

    for k, v in ipairs(player.GetAll()) do
        local distance = v:GetPos():Distance(pos)

        if distance <= 1000 then
            players[#players + 1] = v
        end
    end

    return players
end

function ItemBase.AnimTakeItem(transmit, receiver, pos, ang, model)
    if pos:Distance(receiver:GetPos()) >= 170 then return end

    if IsValid(transmit) and transmit:IsPlayer() and transmit:IsNocliping() then return end
    if IsValid(receiver) and receiver:IsPlayer() and receiver:IsNocliping() then return end

    local players = getPlayersRecivers(pos)

    netstream.Start(players, "ItemBase.AnimTakeItem", receiver, pos, ang, model)
end

function ItemBase.AnimDropItem(target, idx, class)
    local players = getPlayersRecivers(target:GetPos())

    netstream.Start(players, "ItemBase.AnimDropItem", target, idx, class)
end

function ItemBase:PlayerInitialSpawnForRealz(client)
    -- Синхронизируем Creation предметы
    ItemBase.CreationSync(client)

    -- Синхранизируем предметы
    timer.Simple(2, function()
        local info = {}
        for id, item in pairs(self.instances) do
            info[id] = {
                uniqueID = item.uniqueID,
                data = ItemBase.data[id] or {}
            }
        end

        netstream.Heavy(client, "ItemBase:SyncAllItems", info)
    end)
end

function ItemBase:InitPostEntity()
    ItemBase.CreationSync()
end

function ItemBase.CreationSync(client)
    local itemslist = asterionlib.data:Get("itemslist", {}, true)

    for baseID, stored in pairs(itemslist) do
        if baseID == "basic" or ItemBase.base[baseID] then
            if client != nil then
                netstream.Heavy(client, "ItemBase:CreationSync", baseID, stored)
            else
                for uniqueID, info in pairs(stored) do
                    ItemBase.CreationRegisterItem(baseID, uniqueID, info)
                end
            end
        end
    end
end

netstream.Hook("ItemBase:SendAction", function(client, itemID, action)
    if client:IsRagdolling() then return end
    if client:IsSpectate() then return end

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

    if (!client.ItemActionCD or CurTime() >= client.ItemActionCD) then
        client.ItemActionCD = CurTime() + 0.3

        item.player = client
        item.entity = entity

        local actionList = item:GetValidActions()
        local actionInfo = actionList[action]
        if actionInfo then
            local actionRun = actionInfo.OnRun

            if actionRun then
                hook.Run("OnItemAction", client, item, action)
                local data = actionRun(item)

                if data != false then
                    item:Remove()
                end
            end
        end

        item.player = nil
        item.entity = nil
    end
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
        return client:ChatNotify(errNotify)
    end

    client:ChatNotify(L(client, "#notify_give_item", item:GetName(), target:Name()))

    if client != target then
        target:ChatNotify(L(target, "#notify_admin_give_item", item:GetName()))
    end
end)

netstream.Hook("ItemBase:EditItemProperties", function(client, itemID, data)
    if !client:IsAdmin() then return end

    local item = ItemBase.instances[itemID]
    if !item then return end

    local entity = item:GetEntity()
    local info = ItemBase:GetItemProperties(item)

    for key, value in pairs(data) do
        local func = nil
        local isChange = false

        for k2, v2 in ipairs(info) do
            if v2[1] == key then
                func = v2[4]
                local oldValue = v2[3](item)

                if oldValue != value then
                    isChange = true
                end

                break
            end
        end

        if !isChange then continue end

        item:SetData("m_" .. key, value)
        if func then
            func(item, entity, value)
        end
    end
end)

local function getInfo(data)
    local info = {
        name = data.name or "Не указано",
        description = data.description or "Не указано",
        model = data.model or "models/props_junk/PlasticCrate01a.mdl",
        icon = data.icon or "danganronpa/inventory/items/antiquebooktest.png"
    }

    local uniqueID = data.uniqueID
    if !uniqueID then return end

    local baseID = data.base
    local example = nil

    if baseID == ItemBase.defaultBaseID then
        example = {
            {
                variable = "category",
                title = "Категория",
                default = "Остальное"
            }
        }
    else
        local itemBase = ItemBase.base[baseID]
        if !itemBase then return end

        example = itemBase.creationExample
    end

    if !example then return end

    for k, v in ipairs(example) do
        info[v.variable] = data[v.variable] or v.default
    end

    return baseID, tostring(uniqueID), info
end

netstream.Hook("ItemBase:CreationRegisterItem", function(client, data)
    if !client:IsAdmin() then return end

    local baseID, uniqueID, info = getInfo(data)

    local itemslist = asterionlib.data:Get("itemslist", {}, true)
    itemslist[baseID] = itemslist[baseID] or {}

    if itemslist[baseID][uniqueID] or ItemBase.list[uniqueID] then
        return client:ChatNotify("Предмет с ID " .. uniqueID .. " уже существует!")
    end

    itemslist[baseID][uniqueID] = info

    asterionlib.data:Set("itemslist", itemslist)
    ItemBase.CreationRegisterItem(baseID, uniqueID, info)

    client:ChatNotify("Предмет " .. uniqueID .. " успешно был создан! (Чтобы обновить список предметов в Q меню, пропишите в консоль: spawnmenu_reload)")
    AdminNotify:SendNotify("registeritem", client:FullName(), uniqueID)
end)

netstream.Hook("ItemBase:CreationEditItem", function(client, data)
    if !client:IsAdmin() then return end

    local baseID, uniqueID, info = getInfo(data)

    local itemslist = asterionlib.data:Get("itemslist", {}, true)
    itemslist[baseID] = itemslist[baseID] or {}

    if !itemslist[baseID][uniqueID] then
        return client:ChatNotify("Предмет с ID " .. uniqueID .. " не существует!")
    end

    if !client:IsSuperAdmin() and itemslist[baseID][uniqueID].isprotect then
        return client:ChatNotify("Предмет с ID " .. uniqueID .. " защищен!")
    end

    info.isprotect = false

    itemslist[baseID][uniqueID] = info

    asterionlib.data:Set("itemslist", itemslist)
    ItemBase.CreationEditItem(uniqueID, info)

    client:ChatNotify("Предмет " .. uniqueID .. " успешно был обновлен! (Чтобы обновить список предметов в Q меню, пропишите в консоль: spawnmenu_reload)")
    AdminNotify:SendNotify("edititem", client:FullName(), uniqueID)
end)

netstream.Hook("ItemBase:CreationRemoveItem", function(client, baseID, uniqueID)
    if !client:IsAdmin() then return end

    uniqueID = tostring(uniqueID)

    local itemslist = asterionlib.data:Get("itemslist", {}, true)
    itemslist[baseID] = itemslist[baseID] or {}

    if !itemslist[baseID][uniqueID] then
        return client:ChatNotify("Предмет с ID " .. uniqueID .. " не существует!")
    end

    if !client:IsSuperAdmin() and itemslist[baseID][uniqueID].isprotect then
        return client:ChatNotify("Предмет с ID " .. uniqueID .. " защищен!")
    end

    itemslist[baseID][uniqueID] = nil

    asterionlib.data:Set("itemslist", itemslist)
    ItemBase.CreationRemoveItem(uniqueID)

    client:ChatNotify("Предмет " .. uniqueID .. " успешно был удален! (Чтобы обновить список предметов в Q меню, пропишите в консоль: spawnmenu_reload)")
    AdminNotify:SendNotify("removeitem", client:FullName(), uniqueID)
end)

netstream.Hook("ItemBase:CreationProtectItem", function(client, baseID, uniqueID)
    if !client:IsSuperAdmin() then return end

    uniqueID = tostring(uniqueID)

    local itemslist = asterionlib.data:Get("itemslist", {}, true)
    itemslist[baseID] = itemslist[baseID] or {}

    local info = itemslist[baseID][uniqueID]
    if !info then
        return client:ChatNotify("Предмет с ID " .. uniqueID .. " не существует!")
    end

    if info.isprotect == nil then
        info.isprotect = false
    end

    info.isprotect = !info.isprotect

    asterionlib.data:Set("itemslist", itemslist)
    ItemBase.CreationProtectItem(uniqueID, info.isprotect)

    client:ChatNotify("На предмет " .. uniqueID .. " была " .. (info.isprotect and "установлена" or "снята") .. " защита!")
    AdminNotify:SendNotify("protectitem", client:FullName(), uniqueID)
end)