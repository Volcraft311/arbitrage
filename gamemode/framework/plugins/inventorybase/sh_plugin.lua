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

PLUGIN.name = "InventoryBase"
InventoryBase = PLUGIN

PLUGIN.instances = PLUGIN.instances or {}
PLUGIN.lastID = PLUGIN.lastID or 1

function InventoryBase:New(id, w, h)
    if self.instances[id] and self.instances[id].w == w and self.instances[id].h == h then
        return self.instances[id]
    end

    local inventoryData = table.Copy(FindMetaTable("Inventory"))
    local inventory = setmetatable({id = id}, inventoryData)

    inventory.w = w or 4
    inventory.h = h or 2

    for x = 1, inventory.w do
        inventory.slots[x] = inventory.slots[x] or {}
    end

    self.instances[id] = inventory
    return inventory
end

function InventoryBase.CreateInventory(w, h)
    local inventory = InventoryBase:New(InventoryBase.lastID, w, h)
    InventoryBase.lastID = InventoryBase.lastID + 1

    return inventory
end

local metaEntity = FindMetaTable("Entity")
function metaEntity:GetInventory()
    return self.Inventory
end

Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("sh_meta.lua")
Arbitrage.base.Include("sv_plugin.lua")