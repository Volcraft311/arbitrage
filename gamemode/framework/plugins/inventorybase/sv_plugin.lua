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

function PLUGIN:PlayerDeath(client)
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
end

function PLUGIN:PlayerDisconnected(client)
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

netstream.Hook("InventoryBase:EquipItem", function(client, slotID, itemID)
    local item = ItemBase.instances[itemID]
    if !item then return end

    local inventory = item:GetInventory()
    if !inventory then return end

    if !inventory:IsReceiver(client) then return end

    local data = client:GetNetVar("fast_slot_" .. slotID)

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