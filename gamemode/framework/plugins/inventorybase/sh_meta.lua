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


local INVENTORY = {}
INVENTORY.__index = INVENTORY
INVENTORY.slots = INVENTORY.slots or {}
INVENTORY.w = INVENTORY.w or 4
INVENTORY.h = INVENTORY.h or 2
INVENTORY.id = INVENTORY.id or 0
INVENTORY.owner = INVENTORY.owner or NULL
INVENTORY.receivers = INVENTORY.receivers or {}

function INVENTORY:__tostring()
    return "inventory[" .. self.id .. "]"
end

function INVENTORY:__eq(other)
    return self:GetID() == other:GetID()
end

function INVENTORY:GetID()
    return self.id
end

function INVENTORY:SetSize(w, h)
    self.w = w
    self.h = h
end

function INVENTORY:GetSize()
    return self.w, self.h
end

function INVENTORY:SetOwner(entity)
    if !IsValid(entity) then return end

    entity.Inventory = self
    self.owner = entity
end

function INVENTORY:GetOwner()
    return self.owner
end

function INVENTORY:FindEmptySlot(w, h)
    w = w or 1
    h = h or 1

    for y = 1, self.h - (h - 1) do
        for x = 1, self.w - (w - 1) do
            if !self:GetItemAt(x, y) then
                return x, y
            end
        end
    end
end

function INVENTORY:GetItemAt(x, y)
    return self.slots[x][y]
end

function INVENTORY:GetItemSlot(id)
    for x = 1, self.w do
        for y = 1, self.h do
            local item = self:GetItemAt(x, y)

            if item and item:GetID() == id then
                return x, y
            end
        end
    end
end

function INVENTORY:GetItems()
    local data = {}

    for x = 1, self.w do
        for y = 1, self.h do
            local item = self:GetItemAt(x, y)

            if item then
                data[#data + 1] = item
            end
        end
    end

    return data
end

function INVENTORY:HasItem(id)
    for k, v in ipairs(self:GetItems()) do
        if v:GetID() == id then
            return true
        end
    end
end

function INVENTORY:GetReceivers()
    local data = {}

    local owner = self:GetOwner()
    if owner then
        data[#data + 1] = owner
    end

    for receiver in pairs(self.receivers) do
        data[#data + 1] = receiver
    end

    return data
end

function INVENTORY:IsReceiver(entity)
    for id, receiver in ipairs(self:GetReceivers()) do
        if receiver == entity then
            return true
        end
    end

    return false
end

if SERVER then
    function INVENTORY:AddItem(id)
        local item = ItemBase.instances[id]
        if !item then return end

        return item:Transfer(self:GetID())
    end

    function INVENTORY:Sync(client)
        local itemsData = {}
        local invData = {}

        for x = 1, self.w do
            invData[x] = invData[x] or {}

            for y = 1, self.h do
                local item = self:GetItemAt(x, y)

                if item then
                    local id = item:GetID()
                    local uniqueID = item.uniqueID
                    local data = ItemBase.data[id] or {}

                    invData[x][y] = id
                    itemsData[id] = {
                        uniqueID,
                        data
                    }
                end
            end
        end

        local function sync(pl)
            netstream.Start(pl, "InventoryBase:SyncInventory", self.id, self.w, self.h, invData, itemsData, self.owner)
        end

        if IsValid(client) then
            sync(client)
        end

        for id, receiver in ipairs(self:GetReceivers()) do
            if IsValid(receiver) and receiver:IsPlayer() and client != receiver then
                sync(receiver)
            end
        end
    end
end


debug.getregistry().Inventory = INVENTORY