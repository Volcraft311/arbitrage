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
BASE.addstatuseffects = ""
BASE.removestatuseffects = ""

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
    },
    {
        variable = "addstatuseffects",
        title = "Какие статус эффекты будут выдаваться",
        default = ""
    },
    {
        variable = "removestatuseffects",
        title = "Какие статус эффекты будут удаляться",
        default = ""
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
    end},
    {"removestatuseffects", "Удаляются статус эффекты", function(a)
        return a:GetRemoveStatusEffects()
    end},
}

function BASE:Tooltip(tooltip)
    tooltip:SetTitle(self:GetName())
    tooltip:SetDescription(self:GetDescription())
    tooltip:SetIcon("asterion/academy/ui/tooltip/medical.png")
    tooltip:AddSubMenu("Осталось: " .. self:GetLeft() .. "/" .. self:GetMaxUse(), "err.png")
end

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

function BASE:GetAddStatusEffects()
    return self:GetData("m_addstatuseffects", self.addstatuseffects)
end

function BASE:GetRemoveStatusEffects()
    return self:GetData("m_removestatuseffects", self.removestatuseffects)
end

function BASE:GetDescription()
    local left = self:GetLeft()

    return self:GetData("m_description", self.description) .. " Осталось: " .. left .. "/" .. self:GetMaxUse()
end

local function RecoveryFunc(item, target)
    local client = item.player

    if !IsValid(target) or !target:IsPlayer() then return false, "Не валидный игрок!" end

    local text = "Использует '" .. item:GetName() .. "'"
    if target != client then
        text = text .. " на '" .. target:Name() .. "'"
    end
    for k, v in ipairs(ents.FindInSphere(client:GetPos(), ARBITRAGE_SAY_LENGTH * 0.5)) do
        TypingDraw:SetTypingText(v, client, text, Color(255, 170, 23))
    end

    local value = tonumber(item:GetSetHealth())
    if value > 0 then
        local delay = (target:GetTemporaryStatusEffectDelay("health") or CurTime()) - CurTime()
        delay = math.Clamp(delay + value, 0, 100)

        target:SetTemporaryStatusEffect("health", delay)
    elseif value < 0 then
        target:TakeDamage(-value)
    end

    local song = item:GetSound()
    if song and song != "" and song != " " then
        target:EmitSound(song)
    end

    local add_status_effects = item:GetAddStatusEffects()
    for name, delay in pairs(Medical:StringToObject(add_status_effects)) do
        local uniqueID = Medical:GetTemporaryStatusEffectsByName(name)
        if !uniqueID then continue end

        target:AddTemporaryStatusEffect(uniqueID, delay)
    end

    local remove_status_effects = item:GetRemoveStatusEffects()
    for _, name in ipairs(Medical:StringToTable(remove_status_effects)) do
        local uniqueID = Medical:GetTemporaryStatusEffectsByName(name)
        if !uniqueID then continue end

        target:RemoveTemporaryStatusEffect(uniqueID)
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