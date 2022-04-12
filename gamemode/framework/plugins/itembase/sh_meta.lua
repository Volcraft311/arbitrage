local ITEM = Arbitrage.meta.item or {}
ITEM.__index = ITEM
ITEM.name = "Неизвестно"
ITEM.description = "Не указано"
ITEM.category = "Остальное"
ITEM.id = ITEM.id or 0
ITEM.model = "models/props_lab/box01a.mdl"
ITEM.uniqueID = "undefined"

ITEM.hooks = {}
ITEM.postHooks = {}
ITEM.functions = {}

function ITEM:__tostring()
    return "item[" .. self.uniqueID .. "][" .. self.id .. "]"
end

function ITEM:__eq(other)
    return self:GetID() == other:GetID()
end

function ITEM:GetID()
    return self.id
end
ITEM.ID = ITEM.GetID

function ITEM:GetName()
    return self.name
end
ITEM.Name = ITEM.GetName

function ITEM:GetDescription()
    return self.description
end
ITEM.Description = ITEM.GetDescription

function ITEM:GetModel()
    return self.model
end
ITEM.Model = ITEM.GetModel

function ITEM:GetSkin()
    return self.skin or 0
end
ITEM.Skin = ITEM.GetSkin

function ITEM:AddAction(name, data)
    self.functions[name] = data
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

if SERVER then
    function ITEM:SetData(key, value, receivers)
        if !ItemBase.instances[self:GetID()] then return end

        ItemBase.data[self:GetID()] = ItemBase.data[self:GetID()] or {}
        ItemBase.data[self:GetID()][key] = value

        netstream.Start(receivers, "ItemBase:SetData", self:GetID(), key, value)
    end

    function ITEM:Remove(bNoDelete)
        local entity = self:GetEntity()

        if IsValid(entity) then
            entity:Remove()
        end

        if !bNoDelete then
            ItemBase.instances[self:GetID()] = nil
        end
    end

    function ITEM:Spawn(pos, ang)
        if !ItemBase.instances[self:GetID()] then return end

        local entity = ents.Create("arb_item")
        entity:SetPos(pos)
        entity:SetAngles(ang or Angle(0, 0, 0))
        entity:Spawn()

        entity:SetItem(self:GetID())

        return entity
    end
end


Arbitrage.meta.item = ITEM