--[[
        © AsterionStaff 2024.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local BASE = ItemBase.GetBase()

BASE.name = "База Рюкзаков"
BASE.description = ""
BASE.category = "Рюкзаки"
BASE.maxw = 4
BASE.maxh = 4

BASE.creationExample = {
    {
        variable = "category",
        title = "Категория",
        default = "Рюкзаки"
    },
    {
        variable = "maxw",
        title = "Размер рюкзака по ширине",
        default = 4
    },
    {
        variable = "maxh",
        title = "Размер рюкзака по высоте",
        default = 4
    }
}

BASE.propertiesInfo = {
    {"maxuse", "Размер рюкзака по ширине", function(item)
        return item:GetMaxWidth()
    end, function(item, entity, value)
        local inventory = item:GetBagInventory()

        inventory:SetSize(tonumber(value), inventory.h)
    end},
    {"hunger", "Размер рюкзака по высоте", function(item)
        return item:GetMaxHeight()
    end, function(item, entity, value)
        local inventory = item:GetBagInventory()

        inventory:SetSize(inventory.w, tonumber(value))
    end}
}

function BASE:Tooltip(tooltip)
    tooltip:SetTitle(self:GetName())
    tooltip:SetDescription(self:GetDescription())
    tooltip:SetIcon("asterion/academy/ui/tooltip/container.png")
end

function BASE:GetMaxWidth()
    return self:GetData("m_maxw", self.maxw)
end

function BASE:GetMaxHeight()
    return self:GetData("m_maxh", self.maxh)
end

function BASE:CreateInventory()
    self.bag_inventory = InventoryBase.CreateInventory(self:GetMaxWidth(), self:GetMaxHeight())
    self.bag_inventory.OnItemTransfer = function(inventory, item)
        if item.base == "base_bag" then
            return false, "Запрещено перемещать рюкзак в рюкзак!"
        end
    end
end

function BASE:GetBagInventory()
    if !self.bag_inventory then
        self:CreateInventory()
    end

    return self.bag_inventory
end

function BASE:OnDuplicateCopy(entity)
    local inventory = self:GetBagInventory()

    local items = {}
    for x = 1, inventory.w do
        for y = 1, inventory.h do
            local item = inventory:GetItemAt(x, y)

            if item then
                items[#items + 1] = {item:GetUniqueID(), x, y, ItemBase.data[item:GetID()], item.data}
            end
        end
    end

    entity.BoneMods.bag_duplicate = {
        w = inventory.w,
        h = inventory.h,
        items = items
    }

    return entity.BoneMods.bag_duplicate
end

function BASE:OnDuplicatePaste(entity, info)
    if !self.bag_inventory then
        self:CreateInventory()
    end

    info = info or entity.BoneMods.bag_duplicate
    if !info then return end

    self.bag_inventory:SetSize(info.w, info.h)

    for _, v in ipairs(info.items) do
        local uniqueID, x, y, saveData, customData = v[1], v[2], v[3], v[4], v[5]

        local item = ItemBase.CreateItem(uniqueID)
        if item then
            for key, value in pairs(saveData or {}) do
                item:SetData(key, value)
            end

            if customData then
                item.data = customData
            end

            item:Transfer(self.bag_inventory:GetID(), x, y)
        end
    end
end

BASE:AddAction("Открыть", {
    icon = "icon16/package.png",
    OnRun = function(item)
        local client = item.player
        local inventory = item:GetBagInventory()

        InventoryBase.Open(item.player, inventory:GetID(), item:GetName())

        for k, v in ipairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.5)) do
            TypingDraw:SetTypingText(v, client, "Осматривает содержимое '" .. item:GetName()  .. "'", Color(255, 170, 23))
        end

        return false
    end,
    OnCanRun = function(item)
        return true
    end
})

ItemBase:RegisterBase("base_bag", BASE)