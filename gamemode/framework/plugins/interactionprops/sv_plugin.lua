local PLUGIN = PLUGIN

function PLUGIN:SetEntityInteraction(entity, url)
    entity.InteractionURL = url

    return "Картинка " .. url .. " успешна была присвоина " .. tostring(entity) .. "."
end

function PLUGIN:DeleteEntityInteraction(entity)
    if !entity:IsInteraction() then return end

    local url = entity.InteractionURL

    entity.InteractionURL = nil

    return "Картинка " .. url .. " успешна была удалена с " .. tostring(entity) .. "."
end

function PLUGIN:IsEntityInteraction(entity)
    return entity.InteractionURL and true or false
end

function PLUGIN:OpenInteraction(client, url)
    if !NetGUI then return end

    NetGUI:Create(client, "arb.InteractionMenu", nil, "OpenURL", url)
end


function PLUGIN:LeftClick(data)
    if !data then return end
    if !IsValid(data.entity) then return "Не валидное Entity!" end

    return data.entity:SetInteraction(data.url)
end

function PLUGIN:RightClick(data)
    if !data then return end
    if !IsValid(data.entity) then return "Не валидное Entity!" end

    return data.entity:DeleteInteraction()
end


local ENTITY = FindMetaTable("Entity")

function ENTITY:SetInteraction(url)
    return PLUGIN:SetEntityInteraction(self, url)
end

function ENTITY:DeleteInteraction(url)
    return PLUGIN:DeleteEntityInteraction(self)
end

function ENTITY:IsInteraction()
    return PLUGIN:IsEntityInteraction(self)
end


function PLUGIN:PlayerUse(client, entity)
    if !entity:IsInteraction() then return end
    if entity:IsPlayer() then return end

    if !client.interactionCD or CurTime() >= client.interactionCD then
        local url = entity.InteractionURL

        self:OpenInteraction(client, url)

        client.interactionCD = CurTime() + 2
    end
end