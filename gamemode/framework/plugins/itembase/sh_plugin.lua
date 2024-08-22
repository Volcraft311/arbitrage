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

PLUGIN.name = "ItemBase"
ItemBase = PLUGIN

PLUGIN.list = PLUGIN.list or {}
PLUGIN.base = PLUGIN.base or {}
PLUGIN.instances = PLUGIN.instances or {}
PLUGIN.lastID = PLUGIN.lastID or 1
PLUGIN.data = PLUGIN.data or {}

PLUGIN.defaultBaseID = "basic"

function ItemBase.GetBase(base)
    local meta = table.Copy(Arbitrage.meta.item)

    meta:AddAction("Выбросить", {
        icon = "icon16/brick_delete.png",
        OnRun = function(item)
            if Arbitrage.lawEnable then return false end

            local client = item.player
            client:PlayAnimation(GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_ITEM_DROP, true)

            item._oldInventory = client:GetInventory() -- нужно для получения старого инвентаря если запускается с контейнера
            item:Transfer(nil)
            item._oldInventory = nil

            for k, v in ipairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.5)) do
                TypingDraw:SetTypingText(v, client, "Выкидывает '" .. item:GetName() .. "'", Color(255, 170, 23))
            end

            return false
        end,
        OnCanRun = function(item)
            return !IsValid(item.entity)
        end
    })

    meta:AddAction("Взять", {
        icon = "icon16/brick_add.png",
        OnRun = function(item)
            local client = item.player
            local entity = item.entity

            local eyePosZ = Arbitrage.player.GetEyesPos(client)
            eyePosZ = eyePosZ + client:GetPos().z

            local itemPosZ = entity:GetPos().z

            local dist = eyePosZ - itemPosZ
            if dist > 30 then
                client:SetAction("Pickup")
            else
                client:PlayAnimation(GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND, true)
            end

            local entityPos = entity:GetPos()
            local entityAng = entity:GetAngles()
            local entityModel = entity:GetModel()

            local notify = client:GetInventory():AddItem(item:GetID())
            if notify then
                Arbitrage.commands.Notify(client, notify)
            else
                if !item.bNoAnim then
                    ItemBase.AnimTakeItem(nil, client, entityPos, entityAng, entityModel)
                end
            end

            for k, v in ipairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.5)) do
                TypingDraw:SetTypingText(v, client, "Поднимает '" .. item:GetName() .. "'", Color(255, 170, 23))
            end

            return false
        end,
        OnCanRun = function(item)
            return IsValid(item.entity) and !item:GetData("disableTake", false)
        end
    })

    meta:AddAction("* Изменить свойства", {
        icon = "icon16/script_gear.png",
        OnRun = function(item)
            local client = item.player

            client:SendLua("ItemBase:EditProperties(" .. item:GetID() .. ")")
            return false
        end,
        OnCanRun = function(item)
            local client = item.player
            local entity = item.entity

            return client:IsAdmin() and !IsValid(entity)
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

    local itemInfo = table.Copy(self.list[uniqueID])
    if !itemInfo then return end

    local item = {id = id}
    setmetatable(item, {
        __index = itemInfo,
        __eq = itemInfo.__eq,
        __tostring = itemInfo.__tostring
    })

    self.instances[id] = item

    return item
end

ItemBase.converterBase = {
    basic = {"Без базы", "converter_basic"},
    base_medical = {"База медицины", "converter_medical"},
    base_food = {"База продуктов", "converter_food"},
    base_ammo = {"База патронов", "converter_ammo"},
    base_note = {"База блокнотов", "converter_note"},
    base_picklock = {"База отмычек", "converter_picklock"},
    base_weapon = {"База оружий", "converter_weapon"},
    base_stack = {"База Стакающихся Предметов", "converter_stack"},
}

-- a - item
-- b - entity
-- c - args
function ItemBase:GetItemProperties(item)
    local info = {
        {"name", "Название", function(a)
            return a:GetName()
        end},
        {"description", "Описание", function(a)
            return a:GetDescription()
        end},
        {"category", "Категория", function(a)
            return a:GetCategory()
        end},
        {"icon", "Иконка", function(a)
            return a:GetIcon()
        end},
        {"model", "Модель", function(a)
            return a:GetModel()
        end, function(a, b, c)
            if !IsValid(b) then return end

            b:SetModel(c)
            b:PhysicsInit(SOLID_VPHYSICS)
            b:SetSolid(SOLID_VPHYSICS)

            local physObj = b:GetPhysicsObject()
            if !IsValid(physObj) then
                b:PhysicsInitBox(invalidBoundsMin, invalidBoundsMax)
                b:SetCollisionBounds(invalidBoundsMin, invalidBoundsMax)
            else
                physObj:EnableMotion(true)
                physObj:Wake()
            end
        end}
    }

    local base = item.base
    if base and base != "" and base != " " and base != "basic" then
        local itemBase = self.base[base]

        if itemBase then
            local properties = itemBase.propertiesInfo or {}

            table.Add(info, properties)
        end
    end

    return info
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

properties.Add("item_properties", {
    MenuLabel = "Изменить свойства",
    Order = 90002,
    MenuIcon = "icon16/script_gear.png",
    Filter = function(self, entity, ply)
        if !IsValid(entity) then return false end

        return entity:GetClass() == "arb_item"
    end,
    Action = function(self, entity)
        ItemBase:EditProperties(entity:GetItemID())
    end
})

Arbitrage.base.Include("cl_infomenu.lua")
Arbitrage.base.Include("cl_actionmenu.lua")
Arbitrage.base.Include("cl_plugin.lua")
Arbitrage.base.Include("cl_itemlist.lua")
Arbitrage.base.Include("sh_meta.lua")
Arbitrage.base.Include("sv_plugin.lua")


Arbitrage.base.Include("base/base_ammo.lua", "shared")
Arbitrage.base.Include("base/base_food.lua", "shared")
Arbitrage.base.Include("base/base_medical.lua", "shared")
Arbitrage.base.Include("base/base_note.lua", "shared")
Arbitrage.base.Include("base/base_picklock.lua", "shared")
Arbitrage.base.Include("base/base_weapon.lua", "shared")
Arbitrage.base.Include("base/base_stack.lua", "shared")

Arbitrage.base.Include("items/sh_list.lua")
Arbitrage.base.Include("items/sh_other.lua")