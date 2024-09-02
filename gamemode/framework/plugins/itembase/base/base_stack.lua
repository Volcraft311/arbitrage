--[[
        © AsterionStaff 2023.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local BASE = ItemBase.GetBase()

BASE.name = "База Стакающийся Предметов"
BASE.description = ""
BASE.category = "Стакающийся"
BASE.maxstack = 10
BASE.stackdefault = 1

BASE.creationExample = {
    {
        variable = "category",
        title = "Категория",
        default = "Стакающийся"
    },
    {
        variable = "maxstack",
        title = "Максимальное количество стаком",
        default = 10
    },
    {
        variable = "stackdefault",
        title = "Количество стандартно",
        default = 1
    }
}

BASE.propertiesInfo = {
    {"maxstack", "Максимальное количество стаком", function(a)
        return a:GetMaxStack()
    end},
    {"stack", "Количество", function(a)
        return a:GetStack()
    end, function(a, b, c)
        a:SetData("stack", tonumber(c))
        a:SetData("m_stack", nil)
    end}
}

if CLIENT then
    function BASE:Paint(item, w, h)
        if !item:GetData("equip") then
            local amount = item:GetStack()

            draw.SimpleTextOutlined(amount, "DermaDefault", w - 5, h - 15, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, color_black)
        end
    end
end

function BASE:Tooltip(tooltip)
    tooltip:SetTitle(self:GetName())
    tooltip:SetDescription(self:GetDescription())
    tooltip:SetIcon("asterion/academy/ui/tooltip/bag.png")
    tooltip:AddSubMenu("Количество: " .. self:GetStack() .. "/" .. self:GetMaxStack())
end

function BASE:GetDescription()
    local stack = self:GetStack()
    local maxstack = self:GetMaxStack()

    return self:GetData("m_description", self.description) .. " Количество: " .. stack .. "/" .. maxstack
end

function BASE:GetMaxStack()
    return tonumber(self:GetData("m_maxstack", self.maxstack))
end

function BASE:GetStackDefault()
    return tonumber(self:GetData("m_stackdefault", self.stackdefault))
end

function BASE:GetStack()
    return tonumber(self:GetData("stack", self:GetStackDefault()))
end

function BASE:Stack(item)
    if self.base != item.base then return end
    if self:GetName() != item:GetName() then return end

    local itemStack = self:GetStack()
    local itemMaxStack = self:GetMaxStack()
    if itemStack >= itemMaxStack then return end

    local item2Stack = item:GetStack()

    local value = math.Clamp(itemStack + item2Stack, 1, self:GetMaxStack())
    self:SetData("stack", value)

    local added = value - itemStack
    local newItem2Stack = item2Stack - added
    if newItem2Stack <= 0 then
        item:Remove()
    else
        item:SetData("stack", newItem2Stack)
    end
end

function BASE:UnStack(value, inventory, x, y)
    local stack = self:GetStack()

    local item = ItemBase.CreateItem(self:GetUniqueID())
    if !item then return end

    local errNotify = item:Transfer(inventory:GetID(), x, y)
    if errNotify then return end

    self:SetData("stack", stack - value)
    item:SetData("stack", value)

    local data = ItemBase.data[self:GetID()]
    for k, v in pairs(data) do
        if string.Left(k, 2) == "m_" then
            item:SetData(k, v)
        end
    end
end

function BASE:UnStackValue()
    local stack = self:GetStack()

    return stack - 1
end

ItemBase:RegisterBase("base_stack", BASE)