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


function AdminNotify:SendNotify(notify, ...)
    if !self.notifyList[notify] then return end

    for k, v in ipairs(player.GetAdmins()) do
        netstream.Start(v, "ixAdminNotify", notify, ...)
    end
end


gameevent.Listen("player_connect")
hook("player_connect", function(data)
    local name = data.name
    local steamid = data.networkid

    AdminNotify:SendNotify("connect", name, steamid)
end)

hook("OnPlayerInitialize", function(client)
    AdminNotify:SendNotify("join", client:FullName(true))
end)

hook("PlayerDisconnected", function(client)
    AdminNotify:SendNotify("disconnect", client:FullName(true))
end)

hook("PlayerDeath", function(client, inflictor, attacker)
    local weapon = attacker:IsPlayer() and attacker:GetActiveWeapon()

    local attackerName = (IsValid(attacker) and attacker:IsPlayer()) and attacker:FullName() or attacker:GetClass()
    local targetName = client:FullName()
    local weaponName = IsValid(weapon) and weapon:GetClass()

    AdminNotify:SendNotify("killed", attackerName, targetName, weaponName)
end)

hook("PlayerSpawn", function(client)
    AdminNotify:SendNotify("spawn", client:FullName())
end)

hook("OnCharacterJoin", function(client, character)
    AdminNotify:SendNotify("joincharacter", client:FullName(), character:GetName() .. "(" .. character:GetID() .. ")")
end)