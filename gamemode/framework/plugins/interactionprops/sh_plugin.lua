local PLUGIN = PLUGIN
Interaction = PLUGIN

PLUGIN.name = "Interaction Props"

function PLUGIN:IsUsesTool(client)
    if !IsValid(client) then return false end

    local weapon = client:GetActiveWeapon()
    if !IsValid(weapon) then return false end

    local class = weapon:GetClass()
    if class != "gmod_tool" then return false end

    local tool = client:GetTool() and client:GetTool().Name or nil
    if tool != "Interaction Tool" then return false end

    return true
end

function PLUGIN:GetToolData(client)
    if !self:IsUsesTool(client) then return end

    local trace = client:GetEyeTrace()
    local entity = trace.Entity

    local tool = client:GetTool()

    -- local evidenceName = tool:GetClientInfo("name")
    -- local evidenceDescription = tool:GetClientInfo("description")
    -- local evidenceR = tool:GetClientInfo("r")
    -- local evidenceG = tool:GetClientInfo("g")
    -- local evidenceB = tool:GetClientInfo("b")
    -- local evidenceAlpha = tool:GetClientInfo("alpha")
    -- local evidenceIcon = tool:GetClientInfo("icon")

    -- if IsValid(entity) and !entity:IsPlayer() and !entity:IsWorld() then
    --     -- eh...
    -- else
    --     entity = NULL
    -- end

    -- local data = {
    --     name = evidenceName,
    --     description = evidenceDescription,
    --     entity = entity,
    --     color = Color(evidenceR, evidenceG, evidenceB),
    --     alpha = evidenceAlpha,
    --     position = position + angles:Up() * 0.5,
    --     image = evidenceIcon,
    --     angles = angles,
    -- }

    local interactionUrl = tool:GetClientInfo("url")

    local data = {
        entity = entity,
        url = interactionUrl
    }

    return data
end

Arbitrage.base.Include("sv_plugin.lua")