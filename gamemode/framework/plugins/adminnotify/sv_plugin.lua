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

function PLUGIN:SendNotify(notify, ...)
    if !self.notifyList[notify] then return end

    for k, v in pairs(player.GetAll()) do
        if self:HasAccess(v) then
            netstream.Start(v, "ixAdminNotify", notify, ...)
        end
    end
end

gameevent.Listen("player_connect")
function PLUGIN:player_connect(data)
    local name = data.name
    local steamid = data.networkid

    self:SendNotify("connect", name, steamid)
end

function PLUGIN:PlayerInitial(client)
    self:SendNotify("join", client:FullName(true))
end

function PLUGIN:PlayerDisconnected(client)
    self:SendNotify("disconnect", client:FullName(true))
end

function PLUGIN:PlayerDeath(client, inflictor, attacker)
    local weapon = attacker:IsPlayer() and attacker:GetActiveWeapon()

    local attackerName = (IsValid(attacker) and attacker:IsPlayer()) and attacker:FullName() or attacker:GetClass()
    local targetName = client:FullName()
    local weaponName = IsValid(weapon) and weapon:GetClass()

    self:SendNotify("killed", attackerName, targetName, weaponName)
end

function PLUGIN:PlayerSpawn(client)
    self:SendNotify("spawn", client:FullName())
end

function PLUGIN:SelectCharacter(client, data)
    local factionData = Character.team:GetByID(data)
    local faction = factionData and factionData:GetName() or "НЕИЗВЕСТНО"

    self:SendNotify("joincharacter", client:FullName(), faction .. "(" .. data .. ")")
end