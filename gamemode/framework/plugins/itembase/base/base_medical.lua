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

BASE.name = "База Медикаметров"
BASE.description = ""
BASE.category = "Медикаменты"
BASE.health = 50
BASE.maxuse = 1
BASE.sound = "items/medshot4.wav"

BASE.creationExample = {
    {
        variable = "category",
        title = "Категория",
        default = "Медикаменты"
    },
    {
        variable = "health",
        title = "Количество восстанавливающего здоровья",
        default = 50
    },
    {
        variable = "maxuse",
        title = "Максимальное количество использований",
        default = 1
    },
    {
        variable = "sound",
        title = "Звук при использовании",
        default = "items/medshot4.wav"
    }
}

function BASE:GetDescription()
    local left = self:GetData("left", tonumber(self.maxuse))

    return self.description .. ". Осталось: " .. left .. "/" .. self.maxuse .. ""
end

local function RecoveryFunc(item, target)
    if !IsValid(target) or !target:IsPlayer() then return false, "Не валидный игрок!" end

    local song = item.sound
    if song and song != "" and song != " " then
        target:EmitSound(song)
    end

    target:SetHealth(math.min(target:Health() + tonumber(item.health), target:GetMaxHealth()))

    if target:Health() <= 0 then
        target:Kill()
    end

    local left = item:GetData("left", tonumber(item.maxuse))
    item:SetData("left", left - 1)
    if (left - 1) <= 0 then return true end
end

BASE:AddAction("Использовать на себе", {
    OnRun = function(item)
        local client = item.player

        local st, msg = RecoveryFunc(item, item.player)
        if st == true then return
        elseif st == false and msg then
            Arbitrage.commands.Notify(client, msg)
        end

        return false
    end,
    OnCanRun = function(item)
        return true
    end
})

BASE:AddAction("Использовать на другом игроке", {
    OnRun = function(item)
        local client = item.player

        local target = client:GetEyeTrace().Entity

        local st, msg = RecoveryFunc(item, target)
        if st == true then return
        elseif st == false and msg then
            Arbitrage.commands.Notify(client, msg)
        end

        return false
    end,
    OnCanRun = function(item)
        return true
    end
})

ItemBase:RegisterBase("base_medical", BASE)