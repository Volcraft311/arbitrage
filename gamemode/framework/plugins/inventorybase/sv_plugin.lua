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

    hook.Run("OnInventoryOpen", client, inventory)
end

function InventoryBase:PlayerDeath(client)
    local inventory = client:GetInventory()
    if !inventory then return end

    local items = inventory:GetItems()
    for k, v in pairs(items) do
        if v:GetData("equip") then
            v:UnEquip(client, v)

            v.bNoAnim = true
                v:Transfer(nil)
            v.bNoAnim = nil

            local entity = v:GetEntity()
            if IsValid(entity) then
                local shootPos = client:GetShootPos()
                local aimVector = client:GetAimVector()

                entity:SetPos(shootPos + (aimVector * 32))

                local physObj = entity:GetPhysicsObject()
                if IsValid(physObj) then
                    physObj:SetVelocity(physObj:GetVelocity() + aimVector * 128)
                end
            end
        end
    end


    local itemsAmmo = {}
    for k, v in pairs(ItemBase.list) do
        if v.base == "base_ammo" and v.uniqueID != "converter_ammo" then
            itemsAmmo[v.ammoClass:lower()] = k
        end
    end

    local ammo = client:GetAmmo()
    for id, count in pairs(ammo) do
        local name = game.GetAmmoName(id)
        if !name then continue end

        local uniqueID = itemsAmmo[name:lower()]
        if !uniqueID then continue end

        local item = ItemBase.CreateItemInWorld(uniqueID, client:GetShootPos(), Angle(0, 0, 0))
        if !item then continue end

        item:SetData("amount", count)
    end
end

hook("OnCreateDisconnectEntity", function(client)
    local inventory = client:GetInventory()
    if !inventory then return end

    local items = inventory:GetItems()

    for k, v in pairs(items) do
        if v:GetData("equip") then
            v:UnEquip(client, v)
        end
    end
end)

netstream.Hook("InventoryBase:GetActions", function(client, itemID)
    if client:IsSpectate() then return end

    local item = ItemBase.instances[itemID]
    if !item then return end

    local data = {}

    item.player = client
    for k, v in pairs(item:GetValidActions()) do
        data[#data + 1] = {k, v.icon}
    end
    item.player = nil

    netstream.Start(client, "InventoryBase:OpenActions", itemID, data)
end)

netstream.Hook("InventoryBase:TransferItem", function(client, itemID, invID, x, y)
    if client:IsRagdolling() then return end
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
    else
        local inventoryPlayer = inventoryTransfer:GetOwner()

        if IsValid(inventoryPlayer) and inventoryPlayer:IsPlayer() then
            inventoryPlayer:PlaySequence("get_item")
        end
    end
end)

netstream.Hook("InventoryBase:StopReceiving", function(client, invID)
    local inventory = InventoryBase.instances[invID]
    if !inventory then return end

    inventory.receivers[client] = nil
    hook.Run("InventoryBase:StopReceiving", client, invID)
end)

netstream.Hook("InventoryBase:EquipItem", function(client, slotID, itemID)
    if client:IsRagdolling() then return end
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
    if client:IsRagdolling() then return end
    if client:IsSpectate() then return end

    local inventory = client:GetInventory()
    if !inventory then return end

    local ammoCount = client:GetAmmo()[id]
    if !ammoCount then return end

    amount = math.floor(amount)
    amount = math.Clamp(amount, 0, ammoCount)
    if amount <= 0 then return end

    local itemsAmmo = {}
    for k, v in pairs(ItemBase.list) do
        if v.base == "base_ammo" and v.uniqueID != "converter_ammo" then
            itemsAmmo[v.ammoClass:lower()] = k
        end
    end

    local name = game.GetAmmoName(id)
    if !name then return end

    local uniqueID = itemsAmmo[name:lower()]
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

netstream.Hook("InventoryBase:ItemUnStack", function(client, itemID, invID, value, x, y)
    if client:IsRagdolling() then return end
    if client:IsSpectate() then return end

    local item = ItemBase.instances[itemID]
    if !item then return end

    local inventoryItem = item:GetInventory()
    if !inventoryItem then return end
    if !inventoryItem:IsReceiver(client) then return end

    local inventoryTransfer = InventoryBase.instances[invID]
    if !inventoryTransfer then return end
    if !inventoryTransfer:IsReceiver(client) then return end

    if inventoryTransfer:GetItemAt(x, y) then return end

    local funcUnStackValue = item.UnStackValue
    if !funcUnStackValue then return end

    value = math.floor(value)

    local maxValue = funcUnStackValue(item)
    if !maxValue then return end
    if maxValue <= 0 then return end
    if value > maxValue then return end

    local funcUnStack = item.UnStack
    if !funcUnStack then return end

    funcUnStack(item, value, inventoryTransfer, x, y)
end)

netstream.Hook("InventoryBase:ItemStack", function(client, itemID, itemID2)
    if client:IsRagdolling() then return end
    if client:IsSpectate() then return end

    if itemID == itemID2 then return end

    local item = ItemBase.instances[itemID]
    if !item then return end

    local inventoryItem = item:GetInventory()
    if !inventoryItem then return end
    if !inventoryItem:IsReceiver(client) then return end

    local item2 = ItemBase.instances[itemID2]
    if !item2 then return end

    local inventoryItem2 = item2:GetInventory()
    if !inventoryItem2 then return end
    if !inventoryItem2:IsReceiver(client) then return end

    local funcStack = item.Stack
    if !funcStack then return end

    funcStack(item, item2)
end)

netstream.Hook("Inventory:OpenMenu", function(client)
    TypingDraw:SendSphere(0.5, client, "Осматривает карманы", Color(255, 170, 23))
end)