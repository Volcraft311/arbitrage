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


local BASE = ItemBase.GetBase()

BASE.name = "База Еды"
BASE.description = ""
BASE.category = "Продукты"
BASE.maxuse = 10
BASE.thirst = 10
BASE.hunger = 10
BASE.sleep = 10
BASE.sound = "garrysmod/ui_click.wav"

BASE.creationExample = {
    {
        variable = "category",
        title = "Категория",
        default = "Продукты"
    },
    {
        variable = "maxuse",
        title = "Максимальное количество использований",
        default = 10
    },
    {
        variable = "thirst",
        title = "Пополнение жажды",
        default = 10
    },
    {
        variable = "hunger",
        title = "Пополнение голода",
        default = 10
    },
    {
        variable = "sleep",
        title = "Пополнение сна",
        default = 10
    },
    {
        variable = "sound",
        title = "Звук при использовании",
        default = "garrysmod/ui_click.wav"
    }
}

function BASE:GetDescription()
    local left = self:GetData("left", tonumber(self.maxuse))

    return self.description .. ". Осталось: " .. left .. "/" .. self.maxuse .. ""
end

local function RecoveryFunc(item, bAll)
    local client = item.player
    local left = item:GetData("left", tonumber(item.maxuse))

    local data = {"Thirst", "Hunger", "Sleep"}
    for k, v in ipairs(data) do
        local info = Arbitrage.statistics.Get(client, v)
        local amount = tonumber(item[string.lower(v)])
        if !amount then continue end
        if amount == 0 then continue end

        Arbitrage.statistics.Set(client, v, math.Clamp(info + (amount * (bAll and left or 1)), 0, 100))
    end

    local health = client:Health()
    if health > 0 and health < 100 then
        local addHealth = 2 * (bAll and left or 1)

        client:SetHealth(math.Clamp(health + addHealth, 0, 100))
    end

    local song = item.sound
    if song and song != "" and song != " " then
        client:EmitSound(song)
    end
end

BASE:AddAction("Использовать", {
    OnRun = function(item)
        RecoveryFunc(item)

        local left = item:GetData("left", tonumber(item.maxuse))
        item:SetData("left", left - 1)
        if (left - 1) <= 0 then return end

        return false
    end,
    OnCanRun = function(item)
        return true
    end
})

BASE:AddAction("Использовать все", {
    OnRun = function(item)
        RecoveryFunc(item, true)
    end,
    OnCanRun = function(item)
        local left = item:GetData("left", tonumber(item.maxuse))

        return left > 1
    end
})

ItemBase:RegisterBase("base_food", BASE)