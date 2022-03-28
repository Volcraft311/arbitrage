--[[
        © Asterion Project 2022.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local PLUGIN = PLUGIN

function PLUGIN:SetEntityInteraction(entity, data)
    entity.Interaction = data

    return "Взаимодействие успешна была присвоино " .. tostring(entity) .. "."
end

function PLUGIN:DeleteEntityInteraction(entity)
    if !entity:IsInteraction() then return end
    entity.Interaction = nil

    return "Взаимодействие успешна было удалена с " .. tostring(entity) .. "."
end

function PLUGIN:IsEntityInteraction(entity)
    return entity.Interaction and true or false
end

function PLUGIN:OpenInteraction(client, data)
    if !NetGUI then return end

    NetGUI:Create(client, "arb.InteractionMenu", nil, "OpenData", data)
end


function PLUGIN:LeftClick(client, data, entity)
    local info = entity:SetInteraction(data)
    if info and IsValid(client) then
        client:ChatPrint(info)
    end
end

function PLUGIN:RightClick(data)
    if !data then return end
    if !IsValid(data.entity) then return "Не валидное Entity!" end

    return data.entity:DeleteInteraction()
end


local ENTITY = FindMetaTable("Entity")

function ENTITY:SetInteraction(data)
    return PLUGIN:SetEntityInteraction(self, data)
end

function ENTITY:DeleteInteraction()
    return PLUGIN:DeleteEntityInteraction(self)
end

function ENTITY:IsInteraction()
    return PLUGIN:IsEntityInteraction(self)
end


function PLUGIN:PlayerUse(client, entity)
    if !entity:IsInteraction() then return end
    if entity:IsPlayer() then return end

    if !client.interactionCD or CurTime() >= client.interactionCD then
        local data = entity.Interaction

        self:OpenInteraction(client, data)

        client.interactionCD = CurTime() + 2
    end
end


netstream.Hook("Interaction:LeftClick", function(client, data, entity)
    if !PLUGIN:IsUsesTool(client) then return client:ChatPrint("Вы не используете Interaction Tool!") end
    if !IsValid(entity) then return client:ChatPrint("Не валидное Entity!") end

    PLUGIN:LeftClick(client, data, entity)
end)