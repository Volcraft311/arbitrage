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


function Container:LeftClick(data)
    if !data then return end

    local entity = data.entity
    if !IsValid(entity) then return end

    if entity:GetClass() == "arb_container" then return tostring(entity) .. " уже является контейнером!" end

    local container = ents.Create("arb_container")
    container:SetPos(entity:GetPos())
    container:SetAngles(entity:GetAngles())

    container:SetContainer(entity:GetModel(), data.name, data.w, data.h)
    entity:Remove()

    return "Вы успешно создали контейнер у " .. tostring(entity) .. "."
end

function Container:Reload(data)
    if !data then return end

    local entity = data.entity
    if !IsValid(entity) then return end

    if entity:GetClass() != "arb_container" then return tostring(entity) .. " не является контейнером!" end

    local name = tostring(entity)

    local prop = ents.Create("prop_physics")
    prop:SetPos(entity:GetPos())
    prop:SetAngles(entity:GetAngles())
    prop:SetModel(entity:GetModel())

    prop:Spawn()

    local physObj = prop:GetPhysicsObject()
    if IsValid(physObj) then
        physObj:EnableMotion(false)
        physObj:Wake()
    end

    entity:Remove()

    return "Вы успешно удалили контейнер из " .. name .. "."
end

function Container:PlayerUse(client, entity)
    local inventory = entity._containerInventory
    if !inventory then return end

    if entity:IsPlayer() then return end

    if !client.containerCD or CurTime() >= client.containerCD then
        client:PlayAnimation(GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_ITEM_PLACE, true)

        Arbitrage.action.ActionRun(client, "Обыскиваем", entity._containerTime or 1, function()
            if client:GetEyeTrace().Entity != entity then return true end
            if client:GetPos():Distance(entity:GetPos()) >= 200 then return true end

             return false
        end, function(activator)
            InventoryBase.Open(client, inventory:GetID(), entity._containerName)
        end)

        client.containerCD = CurTime() + 2
    end
end