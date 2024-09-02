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


local ITEM = {}
ITEM.__index = ITEM
ITEM.name = "База предметов"
ITEM.description = "Стандартная база для создания предметов."
ITEM.icon = "danganronpa/inventory/items/antiquebooktest.png"
ITEM.category = "Остальное"
ITEM.id = ITEM.id or 0
ITEM.model = "models/props_lab/box01a.mdl"
ITEM.uniqueID = "undefined"
ITEM.base = nil

ITEM.hooks = {}
ITEM.postHooks = {}
ITEM.functions = {}

function ITEM:__tostring()
    return "item[" .. self.uniqueID .. "][" .. self.id .. "]"
end

function ITEM:__eq(other)
    return self:GetID() == other:GetID()
end

function ITEM:Tooltip(tooltip)
    tooltip:SetTitle(self:GetName())
    tooltip:SetIcon("asterion/academy/ui/tooltip/puzzle.png")
    tooltip:SetDescription(self:GetDescription())
end

function ITEM:GetID()
    return self.id
end

function ITEM:GetUniqueID()
    return self.uniqueID
end

function ITEM:GetName()
    return self:GetData("m_name", self.name)
end

function ITEM:GetIcon()
    return self:GetData("m_icon", self.icon)
end

function ITEM:GetDescription()
    return self:GetData("m_description", self.description)
end

function ITEM:GetModel()
    return self:GetData("m_model", self.model)
end

function ITEM:GetSkin()
    return self.skin or 0
end

function ITEM:GetCategory()
    return self:GetData("m_category", self.category)
end

function ITEM:AddAction(name, data)
    self.functions[name] = data
end

function ITEM:HookAdd(name, func)
    self.hooks[name] = func
end

function ITEM:HookRun(name, ...)
    if self.hooks[name] then
        self.hooks[name](self, ...)
    end
end

function ITEM:GetValidActions()
    local data = {}

    for k, v in pairs(self.functions) do
        local bAllow = true

        if v.OnCanRun then
            bAllow = v.OnCanRun(self)
        end

        if bAllow then
            data[k] = v
        end
    end

    return data
end

function ITEM:GetEntity()
    local id = self:GetID()

    for k, v in ipairs(ents.FindByClass("arb_item")) do
        if v:GetItemID() == id then
            return v
        end
    end
end

function ITEM:GetData(key, default)
    return ItemBase.data[self:GetID()] and (ItemBase.data[self:GetID()][key] or default) or default
end

function ITEM:GetInventory()
    return self.inventory
end

if SERVER then
    function ITEM:Transfer(id, x, y)
        local inventory = InventoryBase.instances[id]
        if inventory then
            if x and y then
                local find = inventory:GetItemAt(x, y)

                if find then
                    return "Данный слот занят!"
                end
            else
                x, y = inventory:FindEmptySlot()
            end

            if !x or !y then return "Инвентарь заполнен!" end

            self:HookRun("transfer")
            self:Remove(true, true)

            inventory.slots[x][y] = self

            if !self.bNoAnim then
                local inventoryItem = self.inventory
                if inventoryItem and inventory and inventoryItem != inventory then
                    local transmitEntity = inventoryItem:GetOwner()
                    local receiverEntity = inventory:GetOwner()

                    if IsValid(transmitEntity) and IsValid(receiverEntity) then
                        ItemBase.AnimTakeItem(transmitEntity, receiverEntity, transmitEntity:GetPos(), transmitEntity:GetAngles(), self:GetModel())
                    end
                end
            end
        else
            inventory = self:GetInventory()
            if !inventory then return "Невозможно передвинуть предмет!" end

            local owner = inventory:GetOwner()
            if !IsValid(owner) then
                local newInventory = self._oldInventory

                if newInventory then
                    owner = newInventory:GetOwner()
                end
            end

            if IsValid(owner) then
                -- нужно чтобы выкидывал из контейнера игрок, а не контейнер
                if owner:GetClass() == "arb_container" then
                    local newInventory = self._oldInventory
                    if newInventory then
                        local transferOwner = newInventory:GetOwner()
                        if IsValid(transferOwner) then
                            owner = transferOwner
                        end
                    end
                end

                local dist = 100
                local tr = nil
                if owner:IsPlayer() then
                    tr = util.TraceLine({
                        start = owner:EyePos(),
                        endpos = owner:EyePos() + owner:EyeAngles():Forward() * dist,
                        filter = owner
                    })
                else
                    tr = owner:GetPos() + owner:GetAngles():Forward() * dist
                end


                self:HookRun("drop")
                self:Remove(true, true)

                local entity = self:Spawn((isvector(tr) and tr or tr.HitPos) + Vector(0, 0, 5), Angle(0, owner:IsPlayer() and owner:EyeAngles().y - 180 or owner:GetAngles().y - 180, 0))

                if !self.bNoAnim then
                    ItemBase.AnimDropItem(owner, entity:EntIndex(), entity:GetClass())
                end

                inventory = nil -- чистим инвентарь, ибо выбросили
            end
        end

        -- Синхранизация
        do
            -- Инвентарь предмета
            local inventoryItem = self.inventory or inventory
            if inventoryItem then
                inventoryItem:Sync()
            end

            -- Старый инвентарь
            local oldInventoryItem = self._oldInventory
            if oldInventoryItem and inventoryItem:GetID() != oldInventoryItem:GetID() then
                oldInventoryItem:Sync()
            end

            -- Инвентарь в который был перемещен предмет
            local inventoryTransfer = InventoryBase.instances[id]
            if inventoryTransfer and inventoryItem:GetID() != inventoryTransfer:GetID() then
                inventoryTransfer:Sync()

                if inventoryItem then
                    self:HookRun("transferOtherInventory", inventoryItem, inventoryTransfer)
                end
            end
        end

        self.inventory = inventory
    end

    function ITEM:SetData(key, value, receivers)
        if !ItemBase.instances[self:GetID()] then return end

        ItemBase.data[self:GetID()] = ItemBase.data[self:GetID()] or {}
        ItemBase.data[self:GetID()][key] = value

        local entity = self:GetEntity()
        if IsValid(entity) then
            entity.BoneMods.saveData[key] = value
        end

        netstream.Start(receivers, "ItemBase:SetData", self:GetID(), key, value)
    end

    function ITEM:Remove(bNoDelete, bNoSync)
        local entity = self:GetEntity()

        if IsValid(entity) then
            entity:Remove()
        end

        local inventory = self.inventory
        if inventory then
            local x, y = inventory:GetItemSlot(self:GetID())

            if x and y then
                inventory.slots[x][y] = nil
            end
        end

        if !bNoDelete then
            self:HookRun("remove")
            ItemBase.instances[self:GetID()] = nil
        end

        if !bNoSync and inventory then
            inventory:Sync()
        end
    end

    function ITEM:Spawn(pos, ang)
        if !ItemBase.instances[self:GetID()] then return end

        local entity = ents.Create("arb_item")
        entity:SetPos(pos)
        entity:SetAngles(ang or Angle(0, 0, 0))
        entity:Spawn()

        entity:SetItem(self:GetID())
        self:Sync()

        return entity
    end

    function ITEM:Sync(receivers)
        local data = ItemBase.data[self:GetID()] or {}

        netstream.Start(receivers, "ItemBase:SyncItem", self.uniqueID, self:GetID(), data)
    end
end


Arbitrage.meta.item = ITEM