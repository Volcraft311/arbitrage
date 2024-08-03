--[[
        © AsterionStaff 2024.
        This script was created from the developers of the Asterion Staff.
        You can get more information from one of the links below:
            Site - https://asterion.games
            Discord - https://discord.gg/Np5evb5ZsR
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--


local light_mat = Material("effects/flashlight001")

function Flashlight:RemovePlayerFlashlight(client)
    if !IsValid(client) then return end

    if IsValid(client.shared_flashlight) then
        client.shared_flashlight:Remove()
    end

    client.shared_flashlight = nil
    client.shared_flashlight_on = false

    client:SetLocalVar("sharedflashlight", nil)
end

function Flashlight:CreateFlashlightTimer(entity, client)
    local timerID = "SharedFlashlight:Updater_" .. entity:EntIndex() .. client:EntIndex()
    timer.Create(timerID, 0.1, 0, function()
        if !IsValid(entity) then return timer.Remove(timerID) end
        if !IsValid(client) then return timer.Remove(timerID) end

        entity:SetPos(client:EyePos() + client:EyeAngles():Forward() * 15)
        entity:SetAngles(client:EyeAngles())
    end)
end

function Flashlight:Active(client)
    local enabled = !client.shared_flashlight_on

    if !enabled then
        self:RemovePlayerFlashlight(client)
    else
        local entity = ents.Create("env_projectedtexture")
        entity:SetPos(client:EyePos() + client:EyeAngles():Forward() * 15)
        entity:SetAngles(client:EyeAngles())

        entity:SetKeyValue("enableshadows", 0)
        entity:SetKeyValue("nearz", 12 * 1.2)
        entity:SetKeyValue("lightfov", 35 * 1.75)
        entity:SetKeyValue("farz", 1024 * 1.2)
        entity:SetKeyValue("lightcolor", "255 255 255 255")

        entity:Spawn()

        entity:Input("SpotlightTexture", NULL, NULL, light_mat:GetString("$basetexture"))

        self:CreateFlashlightTimer(entity, client)
        client:SetLocalVar("sharedflashlight", entity:EntIndex())

        client.shared_flashlight = entity
    end

    client.shared_flashlight_on = enabled

    client:EmitSound("items/flashlight1.wav")
end

function Flashlight:PlayerSwitchFlashlight(client)
    return false
end

function Flashlight:PlayerInitialSpawn(client)
    client:Flashlight(false)
    self:RemovePlayerFlashlight(client)
end

function Flashlight:PlayerDisconnected(client)
    self:RemovePlayerFlashlight(client)
end