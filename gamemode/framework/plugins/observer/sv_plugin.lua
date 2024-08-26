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

function PLUGIN:CanPlayerEnterVehicle(client, vehicle, role)
    if client:IsNocliping() then
        return false
    end
end

function PLUGIN:PlayerNoClip(client, state)
    if client:IsSpectate() then return false end
    if !client:IsAdmin() then return false end
    if Arbitrage.lawEnable then return false end

    hook.Run(state and "PlayerEnterNoclip" or "PlayerExitNoclip", client)

    return true
end

function PLUGIN:PlayerEnterNoclip(client)
    client:DrawHide()
    client:GodEnable()
    client:SetNoTarget(true)

    client:SetLocalVar("observer", true)
end

function PLUGIN:PlayerExitNoclip(client)
    client:DrawUnHide()
    client:GodDisable()
    client:SetNoTarget(false)

    client.observer_data = nil
    client:SetLocalVar("observer", nil)
end