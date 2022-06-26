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


function Container:LeftClick(data)
    if !data then return end

    local entity = data.entity
    if !IsValid(data.entity) then return end

    entity._containerName = data.name
    entity.Inventory = InventoryBase.CreateInventory(data.w, data.h)

    return "Вы успешно создали контейнер у " .. tostring(entity) .. "."
end

function Container:RightClick(data)
    if !data then return end

    local entity = data.entity
    if !IsValid(data.entity) then return end

    local inventory = entity.Inventory
    if inventory then
        entity.Inventory = nil
        return "Вы успешно удалили контейнер из " .. tostring(entity) .. "."
    end

    return tostring(entity) .. " не является контейнером!"
end

function Container:PlayerUse(client, entity)
    local inventory = entity.Inventory
    if !inventory then return end
    if entity:IsPlayer() then return end

    if !client.containerCD or CurTime() >= client.containerCD then
        Arbitrage.action.ActionRun(client, "Обыскиваем", 1, function()
            if client:GetPos():Distance(entity:GetPos()) >= 200 then return true end

            return false
        end, function(activator)
            InventoryBase.Open(client, inventory:GetID(), entity._containerName)
        end)
        client.containerCD = CurTime() + 2
    end
end