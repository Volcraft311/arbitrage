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

BASE.name = "База Отмычек"
BASE.description = ""
BASE.category = "Отмычки"
BASE.maxuse = 2
BASE.hacktime = 20

function BASE:GetDescription()
    local left = self:GetData("left", self.maxuse)

    return self.description .. ". Осталось: " .. left .. "/" .. self.maxuse .. ""
end

local function FindDoor(client)
    local trace = client:GetEyeTrace()

    local entity = trace.Entity
    if !IsValid(entity) then return end

    if !entity:IsDoor() then return end

    return entity
end

local function HackDoor(client, entity, time)
    Arbitrage.action.ActionRun(client, "Взламываем дверь", time, function()
        if client:GetEyeTrace().Entity != entity then return true end
        if client:GetPos():Distance(entity:GetPos()) >= 130 then return true end

        if !client.keyAnim or CurTime() >= client.keyAnim then
            netstream.Start(nil, "arb.PlayerSetAnim", client, GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_ITEM_PLACE, true)

            client.keyAnim = CurTime() + 2.1
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
    OnRun = function(item)
        local client = item.player
        local entity = FindDoor(client)
        if !IsValid(entity) then
            Arbitrage.commands.Notify(client, "Это нельзя взломать!")
            return false
        end

        local left = item:GetData("left", item.maxuse)
        item:SetData("left", left - 1)

        HackDoor(client, entity, item.hacktime)

        if left > 1 then
            return false
        end
    end
})


ItemBase:RegisterBase("base_picklock", BASE)