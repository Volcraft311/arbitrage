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


hook("CanPlayerEnterVehicle", function(client, vehicle, role)
    if client:IsNocliping() then
        return false
    end
end)

hook("PlayerEnterNoclip", function(client)
    client:DrawHide()
    client:GodEnable()
    client:SetNoTarget(true)

    client:SetLocalVar("observer", true)

    hook.Run("OnObServerEnter", client)
end)

hook("PlayerExitNoclip", function(client)
    client:DrawUnHide()
    client:GodDisable()
    client:SetNoTarget(false)

    client:SetLocalVar("observer", nil)

    hook.Run("OnObServerExit", client)
end)