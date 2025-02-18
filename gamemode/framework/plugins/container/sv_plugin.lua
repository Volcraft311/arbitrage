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

    if entity:GetClass() == "arb_container" then return tostring(entity) .. "#container_exist" end

    local container = ents.Create("arb_container")
    container:SetPos(entity:GetPos())
    container:SetAngles(entity:GetAngles())

    container:SetContainer(entity:GetModel(), data.name, data.description, data.w, data.h)
    entity:Remove()

    return "#container_created" .. tostring(entity) .. "."
end

function Container:Reload(data)
    if !data then return end

    local entity = data.entity
    if !IsValid(entity) then return end

    if entity:GetClass() != "arb_container" then return tostring(entity) .. "#container_none" end

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

    return "#container_deleted" .. name .. "."
end

function Container:PlayerUse(client, entity)
    local inventory = entity._containerInventory
    if !inventory then return end
    if entity:IsPlayer() then return end

    if !client.containerCD or CurTime() >= client.containerCD then
        local name = entity._containerName or ""
        TypingDraw:SendSphere(0.5, client, "#typingdraw_examines '" .. name .. "'", Color(255, 170, 23))

        Arbitrage.action.ActionRun(client, "#action_searching", entity._containerTime or 1, function()
            if client:GetEyeTrace().Entity != entity then return true end
            if client:GetPos():Distance(entity:GetPos()) >= 200 then return true end

            if (!client.RMSearch or CurTime() >= client.RMSearch) then
                client:PlayGesture(ACT_GMOD_GESTURE_ITEM_PLACE)
                client.RMSearch = CurTime() + 1.5
            end

             return false
        end, function(activator)
            InventoryBase.Open(client, inventory:GetID(), name)
        end)

        client.containerCD = CurTime() + 2
    end
end

netstream.Hook("Container:SetDescription", function(client, data)
    client.ContainerDescription = data or "#container_desc"
end)