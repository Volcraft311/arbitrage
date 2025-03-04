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


local PLUGIN = PLUGIN

function PLUGIN:SetEntityInteraction(entity, data)
    entity.Interaction = data

    return "#tool_interaction_interact_set_entity " .. tostring(entity) .. "."
end

function PLUGIN:DeleteEntityInteraction(entity)
    if !entity:IsInteraction() then return end
    entity.Interaction = nil

    return "#tool_interaction_interact_remove_entity " .. tostring(entity) .. "."
end

function PLUGIN:IsEntityInteraction(entity)
    return entity.Interaction and true or false
end

function PLUGIN:OpenInteraction(client, data)
    asterionlib.netgui:Create(client, "arb.InteractionMenu", nil, "OpenData", data)
end


function PLUGIN:LeftClick(client, data, entity)
    local info = entity:SetInteraction(data)
    if info and IsValid(client) then
        client:ChatNotify(info)
    end
end

function PLUGIN:RightClick(data)
    if !data then return end
    if !IsValid(data.entity) then return "#notify_not_valid_entity" end

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
    if !client:IsUsesTool("Interaction Tool") then return client:ChatNotify("#tool_interaction_not_use_tool") end
    if !IsValid(entity) then return client:ChatNotify("#notify_not_valid_entity") end

    PLUGIN:LeftClick(client, data, entity)
end)