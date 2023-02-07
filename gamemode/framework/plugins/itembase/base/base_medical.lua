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

BASE.name = "База Медикаметров"
BASE.description = ""
BASE.category = "Медикаменты"
BASE.sethealth = 50
BASE.maxuse = 1
BASE.sound = "items/medshot4.wav"

BASE.creationExample = {
    {
        variable = "category",
        title = "Категория",
        default = "Медикаменты"
    },
    {
        variable = "sethealth",
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

BASE.propertiesInfo = {
    {"sethealth", "Восстанавливает здоровье", function(a)
        return a:GetSetHealth()
    end},
    {"maxuse", "Максимум использований", function(a)
        return a:GetMaxUse()
    end},
    {"left", "Осталось использований", function(a)
        return a:GetLeft()
    end, function(a, b, c)
        a:SetData("left", tonumber(c))
        a:SetData("m_left", nil)
    end},
    {"sound", "Звук при использовании", function(a)
        return a:GetSound()
    end}
}

function BASE:GetSetHealth()
    return self:GetData("m_sethealth", self.sethealth)
end

function BASE:GetMaxUse()
    return self:GetData("m_maxuse", self.maxuse)
end

function BASE:GetLeft()
    return self:GetData("left", tonumber(self:GetMaxUse()))
end

function BASE:GetSound()
    return self:GetData("m_sound", self.sound)
end

function BASE:GetDescription()
    local left = self:GetLeft()

    return self:GetData("m_description", self.description) .. " Осталось: " .. left .. "/" .. self:GetMaxUse() .. ""
end

local function RecoveryFunc(item, target)
    if !IsValid(target) or !target:IsPlayer() then return false, "Не валидный игрок!" end

    local song = item:GetSound()
    if song and song != "" and song != " " then
        target:EmitSound(song)
    end

    target:SetHealth(math.min(target:Health() + tonumber(item:GetSetHealth()), target:GetMaxHealth()))

    if target:Health() <= 0 then
        target:Kill()
    end

    local left = item:GetLeft()
    item:SetData("left", left - 1)
    if (left - 1) <= 0 then return true end
end

BASE:AddAction("Использовать", {
    icon = "icon16/heart.png",
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

local function findTarget(client)
    local data = {}
    data.start = client:GetShootPos()
    data.endpos = data.start + client:GetAimVector() * 84
    data.filter = {client}

    local trace = util.TraceLine(data)
    local entity = trace.Entity

    if IsValid(entity) and entity:IsPlayer() then
        return entity
    end
end

BASE:AddAction("Использовать на другом игроке", {
    icon = "icon16/feed.png",
    OnRun = function(item)
        local client = item.player

        local target = findTarget(client)
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