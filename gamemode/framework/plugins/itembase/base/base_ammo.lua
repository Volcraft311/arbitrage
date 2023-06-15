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


local BASE = ItemBase.GetBase()

BASE.name = "База Патронов"
BASE.description = ""
BASE.category = "Патроны"
BASE.ammoClass = "pistol"
BASE.ammoAmount = 10

BASE.creationExample = {
    {
        variable = "category",
        title = "Категория",
        default = "Патроны"
    },
    {
        variable = "ammoClass",
        title = "Тип патронов",
        default = "pistol"
    },
    {
        variable = "ammoAmount",
        title = "Количество патронов",
        default = 10
    }
}

BASE.propertiesInfo = {
    {"ammoClass", "Класс патронов", function(a)
        return a:GetAmmoClass()
    end},
    {"amount", "Находится патронов", function(a)
        return a:GetAmount()
    end, function(a, b, c)
        a:SetData("amount", tonumber(c))
        a:SetData("m_amount", nil)
    end}
}

if CLIENT then
    function BASE:Paint(item, w, h)
        if !item:GetData("equip") then
            local amount = item:GetAmount()

            draw.SimpleTextOutlined(amount, "DermaDefault", w - 5, h - 15, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, color_black)
        end
    end
end

function BASE:GetAmmoClass()
    return self:GetData("m_ammoClass", self.ammoClass)
end

function BASE:GetAmmoAmount()
    return self:GetData("m_ammoAmount", self.ammoAmount)
end

function BASE:GetAmount()
    return self:GetData("amount", tonumber(self:GetAmmoAmount()))
end

function BASE:GetDescription()
    local amount = self:GetAmount()

    return self:GetData("m_description", self.description) .. " Количество патрон: " .. amount .. "."
end

function BASE:Stack(item)
    if item.base != item.base then return end

    local itemClass = self:GetAmmoClass()
    local item2Class = item:GetAmmoClass()
    if itemClass != item2Class then return end

    local itemAmount = self:GetAmount()
    local item2Amount = item:GetAmount()

    item:Remove()
    self:SetData("amount", itemAmount + item2Amount)
end

function BASE:UnStack(value, inventory, x, y)
    local amount = self:GetAmount()

    local item = ItemBase.CreateItem(self:GetUniqueID())
    if !item then return end

    local errNotify = item:Transfer(inventory:GetID(), x, y)
    if errNotify then return end

    self:SetData("amount", amount - value)
    item:SetData("amount", value)

    local data = ItemBase.data[self:GetID()]
    for k, v in pairs(data) do
        if string.Left(k, 2) == "m_" then
            item:SetData(k, v)
        end
    end
end

function BASE:UnStackValue()
    local amount = self:GetAmount()

    return amount - 1
end

BASE:AddAction("Использовать", {
    icon = "icon16/tick.png",
    OnRun = function(item)
    	local client = item.player
        local ammoClass = item:GetAmmoClass()
        local ammoAmount = tonumber(item:GetAmount())

        client:GiveAmmo(ammoAmount, ammoClass)

        for k, v in pairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.5)) do
            TypingDraw:SetTypingText(v, client, "Использует '" .. item:GetName() .. "'", Color(255, 170, 23))
        end
    end,
    OnCanRun = function(item)
        return true
    end
})

ItemBase:RegisterBase("base_ammo", BASE)