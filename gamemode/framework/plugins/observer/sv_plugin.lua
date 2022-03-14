--[[
        © Asterion Project 2021.
        This script was created from the developers of the AsterionTeam.
        You can get more information from one of the links below:
            Site - https://asterionproject.ru
            Discord - https://discord.gg/Cz3EQJ7WrF
        
        developer(s):
            Selenter - https://steamcommunity.com/id/selenter

        ——— Chop your own wood and it will warm you twice.
]]--

local PLUGIN = PLUGIN

function PLUGIN:CanPlayerEnterVehicle(client, vehicle, role)
    if client:IsNocliping() then
        return false
    end
end

function PLUGIN:PlayerNoClip(client, state)
    if client:IsSpectate() then return false end
    if !client:IsAdmin() then return false end
    if Arbitrage.lawEnable then return false end

    -- if state then
    --     hook.Run("PlayerEnterNoclip", client)
    -- else
    --     hook.Run("PlayerExitNoclip", client)
    -- end

    hook.Run(state and "PlayerEnterNoclip" or "PlayerExitNoclip", client)

    return true
end

function PLUGIN:PlayerEnterNoclip(client)
    -- client.observer_data = {
    --     position = client:GetPos(),
    --     angles = client:EyeAngles(),
    --     color = client:GetColor(),
    --     move_type = client:GetMoveType(),
    -- }

    client:SetNoDraw(true)
    client:SetNotSolid(true)
    client:DrawWorldModel(false)
    client:DrawShadow(false)
    client:GodEnable()
    client:SetNoTarget(true)
    --client:SetColor(Color(0, 0, 0, 0))

    client:SetNetVar("observer", true, client)
end

function PLUGIN:PlayerExitNoclip(client)
    --local data = client.observer_data

    --if data then
        client:SetNoDraw(false)
        client:SetNotSolid(false)
        client:DrawWorldModel(true)
        client:DrawShadow(true)
        client:GodDisable()
        client:SetNoTarget(false)
        --client:SetColor(data.color)
    --end

    client.observer_data = nil
    client:SetNetVar("observer", false, client)
end