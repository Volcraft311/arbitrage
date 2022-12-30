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

PLUGIN.name = "ItemBase"
ItemBase = PLUGIN

PLUGIN.list = PLUGIN.list or {}
PLUGIN.base = PLUGIN.base or {}
PLUGIN.instances = PLUGIN.instances or {}
PLUGIN.lastID = PLUGIN.lastID or 1
PLUGIN.data = PLUGIN.data or {}

PLUGIN.defaultBaseID = "basic"

function ItemBase.GetBase(base)
    local meta = table.Copy(FindMetaTable("Item"))

    meta:AddAction("Выбросить", {
        OnRun = function(item)
            if Arbitrage.lawEnable then return false end

            local client = item.player
            client:PlayAnimation(GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_ITEM_DROP, true)

            item:Transfer(nil)
            return false
        end,
        OnCanRun = function(item)
            return !IsValid(item.entity)
        end
    })

    meta:AddAction("Взять", {
        OnRun = function(item)
            local client = item.player
            local entity = item.entity

            local eyePosZ = Arbitrage.player.GetEyesPos(client).z
            eyePosZ = eyePosZ + client:GetPos().z

            local itemPosZ = entity:GetPos().z

            local dist = eyePosZ - itemPosZ
            if dist > 30 then
                client:SetAction("Pickup")
            else
                client:PlayAnimation(GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND, true)
            end

            local notify = client:GetInventory():AddItem(item:GetID())
            if notify then
                Arbitrage.commands.Notify(client, notify)
            end

            return false
        end,
        OnCanRun = function(item)
            return IsValid(item.entity) and !item:GetData("disableTake", false)
        end
    })

    if base then
        local baseInfo = table.Copy(ItemBase.base[base])
        if baseInfo then
            baseInfo.__index = nil

            for k, v in pairs(baseInfo) do
                meta[k] = v
            end

            meta.base = base
        end
    end

    return meta
end

function ItemBase:RegisterItem(uniqueID, data)
    local meta = data
    meta.uniqueID = uniqueID

    self.list[uniqueID] = meta
end

function ItemBase:RegisterBase(uniqueID, data)
    local meta = data
    meta.uniqueID = uniqueID

    self.base[uniqueID] = meta
end

function ItemBase:New(uniqueID, id)
    if self.instances[id] and self.instances[id].uniqueID == uniqueID then
        return self.instances[id]
    end

    local itemData = table.Copy(self.list[uniqueID])

    if itemData then
        local item = setmetatable({id = id}, {
            __index = itemData,
            __eq = itemData.__eq,
            __tostring = itemData.__tostring
        })

        self.instances[id] = item

        return item
    end
end

function ItemBase.CreateItem(uniqueID)
    local item = ItemBase:New(uniqueID, ItemBase.lastID)
    ItemBase.lastID = ItemBase.lastID + 1

    return item
end


function ItemBase.CreationRegisterItem(baseID, uniqueID, info)
    uniqueID = tostring(uniqueID)

    local ITEM = ItemBase.GetBase(baseID == ItemBase.defaultBaseID and "" or baseID)
    ITEM.isCreation = true

    for k, v in pairs(info) do
        ITEM[k] = v
    end

    ItemBase:RegisterItem(uniqueID, ITEM)

    if SERVER then
        netstream.Start(nil, "ItemBase:CreationRegisterItem", baseID, uniqueID, info)
    end

    do
        local item = ItemBase.list[uniqueID]
        hook.Run("CreationInitItem", item)
    end
end

function ItemBase.CreationEditItem(uniqueID, info)
    uniqueID = tostring(uniqueID)

    local ITEM = ItemBase.list[uniqueID]
    if !ITEM then return end

    for k, v in pairs(info) do
        ITEM[k] = v
    end

    for k, v in pairs(ItemBase.instances) do
        if v.uniqueID == uniqueID then
            for k2, v2 in pairs(info) do
                v[k2] = v2
            end
        end
    end

    if SERVER then
        netstream.Start(nil, "ItemBase:CreationEditItem", uniqueID, info)
    end
end

function ItemBase.CreationRemoveItem(uniqueID)
    uniqueID = tostring(uniqueID)

    if SERVER then
        -- удаляем все предметы на карте с этим ID
        for k, v in ipairs(ents.FindByClass("arb_item" )) do
            if v:GetUniqueID() == uniqueID then
                v:Remove()
            end
        end

        -- чистим инвентари
        if InventoryBase then
            for k, v in pairs(InventoryBase.instances) do
                local items = v:GetItems()

                for k2, v2 in ipairs(items) do
                    if v2.uniqueID == uniqueID then
                        v2:Remove()
                    end
                end
            end
        end
    end

    -- чистим лист
    for k, v in pairs(ItemBase.instances) do
        if v.uniqueID == uniqueID then
            ItemBase.instances[k] = nil
        end
    end

    ItemBase.list[uniqueID] = nil

    if SERVER then
        netstream.Start(nil, "ItemBase:CreationRemoveItem", uniqueID)
    end
end

function ItemBase.CreationProtectItem(uniqueID, protect)
    uniqueID = tostring(uniqueID)

    local ITEM = ItemBase.list[uniqueID]
    if !ITEM then return end

    ITEM.isprotect = protect

    if SERVER then
        netstream.Start(nil, "ItemBase:CreationProtectItem", uniqueID, protect)
    end
end

Arbitrage.base.Include("cl_infomenu.lua")
Arbitrage.base.Include("cl_actionmenu.lua")
Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("cl_itemlist.lua")
Arbitrage.base.Include("sh_meta.lua")
Arbitrage.base.Include("sv_plugin.lua")

local function script_path()
    local str = debug.getinfo(2, "S").source:sub(2)
    str = str:match("(.*/)")

    str = str:gsub("gamemodes/", "")

    return str
end

do
    local f, _ = file.Find(script_path() .. "/base/*", "LUA")
    for k, v in ipairs(f) do
        Arbitrage.base.Include("base/" .. v, "shared")
    end
end

do
    local f, _ = file.Find(script_path() .. "/items/*", "LUA")
    for k, v in ipairs(f) do
        Arbitrage.base.Include("items/" .. v)
    end
end