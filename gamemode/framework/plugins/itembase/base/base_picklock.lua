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

BASE.name = "База Отмычек"
BASE.description = ""
BASE.category = "Отмычки"
BASE.maxuse = 2
BASE.hacktime = 20

BASE.creationExample = {
    {
        variable = "category",
        title = "Категория",
        default = "Отмычки"
    },
    {
        variable = "maxuse",
        title = "Максимальное количество использований",
        default = 2
    },
    {
        variable = "hacktime",
        title = "Время взлома",
        default = 20
    }
}

BASE.propertiesInfo = {
    {"maxuse", "Максимум использований", function(a)
        return a:GetMaxUse()
    end},
    {"left", "Осталось использований", function(a)
        return a:GetLeft()
    end, function(a, b, c)
        a:SetData("left", tonumber(c))
        a:SetData("m_left", nil)
    end},
    {"hacktime", "Время для взлома", function(a)
        return a:GetHackTime()
    end}
}

function BASE:Tooltip(tooltip)
    tooltip:SetTitle(self:GetName())
    tooltip:SetDescription(self:GetDescription())
    tooltip:SetIcon("asterion/academy/ui/tooltip/key.png")
    tooltip:AddSubMenu("Осталось: " .. self:GetLeft() .. "/" .. self:GetMaxUse())
end

function BASE:GetMaxUse()
    return self:GetData("m_maxuse", self.maxuse)
end

function BASE:GetLeft()
    return self:GetData("left", tonumber(self:GetMaxUse()))
end

function BASE:GetHackTime()
    return self:GetData("m_hacktime", self.hacktime)
end

function BASE:GetDescription()
    local left = self:GetLeft()

    return self:GetData("m_description", self.description) .. " Осталось: " .. left .. "/" .. self:GetMaxUse()
end

local function FindDoor(client)
    local trace = client:GetEyeTrace()

    local entity = trace.Entity
    if !IsValid(entity) then return end

    if !entity:IsDoor() then return end
    if entity:GetNWBool("disableHack") then return end

    return entity
end

local function HackDoor(client, entity, time)
    Arbitrage.action.ActionRun(client, "#action_breaking_door", time, function()
        if client:GetEyeTrace().Entity != entity then return true end
        if client:GetPos():Distance(entity:GetPos()) >= 130 then return true end

        if !client.keyAnim or CurTime() >= client.keyAnim then
            client:PlayGesture(ACT_GMOD_GESTURE_ITEM_PLACE)
            client.keyAnim = CurTime() + 2.1

            TypingDraw:SendSphere(0.5, client, "#typingdraw_break_door", Color(255, 170, 23))
        end

        return false
    end, function(activator)
        entity:Fire("UnLock")
        entity:Fire("Open")
        entity:SetNWBool("Locked", false)

        client:EmitSound("doors/door_latch3.wav")
    end)
end

BASE:AddAction("Взломать дверь", {
    icon = "icon16/attach.png",
    OnRun = function(item)
        local client = item.player
        local entity = FindDoor(client)
        if !IsValid(entity) then
            Arbitrage.commands.Notify(client, "#picklock_not_allow")
            return false
        end

        local left = item:GetLeft()
        item:SetData("left", left - 1)

        HackDoor(client, entity, tonumber(item:GetHackTime()))

        if left > 1 then
            return false
        end
    end
})


ItemBase:RegisterBase("base_picklock", BASE)