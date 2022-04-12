local BASE = ItemBase.GetBase()

BASE.name = "База Медикаметров"
BASE.description = ""
BASE.category = "Медикаменты"
BASE.health = 50
BASE.maxuse = 1
BASE.sound = "items/medshot4.wav"

function BASE:GetDescription()
    local left = self:GetData("left", self.maxuse)

    return self.description .. ". Осталось: " .. left .. "/" .. self.maxuse .. ""
end

local function RecoveryFunc(item, target)
    if !IsValid(target) and !target:IsPlayer() then return false, "Не валидный игрок!" end

    local song = item.sound
    if song and song != "" and song != " " then
        target:EmitSound(song)
    end

    target:SetHealth(math.min(target:Health() + item.health, target:GetMaxHealth()))

    local left = item:GetData("left", item.maxuse)
    item:SetData("left", left - 1)
    if (left - 1) <= 0 then return true end
end

BASE:AddAction("Использовать на себе", {
    icon = "icon16/world.png",
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
    icon = "icon16/world.png",
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