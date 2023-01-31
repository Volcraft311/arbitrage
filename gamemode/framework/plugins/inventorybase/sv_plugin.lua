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

-- function PLUGIN:PlayerInitialSpawn(client)
    -- local inventory = InventoryBase.CreateInventory()

    -- inventory:SetOwner(client)
-- end

function InventoryBase.Open(client, id, name)
    local inventory = InventoryBase.instances[id]
    if !inventory then return end

    inventory.receivers[client] = true

    inventory:Sync(client)
    netstream.Start(client, "InventoryBase:OpenInventory", id, name)
end

function InventoryBase:PlayerDeath(client)
    local inventory = client:GetInventory()
    if !inventory then return end

    local items = inventory:GetItems()
    for k, v in pairs(items) do
        if v:GetData("equip") then
            v:UnEquip(client, v)
            v:Transfer(nil)

            local entity = v:GetEntity()
            if IsValid(entity) then
                entity:SetPos(client:GetShootPos())
            end
        end
    end


    local itemsAmmo = {}
    for k, v in pairs(ItemBase.list) do
        if v.base == "base_ammo" then
            itemsAmmo[string.lower(v.ammoClass)] = k
        end
    end

    local ammo = client:GetAmmo()
    for id, count in pairs(ammo) do
        local name = game.GetAmmoName(id)
        if !name then continue end

        local uniqueID = itemsAmmo[string.lower(name)]
        if !uniqueID then continue end

        local item = ItemBase.CreateItemInWorld(uniqueID, client:GetShootPos(), Angle(0, 0, 0))
        if !item then continue end

        item:SetData("amount", count)
    end
end

function InventoryBase:OnCreateDisconnectEntity(client)
    local inventory = client:GetInventory()
    if !inventory then return end

    local items = inventory:GetItems()

    for k, v in pairs(items) do
        if v:GetData("equip") then
            v:UnEquip(client, v)
        end
    end
end

netstream.Hook("InventoryBase:GetActions", function(client, itemID)
    if client:IsSpectate() then return end

    local item = ItemBase.instances[itemID]
    if !item then return end

    local data = {}

    item.player = client
    for k, v in pairs(item:GetValidActions()) do
        data[#data + 1] = k
    end
    item.player = nil

    netstream.Start(client, "InventoryBase:OpenActions", itemID, data)
end)

netstream.Hook("InventoryBase:TransferItem", function(client, itemID, invID, x, y)
    if client:IsSpectate() then return end

    local item = ItemBase.instances[itemID]
    if !item then return end

    local inventoryItem = item:GetInventory()
    if !inventoryItem then return end
    if !inventoryItem:IsReceiver(client) then return end

    local inventoryTransfer = InventoryBase.instances[invID]
    if !inventoryTransfer then return end
    if !inventoryTransfer:IsReceiver(client) then return end

    local errNotify = item:Transfer(invID, x, y)

    if errNotify then
        return Arbitrage.commands.Notify(client, errNotify)
    end
end)

netstream.Hook("InventoryBase:StopReceiving", function(client, invID)
    local inventory = InventoryBase.instances[invID]
    if !inventory then return end

    inventory.receivers[client] = nil
end)

netstream.Hook("InventoryBase:EquipItem", function(client, slotID, itemID)
    if client:IsSpectate() then return end

    local item = ItemBase.instances[itemID]
    if !item then return end

    local inventory = item:GetInventory()
    if !inventory then return end

    if !inventory:IsReceiver(client) then return end

    local data = client:GetLocalVar("fast_slot_" .. slotID)

    if !item.UnEquip or !item.Equip then return Arbitrage.commands.Notify(client, "Этот предмет нельзя экипировать!") end

    item:UnEquip(client, item)

    local eqItem = nil
    if data and data[2] then
        eqItem = ItemBase.instances[data[2]]
    end

    if eqItem and item != eqItem then
        eqItem:UnEquip(client, eqItem)
    end

    if !data or data[2] != itemID then
        item:Equip(client, item, slotID)
    end
end)

netstream.Hook("Inventory:UnequipAmmo", function(client, id, amount)
    if client:IsSpectate() then return end

    local inventory = client:GetInventory()
    if !inventory then return end

    local ammoCount = client:GetAmmo()[id]
    if !ammoCount then return end

    amount = math.Clamp(amount, 0, ammoCount)
    if amount <= 0 then return end

    local itemsAmmo = {}
    for k, v in pairs(ItemBase.list) do
        if v.base == "base_ammo" then
            itemsAmmo[string.lower(v.ammoClass)] = k
        end
    end

    local name = game.GetAmmoName(id)
    if !name then return end

    local uniqueID = itemsAmmo[string.lower(name)]
    if !uniqueID then return end

    local item = ItemBase.CreateItem(uniqueID)
    item:SetData("amount", amount)

    local notify = item:Transfer(inventory:GetID())
    if notify then
        item:Spawn(client:GetPos() + Vector(0, 0, 20))
    end

    client:RemoveAmmo(amount, name)
    client:ChatNotify("Вы успешно вытащили " .. amount .. " патрон из запаса для " .. name .. "!")
end)