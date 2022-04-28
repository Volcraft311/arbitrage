local PLUGIN = PLUGIN

PLUGIN.name = "InventoryBase"
InventoryBase = PLUGIN

PLUGIN.instances = PLUGIN.instances or {}
PLUGIN.lastID = PLUGIN.lastID or 1

function InventoryBase:New(id, w, h)
    if self.instances[id] and self.instances[id].w == w and self.instances[id].h == h then
        return self.instances[id]
    end

    local inventoryData = table.Copy(Arbitrage.meta.inventory)

    if inventoryData then
        local inventory = setmetatable({id = id}, {
            __index = inventoryData,
            __eq = inventoryData.__eq,
            __tostring = inventoryData.__tostring
        })

        inventory.w = w or 4
        inventory.h = h or 2

        for x = 1, inventory.w do
            inventory.slots[x] = inventory.slots[x] or {}
        end

        self.instances[id] = inventory

        return inventory
    end
end

function InventoryBase.CreateInventory(w, h)
    local inventory = InventoryBase:New(InventoryBase.lastID, w, h)
    InventoryBase.lastID = InventoryBase.lastID + 1

    return inventory
end

local meta = FindMetaTable("Entity")

function meta:GetInventory()
    return self.Inventory
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sh_meta.lua")
Arbitrage.base.Include("sv_plugin.lua")