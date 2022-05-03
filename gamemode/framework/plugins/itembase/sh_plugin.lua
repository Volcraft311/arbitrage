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

function ItemBase.GetBase(base)
    local meta = table.Copy(Arbitrage.meta.item)

    meta:AddAction("Выбросить", {
        OnRun = function(item)
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