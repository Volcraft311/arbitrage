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
    entity:Remove()

    return "Вы успешно удалили контейнер из " .. name .. "."
end